function [Events,...
    X_gain,...
    X_offset,...
    Y_gain,...
    Y_offset] = plexon_events_translation(path,file)
% Event translation code to be used in conjuction with ALL_PROS.pro.  This
% includes any Countermanding file recorded by David Godlove after the
% start of 2011.

% see plx2mat_events.m
path
file

PD_channel     = 2;
Strobe_channel = 257;
Refresh_rate   = 70;

% Number of possible photodiode events is task-specific, but important for
% code below. We want at least as many possible events as there are in any
% task we translate.
nPhotoDiodePossible = 5;

error_ct = 0;


%--------------------------------------------------------------------------
% make lists for loops below
event_list = {'Fixate_';...
    'FixSpotOn';... %this is not underscore becuase it is not saved.  it is just used to check photodiode trigger for misses.
    'FixSpotOff_';...
    'Decide_';...
    'Abort_';...
    'Correct_';...
    'Reward_';...
    'Tone_';...
    'Saccade_'};

event_num_list = {'fixate';...
    'fixspoton';...
    'fixspotoff';...
    'decide';...
    'abort';...
    'correct';...
    'reward';...
    'tone';...
    'saccade'};

% THE ORDER OF THIS LIST IS VERY IMPORTANT.  DO NOT CHANGE WITHOUT MAKING
% MATCHING CHANGES TO THE TEMPO CODE!
param_list = {'Allowed_fix_time';...
    'Cancel_time';...
    'Curr_SSD';...
    'Curr_target';...
    'Exponential_holdtime';...
    'Failure_tone';...
    'Fix_win_size';...
    'Fixation_color_b';...
    'Fixation_color_g';...
    'Fixation_color_r';...
    'Fixation_size';...
    'Fixed_trial_length';...
    'Go_weight';...
    'Ignore_color_b';...
    'Ignore_color_g';...
    'Ignore_color_r';...
    'Ignore_weight';...
    'Inter_trial_interval';...
    'Max_holdtime';...
    'Max_saccade_duration';...
    'Max_saccade_time';...
    'Min_holdtime';...
    'N_SSDs';...
    'Punish_time';...
    'Reward_duration';...
    'Reward_offset';...
    'Staircase';...
    'Stop_color_b';...
    'Stop_color_g';...
    'Stop_color_r';...
    'Stop_weight';...
    'Success_tone';...
    'Targ_win_size';...
    'Target_angle';...
    'Target_color_b';...
    'Target_color_g';...
    'Target_color_r';...
    'Target_eccentricity';...
    'Target_hold_time';...
    'Target_size';...
    'Tone_duration';...
    'Trial_length';...
    'Trial_outcome';...
    'Trial_type';...
    'X_gain';...
    'X_offset';...
    'Y_gain';...
    'Y_offset';...
    'Curr_soa';...
    
    'preTargHoldtime';...
    'postTargHoldtime';...
    'targ1_checker_color_r';...
    'targ1_checker_color_g';...
    'targ1_checker_color_b';...
    'targ2_checker_color_r';...
    'targ2_checker_color_g';...
    'targ2_checker_color_b';...
    'chkr_win_size';...
    'nCheckerColumn';...
    'nCheckerRow';...
    'iSquareSizePixels';...
    'CheckerWidthDegrees';...
    'CheckerHeightDegrees';...
    'CheckerEccentricity';...
    'CheckerAngle';...
    'targetEccentricity';...
    'targetAngle';...
    'distractorEccentricity';...
    'distractorAngle';...
    'nDiscriminate';...
    'Targ1Proportion';...
    
    'go_checker_color_r';...
    'go_checker_color_g';...
    'go_checker_color_b';...
    'noGo_checker_color_r';...
    'noGo_checker_color_g';...
    'noGo_checker_color_b';...
    'goProportion'};

filePart = str2num(file(3:5));
% For Broca's files pre-bp050n, was not exporting checkerboardArray.
% Everything after that does export it.
if ~strncmp(file, 'bp', 2) || (strncmp(file, 'bp', 2) && filePart >= 50)
    param_list = [param_list; 'checkerboardArray'];
