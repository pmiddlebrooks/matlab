function Data = ccm_session_data(subjectID, sessionID, options)%dataType, varargin)
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
clear Data

if nargin < 3
   options.dataType = 'neuron';
   
   options.figureHandle     = 1000;
   options.printPlot        = false;
   options.plotFlag         = true;
   options.collapseSignal   = false;
   options.collapseTarg      = false;
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
collapseSignal = options.collapseSignal;
doStops = options.doStops;
normalize = options.normalize;
filterData = options.filterData;
unitArray = options.unitArray;



% Load the data
[trialData, SessionData, ExtraVar] = load_data(subjectID, sessionID);
pSignalArray    = ExtraVar.pSignalArray;
targAngleArray	= ExtraVar.targAngleArray;
ssdArray        = ExtraVar.ssdArray;
nSSD            = length(ssdArray);

if ~strcmp(SessionData.taskID, 'ccm')
   fprintf('Not a chioce countermanding saccade session, try again\n')
   return
end



% CONSTANTS
MIN_RT          = 120;
MAX_RT          = 1200;
STD_MULTIPLE    = 3;

Kernel.method = 'postsynaptic potential';
Kernel.growth = 1;
Kernel.decay = 20;

% Kernel.method = 'gaussian';
% Kernel.sigma = 10;


cropWindow  = -1000 : 1500;  % used to extract a semi-small portion of signal for each epoch/alignemnt
baseWindow 	= -149 : 0;   % To baseline-shift the eeg signals, relative to event alignment index;







% Set defaults
dataType = options.dataType;
switch dataType
   case 'neuron'
      dataArray     = SessionData.spikeUnitArray;
      if strcmp(unitArray, 'each')
         unitArray     = dataArray;
      end
   case 'lfp'
      dataArray 	= num2cell(SessionData.lfpChannel);
      if strcmp(unitArray, 'each')
         unitArray 	= dataArray;
      end
   case 'erp'
      dataArray     = eeg_electrode_map(subjectID);
      if strcmp(unitArray, 'each')
         unitArray     = dataArray;
      end
end
% Make sure user input a dataType that was recorded during the session
dataTypePossible = {'neuron', 'lfp', 'erp'};
if ~sum(strcmp(dataType, dataTypePossible))
   fprintf('%s Is not a valid data type \n', dataType)
   return
end
if isempty(unitArray)
   fprintf('Session %s apparently does not contain %s data \n', sessionID, dataType)
   return
end


% If collapsing into all left and all right need to note here that there are "2" angles to deal with
% (important for calling ccm_trial_selection.m)
leftTargInd = (targAngleArray < -89) & (targAngleArray > -270) | ...
   (targAngleArray > 90) & (targAngleArray < 269);
rightTargInd = ~leftTargInd;
if options.collapseTarg
   nTargPair = 1;
else
   nTargPair = sum(rightTargInd);
   % do nothing, all target angles will be considered separately
end





% epochArray = {'fixWindowEntered', 'targOn', 'checkerOn', 'stopSignalOn', 'responseOnset', 'rewardOn'};
epochArray = {'fixWindowEntered', 'targOn', 'checkerOn', 'stopSignalOn', 'responseOnset', 'rewardOn'};
epochArray = {'fixWindowEntered', 'targOn', 'checkerOn', 'stopSignalOn', 'responseOnset', 'toneOn', 'rewardOn'};
nEpoch = length(epochArray);
nOutcome = 5; % Used to find the maximum signal levels for normalization if desired





% How many units were recorded?
% nUnit = size(unitArray, 2);
nUnit = length(unitArray);



% Get rid of trials with outlying RTs
[allRT, rtOutlierTrial] = truncate_rt(trialData.rt, MIN_RT, MAX_RT, STD_MULTIPLE);
% rtOutlierTrial = [];
trialData.rt(rtOutlierTrial) = nan;
% trialData(rtOutlierTrial,:) = [];




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
if isempty(ssdArray) || ~doStops
   disp('ccm_inhibition.m: No stop trials or stop trial analyses not requested');
   doStops = false;
