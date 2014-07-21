function O = teg_repeated_measures_ANOVA(varargin)

% function O = teg_repeated_measures_ANOVA(M, levels, varnames[, Betw_cont, Betw_labels, plots, fname])
%
% M is observation x variable-combination matrix.
% levels is vector of levels per factor.
% varnames is a cell array of strings.
%
% Thomas E. Gladwin (2010).

betw_subj_interaction_depth = 1;
pCritForFurther = 1; % 0.05;
only_show_FDR = 0;
verbose0 = 0;
plots0 = [];
fdr_crit = 0.05;
digprec = 2; % digital precision of printouts.

M = varargin{1};
levels = varargin{2};
if size(M, 2) > prod(levels), % Number of observations per cell added
    b = size(M, 2) / 2;
    NM = M(:, (b + 1):end);
    M = M(:, 1:b);
else
    NM = ones(size(M));
end;
[nSubj, nVar] = size(M);
% Remove and store subject effects.
% Take different cell counts into account here.
subjEffect = [];
for iSubj = 1:size(M, 1),
    fNonNaN = ~isnan(M(iSubj, :));
    subjEffect(iSubj, 1) = sum(M(iSubj, fNonNaN) .* NM(iSubj, fNonNaN), 2) ./ sum(NM(iSubj, fNonNaN));
end;
M_subj = subjEffect * ones(1, size(M, 2));
M_raw = M;
M = M - M_subj;

