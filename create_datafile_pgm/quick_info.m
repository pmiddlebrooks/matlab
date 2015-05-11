function quick_info(subjectID, sessionID)
%
% Quickly asses information from a sesssion.
% For now, output is only trial number (assessed as number of times monkey
% began a trial by fixating)

% Load the data
if strcmp(sessionID(end-3:end), '.mat')
   sessionID(end-3 : end) = [];
end

[fileName, localDataPath, localDataFile] = data_file_path(subjectID, sessionID, 'monkey');
fileName(end-2 : end) = 'plx';

% fileName = '/Volumes/SchallLab/data/Xena/Plexon/xp053n03.plx';

plx = readPLXFileC(fileName,'events');

% Which event do we want to count?
% eTrialstart		= 1666;
% eTrialEnd 			= 1667;
eFixate          = 2660;

eventTrack = eFixate;

strobedEventChannel = 17;


nTrial = sum(plx.EventChannels(strobedEventChannel).Values == eFixate);

fprintf('Trials: %d\n', nTrial)


