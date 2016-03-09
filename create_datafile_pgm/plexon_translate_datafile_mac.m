function plexon_translate_datafile_mac(monkey, sessionID)

tic
if nargin < 3
    brainArea = nan;
end

%__________________________________________________________________________
%                            CONSTANTS
%__________________________________________________________________________
EEG_CHANNELS        = [];
LFP_CHANNELS        = 1:8;
PD_CHANNEL          = 2;
STROBE_CHANNEL      = 257;
STROBE_CHANNEL_INDEX = 17;

% For some reason voltage from AD lines in MexPlex (PC translation)
% 2.4414 times larger than in ReadPLXC (mac translation)
% Multiply voltage values by this number to obtain real voltage values
AD_VOLTAGE_FACTOR   = 2.4414; 

% Monitor refresh rate- will need to code as rig-specific
REFRESH_RATE        = 70;

% Number of possible photodiode events is task-specific, but important for
% code below. We want at least as many possible events as there are in any
% task we translate.
N_PHOTODIODE_POSSIBLE = 6;

nError = 0;


prompt = 'Are these LFP and EEG channels correct (y or n)? ';
disp(sprintf('LFP/SPike Channels: %d\n', LFP_CHANNELS))
disp(sprintf('EEG Channels: %d\n', EEG_CHANNELS))
answer = input(prompt, 's');

if strcmp(answer, 'n')
    prompt = 'Enter LFP Channels ';
    LFP_CHANNELS = input(prompt);
    prompt = 'Enter EEG Channels ';
    EEG_CHANNELS = input(prompt);
end



%__________________________________________________________________________
%                      FIND AND LOAD PLEXON FILE
%__________________________________________________________________________

plexonFile = [sessionID, '.plx'];

if regexp('broca', monkey, 'ignorecase')
    monkeyDataPath = 'Broca/';
elseif regexp('xena', monkey, 'ignorecase')
    monkeyDataPath = 'Xena/Plexon/';
else
    disp('Wrong monkey name?')
    return
end
localDataPath = ['/Volumes/HD-1/Users/paulmiddlebrooks/matlab/local_data/',lower(monkey),'/'];
tebaDataPath = ['/Volumes/SchallLab/data/',monkeyDataPath];


% Create a dataset for trial informatio
trialData       = table();
% Create a struct for session information
SessionData     = struct();


tebaFile        = fullfile(tebaDataPath, plexonFile);
plx             = readPLXFileC(tebaFile,'fullread', 'all');




%__________________________________________________________________________
%                     CREATE SESSION DATA STRUCT
%__________________________________________________________________________


SessionData.comment  	= plx.Comment;
SessionData.date        = datestr(plx.Date);
SessionData.duration  	= duration / 1000;


%__________________________________________________________________________
%                           GET EVENTS
%__________________________________________________________________________


% make lists for event codes dropped from TEMPO
% -----------------------------------------------------------------
eventArray = {'Fixate_';...
    'ProFixate_';...
    'DecFixate_';...
    'BetFixate_';...
    'FixSpotOn';... %this is not underscore becuase it is not saved.  it is just used to check photodiode trigger for misses.
    'FixSpotOff_';...
    'Decide_';...
    'Abort_';...
    'Correct_';...
    'Distract_';...
    'Reward_';...
    'Tone_';...
    'Saccade_';...
    'HighBet_';...
    'LowBet_'};

eventNumArray = {'eFixate';...
    'eProFixate';...
    'eDecFixate';...
    'eBetFixate';...
    'eFixOn';...
    'eFixOff';...
    'eDecide';...
    'eAbort';...
    'eCorrect';...
    'eDistract';...
    'eReward';...
    'eTone';...
    'eSaccade';...
    'eHighBet';...
    'eLowBet'};

% THE ORDER OF THIS LIST IS VERY IMPORTANT.  DO NOT CHANGE WITHOUT MAKING
% MATCHING CHANGES TO THE TEMPO CODE!
infosArray = {'allowFixTime';...
    'holdStopDuration';...
    'ssd';...
    'targIndex';...
    'expoJitterFlag';...
    'toneFailure';...
    'fixWinSize';...
    'fixColor_b';...
    'fixColor_g';...
    'fixColor_r';...
    'fixSize';...
    'fixedTrialDuration';...
    'goPct';...
    'ignoreColor_b';...
    'ignoreColor_g';...
    'ignoreColor_r';...
    'ignorePct';...
    'interTrialDuration';...
    'holdtimeMax';...
    'saccDurationMax';...
    'saccTimeMax';...
    'holdtimeMin';...
    'nSSD';...
    'punishDuration';...
    'rewardDuration';...
    'rewardDelay';...
    'staircase';...
    'stopColor_b';...
    'stopColor_g';...
    'stopColor_r';...
    'stopPct';...
    'toneSuccess';...
    'targWinSize';...
    'targAngle';...
    'targColor_b';...
    'targColor_g';...
    'targColor_r';...
    'targAmp';...
    'targHoldtime';...
    'targSize';...
    'toneDuration';...
    'trialDuration';...
    'trialOutcome';...
    'trialType';...
    'eyeXGain';...
    'eyeXOffset';...
    'eyeYGain';...
    'eyeYOffset';...
    'soa'...
    
    'preTargHoldtime';...
    'postTargHoldtime';...
    'targ1CheckerColor_r';...
    'targ1CheckerColor_g';...
    'targ1CheckerColor_b';...
    'targ2CheckerColor_r';...
    'targ2CheckerColor_g';...
    'targ2CheckerColor_b';...
    'chkrWinSize';...
    'nCheckerColumn';...
    'nCheckerRow';...
    'iSquareSizePixels';...
    'checkerWidthDegrees';...
    'checkerHeightDegrees';...
    'checkerAmp';...
    'checkerAngle';...
    'targAmp';...
    'targAngle';...
    'distAmp';...
    'distAngle';...
    'nDiscriminate';...
    'targ1CheckerProp';...
    
    'goCheckerColor_r';...
    'goCheckerColor_g';...
    'goCheckerColor_b';...
    'nogoCheckerColor_r';...
    'nogoCheckerColor_g';...
    'nogoCheckerColor_b';...
    'goCheckerProp'};

% For Broca's files pre-bp050n, on 8/30/12, I was not exporting checkerArray.
% Everything after that does export it.
if datenum(SessionData.date) >= datenum('08/30/12', 'mm/dd/yy')
    % if ~strncmp(plexonFile, 'bp', 2) || (strncmp(plexonFile, 'bp', 2) && filePart >= 50)
    infosArray = [infosArray; 'checkerArray'];
end

% Developed new tempo codes, added new INFOs output
if datenum(SessionData.date) >= datenum('02/04/13', 'mm/dd/yy')
    infosArray = [infosArray; 'maskSize'; ...
        'preBetHoldtime'; ...
        'preProHoldtime'; ...
        'highBetAngle'; ...
        'highBetAmp'; ...
        'lowBetAngle'; ...
        'lowBetAmp'; ...
        'maskColor_r'; ...
        'maskColor_g'; ...
        'maskColor_b'; ...
        'highBetColor_r'; ...
        'highBetColor_g'; ...
        'highBetColor_b'; ...
        'lowBetColor_r'; ...
        'lowBetColor_g'; ...
        'lowBetColor_b'; ...
        'betFixColor_r'; ...
        'betFixColor_g'; ...
        'betFixColor_b'; ...
        'proFixColor_r'; ...
        'proFixColor_g'; ...
        'proFixColor_b'; ...
        'betWinSize'];
