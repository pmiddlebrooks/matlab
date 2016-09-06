function Data = ccm_session_data(subjectID, sessionID, Opt)
%
% function Data = ccm_single_neuron(subjectID, sessionID, plotFlag, Opt.unitArray)
%
% Single neuron analyses for choice countermanding task. Only plots the
% sdfs. To see rasters, use ccm_single_neuron_rasters, which displays all
% conditions in a given epoch
%
% input:
%   subjectID: e.g. 'Broca', 'Xena', 'pm', etc
%   sessionID: e.g. 'bp111n01', 'Allsaccade'
%
%   Opt: A structure with various ways to select/organize data:
%   The following fields of Opt are relevant for ccm_session_data, with
%   possible values (default listed first):
%
%    Opt.dataType = 'neuron', 'lfp', 'erp';
%
%    Opt.figureHandle   = 1000;
%    Opt.printPlot      = false, true;
%    Opt.plotFlag       = true, false;
%    Opt.collapseSignal = false, true;
%    Opt.collapseTarg 	= false, true;
%    Opt.doStops        = true, false;
%    Opt.filterData 	= false, true;
%    Opt.stopHz         = 50, <any number, above which signal is filtered;
%    Opt.normalize      = false, true;
%    Opt.howProcess      = how to step through the list of units
%                                 'each' to plot all,
%                                 'step' (default): step through to see one
%                                 plot at a time, pausing between
%                                 'print' (default): step through each plot
%                                 individually, printing each to file
%    Opt.unitArray      = units you want to analyze (default gets filled
%                                   with all available).
%                                 {'spikeUnit17a'}, input a cell of units for a list of individaul units
%    Opt.baselineCorrect = false, true; Baseline correct analog signals?
%    Opt.hemisphere = which hemsiphere were the data recorded from? left or
%    right?
%
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
clear Data

if nargin < 3
    Opt = ccm_options;
end


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


cropWindow  = -1000 : 2000;  % used to extract a semi-small portion of signal for each epoch/alignemnt
baseWindow 	= -149 : 0;   % To baseline-shift the eeg signals, relative to event alignment index;







% Set defaults
dataType = Opt.dataType;
switch dataType
    case 'neuron'
        dataArray     = SessionData.spikeUnitArray;
    case 'lfp'
        chNum = SessionData.lfpChannel;
        dataArray 	= num2cell(SessionData.lfpChannel);
        dataArray   = cellfun(@(x) sprintf('lfp_%s', num2str(x, '%02d')), dataArray, 'uniformoutput', false);
    case 'erp'
        dataArray     = eeg_electrode_map(subjectID);
end



% If there was not a custom set of units or channels input to process, do
% them all
if isempty(Opt.unitArray)
if strcmp(Opt.howProcess, 'each') || strcmp(Opt.howProcess, 'step') || strcmp(Opt.howProcess, 'print')
    Opt.unitArray     = dataArray;
end
end


% Make sure user input a dataType that was recorded during the session
dataTypePossible = {'neuron', 'lfp', 'erp'};
if ~sum(strcmp(dataType, dataTypePossible))
    fprintf('%s Is not a valid data type \n', dataType)
    return
end
if isempty(Opt.unitArray)
    fprintf('Session %s apparently does not contain %s data \n', sessionID, dataType)
    return
end


% If collapsing into all left and all right need to note here that there are "2" angles to deal with
% (important for calling ccm_trial_selection.m)
leftTargInd = (targAngleArray < -89) & (targAngleArray > -270) | ...
    (targAngleArray > 90) & (targAngleArray < 269);
rightTargInd = ~leftTargInd;
if Opt.collapseTarg
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
nUnit = length(Opt.unitArray);



% Get rid of trials with outlying RTs
[allRT, rtOutlierTrial] = truncate_rt(trialData.rt, MIN_RT, MAX_RT, STD_MULTIPLE);
trialData.rt(rtOutlierTrial) = nan;




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
if Opt.collapseSignal
    nSignal = 2;
end





% If there weren't stop trials, skip all stop-related analyses
if isempty(ssdArray) || ~Opt.doStops
%     disp('ccm_inhibition.m: No stop trials or stop trial analyses not requested');
    Opt.doStops = false;
