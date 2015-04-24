function [trialList] = ccm_trial_sequence(trialData, selectOpt)

%% TESTING

[trialData, S, E] = load_data('broca','bp174n02');

%%

% Get default options structure:
selectOpt = ccm_trial_selection;

selectOpt(1).outcome = {'goCorrectTarget'};
selectOpt(2).outcome = {'stopCorrect'};
selectOpt(3).outcome = {'goCorrectTarget'};


% % Required selectOpt structure fields:
%    selectOpt.outcome            = 'valid';
%    selectOpt.rightCheckerPct   = 'collapse';
%    selectOpt.ssd               = 'collapse';
%    selectOpt.targDir           = 'collapse';
%    selectOpt.responseDir       = 'collapse';

nTrial = length(selectOpt);
trialList = 1:nTrial;


for i = 1 : nTrial
    
    iTrialList = ccm_trial_selection(trialData, selectOpt(i));
    
    trialList = intersect(trialList, iTrialList-i+1);
end