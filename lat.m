function data = lat(goRT, stopRT, nStopCorrect)

debug = 1;

%%
Unit = ccm_single_neuron('Broca','bp093n02', 'plotFlag', 0);
[trialData, SessionData, pSignalArray , ssdArray] = load_data('Broca', 'bp093n02');
%%
sigInd = 6;
dataGoTarg    = ccm_concat_neural_conditions(Unit(1), 'checkerOn', 'responseOnset', {'goTarg'}, pSignalArray(sigInd), ssdArray);
dataStopTarg    = ccm_concat_neural_conditions(Unit(1), 'checkerOn', 'responseOnset', {'stopTarg'}, pSignalArray(sigInd), ssdArray);
dataStopStop    = ccm_concat_neural_conditions(Unit(1), 'checkerOn', 'checkerOn', {'stopCorrect'}, pSignalArray(sigInd), ssdArray);

%%
nStopCorrect = size(dataStopStop.raster, 1);

goRT    = dataGoTarg.eventLatency;
stopRT  = dataStopTarg.eventLatency;

nGo       = length(goRT);
nStopTarg = length(stopRT);

% Get a random sample of the go trials (and RTs) equal in length to the stop trials
goTrial   = randperm(nGo);
goTrialSample   = goTrial(1 : nStopTarg + nStopCorrect);
goRTSample      = goRT(goTrialSample);

%%
% Create grid of all possible go/stop RT pairs, and a matrix of the go
% trial number available
[goMeshRT, stopMeshRT]      = meshgrid(goRTSample, stopRT);
[goMeshTrial, stopMeshTrial] = meshgrid(goTrialSample, 1:nStopTarg);

% Take the difference between each possible pair to find the lowest
% difference (nearest-neighbor matched RTs)
[deltaRT, ind] = sort(abs(goMeshRT(:) - stopMeshRT(:)));

% Sort trials in in same order as sorted deltaRT
goMeshTrial     = goMeshTrial(ind);
stopMeshTrial   = stopMeshTrial(ind);
goMeshRT        = goMeshRT(ind);
stopMeshRT      = stopMeshRT(ind);

%%
% Loop through the trials with lowest matched RT differences, and build a
% list of those trials without repeats
goFastTrial    = nan(nStopTarg, 1);
stopMatchTrial  = nan(nStopTarg, 1);
goFastRT       = nan(nStopTarg, 1);
stopMatchRT     = nan(nStopTarg, 1);
i = 1;
matchInd = 1;
while sum(isnan(goFastTrial))
    if ~ismember(goMeshTrial(i), goFastTrial) && ~ismember(stopMeshTrial(i), stopMatchTrial)
        goFastTrial(matchInd)      = goMeshTrial(i);
        stopMatchTrial(matchInd)    = stopMeshTrial(i);
        goFastRT(matchInd)         = goMeshRT(i);
        stopMatchRT(matchInd)       = stopMeshRT(i);
        matchInd = matchInd + 1;
    end
    i = i + 1;
end
goSlowTrial = setdiff(unique(goMeshTrial), goFastTrial);
goSlowRT = goRT(goSlowTrial);

%%

%__________________________________________________________________________
% 1) Match the number of nostop and stop trials at each target
nStopGo = length(stopRT);

% Randomly select a portion of the go trials to use so nGo = nStop. Make
% sure there aren't more stop trials than go trials (and in that case
% randomly select a portion of the stop trials to match the go trials)
nGo       = length(goRT);
goTrial   = randperm(nGo);
goTrial   = goTrial(1 : nStopGo + nStopCorrect);
goRT        = goRT(goTrial);




canceled_id      = 1; %used as identification below
noncanceled_id   = 2; %ditto

% 1a) get trial types
nostop                          = sort(nonzeros(GOCorrect));
noncanceled                     = sort(nonzeros([NOGOWrong;NOGOEarly]));
canceled                        = sort(nonzeros(NOGOCorrect));
stop_trials                     = [canceled;noncanceled];
stop_id                         = nan(size(stop_trials));
stop_id(1:length(canceled))     = canceled_id;
stop_id(length(canceled)+1:end) = noncanceled_id;

