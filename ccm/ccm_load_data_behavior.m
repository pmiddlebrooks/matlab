function [trialData, SessionData, ExtraVariable] = ccm_load_data_behavior(subjectID, sessionID)
% function [trialData, SessionData] = load_data_behavior(subjectID, sessionID)
%
% Loads a behavioral-only data file and does some minimal processing common to lots of
% analyses.
% If the behavioral version doesn't exist yet, this funciton creates and
% saves it locally
ExtraVariable = struct();

if ismember(lower(subjectID), {'joule', 'broca', 'xena', 'chase', 'hoagie', 'norm', 'andy', 'nebby', 'shuffles'})
    monkeyOrHuman = 'monkey';
else
    monkeyOrHuman = 'human';
end


% Load the data
if strcmp(sessionID(end-3:end), '.mat')
    sessionID(end-3 : end) = [];
end

% append session with "behavior" to search for behavioral-only data file
sessionBehavior = [sessionID, '_behavior'];
[dataFile, localDataPath, localDataFile] = data_file_path(subjectID, sessionBehavior, monkeyOrHuman);



% If the file hasn't already been created in a local directory, do it now
if exist(localDataFile, 'file') ~= 2
    
    [trialData, SessionData, ExtraVariable] = load_data(subjectID, sessionID);
    
    variables = trialData.Properties.VariableNames;
    removeVar = {'spikeData', 'lfpData', 'eegData'};
    
    % If it has pyshiology data, remove it and save the file locally
    physData = ismember(variables, removeVar);
    if sum(physData)
        trialData(:, physData) = [];
        save(localDataFile, 'trialData', 'SessionData','-v7.3')
        
    end
    
else
    load(localDataFile);
    % New method (3/18/14)
    trialData.ssd = ssd_session_adjust(trialData.ssd);
    ExtraVariable.ssdArray = unique(trialData.ssd(~isnan(trialData.ssd)));
end

if isa(trialData, 'dataset')
    trialData = dataset2table(trialData);
end


if isfield(SessionData, 'taskID')
    task = SessionData.taskID;
elseif isfield(SessionData.task, 'taskID')
    task = SessionData.task.taskID;
end


% Convert cells to doubles if necessary
if ~strcmp(task, 'maskbet')
    trialData = cell_to_mat(trialData);
    trialData.iTrial = (1 : size(trialData,1))';
end








if strcmp(task, 'ccm')
    %    trialData.Properties.VariableNames';
    pSignalArray = unique(trialData.targ1CheckerProp);
    pSignalArray(isnan(pSignalArray)) = [];
    ExtraVariable.pSignalArray = pSignalArray;
end





if ~strcmp(task, 'maskbet')
    trialData.rt = trialData.responseOnset - trialData.responseCueOn;
    
    if strcmp(task, 'ccm')
        % If there isn't a distractor angle variable, assume distractor is
        % 180 degrees from target
        if ~ismember('distAngle', trialData.Properties.VariableNames)
            trialData.distAngle = trialData.targAngle + 180;
        end
        angleMat = unique([trialData.targAngle trialData.distAngle], 'rows');
        ExtraVariable.targAngleArray = angleMat(:,1);
        ExtraVariable.distAngleArray = angleMat(:,2);
    else
        ExtraVariable.targAngleArray = unique(trialData.targAngle(~isnan(trialData.targAngle)));
    end
    
    % Want to get rid of trials that were mistakenly recored with targets at
    % the wrong angles (happens sometimes at the beginning of a task session
    % recording when the angles were set wrong). For now, sue the criteria that
    % a target must have at ewast 7 trials to considered legitimate
    lowNTarg = zeros(size(trialData, 1), 1);
    for i = 1 : length(ExtraVariable.targAngleArray)
        iTrial = trialData.targAngle == ExtraVariable.targAngleArray(i);
        if sum(iTrial) <= 7
            lowNTarg(iTrial) = 1;
        end
    end
    trialData(logical(lowNTarg),:) = [];
else
    %     trialData.decRT = trialData.decResponseOnset - trialData.decResponseCueOn;
    %     trialData.betRT = trialData.betResponseOnset - trialData.betResponseCueOn;
    ExtraVariable.soaArray = unique(trialData.soa(~isnan(trialData.soa)));
end