function Data = ccm_population_data(subjectID, options)%dataType, varargin)

%
% function Data = ccm_single_neuron(subjectID, sessionID, plotFlag, unitArray)
%
% Single neuron analyses for choice countermanding task. Only plots the
% sdfs. To see rasters, use ccm_single_neuron_rasters, which displays all
% conditions in a given epoch
%
% input:
%   subjectID: e.g. 'Broca', 'Xena', 'pm', etc
%   sessionID: e.g. 'bp111n01', 'Allsaccade'
%
%   options: A structure with various ways to select/organize data: If
%   ccm_session_data.m is called without input arguments, the default
%   options structure is returned. options has the following fields with
%   possible values (default listed first):
%
%    options.dataType = 'neuron', 'lfp', 'erp';
%
%    options.figureHandle   = 1000;
%    options.printPlot      = false, true;
%    options.plotFlag       = true, false;
%    options.collapseSignal = false, true;
%     options.collapseTarg         = false, true;
%    options.doStops        = true, false;
%    options.filterData 	= false, true;
%    options.stopHz         = 50, <any number, above which signal is filtered;
%    options.normalize      = false, true;
%    options.unitArray      = {'spikeUnit17a'},'each', units want to analyze
%
%
% Returns Data structure with fields:
%
%   Data.signalStrength(x).(condition).ssd(x).(epoch name)
%
%   condition can be:  goTarg, goDist, stopTarg, stopDist, stopCorrect
%   ssd(x):  only applies for stop trials, else the field is absent
%   epoch name: fixOn, targOn, checkerOn, etc.
%   nGo
%   nGoRight
%   nStopIncorrect
%   nStopIncorrectRight
%   goRightLogical
%   goRightSignalStrength
%   stopRightLogical
%   stopRightSignalStrength





%%
% % **************************************************************************************************
% % Populaiton data
% % **************************************************************************************************
% fprintf('\n\n\n\n')
% disp('*******************************************************************************')
% subjectID = 'Human';
% % subjectID = 'Xena';
% % sessionSet = 'behavior';
% subjectID = 'broca';

% subjectID = 'broca';
% nargin = 2;

if nargin < 3
    options.dataType = 'neuron';
    options.sessionSet       = 'behavior2';
    
    options.figureHandle     = 4950;
    options.printPlot        = false;
    options.plotFlag         = false;
    options.collapseSignal   = false;
    options.collapseTarg      = true;
    options.doStops          = true;
    options.filterData       = false;
    options.stopHz           = 50;
    options.normalize        = false;
    options.unitArray        = 'each';
    
    if nargin == 0
        Data = options;
        return
    end
end
options.dataType = 'erp';

sessionSet      = options.sessionSet;
dataType        = options.dataType;




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
                [td, S, E] =load_data(subjectID, sessionArray{1});
                pSignalArray = E.pSignalArray;
        end
    case 'xena'
        switch sessionSet
            case 'behavior'
                pSignalArray = [.35 .42 .47 .5 .53 .58 .65];
            otherwise
                [td, S, E] =load_data(subjectID, sessionArray{1});
                pSignalArray = E.pSignalArray;
        end
end
nSignal = length(pSignalArray);


nSession = length(sessionArray);



% if plotFlag
%     nRow = 3;
%     nColumn = 2;
%     rtAx = 1;
%     ssdAx = 2;
%     [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, figureHandle);
%     ax(rtAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 2) yAxesPosition(1, 2) axisWidth axisHeight]);
%     cla
%     ax(ssdAx) = axes('units', 'centimeters', 'position', [xAxesPosition(2, 2) yAxesPosition(2, 2) axisWidth axisHeight]);
%     cla
%     %     stopColor = [.5 .5 .5];
%     stopColor = [1 0 0];
%     goColor = [0 0 0];
%     choicePlotXMargin = .03;
%     switch subjectID
%         case 'Human'
%             set(ax(rtAx), 'Ylim', [400 900])
%         otherwise
%             set(ax(rtAx), 'Ylim', [200 600])
%     end
%     hold(ax(rtAx), 'on')
%     hold(ax(ssdAx), 'on')
% end

















exData = ccm_session_data(subjectIDArray{1}, sessionArray{1}, options);
nSSD = length(exData(1).ssdArray);