% 1b) get set to loop through all tagets
trial_targs                 = Infos_.Curr_target;
targ_list                   = unique(trial_targs);
targ_list(isnan(targ_list)) = [];
nostop_bytarg               = nan(length(nostop),length(targ_list));
stop_bytarg                 = nan(length(stop_trials),length(targ_list));
stop_id_bytarg              = nan(length(stop_trials),length(targ_list));

% 1c) subsample to match trial type numbers at each target
for ii = 1:length(targ_list)
    
    curr_targ    = targ_list(ii);
    curr_nostop  = nostop(trial_targs(nostop) == curr_targ);
    curr_stop    = stop_trials(trial_targs(stop_trials) == curr_targ,:);
    curr_stop_id = stop_id(trial_targs(stop_trials) == curr_targ,:);
    
    if length(curr_nostop) > length(curr_stop) % if we have more nostop trials to the current target
        
        curr_nostop = curr_nostop(randperm(length(curr_nostop))); % shuffle the nostop trials
        curr_nostop = sort(curr_nostop(1:length(curr_stop))); % and draw the top n from the deck
        
    elseif length(curr_nostop) < length(curr_stop) % but if we have more stop trials
        
        shuffle      = randperm(length(curr_stop));
        curr_stop    = curr_stop(shuffle); % shuffle the stop trials
        curr_stop    = curr_stop(1:length(curr_nostop)); % and draw the top n from the deck
        curr_stop_id = curr_stop_id(shuffle);
        curr_stop_id = curr_stop_id(1:length(curr_nostop));
        
    end
    
    nostop_bytarg(1:length(curr_nostop),ii) = curr_nostop; % place the downsampled data back into matrices
    stop_bytarg(1:length(curr_stop),ii)     = curr_stop;
    stop_id_bytarg(1:length(curr_stop),ii)  = curr_stop_id;
    
end

% 1d) revectorize (leave mixed up for operations below)
nostop                = nostop_bytarg(:);
nostop(isnan(nostop)) = [];
stop_trials           = stop_bytarg(:);
stop_id               = stop_id_bytarg(:);
canceled              = stop_trials(stop_id == canceled_id);
noncanceled           = stop_trials(stop_id == noncanceled_id);

if length(canceled) + length(noncanceled) ~= length(nostop)
    fprintf('\nERROR: David screwed up. PANIC! PANIC!\n')
    return
end



%__________________________________________________________________________
% 2) Find the closest matching error and correct RTs
RTs             = Sacc_of_interest(:,1) - Target_(:,1);
RTs_nostop      = RTs(nostop);
RTs_noncanceled = RTs(noncanceled)';

% 2a) Do matrix subtraction to find closest matches
RTs_nostop      = repmat(RTs_nostop,1,length(RTs_noncanceled));
RTs_noncanceled = repmat(RTs_noncanceled,length(RTs_nostop(:,1)),1);
RT_match        = abs(RTs_nostop - RTs_noncanceled);

% 2b) Match them using a traveling salesman approach
fast_nostop   = nan(size(noncanceled));
RT_difference = 0;
ct = 0;
while isnan(sum(fast_nostop))
    
    % get indices of closest matching RTs
    [nostop_i noncan_j] = find(RT_match == RT_difference);
    
    %remove repeats from both indices
    [nostop_i rows] = unique(nostop_i);
    noncan_j        = noncan_j(rows);
    [noncan_j rows] = unique(noncan_j);
    nostop_i        = nostop_i(rows);
    
    %row indices tell us where latency matched RTs are
    fast_nostop(ct+1:length(nostop_i)+ct) = nostop(nostop_i);
    
    %strike out the matches we find so that we don't get repeats
    RT_match(nostop_i,:) = nan;
    RT_match(:,noncan_j) = nan;
    
    ct = ct + length(nostop_i);
    RT_difference = RT_difference + 1;
    
end

slow_nostop = setdiff(nostop,fast_nostop);



%__________________________________________________________________________
% 3) Put all of the indices back into Schall lab standard format
GOCorrect_used   = sort_by_targ(sort(nostop),Infos_);
GOCorrect_fast   = sort_by_targ(sort(fast_nostop),Infos_);
GOCorrect_slow   = sort_by_targ(sort(slow_nostop),Infos_);
NOGOCorrect_used = Veits_Formatting(sort(canceled),Infos_);
NOGOWrong_used   = Veits_Formatting(sort(noncanceled),Infos_);


