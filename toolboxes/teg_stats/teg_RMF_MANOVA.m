function [F, df1, df2, p, MSM, MSE, eta] = teg_RMF_MANOVA(y_red_M, levels)

% y_red_M = reshape(y_red_M, nSubj, length(y_red_M) / nSubj);
nSubj = size(y_red_M, 1);
subjM = mean(y_red_M, 2);
y_red_M = y_red_M - subjM * ones(1, size(y_red_M, 2));

% Create differences-of-differences
ADC = get_ADC(y_red_M, levels);

% Model and test contrasts
[F, df1, df2, p, MSM, MSE, eta] = teg_test_T2(y_red_M, ADC);

function [lev1, lev2] = inner_parse_diffCode(thisDC)
lev1 = thisDC;
lev2 = thisDC + 1;

function ADC = get_ADC(y_red_M, levels)
% Create all-differences coder
levels = flipdim(levels(:)', 2);
nDiffCodes = zeros(1, length(levels));
for n = 1:length(levels),
    n0 = levels(n);
    n0 = n0 - 1;
    nDiffCodes(n) = n0;
end;
id_matrix = rec_comb(nDiffCodes, 0); % All possible pairwise differences
ADC = [];
for iDiffCode = 1:size(id_matrix, 1),
    diffCode = id_matrix(iDiffCode, :);
    codeVec = zeros(1, size(y_red_M, 2));
    prior_factors = 1;
    for iF = 1:length(diffCode),
        thisDC = diffCode(iF);
        [lev1, lev2] = inner_parse_diffCode(thisDC);
        tmp = zeros(1, size(y_red_M, 2));
        tmp = reshape(tmp, prior_factors, length(tmp(:)) / prior_factors);
        prior_factors = prior_factors * levels(iF);
        colsLevel = 1 + mod((1:size(tmp, 2)) - 1, levels(iF));
        tmp = ones(size(tmp, 1), 1) * (colsLevel(:)');
        fPos = find(tmp == lev2);
        fNeg = find(tmp == lev1);
        fZero = find(tmp ~= lev1 & tmp ~= lev2);
        if sum(abs(codeVec)) == 0,
            codeVec(fPos) = 1;
            codeVec(fNeg) = -1;
        else,
            codeVec(fNeg) = -codeVec(fNeg);
            codeVec(fZero) = 0;
        end;
    end;
    ADC = [ADC codeVec(:)];
end;