end





[minTrialDuration,i] = min(trialData.trialDuration(~strcmp(trialData.trialOutcome, 'fixationAbort')));
[maxTrialDuration,i] = max(trialData.trialDuration(~strcmp(trialData.trialOutcome, 'fixationAbort')));




% Get ssrt for the session (to be used for latency matching below)
optInh                  = ccm_options;
optInh.collapseTarg     = true;
optInh.printPlot        = false;
optInh.plotFlag         = false;
dataInh                 = ccm_inhibition(subjectID, sessionID, optInh);
% Which ssrt estimate should we use for latency matching? For now, use a
% collapsed, across color coherence value. Later might want to use
% estimates within each color coherence.
ssrt = dataInh.ssrtCollapseIntegrationWeighted;




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              LOOP THROUGH UNITS/CHANNELS RECORDED
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for kDataInd = 1 : nUnit
    switch dataType
        case 'neuron'
            [a, kUnit] = ismember(Opt.unitArray{kDataInd}, SessionData.spikeUnitArray);
        case 'lfp'
            [a, kUnit] = ismember(chNum(kDataInd), SessionData.lfpChannel);
        case 'erp'
            [a, kUnit] = ismember(Opt.unitArray{kDataInd}, eeg_electrode_map(subjectID));
    end
    
    
    % Get default trial selection Opt
    selectOpt = ccm_options;
    selectOpt.allowRtPreSsd = true;
    
    % Loop through all right targets (or collapse them if desired) and
    % account for all target pairs if the session had more than one target
    % pair
    for jTarg = 1 : nTargPair
        
        
        
        
        yMax = zeros(nEpoch, nSignal, nSSD+1, nOutcome);  % Keep track of maximum signal values, for setting y-axis limits in plots
        yMin = zeros(nEpoch, nSignal, nSSD+1, nOutcome);  % Keep track of maximum signal values, for setting y-axis limits in plots
        
        Data(kDataInd, jTarg).subjectID = subjectID;
        Data(kDataInd, jTarg).sessionID = sessionID;
        Data(kDataInd, jTarg).name = Opt.unitArray{kDataInd};
        Data(kDataInd, jTarg).ssdArray = ssdArray;
        Data(kDataInd, jTarg).pSignalArray = pSignalArray;
        
        
        
        
        
        
        
        
        
        
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                    LOOP THROUGH SIGNAL STRENGTHS
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
            
            
            
            
            
            
            %       if Opt.collapseSignal
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
            if Opt.collapseTarg && iPct(1) > 50
                jAngle = 'right';
            elseif Opt.collapseTarg && iPct(1) < 50
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
                    Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).alignTimeList = alignListGoTarg;   % Keep track of trial-by-trial alignemnt
                    alignListGoDist = trialData.(mEpochName)(iGoDistTrial);
                    Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).alignTimeList = alignListGoDist;   % Keep track of trial-by-trial alignemnt
                    
                    
                    
                    switch dataType
                        
                        
                        case 'neuron'
                            % Go to Target trials
                            [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(iGoTargTrial, kUnit), alignListGoTarg);
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).alignTime = alignmentIndex;
                            sdf = spike_density_function(alignedRasters, Kernel);
                            if ~isempty(sdf); yMax(mEpoch, iPropIndex, 1, 1) = nanmax(nanmean(sdf, 1)); end;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).raster = alignedRasters;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdf = sdf;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdfMean = nanmean(sdf, 1);
                            
                            % Go to Distractor trials
                            [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(iGoDistTrial, kUnit), alignListGoDist);
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).alignTime = alignmentIndex;
                            sdf = spike_density_function(alignedRasters, Kernel);
                            if ~isempty(sdf); yMax(mEpoch, iPropIndex, 1, 2) = nanmax(nanmean(sdf, 1)); end;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).raster = alignedRasters;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdf = sdf;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdfMean = nanmean(sdf, 1);
                            
                            clear alignedRasters sdf
                            
                        case 'lfp'
                            % Go to Target trials
                            [targLFP, alignIndex] 	= align_signals(trialData.lfpData(iGoTargTrial, kUnit), alignListGoTarg, cropWindow);
                            satTrial                = signal_reject_saturate(targLFP, 'alignIndex', alignIndex);
                            iGoTargTrial(satTrial) = [];
                            targLFP(satTrial,:)     = [];
                            if Opt.baselineCorrect
                                targLFP                 = signal_baseline_correct(targLFP, baseWindow, alignIndex);
                            end
                            if Opt.filterData
                                targLFPMean = lowpass(nanmean(targLFP, 1)', Opt.stopHz);
                            else
                                targLFPMean = nanmean(targLFP, 1);
                            end
                            
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).alignTime = alignIndex;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfp = targLFP;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfpMean = targLFPMean;
                            if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                                if ~isempty(targLFP)
                                    yMax(mEpoch, iPropIndex, 1, 1) = nanmax(nanmean(targLFP, 1));
                                    yMin(mEpoch, iPropIndex, 1, 1) = nanmin(nanmean(targLFP, 1));
                                end
                            end
                            
                            % Go to Distractor trials
                            [distLFP, alignIndex]	= align_signals(trialData.lfpData(iGoDistTrial, kUnit), alignListGoDist, cropWindow);
                            satTrial                = signal_reject_saturate(distLFP, 'alignIndex', alignIndex);
                            iGoDistTrial(satTrial) = [];
                            distLFP(satTrial,:)     = [];
                            if Opt.baselineCorrect
                                distLFP                 = signal_baseline_correct(distLFP, baseWindow, alignIndex);
                            end
                            if Opt.filterData
                                distLFPMean = lowpass(nanmean(distLFP, 1)', Opt.stopHz);
                            else
                                distLFPMean = nanmean(distLFP, 1);
                            end
                            
                            
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).alignTime = alignIndex;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfp = distLFP;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfpMean = distLFPMean;
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
                            iGoTargTrial(satTrial) = [];
                            targEEG(satTrial,:)     = [];
                            targEEG                 = signal_baseline_correct(targEEG, baseWindow, alignIndex);
                            if Opt.filterData
                                targEEGMean = lowpass(nanmean(targEEG, 1)', Opt.stopHz);
                            else
                                targEEGMean = nanmean(targEEG, 1);
                            end
                            
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).alignTime = alignIndex;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).eeg = targEEG;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).erp = targEEGMean;
                            if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                                if ~isempty(targEEG)
                                    yMax(kDataInd, mEpoch, iPropIndex, 1) = nanmax(nanmean(targEEG, 1));
                                    yMin(kDataInd, mEpoch, iPropIndex, 1) = nanmin(nanmean(targEEG, 1));
                                end
                            end
                            
                            % Go to Distractor trials
                            [distEEG, alignIndex]	= align_signals(trialData.eegData(iGoDistTrial, kUnit), alignListGoDist, cropWindow);
                            satTrial                = signal_reject_saturate(distEEG, 'alignIndex', alignIndex);
                            iGoDistTrial(satTrial) = [];
                            distEEG(satTrial,:)     = [];
                            distEEG                 = signal_baseline_correct(distEEG, baseWindow, alignIndex);
                            if Opt.filterData
                                distEEGMean = lowpass(nanmean(distEEG, 1)', Opt.stopHz);
                            else
                                distEEGMean = nanmean(distEEG, 1);
                            end
                            
                            
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).alignTime = alignIndex;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).eeg = distEEG;
                            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).erp = distEEGMean;
                            if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                                % if ~isempty(targEEG)
                                %                         yMax(mEpoch, iPropIndex, 1, 2) = nanmax(nanmean(distEEG, 1));
                                %                         yMin(mEpoch, iPropIndex, 1, 2) = nanmin(nanmean(distEEG, 1));
                                %                      end
                            end
                            
                    end % switch dataType
                end % ~strcmp(mEpochName, 'stopSignalOn')
            end % mEpoch
            
            % add go RTs here
            Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.rt = trialData.rt(iGoTargTrial);
            Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.rt = trialData.rt(iGoDistTrial);
            
            
            
            
            
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Stop trials
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            if Opt.doStops
                for jSSDIndex = 1 : nSSD
                    jSSD = ssdArray(jSSDIndex);
                    selectOpt.ssd       = jSSD;
                    
                    selectOpt.outcome       = {'stopIncorrectTarget', 'targetHoldAbort', 'stopIncorrectPreSSDTarget'};
                    jStopTargTrial = ccm_trial_selection(trialData, selectOpt);

                    selectOpt.outcome       =  {'stopIncorrectDistractor', 'distractorHoldAbort', 'stopIncorrectPreSSDDistractor'};
                    jStopDistTrial = ccm_trial_selection(trialData, selectOpt);

                    selectOpt.outcome       = {'stopCorrect'};
                    jstopStopTrial = ccm_trial_selection(trialData, selectOpt);
                    
                    for mEpoch = 1 : length(epochArray)
                        mEpochName = epochArray{mEpoch};
                        
                        alignListStopTarg = trialData.(mEpochName)(jStopTargTrial);
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTimeList = alignListStopTarg;   % Keep track of trial-by-trial alignemnt
                        alignListStopDist = trialData.(mEpochName)(jStopDistTrial);
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTimeList = alignListStopDist;   % Keep track of trial-by-trial alignemnt
                        alignListstopStop = trialData.(mEpochName)(jstopStopTrial);
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).alignTimeList = alignListstopStop;   % Keep track of trial-by-trial alignemnt
                        
                        
                        
                        switch dataType
                            case 'neuron'
                                % Stop to Target trials
                                [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(jStopTargTrial, kUnit), alignListStopTarg);
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
                                
                                sdf = spike_density_function(alignedRasters, Kernel);
                                if ~isempty(sdf); yMax(mEpoch, iPropIndex, jSSDIndex+1, 3) = nanmax(nanmean(sdf, 1)); end;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdf = sdf;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdfMean = nanmean(sdf, 1);
                                
                                
                                % Stop to Distractor trials
                                [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(jStopDistTrial, kUnit), alignListStopDist );
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
                                
                                sdf = spike_density_function(alignedRasters, Kernel);
                                if ~isempty(sdf); yMax(mEpoch, iPropIndex, jSSDIndex+1, 4) = nanmax(nanmean(sdf, 1)); end;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdf = sdf;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdfMean = nanmean(sdf, 1);
                                
                                
                                if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
                                    % Canceled Stop trials
                                    [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(jstopStopTrial, kUnit), alignListstopStop);
                                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
                                    
                                    sdf = spike_density_function(alignedRasters, Kernel);
                                    if ~isempty(sdf); yMax(mEpoch, iPropIndex, jSSDIndex+1, 5) = nanmax(nanmean(sdf, 1)); end;
                                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
                                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).sdf = sdf;
                                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).sdfMean = nanmean(sdf, 1);
                                    
                                end
                                clear alignedRasters sdf
                                
                                
                                
                                
                            case 'lfp'
                                
                                % Stop to Target trials
                                [targLFP, alignIndex] 	= align_signals(trialData.lfpData(jStopTargTrial, kUnit), alignListStopTarg, cropWindow);
                                satTrial                = signal_reject_saturate(targLFP, 'alignIndex', alignIndex);
                                jStopTargTrial(satTrial,:)     = [];
                                targLFP(satTrial,:)     = [];
                                if Opt.baselineCorrect
                                    targLFP                 = signal_baseline_correct(targLFP, baseWindow, alignIndex);
                                end
                                if Opt.filterData
                                    targLFPMean = lowpass(nanmean(targLFP, 1)', Opt.stopHz);
                                else
                                    targLFPMean = nanmean(targLFP, 1);
                                end
                                
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfp = targLFP;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfpMean = targLFPMean;
                                if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                                    % if ~isempty(targLFP)
                                    %                         yMax(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 3) = nanmax(nanmean(targLFP, 1));
                                    %                         yMin(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 3) = nanmin(nanmean(targLFP, 1));
                                    % end
                                end
                                
                                % Stop to Distractor trials
                                [distLFP, alignIndex] 	= align_signals(trialData.lfpData(jStopDistTrial, kUnit), alignListStopDist, cropWindow);
                                satTrial                = signal_reject_saturate(distLFP, 'alignIndex', alignIndex);
                                jStopDistTrial(satTrial,:)     = [];
                                distLFP(satTrial,:)     = [];
                                if Opt.baselineCorrect
                                    distLFP                 = signal_baseline_correct(distLFP, baseWindow, alignIndex);
                                end
                                if Opt.filterData
                                    distLFPMean = lowpass(nanmean(distLFP, 1)', Opt.stopHz);
                                else
                                    distLFPMean = nanmean(distLFP, 1);
                                end
                                
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfp = distLFP;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfpMean = distLFPMean;
                                if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                                    % if ~isempty(distLFP)
                                    %                         yMax(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 4) = nanmax(nanmean(distLFP, 1));
                                    %                         yMin(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 4) = nanmin(nanmean(distLFP, 1));
                                    % end
                                end
                                
                                
                                if ~strcmp(mEpochName, 'responseOnset')  % No response on correct Stop trials
                                    % Correct Stop trials
                                    [stopLFP, alignIndex] 	= align_signals(trialData.lfpData(jstopStopTrial, kUnit), alignListstopStop, cropWindow);
                                    satTrial                = signal_reject_saturate(stopLFP, 'alignIndex', alignIndex);
                                    stopLFP(satTrial,:)     = [];
                                    if Opt.baselineCorrect
                                        stopLFP                 = signal_baseline_correct(stopLFP, baseWindow, alignIndex);
                                    end
                                    if Opt.filterData
                                        stopLFPMean = lowpass(nanmean(stopLFP, 1)', Opt.stopHz);
                                    else
                                        stopLFPMean = nanmean(stopLFP, 1);
                                    end
                                    
                                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).lfp = stopLFP;
                                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).lfpMean = stopLFPMean;
                                    if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                                        if ~isempty(stopLFP)
                                            yMax(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 5) = nanmax(nanmean(stopLFP, 1));
                                            yMin(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 5) = nanmin(nanmean(stopLFP, 1));
                                        end
                                    end
                                    
                                end
                                
                                
                                
                            case 'erp'
                                % Stop to Target trials
                                [targEEG, alignIndex] 	= align_signals(trialData.eegData(jStopTargTrial, kUnit), alignListStopTarg, cropWindow);
                                satTrial                = signal_reject_saturate(targEEG, 'alignIndex', alignIndex);
                                jStopTargTrial(satTrial,:)     = [];
                                targEEG(satTrial,:)     = [];
                                targEEG                 = signal_baseline_correct(targEEG, baseWindow, alignIndex);
                                if Opt.filterData
                                    targEEGMean = lowpass(nanmean(targEEG, 1)', Opt.stopHz);
                                else
                                    targEEGMean = nanmean(targEEG, 1);
                                end
                                
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).eeg = targEEG;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).erp = targEEGMean;
                                if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                                    % if ~isempty(targEEG)
                                    %                         yMax(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 3) = nanmax(nanmean(targEEG, 1));
                                    %                         yMin(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 3) = nanmin(nanmean(targEEG, 1));
                                    %                      end
                                end
                                
                                
                                % Stop to Distractor trials
                                [distEEG, alignIndex] 	= align_signals(trialData.eegData(jStopDistTrial, kUnit), alignListStopDist, cropWindow);
                                satTrial                = signal_reject_saturate(distEEG, 'alignIndex', alignIndex);
                                jStopDistTrial(satTrial,:)     = [];
                                distEEG(satTrial,:)     = [];
                                distEEG                 = signal_baseline_correct(distEEG, baseWindow, alignIndex);
                                if Opt.filterData
                                    distEEGMean = lowpass(nanmean(distEEG, 1)', Opt.stopHz);
                                else
                                    distEEGMean = nanmean(distEEG, 1);
                                end
                                
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).eeg = distEEG;
                                Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).erp = distEEGMean;
                                if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                                    % if ~isempty(distEEG)
                                    %                         yMax(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 4) = nanmax(nanmean(distEEG, 1));
                                    %                         yMin(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 4) = nanmin(nanmean(distEEG, 1));
                                    %                      end
                                end
                                
                                
                                if ~strcmp(mEpochName, 'responseOnset')  % No response on correct Stop trials
                                    % Correct Stop trials
                                    [stopEEG, alignIndex] 	= align_signals(trialData.eegData(jstopStopTrial, kUnit), alignListstopStop, cropWindow);
                                    satTrial                = signal_reject_saturate(stopEEG, 'alignIndex', alignIndex);
                                    stopEEG(satTrial,:)     = [];
                                    stopEEG                 = signal_baseline_correct(stopEEG, baseWindow, alignIndex);
                                    if Opt.filterData
                                        stopEEGMean = lowpass(nanmean(stopEEG, 1)', Opt.stopHz);
                                    else
                                        stopEEGMean = nanmean(stopEEG, 1);
                                    end
                                    
                                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).alignTime = alignIndex;
                                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).eeg = stopEEG;
                                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).erp = stopEEGMean;
                                    if ~strcmp(mEpochName, 'rewardOn') && ~strcmp(mEpochName, 'responseOnset')
                                        if ~isempty(stopEEG)
                                            yMax(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 5) = nanmax(nanmean(stopEEG, 1));
                                            yMin(kDataInd, mEpoch, iPropIndex, jSSDIndex + 1, 5) = nanmin(nanmean(stopEEG, 1));
                                        end
                                    end
                                end
                                
                        end % switch dataType
                    end % mEpoch
                    
                    
                    % Move stop rts here
                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).rt = trialData.rt(jStopTargTrial);
                    Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).rt = trialData.rt(jStopDistTrial);
                    
                    
                    
                    
                    
                    % Get latency matched Go trials
                    mOpt.matchMethod = 'ssrt';
                    mOpt.ssrt = ssrt;
                    mOpt.ssd = ssdArray(jSSDIndex);
                    mOpt.stopRT = trialData.rt(jStopTargTrial);
                    [goFastTrial, goSlowTrial] = latency_match(trialData.rt(iGoTargTrial), mOpt);
                    goFastTrial = iGoTargTrial(goFastTrial);
                    goSlowTrial = iGoTargTrial(goSlowTrial);
                    for mEpoch = 1 : length(epochArray)
                        mEpochName = epochArray{mEpoch};
                        
                        
                        alignListGoFast = trialData.(mEpochName)(goFastTrial);
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).goFast.ssd(jSSDIndex).(mEpochName).alignTimeList = alignListGoFast;   % Keep track of trial-by-trial alignemnt
                        alignListGoSlow = trialData.(mEpochName)(goSlowTrial);
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).goSlow.ssd(jSSDIndex).(mEpochName).alignTimeList = alignListGoSlow;   % Keep track of trial-by-trial alignemnt

                        switch dataType
                            case 'neuron'
                       % Go Fast data
                        [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(goFastTrial, kUnit), alignListGoFast);
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).goFast.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
                        
                        sdf = spike_density_function(alignedRasters, Kernel);
                        if ~isempty(sdf); yMax(mEpoch, iPropIndex, jSSDIndex+1, 3) = nanmax(nanmean(sdf, 1)); end;
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).goFast.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).goFast.ssd(jSSDIndex).(mEpochName).sdf = sdf;
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).goFast.ssd(jSSDIndex).(mEpochName).sdfMean = nanmean(sdf, 1);
                        
                        
                        % Go Slow data
                        [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(goSlowTrial, kUnit), alignListGoSlow);
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).goSlow.ssd(jSSDIndex).(mEpochName).alignTime = alignmentIndex;
                        
                        sdf = spike_density_function(alignedRasters, Kernel);
                        if ~isempty(sdf); yMax(mEpoch, iPropIndex, jSSDIndex+1, 3) = nanmax(nanmean(sdf, 1)); end;
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).goSlow.ssd(jSSDIndex).(mEpochName).raster = alignedRasters;
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).goSlow.ssd(jSSDIndex).(mEpochName).sdf = sdf;
                        Data(kDataInd, jTarg).signalStrength(iPropIndex).goSlow.ssd(jSSDIndex).(mEpochName).sdfMean = nanmean(sdf, 1);
                        
                             case 'lfp'
                                 disp('Need to implement latency matching in lfp data')
                             case 'erp'
                                  disp('Need to implement latency matching in erp data')
                         end
                   end
                    
                end % jSSD
            end % if Opt.doStops
            
        end %iPropIndex
        
        
        
        
        
        
        
        
        a = yMax(:,:,1,:);   % the go trials
        b = yMax(:,:,2:end,:);  % all the stop trials
        c = yMin(:,:,1,:);   % go trials
        d = yMin(:,:,2:end,:);  % stop trials
        
        Data(kDataInd, jTarg).yMax = max([a(:); nanmean(b(:))]);
        Data(kDataInd, jTarg).yMin = min([c(:); nanmean(d(:))]);
        %    Data(kDataInd, jTarg).yMax = max([yMax(:,:,1,:); nanmean(nanmax(yMax(:,:,2:end,:)))]);
        %    Data(kDataInd, jTarg).yMin = max([yMin(:,:,1,:); nanmean(nanmax(yMin(:,:,2:end,:)))]);
        %    Data(kDataInd, jTarg).yMin = nanmin(yMin(:));
        
        
        
        
        
        
        % print the figure if we're stepping through
        if Opt.plotFlag
            howProcess = Opt.howProcess;
            switch howProcess
                case {'step','print','each'}
                    ccm_session_data_plot(Data(kDataInd, jTarg), Opt)
                    if strcmp(howProcess, 'step')
                        pause
                    end
                    clear Data
            end
        end
    end % jTarg
