function Data = ccm_concat_neural_conditions(Unit, options)

if nargin < 2;
   options.dataType         = 'neuron';  % 'lfp' or 'erp'
   
%    options.figureHandle     = 674;
   options.printPlot        = false;
   options.epochName       	= 'checkerOn';
   options.eventMarkName   	= 'responseOnset';
   options.colorCohArray  	= Unit(1).pSignalArray;
   options.ssdArray       	= Unit(1).ssdArray;
   options.conditionArray       	= {'goTarg', 'goDist', 'stopTarg', 'stopDist', 'stopCorrect'};
   
%    options.collapseSignal   = false;
%    options.collapseTarg      = false;
%    options.doStops          = true;
%    options.filterData       = false;
%    options.stopHz           = 50;
%    options.normalize        = false;
%    options.unitArray        = 'each';
   
   if nargin == 1
      Data = options;
      return
   end
end
dataType        = options.dataType;
epochName       = options.epochName;
ssdArray        = options.ssdArray;
colorCohArray   = options.colorCohArray;
conditionArray  = options.conditionArray;
eventMarkName   = options.eventMarkName;

% % If singal strength or ssd index vectors are not input, assume user wants to
% % collapse across all of them
% if nargin < 4
%     conditionArray = {'goTarg', 'goDist', 'stopTarg', 'stopDist', 'stopCorrect'};
% end
% if nargin < 5
%     colorCohArray = Unit(1).pSignalArray;
% end
% if nargin < 6
%     ssdArray = Unit(1).ssdArray;
% end
% if nargin < 7
%     dataType = 'neuron';
% end
nUnit = length(Unit);

% Kernel.method = 'gaussian';
% Kernel.sigma = 10;
Kernel.method = 'postsynaptic potential';
Kernel.growth = 1;
Kernel.decay = 20;

[c, sigIndexArray] = ismember(colorCohArray, Unit(1).pSignalArray);
[c, ssdIndexArray] = ismember(ssdArray, Unit(1).ssdArray);
% If multiple units are in the Unit struct, loop through each one.
for k = 1 : nUnit
    % Create a concatenated cell array of rasters according to the desired
    % input condiitons
    signalCell = {};
    alignCell = {};
    alignList = [];
    eventLatency = [];
    for c = 1 : length(conditionArray)
        condition = conditionArray{c};
        for i = 1 : length(sigIndexArray)
            sigIndex = sigIndexArray(i);
            
            
            if (strcmp(condition, 'goTarg') || strcmp(condition, 'goDist')) && ...
                    ~strcmp(epochName, 'stopSignalOn') && ...
                    ~strcmp(eventMarkName, 'stopSignalOn')
                
                
                
                
                alignList = [alignList; Unit(k).signalStrength(sigIndex).(condition).(epochName).alignTimeList];
                alignCell = [alignCell; Unit(k).signalStrength(sigIndex).(condition).(epochName).alignTime];
                iEventLatency = get_event_latency(Unit(k).signalStrength(sigIndex).(condition), epochName, eventMarkName);
                eventLatency = [eventLatency; iEventLatency];
                
                
                switch dataType
                    case 'neuron'
                        signalCell = [signalCell; Unit(k).signalStrength(sigIndex).(condition).(epochName).raster];
                        
                    case 'lfp'
                        signalCell = [signalCell; Unit(k).signalStrength(sigIndex).(condition).(epochName).lfp];
                        
                    case 'erp'
                        signalCell = [signalCell; Unit(k).signalStrength(sigIndex).(condition).(epochName).eeg];
                end
            elseif strcmp(condition, 'stopTarg') || strcmp(condition, 'stopDist') || strcmp(condition, 'stopCorrect')
                for j = 1 : length(ssdIndexArray)
                    ssdIndex = ssdIndexArray(j);
                    
                    % Don't include stopCorrect trials if aligning on
                    % response onset
                    if ~(strcmp(epochName, 'responseOnset') && strcmp(condition, 'stopCorrect'))
                        alignList = [alignList; Unit(k).signalStrength(sigIndex).(condition).ssd(ssdIndex).(epochName).alignTimeList];
                        alignCell = [alignCell; Unit(k).signalStrength(sigIndex).(condition).ssd(ssdIndex).(epochName).alignTime];
                        % Don't get response onset event marks for stop correct
                        if ~(strcmp(eventMarkName, 'responseOnset') && strcmp(condition, 'stopCorrect'))
                            jEventLatency = get_event_latency(Unit(k).signalStrength(sigIndex).(condition).ssd(ssdIndex), epochName, eventMarkName);
                            eventLatency = [eventLatency; jEventLatency];
                        end
                        switch dataType
                            case 'neuron'
                                signalCell = [signalCell; Unit(k).signalStrength(sigIndex).(condition).ssd(ssdIndex).(epochName).raster];
                                
                            case 'lfp'
                                signalCell = [signalCell; Unit(k).signalStrength(sigIndex).(condition).ssd(ssdIndex).(epochName).lfp];
                                
                            case 'erp'
                                signalCell = [signalCell; Unit(k).signalStrength(sigIndex).(condition).ssd(ssdIndex).(epochName).eeg];
                        end
                    end
                end % j = 1 : length(ssdIndex)
            end % if strcmp(condition)
        end % i = 1 : length(signalStrengthIndex)
    end % for c = 1 : length(conditionArray)
    
    % Get trial-wise signal (rasters, lfps, eegs, etc) and across-trial function of signal (sdf, or mean, etc) for each set of trials
            [Data(k).signal, Data(k).align]     = align_raster_sets(signalCell, alignCell);
            [Data(k).signal, Data(k).eventLatency] = sort_rasters_events(Data(k).signal, eventLatency);
    switch dataType
        case 'neuron'
            Data(k).signalFn   = nanmean(spike_density_function(Data(k).signal, Kernel), 1);
            
        case {'lfp', 'erp'}
            Data(k).signalFn   = nanmean(Data(k).signal, 1);
    end % swtich dataType
    
end

end  % main function






function [eventLatency] = get_event_latency(UnitCondition, epochName, eventMarkName)

eventLatency = [];
alignTime = UnitCondition.(epochName).alignTime;
unitAlignList = UnitCondition.(epochName).alignTimeList;

if ~isempty(eventMarkName)
    eventAlignList = UnitCondition.(eventMarkName).alignTimeList;
else
    switch epochName
        case 'fixWindowEntered'
            % target onset
            eventAlignList = UnitCondition.targOn.alignTimeList;
        case 'targOn'
            % target onset
            eventAlignList = UnitCondition.checkerOn.alignTimeList;
        case 'checkerOn'
            % target onset
            eventAlignList = UnitCondition.responseOnset.alignTimeList;
        case 'stopSignalOn'
            % target onset
            eventAlignList = UnitCondition.checkerOn.alignTimeList;
        case 'responseOnset'
            % target onset
            eventAlignList = UnitCondition.checkerOn.alignTimeList;
        case 'rewardOn'
            % target onset
            eventAlignList = UnitCondition.responseOnset.alignTimeList;
    end
end
if ~isempty(alignTime)
    eventLatency = eventAlignList - unitAlignList;
end
end


