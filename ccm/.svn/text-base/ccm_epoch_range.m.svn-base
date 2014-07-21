function epochRange = ccm_epoch_range(epochName, plotOrAnalyze)

% Returns a range of time around the alignement time for an input epoch


% Default is to return an analysis epoch
if nargin < 2
    plotOrAnalyze = 'analyze';
end



switch plotOrAnalyze
    case 'plot'
        % Set a standard range so each panel of a graph
        epochRange = -349 : 350;
        switch epochName
            case 'fixWindowEntered'
                shiftRange = 100;
            case 'targOn'
                shiftRange = 100;
            case 'checkerOn'
                shiftRange = 0;
            case 'stopSignalOn'
                shiftRange = -100;
            case 'responseOnset'
                shiftRange = 0;
            case 'responseOffset'
                shiftRange = -50;
            case 'rewardOn'
                shiftRange = 100;
        end
        
        
        
        epochRange = epochRange + shiftRange;
    case 'analyze'
end
