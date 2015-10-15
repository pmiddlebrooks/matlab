function data = ccm_rt_history_neural(subjectID, sessionID)

% triplet analysis:
% Replicating Pouget et al
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

%%
close all
subjectID = 'broca';
sessionID = 'bp093n02';
% sessionID = 'bp132n02';
% sessionID = 'bp131n02';
epochName = 'fixWindowEntered';
epochName = 'targOn';
epochName = 'checkerOn';
epochName = 'responseOnset';
% epochName = 'rewardOn';

EPOCH_WINDOW    = -299:300;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DATA AND SET VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[trialData, SessionData, ExtraVar] = load_data(subjectID, sessionID);
pSignalArray    = ExtraVar.pSignalArray;
targAngleArray	= ExtraVar.targAngleArray;
ssdArray        = ExtraVar.ssdArray;
nSSD            = length(ssdArray);

if ~strcmp(SessionData.taskID, 'ccm')
    fprintf('Not a chioce countermanding saccade session, try again\n')
    return
end


% Set defaults
% dataType = options.dataType;
dataType = 'neuron';
unitArray = 'each';
switch dataType
    case 'neuron'
        dataArray     = SessionData.spikeUnitArray;
        if strcmp(unitArray, 'each')
            unitArray     = dataArray;
        end
    case 'lfp'
        dataArray 	= num2cell(SessionData.lfpChannel);
        if strcmp(unitArray, 'each')
            unitArray 	= dataArray;
        end
    case 'erp'
        dataArray     = eeg_electrode_map(subjectID);
        if strcmp(unitArray, 'each')
            unitArray     = dataArray;
        end
end
unitArray = {'spikeUnit17a'};



% CONSTANTS
MIN_RT          = 120;
MAX_RT          = 1200;
STD_MULTIPLE    = 3;
DELETE_ABORTS   = false;
N_UNIT = length(unitArray);

nsColor = 'g';
cColor = [1 .5 0];
ncColor = 'k';
eColor = 'b';


% Get rid of trials with outlying RTs
[allRT, rtOutlierTrial] = truncate_rt(trialData.rt, MIN_RT, MAX_RT, STD_MULTIPLE);
trialData.rt(rtOutlierTrial) = nan;


Kernel.method = 'postsynaptic potential';
Kernel.growth = 1;
Kernel.decay = 20;

% Kernel.method = 'gaussian';
% Kernel.sigma = 10;





if DELETE_ABORTS
    selectOpt = ccm_trial_selection;
    selectOpt.outcome = {...
        'goCorrectTarget', 'goCorrectDistractor', ...
        'stopCorrect', ...
        'targetHoldAbort', 'distractorHoldAbort', ...
        'stopIncorrectTarget', 'stopIncorrectDistractor'};
    validTrial = ccm_trial_selection(trialData, selectOpt);
    trialData = trialData(validTrial,:);
end




responseDirs = {'left', 'right'};
figureHandle = 66;
nRow = 1;
nCol = 2;
yLimit = [0 80];
for kDataInd = 1 : N_UNIT

       switch dataType
      case 'neuron'
         [a, kUnit] = ismember(unitArray{kDataInd}, SessionData.spikeUnitArray);
      case 'lfp'
         [a, kUnit] = ismember(unitArray{kDataInd}, SessionData.lfpChannel);
      case 'erp'
         [a, kUnit] = ismember(unitArray{kDataInd}, eeg_electrode_map(subjectID));
       end

   
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(nRow, nCol, figureHandle);
clf
ax(1,1) = axes('units', 'centimeters', 'position', [xAxesPosition(1,1) yAxesPosition(1,1) axisWidth axisHeight]);
set(ax(1,1), 'ylim', yLimit)
         hold(ax(1,1), 'on')
ax(1,2) = axes('units', 'centimeters', 'position', [xAxesPosition(1,2) yAxesPosition(1,2) axisWidth axisHeight]);
 set(ax(1,2), 'ylim', yLimit)
        hold(ax(1,2), 'on')

    for dirInd = 1 : length(responseDirs)
        iResponseDir = responseDirs{dirInd};
        
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      PARSE DATA AND CALCULATE METRICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total mean No-stop RT
opt = ccm_trial_selection;
opt.outcome = {'goCorrectTarget', 'goCorrectDistractor'};
opt.ssd = 'none';
nsTrial = ccm_trial_selection(trialData, opt);
rtNs = nanmean(trialData.rt(nsTrial));