end
% Developed new tempo codes, added new INFOs output
if ~(strncmp(file, 'bp', 2) || strncmp(file, 'xp', 2)) ||...
        (strncmp(file, 'bp', 2) && filePart >= 61) ||...
        (strncmp(file, 'xp', 2) && filePart >= 53)
    param_list = [param_list; 'maskSize'; ...
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
cmanheader      = 1501;
memheader      = 1502;
chcmanheader      = 1503;
visheader      = 1504;
ampheader      = 1505;
gonogoheader      = 1506;
delayheader      = 1507;
maskbetheader      = 1508;
trialstart		= 1666;
eot 			= 1667;
fixate          = 2660;
fixspoton       = 2301;
fixspotoff		= 2300;
decide          = 2811;
mouthbegin  	= 2655;
mouthend 		= 2656;
abort 			= 2620;
correct 		= 2600;
reward          = 2727;
tone            = 2001;
saccade     	= 2810;

% trial parameters (not timed)
start_infos		= 2998;
end_infos		= 2999;
infos_zero		= 3000;


%--------------------------------------------------------------------------
% get all of the raw values out of the .plx file
fprintf('\nLoading events from %s ...\n',file)
[N_events, Time_stamps, Event_codes] = plx_event_ts([path,file],Strobe_channel);
% N_events
% Time_stamps
% Event_codes
fprintf('...done!\n\n')

% SHOULD MAKE SEPERATE TRANSLATION PROTOCOLS FOR DIFFERENT TASKS
% CAN GET WHICH TASK IT IS FROM HEADER.

%--------------------------------------------------------------------------
% get information and create the header
[OpenedFileName,...
    Version,...
    Freq,...
    Comment,...
    Trodalness,...
    NPW,...
    PreTresh,...
    SpikePeakV,...
    SpikeADResBits,...
    SlowPeakV,...
    SlowADResBits,...
    Duration,...
    Date_and_Time] = plx_information([path file]);

cell_date = regexp(Date_and_Time,'/','split');
day       = str2double(deblank(char(cell_date(2))));
month     = str2double(deblank(char(cell_date(1))));
cell_year = regexp(char(cell_date(3)),'\s','split');
year      = str2double(deblank(char(cell_year(1))));

Date_Number = datenum(year,month,day);

if Event_codes(Event_codes == cmanheader)
    taskID = 'Countermanding';
elseif Event_codes(Event_codes == chcmanheader)
    taskID = 'ChoiceCountermanding';
elseif Event_codes(Event_codes == gonogoheader)
    taskID = 'GoNoGo';
elseif Event_codes(Event_codes == memheader)
    taskID = 'Memory';
elseif Event_codes(Event_codes == delayheader)
    taskID = 'Delay';
elseif Event_codes(Event_codes == visheader)
    taskID = 'Visual';
elseif Event_codes(Event_codes == ampheader)
    taskID = 'Amplitude';
elseif Event_codes(Event_codes == maskbetheader)
    taskID = 'MaskBet';
end

ofile = [file(1:end-4),'.mat'];

Header_.Comment       = Comment;
Header_.Date_and_Time = Date_and_Time;
Header_.Date_Number   = Date_Number;
Header_.Duration      = Duration / 1000;
Header_.File_name     = ofile;
% Header_.Revision      = get_current_revision;
Header_.Revision      = 0;
Header_.Task          = taskID





%--------------------------------------------------------------------------
% get the time stamped events
fprintf('Sorting time stamps...\n')
TrialStart_     = round(1000 * Time_stamps(Event_codes == trialstart));


Eot_            = round(1000 * Time_stamps(Event_codes == eot));

% TrialStart_(1428) = [];
if length(Eot_) ~= length(TrialStart_)
    fprintf('ERROR: The number of start trial events does not equal the number...\n')
    fprintf('...of end trial events.\n')
    Error_{error_ct+1,1} = 'The number of start trial events does not equal the number of end trial events\n';
    error_ct = error_ct+1;
    fprintf('Attempting to truncate session after last full trial.\n');
    %     num_of_ends = length(Eot_);
    
    
    tsInd = find(diff(TrialStart_) > 70000)+1;
    if isempty(tsInd)
        TrialStart_(end) = [];
    else
        if length(TrialStart_) > length(Eot_)
            
            TrialStart_(tsInd - 1)  = [];
        elseif length(TrialStart_) < length(Eot_)
            Eot_(tsInd) = [];
        end
    end
    % ecInd = find(Event_codes == trialstart);
    % Event_codes(ecInd(tsInd)) = [];
end

% except for TrialStart_, all underscore variables are in trial time, not
% session time
Eot_ = Eot_ - TrialStart_;

% preallocate strobed event output
for ii = 1:length(event_list);
    curr_event = char(event_list(ii));
    eval(sprintf('%s(1:length(TrialStart_),1) = nan;',curr_event));
end

% assign time stamps to appropriate events
all_starts = find(Event_codes == trialstart);
all_ends   = find(Event_codes == eot);
curr_strobes(1:max(Eot_)) = 0; % preallocate
curr_tstamps(1:max(Eot_)) = 0; % preallocate
for trl_num = 1:length(TrialStart_);
    
    curr_start                  = all_starts(trl_num);
    curr_end                    = all_ends(trl_num);
    curr_length                 = length(Event_codes(curr_start:curr_end));
    curr_strobes(1:curr_length) = Event_codes(curr_start:curr_end);
    curr_tstamps(1:curr_length) = Time_stamps(curr_start:curr_end);
    
    %     [curr_strobes, curr_tstamps]
    for ii = 1:length(event_list);
        
        curr_event = char(event_list(ii));
        curr_event_code = char(event_num_list(ii));
        eval(sprintf('code_number = %s;',curr_event_code));
        %         char(event_num_list(ii))
        if sum(curr_strobes == code_number) == 1
            %             sum(curr_strobes == code_number)
            eval(sprintf('%s(trl_num) = round(1000 * curr_tstamps(curr_strobes == code_number));',curr_event));
        end
        
    end
    curr_strobes(:) = 0; %reset
end

% put time stamps into time relative to trial starts
for ii = 1:length(event_list);
    curr_event = char(event_list(ii));
    eval(sprintf('%s = %s - TrialStart_;',curr_event,curr_event));
end

fprintf('...done!\n\n')





%--------------------------------------------------------------------------
% get mouth events
% this has to be done seperately b/c there can be any number of mouth
% movement events per trial

% Get maximum values for preallocating mouth matrices
samples    = (diff(TrialStart_));
maxSamples = max(samples);
% According to EEE's documentation mouth movements may only be seperated by
% minimum of 500 ms.  I assume 250 just to be on the safe side.
maxSamples = ceil(maxSamples/250);
MouthBegin_(1:length(TrialStart_),1:maxSamples) = nan;
MouthEnd_(1:length(TrialStart_),1:maxSamples)   = nan;

mouth_starts_ts = round(Time_stamps(Event_codes == mouthbegin) * 1000);
mouth_ends_ts   = round(Time_stamps(Event_codes == mouthend) * 1000);

%NOTE motion detector in 028 lags movement by mean of 29 ms (std 5) under
%optimal conditions (so it is our best guess in all conditions)
mouth_starts_ts = mouth_starts_ts - 29;
mouth_ends_ts   = mouth_ends_ts - 29;

for trl = 1:(length(TrialStart_) - 1)
    
    thisTrialStart = TrialStart_(trl);
    nextTrialStart = TrialStart_(trl+1);
    
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
lastTrialStart  = TrialStart_(end);
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
% get photodiode triggered events
fprintf('Loading photodiode triggers from %s...\n',file)
[N_PDs, Time_stamps] = plx_event_ts([path,file],PD_channel);
fprintf('...done!\n\n');

Time_stamps = round(Time_stamps * 1000);

% Time_stamps(1:20,:)
% pause

photodiode(1:length(TrialStart_),1 : nPhotoDiodePossible) = 0; %can have up to 5 pd events per trial

for trl_num = 1:length(TrialStart_);
    
    curr_start = TrialStart_(trl_num);
    curr_end   = curr_start + Eot_(trl_num);
    curr_timestamps = Time_stamps(Time_stamps > curr_start &...
        Time_stamps < curr_end);
    photodiode(trl_num,1:length(curr_timestamps)) = curr_timestamps;
    
end
% photodiode(1:20,:)
% pause

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
% the code below is a bit complex.
% we have replaced all of the false alarm refresh flickers with nans.
% now the code below just "pushes" all of the nans to the right and gets
% them out of the the first 3 columns.
for column = 2 : nPhotoDiodePossible % there can only be maximum of 3 photodiode events on any given trial
    next_column = column + 1;
    curr_nans = find(isnan(photodiode(:,column)));
    while ~isempty(curr_nans)
        % photodiode(1:20,:)
        % pause
        photodiode(curr_nans,column) = photodiode(curr_nans,next_column);
        photodiode(curr_nans,next_column) = nan;
        next_column = next_column + 1;
        curr_nans = find(isnan(photodiode(:,column)));
        if column > 2 && sum(isnan(photodiode(:,column-1))) == 0
            if sum(photodiode(:,column-1)) == 0
                curr_nans = [];
            end
        end
    end
end

photodiode(photodiode == 0) = nan; % up to this point nans were used for flicker testing

switch taskID
    case 'Countermanding'
        FixSpotOn_  = photodiode(:,1) - TrialStart_;
        Target_     = photodiode(:,2) - TrialStart_;
        StopSignal_ = photodiode(:,3) - TrialStart_;
    case 'ChoiceCountermanding'
        FixSpotOn_  = photodiode(:,1) - TrialStart_;
        Target_     = photodiode(:,2) - TrialStart_;
        Choice_     = photodiode(:,3) - TrialStart_;
        StopSignal_ = photodiode(:,4) - TrialStart_;
    case 'GoNoGo'
        FixSpotOn_  = photodiode(:,1) - TrialStart_;
        Target_     = photodiode(:,2) - TrialStart_;
        Cue_        = photodiode(:,3) - TrialStart_;
    case 'Memory'
        FixSpotOn_  = photodiode(:,1) - TrialStart_;
        Target_     = photodiode(:,2) - TrialStart_;
        FixSpotOff_ = photodiode(:,3) - TrialStart_;
    case 'Delay'
        FixSpotOn_  = photodiode(:,1) - TrialStart_;
        Target_     = photodiode(:,2) - TrialStart_;
        FixSpotOff_ = photodiode(:,3) - TrialStart_;
    case 'Visual'
        FixSpotOn_  = photodiode(:,1) - TrialStart_;
        Target_     = photodiode(:,2) - TrialStart_;
    case 'MaskBet'
        FixSpotOn_  = photodiode(:,1) - TrialStart_;
        PD2     = photodiode(:,2) - TrialStart_;
        PD3     = photodiode(:,3) - TrialStart_;
        PD4     = photodiode(:,4) - TrialStart_;
        PD5     = photodiode(:,5) - TrialStart_;
end





%--------------------------------------------------------------------------
% get non timed trial parameters
Start_Infos_i =  Event_codes == start_infos;

%check for known errors
if sum(Start_Infos_i) ~= length(TrialStart_)
    fprintf('ERROR: The number of start Infos_ flags does not equal the number of trials.\n')
    fprintf('Infos_ may be inaccurate.\n')
    Error_{error_ct+1,1} = 'The number of start Infos_ flags does not equal the number of trials. Infos_ may be inaccurate.';
    error_ct = error_ct+1;
end

End_Infos_i = Event_codes == end_infos;

%check for known errors
if sum(End_Infos_i) ~= length(TrialStart_)
    fprintf('ERROR: The number of end Infos_ flags does not equal the number of trials.\n')
    fprintf('Infos_ may be inaccurate.\n')
    Error_{error_ct+1,1} = 'The number of end Infos_ flags does not equal the number of trials. Infos_ may be inaccurate.';
    error_ct = error_ct+1;
end

param_index = Start_Infos_i;
for param_num = 1:length(param_list)
    
    param_name = char(param_list(param_num));
    
    % If the variable of interest is the checkerboard pattern, use a loop
    if strcmp(param_name,'checkerboardArray') || strcmp(param_name,'targ1Targ1Array')
        param_values = [];
        for iIndex = 1 : 100
            param_index = logical([0; param_index(1:end-1)]);  %shift all logical bits one to the right
            param_values = [param_values, Event_codes(param_index)];
        end
        param_values = param_values - infos_zero;
    else
        param_index = logical([0; param_index(1:end-1)]);  %shift all logical bits one to the right
        
        param_values = Event_codes(param_index);
        
        %check for known errors
        if sum(param_values < 0) > 0
            fprintf('ERROR: Negative parameter values discovered in Infos_.\n')
            fprintf('The number of Infos_ strobes sent may not match the expectation.\n')
            Error_{error_ct+1,1} = 'Negative parameter values discovered in Infos_. The number of Infos_ strobes sent may not match the expectation.';
            error_ct = error_ct+1;
        end
        
        % tempo added a constant to all of these values to keep them seperate
        % from event codes.  we must subtract this now.
        param_values = param_values - infos_zero;
        
        % For some (really strange!) reason, some of the signal strength
        % values get altered during translation. fix that here based on
        % known historical inaccurate numbers:
        if strcmp(param_name,'Targ1Proportion')
            if strcmp(file(1:2), 'bp')
                param_values(param_values == 58) = 59;
            end
            if strcmp(file(1:2), 'xp')
                param_values(param_values == 52) = 53;
            end
        end
        
        
        % many values have been multiplied by 100 to allow for sending floats
        if strcmp(param_name,'Fix_win_size')             ||...
                strcmp(param_name,'Fixation_size')       ||...
                strcmp(param_name,'Go_weight')           ||...
                strcmp(param_name,'Ignore_weight')       ||...
                strcmp(param_name,'Stop_weight')         ||...
                strcmp(param_name,'Target_size')         ||...
                strcmp(param_name,'Targ_win_size')       ||...
                strcmp(param_name,'Target_eccentricity') ||...
                strcmp(param_name,'chkr_win_size')      ||...
                strcmp(param_name,'CheckerWidthDegrees') ||...
                strcmp(param_name,'CheckerHeightDegrees') ||...
                strcmp(param_name,'CheckerEccentricity') ||...
                strcmp(param_name,'targetEccentricity') ||...
                strcmp(param_name,'distractorEccentricity') ||...
                strcmp(param_name,'Targ1Proportion')       ||...
                strcmp(param_name,'goProportion')         ||...
                strcmp(param_name,'maskSize')         ||...
                strcmp(param_name,'betwinSize');
            param_values = param_values / 100;
        end
        
        % some values have been multiplied by 100 and added to 1000 to allow
        % for signed floats
        if strcmp(param_name,'X_gain')          ||...
                strcmp(param_name,'Y_gain')     ||...
                strcmp(param_name,'X_offset')   ||...
                strcmp(param_name,'Y_offset')
            param_values = param_values - 1000;
            param_values = param_values / 100;
            eval(sprintf('%s = nanmean(nonzeros(param_values));',param_name));
            eval(sprintf('%s(isnan(%s)) = 0;',param_name,param_name));
        end
    end % if strcmp(param_name,'targ1Targ2Array')
    eval(sprintf('Infos_.%s = param_values;',param_name));
    
end
param_index = logical([0; param_index(1:end-1)]);  %shift all logical bits one to the right
check4end = Event_codes(param_index);

%check for known errors
if length(unique(check4end)) ~= 1 ||...
        unique(check4end) ~= end_infos
    fprintf('ERROR: End Infos_ flags did not occur when expected on 1 or more trials.\n')
    fprintf('Infos_ may be inaccurate.\n')
    Error_{error_ct+1,1} = 'End Infos_ flags did not occur when expected on 1 or more trials. Infos_ may be inaccurate.';
    error_ct = error_ct+1;
end

% convert refresh rate to ms
Infos_.Curr_SSD = round(Infos_.Curr_SSD * (1000/Refresh_rate));

% some fields in Infos_ are better represented as cells with strings
temp_cell = cell(length(TrialStart_),1);
temp_cell(Infos_.Trial_outcome == 1) = {'noFixation'};
temp_cell(Infos_.Trial_outcome == 2) = {'fixationAbort'};
temp_cell(Infos_.Trial_outcome == 3) = {'goIncorrect'};
temp_cell(Infos_.Trial_outcome == 4) = {'stopCorrect'};
temp_cell(Infos_.Trial_outcome == 5) = {'sacadeAbort'};
temp_cell(Infos_.Trial_outcome == 6) = {'targetHoldAbort'};
temp_cell(Infos_.Trial_outcome == 7) = {'goCorrectTarget'};
temp_cell(Infos_.Trial_outcome == 8) = {'stopIncorrectTarget'};
temp_cell(Infos_.Trial_outcome == 9) = {'earlySaccade'};
temp_cell(Infos_.Trial_outcome == 10) = {'noSaccade'};  % for vgs, mgs, delay, etc.
temp_cell(Infos_.Trial_outcome == 11) = {'saccToTarget'};  % for vgs, mgs, delay, etc.
temp_cell(Infos_.Trial_outcome == 12) = {'bodyMove'};
temp_cell(Infos_.Trial_outcome == 13) = {'goCorrectDistractor'};
temp_cell(Infos_.Trial_outcome == 14) = {'stopIncorrectDistractor'};
temp_cell(Infos_.Trial_outcome == 15) = {'choiceStimulusAbort'};
temp_cell(Infos_.Trial_outcome == 16) = {'distractorHoldAbort'};
temp_cell(Infos_.Trial_outcome == 17) = {'saccToDistractor'};
temp_cell(Infos_.Trial_outcome == 18) = {'betFixationAbort'};
temp_cell(Infos_.Trial_outcome == 19) = {'betHoldAbort'};
temp_cell(Infos_.Trial_outcome == 20) = {'highBet'};
temp_cell(Infos_.Trial_outcome == 21) = {'lowBet'};
temp_cell(Infos_.Trial_outcome == 22) = {'targHighBet'};
temp_cell(Infos_.Trial_outcome == 23) = {'disHighBet'};
temp_cell(Infos_.Trial_outcome == 24) = {'targLowBet'};
temp_cell(Infos_.Trial_outcome == 25) = {'distLowBet'};
Infos_.Trial_outcome = temp_cell;


temp_cell(:) = {[]};
temp_cell(Infos_.Trial_type == 0) = {'GO'};
temp_cell(Infos_.Trial_type == 1) = {'STOP'};
temp_cell(Infos_.Trial_type == 2) = {'IGNORE'};
temp_cell(Infos_.Trial_type == 3) = {'NOGO'};
temp_cell(Infos_.Trial_type == 4) = {'MASK'};
temp_cell(Infos_.Trial_type == 5) = {'BET'};
temp_cell(Infos_.Trial_type == 6) = {'RETRO'};
temp_cell(Infos_.Trial_type == 7) = {'PRO'};
Infos_.Trial_type = temp_cell;

% add 1 to Curr_target so that it works better with MATLAB indices.
Infos_.Curr_target = Infos_.Curr_target + 1;



%
%
% %--------------------------------------------------------------------------
% % now that we have all of the events double check to see if the photodiode
% % trigger ever failed, and, if so, try to recover.
% no_pd_trials        = [];
% unexpected_pd_error = 0;
%
% correct_no_StopSig = unique([strmatch('GO',Infos_.Trial_type);... % these are the trials on which stop signals should not have been presented
%     strmatch('no fixation',   Infos_.Trial_outcome);...
%     strmatch('broke fixation',Infos_.Trial_outcome)]);
% stop_check(1:length(TrialStart_),1) = 1;
% stop_check(correct_no_StopSig)      = 0;
% stop_check                          = logical(stop_check);  % 1 if we were supposed to have a stop signal, 0 if we were NOT supposed to have one.
%
% if sum(isnan(FixSpotOn_) & ~isnan(FixSpotOn)) > 0 % if we were expecting a fixation pd event but we didn't get one
%     curr_no_pd_trials              = find(isnan(FixSpotOn_) & ~isnan(FixSpotOn));
%     FixSpotOn_(curr_no_pd_trials)  = FixSpotOn(curr_no_pd_trials);
%     test_cell = Infos_.Trial_outcome(curr_no_pd_trials); % what types of outcomes are associated with pd failure?
%     if length(strmatch('broke fixation',test_cell)) > length(test_cell) % if pd failure happened even though animal held fixation
%         unexpected_pd_error = 1;
%     end
%     no_pd_trials                   = [no_pd_trials;curr_no_pd_trials];
% end
%
% if sum(isnan(Target_) & ~isnan(FixSpotOff_)) > 0 % if we were expecting a target pd event but we didn't get one
%     curr_no_pd_trials              = find(isnan(Target_) & ~isnan(FixSpotOff_));
%     Target_(curr_no_pd_trials)     = FixSpotOff_(curr_no_pd_trials);
%     FixSpotOn_(curr_no_pd_trials)  = FixSpotOn(curr_no_pd_trials); % this is b/c we can't tell which pd event in sequence failed
%     test_cell = Infos_.Trial_outcome(curr_no_pd_trials); % what types of outcomes are associated with pd failure?
%     if length(strmatch('broke fixation',test_cell)) > length(test_cell) % if pd failure happened even though animal held fixation
%         unexpected_pd_error = 1;
%     end
%     no_pd_trials                   = [no_pd_trials;curr_no_pd_trials];
% end
%
% if sum(isnan(StopSignal_) & stop_check) > 0 % if we were expecting a stop signal pd event but we didn't get one
%     curr_no_pd_trials              = find(isnan(StopSignal_) & stop_check);
%     Target_(curr_no_pd_trials)     = FixSpotOff_(curr_no_pd_trials);  % this is b/c we can't tell which pd event in sequence failed
%     StopSignal_(curr_no_pd_trials) = Infos_.Curr_SSD(curr_no_pd_trials) + Target_(curr_no_pd_trials);
%     FixSpotOn_(curr_no_pd_trials)  = FixSpotOn(curr_no_pd_trials); % this is b/c we can't tell which pd event in sequence failed
%     test_cell = Infos_.Trial_outcome(curr_no_pd_trials); % what types of outcomes are associated with pd failure?
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
%     per_no_pd_trials = num2str(round(100*(length(no_pd_trials)/length(TrialStart_))));
%     fprintf('ERROR: Photodiode trigger was not recieved on %s trials (%s %%).\n',num_no_pd_trials,per_no_pd_trials)
%     fprintf('Subbing less accurate tempo timing in for photodiode timing.\n\n')
%     Error_{error_ct+1,1} = 'ERROR: Photodiode trigger was not recieved on unexpected trials. Subbing less accurate tempo timing in for photodiode timing';
%     error_ct = error_ct + 1;
% end
%




%--------------------------------------------------------------------------
% check for errors, and prepare output for export
if error_ct > 0
    fprintf('\n***WARNING*** 1 or more translation errors detected.  Review Error_ variable for details.\n\n');
end

underscores = who('*_');

% I don't know what variables may come out of the file since it may contain
% the Error_ variable, so just stick it all in a struct and output it that
% way.
for ii = 1:length(underscores)
    curr_var = char(underscores(ii));
    eval(sprintf('Events.%s = %s;',curr_var,curr_var))
end
