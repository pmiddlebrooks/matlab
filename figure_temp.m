function figure_temp







%% ************************************************************************
% Population OVERLAY of  SSRT & Chronometric
% *************************************************************************

load ccm_population_monkey
signalStrengthLeft = [.41 .45 .48 .5];
signalStrengthRight = [.5 .52 .55 .58];
signalStrength = [.41 .45 .48 .5 .52 .55 .59];
% load ccm_population_human
% signalStrengthLeft = [.35 .42 .46 .5];
% signalStrengthRight = [.5 .54 .58 .65];
% signalStrength = [.35 .42 .46 .5 .54 .58 .65];

nSession = size(populationData, 1);
nRow = 3;
nColumn = 2;
rtAx = 1;
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(rtAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
hold(ax(rtAx), 'on')


% SSRT across signal strength
ssrt = cell2mat(cellfun(@(x) x', populationData.ssrt, 'uniformoutput', false));
ssrtMean = mean(ssrt, 1);
ssrtSTD = std(ssrt, 1);
ssrtSEM = std(ssrt, 1) / sqrt(nSession);

plot(ax(rtAx), signalStrength, ssrtMean, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
errorbar(ax(rtAx), signalStrength ,ssrtMean, ssrtSTD, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)


[p, table] = anova1(ssrt)

flipPropArray = signalStrength;
flipPropArray(flipPropArray > .5) = fliplr(flipPropArray(flipPropArray < .5));

signalStrengthData = repmat(flipPropArray, size(ssrt, 1), 1);
[p, s] = polyfit(signalStrengthData(:), ssrt(:), 1);
[y, delta] = polyval(p, signalStrengthData(:), s);
stats = regstats(signalStrengthData(:), ssrt(:))
fprintf('p-value for regression: %.4f\n', stats.tstat.pval(2))
R = corrcoef(signalStrengthData(:), ssrt(:));
Rsqrd = R(1, 2)^2;
cov(signalStrengthData(:), ssrt(:));
xVal = min(signalStrengthData(:)) : .001 : max(signalStrengthData(:));
yVal = p(1) * xVal + p(2);
plot(ax(rtAx), xVal, yVal, stopColor)

ssrtGrandMean = mean(cell2mat(populationData.ssrtGrand))


% Chronometric

goLeftToTargRTMean = [];
goLeftTargRTStd = [];
goRightToDistRTMean = [];
goRightToDistRTStd = [];

goRightToTargRTMean = [];
goRightTargRTStd = [];
goLeftToDistRTMean = [];
goLeftToDistRTStd = [];

stopLeftToTargRTMean = [];
stopLeftTargRTStd = [];
stopRightToDistRTMean = [];
stopRightToDistRTStd = [];

stopRightToTargRTMean = [];
stopRightTargRTStd = [];
stopLeftToDistRTMean = [];
stopLeftToDistRTStd = [];

for i = 1 : nSession
    cellfun(@nanmean, populationData.stopRightToTarg{i})
    cellfun(@nanstd, populationData.stopRightToTarg{i})
    cellfun(@nanmean, populationData.stopLeftToDist{i})
    cellfun(@nanstd, populationData.stopLeftToDist{i})
    
    goLeftToTargRTMean = [goLeftToTargRTMean; cellfun(@nanmean, populationData.goLeftToTarg{i})];
    goLeftTargRTStd = [goLeftTargRTStd; cellfun(@nanstd, populationData.goLeftToTarg{i})];
    goRightToDistRTMean = [goRightToDistRTMean; cellfun(@nanmean, populationData.goRightToDist{i})];
    goRightToDistRTStd = [goRightToDistRTStd; cellfun(@nanstd, populationData.goRightToDist{i})];
    
    goRightToTargRTMean = [goRightToTargRTMean; cellfun(@nanmean, populationData.goRightToTarg{i})];
    goRightTargRTStd = [goRightTargRTStd; cellfun(@nanstd, populationData.goRightToTarg{i})];
    goLeftToDistRTMean = [goLeftToDistRTMean; cellfun(@nanmean, populationData.goLeftToDist{i})];
    goLeftToDistRTStd = [goLeftToDistRTStd; cellfun(@nanstd, populationData.goLeftToDist{i})];
    
    
    stopLeftToTargRTMean = [stopLeftToTargRTMean; cellfun(@nanmean, populationData.stopLeftToTarg{i})];
    stopLeftTargRTStd = [stopLeftTargRTStd; cellfun(@nanstd, populationData.stopLeftToTarg{i})];
    stopRightToDistRTMean = [stopRightToDistRTMean; cellfun(@nanmean, populationData.stopRightToDist{i})];
    stopRightToDistRTStd = [stopRightToDistRTStd; cellfun(@nanstd, populationData.stopRightToDist{i})];
    
    stopRightToTargRTMean = [stopRightToTargRTMean; cellfun(@nanmean, populationData.stopRightToTarg{i})];
    stopRightTargRTStd = [stopRightTargRTStd; cellfun(@nanstd, populationData.stopRightToTarg{i})];
    stopLeftToDistRTMean = [stopLeftToDistRTMean; cellfun(@nanmean, populationData.stopLeftToDist{i})];
    stopLeftToDistRTStd = [stopLeftToDistRTStd; cellfun(@nanstd, populationData.stopLeftToDist{i})];
    
    
    
end

goLeftTargMeanPop = nanmean(goLeftToTargRTMean, 1);
goLeftTargStdPop = nanstd(goLeftToTargRTMean, 1) / sqrt(nSession);
goRightDistMeanPop = nanmean(goRightToDistRTMean, 1);
goRightDistStdPop = nanstd(goRightToDistRTMean, 1) / sqrt(nSession);

goRightTargMeanPop = nanmean(goRightToTargRTMean, 1);
goRightTargStdPop = nanstd(goRightToTargRTMean, 1) / sqrt(nSession);
goLeftDistMeanPop = nanmean(goLeftToDistRTMean, 1);
goLeftDistStdPop = nanstd(goLeftToDistRTMean, 1) / sqrt(nSession);

stopLeftTargMeanPop = nanmean(stopLeftToTargRTMean, 1);
stopLeftTargStdPop = nanstd(stopLeftToTargRTMean, 1) / sqrt(nSession);
stopRightDistMeanPop = nanmean(stopRightToDistRTMean, 1);
stopRightDistStdPop = nanstd(stopRightToDistRTMean, 1) / sqrt(nSession);

stopRightTargMeanPop = nanmean(stopRightToTargRTMean, 1);
stopRightTargStdPop = nanstd(stopRightToTargRTMean, 1) / sqrt(nSession);
stopLeftDistMeanPop = nanmean(stopLeftToDistRTMean, 1);
stopLeftDistStdPop = nanstd(stopLeftToDistRTMean, 1) / sqrt(nSession);


% PLOT GO TRIALS
plot(ax(rtAx), signalStrengthLeft, goLeftTargMeanPop, '-ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
errorbar(ax(rtAx), signalStrengthLeft ,goLeftTargMeanPop, goLeftTargStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

plot(ax(rtAx), signalStrengthLeft, goRightDistMeanPop, 'ok', 'markeredgecolor', 'k', 'markersize', 10)
% errorbar(ax(rtAx), signalStrength ,goRightDistMeanPop, goRightDistStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

plot(ax(rtAx), signalStrengthRight, goRightTargMeanPop, '-ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
errorbar(ax(rtAx), signalStrengthRight ,goRightTargMeanPop, goRightTargStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

plot(ax(rtAx), signalStrengthRight, goLeftDistMeanPop, 'ok', 'markeredgecolor', 'k', 'markersize', 10)
% errorbar(ax(rtAx), signalStrength ,goRightDistMeanPop, goRightDistStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)


% PLOT STOP TRIALS
plot(ax(rtAx), signalStrengthLeft, stopLeftTargMeanPop, '-or', 'markeredgecolor', stopColor, 'markerfacecolor', stopColor, 'markersize', 10)
errorbar(ax(rtAx), signalStrengthLeft ,stopLeftTargMeanPop, stopLeftTargStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)

plot(ax(rtAx), signalStrengthLeft, stopRightDistMeanPop, 'or', 'markeredgecolor', stopColor, 'markersize', 10)
% errorbar(ax(rtAx), signalStrength ,stopRightDistMeanPop, stopRightDistStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)

plot(ax(rtAx), signalStrengthRight, stopRightTargMeanPop, '-or', 'markeredgecolor', stopColor, 'markerfacecolor', stopColor, 'markersize', 10)
errorbar(ax(rtAx), signalStrengthRight ,stopRightTargMeanPop, stopRightTargStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)

plot(ax(rtAx), signalStrengthRight, stopLeftDistMeanPop, 'or', 'markeredgecolor', stopColor, 'markersize', 10)
% errorbar(ax(rtAx), signalStrength ,stopRightDistMeanPop, stopRightDistStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)



set(ax(rtAx), 'Xlim', [.38 .62])
% set(ax(rtAx), 'Xlim', [.33 .67])
ylim([0 350])
% ylim([400 900])
plot(ax(rtAx), [.5 .5], ylim, '--k')
set(ax(rtAx), 'xtick', signalStrength)
set(ax(rtAx), 'xtickLabel', signalStrength*100)

























%% ****************************************************************************************
% Population Inhibition Funciton: Using mean noncanceled stop probabilities across sessions
% ****************************************************************************************
task = 'ccm';
subjectID = 'Human';
subjectID = 'Broca';
subjectID = 'Xena';

switch subjectID
    case 'Human'
        signalStrength = [.35 .42 .46 .5 .54 .58 .65];
    case 'Broca'
        signalStrength = [.41 .45 .48 .5 .52 .55 .59];
    case 'Xena'
        signalStrength = [.35 .42 .47 .5 .53 .58 .65];
end
[sessionArray, subjectIDArray] = task_session_array(subjectID, task);
% signalStrength = unique([populationData.signalStrengthLeft{1}, populationData.signalStrengthRight{1}])';



nSession = length(sessionArray);
nRow = 3;
nColumn = 2;
inhAx = 1;
% [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = model_figure(nRow, nColumn, 9898, 'screen');
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(inhAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
hold(ax(inhAx), 'on')
choicePlotXMargin = .03;

inhGrand = [];
stopRespond = [];
ssdArray = [];
for iSession = 1 : nSession
    
    
    iData = ccm_inhibition(subjectIDArray{iSession}, sessionArray{iSession}, 0);
    
    
    
    iSSDN = nan(1, 1200);
    iStopRespondN = nan(1, 1200);
    iInhN = nan(1, 1200);
    
    iSSD = iData.ssdArray;
    iSSDN(iSSD) = iSSD;
    ssdArray = [ssdArray; iSSDN];
    
    iStopRespond = iData.stopRespondProbGrand;
    iStopRespondN(iSSD) = iStopRespond;
    stopRespond = [stopRespond; iStopRespondN];
    
    iInh = iData.inhibitionFnGrand;
    iInhN(iSSD(1):iSSD(end)) = iInh;
    inhGrand = [inhGrand; iInhN];
    
    
    
    
    
end
ssdArray = nanmean(ssdArray, 1);
inhGrandMean = nanmean(inhGrand, 1);
stopRespondMean = nanmean(stopRespond, 1);
stopRespondStd = nanstd(stopRespond, 1);

ssdArray(isnan(ssdArray)) = [];
inhGrandMean(isnan(inhGrandMean)) = [];
inhGrandMean = [nan(1, ssdArray(1)-1), inhGrandMean];
stopRespondMean(isnan(stopRespondMean)) = [];
stopRespondStd(isnan(stopRespondStd)) = [];


[fitParameters, lowestSSE] = Weibull(ssdArray, stopRespondMean);
timePoints = ssdArray(1) : ssdArray(end);
inhPop = weibull_curve(fitParameters, timePoints);



plot(ax(inhAx), ssdArray, stopRespondMean, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 9)
errorbar(ax(inhAx), ssdArray ,stopRespondMean, stopRespondStd, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)
% plot(ax(inhAx), inhGrandMean, 'k', 'linewidth', 2)
plot(ax(inhAx), timePoints, inhPop, 'k', 'linewidth', 2)
xlim([0 max(ssdArray(:))])
ylim([0 1])
% set(ax(inhAx), 'xtick', ssdArray)
% set(ax(inhAx), 'xtickLabel', ssdArray*1000)
















%%
% ****************************************************************************************
% Population Inhibition Funciton: within ech signal strength:
% ****************************************************************************************
task = 'ccm';
subjectID = 'Human';
% subjectID = 'Broca';
% subjectID = 'Xena';

switch subjectID
    case 'Human'
        signalStrength = [.35 .42 .46 .5 .54 .58 .65];
    case 'Broca'
        signalStrength = [.41 .45 .48 .5 .52 .55 .59];
    case 'Xena'
        signalStrength = [.35 .42 .47 .5 .53 .58 .65];
end
[sessionArray, subjectIDArray] = task_session_array(subjectID, task);
% signalStrength = unique([populationData.signalStrengthLeft{1}, populationData.signalStrengthRight{1}])';



nSession = length(sessionArray);
nRow = 3;
nColumn = 2;
inhAx = 1;
% [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = model_figure(nRow, nColumn, 9898, 'screen');
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(inhAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
hold(ax(inhAx))

ssdArray = [];
nStop = [];
nStopStop = [];
nStopTarg = [];
nStopDist = [];
ssdMax = max(cellfun(@max, populationData.ssdArray));
for iSession = 1 : nSession
    
    
    iData = ccm_inhibition(subjectIDArray{iSession}, sessionArray{iSession}, 0);
    
    
    % Initialize arrays to be filled with stop trial numbers/ssd's for each
    % session
    iSSDN = nan(1, ssdMax);
    [iStopStopN, iStopTargN, iStopDistN] = deal(nan(length(signalStrength), 1200));
    
    
    iSSD = iData.ssdArray;
    iSSDN(iSSD) = iSSD;
    ssdArray = [ssdArray; iSSDN];
    
    iStopStopN(:, iSSD) = iData.nStopStop;
    iStopTargN(:, iSSD) = iData.nStopTarg;
    iStopDistN(:, iSSD) = iData.nStopDist;
    
    %     nStop = cat(3, nStop, populationData.nStop{i});
    nStopStop = cat(3, nStopStop, iStopStopN);
    nStopTarg = cat(3, nStopTarg, iStopTargN);
    nStopDist = cat(3, nStopDist, iStopDistN);
end
ssdArray = nanmean(ssdArray, 1);
ssdArray(isnan(ssdArray)) = [];
size(nStopTarg)
size(nStopDist)
nStopTarg(isnan(nStopTarg)) = 0;  % change NaNs to zeros here since they will be numerators below
nStopDist(isnan(nStopDist)) = 0;  % change NaNs to zeros here since they will be numerators below
% nStopRespond(isnan(nStopRespond)) = 0;  % change NaNs to zeros here since they will be numerators below
nStopRespond = nStopTarg + nStopDist;


% Session by session method: use this to take the average pResponse over
% sessions:
pStopRespond = nStopRespond ./ (nStopRespond + nStopStop);
pStopRespond = nanmean(pStopRespond, 3);

% % Collapse across sessions method: use this to treat all sessions as if
% % they were one big session
% nStopRespond = nansum(nStopRespond, 3);
% nStopStop = nansum(nStopStop, 3);
% pStopRespond = nStopRespond ./ (nStopRespond + nStopStop);


pStopRespond(:, isnan(pStopRespond(1,:))) = [];


minColorGun = .25;
maxColorGun = 1;
for iPropIndex = 1 : length(signalStrength);
    iPercent = signalStrength(iPropIndex) * 100;
    
    % Determine color to use for plot based on which checkerboard color
    % proportion being used. Normalize the available color spectrum to do
    % it
    if iPercent == 50
        inhColor = [0 0 0];
    elseif iPercent < 50
        colorNorm = .5 - signalStrength(1);
        colorProp = (.5 - signalStrength(iPropIndex)) / colorNorm;
        colorGun = minColorGun + (maxColorGun - minColorGun) * colorProp;
        inhColor = [0 colorGun colorGun];
    elseif iPercent > 50
        colorNorm = signalStrength(end) - .5;
        colorProp = (signalStrength(iPropIndex) - .5) / colorNorm;
        colorGun = minColorGun + (maxColorGun - minColorGun) * colorProp;
        inhColor = [colorGun 0 colorGun];
    end
    
    [fitParameters, lowestSSE] = Weibull(ssdArray, pStopRespond(iPropIndex, :));
    %     timePoints = ssdArray(1) : ssdArray(end);
    timePoints = ssdArray(1) : 600;
    inhPop = weibull_curve(fitParameters, timePoints);
    
    
    
    
    % plot(ax(inhAx), ssdArray, pStopRespond, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 9)
    % errorbar(ax(inhAx), ssdArray ,stopRespondMean, stopRespondStd, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)
    plot(ax(inhAx), timePoints, inhPop, 'color', inhColor, 'linewidth', 2)
    xlim([0 600])
    ylim([0 1])
    % set(ax(inhAx), 'xtick', ssdArray)
    % set(ax(inhAx), 'xtickLabel', ssdArray*1000)
end












%%
% ****************************************************************************************
% Population Inhibition Funciton:   ZRFT
% ****************************************************************************************

% load ccm_population_monkey
% signalStrengthLeft = [.41 .45 .48 .5];
% signalStrengthRight = [.5 .52 .55 .58];
load ccm_population_human
signalStrengthLeft = [.35 .42 .46 .5];
signalStrengthRight = [.5 .54 .58 .65];

nSession = size(populationData, 1);
nRow = 3;
nColumn = 2;
inhAx = 1;
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(inhAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
hold(ax(inhAx), 'on')

for i = 1 : nSession
    goTargRT = [];
    goDistRT = [];
    for s = 1 : length(signalStrengthLeft)
        goTargRT = [goTargRT; populationData.goRightToTarg{i}{s}; populationData.goLeftToTarg{i}{s}];
        goDistRT = [goDistRT; populationData.goRightToDist{i}{s}; populationData.goLeftToDist{i}{s}];
    end
    
    zrft{i} = (nanmean([goTargRT; goDistRT]) - populationData.ssdArray{i} - populationData.ssrtGrand{i}) / nanstd([goTargRT; goDistRT]);
    [fitParameters, lowestSSE] = Weibull(fliplr(zrft{i}), populationData.stopRespondProbGrand{i});
    timePoints = zrft{i}(1) : zrft{i}(end);
    inhTrans{i} = weibull_curve(fitParameters, timePoints);
    
    zrft{i}
    populationData.stopRespondProbGrand{i}
    % plot(ax(inhAx), flipud(zrft{i}), populationData.stopRespondProbGrand{i}, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
    plot(ax(inhAx), flipud(zrft{i}), populationData.stopRespondProbGrand{i}, '-k')
    %     plot(ax(inhAx), timePoints-20, inhTrans{i}, 'k', 'linewidth', 2)
    pause
end
% xlim([0 600])
ylim([0 1])
% set(ax(inhAx), 'xtick', ssdArray)
% set(ax(inhAx), 'xtickLabel', ssdArray*1000)


%
% inhGrand = [];
% stopRespond = [];
% for i = 1 : nSession
%     iSSD = populationData.ssdArray{i};
%     iInh = [nan(1, iSSD(1)-1), populationData.inhibitionFnGrand{i}];
%
% %     if length(iInh) < 902 +iSSD(1)-1
%         iInh(end+1 : 1200) = nan;
% %     end
%     inhGrand = [inhGrand; iInh];
%
%     iStopRespond = populationData.stopRespondProbGrand{i}';
%     if length(iStopRespond) < 10
%         iStopRespond(end+1 : 10) = nan;
%     else
%         ssdArray = populationData.ssdArray{i};
%     end
%     stopRespond = [stopRespond; iStopRespond];
% end
% inhGrandMean = nanmean(inhGrand, 1)
% stopRespondMean = nanmean(stopRespond, 1)
% stopRespondStd = nanstd(stopRespond, 1)
%
% plot(ax(inhAx), ssdArray, stopRespondMean, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
% errorbar(ax(inhAx), ssdArray ,stopRespondMean, stopRespondStd, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)
% plot(ax(inhAx), inhGrandMean, 'k', 'linewidth', 2)
% xlim([0 600])
% ylim([0 1])
%     set(ax(inhAx), 'xtick', ssdArray)
%     set(ax(inhAx), 'xtickLabel', ssdArray*1000)















%%
% ****************************************************************************************
% Population CDF
% ****************************************************************************************
task = 'ccm';
subjectID = 'Human';
% subjectID = 'Broca';
% subjectID = 'Xena';

switch subjectID
    case 'Human'
        signalStrength = [.35 .42 .46 .5 .54 .58 .65];
    case 'Broca'
        signalStrength = [.41 .45 .48 .5 .52 .55 .59];
    case 'Xena'
        signalStrength = [.35 .42 .47 .5 .53 .58 .65];
end
[sessionArray, subjectIDArray] = task_session_array(subjectID, task);
% signalStrength = unique([populationData.signalStrengthLeft{1}, populationData.signalStrengthRight{1}])';


nSession = length(sessionArray);
nRow = 3;
nColumn = 2;
cumAx = 1;
distAx = 2;
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(cumAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
ax(distAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 2) yAxesPosition(1, 2) axisWidth axisHeight]);
hold(ax(cumAx), 'on')
hold(ax(distAx), 'on')
stopColor = [.5 .5 .5];
goColor = [0 0 0];
switch subjectID
    case 'Human'
        set(ax(cumAx), 'Xlim', [300 1000])
    case 'Broca'
        set(ax(cumAx), 'Xlim', [150 550])
    case 'Xena'
        set(ax(cumAx), 'Xlim', [150 550])
end


% Cumulative RT functions:
goTargRT = [];
goDistRT = [];
stopTargRT = [];
stopDistRT = [];
signalStrengthLeft  = signalStrength(1:4);

for iSession = 1 : nSession
    
    iData = ccm_chronometric(subjectIDArray{iSession}, sessionArray{iSession}, 'plotFlag', 0);
    
    for s = 1 : length(signalStrengthLeft)
        
        
        goTargRT = [goTargRT; iData.goLeftToTarg{s}; iData.goRightToTarg{s}];
        goDistRT = [goDistRT; iData.goLeftToDist{s}; iData.goRightToDist{s}];
        stopTargRT = [stopTargRT; cell2mat(iData.stopRightToTarg(:,s)); cell2mat(iData.stopLeftToTarg(:,s))];
        stopDistRT = [stopDistRT; cell2mat(iData.stopRightToDist(:,s)); cell2mat(iData.stopLeftToDist(:,s))];
        
        % % Go data
        %     goLeftToTarg =  [goLeftToTarg; cellfun(@nanmean, iData.goLeftToTarg)];
        %     goRightToTarg = [goRightToTarg; cellfun(@nanmean, iData.goRightToTarg)];
        %     goLeftToDist =  [goLeftToDist; cellfun(@nanmean, iData.goLeftToDist)];
        %     goRightToDist = [goRightToDist; cellfun(@nanmean, iData.goRightToDist)];
        %
        %
        %     % Stop data
        %     iStopLeftToTarg = [nanmean(cell2mat(iData.stopLeftToTarg(:,1))), nanmean(cell2mat(iData.stopLeftToTarg(:,2))), nanmean(cell2mat(iData.stopLeftToTarg(:,3))), nanmean(cell2mat(iData.stopLeftToTarg(:,4)))];
        %     iStopRightToTarg = [nanmean(cell2mat(iData.stopRightToTarg(:,1))), nanmean(cell2mat(iData.stopRightToTarg(:,2))), nanmean(cell2mat(iData.stopRightToTarg(:,3))), nanmean(cell2mat(iData.stopRightToTarg(:,4)))];
        %     iStopLeftToDist = [nanmean(cell2mat(iData.stopLeftToDist(:,1))), nanmean(cell2mat(iData.stopLeftToDist(:,2))), nanmean(cell2mat(iData.stopLeftToDist(:,3))), nanmean(cell2mat(iData.stopLeftToDist(:,4)))];
        %     iStopRightToDist = [nanmean(cell2mat(iData.stopRightToDist(:,1))), nanmean(cell2mat(iData.stopRightToDist(:,2))), nanmean(cell2mat(iData.stopRightToDist(:,3))), nanmean(cell2mat(iData.stopRightToDist(:,4)))];
        %
        %     stopLeftToTarg = [stopLeftToTarg; iStopLeftToTarg];
        %     stopRightToTarg = [stopRightToTarg; iStopRightToTarg];
        %     stopLeftToDist = [stopLeftToDist; iStopLeftToDist];
        %     stopRightToDist = [stopRightToDist; iStopRightToDist];
    end
end

%     for i = 1 : nSession
%     for s = 1 : length(signalStrengthLeft)
%         goTargRT = [goTargRT; populationData.goRightToTarg{i}{s}; populationData.goLeftToTarg{i}{s}];
%         goDistRT = [goDistRT; populationData.goRightToDist{i}{s}; populationData.goLeftToDist{i}{s}];
%         stopTargRT = [stopTargRT; populationData.stopRightToTarg{i}{s}; populationData.stopLeftToTarg{i}{s}];
%         stopDistRT = [stopDistRT; populationData.stopRightToDist{i}{s}; populationData.stopLeftToDist{i}{s}];
%     end
% end
goTargRT = sort(goTargRT);
goDistRT = sort(goDistRT);
stopTargRT = sort(stopTargRT);
stopDistRT = sort(stopDistRT);

goTargRT(isnan(goTargRT)) = [];
goDistRT(isnan(goDistRT)) = [];
stopTargRT(isnan(stopTargRT)) = [];
stopDistRT(isnan(stopDistRT)) = [];

iRTIndex = 1;
% for i = min(goRT) : max(goRT)
for iMS = 1:1200
    propGoTargRT(iRTIndex) = sum(goTargRT <= iMS) / length(goTargRT);
    propGoDistRT(iRTIndex) = sum(goDistRT <= iMS) / length(goDistRT);
    propStopTargRT(iRTIndex) = sum(stopTargRT <= iMS) / length(stopTargRT);
    propStopDistRT(iRTIndex) = sum(stopDistRT <= iMS) / length(stopDistRT);
    iRTIndex = iRTIndex + 1;
end
% if sum(ijStopIncorrectTrialIndices)
%     stopRT = sort(stopIncorrectRT);
%     iRTIndex = 1;
%     for i = min(stopRT) : max(stopRT)
%         propStopTargRT(iRTIndex) = sum(stopTargRT <= i) / length(stopTargRT);
%         iRTIndex = iRTIndex + 1;
%     end
% end
%
% for i = 1 : nSession
%     cla
%     plot([populationData.ssdArray{i}(1): populationData.ssdArray{i}(end)], populationData.inhibitionFnGrand{i})
%     plot(populationData.ssdArray{i}, populationData.stopRespondProbGrand{i}, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
%  pause
% end
[h,p] = kstest2(propGoTargRT, propGoDistRT);
fprintf('Kolmogorov-Smirnov test:  Go Correct vs Go Incorrect: p = %1.2d\n', p)
[h,p] = kstest2(propStopTargRT, propStopDistRT);
fprintf('Kolmogorov-Smirnov test:  Stop Correct vs Stop Incorrect: p = %1.2d\n', p)
[h,p] = kstest2(propGoTargRT, propStopTargRT);
fprintf('Kolmogorov-Smirnov test:  Go Correct vs Stop Correct: p = %1.2d\n', p)
[h,p] = kstest2(propGoDistRT, propStopDistRT);
fprintf('Kolmogorov-Smirnov test:  Go Incorrect vs Stop Incorrect: p = %1.2d\n', p)


box(ax(cumAx), 'off')
plot(ax(cumAx), propGoTargRT, 'color', goColor)
plot(ax(cumAx), propGoDistRT, '--', 'color', goColor)

plot(ax(cumAx), propStopTargRT, 'color', stopColor)
plot(ax(cumAx), propStopDistRT, '--', 'color', stopColor)
legend(ax(cumAx), {'Go Target', 'Go Distractor', 'Stop Target', 'Stop Distractor'}, 'location', 'southeast');





nBin = 40;
goRT = [goTargRT; goDistRT];
% Go RT Distribution
timeStep = (max(goRT) - min(goRT)) / nBin;
goRTBinValues = hist(goRT, nBin);
distributionArea = sum(goRTBinValues * timeStep);
goCorrectPDF = goRTBinValues / distributionArea;
goCorrectBinCenters = min(goRT)+timeStep/2 : timeStep : max(goRT)-timeStep/2;

plot(ax(distAx), goCorrectBinCenters, goCorrectPDF, '-k', 'linewidth', 2)
set(ax(distAx), 'xlim', [300 1000])


















%%
% *************************************************************************
% Populaiton CHOICE W.R.T. STOPPING :
% *************************************************************************
fprintf('\n\n\n\n')
disp('*******************************************************************************')
disp('Populaiton CHOICE W.R.T. STOPPING :')


task = 'ccm';
subjectID = 'Human';
% subjectID = 'Broca';
% subjectID = 'Xena';

switch subjectID
    case 'Human'
        signalStrength = [.35 .42 .46 .5 .54 .58 .65];
    case 'Broca'
        signalStrength = [.41 .45 .48 .5 .52 .55 .59];
    case 'Xena'
        signalStrength = [.35 .42 .47 .5 .53 .58 .65];
end
[sessionArray, subjectIDArray] = task_session_array(subjectID, task);
% signalStrength = unique([populationData.signalStrengthLeft{1}, populationData.signalStrengthRight{1}])';


timeConst = 5;
trialLag = 20;

nSession = length(sessionArray);
nRow = 2;
nColumn = 2;
axSDGo = 1;
axSDStop = 2;
axELGo = 3;
axELStop = 4;
figureHandle = 9898;
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = big_figure(nRow, nColumn, figureHandle, 'save');
clf
% [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', figureHandle);
ax(axSDGo) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
ax(axSDStop) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 2) yAxesPosition(1, 2) axisWidth axisHeight]);
ax(axELGo) = axes('units', 'centimeters', 'position', [xAxesPosition(2, 1) yAxesPosition(2, 1) axisWidth axisHeight]);
ax(axELStop) = axes('units', 'centimeters', 'position', [xAxesPosition(2, 2) yAxesPosition(2, 2) axisWidth axisHeight]);

%Colors
stopEarlyColor = [0 0 0];
stopLateColor = [1 0 0];
stopLateMatchColor = [.8 .3 .3];
goEarlyColor = [0 0 0];
goLateColor = [0 0 1];
goLateMatchColor = [.3 .3 .8];

stopSparseColor = [0 0 0];
stopDenseColor = [1 0 0];
stopDenseMatchColor = [.8 .3 .3];
goSparseColor = [0 0 0];
goDenseColor = [0 0 1];
goDenseMatchColor = [.3 .3 .8];


hold(ax(axSDGo), 'on')
hold(ax(axSDStop), 'on')
hold(ax(axELGo), 'on')
hold(ax(axELStop), 'on')
choicePlotXMargin = .03;






goRightSparseProb = [];
goSparseSlope = [];
goRightDenseProb = [];
goDenseSlope = [];
goRightDenseMatchProb = [];
goDenseMatchSlope = [];

stopRightSparseProb = [];
stopSparseSlope = [];
stopRightDenseProb = [];
stopDenseSlope = [];
stopRightDenseMatchProb = [];
stopDenseMatchSlope = [];


goRightEarlyProb = [];
goEarlySlope = [];
goRightLateProb = [];
goLateSlope = [];
goRightLateMatchProb = [];
goLateMatchSlope = [];

stopRightEarlyProb = [];
stopEarlySlope = [];
stopRightLateProb = [];
stopLateSlope = [];
stopRightLateMatchProb = [];
stopLateMatchSlope = [];

for iSession = 1 : nSession
    
    
    iDataEL = ccm_choice_wrt_ssd(subjectIDArray{iSession}, sessionArray{iSession}, trialLag, timeConst, 0);
    iDataSD = ccm_choice_wrt_stop_pct(subjectIDArray{iSession}, sessionArray{iSession}, trialLag, timeConst, 0);
    
    
    
    
    goRightSparseProb = [goRightSparseProb; iDataSD.nGoSparseRight ./ iDataSD.nGoSparse];
    goSparseSlope = [goSparseSlope; iDataSD.goRightSlopeSparse];
    
    goRightDenseProb = [goRightDenseProb; iDataSD.nGoDenseRight ./ iDataSD.nGoDense];
    goDenseSlope = [goDenseSlope; iDataSD.goRightSlopeDense];
    
    goRightDenseMatchProb = [goRightDenseMatchProb; iDataSD.nGoDenseMatchRight ./ iDataSD.nGoDenseMatch];
    goDenseMatchSlope = [goDenseMatchSlope; iDataSD.goRightSlopeDenseMatch];
    
    stopRightSparseProb = [stopRightSparseProb; iDataSD.nStopSparseRight ./ iDataSD.nStopSparse];
    stopSparseSlope = [stopSparseSlope; iDataSD.stopRightSlopeSparse];
    
    stopRightDenseProb = [stopRightDenseProb; iDataSD.nStopDenseRight ./ iDataSD.nStopDense];
    stopDenseSlope = [stopDenseSlope; iDataSD.stopRightSlopeDense];
    
    stopRightDenseMatchProb = [stopRightDenseMatchProb; iDataSD.nStopDenseMatchRight ./ iDataSD.nStopDenseMatch];
    stopDenseMatchSlope = [stopDenseMatchSlope; iDataSD.stopRightSlopeDenseMatch];
    
    
    
    
    
    goRightEarlyProb = [goRightEarlyProb; iDataEL.nGoEarlyRight ./ iDataEL.nGoEarly];
    goEarlySlope = [goEarlySlope; iDataEL.goRightSlopeEarly];
    
    goRightLateProb = [goRightLateProb; iDataEL.nGoLateRight ./ iDataEL.nGoLate];
    goLateSlope = [goLateSlope; iDataEL.goRightSlopeLate];
    
    goRightLateMatchProb = [goRightLateMatchProb; iDataEL.nGoLateRightMatchRT ./ iDataEL.nGoLateMatchRT];
    goLateMatchSlope = [goLateMatchSlope; iDataEL.goRightSlopeLateMatch];
    
    stopRightEarlyProb = [stopRightEarlyProb; iDataEL.nStopEarlyRight ./ iDataEL.nStopEarly];
    stopEarlySlope = [stopEarlySlope; iDataEL.stopRightSlopeEarly];
    
    stopRightLateProb = [stopRightLateProb; iDataEL.nStopLateRight ./ iDataEL.nStopLate];
    stopLateSlope = [stopLateSlope; iDataEL.stopRightSlopeLate];
    
    stopRightLateMatchProb = [stopRightLateMatchProb; iDataEL.nStopLateRightMatchRT ./ iDataEL.nStopLateMatchRT];
    stopLateMatchSlope = [stopLateMatchSlope; iDataEL.stopRightSlopeLateMatch];
    
end



signalStrengthFit = repmat(signalStrength, size(goRightDenseProb, 1), 1);


% Sparse/Dense ANOVAs
disp('*********   Sparse vs. Dense  Stop Trial % *********')
% On prbability points
anovaData = [];
groupInh = {};
groupSD = {};
groupSig = [];
for i = 1 : length(signalStrength)
    anovaData = [anovaData; goRightSparseProb(:,i); goRightDenseProb(:,i)];
    groupInh = [groupInh; repmat({'go'}, length(goRightSparseProb(:,i)) + length(goRightDenseProb(:,i)), 1)];
    groupSD = [groupSD; repmat({'sparse'}, length(goRightSparseProb(:,i)), 1); repmat({'dense'}, length(goRightDenseProb(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(goRightSparseProb(:,i)) + length(goRightDenseProb(:,i)), 1)];
    
    anovaData = [anovaData; stopRightSparseProb(:,i); stopRightDenseProb(:,i)];
    groupInh = [groupInh; repmat({'stop'}, length(stopRightSparseProb(:,i)) + length(stopRightDenseProb(:,i)), 1)];
    groupSD = [groupSD; repmat({'sparse'}, length(stopRightSparseProb(:,i)), 1); repmat({'dense'}, length(stopRightDenseProb(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(stopRightSparseProb(:,i)) + length(stopRightDenseProb(:,i)), 1)];
    
end
[p,table,stats] = anovan(anovaData,{groupInh, groupSig, groupSD}, 'varnames', {'Stop/Go', 'Signal', 'Sparse/Dense'}, 'model', 'full', 'display', 'off');
% [p,table,stats] = anovan(anovaData,{groupInh, groupSig, groupSD}, 'varnames', {'Stop/Go', 'Signal', 'Sparse/Dense'}, 'display', 'off');
fprintf('ANOVA:\nStop vs. Go: \t\tp = %.3f\nSignal Strength: \tp = %.3f\nSparse vs. Dense: \tp = %.3f\n', p(1), p(2), p(3))
disp(table)
eta2Sig = table{4,2} / (table{4,2} + table{end,2})


anovaData = [goSparseSlope; goDenseSlope; stopSparseSlope; stopDenseSlope];
groupInh = [repmat({'go'}, length(goSparseSlope) + length(goDenseSlope), 1); repmat({'stop'}, length(stopSparseSlope) + length(stopDenseSlope), 1)];
groupSD = [repmat({'sparse'}, length(goSparseSlope), 1); repmat({'dense'}, length(goDenseSlope), 1); repmat({'sparse'}, length(stopSparseSlope), 1); repmat({'dense'}, length(stopDenseSlope), 1)];

[p,table,stats] = anovan(anovaData,{groupInh, groupSD}, 'display', 'off');
% fprintf('\n\n %s \n', iSubjectID)
fprintf('SLOPES ANOVA:\nSparse/Dense: %.3f \t Go/Stop: %.3f\n', p(2), p(1))


% Using latency matched Dense data
anovaData = [];
groupInh = {};
groupSD = {};
groupSig = [];
for i = 1 : length(signalStrength)
    anovaData = [anovaData; goRightSparseProb(:,i); goRightDenseMatchProb(:,i)];
    groupInh = [groupInh; repmat({'go'}, length(goRightSparseProb(:,i)) + length(goRightDenseMatchProb(:,i)), 1)];
    groupSD = [groupSD; repmat({'sparse'}, length(goRightSparseProb(:,i)), 1); repmat({'dense'}, length(goRightDenseMatchProb(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(goRightSparseProb(:,i)) + length(goRightDenseMatchProb(:,i)), 1)];
    
    anovaData = [anovaData; stopRightSparseProb(:,i); stopRightDenseMatchProb(:,i)];
    groupInh = [groupInh; repmat({'stop'}, length(stopRightSparseProb(:,i)) + length(stopRightDenseMatchProb(:,i)), 1)];
    groupSD = [groupSD; repmat({'sparse'}, length(stopRightSparseProb(:,i)), 1); repmat({'dense'}, length(stopRightDenseMatchProb(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(stopRightSparseProb(:,i)) + length(stopRightDenseMatchProb(:,i)), 1)];
    
end
[p,table,stats] = anovan(anovaData,{groupInh, groupSig, groupSD}, 'varnames', {'Stop/Go', 'Signal', 'Sparse/Dense Match'}, 'model', 'full', 'display', 'off');
eta2Sig = table{4,2} / (table{4,2} + table{end,2})
fprintf('ANOVA:\nStop vs. Go: \t\tp = %.3f\nSignal Strength: \tp = %.3f\nSparse Dense Match: \tp = %.3f\n', p(1), p(2), p(3))
disp(table)


anovaData = [goSparseSlope; goDenseMatchSlope; stopSparseSlope; stopDenseMatchSlope];
groupInh = [repmat({'go'}, length(goSparseSlope) + length(goDenseMatchSlope), 1); repmat({'stop'}, length(stopSparseSlope) + length(stopDenseMatchSlope), 1)];
groupSD = [repmat({'sparse'}, length(goSparseSlope), 1); repmat({'dense'}, length(goDenseMatchSlope), 1); repmat({'sparse'}, length(stopSparseSlope), 1); repmat({'dense'}, length(stopDenseMatchSlope), 1)];

[p,table,stats] = anovan(anovaData,{groupInh, groupSD}, 'display', 'off');
% fprintf('\n\n %s \n', iSubjectID)
fprintf('SLOPES ANOVA:\nSparse/Dense Match: %.3f \t Go/Stop: %.3f\n', p(2), p(1))
fprintf('\nSLOPES Values:\nGo: Sparse: %.2f Dense: %.2f Dense Match: %.2f \t Stop: Sparse: %.2f Dense: %.2f Dense Match:  %.2f\n\n\n',...
    nanmean(goSparseSlope), nanmean(goDenseSlope), nanmean(goDenseMatchSlope), nanmean(stopSparseSlope), nanmean(stopDenseSlope), nanmean(stopDenseMatchSlope))



% Collect data in different format for SPSS Repeated measures ANOVA

psyDataSession = [];
groupSession = [];
for iSession = 1 : nSession
psyData = [];
group = [];
for i = 1 : nSignalStrength
    psyData = [psyData; goRightSparseProb(iSession,i); goRightDenseProb(iSession,i)];
    group = [group; {['goSparse',num2str(i)]}; {['goDense',num2str(i)]}];
    psyData = [psyData; stopRightSparseProb(iSession,i); stopRightDenseProb(iSession,i)];
    group = [group; {['stopSparse',num2str(i)]}; {['stopDense',num2str(i)]}];
end
psyDataSession = [psyDataSession, psyData];
groupSession = [groupSession, group];
end

psyDataMatchSession = [];
groupSession = [];
for iSession = 1 : nSession
psyMatchData = [];
group = [];
for i = 1 : nSignalStrength
    psyMatchData = [psyMatchData; goRightSparseProb(iSession,i); goRightDenseMatchProb(iSession,i)];
    group = [group; {['goSparseMatch',num2str(i)]}; {['goDenseMatch',num2str(i)]}];
    psyMatchData = [psyMatchData; stopRightSparseProb(iSession,i); stopRightDenseMatchProb(iSession,i)];
    group = [group; {['stopSparseMatch',num2str(i)]}; {['stopDenseMatch',num2str(i)]}];
end
psyDataMatchSession = [psyDataMatchSession, psyMatchData];
groupSession = [groupSession, group];
end









% Early/Late ANOVAs
disp('*********   Early vs. Late SSDs   *********')
% On prbability points
anovaData = [];
groupInh = {};
groupEL = {};
groupSig = [];
for i = 1 : length(signalStrength)
    anovaData = [anovaData; stopRightEarlyProb(:,i); stopRightLateProb(:,i)];
    groupInh = [groupInh; repmat({'stop'}, length(stopRightEarlyProb(:,i)) + length(stopRightLateProb(:,i)), 1)];
    groupEL = [groupEL; repmat({'early'}, length(stopRightEarlyProb(:,i)), 1); repmat({'late'}, length(stopRightLateProb(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(stopRightEarlyProb(:,i)) + length(stopRightLateProb(:,i)), 1)];
    
    anovaData = [anovaData; goRightEarlyProb(:,i); goRightLateProb(:,i)];
    groupInh = [groupInh; repmat({'go'}, length(goRightEarlyProb(:,i)) + length(goRightLateProb(:,i)), 1)];
    groupEL = [groupEL; repmat({'early'}, length(goRightEarlyProb(:,i)), 1); repmat({'late'}, length(goRightLateProb(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(goRightEarlyProb(:,i)) + length(goRightLateProb(:,i)), 1)];
end
[p,table,stats] = anovan(anovaData,{groupInh, groupSig, groupEL}, 'varnames', {'Stop/Go', 'Signal', 'Early/Late'}, 'model', 'full', 'display', 'off');
fprintf('ANOVA:\nStop vs. Go: \t\tp = %.3f\nSignal Strength: \tp = %.3f\nEarly vs. Late: \tp = %.3f\n', p(1), p(2), p(3))
disp(table)


% On psychometric fn slopes
anovaData = [goEarlySlope; goLateSlope; stopEarlySlope; stopLateSlope];
groupInh = [repmat({'go'}, length(goEarlySlope) + length(goLateSlope), 1); repmat({'stop'}, length(stopEarlySlope) + length(stopLateSlope), 1)];
groupEL = [repmat({'early'}, length(goEarlySlope), 1); repmat({'late'}, length(goLateSlope), 1); repmat({'early'}, length(stopEarlySlope), 1); repmat({'late'}, length(stopLateSlope), 1)];

[p,table,stats] = anovan(anovaData,{groupInh, groupEL}, 'display', 'off');
% fprintf('\n\n %s \n', iSubjectID)
% fprintf('ANOVA:\nEarly/Late: %.2f \n', p(1))
fprintf('SLOPES ANOVA:\nEarly/Late: %.2f \t Go/Stop: %.2f\n', p(2), p(1))






% On prbability points
anovaData = [];
groupInh = {};
groupEL = {};
groupSig = [];
for i = 1 : length(signalStrength)
    anovaData = [anovaData; stopRightEarlyProb(:,i); stopRightLateMatchProb(:,i)];
    groupInh = [groupInh; repmat({'stop'}, length(stopRightEarlyProb(:,i)) + length(stopRightLateMatchProb(:,i)), 1)];
    groupEL = [groupEL; repmat({'early'}, length(stopRightEarlyProb(:,i)), 1); repmat({'late'}, length(stopRightLateMatchProb(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(stopRightEarlyProb(:,i)) + length(stopRightLateMatchProb(:,i)), 1)];
    
    anovaData = [anovaData; goRightEarlyProb(:,i); goRightLateMatchProb(:,i)];
    groupInh = [groupInh; repmat({'go'}, length(goRightEarlyProb(:,i)) + length(goRightLateMatchProb(:,i)), 1)];
    groupEL = [groupEL; repmat({'early'}, length(goRightEarlyProb(:,i)), 1); repmat({'late'}, length(goRightLateMatchProb(:,i)), 1)];
    groupSig = [groupSig; repmat(i, length(goRightEarlyProb(:,i)) + length(goRightLateMatchProb(:,i)), 1)];
end
[p,table,stats] = anovan(anovaData,{groupInh, groupSig, groupEL}, 'varnames', {'Stop/Go', 'Signal', 'Early/Late Match'}, 'model', 'full', 'display', 'off');
fprintf('ANOVA:\nStop vs. Go: \t\tp = %.3f\nSignal Strength: \tp = %.3f\nEarly Late Match: \tp = %.3f\n', p(1), p(2), p(3))
disp(table)

% On psychometric fn slopes
anovaData = [goEarlySlope; goLateMatchSlope; stopEarlySlope; stopLateMatchSlope];
groupInh = [repmat({'go'}, length(goEarlySlope) + length(goLateMatchSlope), 1); repmat({'stop'}, length(stopEarlySlope) + length(stopLateMatchSlope), 1)];
groupEL = [repmat({'early'}, length(goEarlySlope), 1); repmat({'late'}, length(goLateMatchSlope), 1); repmat({'early'}, length(stopEarlySlope), 1); repmat({'late'}, length(stopLateMatchSlope), 1)];

[p,table,stats] = anovan(anovaData,{groupInh, groupEL}, 'display', 'off');
% fprintf('\n\n %s \n', iSubjectID)
% fprintf('ANOVA:\nEarly/Late Matched: %.2f \n', p(1))
fprintf('SLOPES ANOVA:\nEarly/Late Match: %.2f \t Go/Stop: %.2f\n', p(2), p(1))


fprintf('\nSLOPES Values:\nGo: Early: %.2f Late: %.2f Late Match: %.2f \t Stop: Early: %.2f Late: %.2f Late Match:  %.2f\n',...
    nanmean(goEarlySlope), nanmean(goLateSlope), nanmean(goLateMatchSlope), nanmean(stopEarlySlope), nanmean(stopLateSlope), nanmean(stopLateMatchSlope))




% SPARSE DENSE
% ******************  Go   ******************
goRightSparseProbMean = nanmean(goRightSparseProb, 1);
goRightSparseProbStd = nanstd(goRightSparseProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(goRightSparseProb)), goRightSparseProb(~isnan(goRightSparseProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, goRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
goPsyFnSparse = weibull_curve(fitParameters, propPoints);

goRightDenseProbMean = nanmean(goRightDenseProb, 1);
goRightDenseProbStd = nanstd(goRightDenseProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(goRightDenseProb)), goRightDenseProb(~isnan(goRightDenseProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, goRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
goPsyFnDense = weibull_curve(fitParameters, propPoints);

goRightDenseMatchProbMean = nanmean(goRightDenseMatchProb, 1);
goRightDenseMatchProbStd = nanstd(goRightDenseMatchProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(goRightDenseMatchProb)), goRightDenseMatchProb(~isnan(goRightDenseMatchProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, goRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
goPsyFnDenseMatch = weibull_curve(fitParameters, propPoints);


% ******************  Stop   ******************
stopRightSparseProbMean = nanmean(stopRightSparseProb, 1);
stopRightSparseProbStd = nanstd(stopRightSparseProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(stopRightSparseProb)), stopRightSparseProb(~isnan(stopRightSparseProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, stopRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
stopPsyFnSparse = weibull_curve(fitParameters, propPoints);

stopRightDenseProbMean = nanmean(stopRightDenseProb, 1);
stopRightDenseProbStd = nanstd(stopRightDenseProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(stopRightDenseProb)), stopRightDenseProb(~isnan(stopRightDenseProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, stopRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
stopPsyFnDense = weibull_curve(fitParameters, propPoints);

stopRightDenseMatchProbMean = nanmean(stopRightDenseMatchProb, 1);
stopRightDenseMatchProbStd = nanstd(stopRightDenseMatchProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(stopRightDenseMatchProb)), stopRightDenseMatchProb(~isnan(stopRightDenseMatchProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, stopRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
stopPsyFnDenseMatch = weibull_curve(fitParameters, propPoints);





% EARLY LATE
% ******************  Stop   ******************
stopRightEarlyProbMean = nanmean(stopRightEarlyProb, 1);
stopRightEarlyProbStd = std(stopRightEarlyProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(stopRightEarlyProb)), stopRightEarlyProb(~isnan(stopRightEarlyProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, stopRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
stopPsyFnEarly = weibull_curve(fitParameters, propPoints);

stopRightLateProbMean = nanmean(stopRightLateProb, 1);
stopRightLateProbStd = std(stopRightLateProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(stopRightLateProb)), stopRightLateProb(~isnan(stopRightLateProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, stopRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
stopPsyFnLate = weibull_curve(fitParameters, propPoints);

stopRightLateMatchProbMean = nanmean(stopRightLateMatchProb, 1);
stopRightLateMatchProbStd = std(stopRightLateMatchProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(stopRightLateMatchProb)), stopRightLateMatchProb(~isnan(stopRightLateMatchProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, stopRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
stopPsyFnLateMatch = weibull_curve(fitParameters, propPoints);


% ******************  Go   ******************
goRightEarlyProbMean = nanmean(goRightEarlyProb, 1);
goRightEarlyProbStd = std(goRightEarlyProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(goRightEarlyProb)), goRightEarlyProb(~isnan(goRightEarlyProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, goRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
goPsyFnEarly = weibull_curve(fitParameters, propPoints);

goRightLateProbMean = nanmean(goRightLateProb, 1);
goRightLateProbStd = std(goRightLateProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(goRightLateProb)), goRightLateProb(~isnan(goRightLateProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, goRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
goPsyFnLate = weibull_curve(fitParameters, propPoints);

goRightLateMatchProbMean = nanmean(goRightLateMatchProb, 1);
goRightLateMatchProbStd = std(goRightLateMatchProb, 1);

[fitParameters, lowestSSE] = psychometric_weibull_fit(signalStrengthFit(~isnan(goRightLateMatchProb)), goRightLateMatchProb(~isnan(goRightLateMatchProb)));
% [fitParameters, lowestSSE] = Weibull(signalStrength*100, goRightProbMean);
propPoints = signalStrength(1) : .001 : signalStrength(end);
goPsyFnLateMatch = weibull_curve(fitParameters, propPoints);









plot(ax(axSDStop), signalStrength, stopRightSparseProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', stopSparseColor, 'linewidth' , 2, 'markerfacecolor', stopSparseColor, 'markersize', 10)
% errorbar(ax(sdAx), signalStrength ,stopRightProbMean, stopRightProbStd, 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)
sparseStopLine = plot(ax(axSDStop), propPoints, stopPsyFnSparse, '-', 'color', stopSparseColor, 'linewidth' , 2);

plot(ax(axSDStop), signalStrength, stopRightDenseProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', stopDenseColor, 'linewidth' , 2, 'markerfacecolor', stopDenseColor, 'markersize', 10)
% errorbar(ax(sdAx), signalStrength ,stopRightProbMean, stopRightProbStd, 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)
denseStopLine = plot(ax(axSDStop), propPoints, stopPsyFnDense, '-', 'color', stopDenseColor, 'linewidth' , 2);

plot(ax(axSDStop), signalStrength, stopRightDenseMatchProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', stopDenseMatchColor, 'linewidth' , 2, 'markerfacecolor', [1 1 1], 'markersize', 10)
% errorbar(ax(sdAx), signalStrength ,stopRightProbMean, stopRightProbStd, 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)
denseMatchStopLine = plot(ax(axSDStop), propPoints, stopPsyFnDenseMatch, '--', 'color', stopDenseMatchColor, 'linewidth' , 2);
legend([sparseStopLine, denseStopLine, denseMatchStopLine], {'sparse', 'dense', 'dense match'}, 'location', 'northwest')
title(ax(axSDStop), 'Stop Trial %: Sparse vs Dense Stop Trials')

plot(ax(axSDGo), signalStrength, goRightSparseProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', goSparseColor, 'linewidth' , 2, 'markerfacecolor', goSparseColor, 'markersize', 10)
% errorbar(ax(sdAx), signalStrength ,goRightDenseProbMean, goMatchRightProbStd, 'linestyle' , 'none', 'color', goColor, 'linewidth' , 2)
sparseGoLine = plot(ax(axSDGo), propPoints, goPsyFnSparse, '-', 'color', goSparseColor, 'linewidth' , 2);

plot(ax(axSDGo), signalStrength, goRightDenseProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', goDenseColor, 'linewidth' , 2, 'markerfacecolor', goDenseColor, 'markersize', 10)
% errorbar(ax(sdAx), signalStrength ,goRightDenseProbMean, goMatchRightProbStd, 'linestyle' , 'none', 'color', goColor, 'linewidth' , 2)
denseGoLine = plot(ax(axSDGo), propPoints, goPsyFnDense, '-', 'color', goDenseColor, 'linewidth' , 2);

plot(ax(axSDGo), signalStrength, goRightDenseMatchProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', goDenseMatchColor, 'linewidth' , 2, 'markerfacecolor', [1 1 1], 'markersize', 10)
% errorbar(ax(sdAx), signalStrength ,goRightDenseMatchProbMean, goMatchRightProbStd, 'linestyle' , 'none', 'color', goColor, 'linewidth' , 2)
denseMatchGoLine = plot(ax(axSDGo), propPoints, goPsyFnDenseMatch, '--', 'color', goDenseMatchColor, 'linewidth' , 2);
legend([sparseGoLine, denseGoLine, denseMatchGoLine], {'sparse', 'dense', 'dense match'}, 'location', 'northwest')
title(ax(axSDGo), 'Stop Trial %: Sparse vs Dense Go Trials')




plot(ax(axELStop), signalStrength, stopRightEarlyProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', stopEarlyColor, 'linewidth' , 2, 'markerfacecolor', stopEarlyColor, 'markersize', 10)
earlyStopLine = plot(ax(axELStop), propPoints, stopPsyFnEarly, '-', 'color', stopEarlyColor, 'linewidth' , 2);

plot(ax(axELStop), signalStrength, stopRightLateProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', stopLateColor, 'linewidth' , 2, 'markerfacecolor', stopLateColor, 'markersize', 10)
lateStopLine = plot(ax(axELStop), propPoints, stopPsyFnLate, '-', 'color', stopLateColor, 'linewidth' , 2);

plot(ax(axELStop), signalStrength, stopRightLateMatchProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', stopLateMatchColor, 'linewidth' , 2, 'markerfacecolor', [1 1 1], 'markersize', 10)
lateStopMatchLine = plot(ax(axELStop), propPoints, stopPsyFnLateMatch, '--', 'color', stopLateMatchColor, 'linewidth' , 2);
legend([earlyStopLine, lateStopLine, lateStopMatchLine], {'early', 'late', 'late match'}, 'location', 'northwest')
title(ax(axELStop), 'SSDs: Early vs Late Stop Trials')


plot(ax(axELGo), signalStrength, goRightEarlyProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', goEarlyColor, 'linewidth' , 2, 'markerfacecolor', goEarlyColor, 'markersize', 10)
earlyGoLine = plot(ax(axELGo), propPoints, goPsyFnEarly, '-', 'color', goEarlyColor, 'linewidth' , 2);

plot(ax(axELGo), signalStrength, goRightLateProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', goLateColor, 'linewidth' , 2, 'markerfacecolor', goLateColor, 'markersize', 10)
lateGoLine = plot(ax(axELGo), propPoints, goPsyFnLate, '-', 'color', goLateColor, 'linewidth' , 2);

plot(ax(axELGo), signalStrength, goRightLateMatchProbMean, 'o', 'linestyle' , 'none', 'markeredgecolor', goLateMatchColor, 'linewidth' , 2, 'markerfacecolor', [1 1 1], 'markersize', 10)
lateGoMatchLine = plot(ax(axELGo), propPoints, goPsyFnLateMatch, '--', 'color', goLateMatchColor, 'linewidth' , 2);
legend([earlyGoLine, lateGoLine, lateGoMatchLine], {'early', 'late', 'late match'}, 'location', 'northwest')
title(ax(axELGo), 'SSDs: Early vs Late Go Trials')




print(figure(figureHandle), ['~/matlab/tempfigures/choiceStop_', subjectID, '_Tau', num2str(timeConst), '_Lag', num2str(trialLag)], '-dpdf')










%%
% SSRT MEAN METHOD DEMONSTRATION
% INH FN + RT DIST + PROPORTION
ssdIndex = 10;
demoColor = [1 100/255 100/255];
nBin = 60;

% load ccm_population_monkey
load ccm_population_human
nSession = size(populationData, 1);
nRow = 3;
nColumn = 3;
inhAx = 1;
cumAx = 2;
distAx = 3;
% [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = model_figure(nRow, nColumn, 9898, 'screen');
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(inhAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
ax(cumAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 2) yAxesPosition(1, 2) axisWidth axisHeight]);
ax(distAx) = axes('units', 'centimeters', 'position', [xAxesPosition(2, 2) yAxesPosition(2, 2) axisWidth axisHeight]);
hold(ax(inhAx), 'on')
hold(ax(cumAx), 'on')
hold(ax(distAx), 'on')

inhGrand = [];
stopRespond = [];
ssdArray = [];
for i = 1 : nSession
    iSSDN = nan(1, 1200);
    iStopRespondN = nan(1, 1200);
    iInhN = nan(1, 1200);
    
    iSSD = populationData.ssdArray{i}';
    iSSDN(iSSD) = iSSD;
    ssdArray = [ssdArray; iSSDN];
    
    iStopRespond = populationData.stopRespondProbGrand{i}';
    iStopRespondN(iSSD) = iStopRespond;
    stopRespond = [stopRespond; iStopRespondN];
    
    iInh = populationData.inhibitionFnGrand{i};
    iInhN(iSSD(1):iSSD(end)) = iInh;
    inhGrand = [inhGrand; iInhN];
    
end
ssdArray = nanmean(ssdArray, 1);
inhGrandMean = nanmean(inhGrand, 1);
stopRespondMean = nanmean(stopRespond, 1);
stopRespondStd = nanstd(stopRespond, 1);

ssdArray(isnan(ssdArray)) = [];
inhGrandMean(isnan(inhGrandMean)) = [];
inhGrandMean = [nan(1, ssdArray(1)-1), inhGrandMean];
stopRespondMean(isnan(stopRespondMean)) = [];
stopRespondStd(isnan(stopRespondStd)) = [];


[fitParameters, lowestSSE] = Weibull(ssdArray, stopRespondMean);
timePoints = ssdArray(1) : ssdArray(end);
inhPop = weibull_curve(fitParameters, timePoints);



plot(ax(inhAx), ssdArray, stopRespondMean, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
plot(ax(inhAx), ssdArray(ssdIndex), stopRespondMean(ssdIndex), 'o', 'markeredgecolor', 'k', 'markerfacecolor', demoColor, 'markersize', 12)
plot(ax(inhAx), timePoints, inhPop, 'k', 'linewidth', 2)
set(ax(inhAx), 'xlim', [0 800])
set(ax(inhAx), 'ylim', [0 1])


signalStrengthLeft = [.35 .42 .46 .5];
signalStrengthRight = [.5 .54 .58 .65];
% Cumulative RT functions:
goTargRT = [];
goDistRT = [];
stopTargRT = [];
stopDistRT = [];
% for i = 1 : nSession
%     for s = 1 : length(signalStrength)
%         goTargRT = [goTargRT; populationData.goTargRT{i}{s}];
%         goDistRT = [goDistRT; populationData.goDistRT{i}{s}];
%         stopTargRT = [stopTargRT; populationData.stopTargRT{i}{s}];
%         stopDistRT = [stopDistRT; populationData.stopDistRT{i}{s}];
%     end
% end
for i = 1 : nSession
    for s = 1 : length(signalStrengthLeft)
        goTargRT = [goTargRT; populationData.goRightToTarg{i}{s}; populationData.goLeftToTarg{i}{s}];
        goDistRT = [goDistRT; populationData.goRightToDist{i}{s}; populationData.goLeftToDist{i}{s}];
        stopTargRT = [stopTargRT; populationData.stopRightToTarg{i}{s}; populationData.stopLeftToTarg{i}{s}];
        stopDistRT = [stopDistRT; populationData.stopRightToDist{i}{s}; populationData.stopLeftToDist{i}{s}];
    end
end
goTargRT = sort(goTargRT);
goDistRT = sort(goDistRT);
goRT = [goTargRT; goDistRT];

stopTargRT = sort(stopTargRT);
stopDistRT = sort(stopDistRT);

goTargRT(isnan(goTargRT)) = [];
goDistRT(isnan(goDistRT)) = [];
goRT(isnan(goRT)) = [];

stopTargRT(isnan(stopTargRT)) = [];
stopDistRT(isnan(stopDistRT)) = [];

iRTIndex = 1;
% for i = min(goRT) : max(goRT)
for i = 1:1200
    propGoTargRT(iRTIndex) = sum(goTargRT <= i) / length(goTargRT);
    propGoDistRT(iRTIndex) = sum(goDistRT <= i) / length(goDistRT);
    propGoRT(iRTIndex) = sum(goRT <= i) / length(goRT);
    
    propStopTargRT(iRTIndex) = sum(stopTargRT <= i) / length(stopTargRT);
    propStopDistRT(iRTIndex) = sum(stopDistRT <= i) / length(stopDistRT);
    iRTIndex = iRTIndex + 1;
end


box(ax(cumAx), 'off')
% plot(ax(cumAx), propGoTargRT, '-k')
% plot(ax(cumAx), propGoDistRT, '--k')
plot(ax(cumAx), propGoRT, '-k', 'lineWidth', 2)

% plot(ax(cumAx), propStopTargRT, '-r')
% plot(ax(cumAx), propStopDistRT, '--r')
set(ax(cumAx), 'xlim', [300 1000])





% Go RT Distribution
timeStep = (max(goRT) - min(goRT)) / nBin;
goRTBinValues = hist(goRT, nBin);
distributionArea = sum(goRTBinValues * timeStep);
goCorrectPDF = goRTBinValues / distributionArea;
goCorrectBinCenters = min(goRT)+timeStep/2 : timeStep : max(goRT)-timeStep/2;


stopRespondMean(ssdIndex)

rtIndex = find(propGoRT > stopRespondMean(ssdIndex), 1);
rtLimit = rtIndex;
pdfIndex = find(goCorrectBinCenters >= rtLimit, 1);
pdfLimit = goCorrectBinCenters(pdfIndex);

propGoRT(rtIndex)
plot(ax(cumAx), rtLimit, propGoRT(rtIndex), 'o', 'markeredgecolor', 'k', 'markerfacecolor', demoColor, 'markersize', 12)
% [min(goCorrectBinCenters):pdfLimit pdfLimit:-1:min(goCorrectBinCenters)]
% [goCorrectPDF(1:pdfIndex) zeros(1, length(goCorrectPDF(1:pdfIndex)))]
xError = fill([min(goCorrectBinCenters):timeStep:pdfLimit  pdfLimit:-timeStep:min(goCorrectBinCenters)], [goCorrectPDF(1:pdfIndex) zeros(1, length(goCorrectPDF(1:pdfIndex)))], demoColor);
set(xError, 'edgecolor', 'none');
plot(ax(distAx), goCorrectBinCenters, goCorrectPDF, '-k', 'linewidth', 2)
set(ax(distAx), 'xlim', [300 1000])





%% ****************************************************************************************
%  DUAL MONKEY AND HUMAN CHRONOMETRIC
% ****************************************************************************************
% Populaiton chronometric: Monkey
%
load ccm_population_monkey
signalStrengthLeft = [.41 .45 .48 .5];
signalStrengthRight = [.5 .52 .55 .58];
signalStrength = [.41 .45 .48 .5 .52 .55 .58];
% load ccm_population_human
% signalStrengthLeft = [.35 .42 .46 .5];
% signalStrengthRight = [.5 .54 .58 .65];
% signalStrength = [.35 .42 .46 .5 .55 .58 .65];
populationData = population;
nSession = size(populationData, 1);
nRow = 2;
nColumn = 2;
rtAx = 1;
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(rtAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
hold(ax(rtAx), 'on')

goLeftToTargRTMean = [];
goLeftTargRTStd = [];
goRightToDistRTMean = [];
goRightToDistRTStd = [];

goRightToTargRTMean = [];
goRightTargRTStd = [];
goLeftToDistRTMean = [];
goLeftToDistRTStd = [];

stopLeftToTargRTMean = [];
stopLeftTargRTStd = [];
stopRightToDistRTMean = [];
stopRightToDistRTStd = [];

stopRightToTargRTMean = [];
stopRightTargRTStd = [];
stopLeftToDistRTMean = [];
stopLeftToDistRTStd = [];

for i = 1 : nSession
    cellfun(@nanmean, populationData.stopRightToTarg{i})
    cellfun(@nanstd, populationData.stopRightToTarg{i})
    cellfun(@nanmean, populationData.stopLeftToDist{i})
    cellfun(@nanstd, populationData.stopLeftToDist{i})
    
    goLeftToTargRTMean = [goLeftToTargRTMean; cellfun(@nanmean, populationData.goLeftToTarg{i})];
    goLeftTargRTStd = [goLeftTargRTStd; cellfun(@nanstd, populationData.goLeftToTarg{i})];
    goRightToDistRTMean = [goRightToDistRTMean; cellfun(@nanmean, populationData.goRightToDist{i})];
    goRightToDistRTStd = [goRightToDistRTStd; cellfun(@nanstd, populationData.goRightToDist{i})];
    
    goRightToTargRTMean = [goRightToTargRTMean; cellfun(@nanmean, populationData.goRightToTarg{i})];
    goRightTargRTStd = [goRightTargRTStd; cellfun(@nanstd, populationData.goRightToTarg{i})];
    goLeftToDistRTMean = [goLeftToDistRTMean; cellfun(@nanmean, populationData.goLeftToDist{i})];
    goLeftToDistRTStd = [goLeftToDistRTStd; cellfun(@nanstd, populationData.goLeftToDist{i})];
    
    
    stopLeftToTargRTMean = [stopLeftToTargRTMean; cellfun(@nanmean, populationData.stopLeftToTarg{i})];
    stopLeftTargRTStd = [stopLeftTargRTStd; cellfun(@nanstd, populationData.stopLeftToTarg{i})];
    stopRightToDistRTMean = [stopRightToDistRTMean; cellfun(@nanmean, populationData.stopRightToDist{i})];
    stopRightToDistRTStd = [stopRightToDistRTStd; cellfun(@nanstd, populationData.stopRightToDist{i})];
    
    stopRightToTargRTMean = [stopRightToTargRTMean; cellfun(@nanmean, populationData.stopRightToTarg{i})];
    stopRightTargRTStd = [stopRightTargRTStd; cellfun(@nanstd, populationData.stopRightToTarg{i})];
    stopLeftToDistRTMean = [stopLeftToDistRTMean; cellfun(@nanmean, populationData.stopLeftToDist{i})];
    stopLeftToDistRTStd = [stopLeftToDistRTStd; cellfun(@nanstd, populationData.stopLeftToDist{i})];
    
    
    
end

goLeftTargMeanPop = nanmean(goLeftToTargRTMean, 1);
goLeftTargStdPop = nanstd(goLeftToTargRTMean, 1) / sqrt(nSession);
goRightDistMeanPop = nanmean(goRightToDistRTMean, 1);
goRightDistStdPop = nanstd(goRightToDistRTMean, 1) / sqrt(nSession);

goRightTargMeanPop = nanmean(goRightToTargRTMean, 1);
goRightTargStdPop = nanstd(goRightToTargRTMean, 1) / sqrt(nSession);
goLeftDistMeanPop = nanmean(goLeftToDistRTMean, 1);
goLeftDistStdPop = nanstd(goLeftToDistRTMean, 1) / sqrt(nSession);

stopLeftTargMeanPop = nanmean(stopLeftToTargRTMean, 1);
stopLeftTargStdPop = nanstd(stopLeftToTargRTMean, 1) / sqrt(nSession);
stopRightDistMeanPop = nanmean(stopRightToDistRTMean, 1);
stopRightDistStdPop = nanstd(stopRightToDistRTMean, 1) / sqrt(nSession);

stopRightTargMeanPop = nanmean(stopRightToTargRTMean, 1);
stopRightTargStdPop = nanstd(stopRightToTargRTMean, 1) / sqrt(nSession);
stopLeftDistMeanPop = nanmean(stopLeftToDistRTMean, 1);
stopLeftDistStdPop = nanstd(stopLeftToDistRTMean, 1) / sqrt(nSession);


% PLOT GO TRIALS
plot(ax(rtAx), signalStrengthLeft, goLeftTargMeanPop, '-ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
errorbar(ax(rtAx), signalStrengthLeft ,goLeftTargMeanPop, goLeftTargStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

plot(ax(rtAx), signalStrengthLeft, goRightDistMeanPop, 'ok', 'markeredgecolor', 'k', 'markersize', 10)
% errorbar(ax(rtAx), signalStrength ,goRightDistMeanPop, goRightDistStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

plot(ax(rtAx), signalStrengthRight, goRightTargMeanPop, '-ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
errorbar(ax(rtAx), signalStrengthRight ,goRightTargMeanPop, goRightTargStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

plot(ax(rtAx), signalStrengthRight, goLeftDistMeanPop, 'ok', 'markeredgecolor', 'k', 'markersize', 10)
% errorbar(ax(rtAx), signalStrength ,goRightDistMeanPop, goRightDistStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)


% PLOT STOP TRIALS
plot(ax(rtAx), signalStrengthLeft, stopLeftTargMeanPop, '-or', 'markeredgecolor', stopColor, 'markerfacecolor', stopColor, 'markersize', 10)
errorbar(ax(rtAx), signalStrengthLeft ,stopLeftTargMeanPop, stopLeftTargStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)

plot(ax(rtAx), signalStrengthLeft, stopRightDistMeanPop, 'or', 'markeredgecolor', stopColor, 'markersize', 10)
% errorbar(ax(rtAx), signalStrength ,stopRightDistMeanPop, stopRightDistStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)

plot(ax(rtAx), signalStrengthRight, stopRightTargMeanPop, '-or', 'markeredgecolor', stopColor, 'markerfacecolor', stopColor, 'markersize', 10)
errorbar(ax(rtAx), signalStrengthRight ,stopRightTargMeanPop, stopRightTargStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)

plot(ax(rtAx), signalStrengthRight, stopLeftDistMeanPop, 'or', 'markeredgecolor', stopColor, 'markersize', 10)
% errorbar(ax(rtAx), signalStrength ,stopRightDistMeanPop, stopRightDistStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)



set(ax(rtAx), 'Xlim', [.38 .62])
set(ax(rtAx), 'Ylim', [0 900])
% set(ax(ssrtAx), 'Xlim', [.33 .67])
plot(ax(rtAx), [.5 .5], ylim, '--k')
set(ax(rtAx), 'xtick', signalStrength)
set(ax(rtAx), 'xtickLabel', signalStrength*100)









% Populaiton chronometric: Human
%
% load ccm_population_monkey
% signalStrengthLeft = [.41 .45 .48 .5];
% signalStrengthRight = [.5 .52 .55 .58];
load ccm_population_human
signalStrengthLeft = [.35 .42 .46 .5];
signalStrengthRight = [.5 .54 .58 .65];
signalStrength = [.35 .42 .46 .5 .54 .58 .65];

nSession = size(populationData, 1);
% nRow = 3;
% nColumn = 2;
rtAxHum = 2;
% [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(rtAxHum) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 2) yAxesPosition(1, 2) axisWidth axisHeight]);
hold(ax(rtAxHum), 'on')

goLeftToTargRTMean = [];
goLeftTargRTStd = [];
goRightToDistRTMean = [];
goRightToDistRTStd = [];

goRightToTargRTMean = [];
goRightTargRTStd = [];
goLeftToDistRTMean = [];
goLeftToDistRTStd = [];

stopLeftToTargRTMean = [];
stopLeftTargRTStd = [];
stopRightToDistRTMean = [];
stopRightToDistRTStd = [];

stopRightToTargRTMean = [];
stopRightTargRTStd = [];
stopLeftToDistRTMean = [];
stopLeftToDistRTStd = [];

for i = 1 : nSession
    cellfun(@nanmean, populationData.stopRightToTarg{i})
    cellfun(@nanstd, populationData.stopRightToTarg{i})
    cellfun(@nanmean, populationData.stopLeftToDist{i})
    cellfun(@nanstd, populationData.stopLeftToDist{i})
    
    goLeftToTargRTMean = [goLeftToTargRTMean; cellfun(@nanmean, populationData.goLeftToTarg{i})];
    goLeftTargRTStd = [goLeftTargRTStd; cellfun(@nanstd, populationData.goLeftToTarg{i})];
    goRightToDistRTMean = [goRightToDistRTMean; cellfun(@nanmean, populationData.goRightToDist{i})];
    goRightToDistRTStd = [goRightToDistRTStd; cellfun(@nanstd, populationData.goRightToDist{i})];
    
    goRightToTargRTMean = [goRightToTargRTMean; cellfun(@nanmean, populationData.goRightToTarg{i})];
    goRightTargRTStd = [goRightTargRTStd; cellfun(@nanstd, populationData.goRightToTarg{i})];
    goLeftToDistRTMean = [goLeftToDistRTMean; cellfun(@nanmean, populationData.goLeftToDist{i})];
    goLeftToDistRTStd = [goLeftToDistRTStd; cellfun(@nanstd, populationData.goLeftToDist{i})];
    
    
    stopLeftToTargRTMean = [stopLeftToTargRTMean; cellfun(@nanmean, populationData.stopLeftToTarg{i})];
    stopLeftTargRTStd = [stopLeftTargRTStd; cellfun(@nanstd, populationData.stopLeftToTarg{i})];
    stopRightToDistRTMean = [stopRightToDistRTMean; cellfun(@nanmean, populationData.stopRightToDist{i})];
    stopRightToDistRTStd = [stopRightToDistRTStd; cellfun(@nanstd, populationData.stopRightToDist{i})];
    
    stopRightToTargRTMean = [stopRightToTargRTMean; cellfun(@nanmean, populationData.stopRightToTarg{i})];
    stopRightTargRTStd = [stopRightTargRTStd; cellfun(@nanstd, populationData.stopRightToTarg{i})];
    stopLeftToDistRTMean = [stopLeftToDistRTMean; cellfun(@nanmean, populationData.stopLeftToDist{i})];
    stopLeftToDistRTStd = [stopLeftToDistRTStd; cellfun(@nanstd, populationData.stopLeftToDist{i})];
    
    
    
end

goLeftTargMeanPop = nanmean(goLeftToTargRTMean, 1);
goLeftTargStdPop = nanstd(goLeftToTargRTMean, 1) / sqrt(nSession);
goRightDistMeanPop = nanmean(goRightToDistRTMean, 1);
goRightDistStdPop = nanstd(goRightToDistRTMean, 1) / sqrt(nSession);

goRightTargMeanPop = nanmean(goRightToTargRTMean, 1);
goRightTargStdPop = nanstd(goRightToTargRTMean, 1) / sqrt(nSession);
goLeftDistMeanPop = nanmean(goLeftToDistRTMean, 1);
goLeftDistStdPop = nanstd(goLeftToDistRTMean, 1) / sqrt(nSession);

stopLeftTargMeanPop = nanmean(stopLeftToTargRTMean, 1);
stopLeftTargStdPop = nanstd(stopLeftToTargRTMean, 1) / sqrt(nSession);
stopRightDistMeanPop = nanmean(stopRightToDistRTMean, 1);
stopRightDistStdPop = nanstd(stopRightToDistRTMean, 1) / sqrt(nSession);

stopRightTargMeanPop = nanmean(stopRightToTargRTMean, 1);
stopRightTargStdPop = nanstd(stopRightToTargRTMean, 1) / sqrt(nSession);
stopLeftDistMeanPop = nanmean(stopLeftToDistRTMean, 1);
stopLeftDistStdPop = nanstd(stopLeftToDistRTMean, 1) / sqrt(nSession);


% PLOT GO TRIALS
plot(ax(rtAxHum), signalStrengthLeft, goLeftTargMeanPop, '-ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
errorbar(ax(rtAxHum), signalStrengthLeft ,goLeftTargMeanPop, goLeftTargStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

plot(ax(rtAxHum), signalStrengthLeft, goRightDistMeanPop, 'ok', 'markeredgecolor', 'k', 'markersize', 10)
% errorbar(ax(rtAxHum), signalStrength ,goRightDistMeanPop, goRightDistStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

plot(ax(rtAxHum), signalStrengthRight, goRightTargMeanPop, '-ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
errorbar(ax(rtAxHum), signalStrengthRight ,goRightTargMeanPop, goRightTargStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

plot(ax(rtAxHum), signalStrengthRight, goLeftDistMeanPop, 'ok', 'markeredgecolor', 'k', 'markersize', 10)
% errorbar(ax(rtAxHum), signalStrength ,goRightDistMeanPop, goRightDistStdPop, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)


% PLOT STOP TRIALS
plot(ax(rtAxHum), signalStrengthLeft, stopLeftTargMeanPop, '-or', 'markeredgecolor', stopColor, 'markerfacecolor', stopColor, 'markersize', 10)
errorbar(ax(rtAxHum), signalStrengthLeft ,stopLeftTargMeanPop, stopLeftTargStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)

plot(ax(rtAxHum), signalStrengthLeft, stopRightDistMeanPop, 'or', 'markeredgecolor', stopColor, 'markersize', 10)
% errorbar(ax(rtAxHum), signalStrength ,stopRightDistMeanPop, stopRightDistStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)

plot(ax(rtAxHum), signalStrengthRight, stopRightTargMeanPop, '-or', 'markeredgecolor', stopColor, 'markerfacecolor', stopColor, 'markersize', 10)
errorbar(ax(rtAxHum), signalStrengthRight ,stopRightTargMeanPop, stopRightTargStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)

plot(ax(rtAxHum), signalStrengthRight, stopLeftDistMeanPop, 'or', 'markeredgecolor', stopColor, 'markersize', 10)
% errorbar(ax(rtAxHum), signalStrength ,stopRightDistMeanPop, stopRightDistStdPop, '.' , 'linestyle' , 'none', 'color', stopColor, 'linewidth' , 2)



%     set(ax(ssrtAxHum), 'Xlim', [.38 .62])
set(ax(rtAxHum), 'Xlim', [.33 .67])
set(ax(rtAxHum), 'Ylim', [0 900])
% ylim([100 350])
plot(ax(rtAxHum), [.5 .5], ylim, '--k')
set(ax(rtAxHum), 'xtick', signalStrength)
set(ax(rtAxHum), 'xtickLabel', signalStrength*100)







%% DUAL MONKEY HUMAN INHIBITION FUNCTIONS
% Population Inhibition Funciton

load ccm_population_monkey
% load ccm_population_human
nSession = size(populationData, 1);
nRow = 3;
nColumn = 2;
inhAx = 1;
% [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = model_figure(nRow, nColumn, 9898, 'screen');
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(inhAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
hold(ax(inhAx))

inhGrand = [];
stopRespond = [];
ssdArray = [];
for i = 1 : nSession
    iSSDN = nan(1, 1200);
    iStopRespondN = nan(1, 1200);
    iInhN = nan(1, 1200);
    
    iSSD = populationData.ssdArray{i}';
    iSSDN(iSSD) = iSSD;
    ssdArray = [ssdArray; iSSDN];
    
    iStopRespond = populationData.stopRespondProbGrand{i}';
    iStopRespondN(iSSD) = iStopRespond;
    stopRespond = [stopRespond; iStopRespondN];
    
    iInh = populationData.inhibitionFnGrand{i};
    iInhN(iSSD(1):iSSD(end)) = iInh;
    inhGrand = [inhGrand; iInhN];
    
    
    
    
    
    %      iSSD = populationData.ssdArray{i}';
    %     iInh = [nan(1, iSSD(1)-1), populationData.inhibitionFnGrand{i}];
    %
    %     iInh(end+1 : 1200) = nan;
    %     inhGrand = [inhGrand; iInh];
    %
    %     iSSDNan = [nan(1, iSSD(1)-1), iSSD];
    %     iSSDNan(end+1 : 1000) = nan;
    %
    %     ssdArray = [ssdArray; iSSDNan];
    %
    %     iStopRespond = [nan(1, iSSD(1)-1), populationData.stopRespondProbGrand{i}'];
    %     iStopRespond(end+1 : 1000) = nan;
    % %     if length(iStopRespond) < 10
    % %         iStopRespond(end+1 : 10) = nan;
    % %     else
    % %         ssdArray = populationData.ssdArray{i};
    % %     end
    %
    % stopRespond = [stopRespond; iStopRespond];
end
ssdArray = nanmean(ssdArray, 1);
inhGrandMean = nanmean(inhGrand, 1);
stopRespondMean = nanmean(stopRespond, 1);
stopRespondStd = nanstd(stopRespond, 1);

ssdArray(isnan(ssdArray)) = [];
inhGrandMean(isnan(inhGrandMean)) = [];
inhGrandMean = [nan(1, ssdArray(1)-1), inhGrandMean];
stopRespondMean(isnan(stopRespondMean)) = [];
stopRespondStd(isnan(stopRespondStd)) = [];


[fitParameters, lowestSSE] = Weibull(ssdArray, stopRespondMean);
timePoints = ssdArray(1) : ssdArray(end);
inhPop = weibull_curve(fitParameters, timePoints);



plot(ax(inhAx), ssdArray, stopRespondMean, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 9)
% errorbar(ax(inhAx), ssdArray ,stopRespondMean, stopRespondStd, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)
% plot(ax(inhAx), inhGrandMean, 'k', 'linewidth', 2)
plot(ax(inhAx), timePoints, inhPop, 'k', 'linewidth', 2)
xlim([0 1000])
ylim([0 1])
% set(ax(inhAx), 'xtick', ssdArray)
% set(ax(inhAx), 'xtickLabel', ssdArray*1000)





% Population Inhibition Funciton

% load ccm_population_monkey
load ccm_population_human
nSession = size(populationData, 1);
inhAxHum = 2;
% [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = model_figure(nRow, nColumn, 9898, 'screen');
% [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(inhAxHum) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 2) yAxesPosition(1, 2) axisWidth axisHeight]);
hold(ax(inhAxHum))

inhGrand = [];
stopRespond = [];
ssdArray = [];
for i = 1 : nSession
    iSSDN = nan(1, 1200);
    iStopRespondN = nan(1, 1200);
    iInhN = nan(1, 1200);
    
    iSSD = populationData.ssdArray{i}';
    iSSDN(iSSD) = iSSD;
    ssdArray = [ssdArray; iSSDN];
    
    iStopRespond = populationData.stopRespondProbGrand{i}';
    iStopRespondN(iSSD) = iStopRespond;
    stopRespond = [stopRespond; iStopRespondN];
    
    iInh = populationData.inhibitionFnGrand{i};
    iInhN(iSSD(1):iSSD(end)) = iInh;
    inhGrand = [inhGrand; iInhN];
    
    
    
    
    
    %      iSSD = populationData.ssdArray{i}';
    %     iInh = [nan(1, iSSD(1)-1), populationData.inhibitionFnGrand{i}];
    %
    %     iInh(end+1 : 1200) = nan;
    %     inhGrand = [inhGrand; iInh];
    %
    %     iSSDNan = [nan(1, iSSD(1)-1), iSSD];
    %     iSSDNan(end+1 : 1000) = nan;
    %
    %     ssdArray = [ssdArray; iSSDNan];
    %
    %     iStopRespond = [nan(1, iSSD(1)-1), populationData.stopRespondProbGrand{i}'];
    %     iStopRespond(end+1 : 1000) = nan;
    % %     if length(iStopRespond) < 10
    % %         iStopRespond(end+1 : 10) = nan;
    % %     else
    % %         ssdArray = populationData.ssdArray{i};
    % %     end
    %
    % stopRespond = [stopRespond; iStopRespond];
end
ssdArray = nanmean(ssdArray, 1);
inhGrandMean = nanmean(inhGrand, 1);
stopRespondMean = nanmean(stopRespond, 1);
stopRespondStd = nanstd(stopRespond, 1);

ssdArray(isnan(ssdArray)) = [];
inhGrandMean(isnan(inhGrandMean)) = [];
inhGrandMean = [nan(1, ssdArray(1)-1), inhGrandMean];
stopRespondMean(isnan(stopRespondMean)) = [];
stopRespondStd(isnan(stopRespondStd)) = [];


[fitParameters, lowestSSE] = Weibull(ssdArray, stopRespondMean);
timePoints = ssdArray(1) : ssdArray(end);
inhPop = weibull_curve(fitParameters, timePoints);



plot(ax(inhAxHum), ssdArray, stopRespondMean, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 9)
% errorbar(ax(inhAxHum), ssdArray ,stopRespondMean, stopRespondStd, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)
% plot(ax(inhAxHum), inhGrandMean, 'k', 'linewidth', 2)
plot(ax(inhAxHum), timePoints, inhPop, 'k', 'linewidth', 2)
xlim([0 1000])
ylim([0 1])
% set(ax(inhAxHum), 'xtick', ssdArray)
% set(ax(inhAxHum), 'xtickLabel', ssdArray*1000)





%% DUAL MONKEY HUMAN Population SSRT


load ccm_population_monkey
signalStrength = [.41 .45 .48 .5 .52 .55 .59];
% load ccm_population_human
% signalStrength = [.35 .42 .46 .5 .54 .58 .65];
nSession = size(populationData, 1);
nRow = 2;
nColumn = 2;
ssrtAx = 1;
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(ssrtAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
hold(ax(ssrtAx))


% SSRT across signal strength

ssrt = cell2mat(cellfun(@(x) x', populationData.ssrt, 'uniformoutput', false))
ssrtMean = mean(ssrt, 1);
ssrtSTD = std(ssrt, 1);
ssrtSEM = std(ssrt, 1) / sqrt(nSession);


plot(ax(ssrtAx), signalStrength, ssrtMean, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
errorbar(ax(ssrtAx), signalStrength ,ssrtMean, ssrtSTD, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

% ylim([100 350])
ylim([0 350])
set(ax(ssrtAx), 'Xlim', [.38 .62])
% set(ax(ssrtAx), 'Xlim', [.33 .67])
set(ax(ssrtAx), 'xtick', signalStrength)
set(ax(ssrtAx), 'xtickLabel', signalStrength*100)


[p, table] = anova1(ssrt, {'1','2','3','4','5','6','7'},'off');

flipPropArray = signalStrength;
flipPropArray(flipPropArray > .5) = fliplr(flipPropArray(flipPropArray < .5));

signalStrengthData = repmat(flipPropArray, size(ssrt, 1), 1);
[p, s] = polyfit(signalStrengthData(:), ssrt(:), 1);
[y, delta] = polyval(p, signalStrengthData(:), s);
stats = regstats(signalStrengthData(:), ssrt(:));
fprintf('p-value for regression: %.4f\n', stats.tstat.pval(2))
R = corrcoef(signalStrengthData(:), ssrt(:));
Rsqrd = R(1, 2)^2;
cov(signalStrengthData(:), ssrt(:));
xVal = min(signalStrengthData(:)) : .001 : max(signalStrengthData(:));
yVal = p(1) * xVal + p(2);
plot(ax(ssrtAx), xVal, yVal, 'r')

ssrtGrandMean = mean(cell2mat(populationData.ssrtGrand));



%%
% Human
load ccm_population_human
signalStrength = [.35 .42 .46 .5 .54 .58 .65];
nSession = size(populationData, 1);
nRow = 2;
nColumn = 2;
ssrtAxHum = 2;
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(ssrtAxHum) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 2) yAxesPosition(1, 2) axisWidth axisHeight]);
hold(ax(ssrtAxHum))


% SSRT across signal strength

ssrt = cell2mat(cellfun(@(x) x', populationData.ssrt, 'uniformoutput', false))
ssrtMean = mean(ssrt, 1);
ssrtSTD = std(ssrt, 1);
ssrtSEM = std(ssrt, 1) / sqrt(nSession);


plot(ax(ssrtAxHum), signalStrength, ssrtMean, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
errorbar(ax(ssrtAxHum), signalStrength ,ssrtMean, ssrtSTD, '.' , 'linestyle' , 'none', 'color', 'k', 'linewidth' , 2)

ylim([0 250])
% ylim([0 300])
%     set(ax(ssrtAxHum), 'Xlim', [.38 .62])
set(ax(ssrtAxHum), 'Xlim', [.33 .67])
set(ax(ssrtAxHum), 'xtick', signalStrength)
set(ax(ssrtAxHum), 'xtickLabel', signalStrength*100)


[p, table, stats] = anova1(ssrt, {'1','2','3','4','5','6','7'}, 'off')
c = multcompare(stats, 'display', 'off')

flipPropArray = signalStrength;
flipPropArray(flipPropArray > .5) = fliplr(flipPropArray(flipPropArray < .5));

signalStrengthData = repmat(flipPropArray, size(ssrt, 1), 1);
[p, s] = polyfit(signalStrengthData(:), ssrt(:), 1);
[y, delta] = polyval(p, signalStrengthData(:), s);
stats = regstats(signalStrengthData(:), ssrt(:))
fprintf('p-value for regression: %.4f\n', stats.tstat.pval(2))
R = corrcoef(signalStrengthData(:), ssrt(:));
Rsqrd = R(1, 2)^2;
cov(signalStrengthData(:), ssrt(:));
xVal = min(signalStrengthData(:)) : .001 : max(signalStrengthData(:));
yVal = p(1) * xVal + p(2);
plot(ax(ssrtAxHum), xVal, yVal, 'r')

ssrtGrandMean = mean(cell2mat(populationData.ssrtGrand))




%%
% PREDICTED NON-CANCELED STOP RTS VS. OBSERVED: STILL IN THE WORKS- USE GO
% RTS AND PROPORTION STOP TRIALS TO PREDICT NON-CANCELED STOP RTS AT EACH
% SSD, AS DONE IN LOGAN & COWAN 1984, HANES AND SCHALL 1995 (FIG 7)


load ccm_population_monkey
signalStrengthLeft = [.41 .45 .48 .5];
signalStrengthRight = [.5 .52 .55 .58];
signalStrength = [.41 .45 .48 .5 .52 .55 .58];
% load ccm_population_human
% signalStrengthLeft = [.35 .42 .46 .5];
% signalStrengthRight = [.5 .54 .58 .65];
% signalStrength = [.35 .42 .46 .5 .55 .58 .65];


nSession = size(populationData, 1);
nRow = 3;
nColumn = 3;
inhAx = 1;
cumAx = 2;
distAx = 3;
% [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = model_figure(nRow, nColumn, 9898, 'screen');
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 9898);
ax(inhAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
ax(cumAx) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 2) yAxesPosition(1, 2) axisWidth axisHeight]);
ax(distAx) = axes('units', 'centimeters', 'position', [xAxesPosition(2, 2) yAxesPosition(2, 2) axisWidth axisHeight]);
hold(ax(inhAx), 'on')
hold(ax(cumAx), 'on')
hold(ax(distAx), 'on')


inhGrand = [];
stopRespond = [];
ssdArray = [];
for i = 1 : nSession
    iSSDN = nan(1, 1200);
    iStopRespondN = nan(1, 1200);
    iInhN = nan(1, 1200);
    
    iSSD = populationData.ssdArray{i}';
    iSSDN(iSSD) = iSSD;
    ssdArray = [ssdArray; iSSDN];
    
    iStopRespond = populationData.stopRespondProbGrand{i}';
    iStopRespondN(iSSD) = iStopRespond;
    stopRespond = [stopRespond; iStopRespondN];
    
    iInh = populationData.inhibitionFnGrand{i};
    iInhN(iSSD(1):iSSD(end)) = iInh;
    inhGrand = [inhGrand; iInhN];
    
end
ssdArray = nanmean(ssdArray, 1)
ssdArray = ssdArray(~isnan(ssdArray))

inhGrandMean = nanmean(inhGrand, 1);
stopRespondMean = nanmean(stopRespond, 1);
stopRespondStd = nanstd(stopRespond, 1);

ssdArray(isnan(ssdArray)) = [];
inhGrandMean(isnan(inhGrandMean)) = [];
inhGrandMean = [nan(1, ssdArray(1)-1), inhGrandMean];
stopRespondMean(isnan(stopRespondMean)) = [];
stopRespondStd(isnan(stopRespondStd)) = [];


% [fitParameters, lowestSSE] = Weibull(ssdArray, stopRespondMean);
% timePoints = ssdArray(1) : ssdArray(end);
% inhPop = weibull_curve(fitParameters, timePoints);



plot(ax(inhAx), ssdArray, stopRespondMean, 'ok', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 10)
plot(ax(inhAx), ssdArray(ssdIndex), stopRespondMean(ssdIndex), 'o', 'markeredgecolor', 'k', 'markerfacecolor', demoColor, 'markersize', 12)
plot(ax(inhAx), timePoints, inhPop, 'k', 'linewidth', 2)
set(ax(inhAx), 'xlim', [0 800])
set(ax(inhAx), 'ylim', [0 1])


signalStrengthLeft = [.35 .42 .46 .5];
signalStrengthRight = [.5 .54 .58 .65];
% Cumulative RT functions:
goTargRT = [];
goDistRT = [];
stopTargRT = [];
stopDistRT = [];

for i = 1 : nSession
    for s = 1 : length(signalStrengthLeft)
        goTargRT = [goTargRT; populationData.goRightToTarg{i}{s}; populationData.goLeftToTarg{i}{s}];
        goDistRT = [goDistRT; populationData.goRightToDist{i}{s}; populationData.goLeftToDist{i}{s}];
        stopTargRT = [stopTargRT; populationData.stopRightToTarg{i}{s}; populationData.stopLeftToTarg{i}{s}];
        stopDistRT = [stopDistRT; populationData.stopRightToDist{i}{s}; populationData.stopLeftToDist{i}{s}];
    end
end
goTargRT = sort(goTargRT);
goDistRT = sort(goDistRT);
goRT = [goTargRT; goDistRT];

stopTargRT = sort(stopTargRT);
stopDistRT = sort(stopDistRT);

goTargRT(isnan(goTargRT)) = [];
goDistRT(isnan(goDistRT)) = [];
goRT(isnan(goRT)) = [];

stopTargRT(isnan(stopTargRT)) = [];
stopDistRT(isnan(stopDistRT)) = [];

iRTIndex = 1;
% for i = min(goRT) : max(goRT)
for i = 1:1200
    propGoTargRT(iRTIndex) = sum(goTargRT <= i) / length(goTargRT);
    propGoDistRT(iRTIndex) = sum(goDistRT <= i) / length(goDistRT);
    propGoRT(iRTIndex) = sum(goRT <= i) / length(goRT);
    
    propStopTargRT(iRTIndex) = sum(stopTargRT <= i) / length(stopTargRT);
    propStopDistRT(iRTIndex) = sum(stopDistRT <= i) / length(stopDistRT);
    iRTIndex = iRTIndex + 1;
end


box(ax(cumAx), 'off')
% plot(ax(cumAx), propGoTargRT, '-k')
% plot(ax(cumAx), propGoDistRT, '--k')
plot(ax(cumAx), propGoRT, '-k', 'lineWidth', 2)

% plot(ax(cumAx), propStopTargRT, '-r')
% plot(ax(cumAx), propStopDistRT, '--r')
set(ax(cumAx), 'xlim', [300 1000])





% Go RT Distribution
timeStep = (max(goRT) - min(goRT)) / nBin;
goRTBinValues = hist(goRT, nBin);
distributionArea = sum(goRTBinValues * timeStep);
goCorrectPDF = goRTBinValues / distributionArea;
goCorrectBinCenters = min(goRT)+timeStep/2 : timeStep : max(goRT)-timeStep/2;


stopRespondMean(ssdIndex)

rtIndex = find(propGoRT > stopRespondMean(ssdIndex), 1);
rtLimit = rtIndex;
pdfIndex = find(goCorrectBinCenters >= rtLimit, 1);
pdfLimit = goCorrectBinCenters(pdfIndex);

propGoRT(rtIndex)
plot(ax(cumAx), rtLimit, propGoRT(rtIndex), 'o', 'markeredgecolor', 'k', 'markerfacecolor', demoColor, 'markersize', 12)
% [min(goCorrectBinCenters):pdfLimit pdfLimit:-1:min(goCorrectBinCenters)]
% [goCorrectPDF(1:pdfIndex) zeros(1, length(goCorrectPDF(1:pdfIndex)))]
xError = fill([min(goCorrectBinCenters):timeStep:pdfLimit  pdfLimit:-timeStep:min(goCorrectBinCenters)], [goCorrectPDF(1:pdfIndex) zeros(1, length(goCorrectPDF(1:pdfIndex)))], demoColor);
set(xError, 'edgecolor', 'none');
plot(ax(distAx), goCorrectBinCenters, goCorrectPDF, '-k', 'linewidth', 2)
set(ax(distAx), 'xlim', [300 1000])










%%  COMPARE PSYCHOMETRIC FUNCTIONS BETWEEN CCM SESSSION WITH AND WITHOUT STOPPING

% "Stop" in this code refers to sessions with stop trials
% "NoStop" referes to sessions without stop trials


% load ccm_population_human
% subjectID = ...
%     {'bz', ...
%     'pm', ...
%     'cb'};
% sessionArray = ...
%     {'Allsaccade', ...
%     'Allsaccade', ...
%     'Allsaccade'};
load ccm_population_broca
iSubjectID = 'Broca';
sessionStop = ...
    {'bp042n02', ...
    'bp043n02', ...
    'bp044n02', ...
    'bp046n02', ...
    'bp050n02', ...
    'bp051n02'};
sessionNoStop = ...
    {'bp042n04', ...
    'bp043n04', ...
    'bp044n04', ...
    'bp046n04', ...
    'bp050n04', ...
    'bp051n04'};
% sessionArray = ...
%     {'bp041n03', ...
%     'bp042n02', ...
%     'bp043n02', ...
%     'bp050n02'};

nSession = length(sessionStop);
signalStrength = unique([populationData.signalStrengthLeft{1}, populationData.signalStrengthRight{1}])';



goRightLogicalStop = cell(nSession, 1);
goRightLogicalNoStop = cell(nSession, 1);
goRightSignalStrengthStop = cell(nSession, 1);
goRightSignalStrengthNoStop = cell(nSession, 1);


for iSession = 1 : nSession
    %     iSubjectID = subjectID{iSession};
    iSessionStopID = sessionStop{iSession};
    iSessionNoStopID = sessionNoStop{iSession};
    %     % Load the data
    %     [dataFileStop, localDataPathStop, localDataFileStop] = data_file_path(iSubjectID, iSessionStopID);
    %     [dataFileNoStop, localDataPathNoStop, localDataFileNoStop] = data_file_path(iSubjectID, iSessionNoStopID);
    %     % If the file hasn't already been copied to a local directory, do it now
    %     if exist(localDataFileStop, 'file') ~= 2
    %         copyfile(dataFileStop, localDataPathStop)
    %     end
    %     if exist(localDataFileNoStop, 'file') ~= 2
    %         copyfile(dataFileNoStop, localDataPathNoStop)
    %     end
    % %     load(localDataPathStop);`
    % %     signalStrengthStop = cell2mat(trialData.targ1CheckerProp);
    % %     load(localDataPathNoStop);
    % %     signalStrengthNoStop = cell2mat(trialData.targ1CheckerProp);
    
    
    dataStop = ccm_psychometric(iSubjectID, iSessionStopID, 0);
    dataNoStop = ccm_psychometric(iSubjectID, iSessionNoStopID, 0);
    
    goRightLogicalStop{iSession} = dataStop.goRightLogical;
    goRightLogicalNoStop{iSession} = dataNoStop.goRightLogical;
    
    goRightSignalStrengthStop{iSession} = dataStop.goRightSignalStrength;
    goRightSignalStrengthNoStop{iSession} = dataNoStop.goRightSignalStrength;
    
    
    
end % for iSession = 1 : length(sessionArray)

stopSparseColor = [1 .5 0];
stopDenseColor = [0 0 1];
goSparseColor = [.5 .5 .5];
goDenseColor = [0 0 0];

stopEarlyColor = [1 .5 0];
stopLateColor = [0 0 1];

% propPoints = signalStrength(1)*100 : .1 : signalStrength(end)*100;
propPoints = signalStrength(1) : .001 : signalStrength(end);


method = 'each';
switch method
    % One method would be to estimate one psych function for each
    % condition, collapsing across sessions, and compare psych fn
    % parameters by calculating parameter confidence intervals.
    case 'collapse'
        
    case 'each'
        goParamStop = nan(nSession, 4);
        goParamNoStop = nan(nSession, 4);
        
        goPsychFnStop = nan(nSession, length(propPoints));
        goPsychFnNoStop = nan(nSession, length(propPoints));
        % Another method is to estime psych fns for each session and condition,
        % and compare psych fn parameters across sessions
        for iSession = 1 : nSession
            
            % Weibull fit the stop and noStop sessions
            [goParamStop(iSession, :), maxLogLike] = psychometric_weibull_fit(goRightSignalStrengthStop{iSession}, goRightLogicalStop{iSession});
            goPsychFnStop(iSession, :) = weibull_curve(goParamStop(iSession, :) , propPoints);
            [goParamNoStop(iSession, :), maxLogLike] = psychometric_weibull_fit(goRightSignalStrengthNoStop{iSession}, goRightLogicalNoStop{iSession});
            goPsychFnNoStop(iSession, :) = weibull_curve(goParamNoStop(iSession, :), propPoints);
            
            
            checkPlots = 0;
            if checkPlots
                nRow = 3;
                nColumn = 2;
                stopNoStop = 1;
                [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', 693);
                ax(stopNoStop) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 1) yAxesPosition(1, 1) axisWidth axisHeight]);
                hold(ax(stopNoStop), 'on')
                
                
                
                % SPARSE VS. DENSE
                cla(stopNoStop)
                stopLine = plot(ax(stopNoStop), propPoints, stopSparsePsychFn(iSession, :), '-', 'color', stopSparseColor, 'linewidth', 2);
                % plot(ax(sparseDense), signalStrength, stopRightProbSparse, 'o', 'color', stopSparseColor, 'linewidth', 2, 'markerfacecolor', stopSparseColor, 'markeredgecolor', stopSparseColor)
                noStopLine = plot(ax(stopNoStop), propPoints, stopDensePsychFn(iSession, :), '-', 'color', stopDenseColor, 'linewidth', 2);
                % plot(ax(sparseDense), signalStrength, stopRightProbDense, 'o', 'color', stopDenseColor, 'linewidth', 2, 'markerfacecolor', stopDenseColor, 'markeredgecolor', stopDenseColor)
                
                
                set(ax(sparseDense), 'xtick', signalStrength)
                set(ax(sparseDense), 'xtickLabel', signalStrength*100)
                set(get(ax(sparseDense), 'ylabel'), 'String', 'p(Right)')
                set(ax(sparseDense),'XLim',[signalStrength(1) - choicePlotXMargin signalStrength(end) + choicePlotXMargin])
                set(ax(sparseDense),'YLim',[0 1])
                % legend([stopSparseLine, stopDenseLine, goSparseLine, goDenseLine], 'Stop Sparse', 'Stop Dense', 'Go Sparse', 'Go Dense', 'location', 'northwest')
                plot(ax(sparseDense), [.5 .5], ylim, '--k')
                
                
                pause
            end
        end
        
        
        % Set up t-test:
        
        
        % Early/Late (include-all version and latency-matched version)
        goSlopeStop = goParamStop(:, 2);
        goSlopeNoStop = goParamNoStop(:, 2);
        [goSlopeStop, goSlopeNoStop]
        fprintf('stop slope: %.2f \n noStop slope: %.2f \n', mean(goSlopeStop), mean(goSlopeNoStop));
        [h,ttestP] = ttest2(goSlopeStop, goSlopeNoStop)
        
        
end




%%
load('Broca_sessions.mat')

nStop = length(sessions.ccm.stop)

for iSession = 10 : nStop
    iName = sessions.ccm.stop(iSession).name;
    [dataFile, localDataPath, localDataFile] = data_file_path('Broca', iName);
    load(['local_data/',iName])
    ss = cell2mat(trialData.targ1CheckerProp);
    if ismember(.58, ss)
        sum(ss == .58)
        ss(ss == .58) = .59;
        trialData.targ1CheckerProp = num2cell(ss);
        save(dataFile, 'trialData', '-append')
        save(localDataFile, 'trialData', '-append')
        disp(dataFile)
        disp(localDataFile)
    end
end



%%
load('Xena_sessions.mat')

nStop = length(sessions.ccm.stop)

for iSession = 10 : nStop
    iName = sessions.ccm.stop(iSession).name;
    [dataFile, localDataPath, localDataFile] = data_file_path('Xena', iName);
    load(['local_data/',iName])
    ss = cell2mat(trialData.targ1CheckerProp);
    if ismember(.52, ss)
        sum(ss == .52)
        ss(ss == .52) = .53;
        trialData.targ1CheckerProp = num2cell(ss);
        save(dataFile, 'trialData', '-append')
        save(localDataFile, 'trialData', '-append')
        disp(dataFile)
        disp(localDataFile)
    end
end

nNoStop = length(sessions.ccm.noStop)

for iSession = 10 : nNoStop
    iName = sessions.ccm.noStop(iSession).name;
    [dataFile, localDataPath, localDataFile] = data_file_path('Broca', iName);
    load(['local_data/',iName])
    ss = cell2mat(trialData.targ1CheckerProp);
    if ismember(.58, ss)
        sum(ss == .58)
        ss(ss == .58) = .59;
        trialData.targ1CheckerProp = num2cell(ss);
        save(dataFile, 'trialData', '-append')
        save(localDataFile, 'trialData', '-append')
        disp(dataFile)
        disp(localDataFile)
    end
end
load('Xena_sessions.mat')

nNoStop = length(sessions.ccm.noStop)

for iSession = 1 : nNoStop
    iName = sessions.ccm.noStop(iSession).name;
    [dataFile, localDataPath, localDataFile] = data_file_path('Xena', iName);
    load(['local_data/',iName])
    ss = cell2mat(trialData.targ1CheckerProp);
    if ismember(.52, ss)
        sum(ss == .52)
        ss(ss == .52) = .53;
        trialData.targ1CheckerProp = num2cell(ss);
        save(dataFile, 'trialData', '-append')
        save(localDataFile, 'trialData', '-append')
        disp(dataFile)
        disp(localDataFile)
    end
end


%%

load('Broca_sessions.mat')

nStop = length(sessions.ccm.stop)

for iSession = 6 : nStop
    iName = sessions.ccm.stop(iSession).name;
    load(['local_data/',iName])
    if min(cell2mat(trialData.targ1CheckerProp)) == .41
        
        fprintf('\n\n ************************************** \n\n')
        fprintf('\t\t %s\n\n', iName)
        SessionData = ccm_session_behavior('Broca', iName, 1);
        
    end
end



load('Xena_sessions.mat')

nStop = length(sessions.ccm.stop)

for iSession = 1 : nStop
    iName = sessions.ccm.stop(iSession).name;
    load(['local_data/',iName])
    if min(cell2mat(trialData.targ1CheckerProp)) == .35
        fprintf('\n\n ************************************** \n\n')
        fprintf('\t\t %s\n\n', iName)
        SessionData = ccm_session_behavior('Xena', iName, 1);
        
    end
end

%%
disp('*******************************************************************************')
disp('           Checkerboard Aborts')

task = 'ccm';
subjectID = 'Human';
% subjectID = 'Broca';
% subjectID = 'Xena';

[sessionArray, subjectIDArray] = task_session_array(subjectID, task);
% signalStrength = unique([populationData.signalStrengthLeft{1}, populationData.signalStrengthRight{1}])';





nSession = length(sessionArray);
nTrial = nan(nSession, 1);
nCheckerAbort = nan(nSession, 1);
for iSession = 1 : nSession
    
    
    % Load the data
[trialData, SessionData, ExtraVar] = load_data(subjectIDArray{iSession}, sessionArray{iSession});
    
    iFixAbort = sum(strcmp(trialData.trialOutcome, 'fixationAbort') | strcmp(trialData.trialOutcome, 'noFixation'));
    iTrial = size(trialData, 1) - iFixAbort;
    iCheckerAbort = sum(strcmp(trialData.trialOutcome, 'choiceStimulusAbort'));
    
    nTrial(iSession) = iTrial;
    nCheckerAbort(iSession) = iCheckerAbort;
end

%%
disp('*******************************************************************************')
disp('           Session Data')

task = 'ccm';
subjectID = 'Human';
% subjectID = 'Broca';
% subjectID = 'Xena';

[sessionArray, subjectIDArray] = task_session_array(subjectID, task);
% signalStrength = unique([populationData.signalStrengthLeft{1}, populationData.signalStrengthRight{1}])';



maxITI = 10000;
iti = []
for iSession = 1 : nSession
    
    
    % Load the data
[trialData, SessionData, ExtraVar] = load_data(subjectIDArray{iSession}, sessionArray{iSession});

switch subjectID 
    case 'Human'
% For humans
%     trialData.trialOnset = cell2mat(trialData.trialOnset);
%     trialData.trialDuration = cell2mat(trialData.trialDuration);
iIti = trialData.trialOnset(2 : end) - (trialData.trialOnset(1:end-1) + trialData.feedbackOnset(1:end-1));
iIti = trialData.trialOnset(2 : end) - (trialData.trialOnset(1:end-1) + trialData.trialDuration(1:end-1));
    otherwise
% For monkeys
    trialData.trialOnset = cell2mat(trialData.trialOnset);
    trialData.trialDuration = cell2mat(trialData.trialDuration);
iIti = trialData.trialOnset(2 : end) - (trialData.trialOnset(1:end-1) + trialData.trialDuration(1:end-1));
end
iIti(iIti < 0 | iIti > maxITI) = [];
iti = [iti; iIti]

end


