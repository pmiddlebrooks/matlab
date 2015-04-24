function epochRange = ccm_epoch_range(epochName, plotOrAnalyze, rangeFactor)

% Returns a range of time around the alignement time for an input epoch

% plotOrAnalyze: input: 'plot', 'analyze'.  Might want different window depending on whether we are
% viewing the data or analyzing a specific epoch.

% rangeFactor: 'true' or 'false'. Doubles the normal range. Might want to
% see out further than hard-coded here.

% Default is to return an analysis epoch
if nargin < 2
    plotOrAnalyze = 'analyze';
end
if nargin < 3
    rangeFactor = 1;
end



switch plotOrAnalyze
    case 'plot'
        % Set a standard range so each panel of a graph
        epochRange = -349 : 350;
        epochRange = -49 : 250;
        epochRange = -99 : 300;
        switch epochName
            case 'fixWindowEntered'
                shiftRange = -100;
            case 'targOn'
                shiftRange = 100;
                shiftRange = 0;
            case 'checkerOn'
                shiftRange = 0;
            case 'stopSignalOn'
                shiftRange = -100;
            case 'responseOnset'
                shiftRange = 0;
                shiftRange = -100;
            case 'responseOffset'
                shiftRange = -50;
                shiftRange = -150;
            case 'toneOn'
                shiftRange = 100;
                shiftRange = -50;
            case 'rewardOn'
                shiftRange = 100;
                shiftRange = -50;
        end
        
        
        
        epochRange = epochRange + shiftRange;
    case 'analyze'
end

epochRange = epochRange * rangeFactor;
