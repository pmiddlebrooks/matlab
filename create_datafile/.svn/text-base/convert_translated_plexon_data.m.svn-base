function [trialData, SessionData] = convert_translated_plexon_data(monkey, sessionID, brainArea)

% adapted from convert_translated_datafile.m

if nargin < 3
    brainArea = nan;
end

if regexp('broca', monkey, 'ignorecase')
        monkeyDataPath = 'Broca/';
elseif regexp('xena', monkey, 'ignorecase')
        monkeyDataPath = 'Xena/Plexon/';
else
    disp('Wrong monkey name?')
        return
end
localDataPath = 'Z:\paulmiddlebrooks On My Mac\matlab\local_data\';
tebaDataPath = ['t:/data/',monkeyDataPath];
legacyFile = [sessionID, '_legacy.mat'];
dataPath = [tebaDataPath, legacyFile];

load(dataPath, '-mat')
taskID = get_taskID(Header_.Task)



% Define constants
maxResponsePerTrial = 400;  % The most saccades allowed per trial to be included




% ********************************************************************
%                    Trial Data
% ********************************************************************

% Getting the variables common to all protocols (hopefully?) here. After
% the trialData dataset is collected and the SessionData structure is
% filled with the common variables, we call a function to gather and append
% any task-specific variables


nTrial = size(Infos_.Allowed_fix_time, 1);

% Event Timing
% ------------
trialOnset                = num2cell(TrialStart_(:, 1) - TrialStart_(1, 1), 2);
trialDuration             = num2cell(Eot_(:, 1), 2);

fixOn         = num2cell(FixSpotOn_(:, 1), 2);
fixDuration      = num2cell(FixSpotOff_(:, 1) - FixSpotOn_(:, 1), 2);
fixWindowEntered     = num2cell(Fixate_(:, 1), 2);


targOn               = num2cell(Target_(:, 1), 2);
targDuration            = num2cell(nan(nTrial, 1), 2);
targWindowEntered       = num2cell(Decide_(:, 1), 2);


% Response data
listedSaccades = size(SaccBegin, 2);
if listedSaccades < maxResponsePerTrial
    maxResponsePerTrial = listedSaccades;
end
saccBegin             = num2cell(SaccBegin(:, 1:maxResponsePerTrial), 2);
saccadeToTargetIndex     = Sacc_of_interest(:,2);
saccadeToTargetIndex(saccadeToTargetIndex == 0) = nan;
trialWithResponse       = ~isnan(saccadeToTargetIndex);
saccadeToTargetIndex     = num2cell(saccadeToTargetIndex, 2);
saccDuration          = num2cell((SaccEnd(:, 1:maxResponsePerTrial) - SaccBegin(:, 1:maxResponsePerTrial)), 2);
saccAmp         = num2cell(SaccAmplitude(:, 1:maxResponsePerTrial), 2);
saccAngle         = num2cell(SaccDirection(:, 1:maxResponsePerTrial), 2);

responseOnset = nan(nTrial, 1);
responseOnset(trialWithResponse) = cellfun(@(x, y) x(y), saccBegin(trialWithResponse), saccadeToTargetIndex(trialWithResponse));
responseOnset = num2cell(responseOnset, 2);
% Change zeros to nans
% responseOnset(SaccBegin == 0)       = nan;
% responseDuration(SaccBegin == 0)	= nan;
% responseAmplitude(SaccAmplitude == 0)     = nan;
% responseDirection(SaccDirection == 0)     = nan;

rewardOn               = num2cell(Reward_, 2);  % The odd columns are the reward times
rewardDuration            = num2cell(Infos_.Reward_duration, 2);  % The even columns are the solenoid durations
timeoutDuration           = num2cell(Infos_.Punish_time, 2);

abortTime                = num2cell(Abort_(:, 1), 2);


% Trial Outcomes
trialOutcome    = Infos_.Trial_outcome;




% Location of Stimuli
% ---------------------------------------------------------------
fixAmp       = num2cell(zeros(nTrial, 1), 2);
fixAngle           = num2cell(zeros(nTrial, 1), 2);
fixSize            = num2cell(Infos_.Fixation_size, 2);
fixWindow          = num2cell(Infos_.Fix_win_size, 2);
targSize              = num2cell(Infos_.Target_size, 2);
targWindow            = num2cell(Infos_.Targ_win_size, 2);



