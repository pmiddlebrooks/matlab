%%

load('local_data/broca/brocaRT.mat')

% Fixation aborts only
fa = strcmp(monkeyB.outcome, 'fixationAbort');
prefa = [fa(2:end); false];
postfa = [false; fa(1:end-1)];
nanmean(monkeyB.rt(prefa))
nanmean(monkeyB.rt(postfa))

%%
% Any aborts
ab = strcmp(monkeyB.outcome, ('fixationAbort')) | ...
    strcmp(monkeyB.outcome, ('choiceStimulusAbort')) | ...
    strcmp(monkeyB.outcome, ('noFixation')) | ...
    strcmp(monkeyB.outcome, ('saccadeAbort')) | ...
    strcmp(monkeyB.outcome, ('targetHoldAbort')) | ...
    strcmp(monkeyB.outcome, ('distractorHoldAbort'));

prefa = [ab(2:end); false];
postfa = [false; ab(1:end-1)];
nanmean(monkeyB.rt(prefa))
nanmean(monkeyB.rt(postfa))

%% triplet analysis:
% Replicating Nelson et al 2010 and Emeric et al. 2007 for Choice
% countermanding data.
% These analyses can be done a few ways:
%
%   Include/exclude aborted trials: This will affect the number of paired
%   and triplet trials that make it into analyses, since aborts between
%   trials may or may not count as successive trials. (this seems not to
%   matter though: deleteAborts = true vs. false
%
%   Analyze data across sessions, taking the mean across sessions, or
%   analyze with all data collapsed (as if one big session). Also doesn't
%   alter the results much. acrossSession = true vs. false

% Keeping aborted trials in
% without respect to choice difficulty. As a first, dont' remove any aborted
% trials. This will greatly reduce the data, but is a more valid test


subjectArray = {'broca','xena'};
subjectArray = {'human'};
deleteAborts = false;
acrossSession = true;
if acrossSession == true
    figN = 1;
else
    figN = 2;
end

colorArray = {'b','r'};
figure(figN);
clf
hold all;


for i = 1 : length(subjectArray)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LOAD DATA AND SET VARIABLES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    iSubject = subjectArray{i};
    
    iFile = fullfile('local_data',iSubject,strcat(iSubject,'RT.mat'));
    
    % load('local_data/broca/brocaRT.mat')
    % load('local_data/xena/xenaRT.mat')
    % monkeyB = monkeyX;
    
    load(iFile)  % Loads trialData into workspace (and SessionData)
    
    if deleteAborts
        selectOpt = ccm_trial_selection;
        selectOpt.outcome = {...
            'goCorrectTarget', 'goCorrectDistractor', ...
            'stopCorrect', ...
            'targetHoldAbort', 'distractorHoldAbort', ...
            'stopIncorrectTarget', 'stopIncorrectDistractor'};
        validTrial = ccm_trial_selection(trialData, selectOpt);
        trialData = trialData(validTrial,:);
    end
    
    % Find session switch trials so we don't process them as if a new
    % session was a continuation of one big session
%     if strcmp(iSubject, 'human')
%         excludeTrialPair = find(diff(trialData.sessionTag) < 0);
%     else
%         excludeTrialPair = find(diff(trialData.trial) < 0);
%     end
%     excludeTrialTriplet = [excludeTrialPair; excludeTrialPair-1]; % Exclude last 2 trials of a session as possible beginning trials in triplets
    
    
    
    
    % Treat data differently if analyzing across sessions vs collapsed
    % sessions:
    % excludeTrialTriplet: Find session switch trials so we don't process them as if a new
    % session was a continuation of one big session
    if acrossSession
        nSession = max(trialData.sessionTag);
        excludeTrialTriplet = [];
    else
        nSession = 1;
        excludeTrialPair = find(diff(trialData.sessionTag) < 0);
     excludeTrialTriplet = [excludeTrialPair; excludeTrialPair-1]; % Exclude last 2 trials of a session as possible beginning trials in triplets
   end
    
    % Overall session RTs
    ns = nan(nSession, 1);
    
    % Pairs
    nsNs1 = nan(nSession, 1);
    nsNs2 = nan(nSession, 1);
    cNs1 = nan(nSession, 1);
    cNs2 = nan(nSession, 1);
    ncNs1 = nan(nSession, 1);
    ncNs2 = nan(nSession, 1);
    eNs1 = nan(nSession, 1);
    eNs2 = nan(nSession, 1);
    
    % Triplets
    nsCNs1 = nan(nSession, 1);
    nsCNs2 = nan(nSession, 1);
    nsNcNs1 = nan(nSession, 1);
    nsNcNs2 = nan(nSession, 1);
    nsNcNs3 = nan(nSession, 1);
    nsENs1 = nan(nSession, 1);
    nsENs2 = nan(nSession, 1);
    nsENs3 = nan(nSession, 1);
    nsNsNs1 = nan(nSession, 1);
    nsNsNs2 = nan(nSession, 1);
    nsNsNs3 = nan(nSession, 1);
    
    for j = 1 : nSession
        
     if acrossSession
        jTD = trialData(trialData.sessionTag == j, :);
    else
        jTD = trialData;
    end
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % PARSE DATA AND CALCULATE METRICS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        iSubject = subjectArray{i};
        % Total mean No-stop RT
        sOpt = ccm_trial_selection;
        sOpt.outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt.ssd = 'none';
        nsTrial = ccm_trial_selection(jTD, sOpt);
        ns(j) = nanmean(jTD.rt(nsTrial));
        
        % NS -> NS
        sOpt(1) = ccm_trial_selection;
        % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(1).outcome = {'goCorrectTarget'};
        sOpt(1).ssd = 'none';
        
        sOpt(2) = ccm_trial_selection;
        % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(2).outcome = {'goCorrectTarget'};
        sOpt(2).ssd = 'none';
        
        nsNsTrial = ccm_trial_sequence(jTD, sOpt);
        nsNsTrial = setxor(nsNsTrial, excludeTrialTriplet);
        disp('NoStop - NoStop')
        nsNs1(j) = nanmean(jTD.rt(nsNsTrial));
        nsNs2(j) = nanmean(jTD.rt(nsNsTrial + 1));
        [h,p,ci,stats] = ttest2(jTD.rt(nsNsTrial), jTD.rt(nsNsTrial+1));
        
        % C -> NS
        sOpt(1) = ccm_trial_selection;
        % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(1).outcome = {'stopCorrect'};
        sOpt(1).ssd = 'any';
        
        sOpt(2) = ccm_trial_selection;
        % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(2).outcome = {'goCorrectTarget'};
        sOpt(2).ssd = 'none';
        
        CNsTrial = ccm_trial_sequence(jTD, sOpt);
        CNsTrial = setxor(CNsTrial, excludeTrialTriplet);
        disp('Canceled - NoStop')
        cNs1(j) = nanmean(jTD.rt(CNsTrial));
        cNs2(j) = nanmean(jTD.rt(CNsTrial + 1));
        [h,p,ci,stats] = ttest2(jTD.rt(CNsTrial), jTD.rt(CNsTrial+1));
        
        % NC -> NS
        sOpt(1) = ccm_trial_selection;
        % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(1).outcome = {'stopIncorrectTarget','stopIncorrectDistractor','targetHoldAbort','distractorHoldAbort'};
        sOpt(1).ssd = 'any';
        
        sOpt(2) = ccm_trial_selection;
        % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(2).outcome = {'goCorrectTarget'};
        sOpt(2).ssd = 'none';
        
        ncNsTrial = ccm_trial_sequence(jTD, sOpt);
        ncNsTrial = setxor(ncNsTrial, excludeTrialTriplet);
        disp('Noncanceled - NoStop')
        ncNs1(j) = nanmean(jTD.rt(ncNsTrial));
        ncNs2(j) = nanmean(jTD.rt(ncNsTrial + 1));
        [h,p,ci,stats] = ttest2(jTD.rt(ncNsTrial), jTD.rt(ncNsTrial+1));
        
        % E -> NS
        sOpt(1) = ccm_trial_selection;
        % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(1).outcome = {'goCorrectDistractor'};
        sOpt(1).ssd = 'none';
        
        sOpt(2) = ccm_trial_selection;
        % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(2).outcome = {'goCorrectTarget'};
        sOpt(2).ssd = 'none';
        
        eNsTrial = ccm_trial_sequence(jTD, sOpt);
        eNsTrial = setxor(eNsTrial, excludeTrialTriplet);
        disp('Error - NoStop')
        eNs1(j) = nanmean(jTD.rt(eNsTrial));
        eNs2(j) = nanmean(jTD.rt(eNsTrial + 1));
        [h,p,ci,stats] = ttest2(jTD.rt(eNsTrial), jTD.rt(eNsTrial+1));
        
        
        
        
        
        
        % NS -> C -> NS
        sOpt(1) = ccm_trial_selection;
        % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(1).outcome = {'goCorrectTarget'};
        sOpt(1).ssd = 'none';
        
        sOpt(2) = ccm_trial_selection;
        sOpt(2).outcome = {'stopCorrect'};
        sOpt(2).ssd = 'any';
        
        sOpt(3) = ccm_trial_selection;
        % sOpt(3).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(3).outcome = {'goCorrectTarget'};
        sOpt(3).ssd = 'none';
        
        disp('NoStop - Canceled - NoStop')
        nsCNsTrial = ccm_trial_sequence(jTD, sOpt);
        nsCNsTrial = setxor(nsCNsTrial, excludeTrialTriplet);
        nsCNs1(j) = nanmean(jTD.rt(nsCNsTrial));
        nsCNs2(j) = nanmean(jTD.rt(nsCNsTrial + 2));
        [h,p,ci,stats] = ttest2(jTD.rt(nsCNsTrial), jTD.rt(nsCNsTrial+2));
        
        
        % NS -> NC -> NS
        sOpt(1) = ccm_trial_selection;
        % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(1).outcome = {'goCorrectTarget'};
        sOpt(1).ssd = 'none';
        
        sOpt(2) = ccm_trial_selection;
        sOpt(2).outcome = {'stopIncorrectTarget', 'stopIncorrectDistractor', 'targetHoldAbort', 'distractorHoldAbort'};
        sOpt(2).outcome = {'stopIncorrectTarget', 'targetHoldAbort'};
        sOpt(2).ssd = 'any';
        
        sOpt(3) = ccm_trial_selection;
        % sOpt(3).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        sOpt(3).outcome = {'goCorrectTarget'};
        sOpt(3).ssd = 'none';
        
        disp('NoStop - NonCanceled - NoStop')
        nsNcNsTrial = ccm_trial_sequence(jTD, sOpt);
        nsNcNsTrial = setxor(nsNcNsTrial, excludeTrialTriplet);
        nsNcNs1(j) = nanmean(jTD.rt(nsNcNsTrial));
        nsNcNs3(j) = nanmean(jTD.rt(nsNcNsTrial + 1));
        nsNcNs2(j) = nanmean(jTD.rt(nsNcNsTrial + 2));
        [h,p,ci,stats] = ttest2(jTD.rt(nsNcNsTrial), jTD.rt(nsNcNsTrial+2));
        
        
        % NS -> Error -> NS
        sOpt(1) = ccm_trial_selection;
        sOpt(1).outcome = {'goCorrectTarget'};
        sOpt(1).ssd = 'none';
        
        sOpt(2) = ccm_trial_selection;
        sOpt(2).outcome = {'goCorrectDistractor'};
        sOpt(2).ssd = 'none';
        
        sOpt(3) = ccm_trial_selection;
        sOpt(3).outcome = {'goCorrectTarget'};
        sOpt(3).ssd = 'none';
        
        disp('NoStop - Choice Error - NoStop')
        nsENsTrial = ccm_trial_sequence(jTD, sOpt);
        nsENsTrial = setxor(nsENsTrial, excludeTrialTriplet);
        nsENs1(j) = nanmean(jTD.rt(nsENsTrial));
        nsENs3(j) = nanmean(jTD.rt(nsENsTrial + 1));
        nsENs2(j) = nanmean(jTD.rt(nsENsTrial + 2));
        [h,p,ci,stats] = ttest2(jTD.rt(nsENsTrial), jTD.rt(nsENsTrial+2));
        
        
        % NS -> NS -> NS
        sOpt(1) = ccm_trial_selection;
        sOpt(1).outcome = {'goCorrectTarget'};
        sOpt(1).ssd = 'none';
        
        sOpt(2) = ccm_trial_selection;
        sOpt(2).outcome = {'goCorrectTarget'};
        sOpt(2).ssd = 'none';
        
        sOpt(3) = ccm_trial_selection;
        sOpt(3).outcome = {'goCorrectTarget'};
        sOpt(3).ssd = 'none';
        
        disp('NoStop - Choice Error - NoStop')
        nsNsNsTrial = ccm_trial_sequence(jTD, sOpt);
        nsNsNsTrial = setxor(nsNsNsTrial, excludeTrialTriplet);
        nsNsNs1(j) = nanmean(jTD.rt(nsNsNsTrial));
        nsNsNs3(j) = nanmean(jTD.rt(nsNsNsTrial + 1));
        nsNsNs2(j) = nanmean(jTD.rt(nsNsNsTrial + 2));
        [h,p,ci,stats] = ttest2(jTD.rt(nsNsNsTrial), jTD.rt(nsNsNsTrial+2));
        
        
        
    end % for j = 1 : nSession
    
        % Plot
        % ylim([250 350])
        plot([1 12], [nanmean(ns) nanmean(ns)], '--', 'color', colorArray{i})
        plot([1:4], [nanmean(nsNs2) nanmean(cNs2) nanmean(ncNs2) nanmean(eNs2)], '--o', 'color', colorArray{i})
        plot([5 6], [nanmean(nsCNs1) nanmean(nsCNs2)], '-o', 'color', colorArray{i})
        plot([7 7.5 8], [nanmean(nsNcNs1) nanmean(nsNcNs3) nanmean(nsNcNs2)], '-o', 'color', colorArray{i})
        plot([9 9.5 10], [nanmean(nsENs1) nanmean(nsENs3) nanmean(nsENs2)], '-o', 'color', colorArray{i})
        plot([11 11.5 12], [nanmean(nsNsNs1) nanmean(nsNsNs3) nanmean(nsNsNs2)], '-o', 'color', colorArray{i})
end
if strcmp(iSubject, 'human')
    ylim([550 750])
else
    ylim([200 350])
end
set(gca, 'xtick', [1 2 3 4 5 5.5 6 7 7.5 8 9 9.5 10 11 11.5 12])
set(gca, 'xticklabel', {'NS','C','NC','E','NS','C','NS','NS','NC','NS','NS','E','NS','NS','NS','NS'})
% legend({'Broca','Xena'})


