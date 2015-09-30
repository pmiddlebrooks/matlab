

%% Session-long RTs
figureHandle = 66;   
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(1, 1, figureHandle);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DATA AND SET VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iSubject = 'broca';
[sessionArray, subjectIDArray] = task_session_array(iSubject, 'ccm', 'behavior2');
for i = 1 : length(sessionArray)
    sessionID = sessionArray{i};
    
    [td, S] = load_data(iSubject,sessionID);
    [allRT, rtOutlierTrial] = truncate_rt(td.rt, 120, 1200, 3);

             clf
    ax = axes('units', 'centimeters', 'position', [xAxesPosition(1) yAxesPosition(1) axisWidth axisHeight]);
    plot(ax, allRT, '-k')
    xlim([1 length(allRT)])
    ylim([min(allRT)-20 max(allRT)+20])
    
    savePlot = 'y';
%     input('save?', 's');
    if strcmp(savePlot, 'y')
        localFigurePath = local_figure_path;
        print(figureHandle,[localFigurePath, sprintf('session_rts_%s', sessionID)],'-dpdf', '-r300')
    end
             

    
end
%%

load('local_data/broca/brocaRT.mat')

% Fixation aborts only
fa = strcmp(trialData.trialOutcome, 'fixationAbort');
prefa = [fa(2:end); false];
postfa = [false; fa(1:end-1)];
nanmean(trialData.rt(prefa))
nanmean(trialData.rt(postfa))

%%
% Any aborts
ab = strcmp(trialData.trialOutcome, ('fixationAbort')) | ...
    strcmp(trialData.trialOutcome, ('choiceStimulusAbort')) | ...
    strcmp(trialData.trialOutcome, ('noFixation')) | ...
    strcmp(trialData.trialOutcome, ('saccadeAbort')) | ...
    strcmp(trialData.trialOutcome, ('targetHoldAbort')) | ...
    strcmp(trialData.trialOutcome, ('distractorHoldAbort'));

prefa = [ab(2:end); false];
postfa = [false; ab(1:end-1)];
nanmean(trialData.rt(prefa))
nanmean(trialData.rt(postfa))

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
% subjectArray = {'broca'};
% subjectArray = {'human'};
colorArray = {'b','r'};
deleteAborts = false;
acrossSession = true;
if acrossSession == true
    figN = 1;
else
    figN = 2;
end