% %--------------------------------------------------------------------------
% %       PAIRS
% %--------------------------------------------------------------------------
% Opt2(1) = opt; % Initialize structure with 2 levels
% Opt2(2) = opt;
% 
% %--------------------------------------------------------------------------
% % NS -> NS
% %         disp('NoStop - NoStop')
% 
% Opt2(1).outcome     = {'goCorrectTarget'};
% Opt2(1).ssd         = 'none';
% 
% Opt2(2).outcome     = {'goCorrectTarget'};
% Opt2(2).ssd         = 'none';
% Opt2(2).responseDir = iResponseDir;
% 
% rtNsNsTrial = ccm_trial_sequence(trialData, Opt2);
% rtNsNsTrial = setxor(rtNsNsTrial, excludeTrialTriplet);
% rtNsNs1 = nanmean(trialData.rt(rtNsNsTrial));
% rtNsNs2 = nanmean(trialData.rt(rtNsNsTrial + 1));
% [h,p,ci,stats] = ttest2(trialData.rt(rtNsNsTrial), trialData.rt(rtNsNsTrial+1));
% 
% alignList = trialData.(epochName)(rtNsNsTrial+1);
% [rasNsNs, alignNsNs] = spike_to_raster(trialData.spikeData(rtNsNsTrial+1, kUnit), alignList);
% sdfNsNs = spike_density_function(rasNsNs, Kernel);
% 
% 
% 
% plot(ax(iResponseDir), nanmean(sdfNsNs(:, EPOCH_WINDOW + alignNsNs)))
% 
% %--------------------------------------------------------------------------
% % C -> NS
% %         disp('Canceled - NoStop')
% 
% Opt2(1).outcome = {'stopCorrect'};
% Opt2(1).ssd = 'any';
% 
% Opt2(2).outcome = {'goCorrectTarget'};
% Opt2(2).ssd = 'none';
% 
% CNsTrial = ccm_trial_sequence(trialData, Opt2);
% CNsTrial = setxor(CNsTrial, excludeTrialTriplet);
% rtCNs1 = nanmean(trialData.rt(CNsTrial));
% rtCNs2 = nanmean(trialData.rt(CNsTrial + 1));
% [h,p,ci,stats] = ttest2(trialData.rt(CNsTrial), trialData.rt(CNsTrial+1));
% 
% %--------------------------------------------------------------------------
% % NC -> NS
% %         disp('Noncanceled - NoStop')
% 
% Opt2(1).outcome = {'stopIncorrectTarget','stopIncorrectDistractor','targetHoldAbort','distractorHoldAbort'};
% Opt2(1).ssd = 'any';
% 
% Opt2(2).outcome = {'goCorrectTarget'};
% Opt2(2).ssd = 'none';
% 
% rtNcNsTrial = ccm_trial_sequence(trialData, Opt2);
% rtNcNsTrial = setxor(rtNcNsTrial, excludeTrialTriplet);
% rtNcNs1 = nanmean(trialData.rt(rtNcNsTrial));
% rtNcNs2 = nanmean(trialData.rt(rtNcNsTrial + 1));
% [h,p,ci,stats] = ttest2(trialData.rt(rtNcNsTrial), trialData.rt(rtNcNsTrial+1));
% 
% %--------------------------------------------------------------------------
% % E -> NS    No-stop Error Choice -> No-stop Correct Choice
% %         disp('Error - NoStop')
% 
% Opt2(1).outcome = {'goCorrectDistractor'};
% Opt2(1).ssd = 'none';
% 
% Opt2(2).outcome = {'goCorrectTarget'};
% Opt2(2).ssd = 'none';
% 
% rtENsTrial = ccm_trial_sequence(trialData, Opt2);
% rtENsTrial = setxor(rtENsTrial, excludeTrialTriplet);
% rtENs1 = nanmean(trialData.rt(rtENsTrial));
% rtENs2 = nanmean(trialData.rt(rtENsTrial + 1));
% [h,p,ci,stats] = ttest2(trialData.rt(rtENsTrial), trialData.rt(rtENsTrial+1));
% 
% 
% 
% 








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
Opt3(3).responseDir = iResponseDir;

rtNsCNsTrial        = ccm_trial_sequence(trialData, Opt3);
% rtNsCNsTrial        = setxor(rtNsCNsTrial, excludeTrialTriplet);
nNsCNs             = length(rtNsCNsTrial);
rtNsCNs1         = trialData.rt(rtNsCNsTrial);
rtNsCNs3         = trialData.rt(rtNsCNsTrial + 2);
% [h,p,ci,stats]      = ttest2(trialData.rt(rtNsCNsTrialL), trialData.rt(rtNsCNsTrialL+2));