end


%--------------------------------------------------------------------------
% define event codes
% time stamped events
% THESE VALUES ARE ALL SET IN THE TEMPO CODE
eCmanheader    	= 1501;
eMemheader      = 1502;
eChcmanheader  	= 1503;
eVisheader      = 1504;
eAmpheader      = 1505;
eGonogoheader  	= 1506;
eDelayheader   	= 1507;
eMaskbetheader 	= 1508;
eTrialstart		= 1666;
eTrialEnd 		= 1667;
eFixate        	= 2660;
eProFixate     	= 2661;
eDecFixate     	= 2662;
eBetFixate     	= 2663;
eFixOn          = 2301;
eFixOff         = 2300;
eDecide        	= 2811;
eMouthbegin  	= 2655;
eMouthend 		= 2656;
eAbort 			= 2620;
eCorrect 		= 2600;
eDistract 		= 2601;
eReward        	= 2727;
eTone         	= 2001;
eSaccade     	= 2810;
eHighBet     	= 2602;
eLowBet     	= 2603;

% trial parameters (not timed)
start_infos		= 2998;
end_infos		= 2999;
infos_zero		= 3000;







%--------------------------------------------------------------------------
% get all of the raw values out of the .plx file
% -----------------------------------------------------------------
% fprintf('\nLoading events from %s ...\n',plexonFile)
% [~, timeStamps, eventCodes] = plx_event_ts([path, plexonFile], STROBE_CHANNEL);
% fprintf('...done!\n\n')
eventCodes  = double(plx.EventChannels(STROBE_CHANNEL_INDEX).Values);
timeStamps  = double(plx.EventChannels(STROBE_CHANNEL_INDEX).Timestamps) ./ (plx.ADFrequency / 1000);

allStarts   = find(eventCodes == eTrialstart);
allEnds     = find(eventCodes == eTrialEnd);








if eventCodes(eventCodes == eCmanheader)
    taskName    = 'Countermanding';
    taskID      = 'cmd';
elseif eventCodes(eventCodes == eChcmanheader)
    taskName    = 'ChoiceCountermanding';
    taskID      = 'ccm';
elseif eventCodes(eventCodes == eGonogoheader)
    taskName    = 'GoNoGo';
    taskID      = 'gng';
elseif eventCodes(eventCodes == eMemheader)
    taskName    = 'Memory';
    taskID      = 'mem';
elseif eventCodes(eventCodes == eDelayheader)
    taskName    = 'Delay';
    taskID      = 'del';
elseif eventCodes(eventCodes == eVisheader)
    taskName    = 'Visual';
    taskID      = 'vis';
elseif eventCodes(eventCodes == eAmpheader)
    taskName    = 'Amplitude';
    taskID      = 'amp';
elseif eventCodes(eventCodes == eMaskbetheader)
    taskName    = 'MaskBet';
    taskID      = 'maskbet';
else
    taskName    = 'Unkown';
    taskID      = 'nan';
end

SessionData.taskName    = taskName;
SessionData.taskID      = taskID;




%--------------------------------------------------------------------------
% get the time stamped events
fprintf('Sorting time stamps...\n')
trialStart      = round(timeStamps(eventCodes == eTrialstart));
firstTrialStart = trialStart(1);
nTrial          = length(trialStart);

% trialEnd            = round(1000 * timeStamps(eventCodes == eTrialEnd));
trialEnd            = round(timeStamps(eventCodes == eTrialEnd));

if length(trialEnd) ~= length(trialStart)
    fprintf('ERROR: The number of start trial events does not equal the number...\n')
    fprintf('...of end trial events.\n')
    Error_{nError+1,1} = 'The number of start trial events does not equal the number of end trial events\n';
    nError = nError+1;
    fprintf('Attempting to locate and delete the problem trial.\n');
    %     trialStart(num_of_ends+1:end) = [];
    
    mismatchFlag = 1;
    iTrial = 0;
    while mismatchFlag
        iTrial = iTrial + 1;
        % If the recording was stopped before the last Infos/end-of-trial
        % code was sent (sometimes happens if experimenter is in a hurry,
        % etc)., drop the last trial
        if iTrial == nTrial && length(trialStart) > length(trialEnd)
            trialStart(iTrial) = [];
            allStarts(iTrial) = [];
             nTrial = nTrial - 1;
       elseif trialEnd(iTrial) > trialStart(iTrial + 1)
            trialStart(iTrial) = [];
            allStarts(iTrial) = [];
             nTrial = nTrial - 1;
       elseif trialStart(iTrial) > trialEnd(iTrial)
            trialEnd(iTrial) = [];
            allEnds(iTrial) = [];
        end
        if length(trialEnd) == length(trialStart)
            mismatchFlag = 0;
            mismatchTrial = iTrial;
        end
    end % while mismatchFlag
end

% except for trialStart, all underscore variables are in trial time, not
% session time
trialEnd = trialEnd - trialStart;

% preallocate strobed event output
for i = 1:length(eventArray);
    iEvent = char(eventArray(i));
    eval(sprintf('%s = nan(nTrial, 1);', iEvent));
end

% assign time stamps to appropriate events
% all_starts  = find(eventCodes == eTrialstart);
% all_ends    = find(eventCodes == eTrialEnd);
iStrobes    = zeros(max(trialEnd), 1); % preallocate zeros to maximum trial duration
iTimeStamps = zeros(max(trialEnd), 1); % preallocate zeros to maximum trial duration
for iTrial = 1 : nTrial
    iStart                  = allStarts(iTrial);
    iEnd                    = allEnds(iTrial);
    iNCode                  = length(eventCodes(iStart : iEnd));
    iStrobes(1 : iNCode)    = eventCodes(iStart : iEnd);
    iTimeStamps(1 : iNCode) = timeStamps(iStart : iEnd);
    for j = 1 : length(eventArray);
        jEvent = char(eventArray(j));
        jCode = char(eventNumArray(j));
        eval(sprintf('codeNumber = %s;',jCode));
        if sum(iStrobes == codeNumber) > 0   % If there was at least one dropped code for the current event....
            jPossTime = iTimeStamps(iStrobes == codeNumber);
            eval(sprintf('%s(iTrial) = round(jPossTime(end));',jEvent));
        end
        
    end
    iStrobes(:) = 0; %reset
end

% put time stamps into time relative to trial starts
for i = 1 : length(eventArray);
    iEvent = char(eventArray(i));
    eval(sprintf('%s = %s - trialStart;', iEvent, iEvent));
    
end

fprintf('...done!\n\n')
toc




%--------------------------------------------------------------------------
% get mouth events
% this has to be done seperately b/c there can be any number of mouth
% movement events per trial