if debug
    
    figure
    hold on    
    set(gca,'fontsize',20)
    xlabel('RT(ms)')
    ylabel('Cum pr')
    
    curr_var = RTs(nostop);    
    y = 1/length(curr_var):1/length(curr_var):1;
    plot(sort(curr_var),y,'k','linewidth',2)
    
    curr_var = RTs(noncanceled);
    y = 1/length(curr_var):1/length(curr_var):1;
    plot(sort(curr_var),y,'r','linewidth',2)
    
    curr_var = RTs(fast_nostop);
    y = 1/length(curr_var):1/length(curr_var):1;
    plot(sort(curr_var),y,'k:','linewidth',3)
    
    curr_var = RTs(slow_nostop);
    y = 1/length(curr_var):1/length(curr_var):1;
    plot(sort(curr_var),y,'b','linewidth',2)
    
    h = legend('no-stop','noncanceled','no-stop lat matched','canceled RT estimate');
    set(h,'Location','SouthEast','fontsize',16,'box','off')
    
    xlim([0 1000])
    
end




function [formatted_var] = sort_by_targ(var2_format,Infos_)
% [formatted_var] = sort_by_targ(var2_format,Infos_)
%
% This function reformats variables like GOCorrect after you have taken 
% them out of the standard formatting to use them as indices or something 
% else.  This is helpful becuase it allows variables you create to be fed 
% into functions (like getInh.m) which call for standard formatting (rows,
% targets)
%  
% INPUT:
%     var2_format      = the variable representing trials of a given type 
%                        which is not in (row,target) format
%     Infos_           = the underscore variable of that name
% 
% OUTPUT:
%     formatted_var    = the variable you entered in (row,target) 
%                        format 
% 
% See also stoptrues Cstandard getInh sort_by_targ Veits_Formatting

if isstruct(Infos_)
    targs     = sort(unique(Infos_.Curr_target));
    var_targs = Infos_.Curr_target(var2_format);
else
    targs     = sort(unique(Infos_(:,2)));
    var_targs = Infos_(var2_format,2);
end

formatted_var = zeros(1,length(targs));

for targ_num = 1:length(targs)
    curr_targ = targs(targ_num);

    temp = var2_format(var_targs == curr_targ);
    formatted_var(1:length(temp),targ_num) = temp;

end




function [formatted_var] = Veits_Formatting(var2_format,Infos_,ideal_SSDs)
% [formatted_var] = Veits_Formatting(var2_format,Infos_)
%
% This function reformats variables like NOGOWrong after you have taken
% them out of the standard formatting to use them as indices or something
% else.  This is helpful because it allows variables you create to be fed
% into functions (like getInh.m) which call for standard formatting (rows,
% targets, SSDs)
%
% INPUT:
%     var2_format      = the variable representing trials of a given type
%                        which is not in (row,target,SSD) format
%     Infos_           = the underscore variable of that name
%
% OUTPUT:
%     formatted_var    = the variable you entered in (row,target,SSD)
%                        format
%
% See also stoptrues Cstandard getInh and sort_by_targ
if nargin < 3
    if ~isstruct(Infos_)
        allSSDs   = Infos_(:,17);
        allSSDs(Infos_(:,10) == 0) = nan;
        SSDs      = unique(Infos_(:,17));
        SSDs(isnan(SSDs)) = [];
    else
        allSSDs = Infos_.Curr_SSD;
        SSDs = unique(allSSDs);
    end
else
    SSDs = ideal_SSDs;
end

SSDs(isnan(SSDs)) = [];

if isstruct(Infos_)
    targs     = sort(unique(Infos_.Curr_target));
    var_SSDs  = Infos_.Curr_SSD(var2_format);
    var_targs = Infos_.Curr_target(var2_format);
else
    targs     = unique(Infos_(:,2));
    var_SSDs  = Infos_(var2_format,17);
    var_targs = Infos_(var2_format,2);
end

formatted_var = zeros(1,length(targs),length(SSDs));

for ssd_num = 1:length(SSDs)
    curr_SSD = SSDs(ssd_num);
    for targ_num = 1:length(targs)
        curr_targ = targs(targ_num);
        
        temp = var2_format(var_SSDs == curr_SSD & var_targs == curr_targ);
        if ~isempty (temp)
            formatted_var(1:length(temp),targ_num,ssd_num) = temp;
        end
        
    end
end



