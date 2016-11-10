function unitInfo = ccm_classify_neuron(Data)
%
%
% function neuronTable = ccm_categorize_neuron(Data);
%
%


%%
% unitInfo = Data(1)
% Constants
    

% analyses windows relative to their aligned event
preTargWindow       = -299 : 0;
postTargWindow      = 51 : 125;
preCheckerWindow    = -99 : 0;
postCheckerWindow   = 51 : 150;
saccEarlyWindow       = -99 : -49;
presaccWindow       = -49 : 0;
postsaccWindow      = 41 : 140;
rewardWindow        = 51 : 250;
intertrialWindow    = 251 : 500;



% unitInfo = table();
unitInfo = cell(1, 13);

% unitInfo.sessionID  = {Data.sessionID};
% unitInfo.unit       = {Data.name};
% unitInfo.hemisphere       = {Data.hemisphere};
unitInfo{1}    	= Data.sessionID;
unitInfo{2}    	= Data.name;
unitInfo{3}     = Data.hemisphere;


% Figure out which direction to use to categorize the neuron
% Does this neuron have a saccade response field?
% unitInfo.rf = {ccm_find_saccade_rf(Data)};
unitInfo{4} = ccm_find_saccade_rf(Data);


% if strcmp(unitInfo.rf, 'left')
%     sigInd = 1;
% elseif strcmp(unitInfo.rf, 'right')
%     sigInd = 2;
%     % if there's not a clear RF side, use the contralateral hemifield for
%     % analyses
% elseif strcmp(unitInfo.rf, 'none')
%     switch lower(Data.hemisphere)
%         case 'left'
%             sigInd = 2;
%         case 'right'
%             sigInd = 1;
%     end
% end
% 
if strcmp(unitInfo(4), 'left')
    sigInd = 1;
elseif strcmp(unitInfo(4), 'right')
    sigInd = 2;
    % if there's not a clear RF side, use the contralateral hemifield for
    % analyses
elseif strcmp(unitInfo(4), 'none')
    switch lower(Data.hemisphere)
        case 'left'
            sigInd = 2;
        case 'right'
            sigInd = 1;
    end
end



fixAlign        = Data.targOn.colorCoh(sigInd).goTarg.alignTime;
fixRate         = nansum(Data.targOn.colorCoh(sigInd).goTarg.raster(:,fixAlign + preTargWindow), 2)  .* 1000 ./ length(preTargWindow);

targAlign    = Data.targOn.colorCoh(sigInd).goTarg.alignTime;
targRate     = nansum(Data.targOn.colorCoh(sigInd).goTarg.raster(:,targAlign + postTargWindow), 2)  .* 1000 ./ length(postTargWindow);

preCheckerAlign    = Data.checkerOn.colorCoh(sigInd).goTarg.alignTime;
preCheckerRate     = nansum(Data.checkerOn.colorCoh(sigInd).goTarg.raster(:,preCheckerAlign + preCheckerWindow), 2)  .* 1000 ./ length(preCheckerWindow);

postCheckerAlign    = Data.checkerOn.colorCoh(sigInd).goTarg.alignTime;
postCheckerRate     = nansum(Data.checkerOn.colorCoh(sigInd).goTarg.raster(:,postCheckerAlign + postCheckerWindow), 2)  .* 1000 ./ length(postCheckerWindow);
postCheckerSDF     = nanmean(Data.checkerOn.colorCoh(sigInd).goTarg.sdf(:,postCheckerAlign + postCheckerWindow), 1);

presaccAlign       = Data.responseOnset.colorCoh(sigInd).goTarg.alignTime;
presaccRate        = nansum(Data.responseOnset.colorCoh(sigInd).goTarg.raster(:,presaccAlign + presaccWindow), 2)  .* 1000 ./ length(presaccWindow);
presaccSDF        = nanmean(Data.responseOnset.colorCoh(sigInd).goTarg.sdf(:,presaccAlign + presaccWindow), 1);

presaccEarlyRate        = nansum(Data.responseOnset.colorCoh(sigInd).goTarg.raster(:,presaccAlign + saccEarlyWindow), 2)  .* 1000 ./ length(saccEarlyWindow);

postsaccAlign       = Data.responseOnset.colorCoh(sigInd).goTarg.alignTime;
postsaccRate        = nansum(Data.responseOnset.colorCoh(sigInd).goTarg.raster(:,postsaccAlign + postsaccWindow), 2)  .* 1000 ./ length(postsaccWindow);

rewardAlign       = Data.rewardOn.colorCoh(sigInd).goTarg.alignTime;
rewardRate        = nansum(Data.rewardOn.colorCoh(sigInd).goTarg.raster(:,rewardAlign + rewardWindow), 2)  .* 1000 ./ length(rewardWindow);

