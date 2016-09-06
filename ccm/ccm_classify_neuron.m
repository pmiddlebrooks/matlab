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
postTargWindow      = 51 : 150;
preCheckerWindow    = -99 : 0;
postCheckerWindow   = 51 : 150;
saccEarlyWindow       = -49 : -35;
saccLateWindow       = -14 : 0;
preSaccWindow       = -49 : 0;
postSaccWindow      = 41 : 140;
rewardWindow        = 51 : 250;
intertrialWindow    = 251 : 500;




unitInfo = table();

unitInfo.sessionID  = {Data.sessionID};
unitInfo.unit       = {Data.name};
unitInfo.hemisphere       = {Data.hemisphere};



% Figure out which direction to use to categorize the neuron
% Does this neuron have a saccade response field?
unitInfo.rf = ccm_find_saccade_rf(Data);


if strcmp(unitInfo.rf, 'left')
    sigInd = 1;
elseif strcmp(unitInfo.rf, 'right')
    sigInd = 2;
    % if there's not a clear RF side, use the contralateral hemifield for
    % analyses
elseif strcmp(unitInfo.rf, 'none')
    switch lower(Data.hemisphere)
        case 'left'
            sigInd = 2;
        case 'right'
            sigInd = 1;
    end
end



fixAlign        = Data.signalStrength(sigInd).goTarg.targOn.alignTime;
fixRate         = nansum(Data.signalStrength(sigInd).goTarg.targOn.raster(:,fixAlign + preTargWindow), 2)  .* 1000 ./ length(preTargWindow);

targAlign    = Data.signalStrength(sigInd).goTarg.targOn.alignTime;
targRate     = nansum(Data.signalStrength(sigInd).goTarg.targOn.raster(:,targAlign + postTargWindow), 2)  .* 1000 ./ length(postTargWindow);

preCheckerAlign    = Data.signalStrength(sigInd).goTarg.checkerOn.alignTime;
preCheckerRate     = nansum(Data.signalStrength(sigInd).goTarg.checkerOn.raster(:,preCheckerAlign + preCheckerWindow), 2)  .* 1000 ./ length(preCheckerWindow);

postCheckerAlign    = Data.signalStrength(sigInd).goTarg.checkerOn.alignTime;
postCheckerRate     = nansum(Data.signalStrength(sigInd).goTarg.checkerOn.raster(:,postCheckerAlign + postCheckerWindow), 2)  .* 1000 ./ length(postCheckerWindow);

preSaccAlign       = Data.signalStrength(sigInd).goTarg.responseOnset.alignTime;
preSaccRate        = nansum(Data.signalStrength(sigInd).goTarg.responseOnset.raster(:,preSaccAlign + preSaccWindow), 2)  .* 1000 ./ length(preSaccWindow);

preSaccEarlyRate        = nansum(Data.signalStrength(sigInd).goTarg.responseOnset.raster(:,preSaccAlign + saccEarlyWindow), 2)  .* 1000 ./ length(saccEarlyWindow);
preSaccLateRate        = nansum(Data.signalStrength(sigInd).goTarg.responseOnset.raster(:,preSaccAlign + saccLateWindow), 2)  .* 1000 ./ length(saccLateWindow);

postSaccAlign       = Data.signalStrength(sigInd).goTarg.responseOnset.alignTime;
postSaccRate        = nansum(Data.signalStrength(sigInd).goTarg.responseOnset.raster(:,postSaccAlign + postSaccWindow), 2)  .* 1000 ./ length(postSaccWindow);

rewardAlign       = Data.signalStrength(sigInd).goTarg.rewardOn.alignTime;
rewardRate        = nansum(Data.signalStrength(sigInd).goTarg.rewardOn.raster(:,rewardAlign + rewardWindow), 2)  .* 1000 ./ length(rewardWindow);

intertrialRate        = nansum(Data.signalStrength(sigInd).goTarg.rewardOn.raster(:,rewardAlign + intertrialWindow), 2)  .* 1000 ./ length(intertrialWindow);


fixNeuron           = 0;
visNeuron           = 0;
checkerNeuron       = 0;
preSaccNeuron       = 0;
ddmNeuron           = 0;
preSaccRampNeuron  	= 0;
postSaccNeuron      = 0;
rewardNeuron        = 0;
intertrialNeuron	= 0;

% Get rid of multiunit activity
if mean(fixRate) < 50
    
    % Fixation activity?
    if sum([fixRate; preSaccRate])
        [h , p]     = ttest2(fixRate , preSaccRate , .05);
        if h && mean(fixRate) > mean(preSaccRate)
            fixNeuron = 1;
        end
    end
    
    
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
    
    
    % Presaccadic activity?
    if sum([fixRate; preSaccRate])
        if max(Data.signalStrength(sigInd).goTarg.responseOnset.sdfMean) > 10
%             if mean(preSaccRate) > mean(fixRate) + 3 * std(fixRate)
                    [h , p] = ttest2(fixRate , preSaccRate , .05);
                    if h && mean(preSaccRate) > mean(fixRate)
                [h , p] = ttest2(postCheckerRate , preSaccRate , .05);
                if h && mean(preSaccRate) > mean(postCheckerRate)
%                     if mean(preSaccRate) > mean(postSaccRate)
                        preSaccNeuron = 1;
%                     end
                end
                    end
%             end
        end
    end
    
    
     % Drift diffusion-like activity?
    if preSaccNeuron
        ddmLike = ccm_ddm_like(Data.subjectID, Data.sessionID, 'plotFlag', 0, 'unitArray', Data.name);
        if ddmLike
            ddmNeuron = 1;
        end
    end
    
    
    % Presaccadic ramping activity?
    % A more "pure" saccadic neuron, one that ramps up and isn't dominated
    % by postsaccadic activity
    if preSaccNeuron
        if mean(preSaccLateRate) > mean(preSaccEarlyRate) * 1.25 &&...
                mean(preSaccLateRate) * 1.25 > mean(postSaccRate)
            preSaccRampNeuron = 1;
        end
    end
    
    
    % Postaccadic activity?
    if sum([fixRate; postSaccRate])
        [h , p] = ttest2(fixRate , postSaccRate , .05);
        if h && mean(postSaccRate) > mean(fixRate)
            [h , p] = ttest2(preSaccRate , postSaccRate , .05);
            if h && mean(postSaccRate) > mean(preSaccRate)
                postSaccNeuron = 1;
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

unitInfo.fix        = fixNeuron;
unitInfo.vis        = visNeuron;
unitInfo.checker    = checkerNeuron;
unitInfo.presacc    = preSaccNeuron;
unitInfo.ddm        = ddmNeuron;
unitInfo.presaccRamp = preSaccRampNeuron; 
unitInfo.postsacc   = postSaccNeuron;
unitInfo.reward     = rewardNeuron;
unitInfo.intertrial = intertrialNeuron;


