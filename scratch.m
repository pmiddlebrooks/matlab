%%
figure(10);
hold all
cellfun(@(x,y) plot(x,y, 'k'), goEyeX{1,1}, goEyeY{1,1})

% plot(goEyeX{1,1}, goEyeY{1,1})

degX = cellfun(@(x) sqrt(x), cellfun(@(x,y) x^2 + y^2, goEyeX{1,1}, goEyeY{1,1}))


velX{d, i} = cellfun(@(x) [0; diff(x(:))], degX, 'uni', false);


scatter(trialData.rt(goTrial{d, i}), cellfun(@max, goVel{d, i}))


%% Add hemisphere to translated data file
subject = 'joule';
session = {'jp061n02'};
tebaPath = '/Volumes/SchallLab/data/';


for i = 1 : length(session)
[~, SessionData] = load_data(subject, session{i});

SessionData.hemisphere = 'left';

save(fullfile(local_data_path, subject, [session{i}, '.mat']), 'SessionData', '-append')
save(fullfile(tebaPath, subject, [session{i}, '.mat']), 'SessionData', '-append')


end

%%
plexon_translate_datafile_mac('joule','jp060n02');


%%
sdf53 = nanmean(spike_density_function(cell2mat(alignedRasters(trialData.targ1CheckerProp == .53,:)), Kernel), 1);
sdf58 = nanmean(spike_density_function(cell2mat(alignedRasters(trialData.targ1CheckerProp == .58,:)), Kernel), 1);
figure(1)
eopchLBegin = epochBegin(trialData.targ1CheckerProp == .58);
epochLEnd = epochEnd(trialData.targ1CheckerProp == .58);
for i = 1 : length(epochBegin)
    
clf
hold on
    plot(sdf53);
plot(sdf58, 'k')
plot([eopchLBegin(i) eopchLBegin(i)], [0 50])
plot([epochLEnd(i) epochLEnd(i)], [0 50])
pause
end
%%
size(ddm, 1);
for i = 1  :  size(ddm, 1)
    i
    ddmLike = ccm_ddm_like('broca', ddm.sessionID{i}, 'unitArray', ddm.unit{i})
end

%%

[td, S, E] = load_data('broca','bp093n02');
%%
% [td, S, E] = ccm_load_data_behavior('broca','bp121n02-pm');
[td, S, E] = ccm_load_data_behavior('broca','bp247n02');
%%
opt = ccm_options;
opt.trialOutcome = 'valid';
opt.ssd = 'collapse';
trial = ccm_trial_selection(td, opt);
td = td(trial,:);
nSsd = arrayfun( @(x)(length(find(td.ssd==x))), E.ssdArray);
[E.ssdArray, nSsd]
criteriaDiff = 20;

belowCritera = find(diff(E.ssdArray) < criteriaDiff);

% Are there any that have runs of more than 2 SSDs that are less than
% criteria? If so, we need to give up and keep one.
remove = 1+find(diff(belowCritera) < 2);
belowCritera(remove) = [];

ssdIndAltered = [belowCritera; belowCritera+1];
ssdKeep = setxor(ssdIndAltered, 1:length(E.ssdArray));

ssdWeighted = nan(length(belowCritera), 1);
for i = 1 : length(belowCritera)
    
    ssdInd = [belowCritera(i) belowCritera(i)+1]; 
    ssdWeighted(i) = round(sum(E.ssdArray(ssdInd) .* nSsd(ssdInd) / sum(nSsd(ssdInd))));
    td.ssd(td.ssd == E.ssdArray(ssdInd(1)) | td.ssd == E.ssdArray(ssdInd(2))) = ssdWeighted(i);
end

newSSD = sort([E.ssdArray(ssdKeep); ssdWeighted]);
newSSD2 = unique(td.ssd);

[i,ia] = ismember(newSSD, td.ssd)
nSsdNew = arrayfun( @(x)(length(find(td.ssd==x))), newSSD);
[newSSD, nSsdNew]

%%
[td1, S, E] = load_data('broca','bp256n01');
[td2, S, E] = load_data('broca','bp256n02');
[td3, S, E] = load_data('broca','bp256n03');
% [td1, S, E] = load_data('broca','bp255n01');
% [td2, S, E] = load_data('broca','bp255n02');
% [td3, S, E] = load_data('broca','bp255n03');

opt = ccm_options;

