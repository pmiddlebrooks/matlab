function plexon_translate_datafile(monkey, sessionID, brainArea)


if nargin < 3
    brainArea = nan;
end

plexonFile = [sessionID, '.plx'];
saveName = [sessionID, '_legacy'];
if regexp('broca', monkey, 'ignorecase')
        tebaDataPath = ['b:/'];
elseif regexp('xena', monkey, 'ignorecase')
        tebaDataPath = ['x:/'];
else
        disp('I think you typed the monkey name wrong: see lines 10-20 in plexon_translate_datafile.m')
        return
end

%__________________________________________________________________________
%STEP 1.  GET ALL OF THE UNDERSCORE VARIABLES.
%__________________________________________________________________________
[Events X_gain, X_offset, Y_gain, Y_offset] = plexon_events_translation(tebaDataPath, plexonFile);

% unpackage the events from the struct
underscores = fieldnames(Events);
for iVariable = 1:length(underscores)
    iVarName = char(underscores(iVariable));
    eval(sprintf('%s = Events.%s;', iVarName, iVarName))
end

% we will need the date to know what config to use later
Date_Number = Header_.Date_Number;

% save variables to disk
fprintf('Saving underscore variables to %s ...\n', saveName);
save([tebaDataPath, saveName, '.mat'],'*_') % underscore variables
fprintf('...done!\n\n')




%__________________________________________________________________________
%STEP 2.  SAVE ALL OF THE CONTINUOUS ANALOG DATA.
%__________________________________________________________________________

% get AD channels
for iChannel = 1:64
    [ADvalues ADname] = plexon_ADchannels_translation(tebaDataPath,...
        plexonFile,...
        iChannel,...
        X_gain,...
        Y_gain,...
        X_offset,...
        Y_offset,...
        Date_Number);
    
    if length(ADvalues) > 1
        eval(sprintf('%s = ADvalues;', ADname)) % name the channel appropriately
        fprintf('Saving %s to %s\n', ADname, saveName);
        save([tebaDataPath saveName], ADname, '-append') % save the channel to file
        if ~strcmp(ADname,'EyeX_') && ~strcmp(ADname,'EyeY_') % if we are not dealing with eye channels
            eval(sprintf('clear %s' ,ADname)); % clear channel from workspace to conserve memory
        end
    end  % if length
end % for iChannel

clear ADvalues %conserve memory



%__________________________________________________________________________
%STEP 3.  SAVE ALL OF THE DISCREET SPIKE TIME DATA.
%__________________________________________________________________________

% get spikes
unit_appends = {'i','a','b','c','d'};
for iChannel = 1:64
    for jUnit = 0:4
        jUnitAppend = char(unit_appends(jUnit+1));
        [n, jSpikeTime] = plx_ts([tebaDataPath, plexonFile], iChannel, jUnit);
        if length(jSpikeTime) > 1
            jSpikeTime = round(jSpikeTime * 1000);
                dspName = sprintf('DSP%s%s', num2str(iChannel, '%02i'), jUnitAppend); %figure out the channel name
            fprintf('Saving %s to %s\n', dspName, saveName);
            eval(sprintf('%s = jSpikeTime;', dspName)) % name the channel appropriately
            save([tebaDataPath saveName], dspName, '-append') % save the spikes to file
        end  % ~isempty
    end  % for jUnit
end  % for iChannel

% close plx file
plx_close([tebaDataPath, plexonFile]);



eyeSampleKHz = 1000;

[SaccBegin,...
    SaccEnd,...
    SaccAmplitude,...
    SaccDirection,...
    SaccVelocity,...
    SaccDuration,...
    SaccsNBlinks, ...
    Sacc_of_interest] = saccade_data(EyeX_,...
    EyeY_,...
    TrialStart_, ...
    Target_, ...
    Correct_, ...
    Eot_, ...
    Infos_.Fix_win_size, ...
    eyeSampleKHz);

% save variables to disk
fprintf('Saving behavioral variables to %s ...\n', saveName);
save([tebaDataPath saveName], 'Sacc*'     , '-append') % behavioral output
