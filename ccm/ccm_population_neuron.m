function Data = ccm_population_neuron(subjectID, Opt)

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
%   opt: A structure with various ways to select/organize data: If
%   ccm_session_data.m is called without input arguments, the default
%   opt structure is returned. opt has the following fields with
%   possible values (default listed first):
%
%    opt.dataType = 'neuron', 'lfp', 'erp';
%
%    opt.figureHandle   = 1000;
%    opt.printPlot      = false, true;
%    opt.plotFlag       = true, false;
%    opt.plotError       = true, false;
%    opt.collapseSignal = false, true;
%     opt.collapseTarg         = false, true;
%    opt.doStops        = true, false;
%    opt.filterData 	= false, true;
%    opt.stopHz         = 50, <any number, above which signal is filtered;
%    opt.normalize      = false, true;
%    opt.unitArray      = {'spikeUnit17a'},'each', units want to analyze
%
%
% Returns Data structure with fields:
%
%   Data.signalStrength(x).(condition).ssd(x).(epoch name)
%
%   condition can be:  goTarg, goDist, stopTarg, stopDist, stopStop
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
task = 'ccm';

if nargin < 2
    Opt.dataType = 'neuron';
    Opt.sessionSet       = 'neural1';
    Opt.sessionArray       = [];
    Opt.unitArray        = 'each';
    
    Opt.figureHandle     = 4950;
    Opt.printPlot        = false;
    Opt.plotFlag         = false;
    Opt.plotError        = false;
    Opt.collapseSignal   = false;
    Opt.collapseTarg   	 = true;
    Opt.doStops          = true;
    Opt.filterData       = false;
    Opt.stopHz           = 50;
    Opt.normalize        = false;
    Opt.howProcess        = 'each';
    
    if nargin == 0
        Data = Opt;
        return
    end
end

sessionSet      = Opt.sessionSet;
sessionArray    = Opt.sessionArray;
dataType        = Opt.dataType;

% opt.unitArray = {'fcz','o1','o2'};
unitArray = Opt.unitArray;
sdfWindow = -299:300;

if isempty(Opt.sessionArray)
    [sessionArray, ~] = task_session_array(subjectID, task, sessionSet);
end
subjectIDArray = repmat({subjectID}, length(sessionArray), 1);




nSession = length(sessionArray);
nUnit = length(sessionArray);
totalSSD = [];