% Eye position
% ---------------------------------------------------------------
eyeX = cell(nTrial, 1);
eyeY = cell(nTrial, 1);
for iTrial = 1 : nTrial
    if iTrial < nTrial
        eyeX{iTrial, :}            = EyeX_(TrialStart_(iTrial) : TrialStart_(iTrial+1));
        eyeY{iTrial, :}            = EyeY_(TrialStart_(iTrial) : TrialStart_(iTrial+1));
    elseif iTrial == nTrial
        eyeX{iTrial, :}            = EyeX_(TrialStart_(iTrial) : Eot_(iTrial));
        eyeY{iTrial, :}            = EyeY_(TrialStart_(iTrial) : Eot_(iTrial));
    end
end




% ---------------------------------------------------------------
%       Remove NaNs and irrelevant zeros from variables that have them
% ---------------------------------------------------------------

responseOnset       = cellfun(@(x) x(x ~= 0), responseOnset, 'uniformoutput', false);
saccBegin       = cellfun(@(x) x(x ~= 0), saccBegin, 'uniformoutput', false);
saccDuration    = cellfun(@(x) x(x ~= 0), saccDuration, 'uniformoutput', false);
saccAngle   = cellfun(@(x) x(x ~= 0), saccAngle, 'uniformoutput', false);
saccAmp   = cellfun(@(x) x(x ~= 0), saccAmp, 'uniformoutput', false);

responseOnset       = cellfun(@(x) x(~isnan(x)), responseOnset, 'uniformoutput', false);
saccBegin       = cellfun(@(x) x(~isnan(x)), saccBegin, 'uniformoutput', false);
saccDuration    = cellfun(@(x) x(~isnan(x)), saccDuration, 'uniformoutput', false);
saccAngle   = cellfun(@(x) x(~isnan(x)), saccAngle, 'uniformoutput', false);
saccAmp   = cellfun(@(x) x(~isnan(x)), saccAmp, 'uniformoutput', false);

% rewardOn         = cellfun(@(x) x(~isnan(x)), rewardOn, 'uniformoutput', false);
% rewardDuration      = cellfun(@(x) x(~isnan(x)), rewardDuration, 'uniformoutput', false);
eyeX        = cellfun(@(x) x(~isnan(x)), eyeX, 'uniformoutput', false);
eyeY        = cellfun(@(x) x(~isnan(x)), eyeY, 'uniformoutput', false);
% spikeUnit       = cellfun(@(x) x(~isnan(x)), spikeUnitPDP, 'uniformoutput', false);




% % ---------------------------------------------------------------
% %           Fill the trialData dataset
% % ---------------------------------------------------------------
% trialData = dataset(...
%     {trialOnset,            'trialOnset'},...
%     {trialDuration,         'trialDuration'},...
%     {fixOn,     'fixOn'},...
%     {fixDuration,  'fixDuration'},...
%     {fixWindowEntered, 'fixWindowEntered'},...
% %     {preTargFixDuration,  'preTargFixDuration'},...
% %     {postTargFixDuration, 'postTargFixDuration'},...
%     {targOn,           'targOn'},...
% %     {distOn,       'distOn'},...
% %     {checkerOn,   'checkerOn'},...
% %     {responseCueOn,      'responseCueOn'},...
%     {targDuration,        'targDuration'},...
% %     {distDuration,    'distDuration'},...
% %     {checkerDuration, 'checkerDuration'},...
%     {targWindowEntered,   'targWindowEntered'},...
%     {responseOnset,         'responseOnset'},...
%     {responseToTargetIndex,	'responseToTargetIndex'},...
%     {responseDuration,      'responseDuration'},...
%     {responseAmplitude,     'responseAmplitude'},...
%     {responseDirection,     'responseDirection'},...
% %     {stopSignalOn,             'stopSignalOn'},...
% %     {stopDuration,          'stopDuration'},...
%     {rewardOn,           'rewardOn'},...
%     {rewardDuration,        'rewardDuration'},...
%     {timeoutDuration,        'timeoutDuration'},...
%     {abortTime,            'abortTime'},...
%     {trialOutcome,          'trialOutcome'},...
% %     {stopTrialProp, 	'stopTrialProp'},...
%     {fixAmp, 	'fixAmp'},...
%     {fixAngle,         'fixAngle'},...
%     {fixSize,          'fixSize'},...
%     {fixWindow,        'fixWindow'},...
%     {targAmp,       'targAmp'},...
%     {targAngle,           'targAngle'},...
%     {targSize,            'targSize'},...
%     {targWindow,          'targWindow'},...
% %     {distAmp, 	'distAmp'},...
% %     {distAngle,       'distAngle'},...
% %     {distSize,        'distSize'},...
% %     {distWindow,      'distWindow'},...
% %     {checkerboardAmplitude, 'checkerboardAmplitude'},...
% %     {checkerboardAngle,     'checkerboardAngle'},...
% %     {checkerboardSize,      'checkerboardSize'},...
% %     {checkerboardWindow,    'checkerboardWindow'},...
%     {eyeX,          'eyeX'},...
%     {eyeY,          'eyeY'});


