function Data = ccm_go_vs_noncanceled(subjectID, sessionID, options)

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
%     options.unitArray       	= which units to analyze:
%           'each', <list of units in a cell array: e.g.:{'spikeUnit17a', spikeUnit17b'}>
%     options.collapseSignal    = Collapse across signal strength (difficulty conditions)?
%            false, true
%     options.collapseTarg 	= collapse angle/directions of the CORRECT
%           TARGET within each hemifield
%           false, true
%     options.latencyMatchMethod  = wich method to use to match go trial latencies with canceled and noncanceled stop trials:
%           'ssrt' Use RTs less than or after SSRT
%           'match' Employ a nearest-neighbor algorithm to find closest RT matches
%           'mean' Remove latest Go RTs until the Go RT distribution mean equals the noncanceled Stop RTs mean
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
    options.collapseSignal   	= false;
    options.collapseTarg        = false;
    options.latencyMatchMethod 	= 'ssrt';
    options.minTrialPerCond     = 8;
    options.cellType            =      'move';
    options.ssrt            =      [];
    options.filterData       = false;
    
    options.plotFlag            = true;
    options.printPlot           = false;
    options.figureHandle      	= 600;
    
    % Return just the default options struct if no input
    if nargin == 0
        Data           = options;
        return
    end
end

usePreSSD = false;

dataType            = options.dataType;
collapseSignal      = options.collapseSignal;
latencyMatchMethod  = options.latencyMatchMethod;

plotFlag            = options.plotFlag;
printPlot           = options.printPlot;
figureHandle        = options.figureHandle;

Kernel.method = 'postsynaptic potential';
Kernel.growth = 1;
Kernel.decay = 20;


spikeWindow = -20 : 20;


alignEvent       = 'checkerOn';
markEvent   = 'responseOnset';
encodeTime      = 10;

epochRangeChecker      = 1 : 400;
epochRangeSacc      = -199 : 200;


%%   Get neural data from the session/unit:

    optSess             = options;
    optSess.plotFlag    = 0;
    optSess.collapseTarg = options.collapseTarg;
    optSess.unitArray   = options.unitArray;
    Unit                = ccm_session_data(subjectID, sessionID, optSess);

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

nSSD             = length(ssdArray);
nSignal             = length(pSignalArray);
% If collapsing data across signal strength, adjust the pSignalArray here
if collapseSignal
    nSignal = 2;
end






%%   Get inhibition data from the session (unless user input in options):
    optInh              = options;
    optInh.plotFlag     = false;
    dataInh             = ccm_inhibition(subjectID, sessionID, optInh);




%%  Loop through Units and target pairs to collect and plot data

for kUnitIndex = 1 : nUnit
    
    for jTarg = 1 : nTargPair
        
        disp(Unit(kUnitIndex, jTarg).name)
        
        
        stopTargCheckerData          = cell(nSignal, nSSD);
        stopTargCheckerFn          = cell(nSignal, nSSD);
        stopTargCheckerEventLat  	= cell(nSignal, nSSD);
        stopTargCheckerAlign      	= cell(nSignal, nSSD);
        
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
        
        switch dataType
            case 'neuron'
                stopTargSpike           	= cell(nSignal, nSSD);
                goTargFastSpike             = cell(nSignal, nSSD);
                
            case 'lfp'
                
            case 'erp'
        end
        % For now, use the grand SSRT via integratin method
            ssrt = round(mean(dataInh(jTarg).ssrtIntegrationWeighted));
        
        
        
        
        
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
            opt                 = options; % Get default options structure
            
            opt.epochName       = alignEvent;
            opt.eventMarkName   = markEvent;
            opt.conditionArray  = {'goTarg'};
            opt.colorCohArray   = iSignalP;
            opt.ssdArray        = [];
            iGoTargChecker      = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
            
            opt.epochName       = 'responseOnset';
            opt.eventMarkName   = 'checkerOn';
            iGoTargSacc         = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
            
            
            for mSSDInd = 1 : nSSD
                mSSD = ssdArray(mSSDInd);
                
                
                % Get the stop trial data
                opt.epochName       = alignEvent;
                opt.eventMarkName   = markEvent;
                opt.conditionArray  = {'stopTarg'};
                opt.ssdArray        = mSSD;
                iStopTargChecker    = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                opt.conditionArray  = {'stopStop'};
                iStopStopChecker       = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                opt.epochName       = 'responseOnset';
                opt.eventMarkName   = 'checkerOn';
                opt.conditionArray  = {'stopTarg'};
                iStopTargSacc       = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                
                
                % Use a subsample of the noncanceled stop RTs that are
                % later than the SSD plus some time to encode the stimulus
                if ~usePreSSD
                iStopTargTrial = iStopTargChecker.eventLatency > mSSD + encodeTime;
                end
                
                % Continue processing this condition if there were any noncanceled stop trials
                if sum(iStopTargTrial)
                    % Use a latency-matching method to get a (fast)
                    % subsample of go trials that match the noncanceled
                    % stop trials
                    switch latencyMatchMethod
                        case 'ssrt'
                            iStopLatency = mSSD + ssrt;
                            iGoFastTrial = iGoTargChecker.eventLatency <= iStopLatency & iGoTargChecker.eventLatency >  mSSD + encodeTime;
                        case 'mean'
                            iGoTargRT = sort(iGoTargChecker.eventLatency);
                            meanStopTargRT = nanmean(iStopTargChecker.eventLatency);
                            while nanmean(iGoTargRT) > meanStopTargRT
                                iGoTargRT(end) = [];
                            end
                            iStopLatency = iGoTargRT(end);
                            iGoFastTrial = iGoTargChecker.eventLatency <= iStopLatency;
                        case 'match'
                            % Use nearest neighbor method to get rt-matched
                            % trials
                            nStopCorrect = size(iStopStopChecker.signal, 1);
                            data = ccm_match_rt(iGoTargChecker.eventLatency, iStopTargChecker.eventLatency(iStopTargTrial), nStopCorrect);
                            iGoFastTrial = data.goFastTrial;
                    end
                    
                    % Continue processing this condition if there were go fast trials
                    if sum(iGoFastTrial)
                        
                        
                        
                        
                        
                        
                        % ****************************************************************
                        % COLLECT (AND ANALYZE) THE RELEVANT DATA
                        
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
                        
                        
                        
                        switch dataType
                            case 'neuron'
                                stopTargCheckerFn{iSigInd, mSSDInd}      = nanmean(spike_density_function(stopTargCheckerData{iSigInd, mSSDInd}, Kernel), 1);
                                stopTargSaccFn{iSigInd, mSSDInd}      = nanmean(spike_density_function(stopTargSaccData{iSigInd, mSSDInd}, Kernel), 1);
                                goTargFastCheckerFn{iSigInd, mSSDInd}      = nanmean(spike_density_function(goTargFastCheckerData{iSigInd, mSSDInd}, Kernel), 1);
                                goTargFastSaccFn{iSigInd, mSSDInd}         = nanmean(spike_density_function(goTargFastSaccData{iSigInd, mSSDInd}, Kernel), 1);
                                
                                
                                % Hanes et al 1998 t-test of spike rates 40 ms surrounding estimated ssrt
                                stopTargSpike{iSigInd, mSSDInd}     = sum(iStopTargChecker.signal(iStopTargTrial, spikeWindow + iStopTargChecker.align + mSSD + ssrt), 2);
                                goTargFastSpike{iSigInd, mSSDInd}   = sum(iGoTargChecker.signal(iGoFastTrial, spikeWindow + iGoTargChecker.align + mSSD + ssrt), 2);
                                [h,p,ci,sts]                        = ttest2(stopTargSpike{iSigInd, mSSDInd}, goTargFastSpike{iSigInd, mSSDInd});
                                
                                pValue{iSigInd, mSSDInd}    = p;
                                stats{iSigInd, mSSDInd}     = sts;
                                
                                fprintf('ssd: %d  \tgo v. stop: %.2f  %.2f sp, p = %.2f\n',...
                                    mSSD, mean(goTargFastSpike{iSigInd, mSSDInd}), mean(stopTargSpike{iSigInd, mSSDInd}), p);
                                
                                
                            case {'lfp','erp'}
                                
                                stopTargCheckerFn{iSigInd, mSSDInd}  	= nanmean(iStopTargChecker.signal, 1);
                                goTargFastCheckerFn{iSigInd, mSSDInd}      = nanmean(iGoTargChecker.signal(iGoFastTrial,:), 1);
                                goTargFastSaccFn{iSigInd, mSSDInd}         = nanmean(iGoTargSacc.signal(iGoFastTrial,:), 1);
                                
                                
                                
                        end % switch dataType
                        % ****************************************************************
                        
                        
                        % Mark the data for later display if there were enough trials in both conditions
                        if sum(iGoFastTrial) >= options.minTrialPerCond && sum(iStopTargTrial) >= options.minTrialPerCond
                            usableCondition(iSigInd, mSSDInd) = 1;
                            
                        end
                    end % if sum(iGoFastTrial)
                end % if sum(iStopTargTrial)
                
            end % for mSSDInd = 1 : nSSD
        end %for iSigInd
        
        
        
        
        
        
        
        % ****************************  PLOTTING  ****************************
        
        % Figure out how many conditions to plot/analyze
        usableCondition = logical(usableCondition(:));
        if options.collapseSignal
            pSignalPlot = [0 1];
        else
            pSignalPlot = pSignalArray;
        end
        signalVector = repmat(reshape(pSignalPlot, nSignal, 1), 1, nSSD);
        signalVector = signalVector(:);
        signalVector = signalVector(usableCondition);
        ssdVector = repmat(reshape(ssdArray, 1, nSSD), nSignal, 1);
        ssdVector = ssdVector(:);
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
            
            goLineW = 2;
            stopLineW = 2;
            markSize = 20;
            nColumn = 2;
            figureHandle = figureHandle + 1;
            %     nRow = max([nSignal, nLGraph, nRGraph]);
            nRow = max(3, nUsable);
            if printPlot
                [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', figureHandle);
            else
                [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = screen_figure(nRow, nColumn, figureHandle);
            end
            axisHeight = axisHeight * .9;
            clf
            
            % Figure out y-axis limits (to be consistent across graphs)
            leftSigInd = pSignalArray < .5;
            rightSigInd = pSignalArray > .5;
            
            opt                 = options; % Get default options structure
            
            opt.epochName       = 'responseOnset';
            opt.eventMarkName   = 'checkerOn';
            opt.conditionArray  = {'goTarg'};
            opt.colorCohArray   = pSignalArray(leftSigInd);
            opt.ssdArray        = ssdArray;
            dataL           = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
            
            opt.colorCohArray   = pSignalArray(rightSigInd);
            dataR           = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
            sigMax          = max([dataL.signalFn(dataL.align + epochRangeSacc), dataR.signalFn(dataL.align + epochRangeSacc)]);
            switch dataType
                case 'neuron'
                    sigMin = 0;
                case {'lfp','erp'}
                    sigMin = min([dataL.signalFn(dataL.align + epochRangeSacc), dataR.signalFn(dataR.align + epochRangeSacc)]);
            end
            
            % Title for the figure
            h=axes('Position', [0 0 1 1], 'Visible', 'Off');
            set(gcf, 'Name','Go v Nonanceled','NumberTitle','off')
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
                
                % Data aligned on checkerboard onset
                ax(iRow, colChkr) = axes('units', 'centimeters', 'position', [xAxesPosition(iRow, colChkr) yAxesPosition(iRow, colChkr) axisWidth axisHeight]);
                set(ax(iRow, colChkr), 'ylim', [sigMin sigMax * 1.1], 'xlim', [epochRangeChecker(1) epochRangeChecker(end)])
                cla
                hold(ax(iRow, colChkr), 'on')
                plot(ax(iRow, colChkr), [1 1], [sigMin sigMax], '-k', 'linewidth', 2)
                ttl = sprintf('SSD: %d  pMag: %d', iSSD, iPct);
                title(ttl)
                
                % Data aligned on response onset
                ax(iRow, colSacc) = axes('units', 'centimeters', 'position', [xAxesPosition(iRow, colSacc) yAxesPosition(iRow, colSacc) axisWidth axisHeight]);
                set(ax(iRow, colSacc), 'ylim', [sigMin sigMax * 1.1], 'xlim', [epochRangeSacc(1) epochRangeSacc(end)])
                set(ax(iRow, colSacc), 'yticklabel', [], 'ycolor', [1 1 1])
                cla
                hold(ax(iRow, colSacc), 'on')
                plot(ax(iRow, colSacc), [1 1], [sigMin sigMax], '-k', 'linewidth', 2)
                
                %     if i > 1
                %         set(ax(iRow, colChkr), 'yticklabel', [])
                %         set(ax(iRow, colChkr), 'ycolor', [1 1 1])
                %     end
                
                
                plot(ax(iRow, colChkr), [iSSD, iSSD], [sigMin sigMax], 'color', [.2 .2 .2], 'linewidth', 1)
                plot(ax(iRow, colChkr), [iSSD + ssrt, iSSD + ssrt], [sigMin sigMax], '--', 'color', [0 0 0], 'linewidth', 1)
                
                iGoTargFastCheckerFn = goTargFastCheckerFn{iSigInd,iSsdInd}(goTargFastCheckerAlign{iSigInd,iSsdInd} + epochRangeChecker);
                plot(ax(iRow, colChkr), epochRangeChecker, iGoTargFastCheckerFn, 'color', cMap(iSigInd,:), 'linewidth', goLineW)
                iGoTargRTMean = round(mean(goTargFastCheckerEventLat{iSigInd, iSsdInd}));
                plot(ax(iRow, colChkr), iGoTargRTMean, iGoTargFastCheckerFn(iGoTargRTMean), '.k','markersize', markSize)
                
                iStopTargCheckerFn = stopTargCheckerFn{iSigInd,iSsdInd}(stopTargCheckerAlign{iSigInd,iSsdInd} + epochRangeChecker);
                plot(ax(iRow, colChkr), epochRangeChecker, iStopTargCheckerFn, 'color', stopColor, 'linewidth', stopLineW)
                iStopTargRTMean = round(mean(stopTargCheckerEventLat{iSigInd, iSsdInd}));
                plot(ax(iRow, colChkr), iStopTargRTMean, iStopTargCheckerFn(iStopTargRTMean), '.k','markersize', markSize)
                
                
                iGoTargFastSaccFn = goTargFastSaccFn{iSigInd,iSsdInd}(goTargFastSaccAlign{iSigInd,iSsdInd} + epochRangeSacc);
                plot(ax(iRow, colSacc), epochRangeSacc, iGoTargFastSaccFn, 'color', cMap(iSigInd,:), 'linewidth', goLineW)
                
                iStopTargSaccFn = stopTargSaccFn{iSigInd,iSsdInd}(stopTargSaccAlign{iSigInd,iSsdInd} + epochRangeSacc);
                plot(ax(iRow, colSacc), epochRangeSacc, iStopTargSaccFn, 'color', stopColor, 'linewidth', stopLineW)
                
                %                 iGoTargCheckerMean = round(mean(goTargFastSaccEventLat{iSigInd, iSsdInd}));
                %                 plot(ax(iRow, colSacc), iGoTargCheckerMean, iStopTargSaccFn(iGoTargCheckerMean), 'ok','markersize', 10)
                %                 iGoTargCheckerMean = round(mean(stopTargSaccEventLat{iSigInd, iSsdInd}));
                %                 plot(ax(iRow, colSacc), iGoTargCheckerMean, iStopTargSaccFn(iGoTargCheckerMean), 'ok','markersize', 10)
            end % for i = 1 : nUsable
            
        end % if plotFlag && nUsable > 0
        
        
        if printPlot
            localFigurePath = local_figure_path;
            %             print(figureHandle-1,[localFigurePath, sessionID, '_',Unit(kUnitIndex, jTarg).name, '_ccm_neuron_stop_vs_go_Left.pdf'],'-dpdf', '-r300')
            print(figureHandle,[localFigurePath, sessionID, '_',Unit(kUnitIndex, jTarg).name, '_ccm_go_vs_noncanceled.pdf'],'-dpdf', '-r300')
        end
        
        
        
        
        
        
        % Collect the data for later analyses
        Data(kUnitIndex).targ(jTarg).stopTargSpike      = stopTargSpike;
        Data(kUnitIndex).targ(jTarg).stopTargCheckerData        = stopTargCheckerData;
        Data(kUnitIndex).targ(jTarg).stopTargCheckerAlign        = stopTargCheckerAlign;
        Data(kUnitIndex).targ(jTarg).stopTargCheckerEventLat        = stopTargCheckerEventLat;
        Data(kUnitIndex).targ(jTarg).stopTargSaccData  	= stopTargSaccData;
        Data(kUnitIndex).targ(jTarg).stopTargSaccAlign        = stopTargSaccAlign;
        Data(kUnitIndex).targ(jTarg).stopTargSaccEventLat        = stopTargSaccEventLat;
        
        Data(kUnitIndex).targ(jTarg).goTargFastSpike    = goTargFastSpike;
        Data(kUnitIndex).targ(jTarg).goTargFastCheckerData      = goTargFastCheckerData;
        Data(kUnitIndex).targ(jTarg).goTargFastCheckerAlign      = goTargFastCheckerAlign;
        Data(kUnitIndex).targ(jTarg).goTargFastCheckerEventLat     = goTargFastCheckerEventLat;
        Data(kUnitIndex).targ(jTarg).goTargFastSaccData 	= goTargFastSaccData;
        Data(kUnitIndex).targ(jTarg).goTargFastSaccAlign      = goTargFastSaccAlign;
        Data(kUnitIndex).targ(jTarg).goTargFastSaccEventLat     = goTargFastSaccEventLat;
        
        %         Data(kUnitIndex).targ(jTarg).pValue = pValue;
        %         Data(kUnitIndex).targ(jTarg).stats = stats;
        
    end % for jTarg
end % for kUnitInd
















end % function