% Get maximum values for preallocating mouth matrices
samples    = (diff(trialStart));
maxSamples = max(samples);
% According to EEE's documentation mouth movements may only be seperated by
% minimum of 500 ms.  I assume 250 just to be on the safe side.
maxSamples = ceil(maxSamples/250);
MouthBegin_(1:nTrial,1:maxSamples) = nan;
MouthEnd_(1:nTrial,1:maxSamples)   = nan;

mouth_starts_ts = round(timeStamps(eventCodes == eMouthbegin) * 1000);
mouth_ends_ts   = round(timeStamps(eventCodes == eMouthend) * 1000);

%NOTE motion detector in 028 lags movement by mean of 29 ms (std 5) under
%optimal conditions (so it is our best guess in all conditions)
mouth_starts_ts = mouth_starts_ts - 29;
mouth_ends_ts   = mouth_ends_ts - 29;

for trl = 1:(nTrial - 1)
    
    thisTrialStart = trialStart(trl);
    nextTrialStart = trialStart(trl+1);
    
    % Which mouth events happened on this trial?
    theseMouthBegins = mouth_starts_ts(mouth_starts_ts >= thisTrialStart &...
        mouth_starts_ts < nextTrialStart);
    theseMouthEnds   = mouth_ends_ts(mouth_ends_ts >= thisTrialStart &...
        mouth_ends_ts < nextTrialStart);
    
    theseMouthBegins = theseMouthBegins - thisTrialStart;
    theseMouthEnds   = theseMouthEnds   - thisTrialStart;
    
    MouthBegin_(trl,1:length(theseMouthBegins)) = theseMouthBegins;
    MouthEnd_(trl,1:length(theseMouthEnds))     = theseMouthEnds;
    
end

% last trial is a special case
lastTrialStart  = trialStart(end);
lastMouthBegins = mouth_starts_ts(mouth_starts_ts >= lastTrialStart);
lastMouthEnds   = mouth_ends_ts(mouth_ends_ts >= lastTrialStart);

lastMouthBegins = lastMouthBegins - lastTrialStart;
lastMouthEnds   = lastMouthEnds   - lastTrialStart;
MouthBegin_(end,1:length(lastMouthBegins)) = lastMouthBegins;
MouthEnd_(end,1:length(lastMouthEnds))     = lastMouthEnds;

% now trim off the stray NaNs
nan_check = nansum(MouthBegin_);
first_nan = find(nan_check == 0,1,'first');
MouthBegin_(:,first_nan:end) = [];

nan_check = nansum(MouthEnd_);
first_nan = find(nan_check == 0,1,'first');
MouthEnd_(:,first_nan:end) = [];








%--------------------------------------------------------------------------
% get non timed trial parameters
Start_Infos_i =  eventCodes == start_infos;


%check for known errors
if sum(Start_Infos_i) ~= nTrial
    fprintf('ERROR: The number of start Infos_ flags does not equal the number of trials.\n')
    fprintf('Infos_ may be inaccurate.\n')
    Error_{nError+1,1} = 'The number of start Infos_ flags does not equal the number of trials. Infos_ may be inaccurate.';
    nError = nError+1;
% Check wether the number of infos start codes equals the number of trials.
% In the case that a trial had to be removed because plexon error, etc,
% infos may have been thrown twice within one trial (if an extra end trial
% code was dropped, e.g.)
if sum(Start_Infos_i) > nTrial
    infoStartInd = find(Start_Infos_i);
    Start_Infos_i(infoStartInd(mismatchTrial)) = [];
end
end

End_Infos_i = eventCodes == end_infos;

%check for known errors
if sum(End_Infos_i) ~= nTrial
    fprintf('ERROR: The number of end Infos_ flags does not equal the number of trials.\n')
    fprintf('Infos_ may be inaccurate.\n')
    Error_{nError+1,1} = 'The number of end Infos_ flags does not equal the number of trials. Infos_ may be inaccurate.';
    nError = nError+1;
% Check wether the number of infos end codes equals the number of trials.
% In the case that a trial had to be removed because plexon error, etc,
% infos may have been thrown twice within one trial (if an extra end trial
% code was dropped, e.g.)
if sum(End_Infos_i) > nTrial
    infoStartInd = find(End_Infos_i);
    End_Infos_i(infoStartInd(mismatchTrial)) = [];
end
end








paramIndex = Start_Infos_i;
for iParam = 1:length(infosArray)
    
    paramName = char(infosArray(iParam));
    
    % If the variable of interest is the checkerboard pattern, use a loop
    if strcmp(paramName,'checkerArray') || strcmp(paramName,'targ1Targ1Array')
        paramValues = [];
        for iIndex = 1 : 100   % there are 100 checkers in the 10 X 10 checkerboard
            paramIndex = logical([0; paramIndex(1:end-1)]);  %shift all logical bits one to the right
            paramValues = [paramValues, eventCodes(paramIndex)];
        end
        paramValues = paramValues - infos_zero;
    else
        paramIndex = logical([0; paramIndex(1:end-1)]);  %shift all logical bits one to the right
        
        paramValues = eventCodes(paramIndex);
        
        %         % Check the signal strengths... make sure they translated
        % acurrately
        %         if strcmp(paramName, 'targ1CheckerProp')
        %             disp(paramValues)
        %             disp(unique(paramValues))
        %         end
        
        %check for known errors
        if sum(paramValues < 0) > 0
            fprintf('ERROR: Negative parameter values discovered in \n')
            fprintf('The number of Infos_ strobes sent may not match the expectation.\n')
            Error_{nError+1,1} = 'Negative parameter values discovered in Infos_. The number of Infos_ strobes sent may not match the expectation.';
            nError = nError+1;
        end
        
        % tempo added a constant to all of these values to keep them seperate
        % from event codes.  we must subtract this now.
        paramValues = paramValues - infos_zero;
        
        % For some (really strange!) reason, some of the signal strength
        % values get altered during translation. fix that here based on
        % known historical inaccurate numbers:
        %         if strcmp(paramName,'targ1CheckerProp')
        %             if strcmp(plexonFile(1:2), 'bp')
        %                 paramValues(paramValues == 58) = 59;
        %             end
        %             if strcmp(plexonFile(1:2), 'xp')
        %                 paramValues(paramValues == 52) = 53;
        %             end
        %         end
        
        
        % many values have been multiplied by 100 to allow for sending floats
        if strcmp(paramName,'fixWinSize')             ||...
                strcmp(paramName,'fixSize')       ||...
                strcmp(paramName,'goPct')           ||...
                strcmp(paramName,'ignorePct')       ||...
                strcmp(paramName,'stopPct')         ||...
                strcmp(paramName,'targSize')         ||...
                strcmp(paramName,'targWinSize')       ||...
                strcmp(paramName,'targAmp') ||...
                strcmp(paramName,'chkrWinSize')      ||...
                strcmp(paramName,'checkerWidthDegrees') ||...
                strcmp(paramName,'checkerHeightDegrees') ||...
                strcmp(paramName,'checkerAmp') ||...
                strcmp(paramName,'distAmp') ||...
                strcmp(paramName,'targ1CheckerProp')       ||...
                strcmp(paramName,'goCheckerProp')         ||...
                strcmp(paramName,'maskSize')         ||...
                strcmp(paramName,'betwinSize');
            paramValues = paramValues / 100;
        end
        
        % some values have been multiplied by 100 and added to 1000 to allow
        % for signed floats
        if strcmp(paramName,'eyeXGain')          ||...
                strcmp(paramName,'eyeYGain')     ||...
                strcmp(paramName,'eyeXOffset')   ||...
                strcmp(paramName,'eyeYOffset')
            paramValues = paramValues - 1000;
            paramValues = paramValues / 100;
            eval(sprintf('%s = nanmean(nonzeros(paramValues));', paramName));
            eval(sprintf('%s(isnan(%s)) = 0;', paramName, paramName));
        end
    end % if strcmp(param_name,'targ1Targ2Array')
    