clear exData;

% For now, assume there was only one target per hemisphere or we're
% collapsing across targets
jTarg = 1;
epochArrayStop = {'fixWindowEntered', 'targOn', 'checkerOn', 'stopSignalOn', 'responseOnset', 'rewardOn'};
epochArrayGo = {'fixWindowEntered', 'targOn', 'checkerOn', 'responseOnset', 'rewardOn'};
for k = 1 : nSignal
    for m = 1 : length(epochArrayGo)
        Data.signalStrength(k).goTarg.(epochArrayGo{m}).(dataType) = [];
    end
end
for k = 1 : nSignal
    for m = 1 : length(epochArrayStop)
        for n = 1 : nSSD
        Data.signalStrength(k).stopTarg.ssd(n).(epochArrayStop{m}).(dataType) = [];
        end
    end
end



for iSession = 1 : nSession
    
    fprintf('Session: %s\n', sessionArray{iSession})
    iData = ccm_session_data(subjectIDArray{iSession}, sessionArray{iSession}, options);
    
    
    nUnit = 1; %length(iData(1).unitArray);
    
    

    switch dataType
        case 'neuron'
            
            % loop through the different units on the electrode
            % (or specify which units to include)
            
        case 'lfp'
            
        case 'erp'
            % loop through the eeg electrodes and collect
            % accordingly
            for j = 1 : nUnit
                
                for k = 1 : nSignal
                    
                    % Loop through go trials
                    for m = 1 : length(epochArrayGo)
                        mEpochName = epochArrayGo{m};
                        
                        % Go to Target Trials
                        Data.signalStrength(k).goTarg.(mEpochName).erp = ...
                            [Data.signalStrength(k).goTarg.(mEpochName).erp;...
                            iData(j, jTarg).signalStrength(k).goTarg.(mEpochName).erp];
                        
                    end %for m = 1 ; length(epochArray)
                    
                    % Loop through stop trials
                    for m = 1 : length(epochArrayStop)
                        for n = 1 : nSSD
                        mEpochName = epochArrayStop{m};
                        
                        % Go to Target Trials
                        Data.signalStrength(k).stopTarg.ssd(n).(mEpochName).erp = ...
                            [Data.signalStrength(k).stopTarg.ssd(n).(mEpochName).erp;...
                            iData(j, jTarg).signalStrength(k).stopTarg.ssd(n).(mEpochName).erp];
                        end % for n = 1 : nSSD
                    end %for m = 1 ; length(epochArray)
                    
                end % for k = 1 : nSignal
            end %  for j = 1 : nUnit
    end
    
    
    
    
end





return

























pSignalArrayLeft = iData.pSignalArrayLeft;
pSignalArrayRight = iData.pSignalArrayRight;



% Mean RT within each SSD; Does RT increased with SSD?
[p, s] = polyfit(ssdData, ssdRTData, 1);
[y, delta] = polyval(p, ssdData, s);
stats = regstats(ssdData, ssdRTData)
R = corrcoef(ssdData, ssdRTData);
Rsqrd = R(1, 2)^2;
fprintf('\n\n R-squred: %.3f \t  Slope: %.3f \t p-value for regression: %.4f\n\n', Rsqrd, stats.beta(2), stats.tstat.pval(2))
cov(ssdData, ssdRTData);
xVal = min(ssdData) : .1 : max(ssdData);
yVal = p(1) * xVal + p(2);




goLeftTargMean = nanmean(goLeftToTarg);
goLeftTargStd = nanstd(goLeftToTarg);
goRightDistMean = nanmean(goRightToDist);
goRightDistStd = nanstd(goRightToDist);

goRightTargMean = nanmean(goRightToTarg);
goRightTargStd = nanstd(goRightToTarg);
goLeftDistMean = nanmean(goLeftToDist);
goLeftDistStd = nanstd(goLeftToDist);

stopLeftTargMean = nanmean(stopLeftToTarg);
stopLeftTargStd = nanstd(stopLeftToTarg);
stopRightDistMean = nanmean(stopRightToDist);
stopRightDistStd = nanstd(stopRightToDist);

