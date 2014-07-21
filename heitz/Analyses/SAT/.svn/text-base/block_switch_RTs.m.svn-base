%plots RTs around time of block switches
%take note that not all trials will have been correct, nor are they always
%of a made deadline

%keep first column only of SRT for indexing purposes
function [RTs] = block_switch_RTs(plotFlag)

if nargin < 1; plotFlag = 1; end

SRT = evalin('caller','SRT');
SAT_ = evalin('caller','SAT_');

curr_SRT = SRT(:,1);


blk_switch = find(abs(diff(SAT_(:,1))) ~= 0) + 1;

%find corresponding conditions
fast_to_slow = blk_switch(find(SAT_(blk_switch-1,1) == 3 & SAT_(blk_switch,1) == 1));
slow_to_fast = blk_switch(find(SAT_(blk_switch-1,1) == 1 & SAT_(blk_switch,1) == 3));

slow_to_med = blk_switch(find(SAT_(blk_switch-1,1) == 1 & SAT_(blk_switch,1) == 2));

if ~isempty(slow_to_med)
    med_included = 1;
else
    med_included = 0;
end

med_to_fast = blk_switch(find(SAT_(blk_switch-1,1) == 2 & SAT_(blk_switch,1) == 3));


lag_window = -2:2;

%================================
%5 trial window centered on switch

%FAST to SLOW
fast_to_slow = repmat(fast_to_slow,1,5);
fast_to_slow = fast_to_slow + repmat(lag_window,size(fast_to_slow,1),1);
fast_to_slow(any(fast_to_slow > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

RTs.fast_to_slow = curr_SRT(fast_to_slow);

%SLOW to FAST
slow_to_fast = repmat(slow_to_fast,1,5);
slow_to_fast = slow_to_fast + repmat(lag_window,size(slow_to_fast,1),1);
slow_to_fast(any(slow_to_fast > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

%if first trial happens to be close to block switch, will fail.  Remove if
%so.  This was done primarily for training sessions w/ flipCond == 3 (e.g.,
%S0217001_SEARCH
if length(slow_to_fast) > 0 && length(find(slow_to_fast(1,:) == 0)) > 0
    slow_to_fast(1,:) = [];
end

RTs.slow_to_fast = curr_SRT(slow_to_fast);


%SLOW to MED
slow_to_med = repmat(slow_to_med,1,5);
slow_to_med = slow_to_med + repmat(lag_window,size(slow_to_med,1),1);
slow_to_med(any(slow_to_med > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

RTs.slow_to_med = curr_SRT(slow_to_med);

%MED to FAST
med_to_fast = repmat(med_to_fast,1,5);
med_to_fast = med_to_fast + repmat(lag_window,size(med_to_fast,1),1);
med_to_fast(any(med_to_fast > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

RTs.med_to_fast = curr_SRT(med_to_fast);

if plotFlag
    if med_included == 0
        % SESSIONS NOT INCLUDING MEDIUM
        figure
        fon
        plot(-2:2,RTs.slow_to_fast,'r',-2:2,RTs.fast_to_slow,'g')
        set(gca,'xtick',-2:2)
        xlabel('Trials from Block Switch')
        ylabel('RT (ms)')
        legend('Slow to Fast','Fast to Slow','location','northwest')
        y = ylim;
        
        hold on
        plot(-2:2,nanmean(RTs.slow_to_fast),'k',-2:2,nanmean(RTs.fast_to_slow),'--k','linewidth',2)
        box off
    else
        % SESSIONS INCLUDING MEDIUM
        figure
        fon
        plot(-2:2,RTs.slow_to_med,'r',-2:2,RTs.med_to_fast,'k',-2:2,RTs.fast_to_slow,'g')
        set(gca,'xtick',-2:2)
        xlabel('Trials from Block Switch')
        ylabel('RT (ms)')
        y = ylim;
        
        hold on
        plot(-2:2,nanmean(RTs.slow_to_med),'k',-2:2,nanmean(RTs.med_to_fast),'--k',-2:2,nanmean(RTs.fast_to_slow),':k','linewidth',2)
        legend('Slow to Med','Med to Fast','Fast to Slow','location','northwest')
        box off
    end
end