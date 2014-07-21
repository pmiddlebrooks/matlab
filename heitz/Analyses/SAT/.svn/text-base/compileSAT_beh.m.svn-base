cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
 %[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
 [filename2] = textread('SAT2_Beh_NoMed_D.txt','%s');
 %[filename3] = textread('SAT_Beh_Med_S.txt','%s');
 [filename4] = textread('SAT2_Beh_NoMed_E.txt','%s');
filename = [filename2 ; filename4];

%[filename] = textread('SAT2_Beh_NoMed_D.txt','%s');

RR = [];
OptimalRR = [];

for file = 1:length(filename)
    
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_','Correct_','TrialStart_')
    filename{file}
    
    %============
    % FIND TRIALS
    %===================================================================
    if exist('SRT') == 0
        SRT = getSRT(EyeX_,EyeY_);
    end
    
    trunc_RT = 2000;
    getTrials_SAT
    

    [curRR curOptimalRR] = getRewardRate_SAT;
    
    RR = [RR ; curRR];
    OptimalRR = [OptimalRR ; curOptimalRR];

    %====================
    % Calculate ACC rates
    %percentage of CORRECT trials that missed the deadline
    prc_missed.slow_correct(file,1) = length(slow_correct_missed_dead) / (length(slow_correct_made_dead) + length(slow_correct_missed_dead));
    prc_missed.fast_correct_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / (length(fast_correct_made_dead_withCleared) + length(fast_correct_missed_dead_withCleared));
    prc_missed.fast_correct_noCleared(file,1) = length(fast_correct_missed_dead_noCleared) / (length(fast_correct_made_dead_noCleared) + length(fast_correct_missed_dead_noCleared));
    
    %ACC rate for made deadlines
    ACC.slow_made_dead(file,1) = length(slow_correct_made_dead) / length(slow_all_made_dead);
    ACC.fast_made_dead_withCleared(file,1) = length(fast_correct_made_dead_withCleared) / length(fast_all_made_dead_withCleared);
    ACC.fast_made_dead_noCleared(file,1) = length(fast_correct_made_dead_noCleared) / length(fast_all_made_dead_noCleared);
    
    
    %ACC rate for missed deadlines
    ACC.slow_missed_dead(file,1) = length(slow_correct_missed_dead) / length(slow_all_missed_dead);
    ACC.fast_missed_dead_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared);
    ACC.fast_missed_dead_noCleared(file,1) = length(fast_correct_missed_dead_noCleared) / length(fast_all_missed_dead_noCleared);
    
    
    %overall ACC rate for made + missed deadlines
    ACC.slow_made_missed(file,1) = length(slow_correct_made_missed) / length(slow_all);
    ACC.fast_made_missed_withCleared(file,1) = length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared);
    ACC.fast_made_missed_noCleared(file,1) = length(fast_correct_made_missed_noCleared) / length(fast_all_noCleared);
    
    ACC.med(file,1) = length(med_correct) / length(med_all);
    
    
    RTs.slow_correct_made_dead(file,1) = nanmean(SRT(slow_correct_made_dead,1));
    RTs.slow_correct_missed_dead(file,1) = nanmean(SRT(slow_correct_missed_dead,1));
    RTs.slow_correct_match_med(file,1) = nanmean(SRT(slow_correct_match_med,1));
    
    RTs.med_correct(file,1) = nanmean(SRT(med_correct,1));
    RTs.med_correct_match_med(file,1) = nanmean(SRT(med_correct_match_med,1));
    
    RTs.fast_correct_made_dead_withCleared(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared,1));
    RTs.fast_correct_match_med(file,1) = nanmean(SRT(fast_correct_match_med,1));
    RTs.fast_correct_missed_dead_withCleared(file,1) = nanmean(SRT(fast_correct_missed_dead_withCleared,1));
    RTs.fast_correct_made_dead_noCleared(file,1) = nanmean(SRT(fast_correct_made_dead_noCleared,1));
    
    RTs.slow_errors_made_dead(file,1) = nanmean(SRT(slow_errors_made_dead,1));
    RTs.med_errors(file,1) = nanmean(SRT(med_errors,1));
    RTs.fast_errors_made_dead_withCleared(file,1) = nanmean(SRT(fast_errors_made_dead_withCleared,1));
    RTs.fast_errors_made_dead_noCleared(file,1) = nanmean(SRT(fast_errors_made_dead_noCleared,1));
    
    
    RTs.slow_correct_made_dead_binSLOW(file,1) = nanmean(SRT(slow_correct_made_dead_binSLOW,1));
    RTs.slow_correct_made_dead_binMED(file,1) = nanmean(SRT(slow_correct_made_dead_binMED,1));
    RTs.slow_correct_made_dead_binFAST(file,1) = nanmean(SRT(slow_correct_made_dead_binFAST,1));
    RTs.med_correct_binSLOW(file,1) = nanmean(SRT(med_correct_binSLOW,1));
    RTs.med_correct_binMED(file,1) = nanmean(SRT(med_correct_binMED,1));
    RTs.med_correct_binFAST(file,1) = nanmean(SRT(med_correct_binFAST,1));
    RTs.fast_correct_made_dead_withCleared_binSLOW(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared_binSLOW,1));
    RTs.fast_correct_made_dead_withCleared_binMED(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared_binMED,1));
    RTs.fast_correct_made_dead_withCleared_binFAST(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared_binFAST,1));
    
    CDFtemp_slow = getDefectiveCDF(slow_correct_made_dead,slow_errors_made_dead);
    CDFtemp_med = getDefectiveCDF(med_correct,med_errors);
    CDFtemp_fast = getDefectiveCDF(fast_correct_made_dead_withCleared,fast_errors_made_dead_withCleared);
    
    CDF.slow.correct(:,1:2,file) = CDFtemp_slow.correct;
    CDF.slow.err(:,1:2,file) = CDFtemp_slow.err;
    CDF.med.correct(:,1:2,file) = CDFtemp_med.correct;
    CDF.med.err(:,1:2,file) = CDFtemp_med.err;
    CDF.fast.correct(:,1:2,file) = CDFtemp_fast.correct;
    CDF.fast.err(:,1:2,file) = CDFtemp_fast.err;
    
    file_list{file,1} = filename;
    
    keep filename file ACC RTs CDF file_list prc_missed RR OptimalRR
    
