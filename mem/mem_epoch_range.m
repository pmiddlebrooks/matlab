function epochRange = mem_epoch_range(epochName, plotOrAnalyze)

% Returns a range of time around the alignement time for an input epoch


% Default is to return an analysis epoch
if nargin < 2
    plotOrAnalyze = 'analyze';
end



switch plotOrAnalyze
    case 'plot'
        % Set a standard range so each panel of a graph
        epochRange = -299 : 300;
        switch epochName
            case 'fixWindowEntered'
                shitRange = 150;
            case 'targOn'
                shitRange = 100;
            case 'responseOnset'
                shitRange = -50;
            case 'rewardOn'
                shitRange = 100;
        end
        
        
        
        epochRange = epochRange + shitRange;
    case 'analyze'
        switch epochName
            case 'fixWindowEntered'
        epochRange = 51 : 250;
            case 'targOn'
        epochRange = 51 : 151;
            case 'responseOnset'
        epochRange = -99 : 0;
            case 'rewardOn'
        epochRange = 51 : 250;
        end
end
