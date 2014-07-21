function taskID = get_taskID(monkey, sessionID)


switch monkey
    case 'broca'
        monkeyFolderName = 'Broca';
    otherwise
        disp('Don''t have a path yet for that monkey')
end

% dataPath = get_monkey_dataPath(monkey);
tebaDataPath = ['/Volumes/SchallLab/data/', monkeyFolderName, '/'];
dataFile = [tebaDataPath, sessionID];

load(dataFile, 'sessionData');

taskID = SessionData.taskID;