alignList = trialData.(epochName)(rtNsCNsTrial+2);
[rasNsCNs, alignNsCNs] = spike_to_raster(trialData.spikeData(rtNsCNsTrial+2, kUnit), alignList);
sdfNsCNs = spike_density_function(rasNsCNs, Kernel);


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
Opt3(3).responseDir = iResponseDir;

rtNsNcNsTrial       = ccm_trial_sequence(trialData, Opt3);
% rtNsNcNsTrial       = setxor(rtNsNcNsTrial, excludeTrialTriplet);
nNsNcNs        	= length(rtNsNcNsTrial);
rtNsNcNs1        = trialData.rt(rtNsNcNsTrial);
rtNsNcNs2        = trialData.rt(rtNsNcNsTrial + 1);
rtNsNcNs3        = trialData.rt(rtNsNcNsTrial + 2);
% [h,p,ci,stats]      = ttest2(trialData.rt(rtNsNcNsTrial), trialData.rt(rtNsNcNsTrial+2));

alignList = trialData.(epochName)(rtNsNcNsTrial+2);
[rasNsNcNs, alignNsNcNs] = spike_to_raster(trialData.spikeData(rtNsNcNsTrial+2, kUnit), alignList);
sdfNsNcNs = spike_density_function(rasNsNcNs, Kernel);


%--------------------------------------------------------------------------
% NS -> Error -> NS
%         disp('NoStop - Choice Error - NoStop')

Opt3(1).outcome     = {'goCorrectTarget'};
Opt3(1).ssd         = 'none';

Opt3(2).outcome  	= {'goCorrectDistractor'};
Opt3(2).ssd         = 'none';

Opt3(3).outcome     = {'goCorrectTarget'};
Opt3(3).ssd         = 'none';
Opt3(3).responseDir = iResponseDir;

rtNsENsTrial        = ccm_trial_sequence(trialData, Opt3);
% rtNsENsTrial        = setxor(rtNsENsTrial, excludeTrialTriplet);
nNsENs        	= length(rtNsENsTrial);
rtNsENs1         = trialData.rt(rtNsENsTrial);
rtNsENs2         = trialData.rt(rtNsENsTrial + 1);
rtNsENs3         = trialData.rt(rtNsENsTrial + 2);
% [h,p,ci,stats]      = ttest2(trialData.rt(rtNsENsTrial), trialData.rt(rtNsENsTrial+2));

alignList = trialData.(epochName)(rtNsENsTrial+2);
[rasNsENs, alignNsENs] = spike_to_raster(trialData.spikeData(rtNsENsTrial+2, kUnit), alignList);
sdfNsENs = spike_density_function(rasNsENs, Kernel);



%--------------------------------------------------------------------------
% NS -> NS -> NS
%          disp('NoStop - Choice Error - NoStop')

Opt3(1).outcome     = {'goCorrectTarget'};
Opt3(1).ssd         = 'none';

Opt3(2).outcome     = {'goCorrectTarget'};
Opt3(2).ssd         = 'none';

Opt3(3).outcome     = {'goCorrectTarget'};
Opt3(3).ssd         = 'none';
Opt3(3).responseDir = iResponseDir;

rtNsNsNsTrial       = ccm_trial_sequence(trialData, Opt3);
% rtNsNsNsTrial       = setxor(rtNsNsNsTrial, excludeTrialTriplet);
nNsNsNs        	= length(rtNsNsNsTrial);
rtNsNsNs1        = trialData.rt(rtNsNsNsTrial);
rtNsNsNs2        = trialData.rt(rtNsNsNsTrial + 1);
rtNsNsNs3        = trialData.rt(rtNsNsNsTrial + 2);
% [h,p,ci,stats]      = ttest2(trialData.rt(rtNsNsNsTrial), trialData.rt(rtNsNsNsTrial+2));

alignList = trialData.(epochName)(rtNsNsNsTrial+2);
[rasNsNsNs, alignNsNsNs] = spike_to_raster(trialData.spikeData(rtNsNsNsTrial+2, kUnit), alignList);
sdfNsNsNs = spike_density_function(rasNsNsNs, Kernel);







