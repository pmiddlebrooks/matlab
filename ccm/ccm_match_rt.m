function data = ccm_match_rt(goRT, stopRT, nStopCorrect)

debug = 1;
testCode = 0;
if testCode
    %%
    Unit = ccm_single_neuron('Broca','bp093n02', 'plotFlag', 0);
    [trialData, SessionData, pSignalArray , ssdArray] = load_data('Broca', 'bp093n02');
    %%
    sigInd = 6;
    dataGoTarg    = ccm_concat_neural_conditions(Unit(1), 'checkerOn', 'responseOnset', {'goTarg'}, pSignalArray(sigInd), ssdArray);
    dataStopTarg    = ccm_concat_neural_conditions(Unit(1), 'checkerOn', 'responseOnset', {'stopTarg'}, pSignalArray(sigInd), ssdArray);
    dataStopStop    = ccm_concat_neural_conditions(Unit(1), 'checkerOn', 'checkerOn', {'stopCorrect'}, pSignalArray(sigInd), ssdArray);
    
    %%
    nStopCorrect = size(dataStopStop.raster, 1);
    
    goRT    = dataGoTarg.eventLatency;
    stopRT  = dataStopTarg.eventLatency;
end

nGo       = length(goRT);
nStopTarg = length(stopRT);

% Get a random sample of the go trials (and RTs) equal in length to the stop trials
% goTrial   = randperm(nGo);
% goTrialSample   = goTrial(1 : nStopTarg + nStopCorrect);
% goRTSample      = goRT(goTrialSample);
% goTrialSample   = goTrial;
goTrialSample   = 1:length(goRT);
goRTSample      = goRT;

%%
% Create grid of all possible go/stop RT pairs, and a matrix of the go
% trial number available
[goMeshRT, stopMeshRT]      = meshgrid(goRTSample, stopRT);
[goMeshTrial, stopMeshTrial] = meshgrid(goTrialSample, 1:nStopTarg);

% Take the difference between each possible pair to find the lowest
% difference (nearest-neighbor matched RTs)
[deltaRT, ind] = sort(abs(goMeshRT(:) - stopMeshRT(:)));

% Sort trials in in same order as sorted deltaRT
goMeshTrial     = goMeshTrial(ind);
stopMeshTrial   = stopMeshTrial(ind);
goMeshRT        = goMeshRT(ind);
stopMeshRT      = stopMeshRT(ind);

%%
% Loop through the trials with lowest matched RT differences, and build a
% list of those trials without repeats
goFastTrial    = nan(nStopTarg, 1);
stopMatchTrial  = nan(nStopTarg, 1);
goFastRT       = nan(nStopTarg, 1);
stopMatchRT     = nan(nStopTarg, 1);
i = 1;
matchInd = 1;
while sum(isnan(goFastTrial))
    if ~ismember(goMeshTrial(i), goFastTrial) && ~ismember(stopMeshTrial(i), stopMatchTrial)
        goFastTrial(matchInd)      = goMeshTrial(i);
        stopMatchTrial(matchInd)    = stopMeshTrial(i);
        goFastRT(matchInd)         = goMeshRT(i);
        stopMatchRT(matchInd)       = stopMeshRT(i);
        matchInd = matchInd + 1;
    end
    i = i + 1;
end
goSlowTrial = setdiff(unique(goMeshTrial), goFastTrial);
goSlowRT = goRT(goSlowTrial);

data.goFastTrial = goFastTrial;
data.goSlowTrial = goSlowTrial;
data.stopMatchTrial = stopMatchTrial;