intertrialRate        = nansum(Data.rewardOn.colorCoh(sigInd).goTarg.raster(:,rewardAlign + intertrialWindow), 2)  .* 1000 ./ length(intertrialWindow);


fixNeuron           = 0;
visNeuron           = 0;
checkerNeuron       = 0;
presaccNeuron       = 0;
presaccMaxNeuron   	= 0;
presaccRampNeuron  	= 0;
postsaccNeuron      = 0;
rewardNeuron        = 0;
intertrialNeuron	= 0;


% Fixation activity?
if sum([fixRate; presaccRate])
    [h , p]     = ttest2(fixRate , presaccRate , .05);
    if h && mean(fixRate) > mean(presaccRate)
        % spike rate should dip just before saccade (don't include
        % neurons that reduce activity during trial in general)
        [h , p]     = ttest2(preCheckerRate , presaccRate , .05);
        if h && mean(preCheckerRate) > mean(presaccRate)
            fixNeuron = 1;
        end
    end
end


% Get rid of multiunit activity
if mean(fixRate) < 50
    
    % Visual activity?
    if sum([fixRate; targRate])
        [h , p] = ttest2(fixRate , targRate , .05);
        if h && mean(targRate) > mean(fixRate)
            visNeuron = 1;
        end
    end
    
    
    % Checker activity?
    if sum([postCheckerRate; preCheckerRate])
        [h , p] = ttest2(postCheckerRate , preCheckerRate , .05);
        if h && mean(postCheckerRate) > mean(preCheckerRate)
            checkerNeuron = 1;
        end
    end
    
    
    % presaccadic activity? Must be > fixation, and be raming up toward
    % saccade (to distinguish from checker activity carryover)
    if sum([fixRate; presaccRate])
        if max(Data.responseOnset.colorCoh(sigInd).goTarg.sdfMean) > 5
            [h , p] = ttest2(fixRate , presaccRate , .05);
            if h && mean(presaccRate) > mean(fixRate) && ...
                mean(presaccRate)  > mean(presaccEarlyRate)
                    presaccNeuron = 1;
            end
        end
    end
    
    % presaccadic activity that's at least 20% greater than visual activity?
    if presaccNeuron
        if max(Data.responseOnset.colorCoh(sigInd).goTarg.sdfMean) > 1.2 * max(Data.targOn.colorCoh(sigInd).goTarg.sdfMean)
            presaccMaxNeuron = 1;
        end
    end
    
    
    
    % presaccadic ramping activity?
    % A more "pure" saccadic neuron, one that ramps up and isn't dominated
    % by postsaccadic activity
    if presaccNeuron
        if mean(presaccRate) > mean(presaccEarlyRate) * 1.25 &&...
                mean(presaccRate) * 1.25 > mean(postsaccRate)
            presaccRampNeuron = 1;
        end
    end
    
    
    % Postaccadic activity?
    if sum([fixRate; postsaccRate])
        [h , p] = ttest2(fixRate , postsaccRate , .05);
        if h && mean(postsaccRate) > mean(fixRate)
            [h , p] = ttest2(presaccRate , postsaccRate , .05);
            if h && mean(postsaccRate) > mean(presaccRate)
                postsaccNeuron = 1;
            end
        end
    end
    
    
    % Reward activity?
    if sum([fixRate; rewardRate])
        [h , p] = ttest2(fixRate , rewardRate , .05);
        if h && mean(rewardRate) > mean(fixRate)
            rewardNeuron = 1;
        end
    end
    
    
    % Intertrial activity?
    if sum([fixRate; intertrialRate])
        [h , p] = ttest2(fixRate , intertrialRate , .05);
        if h && mean(intertrialRate) > mean(fixRate)
            intertrialNeuron = 1;
        end
    end
    
end

% unitInfo.fix        = fixNeuron;
% unitInfo.vis        = visNeuron;
% unitInfo.checker    = checkerNeuron;
% unitInfo.presacc    = presaccNeuron;
% unitInfo.presaccMax    = presaccMaxNeuron;
% unitInfo.presaccRamp = presaccRampNeuron;
% unitInfo.postsacc   = postsaccNeuron;
% unitInfo.reward     = rewardNeuron;
% unitInfo.intertrial = intertrialNeuron;

unitInfo{5} = fixNeuron;
unitInfo{6} = visNeuron;
unitInfo{7} = checkerNeuron;
unitInfo{8} = presaccNeuron;
unitInfo{9} = presaccMaxNeuron;
unitInfo{10} = presaccRampNeuron;
unitInfo{11} = postsaccNeuron;
unitInfo{12} = rewardNeuron;
unitInfo{13} = intertrialNeuron;
% 