% if plotFlag
%     nRow = 3;
%     nColumn = 2;
%     rtAx = 1;
%     ssdAx = 2;
%     [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', figureHandle);
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





% For now, assume there was only one target per hemisphere or we're
% collapsing across targets
jTarg = 1;
epochArrayStop      = {'fixWindowEntered', 'targOn', 'checkerOn', 'stopSignalOn', 'responseOnset', 'rewardOn'};
epochArrayGo        = {'fixWindowEntered', 'targOn', 'checkerOn', 'responseOnset', 'rewardOn'};
outcomeArrayGo      = {'goTarg', 'goDist'};
outcomeArrayStop    = {'stopTarg', 'stopStop','goFast', 'goSlow'};
colorCohArray       = {'easyIn', 'easyOut', 'hardIn', 'hardOut'};



% Figure out which SSDs to collapse for go/stop comparison:
% Implement latency matching in ccm_session_data and send it here

% for i = 1 : nUnit
%     % Intialize Data structure for go trials
for k = 1 : length(colorCohArray)
    for m = 1 : length(epochArrayGo)
        Data.(colorCohArray{k}).goTarg.(epochArrayGo{m}).sdf = [];
        Data.(colorCohArray{k}).goDist.(epochArrayGo{m}).sdf = [];
    end
    %     % Intialize Data structure for stop trials
    for m = 1 : length(epochArrayStop)
        Data.(colorCohArray{k}).stopTarg.(epochArrayStop{m}).sdf = [];
        Data.(colorCohArray{k}).stopStop.(epochArrayStop{m}).sdf = [];
        Data.(colorCohArray{k}).goFast.(epochArrayStop{m}).sdf = [];
        Data.(colorCohArray{k}).goSlow.(epochArrayStop{m}).sdf = [];
    end
end
% end

iData = [];
iOpt = Opt;
for iUnit = 1 : nUnit
    
    fprintf('Unit: %s\t%s\n', sessionArray{iUnit}, unitArray{iUnit})
    iOpt.unitArray = Opt.unitArray(iUnit);
    iData = ccm_session_data(subjectIDArray{iUnit}, sessionArray{iUnit}, iOpt);
    
    % Figure out the indices of hardest and easiest left and right color
    % coherence proportions.
    pSignalArray = iData(1).pSignalArray;
    pSignalArray(pSignalArray == .5) = [];
    
    % If there's no RF, use the contralateral direction relative to the
    % recorded hemisphere
    if strcmp(Opt.rfList{iUnit}, 'none')
        switch lower(Opt.hemisphereList{iUnit})
            case 'left'
                Opt.rfList{iUnit} = 'right';
            case 'right'
                Opt.rfList{iUnit} = 'left';
        end
    end
    switch lower(Opt.rfList{iUnit})
        case 'left'
            easyInInd     = 1;
            easyOutInd    = length(pSignalArray);
            hardInInd     = length(pSignalArray)/2;
            hardOutInd    = hardInInd + 1;
        case 'right'
            easyInInd     = length(pSignalArray);
            easyOutInd    = 1;
            hardOutInd    = length(pSignalArray)/2;
            hardInInd     = hardOutInd + 1;
        case 'none'
            
    end
    iRFList = [easyInInd, easyOutInd, hardInInd, hardOutInd]; % Make sure this same order as colorCohArray
    
    ssd(iUnit).array = iData(1).ssdArray;
    totalSSD = unique([totalSSD; iData(1).ssdArray]);
    
    
    switch dataType
        case 'neuron'
            
            for k = 1 : length(colorCohArray)
                
                % Collect Go Data
                for m = 1 : length(epochArrayGo)
                    mEpoch = epochArrayGo{m};
                    for n = 1 : length(outcomeArrayGo)
                        nOutcome = outcomeArrayGo{n};
                        
                        if ~isempty(iData.signalStrength(iRFList(k)).(nOutcome).(mEpoch).sdf)
                            alignTime = iData.signalStrength(iRFList(k)).(nOutcome).(mEpoch).alignTime;
                            
                            % Might need to pad the sdf if aligntime is before the sdf window beginning
                            if alignTime <  -sdfWindow(1)
                                iData.signalStrength(iRFList(k)).(nOutcome).(mEpoch).sdf = ...
                                    [nan(size(iData.signalStrength(iRFList(k)).(nOutcome).(mEpoch).sdf, 1), -sdfWindow(1) - alignTime),...
                                    iData.signalStrength(iRFList(k)).(nOutcome).(mEpoch).sdf];
                                alignTime = alignTime - sdfWindow(1);
                            end
                            
                            Data.(colorCohArray{k}).(nOutcome).(mEpoch).sdf = ...
                                [Data.(colorCohArray{k}).(nOutcome).(mEpoch).sdf;...
                                nanmean(iData.signalStrength(iRFList(k)).(nOutcome).(mEpoch).sdf(:,alignTime + sdfWindow), 1)];
                        end
                    end
                end
                
                % Collect Stop Data
                if Opt.doStops
                    for m = 1 : length(epochArrayStop)
                        mEpoch = epochArrayStop{m};
                        for n = 1 : length(outcomeArrayStop)
                            nOutcome = outcomeArrayStop{n};
                            
                            % concatenate all SSDs
                            cOpt                = ccm_concat_neural_conditions;
                            cOpt.epochName      = mEpoch;
                            cOpt.colorCohArray  = iData.pSignalArray(iRFList(k));
                            cOpt.ssdArray       = iData.ssdArray;
                            cOpt.conditionArray = {nOutcome};
                            iConcat             = ccm_concat_neural_conditions(iData, cOpt);
                            
                            if ~isempty(iConcat.signal)
                                alignTime = iConcat.align;
                                
                                % Might need to pad the sdf if aligntime is before the sdf window beginning
                                if alignTime <  -sdfWindow(1)
                                    iConcat.signal = ...
                                        [nan(1, -sdfWindow(1) - alignTime),...
                                        iConcat.signalFn];
                                    alignTime = alignTime - sdfWindow(1);
                                end
                                
                                Data.(colorCohArray{k}).(nOutcome).(mEpoch).sdf = ...
                                    [Data.(colorCohArray{k}).(nOutcome).(mEpoch).sdf;...
                                    nanmean(iConcat.signalFn(:,alignTime + sdfWindow), 1)];
                            end
                        end
                        
                        
                    end
                end % if opt.doStops
                
                
            end % for k = 1 : length(colorCohArray)
            
        case 'lfp'
            
        case 'erp'
            % loop through the eeg electrodes and collect
            % accordingly
            for j = 1 : nUnit
                Data(j).name = unitArray{j};
                
                % Loop through go trials
                for m = 1 : length(epochArrayGo)
                    mEpoch = epochArrayGo{m};
                    
                    Data(j).signalStrength(k).goTarg.(mEpoch).alignTime = ...
                        iData(j, jTarg).signalStrength(k).goTarg.(mEpoch).alignTime;
                    Data(j).signalStrength(k).goDist.(mEpoch).alignTime = ...
                        iData(j, jTarg).signalStrength(k).goDist.(mEpoch).alignTime;
                    
                    % Go to Target Trials
                    Data(j).signalStrength(k).goTarg.(mEpoch).erp = ...
                        [Data(j).signalStrength(k).goTarg.(mEpoch).erp;...
                        iData(j, jTarg).signalStrength(k).goTarg.(mEpoch).erp];
                    
                    % Go to Distractor Trials
                    Data(j).signalStrength(k).goDist.(mEpoch).erp = ...
                        [Data(j).signalStrength(k).goDist.(mEpoch).erp;...
                        iData(j, jTarg).signalStrength(k).goDist.(mEpoch).erp];
                    
                end %for m = 1 ; length(epochArray)
                
                
                if Opt.doStops
                    % Loop through stop trials
                    for m = 1 : length(epochArrayStop)
                        for n = 1 : nSSD
                            %                                 Data(j).ssd(
                            mEpoch = epochArrayStop{m};
                            Data(j).signalStrength(k).stopTarg.ssd(n).(mEpoch).alignTime = ...
                                iData(j, jTarg).signalStrength(k).stopTarg.ssd(n).(mEpoch).alignTime;
                            
                            % Stop to Target Trials
                            Data(j).signalStrength(k).stopTarg.ssd(n).(mEpoch).erp = ...
                                [Data(j).signalStrength(k).stopTarg.ssd(n).(mEpoch).erp;...
                                iData(j, jTarg).signalStrength(k).stopTarg.ssd(n).(mEpoch).erp];
                        end % for n = 1 : nSSD
                    end %for m = 1 ; length(epochArray)
                end % if opt.doStoips
            end %  for j = 1 : nUnit
    end % swtich dataType
    
    
    clear iData
end % for iUnit = 1 : nSession


% Loop back through all the stop trial SSDs to collect and average signals
% across sessions within each SSD. This is necessary because the ssdArray
% (the SSDs) across sessions may vary.


% Data(1).ssd = ssd;
% Data(1).ssdArray       = iData(j, jTarg).ssdArray;
% Data(1).dataArray       = iData(j, jTarg).dataArray;
% Data(1).pSignalArray    = iData(j, jTarg).pSignalArray;
% % Data(1).targAngleArray = iData(j, jTarg).targAngleArray;
% % Data(1).ssdArray    	= iData(j, jTarg).ssdArray;
% Data(1).subjectID       = iData(j, jTarg).subjectID;
% Data(1).sessionID       = 'Population';
return

if Opt.plotFlag
    ccm_population_neuron_plot(Data, opt)
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
for iUnit = 1 : nSession
    rtData = [];
    group = [];
    for i = 1 : size(goTarg, 2)
        rtData = [rtData, goTarg(iUnit,i)];
        group = [group, {['goTarg',num2str(i)]}];
    end
    for i = 1 : size(goDist, 2)
        rtData = [rtData, goDist(iUnit,i)];
        group = [group, {['goDist',num2str(i)]}];
    end
    for i = 1 : size(stopTarg, 2)
        rtData = [rtData, stopTarg(iUnit,i)];
        group = [group, {['stopTarg',num2str(i)]}];
    end
    for i = 1 : size(stopDist, 2)
        rtData = [rtData, stopDist(iUnit,i)];
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

