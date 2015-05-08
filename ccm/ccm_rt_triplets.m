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
% Keeping aborted trials in
% without respect to choice difficulty. As a first, dont' remove any aborted
% trials. This will greatly reduce the data, but is a more valid test

colorArray = {'b','r'};
figure(1);
clf
hold all;

subjectArray = {'broca','xena'};
subjectArray = {'human'};
deleteAborts = false;

for i = 1 : length(subjectArray)
    iSubject = subjectArray{i};
    
    iFile = fullfile('local_data',iSubject,strcat(iSubject,'RT.mat'));
    
    % load('local_data/broca/brocaRT.mat')
    % load('local_data/xena/xenaRT.mat')
    % monkeyB = monkeyX;
    
    load(iFile)
    
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
    if strcmp(iSubject, 'human')
        excludeTrialPair = find(diff(trialData.sessionTag) < 0);
    else
        excludeTrialPair = find(diff(trialData.trial) < 0);
    end
    excludeTrialTriplet = [excludeTrialPair; excludeTrialPair-1]; % Exclude last 2 trials of a session as possible beginning trials in triplets
    
    
    % Total mean No-stop RT
    sOpt = ccm_trial_selection;
    sOpt.outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    sOpt.ssd = 'none';
    nsTrial = ccm_trial_selection(trialData, sOpt);
    ns = nanmean(trialData.rt(nsTrial));
    
    % NS -> NS
    sOpt(1) = ccm_trial_selection;
    % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    sOpt(1).outcome = {'goCorrectTarget'};
    sOpt(1).ssd = 'none';
    
    sOpt(2) = ccm_trial_selection;
    % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    sOpt(2).outcome = {'goCorrectTarget'};
    sOpt(2).ssd = 'none';
    
    nsNsTrial = ccm_trial_sequence(trialData, sOpt);
    nsNsTrial = setxor(nsNsTrial, excludeTrialPair);
    disp('NoStop - NoStop')
    nsNs1 = nanmean(trialData.rt(nsNsTrial));
    nsNs2 = nanmean(trialData.rt(nsNsTrial + 1));
    [h,p,ci,stats] = ttest2(trialData.rt(nsNsTrial), trialData.rt(nsNsTrial+1));
    
    % C -> NS
    sOpt(1) = ccm_trial_selection;
    % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    sOpt(1).outcome = {'stopCorrect'};
    sOpt(1).ssd = 'any';
    
    sOpt(2) = ccm_trial_selection;
    % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    sOpt(2).outcome = {'goCorrectTarget'};
    sOpt(2).ssd = 'none';
    
    CNsTrial = ccm_trial_sequence(trialData, sOpt);
    CNsTrial = setxor(CNsTrial, excludeTrialPair);
    disp('Canceled - NoStop')
    cNs1 = nanmean(trialData.rt(CNsTrial));
    cNs2 = nanmean(trialData.rt(CNsTrial + 1));
    [h,p,ci,stats] = ttest2(trialData.rt(CNsTrial), trialData.rt(CNsTrial+1));
    
    % NC -> NS
    sOpt(1) = ccm_trial_selection;
    % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    sOpt(1).outcome = {'stopIncorrectTarget','stopIncorrectDistractor','targetHoldAbort','distractorHoldAbort'};
    sOpt(1).ssd = 'any';
    
    sOpt(2) = ccm_trial_selection;
    % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    sOpt(2).outcome = {'goCorrectTarget'};
    sOpt(2).ssd = 'none';
    
    ncNsTrial = ccm_trial_sequence(trialData, sOpt);
    ncNsTrial = setxor(ncNsTrial, excludeTrialPair);
    disp('Noncanceled - NoStop')
    ncNs1 = nanmean(trialData.rt(ncNsTrial));
    ncNs2 = nanmean(trialData.rt(ncNsTrial + 1));
    [h,p,ci,stats] = ttest2(trialData.rt(ncNsTrial), trialData.rt(ncNsTrial+1));
    
    % E -> NS
    sOpt(1) = ccm_trial_selection;
    % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    sOpt(1).outcome = {'goCorrectDistractor'};
    sOpt(1).ssd = 'none';
    
    sOpt(2) = ccm_trial_selection;
    % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    sOpt(2).outcome = {'goCorrectTarget'};
    sOpt(2).ssd = 'none';
    
    eNsTrial = ccm_trial_sequence(trialData, sOpt);
    eNsTrial = setxor(eNsTrial, excludeTrialPair);
    disp('Error - NoStop')
    eNs1 = nanmean(trialData.rt(eNsTrial))
    eNs2 = nanmean(trialData.rt(eNsTrial + 1))
    [h,p,ci,stats] = ttest2(trialData.rt(eNsTrial), trialData.rt(eNsTrial+1));
    
    
    
    
    
    
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
    nsCNsTrial = ccm_trial_sequence(trialData, sOpt);
    nsCNsTrial = setxor(nsCNsTrial, excludeTrialTriplet);
    nsCNs1 = nanmean(trialData.rt(nsCNsTrial));
    nsCNs2 = nanmean(trialData.rt(nsCNsTrial + 2));
    [h,p,ci,stats] = ttest2(trialData.rt(nsCNsTrial), trialData.rt(nsCNsTrial+2));
    
    
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
    nsNcNsTrial = ccm_trial_sequence(trialData, sOpt);
    nsNcNsTrial = setxor(nsNcNsTrial, excludeTrialTriplet);
    nsNcNs1 = nanmean(trialData.rt(nsNcNsTrial));
    nsNcNs3 = nanmean(trialData.rt(nsNcNsTrial + 1));
    nsNcNs2 = nanmean(trialData.rt(nsNcNsTrial + 2));
    [h,p,ci,stats] = ttest2(trialData.rt(nsNcNsTrial), trialData.rt(nsNcNsTrial+2));
    
    
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
    nsENsTrial = ccm_trial_sequence(trialData, sOpt);
    nsENsTrial = setxor(nsENsTrial, excludeTrialTriplet);
    nsENs1 = nanmean(trialData.rt(nsENsTrial));
    nsENs3 = nanmean(trialData.rt(nsENsTrial + 1));
    nsENs2 = nanmean(trialData.rt(nsENsTrial + 2));
    [h,p,ci,stats] = ttest2(trialData.rt(nsENsTrial), trialData.rt(nsENsTrial+2));
    
    
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
    nsNsNsTrial = ccm_trial_sequence(trialData, sOpt);
    nsNsNsTrial = setxor(nsNsNsTrial, excludeTrialTriplet);
    nsNsNs1 = nanmean(trialData.rt(nsNsNsTrial));
    nsNsNs3 = nanmean(trialData.rt(nsNsNsTrial + 1));
    nsNsNs2 = nanmean(trialData.rt(nsNsNsTrial + 2));
    [h,p,ci,stats] = ttest2(trialData.rt(nsNsNsTrial), trialData.rt(nsNsNsTrial+2));
    
    
    % Plot
    % ylim([250 350])
    plot([1 12], [ns ns], '--', 'color', colorArray{i})
    plot([1:4], [nsNs2 cNs2 ncNs2 eNs2], '-o', 'color', colorArray{i})
    plot([5 6], [nsCNs1 nsCNs2], '-o', 'color', colorArray{i})
    plot([7 7.5 8], [nsNcNs1 nsNcNs3 nsNcNs2], '-o', 'color', colorArray{i})
    plot([9 9.5 10], [nsENs1 nsENs3 nsENs2], '-o', 'color', colorArray{i})
    plot([11 11.5 12], [nsNsNs1 nsNsNs3 nsNsNs2], '-o', 'color', colorArray{i})