%     paramValues = paramValues(1:nTrial);  % In case we had to delete a trial
    if ~(strcmp(paramName,'eyeXGain')          ||...
            strcmp(paramName,'eyeYGain')     ||...
            strcmp(paramName,'eyeXOffset')   ||...
            strcmp(paramName,'eyeYOffset'))
            eval(sprintf('%s = paramValues;', paramName));
    end
    
end
paramIndex = logical([0; paramIndex(1:end-1)]);  %shift all logical bits one to the right
check4end = eventCodes(paramIndex);

%check for known errors
if length(unique(check4end)) ~= 1 ||...
        unique(check4end) ~= end_infos
    fprintf('ERROR: End Infos_ flags did not occur when expected on 1 or more trials.\n')
    fprintf('Infos_ may be inaccurate.\n')
    Error_{nError+1,1} = 'End Infos_ flags did not occur when expected on 1 or more trials. Infos_ may be inaccurate.';
    nError = nError+1;
end

% convert refresh rate to ms
ssd = round(ssd * (1000/REFRESH_RATE));
soa = round(soa * (1000/REFRESH_RATE));

% some fields in Infos_ are better represented as cells with strings
temp = cell(nTrial,1);
temp(trialOutcome == 1) = {'noFixation'};
temp(trialOutcome == 2) = {'fixationAbort'};
temp(trialOutcome == 3) = {'goIncorrect'};
temp(trialOutcome == 4) = {'stopCorrect'};
temp(trialOutcome == 5) = {'sacadeAbort'};
temp(trialOutcome == 6) = {'targetHoldAbort'};
temp(trialOutcome == 7) = {'goCorrectTarget'};
temp(trialOutcome == 8) = {'stopIncorrectTarget'};
temp(trialOutcome == 9) = {'earlySaccade'};
temp(trialOutcome == 10) = {'noSaccade'};  % for vgs, mgs, delay, etc.
temp(trialOutcome == 11) = {'saccToTarget'};  % for vgs, mgs, delay, etc.
temp(trialOutcome == 12) = {'bodyMove'};
temp(trialOutcome == 13) = {'goCorrectDistractor'};
temp(trialOutcome == 14) = {'stopIncorrectDistractor'};
temp(trialOutcome == 15) = {'choiceStimulusAbort'};
temp(trialOutcome == 16) = {'distractorHoldAbort'};
temp(trialOutcome == 17) = {'saccToDistractor'};
temp(trialOutcome == 18) = {'betFixationAbort'};
temp(trialOutcome == 19) = {'betHoldAbort'};
temp(trialOutcome == 20) = {'highBet'};
temp(trialOutcome == 21) = {'lowBet'};
temp(trialOutcome == 22) = {'targHighBet'};
temp(trialOutcome == 23) = {'disHighBet'};
temp(trialOutcome == 24) = {'targLowBet'};
temp(trialOutcome == 25) = {'distLowBet'};
trialData.trialOutcome = temp;
% trialData.trialOutcome = temp(1:nTrial);


temp = cell(nTrial,1);
temp(trialType == 0) = {'go'};
temp(trialType == 1) = {'stop'};
temp(trialType == 2) = {'ignore'};
temp(trialType == 3) = {'nogo'};
temp(trialType == 4) = {'mask'};
temp(trialType == 5) = {'bet'};
temp(trialType == 6) = {'retro'};
temp(trialType == 7) = {'pro'};
trialData.trialType = temp;
% trialData.trialType = temp(1:nTrial);









% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PHOTODIODE EVENTS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fprintf('Loading photodiode triggers from %s...\n', plexonFile)
% [N_PDs, timeStamps] = plx_event_ts([path, plexonFile], PD_CHANNEL);
% fprintf('...done!\n\n');
timeStamps = round(double(plx.EventChannels(2).Timestamps) ./ (plx.ADFrequency / 1000));
% timeStamps = round(timeStamps * 1000);


photodiode = zeros(nTrial, N_PHOTODIODE_POSSIBLE);
% photodiode(1:nTrial,1 : N_PHOTODIODE_POSSIBLE) = 0; %can have up to 6 pd events per trial

for iTrial = 1:nTrial;
    
    iStart = trialStart(iTrial);
    iEnd   = iStart + trialEnd(iTrial);
    iTimeStamps = timeStamps(timeStamps > iStart &...
        timeStamps < iEnd);
    photodiode(iTrial, 1 : length(iTimeStamps)) = iTimeStamps;
    
end


% some photodiodes (room 029) are sensitive enough to detect monitor
% flicker.  this screws us up.  if successive photodiode events are in the
% range of monitor flicker, remove them.
% NOTE: this means we can never have SSDs < 2 refresh cycles.
flicker_test = diff(photodiode,1,2);
zero_pad(1:length(flicker_test(:,1)),1) = 0;
flicker_test = [zero_pad flicker_test];
flicker_test = flicker_test > 0 & flicker_test < 20; % estimated based on 70Hz refresh
photodiode(flicker_test) = nan;
photodiode = [photodiode zero_pad];

% we have replaced all of the false alarm refresh flickers with nans.
% now the code below just "pushes" all of the nans to the right and puts
% the real photodiode events in the first few columns
pdCell = num2cell(photodiode, 2);
pdCell = cellfun(@(x) [x(~isnan(x)) x(isnan(x))], pdCell, 'uniformoutput', false);
photodiode = cell2mat(pdCell);
% for iColumn = 2 : N_PHOTODIODE_POSSIBLE % there can only be maximum of N_PHOTODIODE_POSSIBLE photodiode events on any given trial
%     next_iColumn = iColumn + 1;
%     iNan = find(isnan(photodiode(:,iColumn)));
%     while ~isempty(iNan)
%         iColumn
%         sum(isnan(photodiode(:,iColumn-1)))
%         photodiode(1:20,:)
%         pause
%         photodiode(iNan, iColumn) = photodiode(iNan, next_iColumn);
%         photodiode(iNan, next_iColumn) = nan;
%         next_iColumn = next_iColumn + 1;
%         iNan = find(isnan(photodiode(:,iColumn)));
%         if iColumn > 2 && sum(isnan(photodiode(:,iColumn-1))) == 0
%             if sum(photodiode(:,iColumn-1)) == 0
%                 iNan = [];
%             end
%         end
%     end
% end

