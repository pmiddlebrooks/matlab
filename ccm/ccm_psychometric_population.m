function data = ccm_psychometric_population(subjectID, plotFlag, figureHandle)


%%
% *************************************************************************
% Populaiton psychometric : Using mean choice proportion AVERAGED across sessions
% *************************************************************************
% if nargin < 2
    plotFlag = 1;
% end
% if nargin < 3
    figureHandle = 4945;
% end

fprintf('\n\n\n\')
disp('*******************************************************************************')
disp('Populaiton psychometric : Using mean choice proportion AVERAGED across sessions')

% subjectID = 'Human';
subjectID = 'broca';
% subjectID = 'Xena';
sessionSet = 'behavior2';


task = 'ccm';
[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);


switch lower(subjectID)
   case 'human'
      pSignalArray = [.35 .42 .46 .5 .54 .58 .65];
   case 'broca'
      switch sessionSet
         case 'behavior'
            pSignalArray = [.41 .45 .48 .5 .52 .55 .59];
         case 'neural1'
            pSignalArray = [.41 .44 .47 .53 .56 .59];
         case 'neural2'
            pSignalArray = [.42 .44 .46 .54 .56 .58];
           otherwise
               [td, S, E] = load_data(subjectID, sessionArray{1});
               pSignalArray = E.pSignalArray;
      end
   case 'xena'
      pSignalArray = [.35 .42 .47 .5 .53 .58 .65];
end



nSession = length(sessionArray);

if plotFlag
    nRow = 3;
    nColumn = 2;
    psyAx = 1;
    figureHandle = 9898;
    [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', figureHandle);
    ax(psyAx) = axes('units', 'centimeters', 'position', [xAxesPosition(2, 1) yAxesPosition(2, 1) axisWidth axisHeight]);
    cla
    stopColor = [.5 .5 .5];
    goColor = [0 0 0];
    hold(ax(psyAx))
    choicePlotXMargin = .03;
end

goRightProb = [];
goThreshold = [];
goSlope = [];

goMatchRightProb = [];
goMatchThreshold = [];
goMatchSlope = [];

stopRightProb = [];
stopThreshold = [];
stopSlope = [];
for iSession = 1 : nSession
    iSessionID = sessionArray{iSession};
    
    
    psyOpt = ccm_psychometric;
    psyOpt.plotFlag = false;
    iData = ccm_psychometric(subjectIDArray{iSession}, sessionArray{iSession}, psyOpt);
    
    
    goRightProb = [goRightProb; iData.nGoRight ./ iData.nGo];
    goThreshold = [goThreshold; iData.goParams.threshold];
    goSlope = [goSlope; iData.goParams.slope];
    
    goMatchRightProb = [goMatchRightProb; iData.nGoRightMatch ./ iData.nGoMatch];
    goMatchThreshold = [goMatchThreshold; iData.goMatchParams.threshold];
    goMatchSlope = [goMatchSlope; iData.goMatchParams.slope];
    
    stopRightProb = [stopRightProb; nansum(iData.nStopIncorrectRight) ./ nansum(iData.nStopIncorrect)];
    stopThreshold = [stopThreshold; iData.stopParams.threshold];
    stopSlope = [stopSlope; iData.stopParams.slope];
    
end
pSignalArrayFit = repmat(pSignalArray', size(goRightProb, 1), 1);


[h,p, ci, stats] = ttest2(goSlope, stopSlope);
fprintf('Psychometric Slope T-test:\nStop vs. Go: \t\tp = %.4f\n', p)
stats
rTest = sqrt(stats.tstat^2 / (stats.tstat^2 + stats.df))
[h,p, ci, stats] = ttest2(goMatchSlope, stopSlope);
fprintf('Psychometric Slope T-test:\nStop vs. Matched Go: \tp = %.4f\n', p)
stats
rTest = sqrt(stats.tstat^2 / (stats.tstat^2 + stats.df))


anovaData = [];
groupInh = {};
groupSig = [];
for i = 1 : length(pSignalArray)
    anovaData = [anovaData; goRightProb(:,i); stopRightProb(:,i)];
    groupInh = [groupInh; repmat({'go'}, length(goRightProb(:,i)), 1); repmat({'stop'}, length(stopRightProb(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(goRightProb(:,i)), 1); repmat(i, length(stopRightProb(:,i)), 1)];
end
[p,table,stats] = anovan(anovaData,{groupInh, groupSig}, 'varnames', {'Stop vs Go', 'Signal Strength'}, 'display', 'off')
eta2Sig = table{2,2} / (table{2,2} + table{end,2})
% fprintf('\n\n %s \n', subjectID)
fprintf('RT ANOVA:\nStop vs. Go: \t\tp = %d\nSignal Strength: \tp = %d\n', p(1), p(2))

anovaData = [];
groupInh = {};
groupSig = [];
for i = 1 : length(pSignalArray)
    anovaData = [anovaData; goMatchRightProb(:,i); stopRightProb(:,i)];
    groupInh = [groupInh; repmat({'goMatch'}, length(goMatchRightProb(:,i)), 1); repmat({'stop'}, length(stopRightProb(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(goMatchRightProb(:,i)), 1); repmat(i, length(stopRightProb(:,i)), 1)];
end
[p,table,stats] = anovan(anovaData,{groupInh, groupSig}, 'varnames', {'Stop vs Go Matched', 'Signal Strength'}, 'display', 'off')
eta2Sig = table{2,2} / (table{2,2} + table{end,2})
% fprintf('\n\n %s \n', subjectID)
fprintf('RT ANOVA:\nStop vs. Matched Go: \t\tp = %d\nSignal Strength: \tp = %d\n', p(1), p(2))







% ******************  Go   ******************
goRightProbMean = mean(goRightProb, 1);
goRightProbStd = std(goRightProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(pSignalArrayFit(:), goRightProb(:));
% [fitParameters, lowestSSE] = Weibull(pSignalArray*100, goRightProbMean);
propPoints = pSignalArray(1) : .001 : pSignalArray(end);
goPsychometricFn = weibull_curve(fitParameters, propPoints);


% *************  Go Matched RT   **************
goMatchRightProbMean = mean(goMatchRightProb, 1);
goMatchRightProbStd = std(goMatchRightProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(pSignalArrayFit(:), goMatchRightProb(:));
% [fitParameters, lowestSSE] = Weibull(pSignalArray*100, goRightProbMean);
propPoints = pSignalArray(1) : .001 : pSignalArray(end);
goMatchPsychometricFn = weibull_curve(fitParameters, propPoints);



% ******************  Stop   ******************
stopRightProbMean = mean(stopRightProb, 1);
stopRightProbStd = std(stopRightProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(pSignalArrayFit(:), stopRightProb(:));
% [fitParameters, lowestSSE] = Weibull(pSignalArray*100, stopRightProbMean);
stopPsychometricFn = weibull_curve(fitParameters, propPoints);




if plotFlag
    plot(ax(psyAx), pSignalArray, stopRightProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', stopColor, 'linewidth' , 2, 'markerfacecolor', [1 1 1], 'markersize', 10)
    errorbar(ax(psyAx), pSignalArray ,stopRightProbMean, stopRightProbStd, 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)
    plot(ax(psyAx), propPoints, stopPsychometricFn, '-', 'color', stopColor, 'linewidth' , 2)
    
    
    % plot(ax(psyAx), pSignalArray, goMatchRightProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', 'b', 'linewidth' , 2, 'markerfacecolor', [1 1 1], 'markersize', 10)
    % errorbar(ax(psyAx), pSignalArray ,goMatchRightProbMean, goMatchRightProbStd, 'linestyle' , 'none', 'color', goColor, 'linewidth' , 2)
    % plot(ax(psyAx), propPoints, goMatchPsychometricFn, '--', 'color', goColor, 'linewidth' , 2)
    %
    plot(ax(psyAx), pSignalArray, goRightProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', goColor, 'linewidth' , 2, 'markerfacecolor', [1 1 1], 'markersize', 10)
    errorbar(ax(psyAx), pSignalArray ,goRightProbMean, goRightProbStd, 'linestyle' , 'none', 'color', goColor, 'linewidth' , 2)
    plot(ax(psyAx), propPoints, goPsychometricFn, '-', 'color', goColor, 'linewidth' , 2)
    
    
    
    
    % xlim(ax(psyAx), [.33 .67])
    set(ax(psyAx), 'Xlim', [pSignalArray(1) - choicePlotXMargin, pSignalArray(end) + choicePlotXMargin])
    % xlim(ax(psyAx), [.38 .62])
    ylim([0 1])
    plot(ax(psyAx), [.5 .5], ylim, '--k')
    set(ax(psyAx), 'xtick', pSignalArray)
    % set(ax(psyAx), 'xtickLabel', pSignalArray*100)
    % set(ax(psyAx), 'xtickLabel', [])
    % set(ax(psyAx), 'ytickLabel', [])
    set(ax(psyAx), 'xtick', pSignalArray)
    set(ax(psyAx), 'xtickLabel', pSignalArray*100)
    set(ax(psyAx), 'ytick', [0 .5 1])
    set(ax(psyAx), 'ylim', [0 1])
end









% Collect data in different format for SPSS Repeated measures ANOVA

psyDataSession = [];
psyDataMatchSession = [];
groupSession = [];
for iSession = 1 : nSession
    psyData = [];
    psyDataMatch = [];
    group = [];
    for i = 1 : nSignalStrength
        psyData = [psyData, goRightProb(iSession,i), stopRightProb(iSession,i)];
        psyDataMatch = [psyDataMatch, goMatchRightProb(iSession,i), stopRightProb(iSession,i)];
        group = [group, {['go',num2str(i)]}, {['stop',num2str(i)]}];
    end
    psyDataSession = [psyDataSession; psyData];
    psyDataMatchSession = [psyDataMatchSession; psyDataMatch];
    groupSession = [groupSession; group];
end

% O = teg_repeated_measures_ANOVA(psyDataSession, [nSignalStrength, 2, 2], {'Signal Strength', 'Stop vs Go'})
            localFigurePath = local_figure_path;
            print(figureHandle,[localFigurePath, subjectID,'_ccm_population_psychometric'],'-dpdf', '-r300')


