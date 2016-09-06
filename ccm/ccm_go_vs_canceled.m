function Data = ccm_go_vs_canceled(subjectID, sessionID, options)

% ccm_go_vs_canceled(subjectID, sessionID, options)
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
    options.minTrialPerCond     = 15;
    options.cellType            =      'presacc';
    options.ssrt            =      [];
    options.Inh            =      [];
    options.filterData       = false;
    
    options.plotFlag            = true;
    options.printPlot           = false;
    options.figureHandle      	= 700;
    
    % Return just the default options struct if no input
    if nargin == 0
        Data           = options;
        return
    end
end

dataType            = options.dataType;
filterData          = options.filterData;
collapseSignal      = options.collapseSignal;
collapseTarg    	= options.collapseTarg;
latencyMatchMethod  = options.latencyMatchMethod;
minTrialPerCond     = options.minTrialPerCond;

plotFlag            = options.plotFlag;
printPlot           = options.printPlot;
figureHandle        = options.figureHandle;

% latencyMatchMethod = 'match';
% latencyMatchMethod = 'rt';


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
    optSess.dataType   = options.dataType;
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
nAngle              = length(targAngleArray);






%%   Get inhibition data from the session (unless user input in options):
    optInh              = options;
    optInh.plotFlag     = false;
    dataInh             = ccm_inhibition(subjectID, sessionID, optInh);





%%  Loop through Units and target pairs to collect and plot data