figureHandle = 66;   
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(1, 1, figureHandle);
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
    % trialData = monkeyX;
    
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
    
    % Initialize vectors for per-session RT means
    % Overall session RTs
    rtNs          = nan(nSession, 1);
    
    % Pairs
    rtNsNs1     = nan(nSession, 1);
    rtNsNs2     = nan(nSession, 1);
    rtCNs1      = nan(nSession, 1);
    rtCNs2      = nan(nSession, 1);
    rtNcNs1     = nan(nSession, 1);
    rtNcNs2     = nan(nSession, 1);
    rtENs1      = nan(nSession, 1);
    rtENs2      = nan(nSession, 1);
    
    % Triplets: no-stop correct choices -> various outcomes -> no-stop correct choices
    nNsCNs      = nan(nSession, 1);
    rtNsCNs1    = nan(nSession, 1);
    rtNsCNs3    = nan(nSession, 1);
    nNsNcNs     = nan(nSession, 1);
    rtNsNcNs1   = nan(nSession, 1);
    rtNsNcNs2   = nan(nSession, 1);
    rtNsNcNs3   = nan(nSession, 1);
    nNsENs      = nan(nSession, 1);
    rtNsENs1    = nan(nSession, 1);
    rtNsENs2    = nan(nSession, 1);
    rtNsENs3    = nan(nSession, 1);
    nNsNsNs     = nan(nSession, 1);
    rtNsNsNs1   = nan(nSession, 1);
    rtNsNsNs2   = nan(nSession, 1);
    rtNsNsNs3   = nan(nSession, 1);
    
    nNsCNse      = nan(nSession, 1);
    rtNsCNse1    = nan(nSession, 1);
    rtNsCNse3    = nan(nSession, 1);
    nNsNcNse     = nan(nSession, 1);
    rtNsNcNse1   = nan(nSession, 1);
    rtNsNcNse2   = nan(nSession, 1);
    rtNsNcNse3   = nan(nSession, 1);
    nNsENse      = nan(nSession, 1);
    rtNsENse1    = nan(nSession, 1);
    rtNsENse2    = nan(nSession, 1);
    rtNsENse3    = nan(nSession, 1);
    nNsNsNse     = nan(nSession, 1);
    rtNsNsNse1   = nan(nSession, 1);
    rtNsNsNse2   = nan(nSession, 1);
    rtNsNsNse3   = nan(nSession, 1);
    
    for j = 1 : nSession
        
        if acrossSession
            jTD = trialData(trialData.sessionTag == j, :);
        else
            jTD = trialData;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %      PARSE DATA AND CALCULATE METRICS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        iSubject = subjectArray{i};
        % Total mean No-stop RT
        opt = ccm_trial_selection;
        opt.outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        opt.ssd = 'none';
        nsTrial = ccm_trial_selection(jTD, opt);
        rtNs(j) = nanmean(jTD.rt(nsTrial));
        
        
        %--------------------------------------------------------------------------
        %       PAIRS
        %--------------------------------------------------------------------------
        Opt2(1) = opt; % Initialize structure with 2 levels
        Opt2(2) = opt;
        
        %--------------------------------------------------------------------------
        % NS -> NS
        %         disp('NoStop - NoStop')
        
        Opt2(1).outcome = {'goCorrectTarget'};
        Opt2(1).ssd = 'none';
        
        
        Opt2(2).outcome = {'goCorrectTarget'};
        Opt2(2).ssd = 'none';
        rtNsNsTrial = ccm_trial_sequence(jTD, Opt2);
        rtNsNsTrial = setxor(rtNsNsTrial, excludeTrialTriplet);
        rtNsNs1(j) = nanmean(jTD.rt(rtNsNsTrial));
        rtNsNs2(j) = nanmean(jTD.rt(rtNsNsTrial + 1));
        [h,p,ci,stats] = ttest2(jTD.rt(rtNsNsTrial), jTD.rt(rtNsNsTrial+1));
        
        %--------------------------------------------------------------------------
        % C -> NS
        %         disp('Canceled - NoStop')
        
        Opt2(1).outcome = {'stopCorrect'};
        Opt2(1).ssd = 'any';
        
        Opt2(2).outcome = {'goCorrectTarget'};
        Opt2(2).ssd = 'none';
        
        CNsTrial = ccm_trial_sequence(jTD, Opt2);
        CNsTrial = setxor(CNsTrial, excludeTrialTriplet);
        rtCNs1(j) = nanmean(jTD.rt(CNsTrial));
        rtCNs2(j) = nanmean(jTD.rt(CNsTrial + 1));
        [h,p,ci,stats] = ttest2(jTD.rt(CNsTrial), jTD.rt(CNsTrial+1));
        
        %--------------------------------------------------------------------------
        % NC -> NS
        %         disp('Noncanceled - NoStop')
        
        Opt2(1).outcome = {'stopIncorrectTarget','stopIncorrectDistractor','targetHoldAbort','distractorHoldAbort'};
        Opt2(1).ssd = 'any';
        
        Opt2(2).outcome = {'goCorrectTarget'};
        Opt2(2).ssd = 'none';
        
        rtNcNsTrial = ccm_trial_sequence(jTD, Opt2);
        rtNcNsTrial = setxor(rtNcNsTrial, excludeTrialTriplet);
        rtNcNs1(j) = nanmean(jTD.rt(rtNcNsTrial));
        rtNcNs2(j) = nanmean(jTD.rt(rtNcNsTrial + 1));
        [h,p,ci,stats] = ttest2(jTD.rt(rtNcNsTrial), jTD.rt(rtNcNsTrial+1));
        
        %--------------------------------------------------------------------------
        % E -> NS    No-stop Error Choice -> No-stop Correct Choice
        %         disp('Error - NoStop')
        
        Opt2(1).outcome = {'goCorrectDistractor'};
        Opt2(1).ssd = 'none';
        
        Opt2(2).outcome = {'goCorrectTarget'};
        Opt2(2).ssd = 'none';
        
        rtENsTrial = ccm_trial_sequence(jTD, Opt2);
        rtENsTrial = setxor(rtENsTrial, excludeTrialTriplet);
        rtENs1(j) = nanmean(jTD.rt(rtENsTrial));
        rtENs2(j) = nanmean(jTD.rt(rtENsTrial + 1));
        [h,p,ci,stats] = ttest2(jTD.rt(rtENsTrial), jTD.rt(rtENsTrial+1));
        
        
        
        
        
        
        
        
        
        
        
        
        %--------------------------------------------------------------------------
        %       TRIPLETS
        %--------------------------------------------------------------------------
        Opt3(1) = opt; % Initialize structure with 3 levels
        Opt3(2) = opt;
        Opt3(3) = opt;
        
        
        %--------------------------------------------------------------------------
        % NS -> C -> NS
        %         disp('NoStop - Canceled - NoStop')
        
        Opt3(1).outcome     = {'goCorrectTarget'};
        Opt3(1).ssd         = 'none';
        
        Opt3(2).outcome     = {'stopCorrect'};
        Opt3(2).ssd         = 'any';
        
        Opt3(3).outcome     = {'goCorrectTarget'};
        Opt3(3).ssd         = 'none';
        
        rtNsCNsTrial        = ccm_trial_sequence(jTD, Opt3);
        rtNsCNsTrial        = setxor(rtNsCNsTrial, excludeTrialTriplet);
        nNsCNs(j)           = length(rtNsCNsTrial);
        rtNsCNs1(j)         = nanmean(jTD.rt(rtNsCNsTrial));
        rtNsCNs3(j)         = nanmean(jTD.rt(rtNsCNsTrial + 2));
        [h,p,ci,stats]      = ttest2(jTD.rt(rtNsCNsTrial), jTD.rt(rtNsCNsTrial+2));
        
        
        
        %--------------------------------------------------------------------------
        % NS -> NC -> NS
        %          disp('NoStop - NonCanceled - NoStop')
        
        Opt3(1).outcome     = {'goCorrectTarget'};
        Opt3(1).ssd         = 'none';
        
        %         Opt3(2).outcome = {'stopIncorrectTarget', 'stopIncorrectDistractor', 'targetHoldAbort', 'distractorHoldAbort'};
        Opt3(2).outcome     = {'stopIncorrectTarget', 'targetHoldAbort'};
        Opt3(2).ssd         = 'any';
        
        % Opt3(3).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        Opt3(3).outcome     = {'goCorrectTarget'};
        Opt3(3).ssd         = 'none';
        
        rtNsNcNsTrial       = ccm_trial_sequence(jTD, Opt3);
        rtNsNcNsTrial       = setxor(rtNsNcNsTrial, excludeTrialTriplet);
        nNsNcNs(j)        	= length(rtNsNcNsTrial);
        rtNsNcNs1(j)        = nanmean(jTD.rt(rtNsNcNsTrial));
        rtNsNcNs2(j)        = nanmean(jTD.rt(rtNsNcNsTrial + 1));
        rtNsNcNs3(j)        = nanmean(jTD.rt(rtNsNcNsTrial + 2));
        [h,p,ci,stats]      = ttest2(jTD.rt(rtNsNcNsTrial), jTD.rt(rtNsNcNsTrial+2));
        
        
        
        %--------------------------------------------------------------------------
        % NS -> Error -> NS
        %         disp('NoStop - Choice Error - NoStop')
        
        Opt3(1).outcome     = {'goCorrectTarget'};
        Opt3(1).ssd         = 'none';
        
        Opt3(2).outcome  	= {'goCorrectDistractor'};
        Opt3(2).ssd         = 'none';
        
        Opt3(3).outcome     = {'goCorrectTarget'};
        Opt3(3).ssd         = 'none';
        
        rtNsENsTrial        = ccm_trial_sequence(jTD, Opt3);
        rtNsENsTrial        = setxor(rtNsENsTrial, excludeTrialTriplet);
        nNsENs(j)        	= length(rtNsENsTrial);
        rtNsENs1(j)         = nanmean(jTD.rt(rtNsENsTrial));
        rtNsENs2(j)         = nanmean(jTD.rt(rtNsENsTrial + 1));
        rtNsENs3(j)         = nanmean(jTD.rt(rtNsENsTrial + 2));
        [h,p,ci,stats]      = ttest2(jTD.rt(rtNsENsTrial), jTD.rt(rtNsENsTrial+2));
        
        
        
        %--------------------------------------------------------------------------
        % NS -> NS -> NS
        %          disp('NoStop - Choice Error - NoStop')
        
        Opt3(1).outcome     = {'goCorrectTarget'};
        Opt3(1).ssd         = 'none';
        
        Opt3(2).outcome     = {'goCorrectTarget'};
        Opt3(2).ssd         = 'none';
        
        Opt3(3).outcome     = {'goCorrectTarget'};
        Opt3(3).ssd         = 'none';
        
        rtNsNsNsTrial       = ccm_trial_sequence(jTD, Opt3);
        rtNsNsNsTrial       = setxor(rtNsNsNsTrial, excludeTrialTriplet);
        nNsNsNs(j)        	= length(rtNsNsNsTrial);
        rtNsNsNs1(j)        = nanmean(jTD.rt(rtNsNsNsTrial));
        rtNsNsNs2(j)        = nanmean(jTD.rt(rtNsNsNsTrial + 1));
        rtNsNsNs3(j)        = nanmean(jTD.rt(rtNsNsNsTrial + 2));
        [h,p,ci,stats]      = ttest2(jTD.rt(rtNsNsNsTrial), jTD.rt(rtNsNsNsTrial+2));
        
        
        
        
        
        
        % ERROR ANALYSIS
        
        
        
        %--------------------------------------------------------------------------
        % NS -> C -> NSe (no-stop choice errors
        %         disp('NoStop - Canceled - NoStopError')
        
        Opt3(1).outcome     = {'goCorrectTarget'};
        Opt3(1).ssd         = 'none';
        
        Opt3(2).outcome     = {'stopCorrect'};
        Opt3(2).ssd         = 'any';
        
        Opt3(3).outcome     = {'goCorrectDistractor'};
        Opt3(3).ssd         = 'none';
        
        rtNsCNseTrial       = ccm_trial_sequence(jTD, Opt3);
        rtNsCNseTrial       = setxor(rtNsCNseTrial, excludeTrialTriplet);
        nNsCNse(j)          = length(rtNsCNseTrial);
        rtNsCNse1(j)        = nanmean(jTD.rt(rtNsCNseTrial));
        rtNsCNse3(j)        = nanmean(jTD.rt(rtNsCNseTrial + 2));
        [h,p,ci,stats]      = ttest2(jTD.rt(rtNsCNseTrial), jTD.rt(rtNsCNseTrial+2));
        
        
        %--------------------------------------------------------------------------
        % NS -> NC -> NSe
        %          disp('NoStop - NonCanceled - NoStopError')
        
        Opt3(1).outcome     = {'goCorrectTarget'};
        Opt3(1).ssd         = 'none';
        
        %         Opt3(2).outcome = {'stopIncorrectTarget', 'stopIncorrectDistractor', 'targetHoldAbort', 'distractorHoldAbort'};
        Opt3(2).outcome     = {'stopIncorrectTarget', 'targetHoldAbort'};
        Opt3(2).ssd         = 'any';
        
        % Opt3(3).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
        Opt3(3).outcome     = {'goCorrectDistractor'};
        Opt3(3).ssd         = 'none';
        
        rtNsNcNseTrial       = ccm_trial_sequence(jTD, Opt3);
        rtNsNcNseTrial       = setxor(rtNsNcNseTrial, excludeTrialTriplet);
        nNsNcNse(j)        	= length(rtNsNcNseTrial);
        rtNsNcNse1(j)        = nanmean(jTD.rt(rtNsNcNseTrial));
        rtNsNcNse2(j)        = nanmean(jTD.rt(rtNsNcNseTrial + 1));
        rtNsNcNse3(j)        = nanmean(jTD.rt(rtNsNcNseTrial + 2));
        [h,p,ci,stats]      = ttest2(jTD.rt(rtNsNcNseTrial), jTD.rt(rtNsNcNseTrial+2));
        
        
        
        %--------------------------------------------------------------------------
        % NS -> Error -> NSe
        %         disp('NoStop - Choice Error - NoStopError')
        
        Opt3(1).outcome     = {'goCorrectTarget'};
        Opt3(1).ssd         = 'none';
        
        Opt3(2).outcome  	= {'goCorrectDistractor'};
        Opt3(2).ssd         = 'none';
        
        Opt3(3).outcome     = {'goCorrectDistractor'};
        Opt3(3).ssd         = 'none';
        
        rtNsENseTrial        = ccm_trial_sequence(jTD, Opt3);
        rtNsENseTrial        = setxor(rtNsENseTrial, excludeTrialTriplet);
        nNsENse(j)        	= length(rtNsENseTrial);
        rtNsENse1(j)         = nanmean(jTD.rt(rtNsENseTrial));
        rtNsENse2(j)         = nanmean(jTD.rt(rtNsENseTrial + 1));
        rtNsENse3(j)         = nanmean(jTD.rt(rtNsENseTrial + 2));
        [h,p,ci,stats]      = ttest2(jTD.rt(rtNsENseTrial), jTD.rt(rtNsENseTrial+2));
        
        
        
        %--------------------------------------------------------------------------
        % NS -> NS -> NSe
        %          disp('NoStop - Choice Error - NoStopError')
        
        Opt3(1).outcome     = {'goCorrectTarget'};
        Opt3(1).ssd         = 'none';
        
        Opt3(2).outcome     = {'goCorrectTarget'};
        Opt3(2).ssd         = 'none';
        
        Opt3(3).outcome     = {'goCorrectDistractor'};
        Opt3(3).ssd         = 'none';
        
        rtNsNsNseTrial       = ccm_trial_sequence(jTD, Opt3);
        rtNsNsNseTrial       = setxor(rtNsNsNseTrial, excludeTrialTriplet);
        nNsNsNse(j)        	= length(rtNsNsNseTrial);
        rtNsNsNs1(j)        = nanmean(jTD.rt(rtNsNsNseTrial));
        rtNsNsNs2(j)        = nanmean(jTD.rt(rtNsNsNseTrial + 1));
        rtNsNsNs3(j)        = nanmean(jTD.rt(rtNsNsNseTrial + 2));
        [h,p,ci,stats]      = ttest2(jTD.rt(rtNsNsNseTrial), jTD.rt(rtNsNsNseTrial+2));
        
        
        
    end % for j = 1 : nSession
    
    
    pNsCNse  	= sum(nNsCNse) / sum([nNsCNse;nNsCNs]);
    pNsNcNse    = sum(nNsNcNse) / sum([nNsNcNse;nNsNcNs]);
    pNsENse     = sum(nNsENse) / sum([nNsENse;nNsENs]);
    pNsNsNse    = sum(nNsNsNse) / sum([nNsNsNse;nNsNsNs]);
    fprintf('%s error probability after trial type:\n', subjectArray{i})
    fprintf('Canceled:\t\t%0.3f\n', pNsCNse)
    fprintf('Nonanceled:\t\t%0.3f\n', pNsNcNse)
    fprintf('No-stop Error:\t\t%0.3f\n', pNsENse)
    fprintf('No-stop Correct:\t%0.3f\n', pNsNsNse)
    
    
    
    
    
    % Plot
    % ylim([250 350])
    plot([1 21], [nanmean(rtNs) nanmean(rtNs)], '--', 'color', colorArray{i})
    plot([1:2], [nanmean(rtNsNs1) nanmean(rtNsNs2)], '--o', 'color', colorArray{i})
    plot([4], [nanmean(rtCNs2)], '--o', 'color', colorArray{i})
    plot([5:6], [nanmean(rtNcNs1) nanmean(rtNcNs2)], '--o', 'color', colorArray{i})
    plot([7:8], [nanmean(rtENs1) nanmean(rtENs2)], '--o', 'color', colorArray{i})
    plot([10 11 12], [nanmean(rtNsNsNs1) nanmean(rtNsNsNs2) nanmean(rtNsNsNs3)], '-o', 'color', colorArray{i})
    plot([13 15], [nanmean(rtNsCNs1) nanmean(rtNsCNs3)], '-o', 'color', colorArray{i})
    plot([16 17 18], [nanmean(rtNsNcNs1) nanmean(rtNsNcNs2) nanmean(rtNsNcNs3)], '-o', 'color', colorArray{i})
    plot([19 20 21], [nanmean(rtNsENs1) nanmean(rtNsENs2) nanmean(rtNsENs3)], '-o', 'color', colorArray{i})
    
    
    
    
    
    
end
if strcmp(iSubject, 'human')
    ylim([550 750])
else
    ylim([200 350])
end
xlim([0 22])
set(gca, 'xtick', [1.5 3.5 5.5 7.5 11 14 17 20])
set(gca, 'xticklabel', {'NS-NS','C-NS','NC-NS','E-NS','NS-NS-NS','NS-C-NS','NS-NC-NS','NS-E-NS'})
% legend({'Broca','Xena'})