% ---------------------------------------------------------------
%           Fill the trialData dataset
% ---------------------------------------------------------------
trialData = dataset(...
    {trialOnset,            'trialOnset'},...
    {trialDuration,         'trialDuration'},...
    {fixOn,     'fixOn'},...
    {fixDuration,  'fixDuration'},...
    {fixWindowEntered, 'fixWindowEntered'},...
    {targOn,           'targOn'},...
    {targDuration,        'targDuration'},...
    {targWindowEntered,   'targWindowEntered'},...
    {responseOnset,         'responseOnset'},...
    {saccBegin,         'saccBegin'},...
    {saccadeToTargetIndex,	'saccadeToTargetIndex'},...
    {saccDuration,      'saccDuration'},...
    {saccAmp,     'saccAmp'},...
    {saccAngle,     'saccAngle'},...
    {rewardOn,           'rewardOn'},...
    {rewardDuration,        'rewardDuration'},...
    {timeoutDuration,        'timeoutDuration'},...
    {abortTime,            'abortTime'},...
    {trialOutcome,          'trialOutcome'},...
    {fixAmp, 	'fixAmp'},...
    {fixAngle,         'fixAngle'},...
    {fixSize,          'fixSize'},...
    {fixWindow,        'fixWindow'},...
    {targSize,            'targSize'},...
    {targWindow,          'targWindow'},...
    {eyeX,          'eyeX'},...
    {eyeY,          'eyeY'});







% Physiology
% ---------------------------------------------------------------

% spike data
% -------------
% Figure out how many single units were recorded and loop through them
unitNameArray = who('DSP*');
nUnitSpike = size(unitNameArray, 1);
% If there are spike units recorded, collect them and append them to the
% dataset
if nUnitSpike
    spikeUnit = [];
    for iUnit = 1 : nUnitSpike
        eval(['iUnitData = num2cell(',unitNameArray{iUnit},', 2);'])
        iUnitData = cellfun(@(x) x(x ~= 0), iUnitData, 'uniformoutput', false);
        iUnitData = cellfun(@round, iUnitData, 'uniformoutput', false);
        if size(iUnitData, 1) > nTrial
            iUnitData = iUnitData(1:nTrial);
        end
        spikeUnit     	= [spikeUnit, iUnitData];
        
    end
    trialData.spikeUnit = spikeUnit;
end



% Figure whether LFP data was recorded and append it to the dataset if so
% -------------------
if exist('LFP_1', 'var')
    LFP             = num2cell(LFP_1, 2);
    trialData.LFP   = cellfun(@(x) x(x ~= 0), LFP, 'uniformoutput', false);
end




% Figure whether EEG data was recorded and append it to the dataset if so
% -------------------
% Figure out how eeg channels were recorded and loop through them
channelNameArray = who('AD*')
nUnitEEG = size(channelNameArray, 1);
% If there were eegs recorded, collect them and append them to the dataset
if nUnitEEG
    eegData = cell(nTrial, nUnitEEG);
    for iChannel = 1 : nUnitEEG
        for iTrial = 1 : nTrial
            if iTrial < nTrial
                eegData{iTrial, iChannel}            = eval([channelNameArray{iChannel},'(TrialStart_(iTrial) : TrialStart_(iTrial+1))']);
            elseif iTrial == nTrial
                eegData{iTrial, iChannel}            = eval([channelNameArray{iChannel},'(TrialStart_(iTrial) : Eot_(iTrial))']);
            end
        end
    end
end
trialData.eegData = eegData;
%     for iChannel = 1 : nUnitEEG
%         eval(['iChannelData = num2cell(',channelNameArray{iChannel},');'])
% %         iChannelData = cellfun(@(x) x(x ~= 0), iChannelData, 'uniformoutput', false);
% %         iChannelData = cellfun(@round, iChannelData, 'uniformoutput', false);
%         if size(iChannelData, 1) > nTrial
%             iChannelData = iChannelData(1:nTrial);
%         end
%         eegData     	= [eegData, iChannelData]
%
%     end
%     trialData.eegData = eegData
% end