stopRightTargMean = nanmean(stopRightToTarg);
stopRightTargStd = nanstd(stopRightToTarg);
stopLeftDistMean = nanmean(stopLeftToDist);
stopLeftDistStd = nanstd(stopLeftToDist);



goTargMean = nanmean([goLeftToTarg(:); goRightToTarg(:)]);
goDistMean = nanmean([goLeftToDist(:); goRightToDist(:)]);
stopTargMean = nanmean([stopLeftToTarg(:); stopRightToTarg(:)]);
stopDistMean = nanmean([stopLeftToDist(:); stopRightToDist(:)]);
goTargSD = nanstd([goLeftToTarg(:); goRightToTarg(:)]);
goDistSD = nanstd([goLeftToDist(:); goRightToDist(:)]);
stopTargSD = nanstd([stopLeftToTarg(:); stopRightToTarg(:)]);
stopDistSD = nanstd([stopLeftToDist(:); stopRightToDist(:)]);
fprintf('\nGo:   Targ: %.0f (%.0f) \tDist: %.0f (%.0f)', goTargMean, goTargSD, goDistMean, goDistSD);
fprintf('\nStop: Targ: %.0f (%.0f) \tDist: %.0f (%.0f)', stopTargMean, stopTargSD, stopDistMean, stopDistSD);


if plotFlag
    % PLOT GO TRIALS
    plot(ax(rtAx), pSignalArrayLeft, goLeftTargMean, '-o', 'color', goColor, 'linewidth' , 2, 'markeredgecolor', goColor, 'markerfacecolor', [1 1 1], 'markersize', 10)
    errorbar(ax(rtAx), pSignalArrayLeft ,goLeftTargMean, goLeftTargStd, 'linestyle' , 'none', 'color', goColor, 'linewidth' , 2)
    
    plot(ax(rtAx), pSignalArrayLeft, goRightDistMean, 'd', 'markeredgecolor', goColor, 'markersize', 10)
    % errorbar(ax(rtAx), pSignalArray ,goRightDistMean, goRightDistStd, '.' , 'linestyle' , 'none', 'color', goColor, 'linewidth' , 2)
    
    plot(ax(rtAx), pSignalArrayRight, goRightTargMean, '-o', 'color', goColor, 'linewidth' , 2, 'markeredgecolor', goColor, 'markerfacecolor', [1 1 1], 'markersize', 10)
    errorbar(ax(rtAx), pSignalArrayRight ,goRightTargMean, goRightTargStd, 'linestyle' , 'none', 'color', goColor, 'linewidth' , 2)
    
    plot(ax(rtAx), pSignalArrayRight, goLeftDistMean, 'd', 'markeredgecolor', goColor, 'markersize', 10)
    % errorbar(ax(rtAx), pSignalArray ,goRightDistMean, goRightDistStd, '.' , 'linestyle' , 'none', 'color', goColor, 'linewidth' , 2)
    
    
    % PLOT STOP TRIALS
    plot(ax(rtAx), pSignalArrayLeft, stopLeftTargMean, '-o', 'color', stopColor, 'linewidth' , 2, 'markeredgecolor', stopColor, 'markerfacecolor', [1 1 1], 'markersize', 10)
    errorbar(ax(rtAx), pSignalArrayLeft ,stopLeftTargMean, stopLeftTargStd, 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)
    
    plot(ax(rtAx), pSignalArrayLeft, stopRightDistMean, 'd', 'markeredgecolor', stopColor, 'markersize', 10)
    % errorbar(ax(rtAx), pSignalArray ,stopRightDistMean, stopRightDistStd, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)
    
    plot(ax(rtAx), pSignalArrayRight, stopRightTargMean, '-o', 'color', stopColor, 'linewidth' , 2, 'markeredgecolor', stopColor, 'markerfacecolor', [1 1 1], 'markersize', 10)
    errorbar(ax(rtAx), pSignalArrayRight ,stopRightTargMean, stopRightTargStd, 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)
    
    plot(ax(rtAx), pSignalArrayRight, stopLeftDistMean, 'd', 'markeredgecolor', stopColor, 'markersize', 10)
    % errorbar(ax(rtAx), pSignalArray ,stopRightDistMean, stopRightDistStd, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)
    
    
    
    %     set(ax(ssrtAx), 'Xlim', [.38 .62])
    % set(ax(ssrtAx), 'Xlim', [.33 .67])
    set(ax(rtAx), 'Xlim', [pSignalArray(1) - choicePlotXMargin, pSignalArray(end) + choicePlotXMargin])
    plot(ax(rtAx), [.5 .5], ylim, '--k')
    set(ax(rtAx), 'xtick', pSignalArray)
    set(ax(rtAx), 'xtickLabel', pSignalArray*100)
    
    
    % PLOT RTs within each SSD
    plot(ax(ssdAx), ssdData, ssdRTData, '.', 'color', stopColor, 'markersize', 10)
    plot(ax(ssdAx), xVal, yVal, 'color', 'r', 'linewidth', 2)
    
    