plot(ax(dirInd), nanmean(sdfNsCNs(:, EPOCH_WINDOW + alignNsCNs)), 'color', cColor)
plot(ax(dirInd), nanmean(sdfNsNcNs(:, EPOCH_WINDOW + alignNsNcNs)), 'color', ncColor)
plot(ax(dirInd), nanmean(sdfNsENs(:, EPOCH_WINDOW + alignNsENs)), 'color', eColor)
plot(ax(dirInd), nanmean(sdfNsNsNs(:, EPOCH_WINDOW + alignNsNsNs)), 'color', nsColor)
plot(ax(dirInd), [-EPOCH_WINDOW(1)+1 -EPOCH_WINDOW(1)+1], [0 yLimit(2)*.8], 'k')




    end % for dirInd = 1 : 2


    
    
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
% % ERROR ANALYSIS
% 
% 
% 
% %--------------------------------------------------------------------------
% % NS -> C -> NSe (no-stop choice errors
% %         disp('NoStop - Canceled - NoStopError')
% 
% Opt3(1).outcome     = {'goCorrectTarget'};
% Opt3(1).ssd         = 'none';
% 
% Opt3(2).outcome     = {'stopCorrect'};
% Opt3(2).ssd         = 'any';
% 
% Opt3(3).outcome     = {'goCorrectDistractor'};
% Opt3(3).ssd         = 'none';
% 
% rtNsCNseTrial       = ccm_trial_sequence(trialData, Opt3);
% rtNsCNseTrial       = setxor(rtNsCNseTrial, excludeTrialTriplet);
% nNsCNse          = length(rtNsCNseTrial);
% rtNsCNse1        = nanmean(trialData.rt(rtNsCNseTrial));
% rtNsCNse3        = nanmean(trialData.rt(rtNsCNseTrial + 2));
% [h,p,ci,stats]      = ttest2(trialData.rt(rtNsCNseTrial), trialData.rt(rtNsCNseTrial+2));
% 
% 
% %--------------------------------------------------------------------------
% % NS -> NC -> NSe
% %          disp('NoStop - NonCanceled - NoStopError')
% 
% Opt3(1).outcome     = {'goCorrectTarget'};
% Opt3(1).ssd         = 'none';
% 
% %         Opt3(2).outcome = {'stopIncorrectTarget', 'stopIncorrectDistractor', 'targetHoldAbort', 'distractorHoldAbort'};
% Opt3(2).outcome     = {'stopIncorrectTarget', 'targetHoldAbort'};
% Opt3(2).ssd         = 'any';
% 
% % Opt3(3).outcome = {'goCorrectTarget', 'goCorrectDistractor'};
% Opt3(3).outcome     = {'goCorrectDistractor'};
% Opt3(3).ssd         = 'none';
% 
% rtNsNcNseTrial       = ccm_trial_sequence(trialData, Opt3);
% rtNsNcNseTrial       = setxor(rtNsNcNseTrial, excludeTrialTriplet);
% nNsNcNse        	= length(rtNsNcNseTrial);
% rtNsNcNse1        = nanmean(trialData.rt(rtNsNcNseTrial));
% rtNsNcNse2        = nanmean(trialData.rt(rtNsNcNseTrial + 1));
% rtNsNcNse3        = nanmean(trialData.rt(rtNsNcNseTrial + 2));
% [h,p,ci,stats]      = ttest2(trialData.rt(rtNsNcNseTrial), trialData.rt(rtNsNcNseTrial+2));
% 
% 
% 
% %--------------------------------------------------------------------------
% % NS -> Error -> NSe
% %         disp('NoStop - Choice Error - NoStopError')
% 
% Opt3(1).outcome     = {'goCorrectTarget'};
% Opt3(1).ssd         = 'none';
% 
% Opt3(2).outcome  	= {'goCorrectDistractor'};
% Opt3(2).ssd         = 'none';
% 
% Opt3(3).outcome     = {'goCorrectDistractor'};
% Opt3(3).ssd         = 'none';
% 
% rtNsENseTrial        = ccm_trial_sequence(trialData, Opt3);
% rtNsENseTrial        = setxor(rtNsENseTrial, excludeTrialTriplet);
% nNsENse        	= length(rtNsENseTrial);
% rtNsENse1         = nanmean(trialData.rt(rtNsENseTrial));
% rtNsENse2         = nanmean(trialData.rt(rtNsENseTrial + 1));
% rtNsENse3         = nanmean(trialData.rt(rtNsENseTrial + 2));
% [h,p,ci,stats]      = ttest2(trialData.rt(rtNsENseTrial), trialData.rt(rtNsENseTrial+2));
% 
% 
% 
% %--------------------------------------------------------------------------
% % NS -> NS -> NSe
% %          disp('NoStop - Choice Error - NoStopError')
% 
% Opt3(1).outcome     = {'goCorrectTarget'};
% Opt3(1).ssd         = 'none';
% 
% Opt3(2).outcome     = {'goCorrectTarget'};
% Opt3(2).ssd         = 'none';
% 
% Opt3(3).outcome     = {'goCorrectDistractor'};
% Opt3(3).ssd         = 'none';
% 
% rtNsNsNseTrial       = ccm_trial_sequence(trialData, Opt3);
% rtNsNsNseTrial       = setxor(rtNsNsNseTrial, excludeTrialTriplet);
% nNsNsNse        	= length(rtNsNsNseTrial);
% rtNsNsNs1        = nanmean(trialData.rt(rtNsNsNseTrial));
% rtNsNsNs2        = nanmean(trialData.rt(rtNsNsNseTrial + 1));
% rtNsNsNs3        = nanmean(trialData.rt(rtNsNsNseTrial + 2));
% [h,p,ci,stats]      = ttest2(trialData.rt(rtNsNsNseTrial), trialData.rt(rtNsNsNseTrial+2));
% 
% 
% 
% 
% 
% pNsCNse  	= sum(nNsCNse) / sum([nNsCNse;nNsCNsL]);
% pNsNcNse    = sum(nNsNcNse) / sum([nNsNcNse;nNsNcNs]);
% pNsENse     = sum(nNsENse) / sum([nNsENse;nNsENs]);
% pNsNsNse    = sum(nNsNsNse) / sum([nNsNsNse;nNsNsNs]);
% fprintf('%s error probability after trial type:\n', subjectArray{i})
% fprintf('Canceled:\t\t%0.3f\n', pNsCNse)
% fprintf('Nonanceled:\t\t%0.3f\n', pNsNcNse)
% fprintf('No-stop Error:\t\t%0.3f\n', pNsENse)
% fprintf('No-stop Correct:\t%0.3f\n', pNsNsNse)
% 
% 
% 
% 
% 
% % Plot
% % ylim([250 350])
% plot([1:2], [nanmean(rtNsNs1) nanmean(rtNsNs2)], '--o', 'color', colorArray{i})
% plot([4], [nanmean(rtCNs2)], '--o', 'color', colorArray{i})
% plot([5:6], [nanmean(rtNcNs1) nanmean(rtNcNs2)], '--o', 'color', colorArray{i})
% plot([7:8], [nanmean(rtENs1) nanmean(rtENs2)], '--o', 'color', colorArray{i})


% colorArray = {'k'};
% i = 1;
% 
% [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(1, 1, figureHandle + 100);
% clf
% axes('units', 'centimeters', 'position', [xAxesPosition(1,1) yAxesPosition(1,1) axisWidth axisHeight]);
%          hold on
% 
% plot([1 22], [nanmean(rtNs) nanmean(rtNs)], '--', 'color', 'k')
% plot([10 11 12], [nanmean(rtNsNsNs1) nanmean(rtNsNsNs2) nanmean(rtNsNsNs3)], '-o', 'color', nsColor)
% plot([13 15], [nanmean(rtNsCNs1) nanmean(rtNsCNs3)], '-o', 'color', cColor)
% plot([16 17 18], [nanmean(rtNsNcNs1) nanmean(rtNsNcNs2) nanmean(rtNsNcNs3)], '-o', 'color', ncColor)
% plot([19 20 21], [nanmean(rtNsENs1) nanmean(rtNsENs2) nanmean(rtNsENs3)], '-o', 'color', eColor)
% 
% % 
% % 
% % 
% % 
% % 
% % 
% if strcmp(iSubject, 'human')
%     ylim([550 750])
% else
%     ylim([0 80])
% end
% xlim([0 22])
% set(gca, 'xtick', [1.5 3.5 5.5 7.5 11 14 17 20])
% set(gca, 'xticklabel', {'NS-NS','C-NS','NC-NS','E-NS','NS-NS-NS','NS-C-NS','NS-NC-NS','NS-E-NS'})
% % % legend({'Broca','Xena'})
% % 
% % 
% savePlot = 'y';
% %     input('save?', 's');
% if strcmp(savePlot, 'y')
    localFigurePath = local_figure_path;
    print(figureHandle,[localFigurePath, sprintf('rt_history_neural_%s_%s', epochName, sessionID)],'-dpdf', '-r300')
% end

figureHandle = figureHandle + 1;

end

