function plexon_translate_datafile(monkey, sessionID)

tic
if nargin < 3
    brainArea = nan;
end

plexonFile = [sessionID, '.plx'];

if regexp('broca', monkey, 'ignorecase')
    monkeyDataPath = 'Broca/';
elseif regexp('xena', monkey, 'ignorecase')
    monkeyDataPath = 'Xena/Plexon/';
else
    disp('Wrong monkey name?')
    return
end
localDataPath = ['Z:\paulmiddlebrooks On My Mac\matlab\local_data\',lower(monkey),'\'];
tebaDataPath = ['t:/data/',monkeyDataPath];


% Create a dataset for trial informatio
trialData = dataset();
% Create a struct for session information
SessionData = struct();






%__________________________________________________________________________
%                           GET EVENTS
%__________________________________________________________________________
[trialData, SessionData, firstTrialStart, xGain, xOffest, yGain, yOffset] = ...
    plexon_events_translation(tebaDataPath, plexonFile, trialData, SessionData);

nTrial = size(trialData, 1);
taskID = SessionData.taskID;






%__________________________________________________________________________
%                   GET SPIKE TIME DATA.
%__________________________________________________________________________
% codeForSpikes = 0;
% if codeForSpikes
SessionData.spikeUnitArray = {};
spikeChannelArray = [];
nUnit = 1;
% Although online plexon allows only 4 units per channel, offline sorting
% allows more. Enable that possibility here:
unit_appends = {'a','b','c','d','e','f'};
for iChannel = 1:64
    addUnit = true;
    jUnit = 1;
    while addUnit
        jUnitAppend = char(unit_appends(jUnit));
        [n, jSpikeTime] = plx_ts([tebaDataPath, plexonFile], iChannel, jUnit);
        % If the channel/unit has spike data
        if length(jSpikeTime) > 1
            jSpikeTime = round(jSpikeTime * 1000);
            
            % Initialize an empty cell to add to trialData dataset
            iData = cell(nTrial, 1);
            for iTrial = 1 : nTrial
                if iTrial < nTrial
                    spikeRealTime            = jSpikeTime(jSpikeTime > firstTrialStart + trialData.trialOnset(iTrial) & jSpikeTime <= firstTrialStart + trialData.trialOnset(iTrial+1));
                elseif iTrial == nTrial
                    spikeRealTime            = jSpikeTime(jSpikeTime > firstTrialStart + trialData.trialOnset(iTrial) & jSpikeTime <= firstTrialStart + trialData.trialDuration(iTrial));
                end
                iData{iTrial} = spikeRealTime - (firstTrialStart + trialData.trialOnset(iTrial));
            end
            trialData.spikeData(:,nUnit) = iData;
            nUnit = nUnit + 1;
            
            unitName = sprintf('spikeUnit%s%s', num2str(iChannel, '%02i'), jUnitAppend); %figure out the channel name
            SessionData.spikeUnitArray = [SessionData.spikeUnitArray, unitName];
            jUnit = jUnit + 1;
        else
            addUnit = false;
        end  % ~isempty
    end  % while addUnit
end  % for iChannel
% end
% close plx file
plx_close([tebaDataPath, plexonFile]);





%__________________________________________________________________________
%                    GET CONTINUOUS ANALOG DATA.
%__________________________________________________________________________
% For now, always record EEGs on low number channels, and LFPs on higher
% channels (spikes for now also all on higher channels)
eegChannelArray = 1:16;
lfpChannelArray = 17:32;
SessionData.lfpChannel = [];
iEEG = 1;
iLFP = 1;
% get AD channels
for iChannel = 1:64
    % for iChannel = 62:64
    [ADvalues ADname] = plexon_ADchannels_translation(tebaDataPath,...
        plexonFile,...
        iChannel,...
        xGain,...
        yGain,...
        xOffest,...
        yOffset,...
        datenum(SessionData.date));
    
    if ~isempty(ADvalues)
        
        % Initialize an empty cell to add to trialData dataset
        iData = cell(nTrial, 1);
        for iTrial = 1 : nTrial
            %             if iTrial < nTrial - 1
            %                 iData{iTrial}            = ADvalues(trialData.trialOnset(iTrial+1) : trialData.trialOnset(iTrial+2));
            %             elseif iTrial == nTrial-1
            %                 iData{iTrial}            = ADvalues(trialData.trialOnset(iTrial+1) : trialData.trialOnset(iTrial+1) + trialData.trialDuration(iTrial+1));
            %             elseif iTrial == nTrial
            %                 iData{iTrial}            = [];
            %             end
            if iTrial < nTrial
                iData{iTrial}            = ADvalues(firstTrialStart + trialData.trialOnset(iTrial) : firstTrialStart + trialData.trialOnset(iTrial+1));
            elseif iTrial == nTrial
                iData{iTrial}            = ADvalues(firstTrialStart + trialData.trialOnset(iTrial) : firstTrialStart + trialData.trialOnset(iTrial) + trialData.trialDuration(iTrial));
            end
            
            
            
            %         if strncmp(ADname, 'eye', 3)
            %             ADname
            % iData
            % pause
            %         end
            %
            %              trialData.eegData(:,iEEG) = iData;
            %             iEEG = iEEG + 1;
            
        end
        if strncmp(ADname, 'eye', 3)
            % Eye position
            % ---------------------------------------------------------------
            trialData.(ADname) = iData;
            %             adData.(ADname) = ADvalues;
        elseif ismember(iChannel, eegChannelArray)
            trialData.eegData(:,iEEG) = iData;
            iEEG = iEEG + 1;
        elseif ismember(iChannel, lfpChannelArray)
            trialData.lfpData(:,iLFP) = iData;
            SessionData.lfpChannel = [SessionData.lfpChannel; iChannel];
            iLFP = iLFP + 1;
        end
    end
end
clear ADvalues %conserve memory















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
if ismember('responseOnset',td.Properties.VariableNames)
    trialData.rt = trialData.responseOnset - trialData.responseCueOn;
end



fprintf('Saving behavioral variables to %s ...\n', sessionID);
% Save a copy on teba
saveFileName = [tebaDataPath, sessionID];
save(saveFileName, 'trialData', 'SessionData')
% Make a local copy too
saveLocalName = [localDataPath, sessionID];
save(saveLocalName, 'trialData', 'SessionData')

toc
