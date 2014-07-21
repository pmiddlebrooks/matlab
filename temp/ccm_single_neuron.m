function Unit = ccm_single_neuron(subjectID, sessionID, varargin)

%
% function Unit = ccm_single_neuron(subjectID, sessionID, plotFlag, unitArray)
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
% subjectID = 'Broca';
% % sessionID = 'bp087n02';
% % sessionID = 'bp088n02';
% % sessionID = 'bp089n02';
% sessionID = 'bp090n02';
% sessionID = 'bp091n02';
% sessionID = 'bp092n02';
% sessionID = 'bp093n02';
% % sessionID = 'bp106n01';
% % sessionID = 'bp095n02';

% Load the data
[trialData, SessionData, ExtraVar] = load_data(subjectID, sessionID);
pSignalArray = ExtraVar.pSignalArray;
ssdArray = ExtraVar.ssdArray;

if ~isfield(SessionData, 'spikeUnitArray') || isempty(SessionData.spikeUnitArray)
   fprintf('Session %s does not contain spike data \n', sessionID)
   Unit = [];
   return
end

% Set defaults
plotFlag = 1;
unitArray = SessionData.spikeUnitArray;
printPlot = 0; % If set to 1, this collapses data across signal strengths (within each hemifield)
figureHandle = 1000;
collapseSignal = false;
DO_STOPS = true;
for i = 1 : 2 : length(varargin)
   switch varargin{i}
      case 'plotFlag'
         plotFlag = varargin{i+1};
      case 'unitArray'
         unitArray = varargin{i+1};
      case 'printPlot'
         printPlot = varargin{i+1};
      case 'figureHandle'
         figureHandle = varargin{i+1};
      case 'collapseSignal'
         collapseSignal = varargin{i+1};
      case 'doStops'
         DO_STOPS = varargin{i+1};
      otherwise
   end
end

clear Unit
% constants
MIN_RT = 120;
MAX_RT = 1200;
STD_MULTIPLE = 3;

Kernel.method = 'postsynaptic potential';
Kernel.growth = 1;
Kernel.decay = 20;

% epochArray = {'fixWindowEntered', 'targOn', 'checkerOn', 'stopSignalOn', 'responseOnset', 'rewardOn'};
epochArray = {'fixWindowEntered', 'targOn', 'checkerOn', 'stopSignalOn', 'responseOnset', 'rewardOn'};
nEpoch = length(epochArray);






% How many units were recorded?
nUnit = size(unitArray, 2);



% Get rid of trials with outlying RTs
[allRT, rtOutlierTrial] = truncate_rt(trialData.rt, MIN_RT, MAX_RT, STD_MULTIPLE);
% rtOutlierTrial = [];
trialData.rt(rtOutlierTrial) = nan;
% trialData(rtOutlierTrial,:) = [];




nTrial = size(trialData, 1);
DO_50 = false;
if DO_50
   % Add a second 50% signal strength to distinguish between targ1 and targ2
   % trials
   if ismember(.5, pSignalArray)
      [a,i] = ismember(.5, pSignalArray);
      pSignalArray = [pSignalArray(1 : i) ; .5; pSignalArray(i+1 : end)];
   end
else
   if ismember(.5, pSignalArray)
      [a,i] = ismember(.5, pSignalArray);
      pSignalArray(i) = [];
   end
end

nSignal = length(pSignalArray);
% If collapsing data across signal strength, adjust the pSignalArray here
if collapseSignal
   nSignal = 2;
end





% If there weren't stop trials, skip all stop-related analyses
if isempty(ssdArray) || ~DO_STOPS
   disp('ccm_single_neuron.m: No stop trials or stop trial analyses not requested');
   DO_STOPS = false;
end





[minTrialDuration,i] = min(trialData.trialDuration(~strcmp(trialData.trialOutcome, 'fixationAbort')));
[maxTrialDuration,i] = max(trialData.trialDuration(~strcmp(trialData.trialOutcome, 'fixationAbort')));
nCondition = 5;
sdfMax = zeros(nUnit, nEpoch, nSignal, nCondition);  % Keep track of maximum sdf values, for setting y-axis limits in plots

