function Data = ccm_canceled_vs_noncanceled(subjectID, sessionID, options)

% ccm_go_vs_noncanceled(subjectID, sessionID, options)
%
% Compares noncanceled stops trials vs. latency matched (fast) go trials and canceled stop trials vs. latency matched (slower) go trials.
%
% If called without any arguments, returns a default options structure.
% If options are input but one is not specified, it assumes default.
%
% input:
%   subjectID: e.g. 'Broca', 'Xena', 'pm', etc
%   sessionID: e.g. 'bp111n01', 'Allsaccade'
%
% Possible options are (default listed first):
%     options.dataType        	= which recorded signal to analyze:
%           'neuron','lfp',eeg'
%     options.targSide       	= if you want to analyze only one target
%     side, input left or right:
%           'each', 'left', 'right': if you want to
%     options.unitArray       	= which units to analyze:
%           'each', <list of units in a cell array: e.g.:{'spikeUnit17a', spikeUnit17b'}>
%     options.collapseSignal    = Collapse across signal strength (difficulty conditions)?
%            false, true
%     options.collapseTarg 	= collapse angle/directions of the CORRECT
%           TARGET within each hemifield
%           false, true
%     options.latencyMatchMethod  = wich method to use to match go trial latencies with canceled and noncanceled stop trials:
%           'ssrt','match','mean';
%     options.alignEvent  = wich method to use to match go trial latencies with canceled and noncanceled stop trials:
%           'checkerOn','stopSignalOn';
%     options.minTrialPerCond  	= how many trials must a condition have to
%           include in the analyses?
%     options.cellType  	= Are we treating it as a movement or fixaiton
%     cell? A movement cell with have higher firiring rate for go vs. stop,
%     and a fixaiton with be reversed
%           'move','fix'.
%
%     options.plotFlag       = true, false;
%     options.printPlot       = false, true;
%     options.figureHandle  = optional way to assign the figure to a handle


% Set default options or return a default options structure
if nargin < 3
    % Data type to collect/analyze
    options.dataType        	= 'neuron';
    
    options.unitArray          	= 'each';
    options.targSide   	= 'each';
    options.collapseSignal   	= false;
    options.collapseTarg        = false;
    options.collapseSSD        = false;
    options.latencyMatchMethod 	= 'ssrt';
    options.alignEvent          = 'checkerOn';
    options.minTrialPerCond     = 8;
    options.cellType            =      'move';
    options.ssrt            =      [];
    options.Unit            =      [];
    options.Inh            =      [];
    options.filterData       = false;
    
    options.plotFlag            = true;
    options.printPlot           = false;
    options.figureHandle      	= 800;
    
    % Return just the default options struct if no input
    if nargin == 0
        Data           = options;
        return
    end
end

Data = [];

dataType            = options.dataType;
targSide            = options.targSide;
filterData          = options.filterData;
collapseSignal      = options.collapseSignal;
collapseSSD      = options.collapseSSD;
collapseTarg    	= options.collapseTarg;
latencyMatchMethod  = options.latencyMatchMethod;
alignEvent          = options.alignEvent;
minTrialPerCond     = options.minTrialPerCond;


plotFlag            = options.plotFlag;
printPlot           = options.printPlot;
figureHandle        = options.figureHandle;

Kernel.method = 'postsynaptic potential';
Kernel.growth = 1;
Kernel.decay = 20;
% Kernel.method = 'gaussian';
% Kernel.sigma = 10;


spikeWindow = -20 : 20;


% alignEvent       = 'checkerOn';
switch alignEvent
    case 'checkerOn'
        epochRangeEarly      = 1 : 400;
    case 'stopSignalOn'
        epochRangeEarly      = -199 : 200;
end

markEvent   = 'responseOnset';
encodeTime      = 10;

epochRangeSacc      = -199 : 200;

%%   Get neural data from the session/unit:

if isempty(options.Unit)
    optSess             = ccm_session_data;
    optSess.plotFlag    = 0;
    optSess.collapseTarg = options.collapseTarg;
    optSess.unitArray   = options.unitArray;
    Unit                = ccm_session_data(subjectID, sessionID, optSess);
else
    Unit = options.Unit;
end

if isempty(Unit)
    fprintf('Session %s does not contain spike data \n', sessionID)
    return
end

% How many units were recorded?
[nUnit, nTargPair]  = size(Unit);
pSignalArray        = Unit(1).pSignalArray;
targAngleArray      = Unit(1).targAngleArray;
ssdArray            = Unit(1).ssdArray;
unitArray           = Unit(1).unitArray;

switch targSide
    case 'left'
        pSignalArray = pSignalArray(pSignalArray < .5);
    case 'right'
        pSignalArray = pSignalArray(pSignalArray > .5);
end
nSSD             = length(ssdArray);
nSignal             = length(pSignalArray);
% If collapsing data across signal strength, adjust the pSignalArray here
if collapseSignal
    nSignal = 2;
end
% If collapsing data across SSDs, adjust the nSSD here
if collapseSSD
    nSSD = 1;
end
nAngle              = length(targAngleArray);






%%   Get inhibition data from the session (unless user input in options):
if isempty(options.Inh)
    optInh              = ccm_inhibition;
    optInh.collapseTarg = options.collapseTarg;
    optInh.plotFlag     = false;
    dataInh             = ccm_inhibition(subjectID, sessionID, optInh);
else
    dataInh = options.Inh;
end




%%  Loop through Units and target pairs to collect and plot data

for kUnitIndex = 1 : nUnit
    
    for jTarg = 1 : nTargPair
        
        disp(Unit(kUnitIndex, jTarg).name)
        
        
        stopStopSsdData          = cell(nSignal, nSSD);
        stopStopSsdFn          = cell(nSignal, nSSD);
        stopStopSsdEventLat  	= cell(nSignal, nSSD);
        stopStopSsdAlign      	= cell(nSignal, nSSD);
        
        stopStopCheckerData          = cell(nSignal, nSSD);
        stopStopCheckerFn          = cell(nSignal, nSSD);
        stopStopCheckerEventLat  	= cell(nSignal, nSSD);
        stopStopCheckerAlign      	= cell(nSignal, nSSD);
        
        stopTargCheckerData          = cell(nSignal, nSSD);
        stopTargCheckerFn          = cell(nSignal, nSSD);
        stopTargCheckerEventLat  	= cell(nSignal, nSSD);
        stopTargCheckerAlign      	= cell(nSignal, nSSD);
        
        stopTargSsdData          = cell(nSignal, nSSD);
        stopTargSsdFn          = cell(nSignal, nSSD);
        stopTargSsdEventLat  	= cell(nSignal, nSSD);
        stopTargSsdAlign      	= cell(nSignal, nSSD);
        
        stopTargSaccData             = cell(nSignal, nSSD);
        stopTargSaccFn             = cell(nSignal, nSSD);
        stopTargSaccEventLat        = cell(nSignal, nSSD);
        stopTargSaccAlign           = cell(nSignal, nSSD);
        
        goTargFastCheckerData        = cell(nSignal, nSSD);
        goTargFastCheckerFn        = cell(nSignal, nSSD);
        goTargFastCheckerEventLat  	= cell(nSignal, nSSD);
        goTargFastCheckerAlign    	= cell(nSignal, nSSD);
        
        goTargFastSaccData        	= cell(nSignal, nSSD);
        goTargFastSaccFn           = cell(nSignal, nSSD);
        goTargFastSaccEventLat      = cell(nSignal, nSSD);
        goTargFastSaccAlign         = cell(nSignal, nSSD);
        
        goTargSlowCheckerData        = cell(nSignal, nSSD);
        goTargSlowCheckerFn        = cell(nSignal, nSSD);
        goTargSlowCheckerEventLat  	= cell(nSignal, nSSD);
        goTargSlowCheckerAlign    	= cell(nSignal, nSSD);
        
        goTargSlowSaccData        	= cell(nSignal, nSSD);
        goTargSlowSaccFn           = cell(nSignal, nSSD);
        goTargSlowSaccEventLat      = cell(nSignal, nSSD);
        goTargSlowSaccAlign         = cell(nSignal, nSSD);
        
        switch dataType
            case 'neuron'
                stopTargSpike           	= cell(nSignal, nSSD);
                stopStopSpike           	= cell(nSignal, nSSD);
                goTargFastSpike             = cell(nSignal, nSSD);
                goTargSlowSpike             = cell(nSignal, nSSD);
                
            case 'lfp'
                
            case 'erp'
        end
        % For now, use the grand SSRT via integratin method
        if isempty(options.ssrt)
            ssrt = round(mean(dataInh(jTarg).ssrtIntegrationWeighted));
        else
            ssrt = options.ssrt;
        end
        
        
        
        
        
        usableCondition = zeros(nSignal,nSSD);
        
        for iSigInd = 1 : nSignal;
            
            % If we're collapsing over signal strength or we actually only have
            % 2 levels of signal, determine which iPct (signal) to use this
            % loop iteration
            if iSigInd == 1 && nSignal == 2
                iSignalP = pSignalArray(pSignalArray < .5);
            elseif iSigInd == 2 && nSignal == 2
                iSignalP = pSignalArray(pSignalArray > .5);
            else
                iSignalP = pSignalArray(iSigInd);
            end
            
            
            
            
            
            
            % Get the go trial data: these need to be split to latency-match with
            % the stop trial data
            opt                 = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg)); % Get default options structure
            
            opt.epochName       = alignEvent;
            opt.eventMarkName   = markEvent;
            opt.conditionArray  = {'goTarg'};
            opt.colorCohArray   = iSignalP;
            iGoTargChecker      = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
            
            opt.epochName       = 'responseOnset';
            opt.eventMarkName   = 'checkerOn';
            iGoTargSacc         = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
            
            
            for mSSDInd = 1 : nSSD
                % If collapsing across SSDs
                if collapseSSD
                    %                     error('Not coded yet to collapse SSDs')
                    mSSD = ssdArray(ssdArray > 120);
                else
                    mSSD = ssdArray(mSSDInd);
                end
                
                
                % Get the stop trial data
                opt.epochName       = 'stopSignalOn';
                opt.eventMarkName   = 'responseOnset';
                opt.conditionArray  = {'stopTarg'};
                opt.ssdArray        = mSSD;
                iStopTargSsd    = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                opt.epochName       = 'checkerOn';
                iStopTargChecker   = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                opt.epochName       = 'responseOnset';
                opt.eventMarkName   = 'checkerOn';
                iStopTargSacc       = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                opt.epochName       = 'stopSignalOn';
                opt.eventMarkName   = 'checkerOn';
                opt.conditionArray  = {'stopCorrect'};
                iStopStopSsd       = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                opt.epochName       = 'checkerOn';
                opt.eventMarkName   = 'responseOnset';
                iStopStopChecker       = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                % Use a subsample of the noncanceled stop RTs that are
                % later than the SSD plus some time to encode the stimulus
                iStopTargTrial = iStopTargSsd.eventLatency > encodeTime;
                
                % Continue processing this condition if there were canceled and noncanceled stop trials
                if sum(iStopTargTrial) && size(iStopStopSsd.signal, 1) > 0
                    % Use a latency-matching method to get a (fast)
                    % subsample of go trials that match the noncanceled
                    % stop trials
                    switch latencyMatchMethod
                        case 'ssrt'
                            switch alignEvent
                                case 'checkerOn'
                                    iGoFastTrial = iGoTargChecker.eventLatency <= mSSD + ssrt & iGoTargChecker.eventLatency > mSSD + encodeTime;
                                    iGoSlowTrial = iGoTargChecker.eventLatency > mSSD + ssrt;
                                case 'stopSignalOn'
                                    %                                     iGoFastTrial = iGoTargChecker.eventLatency <= ssrt & iGoTargChecker.eventLatency > encodeTime;
                                    %                                     iGoSlowTrial = iGoTargChecker.eventLatency > ssrt;
                                    iGoFastTrial = [];
                                    iGoSlowTrial = [];
                            end
                        case 'mean'
                            iGoTargRT = sort(iGoTargSsd.eventLatency);
                            meanStopTargRT = nanmean(iStopTargSsd.eventLatency);
                            while nanmean(iGoTargRT) > meanStopTargRT
                                iGoTargRT(end) = [];
                            end
                            iStopLatency = iGoTargRT(end);
                            iGoFastTrial = iGoTargSsd.eventLatency <= iStopLatency;
                        case 'match'
                            % Use nearest neighbor method to get rt-matched
                            % trials
                            nStopCorrect = size(iStopStopSsd.signal, 1);
                            data = ccm_match_rt(iGoTargChecker.eventLatency, iStopTargChecker.eventLatency(iStopTargTrial), nStopCorrect);
                            iGoFastTrial = data.goFastTrial;
                            iGoSlowTrial = data.goSlowTrial;
                    end
                    
                    % Continue processing this condition if there were go fast trials
                    %                     if sum(iGoFastTrial)
                    
                    
                    
                    
                    
                    
                    % ****************************************************************
                    % COLLECT (AND ANALYZE) THE RELEVANT DATA
                    
                    stopStopSsdData{iSigInd, mSSDInd}        = iStopStopSsd.signal;
                    stopStopSsdAlign{iSigInd, mSSDInd}     	= iStopStopSsd.align;
                    stopStopSsdEventLat{iSigInd, mSSDInd}	= iStopStopSsd.eventLatency;
                    
                    stopStopCheckerData{iSigInd, mSSDInd}        = iStopStopChecker.signal;
                    stopStopCheckerAlign{iSigInd, mSSDInd}     	= iStopStopChecker.align;
                    stopStopCheckerEventLat{iSigInd, mSSDInd}	= iStopStopChecker.eventLatency;
                    
                    stopTargSsdData{iSigInd, mSSDInd}        = iStopTargSsd.signal(iStopTargTrial,:);
                    stopTargSsdAlign{iSigInd, mSSDInd}     	= iStopTargSsd.align;
                    stopTargSsdEventLat{iSigInd, mSSDInd}	= iStopTargSsd.eventLatency(iStopTargTrial,:);
                    
                    stopTargCheckerData{iSigInd, mSSDInd}        = iStopTargChecker.signal(iStopTargTrial,:);
                    stopTargCheckerAlign{iSigInd, mSSDInd}     	= iStopTargChecker.align;
                    stopTargCheckerEventLat{iSigInd, mSSDInd}	= iStopTargChecker.eventLatency(iStopTargTrial,:);
                    
                    stopTargSaccData{iSigInd, mSSDInd}           = iStopTargSacc.signal(iStopTargTrial,:);
                    stopTargSaccAlign{iSigInd, mSSDInd}         = iStopTargSacc.align;
                    stopTargSaccEventLat{iSigInd, mSSDInd}      = iStopTargSacc.eventLatency(iStopTargTrial,:);
                    
                    goTargFastCheckerData{iSigInd, mSSDInd}      = iGoTargChecker.signal(iGoFastTrial,:);
                    goTargFastCheckerAlign{iSigInd, mSSDInd} 	= iGoTargChecker.align;
                    goTargFastCheckerEventLat{iSigInd, mSSDInd}	= iGoTargChecker.eventLatency(iGoFastTrial,:);
                    
                    goTargFastSaccData{iSigInd, mSSDInd}         = iGoTargSacc.signal(iGoFastTrial,:);
                    goTargFastSaccAlign{iSigInd, mSSDInd}       = iGoTargSacc.align;
                    goTargFastSaccEventLat{iSigInd, mSSDInd}    = iGoTargSacc.eventLatency(iGoFastTrial,:);
                    
                    goTargSlowSaccData{iSigInd, mSSDInd}         = iGoTargSacc.signal(iGoSlowTrial,:);
                    goTargSlowSaccAlign{iSigInd, mSSDInd}       = iGoTargSacc.align;
                    goTargSlowSaccEventLat{iSigInd, mSSDInd}    = iGoTargSacc.eventLatency(iGoSlowTrial,:);
                    
                    goTargSlowCheckerData{iSigInd, mSSDInd}      = iGoTargChecker.signal(iGoSlowTrial,:);
                    goTargSlowCheckerAlign{iSigInd, mSSDInd} 	= iGoTargChecker.align;
                    goTargSlowCheckerEventLat{iSigInd, mSSDInd}	= iGoTargChecker.eventLatency(iGoSlowTrial,:);
                    
                    
                    
                    switch dataType
                        case 'neuron'
                            stopStopSsdFn{iSigInd, mSSDInd} 	= iStopStopSsd.signalFn;
                            stopStopCheckerFn{iSigInd, mSSDInd} 	= iStopStopChecker.signalFn;
                            stopTargSsdFn{iSigInd, mSSDInd}      = nanmean(spike_density_function(stopTargSsdData{iSigInd, mSSDInd}, Kernel), 1);
                            stopTargCheckerFn{iSigInd, mSSDInd}      = nanmean(spike_density_function(stopTargCheckerData{iSigInd, mSSDInd}, Kernel), 1);
                            stopTargSaccFn{iSigInd, mSSDInd}      = nanmean(spike_density_function(stopTargSaccData{iSigInd, mSSDInd}, Kernel), 1);
                            %                                 goTargFastSsdFn{iSigInd, mSSDInd}      = nanmean(spike_density_function(goTargFastSsdData{iSigInd, mSSDInd}, Kernel), 1);
                            goTargFastCheckerFn{iSigInd, mSSDInd}         = nanmean(spike_density_function(goTargFastCheckerData{iSigInd, mSSDInd}, Kernel), 1);
                            goTargSlowCheckerFn{iSigInd, mSSDInd}         = nanmean(spike_density_function(goTargSlowCheckerData{iSigInd, mSSDInd}, Kernel), 1);
                            goTargFastSaccFn{iSigInd, mSSDInd}         = nanmean(spike_density_function(goTargFastSaccData{iSigInd, mSSDInd}, Kernel), 1);
                            goTargSlowSaccFn{iSigInd, mSSDInd}         = nanmean(spike_density_function(goTargSlowSaccData{iSigInd, mSSDInd}, Kernel), 1);
                            
                            
                            %                                 % Hanes et al 1998 t-test of spike rates 40 ms surrounding estimated ssrt
                            %                                 stopTargSpike{iSigInd, mSSDInd}     = sum(iStopTargSsd.signal(iStopTargTrial, spikeWindow + iStopTargSsd.align + mSSD + ssrt), 2);
                            %                                 goTargFastSpike{iSigInd, mSSDInd}   = sum(iGoTargSsd.signal(iGoFastTrial, spikeWindow + iGoTargSsd.align + mSSD + ssrt), 2);
                            %                                 [h,p,ci,sts]                        = ttest2(stopTargSpike{iSigInd, mSSDInd}, goTargFastSpike{iSigInd, mSSDInd});
                            %
                            %                                 pValue{iSigInd, mSSDInd}    = p;
                            %                                 stats{iSigInd, mSSDInd}     = sts;
                            %
                            %                                 fprintf('ssd: %d  \tgo v. stop: %.2f  %.2f sp, p = %.2f\n',...
                            %                                     mSSD, mean(goTargFastSpike{iSigInd, mSSDInd}), mean(stopTargSpike{iSigInd, mSSDInd}), p);
                            
                            
                        case {'lfp','erp'}
                            
                            stopStopSsdFn{iSigInd, mSSDInd}  	= nanmean(iStopStopSsd.signal, 1);
                            stopTargSsdFn{iSigInd, mSSDInd}  	= nanmean(iStopTargSsd.signal, 1);
                            %                                 goTargFastSsdFn{iSigInd, mSSDInd}      = nanmean(iGoTargSsd.signal(iGoFastTrial,:), 1);
                            goTargFastSaccFn{iSigInd, mSSDInd}         = nanmean(iGoTargSacc.signal(iGoFastTrial,:), 1);
                            goTargSlowSaccFn{iSigInd, mSSDInd}         = nanmean(iGoTargSacc.signal(iGoSlowTrial,:), 1);
                            
                            
                            
                    end % switch dataType
                    % ****************************************************************
                    
                    
                    % Mark the data for later display if there were enough trials in both conditions
                    %                         if sum(iStopTargTrial)  >= options.minTrialPerCond && size(iStopStopSsd.signal, 1) >= minTrialPerCond
                    %                             usableCondition(iSigInd, mSSDInd) = 1;
                    %
                    %                         end
                    % Mark the data for later display if there were enough trials in both conditions
                    if (sum(iGoFastTrial) >= minTrialPerCond && ...
                            sum(iStopTargTrial)  >= minTrialPerCond) || ...
                            (sum(iGoSlowTrial) >= minTrialPerCond && ...
                            size(iStopStopSsd.signal, 1) >= minTrialPerCond)
                        usableCondition(iSigInd, mSSDInd) = 1;
                        
                    end
                    %                     end % if sum(iGoFastTrial)
                end % if sum(iStopTargTrial)
                
            end % for mSSDInd = 1 : nSSD
        end %for iSigInd
        
        
        
        
        
        
        
        
        
        
        
        % ****************************  PLOTTING  ****************************
        
        % Figure out how many conditions to plot/analyze
        usableCondition = logical(usableCondition(:));
        if collapseSignal
            pSignalPlot = [0 1];
        else
            pSignalPlot = pSignalArray;
        end
        signalVector = repmat(reshape(pSignalPlot, nSignal, 1), 1, nSSD);
        signalVector = signalVector(:);
        signalVector = signalVector(usableCondition);
        if collapseSSD
            ssdVector = ones(nSignal, 1) * ssdArray(1);
        else
            ssdVector = repmat(reshape(ssdArray, 1, nSSD), nSignal, 1);
            ssdVector = ssdVector(:);
        end
        ssdVector = ssdVector(usableCondition);
        
        
        nUsable = sum(usableCondition);
        
        
        % Creat a new figure if needed (for a new pair of targets and/or
        % unit
        if plotFlag && nUsable > 0
            
            cMap = ccm_colormap(pSignalArray);
            if collapseSignal
                cMap = cMap .* .6;
            end
            stopColor = [.8 0 0];
            
            goFastLineW     = 1;
            goSlowLineW     = 2;
            stopStopLineW   = 2;
            stopTargLineW   = 1;
            markSize = 20;
            nColumn = 2;
            figureHandle = figureHandle + 1;
            %     nRow = max([nSignal, nLGraph, nRGraph]);
            nRow = max(3, nUsable);
            if printPlot
                [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, figureHandle);
            else
                [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, figureHandle);
            end
            axisHeight = axisHeight * .9;
            clf
            
            % Figure out y-axis limits (to be consistent across graphs)
            leftSigInd = pSignalArray < .5;
            rightSigInd = pSignalArray > .5;
            
            opt                 = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg)); % Get default options structure
            
            opt.epochName       = 'responseOnset';
            opt.eventMarkName   = 'checkerOn';
            opt.conditionArray  = {'goTarg'};
            opt.colorCohArray   = pSignalArray(leftSigInd);
            opt.ssdArray        = [];
            %             dataL           = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), 'responseOnset', 'checkerOn', {'goTarg'}, pSignalArray(leftSigInd), []);
            %             dataR           = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), 'responseOnset', 'checkerOn', {'goTarg'}, pSignalArray(rightSigInd), []);
            dataLR           = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
            %             sigMax          = 1.15 * max([dataL.signalFn(dataL.align + epochRangeSacc), dataR.signalFn(dataR.align + epochRangeSacc)]);
            
            sigMax          = 1.15 * max(dataLR.signalFn(dataLR.align + epochRangeSacc));
            switch dataType
                case 'neuron'
                    sigMin = 0;
                case {'lfp','erp'}
                    %                     sigMin = min([dataL.signalFn(dataL.align + epochRangeSacc), dataR.signalFn(dataR.align + epochRangeSacc)]);
                    sigMin = min(dataLR.signalFn(dataLR.align + epochRangeSacc));
            end
            
            
            % Title for the figure
            h=axes('Position', [0 0 1 1], 'Visible', 'Off');
            set(gcf, 'Name','Canceled v Noncanceled','NumberTitle','off')
            titleString = sprintf('%s \t %s', sessionID, Unit(kUnitIndex, jTarg).name);
            text(0.5,1, titleString, 'HorizontalAlignment','Center', 'VerticalAlignment','Top')
            
            
            
            for i = 1 : nUsable
                
                % which pSignalArray index and which ssdArray index?
                iSigInd = find(pSignalPlot == signalVector(i));
                iSsdInd = find(ssdArray == ssdVector(i));
                iSSD = ssdArray(iSsdInd);
                iPct = round(pSignalPlot(iSigInd) * 100);
                
                % _______  Set up axes  ___________
                
                iRow = i;
                colChkr = 1;
                colSacc = 2;
                
                yMaxFactor = 1.2;
                
                % Align First plot on either checkerboard or stop signal
                % onset
                ax(iRow, colChkr) = axes('units', 'centimeters', 'position', [xAxesPosition(iRow, colChkr) yAxesPosition(iRow, colChkr) axisWidth axisHeight]);
                set(ax(iRow, colChkr), 'ylim', [sigMin sigMax * yMaxFactor], 'xlim', [epochRangeEarly(1) epochRangeEarly(end)])
                cla
                hold(ax(iRow, colChkr), 'on')
                plot(ax(iRow, colChkr), [1 1], [sigMin sigMax], '-k', 'linewidth', 2)
                ttl = sprintf('SSD: %d  pMag: %d', iSSD, iPct);
                title(ttl)
                
                
                % Data aligned on response onset
                ax(iRow, colSacc) = axes('units', 'centimeters', 'position', [xAxesPosition(iRow, colSacc) yAxesPosition(iRow, colSacc) axisWidth axisHeight]);
                set(ax(iRow, colSacc), 'ylim', [sigMin sigMax * yMaxFactor], 'xlim', [epochRangeSacc(1) epochRangeSacc(end)])
                set(ax(iRow, colSacc), 'yticklabel', [], 'ycolor', [1 1 1])
                cla
                hold(ax(iRow, colSacc), 'on')
                plot(ax(iRow, colSacc), [1 1], [sigMin sigMax], '-k', 'linewidth', 2)
                
                %     if i > 1
                %         set(ax(iRow, colChkr), 'yticklabel', [])
                %         set(ax(iRow, colChkr), 'ycolor', [1 1 1])
                %     end
                
                
                
                
                
                switch alignEvent
                    case 'checkerOn'
                        % Checker aligned
                        plot(ax(iRow, colChkr), [ssrt + iSSD, ssrt + iSSD], [sigMin sigMax], '--', 'color', [0 0 0], 'linewidth', 1)
                        plot(ax(iRow, colChkr), [iSSD, iSSD], [sigMin sigMax], '-', 'color', [1 0 0], 'linewidth', 1)
                        
                        
                        iGoTargFastRTMean = round(mean(goTargFastCheckerEventLat{iSigInd, iSsdInd}));
                        iGoTargSlowRTMean = round(mean(goTargSlowCheckerEventLat{iSigInd, iSsdInd}));
                        iStopTargRTMean = round(mean(stopTargSsdEventLat{iSigInd, iSsdInd}) + iSSD);
                        
                        if ~isempty(goTargFastCheckerFn{iSigInd,iSsdInd})
                            iGoTargFastCheckerFn = goTargFastCheckerFn{iSigInd,iSsdInd}(goTargFastCheckerAlign{iSigInd,iSsdInd} + epochRangeEarly);
                            plot(ax(iRow, colChkr), epochRangeEarly, iGoTargFastCheckerFn, 'color', cMap(iSigInd,:), 'linewidth', goFastLineW)
                            plot(ax(iRow, colChkr), iGoTargFastRTMean, iGoTargFastCheckerFn(iGoTargFastRTMean), '.k','markersize', markSize)
                        end
                        
                        if ~isempty(goTargSlowCheckerFn{iSigInd,iSsdInd})
                            iGoTargSlowCheckerFn = goTargSlowCheckerFn{iSigInd,iSsdInd}(goTargSlowCheckerAlign{iSigInd,iSsdInd} + epochRangeEarly);
                            plot(ax(iRow, colChkr), epochRangeEarly, iGoTargSlowCheckerFn, 'color', cMap(iSigInd,:), 'linewidth', goSlowLineW)
                        end
                        
                        if iGoTargSlowRTMean <= length(iGoTargSlowCheckerFn)
                            plot(ax(iRow, colChkr), iGoTargSlowRTMean, iGoTargSlowCheckerFn(iGoTargSlowRTMean), '.k','markersize', markSize)
                        end
                        
                        if ~isempty(stopTargCheckerFn{iSigInd,iSsdInd})
                            iStopTargCheckerFn = stopTargCheckerFn{iSigInd,iSsdInd}(stopTargCheckerAlign{iSigInd,iSsdInd} + epochRangeEarly);
                            plot(ax(iRow, colChkr), epochRangeEarly, iStopTargCheckerFn, 'color', stopColor, 'linewidth', stopTargLineW)
                        end
                        
                        if iStopTargRTMean <= length(iStopTargCheckerFn)
                            plot(ax(iRow, colChkr), iStopTargRTMean, iStopTargCheckerFn(iStopTargRTMean), '.k','markersize', markSize)
                        end
                        
                        if ~isempty(stopStopSsdFn{iSigInd,iSsdInd})
                            iStopStopCheckerFn = stopStopSsdFn{iSigInd,iSsdInd}(stopStopCheckerAlign{iSigInd,iSsdInd} + epochRangeEarly);
                            plot(ax(iRow, colChkr), epochRangeEarly, iStopStopCheckerFn, 'color', stopColor, 'linewidth', stopStopLineW)
                        end
                        
                    case 'stopSignalOn'
                        % SSD aligned
                        
                        plot(ax(iRow, colChkr), [ssrt, ssrt], [sigMin sigMax], '--', 'color', [0 0 0], 'linewidth', 1)
                        % Don't plot go trials if we're collapsing across SSD
                        if ~collapseSSD
                            iGoTargFastRTMean = round(mean(goTargFastCheckerEventLat{iSigInd, iSsdInd})) - iSSD;
                            iGoTargSlowRTMean = round(mean(goTargSlowCheckerEventLat{iSigInd, iSsdInd})) - iSSD;
                            
                            iGoTargFastSsdFn = goTargFastCheckerFn{iSigInd,iSsdInd}(goTargFastCheckerAlign{iSigInd,iSsdInd} + iSSD + epochRangeEarly);
                            plot(ax(iRow, colChkr), epochRangeEarly, iGoTargFastSsdFn, 'color', cMap(iSigInd,:), 'linewidth', goFastLineW)
                            plot(ax(iRow, colChkr), iGoTargFastRTMean, iGoTargFastSsdFn(-epochRangeSsd(1) + iGoTargFastRTMean), '.k','markersize', markSize)
                            
                            iGoTargSlowSsdFn = goTargSlowCheckerFn{iSigInd,iSsdInd}(goTargSlowCheckerAlign{iSigInd,iSsdInd} + iSSD + epochRangeEarly);
                            plot(ax(iRow, colChkr), epochRangeEarly, iGoTargSlowSsdFn, 'color', cMap(iSigInd,:), 'linewidth', goSlowLineW)
                            plot(ax(iRow, colChkr), iGoTargSlowRTMean, iGoTargSlowSsdFn(-epochRangeSsd(1) + iGoTargSlowRTMean), '.k','markersize', markSize)
                        end
                        iStopTargRTMean = round(mean(stopTargSsdEventLat{iSigInd, iSsdInd}));
                        
                        iStopTargSsdFn = stopTargSsdFn{iSigInd,iSsdInd}(stopTargSsdAlign{iSigInd,iSsdInd} + epochRangeEarly);
                        plot(ax(iRow, colChkr), epochRangeEarly, iStopTargSsdFn, 'color', stopColor, 'linewidth', stopTargLineW)
                        plot(ax(iRow, colChkr), iStopTargRTMean, iStopTargSsdFn(-epochRangeEarly(1) + iStopTargRTMean), '.k','markersize', markSize)
                        
                        iStopStopSsdFn = stopStopSsdFn{iSigInd,iSsdInd}(stopStopSsdAlign{iSigInd,iSsdInd} + epochRangeEarly);
                        plot(ax(iRow, colChkr), epochRangeEarly, iStopStopSsdFn, 'color', stopColor, 'linewidth', stopStopLineW)
                end
                
                
                
                % Saccade-aligned
                % Don't plot go trials if we're collapsing across SSD
                if ~collapseSSD
                    if ~isempty(goTargFastSaccFn{iSigInd,iSsdInd})
                        iGoTargFastSaccFn = goTargFastSaccFn{iSigInd,iSsdInd}(goTargFastSaccAlign{iSigInd,iSsdInd} + epochRangeSacc);
                        plot(ax(iRow, colSacc), epochRangeSacc, iGoTargFastSaccFn, 'color', cMap(iSigInd,:), 'linewidth', goFastLineW)
                    end
                    
                    if ~isempty(goTargSlowSaccFn{iSigInd,iSsdInd})
                        iGoTargSlowSaccFn = goTargSlowSaccFn{iSigInd,iSsdInd}(goTargSlowSaccAlign{iSigInd,iSsdInd} + epochRangeSacc);
                        plot(ax(iRow, colSacc), epochRangeSacc, iGoTargSlowSaccFn, 'color', cMap(iSigInd,:), 'linewidth', goSlowLineW)
                    end
                end
                
                if ~isempty(stopTargSaccFn{iSigInd,iSsdInd})
                    iStopTargSaccFn = stopTargSaccFn{iSigInd,iSsdInd}(stopTargSaccAlign{iSigInd,iSsdInd} + epochRangeSacc);
                    plot(ax(iRow, colSacc), epochRangeSacc, iStopTargSaccFn, 'color', stopColor, 'linewidth', stopTargLineW)
                end
                
                %                 iStopStopSaccFn = stopStopCheckerFn{iSigInd,iSsdInd}(stopStopCheckerAlign{iSigInd,iSsdInd} + iGoTargSlowRTMean + epochRangeSacc);
                %                 plot(ax(iRow, colSacc), epochRangeSacc, iStopStopSaccFn, 'color', stopColor, 'linewidth', stopStopLineW)
                
            end % for i = 1 : nUsable
            
        end % if plotFlag && nUsable > 0
        
        
        if printPlot
            localFigurePath = local_figure_path;
            %             print(figureHandle-1,[localFigurePath, sessionID, '_',Unit(kUnitIndex, jTarg).name, '_ccm_neuron_stop_vs_go_Left.pdf'],'-dpdf', '-r300')
            print(figureHandle,[localFigurePath, sessionID, '_',Unit(kUnitIndex, jTarg).name, '_ccm_canceled_vs_noncanceled.pdf'],'-dpdf', '-r300')
        end
        
        
        
        
        
        
        %         % Collect the data for later analyses
        %         Data(kUnitIndex).targ(jTarg).stopTargSpike      = stopTargSpike;
        %         Data(kUnitIndex).targ(jTarg).stopTargSsdData        = stopTargSsdData;
        %         Data(kUnitIndex).targ(jTarg).stopTargSsdAlign        = stopTargSsdAlign;
        %         Data(kUnitIndex).targ(jTarg).stopTargSsdEventLat        = stopTargSsdEventLat;
        %         Data(kUnitIndex).targ(jTarg).stopTargSaccData  	= stopTargSaccData;
        %         Data(kUnitIndex).targ(jTarg).stopTargSaccAlign        = stopTargSaccAlign;
        %         Data(kUnitIndex).targ(jTarg).stopTargSaccEventLat        = stopTargSaccEventLat;
        %
        %         Data(kUnitIndex).targ(jTarg).goTargFastSpike    = goTargFastSpike;
        %         Data(kUnitIndex).targ(jTarg).goTargFastSsdData      = goTargFastSsdData;
        %         Data(kUnitIndex).targ(jTarg).goTargFastSsdAlign      = goTargFastSsdAlign;
        %         Data(kUnitIndex).targ(jTarg).goTargFastSsdEventLat     = goTargFastSsdEventLat;
        %         Data(kUnitIndex).targ(jTarg).goTargFastSaccData 	= goTargFastSaccData;
        %         Data(kUnitIndex).targ(jTarg).goTargFastSaccAlign      = goTargFastSaccAlign;
        %         Data(kUnitIndex).targ(jTarg).goTargFastSaccEventLat     = goTargFastSaccEventLat;
        %
        %         %         Data(kUnitIndex).targ(jTarg).pValue = pValue;
        %         %         Data(kUnitIndex).targ(jTarg).stats = stats;
        
    end % for jTarg
end % for kUnitInd
















end % function