% Replace cells with absolutely no data with a single NaN;
for iTrial = 1 : nTrial
    if isempty(trialData.responseOnset{iTrial})
        trialData.responseOnset{iTrial} = nan;
        trialData.saccBegin{iTrial} = nan;
        trialData.saccDuration{iTrial} = nan;
        trialData.saccAngle{iTrial} = nan;
        trialData.saccAmp{iTrial} = nan;
    end
    if nUnitSpike
        for iUnit = 1 : nUnitSpike
            if isempty(trialData.spikeUnit{iTrial, iUnit})
                trialData.spikeUnit{iTrial, iUnit} = nan;
            end
        end
    end
    if exist('trialData.LFP', 'var')
        if isempty(trialData.LFP{iTrial})
            trialData.LFP{iTrial} = nan;
        end
    end
end








% ********************************************************************
%                       Session Data
% ********************************************************************

SessionData.stimuli.fixationRGB         = [Infos_.Fixation_color_r(1,:), Infos_.Fixation_color_g(1,:), Infos_.Fixation_color_b(1,:)];
SessionData.stimuli.targetRGB           = [Infos_.Target_color_r(1,:), Infos_.Target_color_g(1,:), Infos_.Target_color_b(1,:)];

SessionData.collectedData.behavior.eyePosition.samplingHz       = 1000;
SessionData.collectedData.neurophysiology.spikeUnit.samplingHz  = 1000;
if exist('LFP_1', 'var')
    SessionData.collectedData.neurophysiology.LFP.samplingHz    = 1000;
end

% single unit channel names
SessionData.collectedData.neurophysiology.spikeUnit.names = unitNameArray;

SessionData.taskID = taskID;
SessionData.task.effector = 'eye';

SessionData.timing.totalDuration = (TrialStart_(end, 1) + Eot_(end) - TrialStart_(1, 1)); % seconds


SessionData.subjectID = monkey;
SessionData.sessionID = sessionID;










% ********************************************************************
%             ADD ON TASK-SPECIFIC TRIAL AND SESSION DATA
% ********************************************************************

[trialData, SessionData] = task_specific_variables(dataPath, taskID, trialData, SessionData);


if isempty(trialData.eyeX{end, :})
    nTrial = nTrial - 1;
end
trialData = trialData(1:nTrial, :);


% Save a copy on teba
saveFileName = [tebaDataPath, sessionID];
save(saveFileName, 'trialData', 'SessionData')
% Make a local copy too
saveLocalName = [localDataPath, sessionID];
save(saveLocalName, 'trialData', 'SessionData')







% *************************************************************************
% *************************************************************************
function taskID = get_taskID(headerTask)
switch headerTask
    case 'ChoiceCountermanding';
        taskID = 'ccm';
    case 'Countermanding';
        taskID = 'cmd';
    case 'GoNoGo'
        taskID = 'gng';
    case 'Memory'
        taskID = 'mem';
    case 'Delay'
        taskID = 'del';
    case 'Visual'
        taskID = 'vis';
    case 'Amplitude'
        taskID = 'amp';
    otherwise
        fprintf('%s does not have an associated taskID yet', Header_.Task)
        return
end

% Get task-specific variables as a structure to be read out and added to
% the rest of the dataset
function [trialData, SessionData] = task_specific_variables(dataPath, taskID, trialData, SessionData)
load(dataPath, 'Header_', 'Infos_', 'Target_', 'Fixate_', 'Choice_', 'StopSignal_', 'Cue_')
nTrial = size(Target_, 1);