end
if strcmp(iSubject, 'human')
    ylim([550 750])
else
ylim([200 350])
end
set(gca, 'xtick', [1 2 3 4 5 5.5 6 7 7.5 8 9 9.5 10 11 11.5 12])
set(gca, 'xticklabel', {'NS','C','NC','E','NS','C','NS','NS','NC','NS','NS','E','NS','NS','NS','NS'})
% legend({'Broca','Xena'})



% %% triplet analysis:
% % Keeping aborted trials in
% % without respect to choice difficulty. As a first, dont' remove any aborted
% % trials. This will greatly reduce the data, but is a more valid test
%
% colorArray = {'b','r'};
% figure(1);
% clf
% hold all;
%
% monkeyArray = {'human'};
% deleteAborts = false;
%
% for i = 1
%     iSubject = monkeyArray{i};
%
%     iFile = fullfile('local_data',iSubject,strcat(iSubject,'RT.mat'));
%
%     % load('local_data/broca/brocaRT.mat')
%     % load('local_data/xena/xenaRT.mat')
%     % monkeyB = monkeyX;
%
%     load(iFile)
%
%     if deleteAborts
%         selectOpt = ccm_trial_selection;
%         selectOpt.outcome = {...
%             'goCorrectTarget', 'goCorrectDistractor', ...
%             'stopCorrect', ...
%             'targetHoldAbort', 'distractorHoldAbort', ...
%             'stopIncorrectTarget', 'stopIncorrectDistractor'};
%         validTrial = ccm_trial_selection(trialData, selectOpt);
%         trialData = trialData(validTrial,:);
%     end
%
%     % Total mean No-stop RT
%     sOpt = ccm_trial_selection;
%     sOpt.outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt.ssd = 'none';
%     nsTrial = ccm_trial_selection(trialData, sOpt);
%     ns = nanmean(trialData.rt(nsTrial));
%
%     % NS -> NS
%     sOpt(1) = ccm_trial_selection;
%     % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(1).outcome = {'goCorrectTarget'};
%     sOpt(1).ssd = 'none';
%
%     sOpt(2) = ccm_trial_selection;
%     % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(2).outcome = {'goCorrectTarget'};
%     sOpt(2).ssd = 'none';
%
%     nsNsTrial = ccm_trial_sequence(trialData, sOpt);
%     disp('NoStop - NoStop')
%     nsNs1 = nanmean(trialData.rt(nsNsTrial));
%     nsNs2 = nanmean(trialData.rt(nsNsTrial + 1));
%     [h,p,ci,stats] = ttest2(trialData.rt(nsNsTrial), trialData.rt(nsNsTrial+1));
%
%    % C -> NS
%     sOpt(1) = ccm_trial_selection;
%     % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(1).outcome = {'stopCorrect'};
%     sOpt(1).ssd = 'any';
%
%     sOpt(2) = ccm_trial_selection;
%     % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(2).outcome = {'goCorrectTarget'};
%     sOpt(2).ssd = 'none';
%
%     CNsTrial = ccm_trial_sequence(trialData, sOpt);
%     disp('Canceled - NoStop')
%     cNs1 = nanmean(trialData.rt(CNsTrial));
%     cNs2 = nanmean(trialData.rt(CNsTrial + 1));
%     [h,p,ci,stats] = ttest2(trialData.rt(CNsTrial), trialData.rt(CNsTrial+1));
%
%    % NC -> NS
%     sOpt(1) = ccm_trial_selection;
%     % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(1).outcome = {'stopIncorrectTarget','stopIncorrectDistractor','targetHoldAbort','distractorHoldAbort'};
%     sOpt(1).ssd = 'any';
%
%     sOpt(2) = ccm_trial_selection;
%     % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(2).outcome = {'goCorrectTarget'};
%     sOpt(2).ssd = 'none';
%
%     ncNsTrial = ccm_trial_sequence(trialData, sOpt);
%     disp('Noncanceled - NoStop')
%     ncNs1 = nanmean(trialData.rt(ncNsTrial));
%     ncNs2 = nanmean(trialData.rt(ncNsTrial + 1));
%     [h,p,ci,stats] = ttest2(trialData.rt(ncNsTrial), trialData.rt(ncNsTrial+1));
%
%    % E -> NS
%     sOpt(1) = ccm_trial_selection;
%     % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(1).outcome = {'goCorrectDistractor'};
%     sOpt(1).ssd = 'none';
%
%     sOpt(2) = ccm_trial_selection;
%     % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(2).outcome = {'goCorrectTarget'};
%     sOpt(2).ssd = 'none';
%
%     eNsTrial = ccm_trial_sequence(trialData, sOpt);
%     disp('Error - NoStop')
%     eNs1 = nanmean(trialData.rt(eNsTrial))
%     eNs2 = nanmean(trialData.rt(eNsTrial + 1))
%     [h,p,ci,stats] = ttest2(trialData.rt(eNsTrial), trialData.rt(eNsTrial+1));
%
%
%
%
%
%
%     % NS -> C -> NS
%     sOpt(1) = ccm_trial_selection;
%     % sOpt(2).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(1).outcome = {'goCorrectTarget'};
%     sOpt(1).ssd = 'none';
%
%     sOpt(2) = ccm_trial_selection;
%     sOpt(2).outcome = {'stopCorrect'};
%     sOpt(2).ssd = 'any';
%
%     sOpt(3) = ccm_trial_selection;
%     % sOpt(3).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(3).outcome = {'goCorrectTarget'};
%     sOpt(3).ssd = 'none';
%
%     disp('NoStop - Canceled - NoStop')
%     nsCNsTrial = ccm_trial_sequence(trialData, sOpt);
%     nsCNs1 = nanmean(trialData.rt(nsCNsTrial));
%     nsCNs2 = nanmean(trialData.rt(nsCNsTrial + 2));
%     [h,p,ci,stats] = ttest2(trialData.rt(nsCNsTrial), trialData.rt(nsCNsTrial+2));
%
%     % NS -> NC -> NS
%     sOpt(1) = ccm_trial_selection;
%     % sOpt(1).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(1).outcome = {'goCorrectTarget'};
%     sOpt(1).ssd = 'none';
%
%     sOpt(2) = ccm_trial_selection;
%     sOpt(2).outcome = {'stopIncorrectTarget', 'stopIncorrectDistractor', 'targetHoldAbort', 'distractorHoldAbort'};
%     sOpt(2).outcome = {'stopIncorrectTarget', 'targetHoldAbort'};
%     sOpt(2).ssd = 'any';
%
%     sOpt(3) = ccm_trial_selection;
%     % sOpt(3).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
%     sOpt(3).outcome = {'goCorrectTarget'};
%     sOpt(3).ssd = 'none';
%
%     disp('NoStop - NonCanceled - NoStop')
%     nsNcNsTrial = ccm_trial_sequence(trialData, sOpt);
%     nsNcNs1 = nanmean(trialData.rt(nsNcNsTrial));
%     nsNcNs3 = nanmean(trialData.rt(nsNcNsTrial + 1));
%     nsNcNs2 = nanmean(trialData.rt(nsNcNsTrial + 2));
%     [h,p,ci,stats] = ttest2(trialData.rt(nsNcNsTrial), trialData.rt(nsNcNsTrial+2));
%
%     % NS -> Error -> NS
%     sOpt(1) = ccm_trial_selection;
%     sOpt(1).outcome = {'goCorrectTarget'};
%     sOpt(1).ssd = 'none';
%
%     sOpt(2) = ccm_trial_selection;
%     sOpt(2).outcome = {'goCorrectDistractor'};
%     sOpt(2).ssd = 'none';
%
%     sOpt(3) = ccm_trial_selection;
%     sOpt(3).outcome = {'goCorrectTarget'};
%     sOpt(3).ssd = 'none';
%
%     disp('NoStop - Choice Error - NoStop')
%     nsENsTrial = ccm_trial_sequence(trialData, sOpt);
%     nsENs1 = nanmean(trialData.rt(nsENsTrial));
%     nsENs3 = nanmean(trialData.rt(nsENsTrial + 1));
%     nsENs2 = nanmean(trialData.rt(nsENsTrial + 2));
%     [h,p,ci,stats] = ttest2(trialData.rt(nsENsTrial), trialData.rt(nsENsTrial+2));
%
%     % NS -> NS -> NS
%     sOpt(1) = ccm_trial_selection;
%     sOpt(1).outcome = {'goCorrectTarget'};
%     sOpt(1).ssd = 'none';
%
%     sOpt(2) = ccm_trial_selection;
%     sOpt(2).outcome = {'goCorrectTarget'};
%     sOpt(2).ssd = 'none';
%
%     sOpt(3) = ccm_trial_selection;
%     sOpt(3).outcome = {'goCorrectTarget'};
%     sOpt(3).ssd = 'none';
%
%     disp('NoStop - Choice Error - NoStop')
%     nsNsNsTrial = ccm_trial_sequence(trialData, sOpt);
%     nsNsNs1 = nanmean(trialData.rt(nsNsNsTrial));
%     nsNsNs3 = nanmean(trialData.rt(nsNsNsTrial + 1));
%     nsNsNs2 = nanmean(trialData.rt(nsNsNsTrial + 2));
%     [h,p,ci,stats] = ttest2(trialData.rt(nsNsNsTrial), trialData.rt(nsNsNsTrial+2));
%
%
%     % Plot
%     % ylim([250 350])
%     plot([1 12], [ns ns], '--', 'color', colorArray{i})
%     plot([1:4], [nsNs2 cNs2 ncNs2 eNs2], '-o', 'color', colorArray{i})
%     plot([5 6], [nsCNs1 nsCNs2], '-o', 'color', colorArray{i})
%     plot([7 7.5 8], [nsNcNs1 nsNcNs3 nsNcNs2], '-o', 'color', colorArray{i})
%     plot([9 9.5 10], [nsENs1 nsENs3 nsENs2], '-o', 'color', colorArray{i})
%     plot([11 11.5 12], [nsNsNs1 nsNsNs3 nsNsNs2], '-o', 'color', colorArray{i})
% end
% ylim([550 750])
% set(gca, 'xtick', [1 2 3 4 5 5.5 6 7 7.5 8 9 9.5 10 11 11.5 12])
% set(gca, 'xticklabel', {'NS','C','NC','E','NS','C','NS','NS','NC','NS','NS','E','NS','NS','NS','NS'})
% legend({'Broca','Xena'})
