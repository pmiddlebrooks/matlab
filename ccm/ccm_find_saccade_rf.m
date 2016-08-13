function rf = ccm_find_saccade_rf(Data)
%
% function rf = find_saccade_rf(Data);
%

% analyses windows relative to their aligned event
preTargWindow       = -299 : -1;
postCheckerWindow   = 50 : 150;
preSaccWindow       = -49 : 0;



rf = {'none'}; % Default is no RF

leftFixAlign        = Data.signalStrength(1).goTarg.targOn.alignTime;
rightFixAlign       = Data.signalStrength(2).goTarg.targOn.alignTime;
leftCheckerAlign    = Data.signalStrength(1).goTarg.checkerOn.alignTime;
rightCheckerAlign   = Data.signalStrength(2).goTarg.checkerOn.alignTime;
leftSaccAlign       = Data.signalStrength(1).goTarg.responseOnset.alignTime;
rightSaccAlign      = Data.signalStrength(2).goTarg.responseOnset.alignTime;

leftFixRate         = nansum(Data.signalStrength(1).goTarg.targOn.raster(:,leftFixAlign + preTargWindow), 2)  .* 1000 ./ length(preTargWindow);
rightFixRate        = nansum(Data.signalStrength(2).goTarg.targOn.raster(:,rightFixAlign + preTargWindow), 2)  .* 1000 ./ length(preTargWindow);
leftCheckerRate     = nansum(Data.signalStrength(1).goTarg.checkerOn.raster(:,leftCheckerAlign + postCheckerWindow), 2)  .* 1000 ./ length(postCheckerWindow);
rightCheckerRate 	= nansum(Data.signalStrength(2).goTarg.checkerOn.raster(:,rightCheckerAlign + postCheckerWindow), 2)  .* 1000 ./ length(postCheckerWindow);
leftSaccRate        = nansum(Data.signalStrength(1).goTarg.responseOnset.raster(:,leftSaccAlign + preSaccWindow), 2)  .* 1000 ./ length(preSaccWindow);
rightSaccRate       = nansum(Data.signalStrength(2).goTarg.responseOnset.raster(:,rightSaccAlign + preSaccWindow), 2)  .* 1000 ./ length(preSaccWindow);


% Is there leftward presaccadic activity?
leftRF = false; % default is no
if sum([leftFixRate; leftSaccRate])
% 1) Is presacc > fixation activity?
[h , p] = ttest2(leftFixRate , leftSaccRate , .05);
if h && mean(leftSaccRate) > mean(leftFixRate)
    % 1) If so, is presacc > checker activity?
    [h , p] = ttest2(leftCheckerRate , leftSaccRate , .05);
    if h && mean(leftSaccRate) > mean(leftCheckerRate)
        leftRF = true;
    end
end
end

% Is there rightward presaccadic activity?
rightRF = false; % default is no
if sum([rightFixRate; rightSaccRate])
% 1) Is presacc > fixation activity?
[h , p] = ttest2(rightFixRate , rightSaccRate , .05);
if h && mean(rightSaccRate) > mean(rightFixRate)
    % 1) If so, is presacc > checker activity?
    [h , p] = ttest2(rightCheckerRate , rightSaccRate , .05);
    if h && mean(rightSaccRate) > mean(rightCheckerRate)
        rightRF = true;
    end
end
end

if leftRF && ~rightRF
    rf = {'left'};
elseif ~leftRF && rightRF
    rf = {'right'};
elseif leftRF && rightRF  % if both sides have saccade activity, figure out which has more and use it as the RF
    if mean(leftSaccRate) >= mean(rightSaccRate)
        rf = {'left'};
    else
        rf = {'right'};
    end
end


