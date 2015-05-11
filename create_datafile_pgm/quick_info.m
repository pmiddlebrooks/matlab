%%

fileName = '/Volumes/SchallLab/data/Xena/Plexon/xp053n01.plx';
plx = readPLXFileC(fileName,'events');

% Which event do we want to count?
% eTrialstart		= 1666;
% eTrialEnd 			= 1667;
eFixate          = 2660;

eventTrack = eFixate;

strobedEventChannel = 17;


nTrial = sum(plx.EventChannels(strobedEventChannel).Values == eFixate);


