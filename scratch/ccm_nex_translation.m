%%
%load first file on the list, initialize/reset config
cfg = [];
cfg.dataset = 'bp234n02.nex';

alignEpoch = 'checkerOn';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Re-code events for use by FieldTrip
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfg.event         = ft_read_event(cfg.dataset);

% hdr = ft_read_header(cfg.dataset);
% data = ft_read_data(cfg.dataset);

for i = 1:length(cfg.event)
    cfg.event(i).type         = alignEpoch;
end
cfg.trialdef.eventtype      = alignEpoch;



% DEFINE EVENT CODES (all set in TEMPO code)
%--------------------------------------------------------------------------
eChcmanheader  	= 1503;
eTrialStart    	= 1666;
eFixOn        	= 2301;
eFixate        	= 2660;
eTarget        	= 2651;
eChoice        	= 2652;
eDecide        	= 2811;
eCorrect 		= 2600;
eDistract 		= 2601;
eReward        	= 2727;
eTone         	= 2001;
eSaccade     	= 2810;

eInfosStart   	= 2998;
eInfosZero    	= 3000;  % The number added to all Infos' data in TEMPO


%code to get events into conditionals
eTrialStartInd = find([cfg.event.value] == eTrialStart); % every trial has a TrialStart. Use this find other code align times

% Depending on what we want to align to, we need to add to event code index
switch alignEpoch
    case 'fixOn'
eIndAdd = 1;
    case 'fixWindowEntered'
eIndAdd = 2;
    case 'targOn'
eIndAdd = 3;
    case 'checkerOn'
eIndAdd = 4;
end

% Infos start code, from which other codes will be derived by how many
% eCodes are dropped after the infos start coded until each relevant code.
infosStartInd   = find([cfg.event.value] == eInfosStart); % Find start of each infos dump on each trial

% How many indices after Infos start are the infos variables?
infosSsdInd             = 3;
infosTargIndexInd       = 4;
% infosTargAngleInd     = 34;
% infosTargAmpInd       = 38;
infosTrialOutcomeInd    = 43;
infosTrialTypeInd       = 44;
infosTargAmpInd         = 66;
infosTargAngleInd       = 67;
infosDistAmpInd         = 66;
infosDistAngleInd       = 67;
infosColorCohInd        = 71;

trialTypeGo             = 0;
trialTypeStop           = 1;

outcomeGoTarg           = 7;
outcomeGoDist           = 13;
outcomeStopTarg         = 8;
outcomeStopDist         = 14;
outcomeStopStop         = 4;
outcomeTargAbort        = 6;
outcomeDistAbort        = 16;

targSideIndL            = 1;
targSideIndR         	= 0;

% Event code indices for each condition we want:

% Go trial, target on right (indices)
goR = [cfg.event(infosStartInd + infosTrialTypeInd).value] == (eInfosZero + trialTypeGo) & ...
    [cfg.event(infosStartInd + infosTargIndexInd).value] == (eInfosZero + targSideIndR);

% Go trial, right target, correct choice to target
goTargR = eIndAdd + eTrialStartInd(find(goR & ...
    [cfg.event(infosStartInd + infosTrialOutcomeInd).value] == (eInfosZero + outcomeGoTarg)));

% Go trial, right target, error choice to distractor
goDistR = eIndAdd + eTrialStartInd(find(goR & ...
    [cfg.event(infosStartInd + infosTrialOutcomeInd).value] == (eInfosZero + outcomeGoDist)));


% Stop trial, target on right (indices)
stopR = [cfg.event(infosStartInd + infosTrialTypeInd).value] == (eInfosZero + trialTypeStop) & ...
    [cfg.event(infosStartInd + infosTargIndexInd).value] == (eInfosZero + targSideIndR);

% Stop trial, right target, noncanceled correct choice to target
stopTargR = eIndAdd + eTrialStartInd(find(stopR & ...
    [cfg.event(infosStartInd + infosTrialOutcomeInd).value] == (eInfosZero + outcomeStopTarg)));

% Stop trial, right target, noncanceled error choice to distractor
stopDistR = eIndAdd + eTrialStartInd(find(stopR & ...
    [cfg.event(infosStartInd + infosTrialOutcomeInd).value] == (eInfosZero + outcomeStopDist)));

% Stop trial, right target, canceled response
stopStopR = eIndAdd + eTrialStartInd(find(stopR & ...
    [cfg.event(infosStartInd + infosTrialOutcomeInd).value] == (eInfosZero + outcomeStopStop)));

%% 
goTargRCode     = 9000;
goDistRCode     = 9001;
stopTargRCode   = 9002;
stopDistRCode   = 9003;
stopStopRCode   = 9004;

%Replace old search onset codes with condition specific codes
for t=1:length(goTargR)
    cfg.event(goTargR(t)).value = goTargRCode;
end
for t=1:length(goDistR)
    cfg.event(goDistR(t)).value = goDistRCode;
end
for t=1:length(stopTargR)
    cfg.event(stopTargR(t)).value = stopTargRCode;
end
for t=1:length(stopDistR)
    cfg.event(stopDistR(t)).value = stopDistRCode;
end
for t=1:length(stopStopR)
    cfg.event(stopStopR(t)).value = stopStopRCode;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define trials of interest and prepare data for analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define trials of interest based on event codes
cfg.trialdef.eventvalue     = [goTargRCode goDistRCode stopTargRCode stopDistRCode stopStopRCode]; % the value of the stimulus trigger
cfg.trialdef.prestim        = 0.5; % in seconds
cfg.trialdef.poststim       = 1; % in seconds
cfg = ft_definetrial(cfg);
%prepare data for relevant trials
% cfg.dftfreq   = [60-1*(1/10):(1/10):60+1*(1/10) ]; % filter out 60 hz line noise
% cfg.dftfilter = 'yes';
trialdata = ft_preprocessing(cfg);	% call preprocessing, putting the output in 'trialdata'


%%
% from: preprocessing tutorial
% http://www.fieldtriptoolbox.org/tutorial/preprocessing_erp

cfg = [];
cfg.trials = find(trialdata.trialinfo==goTargRCode);
goTargRTimeLock = ft_timelockanalysis(cfg, trialdata);

cfg = [];
cfg.trials = find(trialdata.trialinfo==goDistRCode);
goDistRTimeLock = ft_timelockanalysis(cfg, trialdata);

cfg = [];
cfg.trials = find(trialdata.trialinfo==stopTargRCode);
stopTargRTimeLock = ft_timelockanalysis(cfg, trialdata);

cfg = [];
cfg.trials = find(trialdata.trialinfo==stopDistRCode);
stopDistRTimeLock = ft_timelockanalysis(cfg, trialdata);

cfg = [];
cfg.trials = find(trialdata.trialinfo==stopStopRCode);
stopStopRTimeLock = ft_timelockanalysis(cfg, trialdata);

cfg = [];
% cfg.layout = 'mpi_customized_acticap64.mat';
% cfg.interactive = 'yes';
% cfg.showoutline = 'yes';
% ft_multiplotER(cfg, goTargRTimeLock, goDistRTimeLock, stopTargRTimeLock, stopStopRTimeLock)
[channel] = ft_channelselection('AD*', trialdata.label);
cfg.channel = channel(1:32); % take the first 32 channels (the last 2 are eye traces)
% cfg.channel = channel;
[cfg] = ft_singleplotER(cfg, goTargRTimeLock, goDistRTimeLock, stopTargRTimeLock, stopStopRTimeLock);