opt.trialOutcome = 'goCorrectTarget';
% opt.targAngle = 0;
opt.targHemifield = 'right';

rCorr1 = cmd_trial_selection(td1, opt);
rCorr2 = cmd_trial_selection(td2, opt);
rCorr3 = cmd_trial_selection(td3, opt);

rtRCorr1 = nanmean(td1.rt(rCorr1))
rtRCorr2 = nanmean(td2.rt(rCorr2))
rtRCorr3 = nanmean(td3.rt(rCorr3))


% opt.targAngle = 180;
opt.targHemifield = 'left';

lCorr1 = cmd_trial_selection(td1, opt);
lCorr2 = cmd_trial_selection(td2, opt);
lCorr3 = cmd_trial_selection(td3, opt);

rtLCorr1 = nanmean(td1.rt(lCorr1))
rtLCorr2 = nanmean(td2.rt(lCorr2))
rtLCorr3 = nanmean(td3.rt(lCorr3))

leftRT = [td1.rt(lCorr1); td2.rt(lCorr2); td3.rt(lCorr3)];
leftGroup = [ones(length(td1.rt(lCorr1)), 1); 2*ones(length(td2.rt(lCorr2)), 1); 3* ones(length(td3.rt(lCorr3)), 1)]; 
rightRT = [td1.rt(rCorr1); td2.rt(rCorr2); td3.rt(rCorr3)];
rightGroup = [ones(length(td1.rt(rCorr1)), 1); 2*ones(length(td2.rt(rCorr2)), 1); 3* ones(length(td3.rt(rCorr3)), 1)]; 
% [pL, tableL, statsL] = anova1(leftRT, leftGroup, 'display', 'off');
% [pR, tableR, statsR] = anova1(rightRT, rightGroup, 'display', 'off');
save(fullfile(local_data_path, 'anodal.mat'), 'leftRT', 'leftGroup', 'rightRT', 'rightGroup')

%%
figure(1)
hold all
plot([rtLCorr1, rtLCorr2, rtLCorr3], '--k')
plot([rtRCorr1, rtRCorr2, rtRCorr3], '--b')


%%
ssd = new.ssd;

    ssdList = unique(ssd(~isnan(ssd)))
    nSSD = nan(length(ssdList), 1);
    for i = 1 : length(ssdList)
        nSSD(i) = sum(trialData.ssd == ssdList(i));
    end

 %%

                     % plot Average unit dynamics
                    dynTime = mean(cell2mat(prd.dyn{iTrialCatGo}.stopICorr.stopStim.targetGO.sX));
                    dynAct = mean(cell2mat(prd.dyn{iTrialCatGo}.stopICorr.stopStim.targetGO.sY));
                    plot(dynTime, dynAct, 'Color','k','LineStyle',unitLnStyle{unitGoCorr},'LineWidth',unitLnWidth(unitGoCorr))
                    
                    dynTime = prd.dyn{iTrialCatGo}.stopICorr.goStim.targetGO.sX;
                    dynAct = prd.dyn{iTrialCatGo}.stopICorr.goStim.targetGO.sY;
                    cellfun(@(x,y) plot(x,y, 'Color',unitLnClr(unitGoCorr,:),'LineStyle',unitLnStyle{unitGoCorr},'LineWidth',1), dynTime,dynAct, 'uni', false)

 
                     plot(dynTime(iSsd+1:end), dynAct(iSsd+1:end), 'Color',unitLnClr(unitStop,:),'LineStyle',unitLnStyle{unitStop},'LineWidth',unitLnWidth(unitStop))
                     plot(dynTime(iSsd+1:end), dynAct(iSsd+1:end), 'Color','b','LineStyle',unitLnStyle{unitStop},'LineWidth',unitLnWidth(unitStop))

                     normAct = cell(size(dynActGoCorr));
                     lastNonNan = cellfun(@(x) find(isnan(x), 1), dynActGoCorr);
                     lastNonNan = max(lastNonNan) - 1;
for i = 1 : size(dynActGoCorr, 1)
    iLast = find(isnan(dynActGoCorr{i}), 1) - 1;
    iScale = lastNonNan / iLast;
    normAct{i} = dynActGoCorr{i} * iScale;
end
cellfun(@(x,y) plot(x,y, 'Color','k','LineStyle',unitLnStyle{unitGoCorr},'LineWidth',1), dynTimeGoCorr,normAct, 'uni', false)

meanFn = nanmean(cell2mat(normAct));