end % kDataInd

% if Opt.plotFlag
%     switch Opt.unitArray
%         case {'step','print'}
%             close(gcf)
%     end
% end








% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                   Opt.normalize
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
% % If we want the signal to be normalized to the maximum value for each
% % unit/channel, loop back through and Opt.normalize here...
% %
% %  Haven't tested this in a while, probably needs work
%
% if Opt.normalize
%     for kDataInd = 1 : nUnit
%         for iPropIndex = 1 : nSignal;
%             for mEpoch = 1 : length(epochArray)
%                 mEpochName = epochArray{mEpoch};
%
%                 % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 % Go trials
%                 % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 if ~strcmp(mEpochName, 'stopSignalOn')  % No stop signals on go trials
%
%                     switch dataType
%                         case 'neuron'
%                             % Go to Target trials
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdf = ...
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdf ./ Data(kDataInd, jTarg).yMax;
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdfMean = ...
%                                 nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).sdf, 1);
%
%                             % Go to Distractor trials
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdf = ...
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdf ./ Data(kDataInd, jTarg).yMax;
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdfMean = ...
%                                 nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).sdf, 1);
%
%
%                         case 'lfp'
%                             % Go to Target trials
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfp = ...
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfp ./ Data(kDataInd, jTarg).yMax;
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfpMean = ...
%                                 nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfp, 1);
%
%                             % Go to Distractor trials
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfp = ...
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfp ./ Data(kDataInd, jTarg).yMax;
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfpMean = ...
%                                 nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).lfp, 1);
%
%
%                         case 'erp'
%                             % Go to Target trials
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).eeg = ...
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).eeg ./ Data(kDataInd, jTarg).yMax;
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).lfpMean = ...
%                                 nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).goTarg.(mEpochName).eeg, 1);
%
%                             % Go to Distractor trials
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).eeg = ...
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).eeg ./ Data(kDataInd, jTarg).yMax;
%                             Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).erp = ...
%                                 nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).goDist.(mEpochName).eeg, 1);
%
%
%                     end % switch dataType
%                 end % ~strcmp(mEpochName, 'stopSignalOn')
%
%
%
%
%
%                 % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 % Stop trials
%                 % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 if Opt.doStops
%                     for jSSDIndex = 1 : nSSD
%
%                         switch dataType
%                             case 'neuron'
%                                 % Stop to Target trials
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdf = ...
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdf ./ Data(kDataInd, jTarg).yMax;
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdfMean = ...
%                                     nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).sdf, 1);
%
%                                 % Stop to Distractor trials
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdf = ...
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdf ./ Data(kDataInd, jTarg).yMax;
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdfMean = ...
%                                     nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).sdf, 1);
%
%                                 if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
%
%                                     % Stop Correct trials
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).sdf = ...
%                                         Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).sdf ./ Data(kDataInd, jTarg).yMax;
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).sdfMean = ...
%                                         nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).sdf, 1);
%
%                                 end % ~strcmp(mEpochName, 'responseOnset')
%
%
%                             case 'lfp'
%
%                                 % Stop to Target trials
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfp = ...
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfp ./ Data(kDataInd, jTarg).yMax;
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfpMean = ...
%                                     nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).lfp, 1);
%
%                                 % Stop to Distractor trials
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfp = ...
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfp ./ Data(kDataInd, jTarg).yMax;
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfpMean = ...
%                                     nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).lfp, 1);
%
%                                 if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
%
%                                     % Stop Correct trials
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).lfp = ...
%                                         Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).lfp ./ Data(kDataInd, jTarg).yMax;
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).lfpMean = ...
%                                         nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).lfp, 1);
%
%                                 end % ~strcmp(mEpochName, 'responseOnset')
%
%
%                             case 'erp'
%
%                                 % Stop to Target trials
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).eeg = ...
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).eeg ./ Data(kDataInd, jTarg).yMax;
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).erp = ...
%                                     nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).stopTarg.ssd(jSSDIndex).(mEpochName).eeg, 1);
%
%                                 % Stop to Distractor trials
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).eeg = ...
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).eeg ./ Data(kDataInd, jTarg).yMax;
%                                 Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).erp = ...
%                                     nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).stopDist.ssd(jSSDIndex).(mEpochName).eeg, 1);
%
%                                 if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
%
%                                     % Stop Correct trials
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).eeg = ...
%                                         Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).eeg ./ Data(kDataInd, jTarg).yMax;
%                                     Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).erp = ...
%                                         nanmean(Data(kDataInd, jTarg).signalStrength(iPropIndex).stopStop.ssd(jSSDIndex).(mEpochName).eeg, 1);
%
%                                 end % ~strcmp(mEpochName, 'responseOnset')
%
%                         end % switch dataType
%                     end % jSSD
%                 end % if Opt.doStops
%             end % mEpoch
%         end % for mEpoch = 1 : length(epochArray)
%         Data(kDataInd, jTarg).yMax = 1.1;
%         switch dataType
%             case 'neuron'
%                 Data(kDataInd, jTarg).yMin = 0;
%             case {'lfp', 'erp'}
%                 Data(kDataInd, jTarg).yMin = -1.1;
%         end
%
%
%
%     end % for kDataInd = 1 : nUnit
%
%
% end % if Opt.normalize