for kUnitIndex = 1 : nUnit
   [a, kUnit] = ismember(unitArray{kUnitIndex}, SessionData.spikeUnitArray);
   
   Unit(kUnitIndex).subjectID = subjectID;
   Unit(kUnitIndex).sessionID = sessionID;
   Unit(kUnitIndex).name = unitArray{kUnitIndex};
   Unit(kUnitIndex).ssdArray = ssdArray;
   Unit(kUnitIndex).pSignalArray = pSignalArray;
   
   for iPropIndex = 1 : nSignal;
      
      
      % If we're collapsing over signal strength or we actually only have
      % 2 levels of signal, determine which iPct (signal) to use this
      % loop iteration
      if iPropIndex == 1 && nSignal == 2
         iPct = pSignalArray(pSignalArray < .5);
      elseif iPropIndex == 2 && nSignal == 2
         iPct = pSignalArray(pSignalArray > .5);
      else
         iPct = pSignalArray(iPropIndex);
      end
      iPct = iPct .* 100;
      
      %   Go trials:
      ssdRange = 'none';
      
      if collapseSignal
         targetHemifield = 'all';
      else
         % If it's not 50% or if there's only one 50% condition in
         % targPropArray
         if iPct ~= 50 || (iPct == 50 &&  pSignalArray(iPropIndex-1) ~= 50 &&  pSignalArray(iPropIndex+1) ~= 50)
            targetHemifield = 'all';
            % If it's the first (left target) 50% condition
         elseif iPct == 50 && pSignalArray(iPropIndex-1) ~= 50
            targetHemifield = 'left';
            % If it's the second (right target) 50% condition
         elseif iPct == 50 && pSignalArray(iPropIndex-1) == 50
            targetHemifield = 'right';
         end
      end
      
      % Select appropriate trials to analyzie
      iGoTargTrial = ccm_trial_selection(trialData, {'goCorrectTarget'; 'targetHoldAbort'}, iPct, ssdRange, targetHemifield);
      iGoDistTrial = ccm_trial_selection(trialData, {'goCorrectDistractor', 'distractorHoldAbort'}, iPct, ssdRange, targetHemifield);
      
      for mEpoch = 1 : length(epochArray)
         mEpochName = epochArray{mEpoch};
         if ~strcmp(mEpochName, 'stopSignalOn')  % No stop signals on go trials
            
            % Go to Target trials
            alignmentTimeList = trialData.(mEpochName)(iGoTargTrial);
            Unit(kUnitIndex).signalStrength(iPropIndex).goTarg.(mEpochName).alignTimeList = alignmentTimeList;   % Keep track of trial-by-trial alignemnt
            [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(iGoTargTrial, kUnit), alignmentTimeList, maxTrialDuration);
            Unit(kUnitIndex).signalStrength(iPropIndex).goTarg.(mEpochName).alignTime = alignmentIndex;
            sdf = nanmean(spike_density_function(alignedRasters, Kernel), 1);
            if ~isempty(sdf); sdfMax(kUnitIndex, mEpoch, iPropIndex, 1) = max(sdf); end;
            Unit(kUnitIndex).signalStrength(iPropIndex).goTarg.(mEpochName).raster = alignedRasters;
            Unit(kUnitIndex).signalStrength(iPropIndex).goTarg.(mEpochName).sdf = sdf;
            
            % Go to Distractor trials
            alignmentTimeList = trialData.(mEpochName)(iGoDistTrial);
            Unit(kUnitIndex).signalStrength(iPropIndex).goDist.(mEpochName).alignTimeList = alignmentTimeList;   % Keep track of trial-by-trial alignemnt
            [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(iGoDistTrial, kUnit), alignmentTimeList, maxTrialDuration);
            Unit(kUnitIndex).signalStrength(iPropIndex).goDist.(mEpochName).alignTime = alignmentIndex;
            sdf = nanmean(spike_density_function(alignedRasters, Kernel), 1);
            Unit(kUnitIndex).signalStrength(iPropIndex).goDist.(mEpochName).raster = alignedRasters;
            Unit(kUnitIndex).signalStrength(iPropIndex).goDist.(mEpochName).sdf = sdf;
         end
      end % mEpoch
      
      
      
      %         function Unit = spike_unit_data(Unit, kUnitIndex, conditionName, iPropIndex, mEpochName)
      
      
      
      
      % Stop trials
      for jSSDIndex = 1 : length(ssdArray)
         jSSD = ssdArray(jSSDIndex);
         %         jSSD = 'all';
         
         jStopTargTrial = ccm_trial_selection(trialData,  {'stopIncorrectTarget', 'targetHoldAbort', 'stopIncorrectPreSSDTarget'}, iPct, jSSD, targetHemifield);
         jStopDistTrial = ccm_trial_selection(trialData,  {'stopIncorrectDistractor', 'distractorHoldAbort', 'stopIncorrectPreSSDDistractor'}, iPct, jSSD, targetHemifield);
         jStopCorrectTrial = ccm_trial_selection(trialData,  {'stopCorrect'}, iPct, jSSD, targetHemifield);
         
         for mEpoch = 1 : length(epochArray)
            mEpochName = epochArray{mEpoch};
            
            % Stop to Target trials
            alignmentTimeList = trialData.(mEpochName)(jStopTargTrial);
            Unit(kUnitIndex).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTimeList = alignmentTimeList;   % Keep track of trial-by-trial alignemnt
            [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(jStopTargTrial, kUnit), alignmentTimeList, maxTrialDuration);
            Unit(kUnitIndex).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
            sdf = nanmean(spike_density_function(alignedRasters, Kernel), 1);
            Unit(kUnitIndex).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
            Unit(kUnitIndex).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdf = sdf;
            
            % Stop to Distractor trials
            alignmentTimeList = trialData.(mEpochName)(jStopDistTrial);
            Unit(kUnitIndex).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTimeList = alignmentTimeList;   % Keep track of trial-by-trial alignemnt
            [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(jStopDistTrial, kUnit), alignmentTimeList , maxTrialDuration);
            Unit(kUnitIndex).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
            sdf = nanmean(spike_density_function(alignedRasters, Kernel), 1);
            Unit(kUnitIndex).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
            Unit(kUnitIndex).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdf = sdf;
            
            if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
               % Stop to Target trials
               alignmentTimeList = trialData.(mEpochName)(jStopCorrectTrial);
               Unit(kUnitIndex).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).alignTimeList = alignmentTimeList;   % Keep track of trial-by-trial alignemnt
               [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(jStopCorrectTrial, kUnit), alignmentTimeList, maxTrialDuration);
               Unit(kUnitIndex).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
               sdf = nanmean(spike_density_function(alignedRasters, Kernel), 1);
               Unit(kUnitIndex).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
               Unit(kUnitIndex).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).sdf = sdf;
               
            end % jSSD
         end % mEpoch
         
         
      end % jSSDIndex
   end %iPropIndex
   
   
   
   
   
   
   
   
   
   
   