end





[minTrialDuration,i] = min(trialData.trialDuration(~strcmp(trialData.trialOutcome, 'fixationAbort')));
[maxTrialDuration,i] = max(trialData.trialDuration(~strcmp(trialData.trialOutcome, 'fixationAbort')));

for kDataIndex = 1 : nUnit
   switch dataType
      case 'neuron'
         [a, kUnit] = ismember(unitArray{kDataIndex}, SessionData.spikeUnitArray);
      case 'lfp'
         [a, kUnit] = ismember(unitArray{kDataIndex}, SessionData.lfpChannel);
      case 'erp'
         [a, kUnit] = ismember(unitArray{kDataIndex}, eeg_electrode_map(subjectID));
   end
   
   
   % Get default trial selection options
   selectOpt = ccm_trial_selection;
   
   % Loop through all right targets (or collapse them if desired) and
   % account for all target pairs if the session had more than one target
   % pair
   for jTarg = 1 : nTargPair
      
      
      
      
      yMax = zeros(nEpoch, nSignal, nSSD+1, nOutcome);  % Keep track of maximum signal values, for setting y-axis limits in plots
      yMin = zeros(nEpoch, nSignal, nSSD+1, nOutcome);  % Keep track of maximum signal values, for setting y-axis limits in plots
      
      Data(kDataIndex, jTarg).subjectID = subjectID;
      Data(kDataIndex, jTarg).sessionID = sessionID;
      Data(kDataIndex, jTarg).name = unitArray{kDataIndex};
      Data(kDataIndex, jTarg).ssdArray = ssdArray;
      Data(kDataIndex, jTarg).pSignalArray = pSignalArray;
      
      
      
      
      % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % LOOP THROUGH SIGNAL STRENGTHS
      % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
         selectOpt.rightCheckerPct = iPct;
         
         
         
         
         
         
         %       if collapseSignal
         %          targetHemifield = 'all';
         %       else
         %          % If it's not 50% or if there's only one 50% condition in
         %          % targPropArray
         %          if iPct ~= 50 || (iPct == 50 &&  pSignalArray(iPropIndex-1) ~= 50 &&  pSignalArray(iPropIndex+1) ~= 50)
         %             targetHemifield = 'all';
         %             % If it's the first (left target) 50% condition
         %          elseif iPct == 50 && pSignalArray(iPropIndex-1) ~= 50
         %             targetHemifield = 'left';
         %             % If it's the second (right target) 50% condition
         %          elseif iPct == 50 && pSignalArray(iPropIndex-1) == 50
         %             targetHemifield = 'right';
         %          end
         %       end
         
         % If collapsing into all left and all right or all up/all down,
         % need to note here that there are "2" angles to deal with
         % (important for calling ccm_trial_selection.m)
         if options.collapseTarg && iPct(1) > 50
            jAngle = 'right';
         elseif options.collapseTarg && iPct(1) < 50
            jAngle = 'left';
         else
            if iPct(1) > 50
               rightTargArray = targAngleArray(rightTargInd);
               jAngle = rightTargArray(jTarg);
            elseif iPct(1) < 50
               leftTargArray = targAngleArray(leftTargInd);
               jAngle = leftTargArray(jTarg);
            end
         end
         selectOpt.targDir = jAngle;
         
         
         
         
         
         % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %              GO TRIALS
         % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         selectOpt.ssd = 'none';
         % Select appropriate trials to analyzie
         selectOpt.outcome     = {'goCorrectTarget', 'targetHoldAbort'};
         iGoTargTrial = ccm_trial_selection(trialData, selectOpt);
         selectOpt.outcome     = {'goCorrectDistractor', 'distractorHoldAbort'};
         iGoDistTrial = ccm_trial_selection(trialData, selectOpt);
         
         
         
         for mEpoch = 1 : length(epochArray)
            mEpochName = epochArray{mEpoch};
            if ~strcmp(mEpochName, 'stopSignalOn')  % No stop signals on go trials
               
               alignListGoTarg = trialData.(mEpochName)(iGoTargTrial);
               Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).alignTimeList = alignListGoTarg;   % Keep track of trial-by-trial alignemnt
               alignListGoDist = trialData.(mEpochName)(iGoDistTrial);
               Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).alignTimeList = alignListGoDist;   % Keep track of trial-by-trial alignemnt
               
               
               switch dataType
                  case 'neuron'
                     % Go to Target trials
                     [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(iGoTargTrial, kUnit), alignListGoTarg);
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).alignTime = alignmentIndex;
                     sdf = spike_density_function(alignedRasters, Kernel);
                     if ~isempty(sdf); yMax(mEpoch, iPropIndex, 1, 1) = nanmax(nanmean(sdf, 1)); end;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).raster = alignedRasters;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdf = sdf;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdfMean = nanmean(sdf, 1);
                     
                     % Go to Distractor trials
                     [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(iGoDistTrial, kUnit), alignListGoDist);
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).alignTime = alignmentIndex;
                     sdf = spike_density_function(alignedRasters, Kernel);
                     if ~isempty(sdf); yMax(mEpoch, iPropIndex, 1, 2) = nanmax(nanmean(sdf, 1)); end;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).raster = alignedRasters;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdf = sdf;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdfMean = nanmean(sdf, 1);
                     
                  case 'lfp'
                     % Go to Target trials
                     [targLFP, alignIndex] 	= align_signals(trialData.lfpData(iGoTargTrial, kUnit), alignListGoTarg, cropWindow);
                     satTrial                = signal_reject_saturate(targLFP, 'alignIndex', alignIndex);
                     targLFP(satTrial,:)     = [];
                     targLFP                 = signal_baseline_correct(targLFP, baseWindow, alignIndex);
                     if filterData
                        targLFPMean = lowpass(nanmean(targLFP, 1)', options.stopHz);
                     else
                        targLFPMean = nanmean(targLFP, 1);
                     end
                     
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).alignTime = alignIndex;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfp = targLFP;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfpMean = targLFPMean;
                     if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                        if ~isempty(targLFP)
                           yMax(mEpoch, iPropIndex, 1, 1) = nanmax(nanmean(targLFP, 1));
                           yMin(mEpoch, iPropIndex, 1, 1) = nanmin(nanmean(targLFP, 1));
                        end
                     end
                     
                     % Go to Distractor trials
                     [distLFP, alignIndex]	= align_signals(trialData.lfpData(iGoDistTrial, kUnit), alignListGoDist, cropWindow);
                     satTrial                = signal_reject_saturate(distLFP, 'alignIndex', alignIndex);
                     distLFP(satTrial,:)     = [];
                     distLFP                 = signal_baseline_correct(distLFP, baseWindow, alignIndex);
                     if filterData
                        distLFPMean = lowpass(nanmean(distLFP, 1)', options.stopHz);
                     else
                        distLFPMean = nanmean(distLFP, 1);
                     end
                     
                     
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).alignTime = alignIndex;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfp = distLFP;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfpMean = distLFPMean;
                     if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                        if ~isempty(distLFP)
                           yMax(mEpoch, iPropIndex, 1, 2) = nanmax(nanmean(distLFP, 1));
                           yMin(mEpoch, iPropIndex, 1, 2) = nanmin(nanmean(distLFP, 1));
                        end
                     end
                     
                     
                     
                     
                  case 'erp'
                     % Go to Target trials
                     [targEEG, alignIndex] 	= align_signals(trialData.eegData(iGoTargTrial, kUnit), alignListGoTarg, cropWindow);
                     satTrial                = signal_reject_saturate(targEEG, 'alignIndex', alignIndex);
                     targEEG(satTrial,:)     = [];
                     targEEG                 = signal_baseline_correct(targEEG, baseWindow, alignIndex);
                     if filterData
                        targEEGMean = lowpass(nanmean(targEEG, 1)', options.stopHz);
                     else
                        targEEGMean = nanmean(targEEG, 1);
                     end
                     
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).alignTime = alignIndex;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).eeg = targEEG;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).erp = targEEGMean;
                     if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                        if ~isempty(targEEG)
                           yMax(kDataIndex, mEpoch, iPropIndex, 1) = nanmax(nanmean(targEEG, 1));
                           yMin(kDataIndex, mEpoch, iPropIndex, 1) = nanmin(nanmean(targEEG, 1));
                        end
                     end
                     
                     % Go to Distractor trials
                     [distEEG, alignIndex]	= align_signals(trialData.eegData(iGoDistTrial, kUnit), alignListGoDist, cropWindow);
                     satTrial                = signal_reject_saturate(distEEG, 'alignIndex', alignIndex);
                     distEEG(satTrial,:)     = [];
                     distEEG                 = signal_baseline_correct(distEEG, baseWindow, alignIndex);
                     if filterData
                        distEEGMean = lowpass(nanmean(distEEG, 1)', options.stopHz);
                     else
                        distEEGMean = nanmean(distEEG, 1);
                     end
                     
                     
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).alignTime = alignIndex;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).eeg = distEEG;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).erp = distEEGMean;
                     if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                        % if ~isempty(targEEG)
                        %                         yMax(mEpoch, iPropIndex, 1, 2) = nanmax(nanmean(distEEG, 1));
                        %                         yMin(mEpoch, iPropIndex, 1, 2) = nanmin(nanmean(distEEG, 1));
                        %                      end
                     end
                     
               end % switch dataType
            end % ~strcmp(mEpochName, 'stopSignalOn')
         end % mEpoch
         
         
         
         
         
         
         
         % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % Stop trials
         % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
         
         if doStops
         for jSSDIndex = 1 : nSSD
            jSSD = ssdArray(jSSDIndex);
            selectOpt.ssd       = jSSD;
            
            selectOpt.outcome       = {'stopIncorrectTarget', 'targetHoldAbort', 'stopIncorrectPreSSDTarget'};