disp('completed data collection')

Data(1).unitArray       = Opt.unitArray;
Data(1).howProcess       = Opt.howProcess;
Data(1).dataArray       = dataArray;
Data(1).pSignalArray    = pSignalArray;
Data(1).targAngleArray  = targAngleArray;
Data(1).ssdArray        = ssdArray;
Data(1).sessionID       = sessionID;
Data(1).subjectID       = subjectID;
Data(1).Opt         = Opt;


if Opt.plotFlag && ~strcmp(Opt.howProcess, 'step') && ~strcmp(Opt.howProcess, 'each') && ~strcmp(Opt.howProcess, 'print')
    ccm_session_data_plot(Data, Opt)
    
end

% ################################################################################
% ############################   SUB FUNCTIONS    ################################
% ################################################################################

%     function [goFastTrial, goSlowTrial] = latency_match(goRT, stopRT)
%         
%         goFastTrial = [];
%         goSlowTrial = [];
%         if isempty(stopRT) || isempty(goRT)
%             return
%         end
%         
%         [rt, ind] = sort(goRT);
%         
%         lastInd = 1;
%         while nanmean(rt(lastInd:end)) < nanmean(stopRT)
%             goFastTrial = [goFastTrial; ind(lastInd)];
%             lastInd = lastInd + 1;
%             
%             
%         end
%         goSlowTrial = ind(lastInd:end);
%         %         trialList = 1 : length(goRT);
%         %         remaining = 1 : length(goRT);
%         %         remove = [];
%         %         goFastTrial = remaining;
%         %         while nanmean(goRT(remaining)) > nanmean(stopRT)
%         %             [y,i] = max(goRT(remaining));
%         %             remove = [remove; i]
%         %             goSlowTrial = [goSlowTrial; i];
%         %
%         %
%         %         end
%         %         goFastTrial = remaining;
%         
%         
%     end


end