photodiode(photodiode == 0) = nan; % up to this point nans were used for flicker testing

switch taskName
    case 'Countermanding'
        trialData.fixOn  = photodiode(:,1) - trialStart;
        trialData.targOn     = photodiode(:,2) - trialStart;
        trialData.stopSignalOn = photodiode(:,3) - trialStart;
        stopTrial = ~isnan(trialData.stopSignalOn);
    case 'ChoiceCountermanding'
        trialData.fixOn  = photodiode(:,1) - trialStart;
        trialData.targOn     = photodiode(:,2) - trialStart;
        trialData.checkerOn     = photodiode(:,3) - trialStart;
        % Differentiate here between the delayed-vs-rt version of ccm
        if nanmean(soa) == 0
            trialData.fixOff        = photodiode(:,3) - trialStart;
            trialData.responseCueOn     = photodiode(:,3) - trialStart;
            trialData.stopSignalOn = photodiode(:,4) - trialStart;
        elseif nanmean(soa) > 0
            trialData.fixOff        = photodiode(:,4) - trialStart;
            trialData.responseCueOn     = photodiode(:,4) - trialStart;
            trialData.stopSignalOn = photodiode(:,5) - trialStart;
        end
        stopTrial = ~isnan(trialData.stopSignalOn);
    case 'GoNoGo'
        trialData.fixOn  = photodiode(:,1) - trialStart;
        trialData.targOn     = photodiode(:,2) - trialStart;
        trialData.checkerOn        = photodiode(:,3) - trialStart;
    case 'Memory'
        trialData.fixOn  = photodiode(:,1) - trialStart;
        trialData.targOn     = photodiode(:,2) - trialStart;
        trialData.fixOff = photodiode(:,3) - trialStart;
    case 'Delay'
        trialData.fixOn  = photodiode(:,1) - trialStart;
        trialData.targOn     = photodiode(:,2) - trialStart;
        trialData.fixOff = photodiode(:,3) - trialStart;
    case 'Visual'
        trialData.fixOn  = photodiode(:,1) - trialStart;
        trialData.targOn     = photodiode(:,2) - trialStart;
    case 'MaskBet'
        for iTrial = 1 : nTrial
            % Need a way to tell which typp of trial is being run, to
            % determine the correct order of photodiode events
            switch trialData.trialType{iTrial}
                case  'mask'
                    trialData.decFixOn  = photodiode(:,1) - trialStart;
                    trialData.decMaskOn     = photodiode(:,2) - trialStart;
                    trialData.decFixOff     = photodiode(:,3) - trialStart;
                case  'bet'
                    trialData.betFixOn  = photodiode(:,1) - trialStart;
                    trialData.betTargOn     = photodiode(:,2) - trialStart;
                    trialData.betFixOff     = trialData.betTargOn;
                case  'retro'
                    trialData.decFixOn  = photodiode(:,1) - trialStart;
                    trialData.decMaskOn     = photodiode(:,2) - trialStart;
                    trialData.decFixOff     = photodiode(:,3) - trialStart;
                    trialData.betFixOn     = photodiode(:,4) - trialStart;
                    trialData.betTargOn     = photodiode(:,5) - trialStart;
                    trialData.betFixOff     = trialData.betTargOn;
                case  'pro'
                    trialData.proFixOn  = photodiode(:,1) - trialStart;
                    trialData.proMaskOn     = photodiode(:,2) - trialStart;
                    trialData.betFixOn     = photodiode(:,3) - trialStart;
                    trialData.betTargOn     = photodiode(:,4) - trialStart;
                    trialData.betFixOff     = trialData.betTargOn;
                    trialData.decFixOn  = photodiode(:,5) - trialStart;
                    trialData.decMaskOn  = photodiode(:,6) - trialStart;
                otherwise
                    disp('Not a valid metacog trial type')
                    return
            end
        end
end




%
%
% %--------------------------------------------------------------------------
% % now that we have all of the events double check to see if the photodiode
% % trigger ever failed, and, if so, try to recover.
% no_pd_trials        = [];
% unexpected_pd_error = 0;
%
% correct_no_StopSig = unique([strmatch('GO',Infos_.trialType);... % these are the trials on which stop signals should not have been presented
%     strmatch('no fixation',   Infos_.trialOutcome);...
%     strmatch('broke fixation',Infos_.trialOutcome)]);
% stop_check(1:nTrial,1) = 1;
% stop_check(correct_no_StopSig)      = 0;
% stop_check                          = logical(stop_check);  % 1 if we were supposed to have a stop signal, 0 if we were NOT supposed to have one.
%
% if sum(isnan(fixOn_) & ~isnan(fixOn)) > 0 % if we were expecting a fixation pd event but we didn't get one
%     curr_no_pd_trials              = find(isnan(fixOn_) & ~isnan(fixOn));
%     fixOn_(curr_no_pd_trials)  = fixOn(curr_no_pd_trials);
%     test_cell = Infos_.trialOutcome(curr_no_pd_trials); % what types of outcomes are associated with pd failure?
%     if length(strmatch('broke fixation',test_cell)) > length(test_cell) % if pd failure happened even though animal held fixation
%         unexpected_pd_error = 1;
%     end
%     no_pd_trials                   = [no_pd_trials;curr_no_pd_trials];
% end
%
% if sum(isnan(trialData.targOn) & ~isnan(trialData.fixOff)) > 0 % if we were expecting a target pd event but we didn't get one
%     curr_no_pd_trials              = find(isnan(trialData.targOn) & ~isnan(trialData.fixOff));
%     trialData.targOn(curr_no_pd_trials)     = trialData.fixOff(curr_no_pd_trials);
%     fixOn_(curr_no_pd_trials)  = fixOn(curr_no_pd_trials); % this is b/c we can't tell which pd event in sequence failed
%     test_cell = Infos_.trialOutcome(curr_no_pd_trials); % what types of outcomes are associated with pd failure?
%     if length(strmatch('broke fixation',test_cell)) > length(test_cell) % if pd failure happened even though animal held fixation
%         unexpected_pd_error = 1;
%     end
%     no_pd_trials                   = [no_pd_trials;curr_no_pd_trials];
% end
%
% if sum(isnan(trialData.stopSignalOn) & stop_check) > 0 % if we were expecting a stop signal pd event but we didn't get one
%     curr_no_pd_trials              = find(isnan(trialData.stopSignalOn) & stop_check);
%     trialData.targOn(curr_no_pd_trials)     = trialData.fixOff(curr_no_pd_trials);  % this is b/c we can't tell which pd event in sequence failed
%     trialData.stopSignalOn(curr_no_pd_trials) = Infos_.Curr_SSD(curr_no_pd_trials) + trialData.targOn(curr_no_pd_trials);
%     fixOn_(curr_no_pd_trials)  = fixOn(curr_no_pd_trials); % this is b/c we can't tell which pd event in sequence failed
%     test_cell = Infos_.trialOutcome(curr_no_pd_trials); % what types of outcomes are associated with pd failure?
%     if length(strmatch('broke target',test_cell)) > length(test_cell) % if pd failure happened even though animal held gaze on target
%         unexpected_pd_error = 1;
%     end
%     no_pd_trials                   = [no_pd_trials;curr_no_pd_trials];
% end
%
% No_PD_Trials_ = nonzeros(unique(no_pd_trials)); %make it an underscore so that it gets saved
%
% if unexpected_pd_error
%     num_no_pd_trials = num2str(length(no_pd_trials));
%     per_no_pd_trials = num2str(round(100*(length(no_pd_trials)/nTrial)));
%     fprintf('ERROR: Photodiode trigger was not recieved on %s trials (%s %%).\n',num_no_pd_trials,per_no_pd_trials)
%     fprintf('Subbing less accurate tempo timing in for photodiode timing.\n\n')
%     Error_{error_ct+1,1} = 'ERROR: Photodiode trigger was not recieved on unexpected trials. Subbing less accurate tempo timing in for photodiode timing';
%     error_ct = error_ct + 1;
% end
%




