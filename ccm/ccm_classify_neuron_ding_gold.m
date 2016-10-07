function unitInfo = ccm_classify_neuron_ding_gold(Data)
%
%
% function neuronTable = ccm_classify_neuron_ding_gold(Data);
%
% Classify neurons according to the criteria of Ding & Gold 2012 Cereb Ctx.
% They query "choice" and "coherence" dependence within 4 defined epochs:
% Stim, Sacc, Post, Reward.


%%
% Define the four epochs
epochs = {'Stim', 'Sacc', 'Post', 'Reward'};
epochWindows = {81:150, -49 : 0, 41:140, 51:250};
epochAlign = {'checkerOn', 'responseOnset', 'responseOnset', 'rewardOn'};
rasterWindow = -499: 500;
epochAlignInd = -rasterWindow(1);

% Define analyses windows relative to their aligned event
postCheckerWindow   = 51 : 150;
saccEarlyWindow       = -49 : -35;
saccLateWindow       = -14 : 0;
presaccWindow       = -49 : 0;
postsaccWindow      = 41 : 140;
rewardWindow        = 51 : 250;


% These will determine the trial-to-trial epochs used for analyses:
preSaccadeBuffer = 20;

% Initialize the table and add session information
unitInfo = table();






for i = 1 : length(epochs)
    
    % Initialize table row
    iUnitInfo = table();
    iUnitInfo.sessionID  = {Data.sessionID};
    iUnitInfo.unit       = {Data.name};
    iUnitInfo.hemisphere       = {Data.hemisphere};
    
    % Loop through color coherence (singal strength) values and build
    % vectors of relevant things to send to ding_gold_ddm_like.m
    iSpikeRate       = [];
    iColorCoherence  = [];
    iAlignedRasters  = {};
    
    for j = 1 : length(Data.pSignalArray)
        
        nTrial = length(Data.signalStrength(j).goTarg.rt);
        jAlign = Data.signalStrength(j).goTarg.(epochAlign{i}).alignTime;
        jRaster = num2cell(Data.signalStrength(j).goTarg.(epochAlign{i}).raster(:, jAlign + rasterWindow), 2);
        
        switch epochs{i}
            % If we're dealing with the Stim epoch, want to define the end of
            % the epoch with respect to median RT for a given side and
            % trial-by-trial RTs for RTs less than the median RT
            case 'Stim'
                epochBegin = epochAlignInd + epochWindows{i}(1) * ones(nTrial, 1);
                if Data.pSignalArray(j) < .5
                    medianRT = round(nanmedian(Data.signalStrength(1).goTarg.rt));
                else
                    medianRT = round(median(Data.signalStrength(end).goTarg.rt));
                end
                % Initialize epochEnd as xx ms (preSaccadeBuffer) before
                % median RT
                epochEnd = epochAlignInd + medianRT * ones(nTrial, 1) - preSaccadeBuffer;
                
                % Replace the saccade-before-medianRT trials with the short
                % RTs
                earlySaccTrial = Data.signalStrength(j).goTarg.rt < medianRT;
                epochEnd(earlySaccTrial) = epochAlignInd + Data.signalStrength(j).goTarg.rt(earlySaccTrial) - preSaccadeBuffer;
                
                % Make sure epoch doesn't extend beyond length of rasters
                epochEnd(epochEnd > length(jRaster{1})) = length(jRaster{1}); 

                nSpike = cellfun(@(x,y,z) sum(x(y:z)), jRaster, num2cell(epochBegin), num2cell(epochEnd));
                jSpikeRate = nSpike .* 1000 ./ (epochEnd - epochBegin);
                
            otherwise
                epochBegin = epochAlignInd + epochWindows{i}(1) * ones(nTrial, 1);
                epochEnd = epochAlignInd + epochWindows{i}(end) * ones(nTrial, 1);
                nSpike = cellfun(@(x,y,z) sum(x(y:z)), jRaster, num2cell(epochBegin), num2cell(epochEnd));
                jSpikeRate = nSpike .* 1000 ./ (epochWindows{i}(end) - epochWindows{i}(1));
        end
        
        
        iColorCoherence = [iColorCoherence; Data.pSignalArray(j) * ones(nTrial, 1)];
        iAlignedRasters = [iAlignedRasters; jRaster];
        iSpikeRate = [iSpikeRate; jSpikeRate];
    end
    
    
    iLeftTrial = iColorCoherence < 0.5;
    iRightTrial = iColorCoherence > 0.5;
    
    
    Unit.spikeRate      = iSpikeRate;
    Unit.leftTrial      = iLeftTrial;
    Unit.rightTrial     = iRightTrial;
    Unit.signalP        = iColorCoherence;
    Unit.alignedRasters = iAlignedRasters;
    Unit.alignIndex     = epochAlignInd;
    Unit.epochOffset    = epochWindows{i}(1);
    
    
    [ddmData] = ding_gold_ddm_like(Unit);
    
    
    iUnitInfo.epoch = epochs(i);
    iUnitInfo.choice = ddmData.choiceDependent;
    iUnitInfo.coherehce = ddmData.coherenceDependent;
    iUnitInfo.ddm = ddmData.ddmLike; % true if this activity counts as ddm-like, false if not
    iUnitInfo.tChoice = ddmData.tChoice; % true if this activity counts as ddm-like, false if not
    iUnitInfo.leftIsIn = ddmData.leftIsIn; % true of left direction counts as into RF, false if not
    iUnitInfo.coeffIn = ddmData.coeffIn;  % regression coefficients into RF
    iUnitInfo.coeffOut = ddmData.coeffOut; % regression coefficients out of RF
    
    unitInfo = [unitInfo; iUnitInfo];
end