for kUnitIndex = 1 : nUnit
    
    for jTarg = 1 : nTargPair
        
        disp(Unit(kUnitIndex, jTarg).name)
        
        % Initialize the cell arrays to be used for analyses:
        
        %       ****** Decscriptions ******
        % stopStopCheckerData: canceled stop trials (markEvent = stop trial the monkey stopped on), CheckerData = rasters aligned on checker onset
        % stopStopCheckerAlign: where the rasters are aligned (the checker onset time)
        % stopStopCheckerEventaLat: Latency of some event (usually saccade, but can be defined as some other event) with respect to aligned data
        %
        % goTargSlowChecker? no-stop trials with correct choice (to target), aligned on checker onset
        % goTargSlowSacc? no-stop trials with correct choice (to target), aligned on saccade onset
        
        stopStopCheckerData          = cell(nSignal, nSSD);
        stopStopCheckerFn          = cell(nSignal, nSSD);
        stopStopCheckerEventLat  	= cell(nSignal, nSSD);
        stopStopCheckerAlign      	= cell(nSignal, nSSD);
        
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
                stopStopSpike           	= cell(nSignal, nSSD);
                goTargSlowSpike             = cell(nSignal, nSSD);
                cancelTime                  = nan(nSignal, nSSD);
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
                opt.eventMarkName   = 'targOn';
                opt.conditionArray  = {'stopStop'};
                opt.ssdArray        = mSSD;
                iStopStopChecker    = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                opt.epochName       = alignEvent;
                opt.eventMarkName   = markEvent;
                opt.conditionArray  = {'stopTarg'};
                iStopTargChecker       = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                
                % Continue processing this condition if there were any canceled stop trials
                if size(iStopStopChecker.eventLatency, 1) > 0
                    % Use a latency-matching method to get a (fast)
                    % subsample of go trials that match the noncanceled
                    % stop trials
                    switch latencyMatchMethod
                        
                        case 'ssrt'
                            iStopLatency = mSSD + ssrt;
                            %                             iGoFastTrial = iGoTargChecker.eventLatency <= iStopLatency & iGoTargChecker.eventLatency >  mSSD + encodeTime;
                            iGoSlowTrial = iGoTargChecker.eventLatency > iStopLatency;
                        case 'mean'
                            iGoTargRT = sort(iGoTargChecker.eventLatency);
                            meanStopTargRT = nanmean(iStopTargChecker.eventLatency);
                            while nanmean(iGoTargRT) > meanStopTargRT
                                iGoTargRT(end) = [];
                            end
                            iStopLatency = iGoTargRT(end);
                            iGoSlowTrial = iGoTargChecker.eventLatency > iStopLatency;
                        case 'match'
                            % Use nearest neighbor method to get rt-matched
                            % trials
                            nStopCorrect = size(iStopStopChecker.signal, 1);
                            data = ccm_match_rt(iGoTargChecker.eventLatency, iStopTargChecker.eventLatency(iStopTargTrial), nStopCorrect);
                            iGoSlowTrial = data.goSlowTrial;
                    end
                    
                    % Continue processing this condition if there were go fast trials
                    if sum(iGoSlowTrial)
                        
                        
                        
                        
                        
                        
                        % ****************************************************************
                        % COLLECT (AND ANALYZE) THE RELEVANT DATA
                        
                        stopStopCheckerData{iSigInd, mSSDInd}        = iStopStopChecker.signal;
                        stopStopCheckerAlign{iSigInd, mSSDInd}     	= iStopStopChecker.align;
                        stopStopCheckerEventLat{iSigInd, mSSDInd}	= iStopStopChecker.eventLatency;
                        
                        goTargSlowCheckerData{iSigInd, mSSDInd}      = iGoTargChecker.signal(iGoSlowTrial,:);
                        goTargSlowCheckerAlign{iSigInd, mSSDInd} 	= iGoTargChecker.align;
                        goTargSlowCheckerEventLat{iSigInd, mSSDInd}	= iGoTargChecker.eventLatency(iGoSlowTrial,:);
                        
                        goTargSlowSaccData{iSigInd, mSSDInd}         = iGoTargSacc.signal(iGoSlowTrial,:);
                        goTargSlowSaccAlign{iSigInd, mSSDInd}       = iGoTargSacc.align;
                        goTargSlowSaccEventLat{iSigInd, mSSDInd}    = iGoTargSacc.eventLatency(iGoSlowTrial,:);
                        
                        
                        
                        
                        switch dataType
                            case 'neuron'
                                stopStopCheckerFn{iSigInd, mSSDInd} 	= iStopStopChecker.signalFn;
                                goTargSlowCheckerFn{iSigInd, mSSDInd}      = nanmean(spike_density_function(goTargSlowCheckerData{iSigInd, mSSDInd}, Kernel), 1);
                                goTargSlowSaccFn{iSigInd, mSSDInd}         = nanmean(spike_density_function(goTargSlowSaccData{iSigInd, mSSDInd}, Kernel), 1);
                                
                                
                                
                                
                                
                                % TEST #1:
                                % Hanes et al 1998 (p.822) t-test of spike rates 40 ms surrounding estimated ssrt
                                stopStopSpike{iSigInd, mSSDInd}     = sum(iStopStopChecker.signal(:, spikeWindow + iStopStopChecker.align + mSSD + ssrt), 2);
                                goTargSlowSpike{iSigInd, mSSDInd}   = sum(iGoTargChecker.signal(iGoSlowTrial, spikeWindow + iGoTargChecker.align + mSSD + ssrt), 2);
                                [h,p,ci,sts]                        = ttest2(stopStopSpike{iSigInd, mSSDInd}, goTargSlowSpike{iSigInd, mSSDInd});
                                
                                pValue{iSigInd, mSSDInd}    = p;
                                stats{iSigInd, mSSDInd}     = sts;
                                
                                
                                
                                % TEST #2:
                                % Hanes et al 1998 (p.822) differential sdf test
                                % ------------------------------------------------------------------------
                                cTime = nan; % cancel time for this conditionInitialize to NaN;
                                sdfDiff = goTargSlowCheckerFn{iSigInd, mSSDInd}(iGoTargChecker.align + (-599 : epochRangeChecker(end)))' - stopStopCheckerFn{iSigInd, mSSDInd}(iStopStopChecker.align + (-599 : epochRangeChecker(end)))';
                                % If user thinks it's a fixation/stopping type cell, flip
                                % the sign of the differential sdf
                                if strcmp(options.cellType, 'fix')
                                    sdfDiff = -sdfDiff;
                                end
                                sdfDiffCheckerOn = 600;
                                stdDiff = std(sdfDiff(1:sdfDiffCheckerOn));
                                
                                
                                % are there times at which the difference between sdfs is
                                % greater than 2 standard deviations of the difference 600
                                % ms before checkerboard onset?
                                std2Ind = sdfDiff(sdfDiffCheckerOn : end) > 2*stdDiff;
                                
                                % Look for a sequence of 50 ms for which the go sdf is 2
                                % std greater than the stop sdf.
                                % First whether the differential sdf was > 2*Std for the
                                % first 50 ms
                                pass50msTestInd = [];
                                if sum(std2Ind(1:50)) == 50
                                    pass50msTestInd = 1;
                                else
                                    % If it wasn't, determein whether there was a time
                                    % after the checkerboard onset that the differential
                                    % sdf was > 2*Std for at least 50 ms.
                                    riseAbove2Std = find([0; diff(std2Ind)] == 1);
                                    sinkBelow2Std = find([0; diff(std2Ind)] == -1);
                                    if ~isempty(riseAbove2Std)
                                        % Get rid of occasions for which the signals differ
                                        % going into the epoch (and therefore they will
                                        % cease to differ before they begin again to
                                        % differ)
                                        if ~isempty(sinkBelow2Std)
                                            sinkBelow2Std(sinkBelow2Std < riseAbove2Std(1)) = [];
                                        end
                                        % Now riseAbove2Std length shouldb equal to or 1
                                        % more than sinkBelow2Std. If they're equal, see if
                                        % any of the riseAbove2Std streaks go longer than
                                        % 50ms
                                        if length(riseAbove2Std) == length(sinkBelow2Std)
                                            ind = find(sinkBelow2Std - riseAbove2Std >= 50, 1);
                                            if ~isempty(ind)
                                                pass50msTestInd = riseAbove2Std(ind);
                                            end
                                            % If they're not equal, the last riseAbove2Std
                                            % will last until the end of the sdf: see if
                                            % that is at least 50 ms
                                        elseif length(riseAbove2Std) > length(sinkBelow2Std)
                                            if riseAbove2Std(end) < length(std2Ind) - 49
                                                pass50msTestInd = riseAbove2Std(end);
                                            end
                                        end
                                    end
                                end
                                
                                
                                % If there werwe 50 consecutive ms of sdfDiff > 2*Std,
                                % check whether the difference ever reached 6*Std
                                if ~isempty(pass50msTestInd)
                                    std6Ind = sdfDiff(pass50msTestInd : end) > 6*stdDiff;
                                    if sum(std6Ind)
                                        % Cancel time will be Negative if
                                        % go SDF > stop SDF BEFORE SSRT
                                        cTime = pass50msTestInd - mSSD - ssrt;
                                        cancelTime(iSigInd, mSSDInd) = cTime;
                                    end
                                end
                                
                                fprintf('ssd: %d  \tgo v. stop: %.2f  %.2f sp, p = %.2f\t canceltime = %d\n',...
                                    mSSD, mean(goTargSlowSpike{iSigInd, mSSDInd}), mean(stopStopSpike{iSigInd, mSSDInd}), p, cancelTime(iSigInd, mSSDInd));
                                
                                
                            case {'lfp','erp'}
                                
                                stopStopCheckerFn{iSigInd, mSSDInd}  	= nanmean(iStopStopChecker.signal, 1);
                                goTargSlowCheckerFn{iSigInd, mSSDInd}      = nanmean(iGoTargChecker.signal(iGoSlowTrial,:), 1);
                                goTargSlowSaccFn{iSigInd, mSSDInd}         = nanmean(iGoTargSacc.signal(iGoSlowTrial,:), 1);
                                
                                
                                
                        end % switch dataType
                        % ****************************************************************
                        
                        
                        
                        size(iStopStopChecker.eventLatency, 1)
                        % Mark the data for later display if there were enough trials in both conditions
                        if sum(iGoSlowTrial) >= options.minTrialPerCond && size(iStopStopChecker.eventLatency, 1) >= options.minTrialPerCond
                            usableCondition(iSigInd, mSSDInd) = 1;
                            
                            
                        end
                    end % if sum(iGoSlowTrial)
                end % if sum(iStopStopSacc)
                
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
        signalVector    = repmat(reshape(pSignalPlot, nSignal, 1), 1, nSSD);
        signalVector    = signalVector(:);
        signalVector    = signalVector(usableCondition);
        ssdVector       = repmat(reshape(ssdArray, 1, nSSD), nSignal, 1);
        ssdVector       = ssdVector(:);
        ssdVector       = ssdVector(usableCondition);
        
        nUsable         = sum(usableCondition);
        
        
        
        if plotFlag && nUsable > 0
            
            
            cMap = ccm_colormap(pSignalPlot);
            if collapseSignal
                cMap = cMap .* .6;
            end
            stopColor = [.8 0 0];
            
            
            goLineW     = 2;
            stopLineW   = 2;
            markSize    = 20;
            nColumn     = 2;
            figureHandle = figureHandle + 1;
            %     nRow = max([nSignal, nLGraph, nRGraph]);
            nRow = max(3, nUsable);
            if printPlot
                [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'landscape', figureHandle);
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
            
            
            h=axes('Position', [0 0 1 1], 'Visible', 'Off');
            set(gcf, 'Name','Go v Canceled','NumberTitle','off')
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
                plot(ax(iRow, colChkr), [1 1], [0 sigMax], '-k', 'linewidth', 2)
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
                
                iGoTargRTMean = round(mean(goTargSlowCheckerEventLat{iSigInd, iSsdInd}));
                goTargSlowRTMean = round(mean(goTargSlowCheckerEventLat{iSigInd, iSsdInd}));
                
                % Checkerboard onset aligned
                iGoTargSlowCheckerFn = goTargSlowCheckerFn{iSigInd,iSsdInd}(goTargSlowCheckerAlign{iSigInd,iSsdInd} + epochRangeChecker);
                plot(ax(iRow, colChkr), epochRangeChecker, iGoTargSlowCheckerFn, 'color', cMap(iSigInd,:), 'linewidth', goLineW)
                if iGoTargRTMean < length(iGoTargSlowCheckerFn)
                    plot(ax(iRow, colChkr), iGoTargRTMean, iGoTargSlowCheckerFn(iGoTargRTMean), '.k','markersize', markSize)
                end
                
                iStopStopCheckerFn = stopStopCheckerFn{iSigInd,iSsdInd}(stopStopCheckerAlign{iSigInd,iSsdInd} + epochRangeChecker);
                plot(ax(iRow, colChkr), epochRangeChecker, iStopStopCheckerFn, 'color', stopColor, 'linewidth', stopLineW)
                
                % Saccade-aligned
                iGoTargSlowSaccFn = goTargSlowSaccFn{iSigInd,iSsdInd}(goTargSlowSaccAlign{iSigInd,iSsdInd} + epochRangeSacc);
                plot(ax(iRow, colSacc), epochRangeSacc, iGoTargSlowSaccFn, 'color', cMap(iSigInd,:), 'linewidth', goLineW)
                
                iStopStopSaccFn = stopStopCheckerFn{iSigInd,iSsdInd}(stopStopCheckerAlign{iSigInd,iSsdInd} + goTargSlowRTMean + epochRangeSacc);
                plot(ax(iRow, colSacc), epochRangeSacc, iStopStopSaccFn, 'color', stopColor, 'linewidth', stopLineW)
                
            end % for i = 1 : nUsable
            
        end % if plotFlag && nUsable > 0
        
        
        if printPlot
            localFigurePath = local_figure_path;
            print(figureHandle,[localFigurePath, sessionID, '_',Unit(kUnitIndex, jTarg).name, '_ccm_go_vs_canceled.pdf'],'-dpdf', '-r300')
        end
        
        
        
        
        
        
        
        % Collect the data for later analyses
        Data(kUnitIndex).targ(jTarg).stopStopCheckerData        = stopStopCheckerData;
        Data(kUnitIndex).targ(jTarg).stopStopCheckerAlign        = stopStopCheckerAlign;
        Data(kUnitIndex).targ(jTarg).stopStopCheckerEventLat        = stopStopCheckerEventLat;
        
        Data(kUnitIndex).targ(jTarg).goTargSlowCheckerData      = goTargSlowCheckerData;
        Data(kUnitIndex).targ(jTarg).goTargSlowCheckerAlign      = goTargSlowCheckerAlign;
        Data(kUnitIndex).targ(jTarg).goTargSlowCheckerEventLat     = goTargSlowCheckerEventLat;
        
        Data(kUnitIndex).targ(jTarg).goTargSlowSaccData 	= goTargSlowSaccData;
        Data(kUnitIndex).targ(jTarg).goTargSlowSaccAlign      = goTargSlowSaccAlign;
        Data(kUnitIndex).targ(jTarg).goTargSlowSaccEventLat     = goTargSlowSaccEventLat;
        
        switch dataType
            case 'neuron'
                Data(kUnitIndex).targ(jTarg).stopStopSpike      = stopStopSpike;
                Data(kUnitIndex).targ(jTarg).goTargSlowSpike    = goTargSlowSpike;
                Data(kUnitIndex).targ(jTarg).cancelTime    = cancelTime;
                
                
            case 'lfp'
                
            case 'erp'
                
        end % switch dataType
        
    end % for jTarg
end % for kUnitInd



















end % function