%             selectOpt.outcome       = {'stopIncorrectTarget', 'targetHoldAbort'};
            jStopTargTrial = ccm_trial_selection(trialData, selectOpt);
            selectOpt.outcome       =  {'stopIncorrectDistractor', 'distractorHoldAbort', 'stopIncorrectPreSSDDistractor'};
%             selectOpt.outcome       =  {'stopIncorrectDistractor', 'distractorHoldAbort'};
            jStopDistTrial = ccm_trial_selection(trialData, selectOpt);
            selectOpt.outcome       = {'stopCorrect'};
            jStopCorrectTrial = ccm_trial_selection(trialData, selectOpt);
            
            for mEpoch = 1 : length(epochArray)
               mEpochName = epochArray{mEpoch};
               
               alignListStopTarg = trialData.(mEpochName)(jStopTargTrial);
               Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTimeList = alignListStopTarg;   % Keep track of trial-by-trial alignemnt
               alignListStopDist = trialData.(mEpochName)(jStopDistTrial);
               Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTimeList = alignListStopDist;   % Keep track of trial-by-trial alignemnt
               alignListStopCorrect = trialData.(mEpochName)(jStopCorrectTrial);
               Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).alignTimeList = alignListStopCorrect;   % Keep track of trial-by-trial alignemnt
               
               
               
               switch dataType
                  case 'neuron'
                     % Stop to Target trials
                     [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(jStopTargTrial, kUnit), alignListStopTarg);
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
                     
                     sdf = spike_density_function(alignedRasters, Kernel);
                     if ~isempty(sdf); yMax(mEpoch, iPropIndex, jSSDIndex+1, 3) = nanmax(nanmean(sdf, 1)); end;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdf = sdf;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdfMean = nanmean(sdf, 1);
                     
                     
                     % Stop to Distractor trials
                     [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(jStopDistTrial, kUnit), alignListStopDist );
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
                     
                     sdf = spike_density_function(alignedRasters, Kernel);
                     if ~isempty(sdf); yMax(mEpoch, iPropIndex, jSSDIndex+1, 4) = nanmax(nanmean(sdf, 1)); end;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdf = sdf;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdfMean = nanmean(sdf, 1);
                     
                     
                     if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
                        % Stop to Target trials
                        [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(jStopCorrectTrial, kUnit), alignListStopCorrect);
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
                        
                        sdf = spike_density_function(alignedRasters, Kernel);
                        if ~isempty(sdf); yMax(mEpoch, iPropIndex, jSSDIndex+1, 5) = nanmax(nanmean(sdf, 1)); end;
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).sdf = sdf;
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).sdfMean = nanmean(sdf, 1);
                        
                     end
                     
                     
                     
                     
                  case 'lfp'
                     
                     % Stop to Target trials
                     [targLFP, alignIndex] 	= align_signals(trialData.lfpData(jStopTargTrial, kUnit), alignListStopTarg, cropWindow);
                     satTrial                = signal_reject_saturate(targLFP, 'alignIndex', alignIndex);
                     targLFP(satTrial,:)     = [];
                     targLFP                 = signal_baseline_correct(targLFP, baseWindow, alignIndex);
                     if filterData
                        targLFPMean = lowpass(nanmean(targLFP, 1)', options.stopHz);
                     else
                        targLFPMean = nanmean(targLFP, 1);
                     end
                     
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfp = targLFP;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfpMean = targLFPMean;
                     if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                        % if ~isempty(targLFP)
                        %                         yMax(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 3) = nanmax(nanmean(targLFP, 1));
                        %                         yMin(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 3) = nanmin(nanmean(targLFP, 1));
                        % end
                     end
                     
                     % Stop to Distractor trials
                     [distLFP, alignIndex] 	= align_signals(trialData.lfpData(jStopDistTrial, kUnit), alignListStopDist, cropWindow);
                     satTrial                = signal_reject_saturate(distLFP, 'alignIndex', alignIndex);
                     distLFP(satTrial,:)     = [];
                     distLFP                 = signal_baseline_correct(distLFP, baseWindow, alignIndex);
                     if filterData
                        distLFPMean = lowpass(nanmean(distLFP, 1)', options.stopHz);
                     else
                        distLFPMean = nanmean(distLFP, 1);
                     end
                     
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfp = distLFP;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfpMean = distLFPMean;
                     if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                        % if ~isempty(distLFP)
                        %                         yMax(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 4) = nanmax(nanmean(distLFP, 1));
                        %                         yMin(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 4) = nanmin(nanmean(distLFP, 1));
                        % end
                     end
                     
                     
                     if ~strcmp(mEpochName, 'responseOnset')  % No response on correct Stop trials
                        % Correct Stop trials
                        [stopLFP, alignIndex] 	= align_signals(trialData.lfpData(jStopCorrectTrial, kUnit), alignListStopCorrect, cropWindow);
                        satTrial                = signal_reject_saturate(stopLFP, 'alignIndex', alignIndex);
                        stopLFP(satTrial,:)     = [];
                        stopLFP                 = signal_baseline_correct(stopLFP, baseWindow, alignIndex);
                        if filterData
                           stopLFPMean = lowpass(nanmean(stopLFP, 1)', options.stopHz);
                        else
                           stopLFPMean = nanmean(stopLFP, 1);
                        end
                        
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).lfp = stopLFP;
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).lfpMean = stopLFPMean;
                        if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                           if ~isempty(stopLFP)
                              yMax(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 5) = nanmax(nanmean(stopLFP, 1));
                              yMin(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 5) = nanmin(nanmean(stopLFP, 1));
                           end
                        end
                        
                     end % jSSD
                     
                     
                     
                  case 'erp'
                     % Stop to Target trials
                     [targEEG, alignIndex] 	= align_signals(trialData.eegData(jStopTargTrial, kUnit), alignListStopTarg, cropWindow);
                     satTrial                = signal_reject_saturate(targEEG, 'alignIndex', alignIndex);
                     targEEG(satTrial,:)     = [];
                     targEEG                 = signal_baseline_correct(targEEG, baseWindow, alignIndex);
                     if filterData
                        targEEGMean = lowpass(nanmean(targEEG, 1)', options.stopHz);
                     else
                        targEEGMean = nanmean(targEEG, 1);
                     end
                     
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).eeg = targEEG;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).erp = targEEGMean;
                     if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                        % if ~isempty(targEEG)
                        %                         yMax(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 3) = nanmax(nanmean(targEEG, 1));
                        %                         yMin(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 3) = nanmin(nanmean(targEEG, 1));
                        %                      end
                     end
                     
                     
                     % Stop to Distractor trials
                     [distEEG, alignIndex] 	= align_signals(trialData.eegData(jStopDistTrial, kUnit), alignListStopDist, cropWindow);
                     satTrial                = signal_reject_saturate(distEEG, 'alignIndex', alignIndex);
                     distEEG(satTrial,:)     = [];
                     distEEG                 = signal_baseline_correct(distEEG, baseWindow, alignIndex);
                     if filterData
                        distEEGMean = lowpass(nanmean(distEEG, 1)', options.stopHz);
                     else
                        distEEGMean = nanmean(distEEG, 1);
                     end
                     
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).eeg = distEEG;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).erp = distEEGMean;
                     if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                        % if ~isempty(distEEG)
                        %                         yMax(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 4) = nanmax(nanmean(distEEG, 1));
                        %                         yMin(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 4) = nanmin(nanmean(distEEG, 1));
                        %                      end
                     end
                     
                     
                     if ~strcmp(mEpochName, 'responseOnset')  % No response on correct Stop trials
                        % Correct Stop trials
                        [stopEEG, alignIndex] 	= align_signals(trialData.eegData(jStopCorrectTrial, kUnit), alignListStopCorrect, cropWindow);
                        satTrial                = signal_reject_saturate(stopEEG, 'alignIndex', alignIndex);
                        stopEEG(satTrial,:)     = [];
                        stopEEG                 = signal_baseline_correct(stopEEG, baseWindow, alignIndex);
                        if filterData
                           stopEEGMean = lowpass(nanmean(stopEEG, 1)', options.stopHz);
                        else
                           stopEEGMean = nanmean(stopEEG, 1);
                        end
                        
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).eeg = stopEEG;
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).erp = stopEEGMean;
                        if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                           if ~isempty(stopEEG)
                              yMax(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 5) = nanmax(nanmean(stopEEG, 1));
                              yMin(kDataIndex, mEpoch, iPropIndex, jSSDIndex + 1, 5) = nanmin(nanmean(stopEEG, 1));
                           end
                        end
                     end
                     
               end % switch dataType
            end % mEpoch
            
         end % jSSD
         end % if doStops
         
      end %iPropIndex
      
      
      
      
      
      
      
      
      a = yMax(:,:,1,:);   % the go trials
      b = yMax(:,:,2:end,:);  % all the stop trials
      c = yMin(:,:,1,:);   % go trials
      d = yMin(:,:,2:end,:);  % stop trials
      
      Data(kDataIndex, jTarg).yMax = max([a(:); nanmean(b(:))]);
      Data(kDataIndex, jTarg).yMin = min([c(:); nanmean(d(:))]);
      %    Data(kDataIndex, jTarg).yMax = max([yMax(:,:,1,:); nanmean(nanmax(yMax(:,:,2:end,:)))]);
      %    Data(kDataIndex, jTarg).yMin = max([yMin(:,:,1,:); nanmean(nanmax(yMin(:,:,2:end,:)))]);
      %    Data(kDataIndex, jTarg).yMin = nanmin(yMin(:));
      
   end % jTarg
