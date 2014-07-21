function Unit = mem_single_neuron(subjectID, sessionID, varargin)

%
% function Unit = mem_single_neuron(subjectID, sessionID, plotFlag, unitArray)
%
% Single neuron analyses for choice countermanding task. Only plots the
% sdfs. To see rasters, use ccm_single_neuron_rasters, which displays all
% conditions in a given epoch
%
% input:
%   subjectID: e.g. 'Broca', 'Xena', 'pm', etc
%   sessionID: e.g. 'bp111n01', 'Allsaccade'
%
%   varargin: property names and their values:
%           'plotFlag': 0 or 1
%           'printPlot': 0 or 1: If set to 1, this prints the figure in the local_figures folder
%           'unitArray': a single unit, like 'spikeUnit17a', or an array of units, like {'spikeUnit17a', 'spikeUnit17b'}
%
%
% Returns Unit structure with fields:
%
%   Unit.signalStrength(x).(condition).ssd(x).(epoch name)
%
%   condition can be:  rightTarg, goDist, stopTarg, stopDist, stopCorrect
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

% Load the data
[trialData, SessionData, ExtraVar] = load_data(subjectID, sessionID);

if ~strcmp(SessionData.taskID, 'mem')
    fprintf('Not a memory guided saccade session, try again\n')
    return
end
if ~isfield(SessionData, 'spikeUnitArray') || isempty(SessionData.spikeUnitArray)
    fprintf('Session %s does not contain spike data \n', sessionID)
    Unit = [];
    return
end

nTarg = length(unique(trialData.targAngle));
nTrial = size(trialData, 1);
% if nTarg ~= 2
%     disp('Don"t have code yet for memory guided saccade task with more than 2 targets')
%     Unit = struct();
%     return
% end

% Set defaults
plotFlag = 1;
unitArray = SessionData.spikeUnitArray;
printPlot = 0; % If set to 1, this collapses data across signal strengths (within each hemifield)
for i = 1 : 2 : length(varargin)
    switch varargin{i}
        case 'plotFlag'
            plotFlag = varargin{i+1};
        case 'unitArray'
            unitArray = varargin{i+1};
        case 'printPlot'
            printPlot = varargin{i+1};
        otherwise
    end
end
if isempty(unitArray)
    unitArray = SessionData.spikeUnitArray
end

clear Unit
% constants
Kernel.method = 'postsynaptic potential';
Kernel.growth = 1;
Kernel.decay = 20;

% epochArray = {'fixWindowEntered', 'targOn', 'checkerOn', 'stopSignalOn', 'responseOnset', 'rewardOn'};
epochArray = {'fixWindowEntered', 'targOn', 'responseOnset', 'rewardOn'};
nEpoch = length(epochArray);
rightTargColor = [1 0 0];
leftTargColor = [0 0 1];
tickWidth = 5;
rasYlim = 100;




% How many units were recorded?
nUnit = size(unitArray, 2);





[minTrialDuration,i] = min(trialData.trialDuration(~strcmp(trialData.trialOutcome, 'fixationAbort')));
[maxTrialDuration,i] = max(trialData.trialDuration(~strcmp(trialData.trialOutcome, 'fixationAbort')));
sdfMax = zeros(nUnit, nEpoch, nTarg);  % Keep track of maximum sdf values, for setting y-axis limits in plots