end



%===========
% PLOTTING
%plotting routine for SAT aggs

mACC.slow_made_dead = nanmean(ACC.slow_made_dead);
mACC.fast_made_dead_withCleared = nanmean(ACC.fast_made_dead_withCleared);
mACC.fast_made_dead_noCleared = nanmean(ACC.fast_made_dead_noCleared);

mACC.slow_missed_dead = nanmean(ACC.slow_missed_dead);
mACC.fast_missed_dead_withCleared = nanmean(ACC.fast_missed_dead_withCleared);
mACC.fast_missed_dead_noCleared = nanmean(ACC.fast_missed_dead_noCleared);

mACC.med = nanmean(ACC.med);


sem.slow_made_dead = nanstd(ACC.slow_made_dead) / sqrt(sum(~isnan(ACC.slow_made_dead)));
sem.fast_made_dead_withCleared = nanstd(ACC.fast_made_dead_withCleared) / sqrt(sum(~isnan(ACC.fast_made_dead_withCleared)));
sem.fast_made_dead_noCleared = nanstd(ACC.fast_made_dead_noCleared) / sqrt(sum(~isnan(ACC.fast_made_dead_noCleared)));


sem.slow_missed_dead = nanstd(ACC.slow_missed_dead) / sqrt(sum(~isnan(ACC.slow_missed_dead)));
sem.fast_missed_dead_withCleared = nanstd(ACC.fast_missed_dead_withCleared) / sqrt(sum(~isnan(ACC.fast_missed_dead_withCleared)));
sem.fast_missed_dead_noCleared = nanstd(ACC.fast_missed_dead_noCleared) / sqrt(sum(~isnan(ACC.fast_missed_dead_noCleared)));

sem.med = nanstd(ACC.med) / sqrt(sum(~isnan(ACC.med)));


figure
subplot(2,1,1)
errorbar(1:7,[mACC.slow_made_dead mACC.med mACC.fast_made_dead_withCleared mACC.fast_made_dead_noCleared ...
     mACC.slow_missed_dead mACC.fast_missed_dead_withCleared mACC.fast_missed_dead_noCleared], ...
    [sem.slow_made_dead sem.fast_made_dead_withCleared sem.fast_made_dead_noCleared ...
    sem.med sem.slow_missed_dead sem.fast_missed_dead_withCleared sem.fast_missed_dead_noCleared], ...
    'x')

hold on
bar(1:7,[mACC.slow_made_dead mACC.med mACC.fast_made_dead_withCleared mACC.fast_made_dead_noCleared ...
     mACC.slow_missed_dead mACC.fast_missed_dead_withCleared mACC.fast_missed_dead_noCleared])
set(gca,'xtick',[1:7])
set(gca,'xticklabel',['slow   made';'Medium     ';'fast MadeWi';'fast MadeNo';'slow   miss'; ...
    'fast MissWi';'fast MissNo'])



%==========
% CDFs
bins.slow_correct = mean(CDF.slow.correct(:,1,:),3);
cdfs.slow_correct = mean(CDF.slow.correct(:,2,:),3);

bins.med_correct = mean(CDF.med.correct(:,1,:),3);
cdfs.med_correct = mean(CDF.med.correct(:,2,:),3);

bins.fast_correct = mean(CDF.fast.correct(:,1,:),3);
cdfs.fast_correct = mean(CDF.fast.correct(:,2,:),3);

bins.slow_err = mean(CDF.slow.err(:,1,:),3);
cdfs.slow_err = mean(CDF.slow.err(:,2,:),3);
 
bins.med_err = mean(CDF.med.err(:,1,:),3);
cdfs.med_err = mean(CDF.med.err(:,2,:),3);
 
bins.fast_err = mean(CDF.fast.err(:,1,:),3);
cdfs.fast_err = mean(CDF.fast.err(:,2,:),3);


figure
fon
plot(bins.slow_correct,cdfs.slow_correct,'-or',bins.slow_err,cdfs.slow_err,'--or', ...
    bins.med_correct,cdfs.med_correct,'-ok',bins.med_err,cdfs.med_err,'--ok', ...
    bins.fast_correct,cdfs.fast_correct,'-og',bins.fast_err,cdfs.fast_err,'--og')
title('Defective CDFs')
xlabel('Vincentized RT Bin')
ylabel('p(Correct)')
box off
ylim([0 1])
xlim([0 800])

