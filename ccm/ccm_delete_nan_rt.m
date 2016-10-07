function trialData = ccm_delete_nan_rt(trialData)
%
% Delete trials that are supposed to have RTs (valid saccades) but don't.

rtTrial = strcmp(trialData.trialOutcome, 'goCorrectTarget') | ...
    strcmp(trialData.trialOutcome, 'goCorrectDistractor') | ...
    strcmp(trialData.trialOutcome, 'stopCorrectTarget') | ...
    strcmp(trialData.trialOutcome, 'stopCorrectDistractor') | ...
    strcmp(trialData.trialOutcome, 'targetHoldAbort') | ...
    strcmp(trialData.trialOutcome, 'distractorHoldAbort');

trialData(rtTrial & isnan(trialData.rt),:) = [];