for kUnitIndex = 1 : nUnit
    [a, kUnit] = ismember(unitArray{kUnitIndex}, SessionData.spikeUnitArray);
    
    Unit(kUnitIndex).subjectID = subjectID;
    Unit(kUnitIndex).sessionID = sessionID;
    Unit(kUnitIndex).name = unitArray{kUnitIndex};
    
    rightTargTrial = mem_trial_selection(trialData, {'saccToTarget'}, 'right');
    leftTargTrial = mem_trial_selection(trialData, {'saccToTarget'}, 'left');
    
    for mEpoch = 1 : length(epochArray)
        mEpochName = epochArray{mEpoch};
        
        % Right Target trials
        alignmentTimeList = trialData.(mEpochName)(rightTargTrial);
        Unit(kUnitIndex).rightTarg.(mEpochName).alignTimeList = alignmentTimeList;   % Keep track of trial-by-trial alignemnt
        [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(rightTargTrial, kUnit), alignmentTimeList, maxTrialDuration);
        Unit(kUnitIndex).rightTarg.(mEpochName).alignTime = alignmentIndex;
        if ~isempty(alignedRasters) && size(alignedRasters, 2) > minTrialDuration
            sdf = nanmean(spike_density_function(alignedRasters, Kernel), 1);
            sdfMax(kUnitIndex, mEpoch, 1) = max(sdf);
            Unit(kUnitIndex).rightTarg.(mEpochName).raster = alignedRasters;
            Unit(kUnitIndex).rightTarg.(mEpochName).sdf = sdf;
        else
            Unit(kUnitIndex).rightTarg.(mEpochName).raster = [];
            Unit(kUnitIndex).rightTarg.(mEpochName).sdf = [];
            Unit(kUnitIndex).rightTarg.(mEpochName).alignTime = [];
        end
        
        % Left Target trials
        alignmentTimeList = trialData.(mEpochName)(leftTargTrial);
        Unit(kUnitIndex).leftTarg.(mEpochName).alignTimeList = alignmentTimeList;   % Keep track of trial-by-trial alignemnt
        [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(leftTargTrial, kUnit), alignmentTimeList, maxTrialDuration);
        Unit(kUnitIndex).leftTarg.(mEpochName).alignTime = alignmentIndex;
        if ~isempty(alignedRasters) && size(alignedRasters, 2) > minTrialDuration
            sdf = nanmean(spike_density_function(alignedRasters, Kernel), 1);
            sdfMax(kUnitIndex, mEpoch, 2) = max(sdf);
            Unit(kUnitIndex).leftTarg.(mEpochName).raster = alignedRasters;
            Unit(kUnitIndex).leftTarg.(mEpochName).sdf = sdf;
        else
            Unit(kUnitIndex).leftTarg.(mEpochName).raster = [];
            Unit(kUnitIndex).leftTarg.(mEpochName).sdf = [];
            Unit(kUnitIndex).leftTarg.(mEpochName).alignTime = [];
        end
        
        
        
    end % mEpoch
    
    
end % kUnitIndex