end





% ANOVA calculations
% ==================================
rtData = [];
groupInh = [];
groupTarg = [];
groupSig = [];
goFlag = 1;
stopFlag = 2;
targFlag = 1;
distFlag = 2;
pSignalArray = [pSignalArrayLeft; pSignalArrayRight];
goTarg = [goLeftToTarg, goRightToTarg];
goDist = [goRightToDist, goLeftToDist];
stopTarg = [stopLeftToTarg, stopRightToTarg];
stopDist = [stopRightToDist, stopLeftToDist];
for i = 1 : size(goTarg, 2)
    rtData = [rtData; goTarg(:,i)];
    groupInh = [groupInh; repmat({'go'}, length(goTarg(:,i)), 1)];
    groupTarg = [groupTarg; repmat({'targ'}, length(goTarg(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(goTarg(:,i)), 1)];
end
for i = 1 : size(goDist, 2)
    rtData = [rtData; goDist(:,i)];
    groupInh = [groupInh; repmat({'go'}, length(goDist(:,i)), 1)];
    groupTarg = [groupTarg; repmat({'dist'}, length(goDist(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(goDist(:,i)), 1)];
end
for i = 1 : size(stopTarg, 2)
    rtData = [rtData; stopTarg(:,i)];
    groupInh = [groupInh; repmat({'stop'}, length(stopTarg(:,i)), 1)];
    groupTarg = [groupTarg; repmat({'targ'}, length(stopTarg(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(stopTarg(:,i)), 1)];
end
for i = 1 : size(stopDist, 2)
    rtData = [rtData; stopDist(:,i)];
    groupInh = [groupInh; repmat({'stop'}, length(stopDist(:,i)), 1)];
    groupTarg = [groupTarg; repmat({'dist'}, length(stopDist(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(stopDist(:,i)), 1)];
end
% size(rtData)
% size(groupInh)
% size(groupTarg)
% size(groupSig)
% [rtData, groupInh, groupTarg, groupSig]
fprintf('\n\n *******************  RT ANOVA  *******************  \n')
[p,table,stats] = anovan(rtData,{groupInh, groupTarg, groupSig}, 'varnames', {'Stop/Go', 'Targ/Dist', 'Signal'}, 'model', 'full', 'display', 'off');
fprintf('\nStop vs. Go: \t\tp = %.3f\nTarg vs Dist: \tp = %.3f\nSignal Strength: \tp = %.3f\n', p(1), p(2), p(3))
disp(table)

eta2Sig = table{4,2} / (table{4,2} + table{end-1,2})
eta2Targ = table{3,2} / (table{3,2} + table{end-1,2})
eta2InhTarg = table{5,2} / (table{2,2} + table{end-1,2})

fprintf('\n\n *********  RT Multicompare  *********  \n')
c = multcompare(stats, 'dimension', 3, 'display', 'off');
disp(c)
disp(stats)



% TTESTS for overall means calculations
% ==================================

[h,p, ci, stats] = ttest2(goTargSessionMean, stopTargSessionMean, [], [], 'unequal');
stats
rTest = sqrt(stats.tstat^2 / (stats.tstat^2 + stats.df))
fprintf('GoTarg: %.0f (%.0f) --vs-- stopTarg: %.0f (%.0f) \tt-test: t(%.2f) = %.2f \tp = %.5f \t CI: %.2f - %.2f\n', ...
    mean(goTargSessionMean), std(goTargSessionMean), ...
    mean(stopTargSessionMean), std(stopTargSessionMean), ...
    stats.df, stats.tstat, p, ci(1), ci(2));

[h,p, ci, stats] = ttest2(goDistSessionMean, stopDistSessionMean, [], [], 'unequal');
rTest = sqrt(stats.tstat^2 / (stats.tstat^2 + stats.df))
fprintf('GoDist: %.0f (%.0f) --vs-- stopDist: %.0f (%.0f) \tt-test: t(%.2f) = %.2f \tp = %.5f \t CI: %.2f - %.2f\n', ...
    mean(goDistSessionMean), std(goDistSessionMean), ...
    mean(stopDistSessionMean), std(stopDistSessionMean), ...
    stats.df, stats.tstat, p, ci(1), ci(2));









% Collect data in different format for SPSS Repeated measures ANOVA

rtDataSession = [];
groupSession = [];
session = [];
for iSession = 1 : nSession
    rtData = [];
    group = [];
    for i = 1 : size(goTarg, 2)
        rtData = [rtData, goTarg(iSession,i)];
        group = [group, {['goTarg',num2str(i)]}];
    end
    for i = 1 : size(goDist, 2)
        rtData = [rtData, goDist(iSession,i)];
        group = [group, {['goDist',num2str(i)]}];
    end
    for i = 1 : size(stopTarg, 2)
        rtData = [rtData, stopTarg(iSession,i)];
        group = [group, {['stopTarg',num2str(i)]}];
    end
    for i = 1 : size(stopDist, 2)
        rtData = [rtData, stopDist(iSession,i)];
        group = [group, {['stopDist',num2str(i)]}];
    end
    rtDataSession = [rtDataSession; rtData];
    groupSession = [groupSession; group];
end



%  ANOVA calculations
% ==================================
rtData = [];
groupInh = [];
groupTarg = [];
groupSig = [];
goFlag = 1;
stopFlag = 2;
targFlag = 1;
distFlag = 2;
pSignalArray = [pSignalArrayLeft; pSignalArrayRight];
goTarg = [goLeftToTarg, goRightToTarg];
goDist = [goRightToDist, goLeftToDist];
stopTarg = [stopLeftToTarg, stopRightToTarg];
stopDist = [stopRightToDist, stopLeftToDist];
sessionNumber = [];
for i = 1 : size(goTarg, 2)
    rtData = [rtData; goTarg(:,i)];
    groupInh = [groupInh; repmat(goFlag, length(goTarg(:,i)), 1)];
    groupTarg = [groupTarg; repmat(targFlag, length(goTarg(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(goTarg(:,i)), 1)];
    sessionNumber = [sessionNumber; (1:nSession)'];
    %     sessionNumber = [sessionNumber; i * ones(length(goTarg(:,i)), 1)];
end
for i = 1 : size(goDist, 2)
    rtData = [rtData; goDist(:,i)];
    groupInh = [groupInh; repmat(goFlag, length(goDist(:,i)), 1)];
    groupTarg = [groupTarg; repmat(distFlag, length(goDist(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(goDist(:,i)), 1)];
    sessionNumber = [sessionNumber; (1:nSession)'];
    %     sessionNumber = [sessionNumber; i * ones(length(goDist(:,i)), 1)];
end
for i = 1 : size(stopTarg, 2)
    rtData = [rtData; stopTarg(:,i)];
    groupInh = [groupInh; repmat(stopFlag, length(stopTarg(:,i)), 1)];
    groupTarg = [groupTarg; repmat(targFlag, length(stopTarg(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(stopTarg(:,i)), 1)];
    sessionNumber = [sessionNumber; (1:nSession)'];
    %     sessionNumber = [sessionNumber; i * ones(length(stopTarg(:,i)), 1)];
end
for i = 1 : size(stopDist, 2)
    rtData = [rtData; stopDist(:,i)];
    groupInh = [groupInh; repmat(stopFlag, length(stopDist(:,i)), 1)];
    groupTarg = [groupTarg; repmat(distFlag, length(stopDist(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(stopDist(:,i)), 1)];
    sessionNumber = [sessionNumber; (1:nSession)'];
    %     sessionNumber = [sessionNumber; i * ones(length(stopDist(:,i)), 1)];
end
size(groupSig)
size(sessionNumber)

datas = [rtData, groupInh, groupTarg, groupSig, sessionNumber];