end % kDataIndex










% If we want the signal to be normalized to the maximum value for each
% unit/channel, loop back through and normalize here
if normalize
   for kDataIndex = 1 : nUnit
      for iPropIndex = 1 : nSignal;
         for mEpoch = 1 : length(epochArray)
            mEpochName = epochArray{mEpoch};
            
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Go trials
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if ~strcmp(mEpochName, 'stopSignalOn')  % No stop signals on go trials
               
               switch dataType
                  case 'neuron'
                     % Go to Target trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdf = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdf ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdfMean = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdf, 1);
                     
                     % Go to Distractor trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdf = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdf ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdfMean = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdf, 1);
                     
                     
                  case 'lfp'
                     % Go to Target trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfp = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfp ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfpMean = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfp, 1);
                     
                     % Go to Distractor trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfp = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfp ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfpMean = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfp, 1);
                     
                     
                  case 'erp'
                     % Go to Target trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).eeg = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).eeg ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfpMean = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).eeg, 1);
                     
                     % Go to Distractor trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).eeg = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).eeg ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).erp = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).eeg, 1);
                     
                     
               end % switch dataType
            end % ~strcmp(mEpochName, 'stopSignalOn')
            
            
            
            
            
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Stop trials
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if doStops
            for jSSDIndex = 1 : nSSD
               
               switch dataType
                  case 'neuron'
                     % Stop to Target trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdf = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdf ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdfMean = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdf, 1);
                     
                     % Stop to Distractor trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdf = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdf ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdfMean = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdf, 1);
                     
                     if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
                        
                        % Stop Correct trials
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).sdf = ...
                           Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).sdf ./ Data(kDataIndex, jTarg).yMax;
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).sdfMean = ...
                           nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).sdf, 1);
                        
                     end % ~strcmp(mEpochName, 'responseOnset')
                     
                     
                  case 'lfp'
                     
                     % Stop to Target trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfp = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfp ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfpMean = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfp, 1);
                     
                     % Stop to Distractor trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfp = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfp ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfpMean = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfp, 1);
                     
                     if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
                        
                        % Stop Correct trials
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).lfp = ...
                           Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).lfp ./ Data(kDataIndex, jTarg).yMax;
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).lfpMean = ...
                           nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).lfp, 1);
                        
                     end % ~strcmp(mEpochName, 'responseOnset')
                     
                     
                  case 'erp'
                     
                     % Stop to Target trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).eeg = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).eeg ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).erp = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).eeg, 1);
                     
                     % Stop to Distractor trials
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).eeg = ...
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).eeg ./ Data(kDataIndex, jTarg).yMax;
                     Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).erp = ...
                        nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).eeg, 1);
                     
                     if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
                        
                        % Stop Correct trials
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).eeg = ...
                           Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).eeg ./ Data(kDataIndex, jTarg).yMax;
                        Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).erp = ...
                           nanmean(Data(kDataIndex, jTarg).signalStrength(iPropIndex).stopCorrect.ssd(jSSDIndex).(mEpochName).eeg, 1);
                        
                     end % ~strcmp(mEpochName, 'responseOnset')
                     
               end % switch dataType
            end % jSSD
            end % if doStops
         end % mEpoch
      end % for mEpoch = 1 : length(epochArray)
      Data(kDataIndex, jTarg).yMax = 1.1;
      switch dataType
         case 'neuron'
            Data(kDataIndex, jTarg).yMin = 0;
         case {'lfp', 'erp'}
            Data(kDataIndex, jTarg).yMin = -1.1;
      end
   end % for kDataIndex = 1 : nUnit
   
   
end % if normalize



disp('completed data collection')

Data(1).unitArray       = unitArray;
Data(1).dataArray       = dataArray;
Data(1).pSignalArray    = pSignalArray;
Data(1).targAngleArray  = targAngleArray;
Data(1).ssdArray        = ssdArray;
Data(1).sessionID       = sessionID;
Data(1).subjectID       = subjectID;
Data(1).options         = options;


if options.plotFlag
   ccm_session_data_plot(Data, options)
   
end