%%
%**********************   CLASSIFY CELL RESPONSE TYPE    %*************************
for kUnitIndex = 1 : nUnit
    
    
    vis = false;
    mov = false;
    alpha = .05;
    baseEpoch = -99 : 0;
    visEpoch = mem_epoch_range('targOn', 'analyze');
    movEpoch = mem_epoch_range('responseOnset', 'analyze');
    
    
    baseRasR = Unit(kUnitIndex).rightTarg.targOn.raster(:, baseEpoch + Unit(kUnitIndex).rightTarg.targOn.alignTime);
    baseRasL = Unit(kUnitIndex).leftTarg.targOn.raster(:, baseEpoch + Unit(kUnitIndex).leftTarg.targOn.alignTime);
    nBaseSpikeR = nansum(baseRasR, 2);
    nBaseSpikeL = nansum(baseRasL, 2);
    
    
    % Visual cell?
    rightRas = Unit(kUnitIndex).rightTarg.targOn.raster(:, visEpoch + Unit(kUnitIndex).rightTarg.targOn.alignTime);
    nRightSpike = nansum(rightRas, 2);
    [h, p, ci, stats] = ttest2(nBaseSpikeR, nRightSpike);
    if p < alpha && nanmean(nBaseSpikeR) < nanmean(nRightSpike)
        vis = true;
    end
    
    leftRas = Unit(kUnitIndex).leftTarg.targOn.raster(:, visEpoch + Unit(kUnitIndex).leftTarg.targOn.alignTime);
    nLeftSpike = nansum(leftRas, 2);
    [h, p, ci, stats] = ttest2(nBaseSpikeL, nLeftSpike);
    if p < alpha && nanmean(nBaseSpikeL) < nanmean(nLeftSpike)
        vis = true;
    end
    
    
    % Movement cell?
    rightRas = Unit(kUnitIndex).rightTarg.responseOnset.raster(:, movEpoch + Unit(kUnitIndex).rightTarg.responseOnset.alignTime);
    nRightSpike = nansum(rightRas, 2);
    [h, p, ci, stats] = ttest2(nBaseSpikeR, nRightSpike);
    if p < alpha && nanmean(nBaseSpikeR) < nanmean(nRightSpike)
        mov = true;
    end
    
    leftRas = Unit(kUnitIndex).leftTarg.responseOnset.raster(:, movEpoch + Unit(kUnitIndex).leftTarg.responseOnset.alignTime);
    nLeftSpike = nansum(leftRas, 2);
    [h, p, ci, stats] = ttest2(nBaseSpikeL, nLeftSpike);
    if p < alpha && nanmean(nBaseSpikeL) < nanmean(nLeftSpike)
        mov = true;
    end
    
    
    
    if ~vis && ~mov
        Unit(kUnitIndex).cellType = nan;
    elseif vis && ~mov
        Unit(kUnitIndex).cellType = 'visual';
    elseif ~vis && mov
        Unit(kUnitIndex).cellType = 'movement';
    elseif vis && mov
        Unit(kUnitIndex).cellType = 'visuomovement';
    end
end % kUnitIndex

%%
%**********************   PLOTTING    %*************************


if plotFlag
    cMap = ccm_colormap([0 1]);

    kernelMethod = 'gaussian';
    SIGMA = 20;
    kernelMethod = 'postsynaptic potential';
    GROWTH = 1;
    DECAY = 20;
    % kernelIn = [SIGMA];
    
    
    
    
    figureHandle = 2000;
    targLineW = 2;
    
    
    for kUnitIndex = 1 : nUnit
