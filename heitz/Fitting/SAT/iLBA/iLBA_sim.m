%This runs the integrated LBA (iLBA) on a sample dataset using the objective function:
%iLBA_sim_leaky_integrator_calc_X2.m.  This is the same minimization routine used for the vincentized
%data; just different data
function [] = iLBA_sim()
rand('seed',5150);
randn('seed',5150);
normrnd('seed',5150);

minimize = 0;
plotFlag = 1;
truncate_IQR = 1;
truncval = 1.5;

load('Q110910001-RH_SEARCH','Target_','Correct_','SAT_','Errors_','SRT')
%load('S052011001-RH_SEARCH','Target_','Correct_','SAT_','Errors_','SRT')
getTrials_SAT

if truncate_IQR
    disp(['Truncating ' mat2str(truncval) ' * IQR'])
    highcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) + truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
    lowcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) - truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
    highcut_med = nanmedian(SRT([med_correct ; med_errors],1)) + truncval * iqr(SRT([med_correct ; med_errors],1));
    lowcut_med = nanmedian(SRT([med_correct ; med_errors],1)) - truncval * iqr(SRT([med_correct ; med_errors],1));
    highcut_fast = nanmedian(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1)) + truncval * iqr(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1));
    lowcut_fast = nanmedian(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1)) - truncval * iqr(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1));
    
    
    %Second Pass
    med_correct = intersect(med_correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
    med_errors = intersect(med_errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
    
    %All correct trials w/ made deadlines
    slow_correct = intersect(slow_correct_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
    fast_correct_withCleared = intersect(fast_correct_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
    slow_errors = intersect(slow_errors_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
    fast_errors_withCleared = intersect(fast_errors_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
else
    slow_correct = slow_correct_made_dead;
    slow_errors = slow_errors_made_dead;
    fast_correct_withCleared = fast_correct_made_dead_withCleared;
    fast_errors_withCleared = fast_errors_made_dead_withCleared;
end




trls.slow.correct = slow_correct_made_dead;
trls.slow.errors = slow_errors_made_dead;
trls.fast.correct = fast_correct_made_dead_withCleared;
trls.fast.errors = fast_errors_made_dead_withCleared;
trls.med.correct = med_correct;
trls.med.errors = med_errors;


nts = [10 ; 30 ; 50 ; 70 ; 90 ; 100];


ntiles.slow.correct = prctile(SRT(slow_correct_made_dead,1),nts);
ntiles.slow.errors = prctile(SRT(slow_errors_made_dead,1),nts);
ntiles.fast.correct = prctile(SRT(fast_correct_made_dead_withCleared,1),nts);
ntiles.fast.errors = prctile(SRT(fast_errors_made_dead_withCleared,1),nts);
ntiles.med.correct = prctile(SRT(med_correct,1),nts);
ntiles.med.errors = prctile(SRT(med_errors,1),nts);



N.slow.correct = length(slow_correct_made_dead);
N.slow.errors = length(slow_errors_made_dead);
N.fast.correct = length(fast_correct_made_dead_withCleared);
N.fast.errors = length(fast_errors_made_dead_withCleared);
N.med.correct = length(med_correct);
N.med.errors = length(med_errors);


nl = .1 * N.slow.correct;
nh = .2 * N.slow.correct;
obs_freq.slow.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * N.slow.errors;
nh = .2 * N.slow.errors;
obs_freq.slow.errors = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * N.fast.correct;
nh = .2 * N.fast.correct;
obs_freq.fast.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * N.fast.errors;
nh = .2 * N.fast.errors;
obs_freq.fast.errors = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * N.med.correct;
nh = .2 * N.med.correct;
obs_freq.med.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * N.med.errors;
nh = .2 * N.med.errors;
obs_freq.med.errors = [nl nh nh nh nh nl];
clear nl nh


A.slow = 10;
A.med = 10;
A.fast = 120;

b = 160;

v.slow = .63;
v.med = .75;
v.fast = .6;

T0.slow = 200.783;
T0.med = 100.917;
T0.fast = 30.07;

leakage = .01;
sd_rate = .1;



%=============
% BOUNDS
%=============
lb.A = [1 1 1];
lb.b = 10000;
lb.v = [.5 .5 .5];
lb.T0 = [50 50 50];

ub.A = [500 500 500];
ub.b = 20000;
ub.v = [1 1 1];
ub.T0 = [800 800 800];


param = [A.slow A.med A.fast b v.slow v.med v.fast T0.slow T0.med T0.fast];
lower = [lb.A lb.b lb.v lb.T0];
upper = [ub.A ub.b ub.v ub.T0];

if minimize
    
    %options = optimset;
    options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    %[solution minval exitflag output] = fminsearch(@(param) iLBA_sim_leaky_integrator_calc_X2(param,ntiles,trls,obs_freq),param,options);
    [solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2(param,ntiles,trls,obs_freq),param,lower,upper,options);
    
    
    %     options = gaoptimset('PopulationSize',[ones(1,numel(param))*30],...
    %         'Generations',10,...
    %         'PopInitRange',initRange,...
    %         'Display','iter', ...
    %         'StallGenLimit',60,'TolFun',.0001, ...
    %         'UseParallel','always', ...
    %         'MutationFcn',{@mutationgaussian,1,1});%, ...
    
    %'PlotInterval',2,'PlotFcns',{ @plot_iLBA_sim_vincentized_fixed_b_ga });%,...
    %'HybridFcn',@fminsearch);
    %[solution minval exitflag output] = ga(@(param) iLBA_sim_leaky_integrator_calc_X2(param,ntiles,trls,obs_freq),numel(param),[],[],[],[],lower,upper,[],options);
    
    
else
    solution = param;
end


if plotFlag
    figure
    
    slow_correct_made_dead = trls.slow.correct;
    slow_errors_made_dead = trls.slow.errors;
    fast_correct_made_dead_withCleared = trls.fast.correct;
    fast_errors_made_dead_withCleared = trls.fast.errors;
    med_correct = trls.med.correct;
    med_errors = trls.med.errors;
    
    
    [A.slow A.med A.fast b v.slow v.med v.fast T0.slow T0.med T0.fast] = disperse(solution);
    b = b * 100;
    
    nTrials = 5000;
    
    
    correct.slow(1:nTrials,1) = NaN;
    correct.fast(1:nTrials,1) = NaN;
    correct.med(1:nTrials,1) = NaN;
    
    rt.slow(1:nTrials,1) = NaN;
    rt.fast(1:nTrials,1) = NaN;
    rt.med(1:nTrials,1) = NaN;
    
    
    %==========================
    % INTEGRATION
    start1.slow = unifrnd(0,A.slow,nTrials,1);
    start1.med = unifrnd(0,A.med,nTrials,1);
    start1.fast = unifrnd(0,A.fast,nTrials,1);
    
    start2.slow = unifrnd(0,A.slow,nTrials,1);
    start2.med = unifrnd(0,A.med,nTrials,1);
    start2.fast = unifrnd(0,A.fast,nTrials,1);
    
    %use absolute value just in case negative drift rate is selected
    rate1.slow = abs(normrnd(v.slow,sd_rate,nTrials,1));
    rate1.med = abs(normrnd(v.med,sd_rate,nTrials,1));
    rate1.fast = abs(normrnd(v.fast,sd_rate,nTrials,1));
    
    rate1.slow(find(rate1.slow > 1)) = .9999;
    rate1.med(find(rate1.med > 1)) = .9999;
    rate1.fast(find(rate1.fast > 1)) = .9999;
    
    rate2.slow = abs(normrnd(1-v.slow,sd_rate,nTrials,1));
    rate2.med = abs(normrnd(1-v.med,sd_rate,nTrials,1));
    rate2.fast = abs(normrnd(1-v.fast,sd_rate,nTrials,1));
    
    
    %generate starting point
    act1.slow = start1.slow;
    act1.med = start1.med;
    act1.fast = start1.fast;
    
    act2.slow = start2.slow;
    act2.med = start2.med;
    act2.fast = start2.fast;
    
    linear1.slow = cumsum([zeros(nTrials,1) repmat(rate1.slow,1,1000)],2) + repmat(start1.slow,1,1001);
    linear1.med = cumsum([zeros(nTrials,1) repmat(rate1.med,1,1000)],2) + repmat(start1.med,1,1001);
    linear1.fast = cumsum([zeros(nTrials,1) repmat(rate1.fast,1,1000)],2) + repmat(start1.fast,1,1001);
    
    linear2.slow = cumsum([zeros(nTrials,1) repmat(rate2.slow,1,1000)],2) + repmat(start2.slow,1,1001);
    linear2.med = cumsum([zeros(nTrials,1) repmat(rate2.med,1,1000)],2) + repmat(start2.med,1,1001);
    linear2.fast = cumsum([zeros(nTrials,1) repmat(rate2.fast,1,1000)],2) + repmat(start2.fast,1,1001);
    
    
%     for t = 2:1000
%         act1.slow(:,t) = act1.slow(:,t-1) + linear1.slow(:,t) - ( leakage.slow .* act1.slow(:,t-1));
%         act1.med(:,t) = act1.med(:,t-1) + linear1.med(:,t) - ( leakage.med .* act1.med(:,t-1));
%         act1.fast(:,t) = act1.fast(:,t-1) + linear1.fast(:,t) - ( leakage.fast .* act1.fast(:,t-1));
%         
%         act2.slow(:,t) = act2.slow(:,t-1) + linear2.slow(:,t) - ( leakage.slow .* act2.slow(:,t-1));
%         act2.med(:,t) = act2.med(:,t-1) + linear2.med(:,t) - ( leakage.med .* act2.med(:,t-1));
%         act2.fast(:,t) = act2.fast(:,t-1) + linear2.fast(:,t) - ( leakage.fast .* act2.fast(:,t-1));
%     end
    
    act1.slow = leaky_integrate(linear1.slow',start1.slow,leakage)';
    act1.med = leaky_integrate(linear1.med',start1.med,leakage)';
    act1.fast = leaky_integrate(linear1.fast',start1.fast,leakage)';
    
    act2.slow = leaky_integrate(linear2.slow',start2.slow,leakage)';
    act2.med = leaky_integrate(linear2.med',start2.med,leakage)';
    act2.fast = leaky_integrate(linear2.fast',start2.fast,leakage)';
    

    cross1.slow = diff(act1.slow > b.slow,1,2);
    cross1.med = diff(act1.med > b.med,1,2);
    cross1.fast = diff(act1.fast > b.fast,1,2);
    
    cross2.slow = diff(act2.slow > b.slow,1,2);
    cross2.med = diff(act2.med > b.med,1,2);
    cross2.fast = diff(act2.fast > b.fast,1,2);
    
    %force threshold crossing at latest point if never found
    force1.slow = find(~any(cross1.slow,2));
    force1.med = find(~any(cross1.med,2));
    force1.fast = find(~any(cross1.fast,2));
    
    force2.slow = find(~any(cross2.slow,2));
    force2.med = find(~any(cross2.med,2));
    force2.fast = find(~any(cross2.fast,2));
    
    cross1.slow(force1.slow,size(cross1.slow,2)) = 1;
    cross1.med(force1.med,size(cross1.med,2)) = 1;
    cross1.fast(force1.fast,size(cross1.fast,2)) = 1;
    
    cross2.slow(force2.slow,size(cross2.slow,2)) = 1;
    cross2.med(force2.med,size(cross2.med,2)) = 1;
    cross2.fast(force2.fast,size(cross2.fast,2)) = 1;
    
    %multiple logical cross1 and cross2 by sequence of column numbers to convert into real time values
    mult_mat = repmat(linspace(1,size(cross1.slow,2),size(cross1.slow,2)),nTrials,1);
    
    cross1.slow = sum(cross1.slow .* mult_mat,2) + 1; % +1 to correct for diff operation earlier
    cross1.med = sum(cross1.med .* mult_mat,2) + 1;
    cross1.fast = sum(cross1.fast .* mult_mat,2) + 1;
    
    cross2.slow = sum(cross2.slow .* mult_mat,2) + 1; % +1 to correct for diff operation earlier
    cross2.med = sum(cross2.med .* mult_mat,2) + 1;
    cross2.fast = sum(cross2.fast .* mult_mat,2) + 1;
    
    rt.slow = min([cross1.slow cross2.slow],[],2);
    rt.med = min([cross1.med cross2.med],[],2);
    rt.fast = min([cross1.fast cross2.fast],[],2);
    
    correct.slow = cross1.slow < cross2.slow;
    correct.med = cross1.med < cross2.med;
    correct.fast = cross1.fast < cross2.fast;
    %===============================
    % END INTEGRATION
    
    
    
    %to get total decision time, add decision time rt + nondecision time T0
    rt.slow = rt.slow + T0.slow;
    rt.fast = rt.fast + T0.fast;
    rt.med = rt.med + T0.med;
    
    
    simTrls.slow.correct = find(correct.slow == 1);
    simTrls.slow.errors = find(correct.slow == 0);
    simTrls.fast.correct = find(correct.fast == 1);
    simTrls.fast.errors = find(correct.fast == 0);
    simTrls.med.correct = find(correct.med == 1);
    simTrls.med.errors = find(correct.med == 0);
    
    
    N.slow.correct = length(slow_correct_made_dead);
    N.slow.errors = length(slow_errors_made_dead);
    N.slow.all = N.slow.correct + N.slow.errors;
    N.fast.correct = length(fast_correct_made_dead_withCleared);
    N.fast.errors = length(fast_errors_made_dead_withCleared);
    N.fast.all = N.fast.correct + N.fast.errors;
    N.med.correct = length(med_correct);
    N.med.errors = length(med_errors);
    N.med.all = length(med_correct) + length(med_errors);
    
    simN.slow.correct = length(simTrls.slow.correct);
    simN.slow.errors = length(simTrls.slow.errors);
    simN.slow.all = simN.slow.correct + simN.slow.errors;
    simN.fast.correct = length(simTrls.fast.correct);
    simN.fast.errors = length(simTrls.fast.errors);
    simN.fast.all = simN.fast.correct + simN.fast.errors;
    simN.med.correct = length(simTrls.med.correct);
    simN.med.errors = length(simTrls.med.errors);
    simN.med.all = simN.med.correct + simN.med.errors;
    
    
    
    pred_prop.slow.correct(1) = length(find(rt.slow(simTrls.slow.correct) <= ntiles.slow.correct(1))) / simN.slow.all;
    pred_prop.slow.correct(2) = length(find(rt.slow(simTrls.slow.correct) > ntiles.slow.correct(1) & rt.slow(simTrls.slow.correct) <= ntiles.slow.correct(2))) / simN.slow.all;
    pred_prop.slow.correct(3) = length(find(rt.slow(simTrls.slow.correct) > ntiles.slow.correct(2) & rt.slow(simTrls.slow.correct) <= ntiles.slow.correct(3))) / simN.slow.all;
    pred_prop.slow.correct(4) = length(find(rt.slow(simTrls.slow.correct) > ntiles.slow.correct(3) & rt.slow(simTrls.slow.correct) <= ntiles.slow.correct(4))) / simN.slow.all;
    pred_prop.slow.correct(5) = length(find(rt.slow(simTrls.slow.correct) > ntiles.slow.correct(4) & rt.slow(simTrls.slow.correct) <= ntiles.slow.correct(5))) / simN.slow.all;
    pred_prop.slow.correct(6) = length(find(rt.slow(simTrls.slow.correct) > ntiles.slow.correct(5))) / simN.slow.all;
    
    pred_prop.slow.errors(1) = length(find(rt.slow(simTrls.slow.errors) <= ntiles.slow.errors(1))) / simN.slow.all;
    pred_prop.slow.errors(2) = length(find(rt.slow(simTrls.slow.errors) > ntiles.slow.errors(1) & rt.slow(simTrls.slow.errors) <= ntiles.slow.errors(2))) / simN.slow.all;
    pred_prop.slow.errors(3) = length(find(rt.slow(simTrls.slow.errors) > ntiles.slow.errors(2) & rt.slow(simTrls.slow.errors) <= ntiles.slow.errors(3))) / simN.slow.all;
    pred_prop.slow.errors(4) = length(find(rt.slow(simTrls.slow.errors) > ntiles.slow.errors(3) & rt.slow(simTrls.slow.errors) <= ntiles.slow.errors(4))) / simN.slow.all;
    pred_prop.slow.errors(5) = length(find(rt.slow(simTrls.slow.errors) > ntiles.slow.errors(4) & rt.slow(simTrls.slow.errors) <= ntiles.slow.errors(5))) / simN.slow.all;
    pred_prop.slow.errors(6) = length(find(rt.slow(simTrls.slow.errors) > ntiles.slow.errors(5))) / simN.slow.all;
    
    pred_prop.fast.correct(1) = length(find(rt.fast(simTrls.fast.correct) <= ntiles.fast.correct(1))) / simN.fast.all;
    pred_prop.fast.correct(2) = length(find(rt.fast(simTrls.fast.correct) > ntiles.fast.correct(1) & rt.fast(simTrls.fast.correct) <= ntiles.fast.correct(2))) / simN.fast.all;
    pred_prop.fast.correct(3) = length(find(rt.fast(simTrls.fast.correct) > ntiles.fast.correct(2) & rt.fast(simTrls.fast.correct) <= ntiles.fast.correct(3))) / simN.fast.all;
    pred_prop.fast.correct(4) = length(find(rt.fast(simTrls.fast.correct) > ntiles.fast.correct(3) & rt.fast(simTrls.fast.correct) <= ntiles.fast.correct(4))) / simN.fast.all;
    pred_prop.fast.correct(5) = length(find(rt.fast(simTrls.fast.correct) > ntiles.fast.correct(4) & rt.fast(simTrls.fast.correct) <= ntiles.fast.correct(5))) / simN.fast.all;
    pred_prop.fast.correct(6) = length(find(rt.fast(simTrls.fast.correct) > ntiles.fast.correct(5))) / simN.fast.all;
    
    pred_prop.fast.errors(1) = length(find(rt.fast(simTrls.fast.errors) <= ntiles.fast.errors(1))) / simN.fast.all;
    pred_prop.fast.errors(2) = length(find(rt.fast(simTrls.fast.errors) > ntiles.fast.errors(1) & rt.fast(simTrls.fast.errors) <= ntiles.fast.errors(2))) / simN.fast.all;
    pred_prop.fast.errors(3) = length(find(rt.fast(simTrls.fast.errors) > ntiles.fast.errors(2) & rt.fast(simTrls.fast.errors) <= ntiles.fast.errors(3))) / simN.fast.all;
    pred_prop.fast.errors(4) = length(find(rt.fast(simTrls.fast.errors) > ntiles.fast.errors(3) & rt.fast(simTrls.fast.errors) <= ntiles.fast.errors(4))) / simN.fast.all;
    pred_prop.fast.errors(5) = length(find(rt.fast(simTrls.fast.errors) > ntiles.fast.errors(4) & rt.fast(simTrls.fast.errors) <= ntiles.fast.errors(5))) / simN.fast.all;
    pred_prop.fast.errors(6) = length(find(rt.fast(simTrls.fast.errors) > ntiles.fast.errors(5))) / simN.fast.all;
    
    pred_prop.med.correct(1) = length(find(rt.med(simTrls.med.correct) <= ntiles.med.correct(1))) / simN.med.all;
    pred_prop.med.correct(2) = length(find(rt.med(simTrls.med.correct) > ntiles.med.correct(1) & rt.med(simTrls.med.correct) <= ntiles.med.correct(2))) / simN.med.all;
    pred_prop.med.correct(3) = length(find(rt.med(simTrls.med.correct) > ntiles.med.correct(2) & rt.med(simTrls.med.correct) <= ntiles.med.correct(3))) / simN.med.all;
    pred_prop.med.correct(4) = length(find(rt.med(simTrls.med.correct) > ntiles.med.correct(3) & rt.med(simTrls.med.correct) <= ntiles.med.correct(4))) / simN.med.all;
    pred_prop.med.correct(5) = length(find(rt.med(simTrls.med.correct) > ntiles.med.correct(4) & rt.med(simTrls.med.correct) <= ntiles.med.correct(5))) / simN.med.all;
    pred_prop.med.correct(6) = length(find(rt.med(simTrls.med.correct) > ntiles.med.correct(5))) / simN.med.all;
    
    pred_prop.med.errors(1) = length(find(rt.med(simTrls.med.errors) <= ntiles.med.errors(1))) / simN.med.all;
    pred_prop.med.errors(2) = length(find(rt.med(simTrls.med.errors) > ntiles.med.errors(1) & rt.med(simTrls.med.errors) <= ntiles.med.errors(2))) / simN.med.all;
    pred_prop.med.errors(3) = length(find(rt.med(simTrls.med.errors) > ntiles.med.errors(2) & rt.med(simTrls.med.errors) <= ntiles.med.errors(3))) / simN.med.all;
    pred_prop.med.errors(4) = length(find(rt.med(simTrls.med.errors) > ntiles.med.errors(3) & rt.med(simTrls.med.errors) <= ntiles.med.errors(4))) / simN.med.all;
    pred_prop.med.errors(5) = length(find(rt.med(simTrls.med.errors) > ntiles.med.errors(4) & rt.med(simTrls.med.errors) <= ntiles.med.errors(5))) / simN.med.all;
    pred_prop.med.errors(6) = length(find(rt.med(simTrls.med.errors) > ntiles.med.errors(5))) / simN.med.all;
    
    
    
    
    pred_freq.slow.correct = pred_prop.slow.correct .* N.slow.all;
    pred_freq.slow.errors = pred_prop.slow.errors .* N.slow.all;
    pred_freq.fast.correct = pred_prop.fast.correct .* N.fast.all;
    pred_freq.fast.errors = pred_prop.fast.errors .* N.fast.all;
    pred_freq.med.correct = pred_prop.med.correct .* N.med.all;
    pred_freq.med.errors = pred_prop.med.errors .* N.med.all;
    
    all_obs = [obs_freq.slow.correct' ; obs_freq.slow.errors' ; obs_freq.med.correct' ; obs_freq.med.errors' ;  obs_freq.fast.correct' ; obs_freq.fast.errors'];
    all_pred = [pred_freq.slow.correct' ; pred_freq.slow.errors' ; pred_freq.med.correct' ; pred_freq.med.errors' ; pred_freq.fast.correct' ; pred_freq.fast.errors'];
    
    all_pred(find(isnan(all_pred))) = 0;
    disp([all_obs all_pred])
    
    X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) )
    
    
    
    obs_prop_correct.slow = N.slow.correct / N.slow.all;
    obs_prop_errors.slow = 1-obs_prop_correct.slow;
    
    obs_prop_correct.fast = N.fast.correct / N.fast.all;
    obs_prop_errors.fast = 1-obs_prop_correct.fast;
    
    obs_prop_correct.med = N.med.correct / N.med.all;
    obs_prop_errors.med = 1-obs_prop_correct.med;
    
    pred_prop_correct.slow = length(simTrls.slow.correct) / (length(simTrls.slow.correct) + length(simTrls.slow.errors));
    pred_prop_errors.slow = 1-pred_prop_correct.slow;
    
    pred_prop_correct.fast = length(simTrls.fast.correct) / (length(simTrls.fast.correct) + length(simTrls.fast.errors));
    pred_prop_errors.fast = 1-pred_prop_correct.fast;
    
    pred_prop_correct.med = length(simTrls.med.correct) / (length(simTrls.med.correct) + length(simTrls.med.errors));
    pred_prop_errors.med = 1-pred_prop_correct.med;
    
    if plotFlag
        subplot(1,3,1)
        hold on
        plot([ntiles.slow.correct],(cumsum(obs_freq.slow.correct)./N.slow.correct)*obs_prop_correct.slow,'ok',[ntiles.slow.errors],(cumsum(obs_freq.slow.errors)./N.slow.errors)*obs_prop_errors.slow,'or')
        plot([ntiles.slow.correct],(cumsum(pred_freq.slow.correct)./N.slow.correct)*pred_prop_correct.slow,'-xk',[ntiles.slow.errors],(cumsum(pred_freq.slow.errors)./N.slow.errors)*pred_prop_errors.slow,'-xr')
        xlim([400 800])
        ylim([0 1])
        
        subplot(1,3,3)
        hold on
        plot([ntiles.fast.correct],(cumsum(obs_freq.fast.correct)./N.fast.correct)*obs_prop_correct.fast,'ok',[ntiles.fast.errors],(cumsum(obs_freq.fast.errors)./N.fast.errors)*obs_prop_errors.fast,'or')
        plot([ntiles.fast.correct],(cumsum(pred_freq.fast.correct)./N.fast.correct)*pred_prop_correct.fast,'-xk',[ntiles.fast.errors],(cumsum(pred_freq.fast.errors)./N.fast.errors)*pred_prop_errors.fast,'-xr')
        xlim([100 500])
        ylim([0 1])
        
        subplot(1,3,2)
        hold on
        plot([ntiles.med.correct],(cumsum(obs_freq.med.correct)./N.med.correct)*obs_prop_correct.med,'ok',[ntiles.med.errors],(cumsum(obs_freq.med.errors)./N.med.errors)*obs_prop_errors.med,'or')
        plot([ntiles.med.correct],(cumsum(pred_freq.med.correct)./N.med.correct)*pred_prop_correct.med,'-xk',[ntiles.med.errors],(cumsum(pred_freq.med.errors)./N.med.errors)*pred_prop_errors.med,'-xr')
        xlim([100 500])
        ylim([0 1])
    end
end