switch taskID
    case 'ccm'
        trialData.targ1CheckerProp  = num2cell(Infos_.Targ1Proportion, 2);
        trialData.preTargFixDuration      = num2cell(Target_(:, 1) - Fixate_(:, 1), 2);
        trialData.postTargFixDuration   	= num2cell(Choice_(:, 1) - Target_(:, 1), 2);
        trialData.distOn          	= num2cell(Target_(:, 1), 2); %  For now, distractor and target appear simultaneously
        trialData.distDuration        = num2cell(nan(nTrial, 1), 2);  %
        trialData.checkerOn       = num2cell(Choice_(:, 1), 2);
        trialData.checkerDuration  	= num2cell(nan(nTrial, 1), 2);
        trialData.responseCueOn          = num2cell(Choice_(:, 1), 2);  % For now this the choice stimulus onset is the cue to responed, but could possibly change that
        trialData.stopSignalOn                 = num2cell(StopSignal_(:, 1), 2);
        trialData.stopDuration              = num2cell(nan(nTrial, 1), 2);  % Doesn't seem to be any StopSingalOff event code
        trialData.stopTrialProp    	= num2cell(Infos_.Stop_weight ./ 100, 2);
        trialData.targAmp         = num2cell(Infos_.targetEccentricity, 2);
        trialData.targAngle             = num2cell(Infos_.targetAngle, 2);
        trialData.distAmp     = num2cell(Infos_.distractorEccentricity, 2);
        trialData.distAngle         = num2cell(Infos_.distractorAngle, 2);
        trialData.distSize          = num2cell(Infos_.Target_size, 2);
        trialData.distWindow        = num2cell(Infos_.Targ_win_size, 2);
        trialData.checkerAmp   = num2cell(Infos_.CheckerEccentricity, 2);
        trialData.checkerAngle       = num2cell(Infos_.CheckerAngle, 2);
        trialData.checkerSize        = num2cell(Infos_.CheckerWidthDegrees, 2);
        trialData.checkerWindow      = num2cell(Infos_.chkr_win_size, 2);
        if isfield(Infos_, 'checkerboardArray')  % Before session 50 for Broca, was not sending the checker stimuli pattern
            trialData.checkerArray  = num2cell(Infos_.checkerboardArray, 2);
        end
        
        SessionData.stimuli.stopSignalRGB       = [Infos_.Stop_color_r(1,:), Infos_.Stop_color_g(1,:), Infos_.Stop_color_b(1,:)];
        SessionData.stimuli.target1CheckerRGB   = [Infos_.targ1_checker_color_r(1,:), Infos_.targ1_checker_color_g(1,:), Infos_.targ1_checker_color_b(1,:)];
        SessionData.stimuli.target2CheckerRGB   = [Infos_.targ2_checker_color_r(1,:), Infos_.targ2_checker_color_g(1,:), Infos_.targ2_checker_color_b(1,:)];
        SessionData.stimuli.nChoiceStimulusColumn = Infos_.nCheckerColumn(1,:);
        SessionData.stimuli.nChoiceStimulusRow    = Infos_.nCheckerRow(1,:);
        SessionData.stimuli.iCheckerPixel       = Infos_.iSquareSizePixels(1,:);       
                
        
    case 'cmd'
        trialData.stopSignalOn                 = num2cell(StopSignal_(:, 1), 2);
        trialData.stopDuration              = num2cell(nan(nTrial, 1), 2);  % Doesn't seem to be any StopSingalOff event code
        trialData.stopTrialProp          = num2cell(Infos_.Stop_weight ./ 100, 2);
        trialData.targAmp         = num2cell(Infos_.targetEccentricity, 2);
        trialData.targAngle             = num2cell(Infos_.Target_angle, 2);
        
        SessionData.stimuli.stopSignalRGB       = [Infos_.Stop_color_r(1,:), Infos_.Stop_color_g(1,:), Infos_.Stop_color_b(1,:)];
        
    case 'gng'
        trialData.goCheckerProportion  = num2cell(Infos_.goProportion, 2);
        trialData.preTargFixDuration      = num2cell(Target_(:, 1) - Fixate_(:, 1), 2);
        trialData.targAmp         = num2cell(Infos_.Target_eccentricity, 2);
        trialData.targAngle             = num2cell(Infos_.Target_angle, 2);
        trialData.checkerOn       = num2cell(Cue_(:, 1), 2);
        trialData.checkerDuration      = num2cell(nan(nTrial, 1), 2);
        trialData.responseCueOn          = num2cell(Cue_(:, 1), 2);  % For now this the choice stimulus onset is the cue to responed, but could possibly change that
        
        SessionData.stimuli.goCheckerRGB        = [Infos_.go_checker_color_r(1,:), Infos_.go_checker_color_g(1,:), Infos_.go_checker_color_b(1,:)];
        SessionData.stimuli.noGoCheckerRGB      = [Infos_.noGo_checker_color_r(1,:), Infos_.noGo_checker_color_g(1,:), Infos_.noGo_checker_color_b(1,:)];
        SessionData.stimuli.nChoiceStimulusColumn = Infos_.nCheckerColumn(1,:);
        SessionData.stimuli.nChoiceStimulusRow    = Infos_.nCheckerRow(1,:);
        SessionData.stimuli.iCheckerPixel       = Infos_.iSquareSizePixels(1,:);
        
    case 'mem'
    case 'del'
    case 'vis'
    case 'amp'
    otherwise
        fprintf('%s is not a valid task ID', taskID)
        return
end