%         colormap([1 1 1; rightTargColor; leftTargColor])
        colormap([1 1 1; cMap(1,:); cMap(2,:)])
        nRow = 2;
        nEpoch = length(epochArray);
        nColumn = nEpoch;
        figureHandle = figureHandle + 1;
        if printPlot
            [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(nRow, nColumn, figureHandle);
        else
            [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = screen_figure(nRow, nColumn, figureHandle);
        end
        clf
        for mEpoch = 1 : nEpoch
            mEpochName = epochArray{mEpoch};
            epochRangeDisplay = mem_epoch_range(mEpochName, 'plot');
            epochRangeAnalysis = mem_epoch_range(mEpochName, 'analyze');
            
            yLimMax = max(sdfMax(kUnitIndex, :)) * 1.1;
            
            % _______  Set up axes  ___________
            % axes names
            axSDF = 1;
            axRas = 2;
            
            % Set up plot axes
            % SDFs
            ax(axSDF, mEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axSDF, mEpoch) yAxesPosition(axSDF, mEpoch) axisWidth axisHeight]);
            set(ax(axSDF, mEpoch), 'ylim', [0 yLimMax], 'xlim', [epochRangeDisplay(1) epochRangeDisplay(end)])
            cla
            hold(ax(axSDF, mEpoch), 'on')
            title(epochArray{mEpoch})
            
            
            % Rasters
            ax(axRas, mEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axRas, mEpoch) yAxesPosition(axRas, mEpoch) axisWidth axisHeight]);
            set(ax(axRas, mEpoch), 'ylim', [0 rasYlim], 'xlim', [epochRangeDisplay(1) epochRangeDisplay(end)])
            cla
            hold(ax(axRas, mEpoch), 'on')
            
            
            if mEpoch > 1
                set(ax(axSDF, mEpoch), 'yticklabel', [])
                set(ax(axRas, mEpoch), 'yticklabel', [])
                
                set(ax(axSDF, mEpoch), 'ycolor', [1 1 1])
                set(ax(axRas, mEpoch), 'ycolor', [1 1 1])
            end
            
            
            
            alignRightTarg = Unit(kUnitIndex).rightTarg.(mEpochName).alignTime;
            alignLeftTarg = Unit(kUnitIndex).leftTarg.(mEpochName).alignTime;
            
            axes(ax(axSDF, mEpoch))
            fillX = [epochRangeAnalysis(1), epochRangeAnalysis(end), epochRangeAnalysis(end), epochRangeAnalysis(1)];
            fillY = [.1 .1 yLimMax yLimMax];
            fillColor = [1 1 .5];
            h = fill(fillX, fillY, fillColor);
            set(h, 'edgecolor', 'none');
            
            if strcmp(mEpochName, 'targOn')
                fillX = [baseEpoch(1), baseEpoch(end), baseEpoch(end), baseEpoch(1)];
                fillY = [.1 .1 yLimMax yLimMax];
                fillColor = [.8 .8 .8];
                b = fill(fillX, fillY, fillColor);
                set(b, 'edgecolor', 'none');
            end
            
            % Alignemnt line
            plot(ax(axSDF, mEpoch), [1 1], [0 yLimMax * .9], '-k', 'linewidth', 2)
            % Right SDFs
            if ~isempty(alignRightTarg)
                sdfRightTarg = Unit(kUnitIndex).rightTarg.(mEpochName).sdf;
                plot(ax(axSDF, mEpoch), epochRangeDisplay, sdfRightTarg(alignRightTarg + epochRangeDisplay), 'color', cMap(1,:), 'linewidth', targLineW)
            end
            % Left SDFs
            if ~isempty(alignLeftTarg)
                sdfLeftTarg = Unit(kUnitIndex).leftTarg.(mEpochName).sdf;
                plot(ax(axSDF, mEpoch), epochRangeDisplay, sdfLeftTarg(alignLeftTarg + epochRangeDisplay), 'color', cMap(2,:), 'linewidth', targLineW)
            end
            
            axes(ax(axRas, mEpoch))
            rasRightTarg =  Unit(kUnitIndex).rightTarg.(mEpochName).raster;
            rightTargRas = fat_raster(rasRightTarg, tickWidth);
            rightTargRas = rightTargRas .* .5;
            imagesc(epochRangeDisplay, 1 : size(rasRightTarg, 1), rightTargRas(:, alignRightTarg + epochRangeDisplay))
            
            rasLeftTarg =  Unit(kUnitIndex).leftTarg.(mEpochName).raster;
            leftTargRas = fat_raster(rasLeftTarg, tickWidth);
            imagesc(epochRangeDisplay, size(rasRightTarg, 1) : size(rasLeftTarg, 1), leftTargRas(:, alignLeftTarg + epochRangeDisplay))
            
            plot(ax(axRas, mEpoch), [1 1], [0 rasYlim * .9], '-k', 'linewidth', 2)
            
            
        end
        
    end % mEpoch
    
    %                             legend(ax(axGo, 1), {num2cell(pSignalArray'), num2str(pSignalArray')})
    
    %         colorbar('peer', ax(axGo, 1), 'location', 'west')
    %         colorbar('peer', ax(axStopGo, 1), 'location', 'west')
    h=axes('Position', [0 0 1 1], 'Visible', 'Off');
    titleString = sprintf('%s \t %s', sessionID, Unit(kUnitIndex).name);
    text(0.5,1, titleString, 'HorizontalAlignment','Center', 'VerticalAlignment','Top', 'color', 'k')
    if printPlot
        localFigurePath = local_figure_path;
        print(figureHandle,[localFigurePath, sessionID, '_', unitArray{kUnitIndex}, '_mem_single_neuron'],'-dpdf', '-r300')
    end
end % kUnitIndex


end % plotFlag