%--------------------------------------------------------------------------
% check for errors, and prepare output for export
if nError > 0
    fprintf('\n***WARNING*** 1 or more translation errors detected.  Review Error_ variable for details.\n\n');
end









% Event Timing
% ------------
trialData.trialOnset                = trialStart - trialStart(1);
trialData.trialDuration             = trialEnd;

trialData.rewardOn               = num2cell(Reward_, 2);  % The odd columns are the reward times
trialData.rewardDuration            = num2cell(rewardDuration, 2);  % The even columns are the solenoid durations
trialData.timeoutDuration           = punishDuration;

trialData.abortTime                = Abort_;

trialData.toneOn       = Tone_(:, 1);
trialData.toneDuration       = toneDuration;



% Get task-specific variables as a structure to be read out and added to
% the rest of the dataset
switch taskID
    case 'ccm'
        trialData.fixWindowEntered      = Fixate_(:, 1);
        trialData.targWindowEntered    	= Decide_(:, 1);
        trialData.targAmp              	= targAmp;
        trialData.targAngle           	= targAngle;
        trialData.targSize              = targSize;
        trialData.targWindow            = targWinSize;
        trialData.fixAmp                = zeros(nTrial, 1);
        trialData.fixAngle              = zeros(nTrial, 1);
        trialData.fixSize               = fixSize;
        trialData.fixWindow             = fixWinSize;
        
        trialData.targ1CheckerProp      = targ1CheckerProp;
        trialData.preTargFixDuration  	= trialData.targOn - trialData.fixOn;
        trialData.postTargFixDuration   = trialData.checkerOn - trialData.targOn;
        trialData.distOn                = trialData.targOn; %  For now, distractor and target appear simultaneously
        trialData.distDuration          = nan(nTrial, 1);  %
        trialData.checkerDuration       = nan(nTrial, 1);
        trialData.stopDuration        	= nan(nTrial, 1);
        trialData.stopTrialProp         = stopPct ./ 100;
        trialData.distAmp               = distAmp;
        trialData.distAngle             = distAngle;
        trialData.distSize              = targSize;
        trialData.distWindow            = targWinSize;
        trialData.checkerAmp            = checkerAmp;
        trialData.checkerAngle          = checkerAngle;
        trialData.checkerSize           = checkerWidthDegrees;
        trialData.checkerWindow         = chkrWinSize;
        trialData.ssd                   = nan(nTrial, 1);  %
        trialData.ssd(stopTrial)      	= ssd(stopTrial);
        if exist('checkerArray','var')  % Before session 50 for Broca, was not sending the checker stimuli pattern
            trialData.checkerArray  = checkerArray;
        end
        
        %         % Need to do a little SSD value adjusting, due to 1 ms differences in SSD values
        %         ssd = trialData.stopSignalOn - trialData.responseCueOn;
        %         ssdArray = unique(trialData.stopSignalOn - trialData.responseCueOn);
        %         ssdArray(isnan(ssdArray)) = [];
        %         if ~isempty(ssdArray)
        %             a = diff(ssdArray);
        %             addOne = ssdArray(a == 1);
        %             [d,i] = ismember(ssd, addOne);
        %             ssd(d) = ssd(d) + 1;
        %         end
        %         trialData.ssd = ssd;
        
        SessionData.stimuli.stopSignalRGB       = [stopColor_r(1,:), stopColor_g(1,:), stopColor_b(1,:)];
        SessionData.stimuli.target1CheckerRGB   = [targ1CheckerColor_r(1,:), targ1CheckerColor_g(1,:), targ1CheckerColor_b(1,:)];
        SessionData.stimuli.target2CheckerRGB   = [targ2CheckerColor_r(1,:), targ2CheckerColor_g(1,:), targ2CheckerColor_b(1,:)];
        SessionData.stimuli.nCheckerboardColumn = nCheckerColumn(1,:);
        SessionData.stimuli.nCheckerboardRow    = nCheckerRow(1,:);
        SessionData.stimuli.iCheckerPixel       = iSquareSizePixels(1,:);
        
        
    case 'cmd'
        trialData.fixWindowEntered     = Fixate_(:, 1);
        trialData.targWindowEntered       = Decide_(:, 1);
        trialData.targAmp                   = targAmp;
        trialData.targAngle                   = targAngle;
        trialData.targSize              = targSize;
        trialData.targWindow            = targWinSize;
        trialData.fixAmp       = zeros(nTrial, 1);
        trialData.fixAngle           = zeros(nTrial, 1);
        trialData.fixSize            = fixSize;
        trialData.fixWindow          = fixWinSize;
        
        trialData.stopDuration                  = nan(nTrial, 1);
        trialData.stopTrialProp                 = stopPct ./ 100;
        
        trialData.responseCueOn                 = trialData.targOn;  % For now this the choice stimulus onset is the cue to responed, but could possibly change that
        SessionData.stimuli.stopSignalRGB       = [stopColor_r(1,:), stopColor_g(1,:), stopColor_b(1,:)];
        
    case 'gng'
        trialData.fixWindowEntered     = Fixate_(:, 1);
        trialData.targWindowEntered       = Decide_(:, 1);
        trialData.targAmp                   = targAmp;
        trialData.targAngle                   = targAngle;
        trialData.targSize              = targSize;
        trialData.targWindow            = targWinSize;
        trialData.fixAmp       = zeros(nTrial, 1);
        trialData.fixAngle           = zeros(nTrial, 1);
        trialData.fixSize            = fixSize;
        trialData.fixWindow          = fixWinSize;
        
        trialData.goCheckerProp  = goCheckerProp;
        trialData.preTargFixDuration            = trialData.targOn - trialData.fixOn;
        trialData.checkerDuration               = nan(nTrial, 1);
        trialData.responseCueOn                 = trialData.checkerOn;
        
        SessionData.stimuli.goCheckerRGB        = [goCheckerColor_r(1,:), goCheckerColor_g(1,:), goCheckerColor_b(1,:)];
        SessionData.stimuli.noGoCheckerRGB      = [nogoCheckerColor_r(1,:), nogoCheckerColor_g(1,:), nogoCheckerColor_b(1,:)];
        SessionData.stimuli.nCheckerboardColumn = nCheckerColumn(1,:);
        SessionData.stimuli.nCheckerboardRow    = nCheckerRow(1,:);
        SessionData.stimuli.iCheckerPixel       = iSquareSizePixels(1,:);
        
    case 'mem'
        trialData.fixWindowEntered     = Fixate_(:, 1);
        trialData.targWindowEntered       = Decide_(:, 1);
        trialData.targAmp                   = targAmp;
        trialData.targAngle                   = targAngle;
        trialData.targSize              = targSize;
        trialData.targWindow            = targWinSize;
        trialData.fixAmp       = zeros(nTrial, 1);
        trialData.fixAngle           = zeros(nTrial, 1);
        trialData.fixSize            = fixSize;
        trialData.fixWindow          = fixWinSize;
        
        trialData.responseCueOn          = trialData.fixOff;  % For now this the choice stimulus onset is the cue to responed, but could possibly change that
    case 'del'
        trialData.fixWindowEntered     = Fixate_(:, 1);
        trialData.targWindowEntered       = Decide_(:, 1);
        trialData.targAmp                   = targAmp;
        trialData.targAngle                   = targAngle;
        trialData.targSize              = targSize;
        trialData.targWindow            = targWinSize;
        trialData.fixAmp       = zeros(nTrial, 1);
        trialData.fixAngle           = zeros(nTrial, 1);
        trialData.fixSize            = fixSize;
        trialData.fixWindow          = fixWinSize;
        
        trialData.responseCueOn          = trialData.fixOff;  % For now this the choice stimulus onset is the cue to responed, but could possibly change that
    case 'vis'
        trialData.fixWindowEntered     = Fixate_(:, 1);
        trialData.targWindowEntered       = Decide_(:, 1);
        trialData.targAmp                   = targAmp;
        trialData.targAngle                   = targAngle;
        trialData.targSize              = targSize;
        trialData.targWindow            = targWinSize;
        trialData.fixAmp            = zeros(nTrial, 1);
        trialData.fixAngle           = zeros(nTrial, 1);
        trialData.fixSize            = fixSize;
        trialData.fixWindow          = fixWinSize;
        
        trialData.responseCueOn          = trialData.targOn;  % For now this the choice stimulus onset is the cue to responed, but could possibly change that
    case 'amp'
        trialData.fixWindowEntered     = Fixate_(:, 1);
        trialData.targWindowEntered       = Decide_(:, 1);
        trialData.targAmp                   = targAmp;
        trialData.targAngle                   = targAngle;
        trialData.targSize              = targSize;
        trialData.targWindow            = targWinSize;
        trialData.fixAmp            = zeros(nTrial, 1);
        trialData.fixAngle           = zeros(nTrial, 1);
        trialData.fixSize            = fixSize;
        trialData.fixWindow          = fixWinSize;
        
        trialData.responseCueOn          = trialData.targOn;  % For now this the choice stimulus onset is the cue to responed, but could possibly change that
    case 'maskbet'
        trialData.proFixWindowEntered     = ProFixate_(:, 1);
        
        trialData.decFixAmp             = zeros(nTrial, 1);
        trialData.decFixAngle           = zeros(nTrial, 1);
        trialData.decFixSize            = fixSize;
        trialData.decFixWindow          = fixWinSize;
        trialData.decFixWindowEntered     = DecFixate_(:, 1);
        
        trialData.decTargAmp          	= targAmp;
        trialData.decTargAngle        	= targAngle;
        trialData.decTargSize         	= targSize;
        trialData.decTargWindow        	= targWinSize;
        trialData.decTargWindowEntered       = nanmean([Correct_(:, 1),Distract_(:, 1)], 2);  % Either high or lo;
        
        trialData.decMaskSize          	= maskSize;
        trialData.decMaskAmp          	= targAmp;
        trialData.decMaskAngle          = repmat(unique(trialData.decTargAngle(~isnan(trialData.decTargAngle)))',nTrial,1); % All mask angles, including target and distractors
        
        trialData.betFixWindowEntered  	= BetFixate_(:, 1);
        trialData.betTargWindowEntered 	= nanmean([HighBet_(:, 1),LowBet_(:, 1)], 2);  % Either high or low bet code (or neither) will be dropped upon bet
        trialData.betHighAmp            = highBetAmp;
        trialData.betHighAngle       	= highBetAngle;
        trialData.betLowAmp             = lowBetAmp;
        trialData.betLowAngle       	= lowBetAngle;
        trialData.betTargSize              = maskSize;
        trialData.betTargWindow            = targWinSize;
        trialData.betFixAmp             = zeros(nTrial, 1);
        trialData.betFixAngle           = zeros(nTrial, 1);
        trialData.betFixSize            = fixSize;
        trialData.betFixWindow          = fixWinSize;
        
        trialData.soa                   = soa;  %
        trialData.decTargOn                   = trialData.decMaskOn - soa;  %
        trialData.decResponseCueOn     	= trialData.decFixOff;  % For now this the choice stimulus onset is the cue to responed, but could possibly change that
        trialData.betResponseCueOn     	= trialData.betTargOn;  % For now this the choice stimulus onset is the cue to responed, but could possibly change that
        
        decTargTrial                    = ~isnan(Correct_);
        decDistTrial                    = ~isnan(Distract_);
        trialData.decOutcome            = cell(nTrial, 1);
        trialData.decOutcome(logical(decTargTrial)) = {'target'};
        trialData.decOutcome(logical(decDistTrial)) = {'distractor'};
        
        betHighTrial                    = ~isnan(HighBet_);
        betLowTrial                     = ~isnan(LowBet_);
        trialData.betOutcome            = cell(nTrial, 1);
        trialData.betOutcome(logical(betHighTrial)) = {'high'};
        trialData.betOutcome(logical(betLowTrial)) = {'low'};
        
        
        
        SessionData.maskAngle           = unique(trialData.decTargAngle(~isnan(trialData.decTargAngle)));
        SessionData.betAngle            = unique(trialData.betHighAngle(~isnan(trialData.betHighAngle)));
    otherwise
        fprintf('%s is not a valid task ID', taskID)
        return
end

nTrial = size(trialData, 1);
taskID = SessionData.taskID;












%__________________________________________________________________________
%                   GET SPIKE TIME DATA.
%__________________________________________________________________________
nSpikeChannel               = length(plx.SpikeChannels);

SessionData.spikeUnitArray  = {};
spikeChannelArray           = [];
nUnitInd                 = 1; % nUnitFilled gets incremented with each unit


% Although online plexon allows only 4 units per channel, offline sorting
% allows more. Enable that possibility here:
unit_appends = {'a','b','c','d','e','f'};
for iChannel = 1:nSpikeChannel
    
    % If channel has no data, skip to next one.
    if isempty(plx.SpikeChannels(iChannel).Timestamps)
        continue
    end
    
    % How many units on this channel? Units are numbered from 0
    maxUnit = double(max(plx.SpikeChannels(iChannel).Units));
    for jUnit = 1 : maxUnit
        jUnitAppend = char(unit_appends(jUnit));
        jStampInd = plx.SpikeChannels(iChannel).Units == jUnit;  % Get the timestamp indices for this particular unit
        jSpikeTime = round(double(plx.SpikeChannels(iChannel).Timestamps(jStampInd)) ./ (plx.ADFrequency / 1000));
        
        % Initialize an empty cell to add to trialData dataset
        iData = cell(nTrial, 1);
        
        % Extract the spike timestamps within the given trial
        for iTrial = 1 : nTrial
            if iTrial < nTrial
                spikeRealTime            = jSpikeTime(jSpikeTime >= firstTrialStart + trialData.trialOnset(iTrial) & jSpikeTime < firstTrialStart + trialData.trialOnset(iTrial+1));
            elseif iTrial == nTrial
                spikeRealTime            = jSpikeTime(jSpikeTime >= firstTrialStart + trialData.trialOnset(iTrial) & jSpikeTime < firstTrialStart + trialData.trialDuration(iTrial));
            end
            
            % Adjust the trial's spike time so it's relative to trial start
            iData{iTrial} = spikeRealTime - (firstTrialStart + trialData.trialOnset(iTrial)+1);
        end
        
        % Fill the spikeData from all the trials for this jUnit
        trialData.spikeData(:,nUnitInd) = iData;
        
        unitName = sprintf('spikeUnit%s%s', num2str(iChannel, '%02i'), jUnitAppend); %figure out the channel name
        SessionData.spikeUnitArray = [SessionData.spikeUnitArray, unitName];

        
        nUnitInd = nUnitInd + 1;
    end  % while addUnit
end  % for iChannel
% end





%__________________________________________________________________________
%                    GET CONTINUOUS ANALOG DATA.
%__________________________________________________________________________
nADChannel = length(plx.ContinuousChannels);

SessionData.lfpChannel = [];
iEEG = 1;
iLFP = 1;

dateNumber = datenum(SessionData.date);

% this is rig and date specific
% conditional statements may be added
if dateNumber < 734597
    xChannel = 49;
    yChannel = 50;
elseif dateNumber >= 734597 % 04-Apr-2011 (moved eye channels to top)
    xChannel = 63;
    yChannel = 64;
end


% get AD channels
for iChannel = 1:nADChannel
    
    % If channel has no data, skip to next one.
    if isempty(plx.ContinuousChannels(iChannel).Values)
        continue
    end
    
    % name the channel
    if iChannel < 10
        ADname = ['AD0',num2str(iChannel)];
    else
        ADname = ['AD',num2str(iChannel)];
    end
    
    if iChannel == xChannel
        ADname = 'eyeX';
    elseif iChannel == yChannel
        ADname = 'eyeY';
    end
    
    % Get the raw voltage data
    adValues    = double(plx.ContinuousChannels(iChannel).Values);
    adValues    = adValues ./ plx.ContinuousChannels(iChannel).ADGain;
    adValues    = adValues ./ plx.ContinuousChannels(iChannel).PreAmpGain;
    adValues    = adValues .* AD_VOLTAGE_FACTOR;
    
    % Need to shift the AD Values based on when plexon started collecting
    % data (Timestamps value is first timestamp for this channel
    lagShift    = ceil(plx.ContinuousChannels(iChannel).Timestamps / (plx.ADFrequency / 1000));
    adValues    = [nan(lagShift, 1); adValues];
    
    
        
        % if it is an eye channel, do some post processing
        if strcmp(ADname,'eyeX') ||...
                strcmp(ADname,'eyeY')
            % convert the channel from voltage to degrees
            if iChannel == xChannel
%                 adValues = adValues * AD_VOLTAGE_FACTOR / 400; %this may need to be done to take vector into account
                adValues = (adValues * eyeXGain) - eyeXOffset; %this may need to be done to take vector into account
            elseif iChannel == yChannel
%                 adValues = adValues * AD_VOLTAGE_FACTOR / 400; %this may need to be done to take vector into account
                adValues = (adValues * eyeYGain) - eyeYOffset; %this may need to be done to take vector into account
                adValues = -adValues;
            end
            
            % gaussian polynomial for convolving eye traces
            polyWidth = 12;
            polyn = gaussmf(polyWidth/-2 : polyWidth/2, [polyWidth/4,0]);
            polyn = polyn/sum(polyn); % now it sums to 1
            
            %smooth out analog line noise
            %     adValues = conv_2009a(adValues, polyn, 'same');
            adValues = conv(adValues, polyn, 'same');
        end
        
        
        
        % Initialize an empty cell to add to trialData dataset
        iData = cell(nTrial, 1);
        % Loop through trials and add the AD data to trialData table
        for iTrial = 1 : nTrial
            if iTrial < nTrial
                iData{iTrial}            = adValues(firstTrialStart + trialData.trialOnset(iTrial) : firstTrialStart + trialData.trialOnset(iTrial+1));
            elseif iTrial == nTrial
                iData{iTrial}            = adValues(firstTrialStart + trialData.trialOnset(iTrial) : firstTrialStart + trialData.trialOnset(iTrial) + trialData.trialDuration(iTrial));
            end
            
            
            
        end
        if strncmp(ADname, 'eye', 3)
            % Eye position
            % ---------------------------------------------------------------
            trialData.(ADname) = iData;
        elseif ismember(iChannel, EEG_CHANNELS)
            trialData.eegData(:,iEEG) = iData;
            iEEG = iEEG + 1;
        elseif ismember(iChannel, LFP_CHANNELS)
            trialData.lfpData(:,iLFP) = iData;
            SessionData.lfpChannel = [SessionData.lfpChannel; iChannel];
            iLFP = iLFP + 1;
        end
end
clear adValues %conserve memory















%__________________________________________________________________________
%                   GET SACCADE DATA.
%__________________________________________________________________________
eyeSampleHz = 1000;

% [SaccBegin,...
%     SaccEnd,...
%     SaccAmplitude,...
%     SaccDirection,...
%     SaccVelocity,...
%     SaccDuration,...
%     SaccsNBlinks, ...
%     Sacc_of_interest] = saccade_data(EyeX_,...
%     EyeY_,...
%     TrialStart_, ...
%     Target_, ...
%     Correct_, ...
%     Eot_, ...
%     Infos_.Fix_win_size, ...
%     eyeSampleHz);

trialData = saccade_data(trialData, taskID, eyeSampleHz);
% trialData = saccade_data(trialData, adData.eyeX, adData.eyeY, eyeSampleHz);

% Calculate RT if there is one to calculate
if ismember('responseOnset',trialData.Properties.VariableNames)
    trialData.rt = trialData.responseOnset - trialData.responseCueOn;
end




fprintf('Saving behavioral variables to %s ...\n', sessionID);
% Save a copy on teba
% saveFileName = [tebaDataPath, sessionID];
% save(saveFileName, 'trialData', 'SessionData')
% Make a local copy too
saveLocalName = [localDataPath, sessionID];
save(saveLocalName, 'trialData', 'SessionData')

toc