end % kUnitIndex
disp('complete')



%%
% kernelMethod = 'postsynaptic potential';
% GROWTH = 1;
% DECAY = 20;

kernelMethod = 'gaussian';
SIGMA = 20;
kernelMethod = 'postsynaptic potential';
GROWTH = 1;
DECAY = 20;
% kernelIn = [SIGMA];

PLOT_ERROR = false;
epochArray = {'targOn', 'checkerOn', 'stopSignalOn', 'responseOnset', 'rewardOn'};


if plotFlag
   
   if collapseSignal
      cMap = ccm_colormap([0 1]);
   else
      cMap = ccm_colormap(pSignalArray);
   end
   
   targLineW = 2;
   distLineW = 1;
   for kUnitIndex = 1 : nUnit
      nRow = 3;
      nEpoch = length(epochArray);
      nColumn = nEpoch * 2 + 1;
      figureHandle = figureHandle + 1;
      if printPlot
         [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(nRow, nColumn, figureHandle);
      else
         [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = screen_figure(nRow, nColumn, figureHandle);
      end
      clf
      %         boxMargin = .5;
      %         x = xAxesPosition(end, 1);% - boxMargin;
      %         y = yAxesPosition(end, 1);% - boxMargin;
      %         w = axisWidth * nColumn/2;
      %         h = axisHeight * nRow;
      %                 rectangle('Position', [x, y, w, h], 'edgecolor', 'b')
      for mEpoch = 1 : nEpoch
         mEpochName = epochArray{mEpoch};
         epochRange = ccm_epoch_range(mEpochName, 'plot');
         
         yLimMax = max(sdfMax(kUnitIndex, :)) * 1.1;
         
         % _______  Set up axes  ___________
         % axes names
         axGo = 1;
         axStopGo = 2;
         axStopStop = 3;
         
         % Set up plot axes
         % Left target Go trials
         ax(axGo, mEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axGo, mEpoch) yAxesPosition(axGo, mEpoch) axisWidth axisHeight]);
         set(ax(axGo, mEpoch), 'ylim', [0 yLimMax], 'xlim', [epochRange(1) epochRange(end)])
         cla
         hold(ax(axGo, mEpoch), 'on')
         plot(ax(axGo, mEpoch), [1 1], [0 yLimMax * .9], '-k', 'linewidth', 2)
         title(epochArray{mEpoch})
         
         % Right target Go trials
         ax(axGo, mEpoch+nEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axGo, mEpoch+nEpoch+1) yAxesPosition(axGo, mEpoch+nEpoch+1) axisWidth axisHeight]);
         set(ax(axGo, mEpoch+nEpoch), 'ylim', [0 yLimMax], 'xlim', [epochRange(1) epochRange(end)])
         cla
         hold(ax(axGo, mEpoch+nEpoch), 'on')
         plot(ax(axGo, mEpoch+nEpoch), [1 1], [0 yLimMax * .9], '-k', 'linewidth', 2)
         title(epochArray{mEpoch})
         %             set(ax(axRight, mEpoch), 'Xtick', [0 : 100 : epochRange(end) - epochRange(1)], 'XtickLabel', [epochRange(1) : 100: epochRange(end)])
         
         % Left target Stop Incorrect trials
         ax(axStopGo, mEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axStopGo, mEpoch) yAxesPosition(axStopGo, mEpoch) axisWidth axisHeight]);
         set(ax(axStopGo, mEpoch), 'ylim', [0 yLimMax], 'xlim', [epochRange(1) epochRange(end)])
         cla
         hold(ax(axStopGo, mEpoch), 'on')
         plot(ax(axStopGo, mEpoch), [1 1], [0 yLimMax * .9], '-k', 'linewidth', 2)
         
         % Right target Stop Incorrect trials
         ax(axStopGo, mEpoch+nEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axStopGo, mEpoch+nEpoch+1) yAxesPosition(axStopGo, mEpoch+nEpoch+1) axisWidth axisHeight]);
         set(ax(axStopGo, mEpoch+nEpoch), 'ylim', [0 yLimMax], 'xlim', [epochRange(1) epochRange(end)])
         cla
         hold(ax(axStopGo, mEpoch+nEpoch), 'on')
         plot(ax(axStopGo, mEpoch+nEpoch), [1 1], [0 yLimMax * .9], '-k', 'linewidth', 2)
         
         % Left target Stop Correct trials
         ax(axStopStop, mEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axStopStop, mEpoch) yAxesPosition(axStopStop, mEpoch) axisWidth axisHeight]);
         set(ax(axStopStop, mEpoch), 'ylim', [0 yLimMax], 'xlim', [epochRange(1) epochRange(end)])
         cla
         hold(ax(axStopStop, mEpoch), 'on')
         plot(ax(axStopStop, mEpoch), [1 1], [0 yLimMax * .9], '-k', 'linewidth', 2)
         
         % Right target Stop Correct trials
         ax(axStopStop, mEpoch+nEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axStopStop, mEpoch+nEpoch+1) yAxesPosition(axStopStop, mEpoch+nEpoch+1) axisWidth axisHeight]);
         set(ax(axStopStop, mEpoch+nEpoch), 'ylim', [0 yLimMax], 'xlim', [epochRange(1) epochRange(end)])
         cla
         hold(ax(axStopStop, mEpoch+nEpoch), 'on')
         plot(ax(axStopStop, mEpoch+nEpoch), [1 1], [0 yLimMax * .9], '-k', 'linewidth', 2)
         
         if mEpoch > 1
            set(ax(axGo, mEpoch), 'yticklabel', [])
            set(ax(axGo, mEpoch+nEpoch), 'yticklabel', [])
            set(ax(axStopGo, mEpoch), 'yticklabel', [])
            set(ax(axStopGo, mEpoch+nEpoch), 'yticklabel', [])
            set(ax(axStopStop, mEpoch), 'yticklabel', [])
            set(ax(axStopStop, mEpoch+nEpoch), 'yticklabel', [])
            
            set(ax(axGo, mEpoch), 'ycolor', [1 1 1])
            set(ax(axGo, mEpoch+nEpoch), 'ycolor', [1 1 1])
            set(ax(axStopGo, mEpoch), 'ycolor', [1 1 1])
            set(ax(axStopGo, mEpoch+nEpoch), 'ycolor', [1 1 1])
            set(ax(axStopStop, mEpoch), 'ycolor', [1 1 1])
            set(ax(axStopStop, mEpoch+nEpoch), 'ycolor', [1 1 1])
         end
         % __________ Loop signal strengths and plot  _________
         % First the left target trials
         for i = 1 : nSignal/2
            iPropIndex = nSignal/2 + 1 - i;
            
            % Go trials
            if ~strcmp(mEpochName, 'stopSignalOn')  % No stop signals on go trials
               alignGoTarg = Unit(kUnitIndex).signalStrength(iPropIndex).goTarg.(mEpochName).alignTime;
               alignGoDist = Unit(kUnitIndex).signalStrength(iPropIndex).goDist.(mEpochName).alignTime;
               if ~isempty(alignGoTarg)
                  sdfGoTarg = Unit(kUnitIndex).signalStrength(iPropIndex).goTarg.(mEpochName).sdf;
                  %                         plot(ax(axGo, mEpoch), epochRange, sdfGoTarg(alignGoTarg + epochRange), 'color', goC(iPropIndex,:), 'linewidth', targLineW)
                  plot(ax(axGo, mEpoch), epochRange, sdfGoTarg(alignGoTarg + epochRange), 'color', cMap(iPropIndex,:), 'linewidth', targLineW)
               end
               if ~isempty(alignGoDist) && PLOT_ERROR
                  sdfGoDist = Unit(kUnitIndex).signalStrength(iPropIndex).goDist.(mEpochName).sdf;
                  plot(ax(axGo, mEpoch), epochRange, sdfGoDist(alignGoDist + epochRange), '--', 'color', goC(iPropIndex,:), 'linewidth', distLineW)
               end
            end
            
            
            % Stop signal trials
            stopTargRas = cell(1, length(ssdArray));
            stopTargAlign = cell(1, length(ssdArray));
            stopDistRas = cell(1, length(ssdArray));
            stopDistAlign = cell(1, length(ssdArray));
            stopCorrectRas = cell(1, length(ssdArray));
            stopCorrectAlign = cell(1, length(ssdArray));
            for jSSDIndex = 1 : length(ssdArray)
               stopTargRas{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).raster;
               stopTargAlign{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime;
               
               stopDistRas{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).raster;
               stopDistAlign{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTime;
               
               if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
                  stopCorrectRas{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).raster;
                  stopCorrectAlign{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).alignTime;
               end
               
            end  % jSSDIndex = 1 : length(ssdArray)
            
            [rasStopTarg, alignStopTarg] = align_raster_sets(stopTargRas, stopTargAlign);
            %                 sdfStopTarg = nanmean(spike_density_function(rasStopTarg, kernelMethod, SIGMA), 1);
            sdfStopTarg = nanmean(spike_density_function(rasStopTarg, Kernel), 1);
            if size(sdfStopTarg, 2) == 1, sdfStopTarg = []; end;
            
            [rasStopDist, alignStopDist] = align_raster_sets(stopDistRas, stopDistAlign);
            %                 sdfStopDist = nanmean(spike_density_function(rasStopDist, kernelMethod, SIGMA), 1);
            sdfStopDist = nanmean(spike_density_function(rasStopDist, Kernel), 1);
            if size(sdfStopDist, 2) == 1, sdfStopDist = []; end;
            
            if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
               [rasStopCorrect, alignStopCorrect] = align_raster_sets(stopCorrectRas, stopCorrectAlign);
               %                     sdfStopCorrect = nanmean(spike_density_function(rasStopCorrect, kernelMethod, SIGMA), 1);
               sdfStopCorrect = nanmean(spike_density_function(rasStopCorrect, Kernel), 1);
               if size(sdfStopCorrect, 2) == 1, sdfStopCorrect = []; end;
            end
            
            
            
            
            if ~isempty(sdfStopTarg)
               %                     plot(ax(axStopGo, mEpoch), epochRange, sdfStopTarg(alignStopTarg + epochRange), 'color', stopC(iPropIndex,:), 'linewidth', targLineW)
               plot(ax(axStopGo, mEpoch), epochRange, sdfStopTarg(alignStopTarg + epochRange), 'color', cMap(iPropIndex,:), 'linewidth', targLineW)
            end
            if PLOT_ERROR && ~isempty(sdfStopDist)
               %                     plot(ax(axStopGo, mEpoch), epochRange, sdfStopDist(alignStopDist + epochRange), '--', 'color', stopC(iPropIndex,:), 'linewidth', distLineW)
               plot(ax(axStopGo, mEpoch), epochRange, sdfStopDist(alignStopDist + epochRange), '--', 'color', cMap(iPropIndex,:), 'linewidth', distLineW)
            end
            
            
            if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
               if ~isempty(sdfStopCorrect)
                  %                         plot(ax(axStopStop, mEpoch), epochRange, sdfStopCorrect(alignStopCorrect + epochRange), 'color', stopC(iPropIndex,:), 'linewidth', targLineW)
                  plot(ax(axStopStop, mEpoch), epochRange, sdfStopCorrect(alignStopCorrect + epochRange), 'color', cMap(iPropIndex,:), 'linewidth', targLineW)
               end
            end
            
            
            % Then the right target trials
            %                 iPropIndexR = nSignal + 1 - iPropIndex;  % Reverse order of plotting to keep color overlays similar between left and right target
            iPropIndexR = i + nSignal/2;  % Reverse order of plotting to keep color overlays similar between left and right target
            
            
            % Go trials
            if ~strcmp(mEpochName, 'stopSignalOn')  % No stop signals on go trials
               alignGoTarg = Unit(kUnitIndex).signalStrength(iPropIndexR).goTarg.(mEpochName).alignTime;
               alignGoDist = Unit(kUnitIndex).signalStrength(iPropIndexR).goDist.(mEpochName).alignTime;
               sdfGoTarg = Unit(kUnitIndex).signalStrength(iPropIndexR).goTarg.(mEpochName).sdf;
               sdfGoDist = Unit(kUnitIndex).signalStrength(iPropIndexR).goDist.(mEpochName).sdf;
               
               if ~isempty(sdfGoTarg)
                  %                         plot(ax(axGo, mEpoch + nEpoch), epochRange, sdfGoTarg(alignGoTarg + epochRange), 'color', goC(iPropIndexR,:), 'linewidth', targLineW)
                  plot(ax(axGo, mEpoch + nEpoch), epochRange, sdfGoTarg(alignGoTarg + epochRange), 'color', cMap(iPropIndexR,:), 'linewidth', targLineW)
               end
               if PLOT_ERROR && ~isempty(sdfGoDist)
                  %                         plot(ax(axGo, mEpoch + nEpoch), epochRange, sdfGoDist(alignGoDist + epochRange), '--', 'color', goC(iPropIndexR,:), 'linewidth', distLineW)
                  plot(ax(axGo, mEpoch + nEpoch), epochRange, sdfGoDist(alignGoDist + epochRange), '--', 'color', cMap(iPropIndexR,:), 'linewidth', distLineW)
               end
            end
            
            
            
            % Stop signal trials
            stopTargRas = cell(1, length(ssdArray));
            stopTargAlign = cell(1, length(ssdArray));
            stopDistRas = cell(1, length(ssdArray));
            stopDistAlign = cell(1, length(ssdArray));
            stopCorrectRas = cell(1, length(ssdArray));
            stopCorrectAlign = cell(1, length(ssdArray));
            for jSSDIndex = 1 : length(ssdArray)
               stopTargRas{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndexR).stopTarg.ssd(jSSDIndex).(mEpochName).raster;
               stopTargAlign{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndexR).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime;
               
               if PLOT_ERROR
                  stopDistRas{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndexR).stopDist.ssd(jSSDIndex).(mEpochName).raster;
                  stopDistAlign{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndexR).stopDist.ssd(jSSDIndex).(mEpochName).alignTime;
               end
               
               if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
                  stopCorrectRas{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndexR).stopCorrect.ssd(jSSDIndex).(mEpochName).raster;
                  stopCorrectAlign{jSSDIndex} = Unit(kUnitIndex).signalStrength(iPropIndexR).stopCorrect.ssd(jSSDIndex).(mEpochName).alignTime;
               end
               
            end  % jSSDIndex = 1 : length(ssdArray)
            
            
            [rasStopTarg, alignStopTarg] = align_raster_sets(stopTargRas, stopTargAlign);
            %                 sdfStopTarg = nanmean(spike_density_function(rasStopTarg, kernelMethod, SIGMA), 1);
            sdfStopTarg = nanmean(spike_density_function(rasStopTarg, Kernel), 1);
            if size(sdfStopTarg, 2) == 1, sdfStopTarg = []; end;
            
            [rasStopDist, alignStopDist] = align_raster_sets(stopDistRas, stopDistAlign);
            %                 sdfStopDist = nanmean(spike_density_function(rasStopDist, kernelMethod, SIGMA), 1);
            sdfStopDist = nanmean(spike_density_function(rasStopDist, Kernel), 1);
            if size(sdfStopDist, 2) == 1, sdfStopDist = []; end;
            
            if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
               [rasStopCorrect, alignStopCorrect] = align_raster_sets(stopCorrectRas, stopCorrectAlign);
               %                     sdfStopCorrect = nanmean(spike_density_function(rasStopCorrect, kernelMethod, SIGMA), 1);
               sdfStopCorrect = nanmean(spike_density_function(rasStopCorrect, Kernel), 1);
               if size(sdfStopCorrect, 2) == 1, sdfStopCorrect = []; end;
            end
            
            
            if ~isempty(sdfStopTarg)
               %                     plot(ax(axStopGo, mEpoch + nEpoch), epochRange, sdfStopTarg(alignStopTarg + epochRange), 'color', stopC(iPropIndexR,:), 'linewidth', targLineW)
               plot(ax(axStopGo, mEpoch + nEpoch), epochRange, sdfStopTarg(alignStopTarg + epochRange), 'color', cMap(iPropIndexR,:), 'linewidth', targLineW)
            end
            if PLOT_ERROR && ~isempty(sdfStopDist)
               %                     plot(ax(axStopGo, mEpoch + nEpoch), epochRange, sdfStopDist(alignStopDist + epochRange), '--', 'color', stopC(iPropIndexR,:), 'linewidth', distLineW)
               plot(ax(axStopGo, mEpoch + nEpoch), epochRange, sdfStopDist(alignStopDist + epochRange), '--', 'color', cMap(iPropIndexR,:), 'linewidth', distLineW)
            end
            if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
               if ~isempty(sdfStopCorrect)
                  %                         plot(ax(axStopStop, mEpoch + nEpoch), epochRange, sdfStopCorrect(alignStopCorrect + epochRange), 'color', stopC(iPropIndexR,:), 'linewidth', targLineW)
                  plot(ax(axStopStop, mEpoch + nEpoch), epochRange, sdfStopCorrect(alignStopCorrect + epochRange), 'color', cMap(iPropIndexR,:), 'linewidth', targLineW)
               end
            end
         end % iPropIndex
         %                       if mEpoch == 3
         %                 colormap(goC);
         %                 legend(ax(axGo, 1), '
         
      end % mEpoch
      
      %                             legend(ax(axGo, 1), {num2cell(pSignalArray'), num2str(pSignalArray')})
      
      %         colorbar('peer', ax(axGo, 1), 'location', 'west')
      %         colorbar('peer', ax(axStopGo, 1), 'location', 'west')
      h=axes('Position', [0 0 1 1], 'Visible', 'Off');
      titleString = sprintf('%s \t %s', sessionID, Unit(kUnitIndex).name);
      text(0.5,1, titleString, 'HorizontalAlignment','Center', 'VerticalAlignment','Top')
      if printPlot
         localFigurePath = local_figure_path;
         print(figureHandle,[localFigurePath, sessionID, '_', unitArray{kUnitIndex}, '_ccm_single_neuron'],'-dpdf', '-r300')
      end
   end % kUnitIndex
   
   
end % plotFlag