varnames = varargin{3};
if isempty(varnames),
    varnames = cellstr(num2str((1:length(levels))'));
end;

if length(varargin) > 6,
    fname = varargin{7};
    if exist([fname '.ps']),
        delete([fname '.ps']);
    end;
else
    fname = [];
end;

if length(varargin) > 3,
    contvar = varargin{4};
    contvar0 = contvar;
    Betw_varnames = varargin{5};
    if ~isempty(Betw_varnames),
        [Betw, Betw_labels, Betw_vars_involved] = teg_make_betw_cont(contvar, Betw_varnames, betw_subj_interaction_depth);
        contvar = contvar - ones(size(contvar, 1), 1) * mean(contvar);
        contvar = {};
        % Test between effects of subject scores.
        for iVar = 1:size(Betw, 2),
            Xtmp = [Betw(:, iVar) ones(nSubj, 1)];
            [b, F, df1, df2, p] = teg_regression(Xtmp, subjEffect, 0);
            if p < pCritForFurther,
                fprintf([fname '\t' Betw_labels{iVar} ':']);
                fprintf(['\tF(' num2str(df1, digprec) ', ' num2str(df2, digprec) ') = ' num2str(F, digprec) ', p = ' num2str(p, digprec)]);
                fprintf([' * \tb = ' num2str(b(1)) '\t']);
                fprintf('\n');
            end;
            contvar1{iVar} = Betw(:, iVar);
            contvarM = [];
            for iVarM = 1:nVar,
                contvarM = [contvarM Betw(:, iVar)];
            end;
            contvar{iVar} = contvarM(:);
        end;
    else,
        contvar = {};
    end;
else
    contvar = {};
end;

if length(varargin) > 5,
    plots = varargin{6};
else
    plots = 0;
end;
if ~isempty(plots0),
    plots = plots0;
end;

% Get dummy-style matrices.
[X1, factorStarts, nColsFactor, labels, cellsets, factors] = teg_create_ANOVA_dummy(levels, varnames);
y = [];
y_raw = [];
yN = [];
X = [];
for iVar = 1:nVar,
    y = [y; M(:, iVar)];
    y_raw = [y_raw; M_raw(:, iVar)];
    yN = [yN; NM(:, iVar)];
    Xsub = ones(nSubj, 1) * X1(iVar, :);
    X = [X; Xsub];
end;

for FDR_loop = 1:2,
O = [];
for iPred = 4:length(factorStarts),
    predcols = factorStarts(iPred):(factorStarts(iPred) + nColsFactor(iPred) - 1);
    X0 = X(:, predcols);

    [y_red, pred_red, thisset] = teg_inner_recode(y, yN, nSubj, X0);
    y_red_M = teg_inner_recode_raw(M_raw, NM, cellsets, iPred);

    [F, df1, df2, p, MSM, MSE] = teg_RMF(y_red, nSubj, levels(factors{iPred}));
    
    O = [O; F df1 df2 p MSM MSE];

    % Between-continuous
    for iBetwCont = 1:length(contvar),
        if iBetwCont > size(contvar0, 2),
            recursestr = '';
        else,
            recursestr = ' '; % No recurse
        end;
        [y_raw_cell_obs_0, O] = teg_contvar_subfunction(contvar, thisset, y, cellsets, iPred, M_raw, nSubj, nColsFactor, X0, iBetwCont, ...
            contvar1, O, pCritForFurther, plots, labels, Betw_labels, fname, factorStarts, recursestr, Betw_vars_involved, verbose0, [], [], yN, NM);
    end;
    close(gcf);
end;

pvec = O(:, 4);
[f_fdr, p_fdr] = teg_do_fdr(pvec, fdr_crit);
fprintf(['FDR p value = ' num2str(p_fdr) ', ' num2str(length(f_fdr)) ' FDR significant test(s) found.\n']);

if only_show_FDR == 1,
    pCritForFurther = p_fdr;
end;

curr_test = 1;
currplot = 1;
for iPred = 1:length(factorStarts),
    predcols = factorStarts(iPred):(factorStarts(iPred) + nColsFactor(iPred) - 1);
    X0 = X(:, predcols);
    
    [y_red, pred_red, thisset] = teg_inner_recode(y, yN, nSubj, X0);
    y_red_M = teg_inner_recode_raw(M_raw, NM, cellsets, iPred);
    
    [F, df1, df2, p, MSM, MSE] = teg_RMF(y_red, nSubj, levels(factors{iPred}));

    if p <= pCritForFurther,
        resstr = [fname '\t' labels{iPred} ': F(' num2str(df1, digprec) ', ' num2str(df2, digprec) ') = ' num2str(F, digprec) ', p = ' num2str(p, digprec)];
        resstr = [resstr '. MSM = ' num2str(MSM) ', MSE = ' num2str(MSE)];
        fprintf([resstr]);
        if p <= p_fdr,
            fprintf(' *** ');
        elseif p < 0.05,
            fprintf(' * ');
        end;
        if verbose0 > 0,
            fprintf('\n\ty_cells: ');
            myr = mean(y_red_M);
            y_red_Mw = y_red_M - mean(y_red_M, 2) * ones(1, size(y_red_M, 2));
            seyr = var(y_red_Mw) .^ 0.5 / sqrt(size(y_red_M, 1));
            for ib = 1:length(myr),
                fprintf([num2str(myr(ib))]);
                if ib < length(myr),
                    fprintf(', ');
                end;
            end;
            fprintf('.\n\tb: ');
            fprintf(['\teps = ' num2str(eps0) '\n']);
            if length(myr) > 2,
                % Paired t-tests
                fprintf('\tPost-hoc differences:\n');
                for col1 = 1:size(y_red_M, 2),
                    for col2 = 1:(col1 - 1),
                        vec = y_red_M(:, col1) - y_red_M(:, col2);
                        [p, t, df] = teg_ttest(vec);
                        if p < 0.05,
                            tresstr = [num2str(col1) ' - ' num2str(col2) ': t(' num2str(df) ') = ' num2str(t) ', p = ' num2str(p)];
                            fprintf(['\t\t' tresstr '\n']);
                        end;
                    end;
                end;
                % vs 0
                fprintf('\tPost-hoc test vs 0:\n');
                for col1 = 1:size(y_red_M, 2),
                    vec = y_red_Mw(:, col1);
                    [p, t, df] = teg_ttest(vec);
                    if p < 0.05,
                        tresstr = [num2str(col1) ': t(' num2str(df) ') = ' num2str(t) ', p = ' num2str(p)];
                        fprintf(['\t\t' tresstr '\n']);
                    end;
                end;
            end;
            
            if length(factors{iPred}) > 1,
                % Test differences of difference scores
                fprintf('\tPost-hoc D-of-D:\n');
                final_factor = levels(factors{iPred}(end));
                higher_levels_id = rec_comb(levels(factors{iPred}(1:(end - 1))), 0);
                D = {};
                for iUpper = 1:length(higher_levels_id),
                    DofD = [];
                    a = 1 + (iUpper - 1) * final_factor;
                    b = a + final_factor - 1;
                    tmp = y_red_M(:, a:b);
                    tmp2 = [];
                    for icol1 = 1:size(tmp, 2),
                        for icol2 = 1:(icol1 - 1),
                            d = tmp(:, icol1) - tmp(:, icol2);
                            [p, t, df] = teg_ttest(d);
                            if p < 0.05,
                                tresstr = ['Diff ' num2str(icol1) ' - ' num2str(icol2) ', upper-level cell ' num2str(iUpper) ': t(' num2str(df) ') = ' num2str(t) ', p = ' num2str(p)];
                                fprintf(['\t\t' tresstr '\n']);
                            end;
                            tmp2 = [tmp2 d];
                            DofD = [DofD; icol1 icol2];
                        end;
                    end;
                    D{iUpper} = tmp2;
                end;
                for iUpper1 = 1:length(D),
                    for iUpper2 = 1:(iUpper1 - 1),
                        D1 = D{iUpper1};
                        D2 = D{iUpper2};
                        for icol = 1:size(D1, 2),
                            vec = D1(:, icol) - D2(:, icol);
                            [p, t, df] = teg_ttest(vec);
                            if p < 0.05,
                                tresstr = ['Diff-of-diff ' num2str(DofD(icol, 1)) ' - ' num2str(DofD(icol, 2)) ', upper-level cells ' num2str(iUpper1) ' - ' num2str(iUpper2) ': t(' num2str(df) ') = ' num2str(t) ', p = ' num2str(p)];
                                fprintf(['\t\t' tresstr '\n']);
                            end;
                        end;
                    end;
                end;
                
                % Plots
                if plots == 1,
                    ply = myr;
                    nonx = levels(factors{iPred}(end));
                    ply = reshape(ply, nonx, length(ply) / nonx);
                    ply_sd = seyr;
                    ply_sd = reshape(ply_sd, nonx, length(ply_sd) / nonx);
                    leg0 = {};
                    title0 = ([fname ' ' resstr]);
                    xlabel0 = varnames{factors{iPred}(end)};
                    ylabel0 = fname;
                    teg_std_plot_sep(ply, title0, xlabel0, ylabel0, leg0, ply_sd, levels, varnames, factors{iPred});
                    if ~isempty(fname),
                        % print(gcf, '-dps', '-append', [pwd '/' fname]);
                        % print(gcf, '-dtiff', '-r300', [pwd '/' fname '_' labels{iPred} '_' ylabel0]);
                        saveas(gcf, [pwd '/' fname resstr(isletter(resstr)) num2str(currplot)]);
                        currplot = currplot + 1;
                    end;
                    close(gcf);
                end;
            else % only one factor involved
                if plots == 1,
                    ply = myr(:);
                    ply_sd = seyr(:);
                    title0 = ([fname ' ' resstr]);
                    xlabel0 = varnames{factors{iPred}};
                    ylabel0 = fname;
                    teg_std_plot_sep(ply, title0, xlabel0, ylabel0, {}, ply_sd, levels, varnames, factors{iPred});
                    if ~isempty(fname),
                        % print(gcf, '-dps', '-append', [pwd '/' fname]);
                        % print(gcf, '-dtiff', '-r300', [[pwd '/' fname] '_' labels{iPred} '_' ylabel0]);
                        saveas(gcf, [pwd '/' fname resstr(isletter(resstr)) num2str(currplot)]);
                        currplot = currplot + 1;
                    end;
                    close(gcf);
                end;
            end;
            fprintf('\n');
        else,
            fprintf('\n');
        end;
    end;
    
    % Between-continuous
    for iBetwCont = 1:length(contvar),
        if iBetwCont > size(contvar0, 2),
            recursestr = '';
        else,
            recursestr = ' '; % No recurse
        end;
        [y_raw_cell_obs_0, O] = teg_contvar_subfunction(contvar, thisset, y, cellsets, iPred, M_raw, nSubj, nColsFactor, X0, iBetwCont, ...
            contvar1, O, pCritForFurther, plots, labels, Betw_labels, fname, factorStarts, recursestr, Betw_vars_involved, verbose0, curr_test, p_fdr, yN, NM);
        curr_test = curr_test + 1;
        
        if plots == 1,
            if size(contvar0, 2) > 2 && iBetwCont == length(contvar),
                if size(y_raw_cell_obs_0, 2) == 2,
                    d = diff([y_raw_cell_obs_0]')'; % level 2 - level 1
                    if size(y_raw_cell_obs_0, 2) > 2,
                        med1 = median(contvar0(:, 1));
                    else
                        med1 = -1;
                    end;
                    figure; clf;
                    for iSplit = 1:2,
                        if iSplit == 1
                            f = find(contvar0(:, 1) <= med1);
                            subplot(2, 1, 1);
                        else
                            f = find(contvar0(:, 1) > med1);
                            subplot(2, 1, 2);
                        end;
                        y_part = d(f);
                        axes_part = contvar0(f, :);
                        buf = (max(contvar0(:, 2)) - min(contvar0(:, 2))) / 10;
                        hold on;
                        tt00 = ['Between variables effect on contrast ' num2str(iPred) ': ' labels{iPred}];
                        title(tt00);
                        for iPoint = 1:size(y_part),
                            x0 = axes_part(iPoint, 2) + [-1 -1 1 1] * buf;
                            y0 = axes_part(iPoint, 3) + [-1 1 1 -1] * buf;
                            r0 = (y_part(iPoint) - mean(y_part)) / max(abs(y_part - mean(y_part)));
                            g0 = 0;
                            b0 = 0;
                            if r0 < 0
                                b0 = -r0;
                                r0 = 0;
                            end;
                            col0 = [r0 g0 b0];
                            fill(x0, y0, col0);
                        end;
                        colorbar;
                        xlim([min(contvar0(:, 2)) max(contvar0(:, 2))] + [-buf buf]);
                        ylim([min(contvar0(:, 3)) max(contvar0(:, 3))] + [-buf buf]);
                    end;
                    if ~isempty(fname),
                        % print(gcf, '-dps', '-append', fname);
                        saveas(gcf, [pwd '/' fname tt00(isstr(tt00)) num2str(currplot)]);
                        currplot = currplot + 1;
                    end;
                    close(gcf);
                end;
            end;
        else,
            % fprintf('\n');            
        end;
    end;
    close(gcf);
end;
