function concatenate_human_sessions(sessionID, concatID, eyeOrKey)

% dataFolder = 'data/';
humanDataPath = '/Volumes/middlepg/HumanData/ChoiceStopTask/';

% humanDataPath = '~/matlab/';
switch eyeOrKey
    case 'eye'
        effectorTag = 'em';
        effector = 'saccade';
        %         effector = 'saccadeMod';
    case 'key'
        effectorTag = 'kp';
        effector = 'keypress';
end
[tebDataFile, localDataPath, localDataFile] = data_file_path(sessionID(1:2), [sessionID(3:end), effector]);

% Load single session data
sessionDataFile = [humanDataPath, sessionID, effector, '.mat'];
load(sessionDataFile);
clear SessionData
SessionData.taskID = 'ccm';

concatData = dataset(...
    {trialData.trialOutcome, 'trialOutcome'}, ...
    {trialData.responseOnset, 'responseOnset'},...
    {trialData.targ1CheckerProp, 'targ1CheckerProp'},...
    {trialData.stopSignalOn, 'stopSignalOn'},...
    {trialData.targAngle, 'targAngle'},...
    {trialData.saccAngle, 'saccAngle'},...
    {trialData.responseCueOn, 'responseCueOn'});

% If this is the first file we're adding to a concatenated file (within a single subject), just use
% the sessionID data
if isempty(concatID)
    concatID = [sessionID(1:2), 'All'];
    concatDataFile = [humanDataPath, concatID, effector, '.mat'];
    %     concatDataFile = [humanDataPath, concatID, 'saccade', '.mat'];
    sessionIDArray = {[sessionID, effector]};
    trialData = concatData;
    % Otherwise add the sessionID data to the concatenated file
    save(concatDataFile, 'trialData', 'SessionData', 'sessionIDArray')
else
    if strcmp(concatID, 'hu')
        % If it's the first across-subjects concatenation
        concatDataFile = [humanDataPath, concatID, 'All', effector, '.mat'];
        
        trialData = concatData;
        sessionIDArray = [sessionID, effector];
        save(concatDataFile, 'trialData', 'SessionData', 'sessionIDArray')
        
    else
        
        % Load concatenated data
        concatDataFile = [humanDataPath, concatID, effector, '.mat'];
        load(concatDataFile)
        
        trialData = [trialData; concatData];
        sessionIDArray = [sessionIDArray; [sessionID, effector]];
        save(concatDataFile, 'trialData', 'SessionData', 'sessionIDArray', '-append')
    end
end


copyfile(concatDataFile, localDataPath)