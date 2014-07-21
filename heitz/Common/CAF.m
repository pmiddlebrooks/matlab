% function to generate Conditional Accuracy Functions (CAFs) based on some
% criteria determined prior to function call (relevant_trials should hold
% this information)

% RPH


function [RT_bins,acc_bins,n_bins] = CAF(SRT,nBins,plotFlag,trls)

Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
Target_ = evalin('caller','Target_');


if isempty(trls)
    RT_bins(1:nBins) = NaN;
    acc_bins(1:nBins) = NaN;
    n_bins(1:nBins) = NaN;
end


%for SAT conditions, modify accuracy rates to take into account missed
%deadlines.
Correct_(find(Errors_(:,6) == 1),2) = 1;
Correct_(find(Errors_(:,7) == 1),2) = 1;


RTs = SRT(trls,1);
accs = Correct_(trls,2);


%compute intervals
%NOTE: this is a dirty way of accomplishing binning, and the last bin will
%not have the same number of observations as all the preceding bins!!!!
% bin_step = 100 / nBins-1; %need to subtract 1 because the last bin is always the max value, which has an n of 1. So if you want 5 bins, you actually need 4 percentile scores
% 
% j = 1;
% for i = bin_step:bin_step:100
%     percentile_array(j) = prctile(RTs,i);
%     j = j + 1;
% end
% 
% %set up trials
% RT_bins(1) = nanmean(RTs(find(RTs <= percentile_array(1)),1)); %do first bin manually
% acc_bins(1) = nanmean(accs(find(RTs <= percentile_array(1)),1));
% n_bins(1) = length(RTs(find(RTs <= percentile_array(1)),1));
% 
% for bin = 2:nBins-1
%     RT_bins(bin) = nanmean(RTs(find(RTs > percentile_array(bin-1) & RTs <= percentile_array(bin)),1));
%     acc_bins(bin) = nanmean(accs(find(RTs > percentile_array(bin-1) & RTs <= percentile_array(bin)),1));
%     n_bins(bin) = length(RTs(find(RTs > percentile_array(bin-1) & RTs <= percentile_array(bin)),1));
%     
% end
% 
% RT_bins(nBins) = nanmean(RTs(find(RTs >= percentile_array(nBins-1)),1)); %do last bin manually
% acc_bins(nBins) = nanmean(accs(find(RTs >= percentile_array(nBins-1)),1));
% n_bins(nBins) = length(RTs(find(RTs >= percentile_array(nBins-1)),1));
% 



bin_step = 100 / nBins;

percentile_array = prctile(RTs,[0:bin_step:100]);


for bin = 1:length(percentile_array)-1
    trls = find(RTs >= percentile_array(bin) & RTs < percentile_array(bin+1));
    RT_bins(bin) = nanmean(RTs(trls));
    acc_bins(bin) = nanmean(accs(trls));
    odds(bin) = (length(find(accs(trls) == 1)) / length(find(accs(trls) == 0)));
    n_bins(bin) = length(trls);
end


if plotFlag == 1
    figure
    subplot(121)
    plot(RT_bins,acc_bins,'-o')
    ylim([.5 1])
    ylabel('Percent Correct')
    xlabel('RT (ms)')
    
    subplot(122)
    [A h1 h2] = plotyy(RT_bins,odds,RT_bins,odds);
    ylim1 = get(A(1),'ylim');
    set(h1,'linestyle','-','color','b','marker','o')
    set(h2,'linestyle','-','color','b')
    
    set(A(2),'ylim')
    set(A(1:2),'yscale','log')
    set(A(1:2),'YTick',linspace(1,11,11))
    %make right axis the equivalent percent correct
    rightY = 1 - round((1 ./ (1+linspace(1,11,11)))*100)/100;
    set(A(2),'YTickLabel',rightY)
    ylabel('Odds (log scale)')
    xlabel('RT (ms)')
end