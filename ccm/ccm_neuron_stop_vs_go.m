function Data = ccm_neuron_stop_vs_go(subjectID, sessionID, options)

% ccm_neuron_stop_vs_go(subjectID, sessionID, options)
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
%           'ssrt','match','mean';
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
    options.Unit            =      [];
    
    options.plotFlag            = true;
    options.printPlot           = false;
    options.figureHandle      	= 600;
    
    % Return just the default options struct if no input
    if nargin == 0
        Data           = options;
        return
    end
end


unitArray           = options.unitArray;
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


epochName       = 'checkerOn';
markEvent   = 'responseOnset';
encodeTime      = 10;



%%   Get neural data from the session/unit:

if isempty(options.Unit)
    optSess             = ccm_options;
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
nAngle              = length(targAngleArray);
ssdArray            = Unit(1).ssdArray;






%%   Get inhibition data from the session:

optInh              = ccm_inhibition;
optInh.collapseTarg = options.collapseTarg;
optInh.plotFlag     = false;
dataInh             = ccm_inhibition(subjectID, sessionID, optInh);





%%  Loop through Units and target pairs to collect and plot data

for kUnitIndex = 1 : nUnit
    
    for jTarg = 1 : nTargPair
        
        disp(Unit(kUnitIndex, jTarg).name)
        
        % For now, use the grand SSRT via integratin method
        if isempty(options.ssrt)
            ssrt = round(mean(dataInh(jTarg).ssrtIntegrationWeighted));
        else
            ssrt = options.ssrt;
        end
        
        
        
        nSignal = length(pSignalArray);
        % Get rid of 50% signal strength condition
        if ismember(.5, pSignalArray)
            [a,i] = ismember(.5, pSignalArray);
            pSignalArray(i) = [];
            dataInh(jTarg).nStopStop(i,:) = [];
            dataInh(jTarg).nStopTarg(i,:) = [];
        end
        
        
        
        % Figure out how many graphs we're going to draw: Each graph will be one or
        % more signal strength conditions within a single SSD, also separated by
        % response side
        
        % Find SSDs with enough trials to compare stop vs go (for each response direction)
        leftSigInd = pSignalArray < .5;
        rightSigInd = pSignalArray > .5;
        
        
        
        % Parse the conditions depending on whether you want to collapse across
        % signal strength conditions
        switch collapseSignal
            case false
                usableStopStop = dataInh(jTarg).nStopStop >= minTrialPerCond;
                usableStopTarg = dataInh(jTarg).nStopTarg >= minTrialPerCond;
                usableStop = usableStopStop | usableStopTarg;
            case true
                %       usableStopStopL = sum(dataInh(jTarg).nStopStop(leftSigInd,:)) >= minTrialPerCond;
                %       usableStopTargL = sum(dataInh(jTarg).nStopTarg(leftSigInd,:)) >= minTrialPerCond;
                %       usableStopStopR = sum(dataInh(jTarg).nStopStop(rightSigInd,:)) >= minTrialPerCond;
                %       usableStopTargR = sum(dataInh(jTarg).nStopTarg(rightSigInd,:)) >= minTrialPerCond;
                %       usableStop = [repmat(usableStopStopL, sum(leftSigInd), 1); repmat(usableStopStopR, sum(rightSigInd), 1)] | ...
                %          [repmat(usableStopTargL, sum(leftSigInd), 1); repmat(usableStopTargR, sum(rightSigInd), 1)];
        end
        
        
        
        % Sort the usable data by signat strength (then ssd)
        % Figure out how many graphs we're going to draw, both for left and
        % right targets. Each "graph" is a column of potentially 2 graphs-
        % noncanceled (top row) and canceled stop trials compared to their
        % latency-matched go trials. If there are enough trials in a given
        % signal strength/ssd condition, either or both
        % (canceled/noncancelled) will be collected (and plotted if desired).
        
        [sigI, ssdI] = find(usableStop);
        signalSSD = sortrows([sigI, ssdI]);  % Sort the data by signal strength (then ssd)
        nLGraph = length(find(usableStop(leftSigInd,:)));  % the number of SSDs to plot
        nRGraph = length(find(usableStop(rightSigInd,:)));
        nGraph = nLGraph + nRGraph;
        if nGraph == 0
            fprintf('ccm_neuron_stop_vs_go:   No conditions meet the requirement of %d trials per condition \n', minTrialPerCond)
            return
        end
        
        
        
        
        
        % Loop through each (set of) usable (enough trials as per
        % minTrialPerCond) signal strength/ssd condition.
        
        for i = 1 : nGraph
            
            
            
            % Creat a new figure if needed (for a new pair of targets and/or
            % left/right checker signal
            if plotFlag && (i == 1 || i == nLGraph + 1)
                
                cMap = ccm_colormap(pSignalArray);
                if collapseSignal
                    cMap = cMap .* .6;
                end
                
                
                targLineW = 2;
                tickWidth = 10;
                nRow = 2;
                figureHandle = figureHandle + 1;
                nColumn = max([nSignal, nLGraph, nRGraph]);
                if printPlot
                    [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(nRow, nColumn, figureHandle);
                else
                    [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = screen_figure(nRow, nColumn, figureHandle);
                end
                axisHeight = axisHeight * .9;
                clf
                
                opt = ccm_concat_neural_conditions; % Get default options structure
                
                opt.epochName = epochName;
                opt.markEvent = markEvent;
                opt.conditionArray = {'goTarg'};
                opt.colorCohArray = pSignalArray(leftSigInd);
                opt.ssdArray = ssdArray;
                
                dataL           = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                opt.colorCohArray = pSignalArray(rightSigInd);
                dataR           = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), opt);
                
                sdfAllL         = nanmean(spike_density_function(dataL.signal(:,:), Kernel), 1);
                sdfAllR         = nanmean(spike_density_function(dataR.signal(:,:), Kernel), 1);
                sdfMax          = max([sdfAllL, sdfAllR] .* 1.2);
                epochName       = 'checkerOn';
                epochRange      = ccm_epoch_range(epochName, 'plot');
                epochRange      = 0 : 400;
                
                h=axes('Position', [0 0 1 1], 'Visible', 'Off');
                titleString = sprintf('%s \t %s', sessionID, Unit(kUnitIndex, jTarg).name);
                text(0.5,1, titleString, 'HorizontalAlignment','Center', 'VerticalAlignment','Top')
            end
            
            
            
            
            % Gathe the signal strength and ssd for this usable data condition
            iSignalSSD = signalSSD(i, :);
            iSignalInd = signalSSD(i,1);
            iSSDInd  	= signalSSD(i,2);
            iSignalP   = pSignalArray(iSignalInd);
            iSSD       = ssdArray(iSSDInd);
            
            
            
            
            
            
            % Noncanceled Stop vs latency-matched (fast) Go:  Top row of graphs first
            if usableStopTarg(iSignalInd, iSSDInd)
                
                
                
                % Get the go trial data: these need to be split to latency-match with
                % the stop trial data
                iGoTarg      = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), epochName, markEvent, {'goTarg'}, iSignalP);
                iGoTargSacc      = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), 'responseOnset', 'checkerOn', {'goTarg'}, iSignalP);
                % Get the stop trial data
                iStopTarg    = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), epochName, markEvent, {'stopTarg'}, iSignalP, iSSD);
                iStopTargSacc    = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), 'responseOnset', 'checkerOn', {'stopTarg'}, iSignalP, iSSD);
                
                switch latencyMatchMethod
                    case 'ssrt'
                        iStopTargTrial = iStopTarg.eventLatency > iSSD + encodeTime;
                        iStopLatency = iSSD + ssrt;
                        iGoFastTrial = iGoTarg.eventLatency <= iStopLatency & iGoTarg.eventLatency >  iSSD + encodeTime;
                    case 'mean'
                        iGoTargRT = sort(iGoTarg.eventLatency);
                        meanStopTargRT = nanmean(iStopTarg.eventLatency);
                        while nanmean(iGoTargRT) > meanStopTargRT
                            iGoTargRT(end) = [];
                        end
                        iStopLatency = iGoTargRT(end);
                        iGoFastTrial = iGoTarg.eventLatency <= iStopLatency;
                    case 'match'
                        % Use nearest neighbor method to get rt-matched
                        % trials
                        nStopCorrect = size(iStopStop.signal, 1);
                        data = ccm_match_rt(iGoTarg.eventLatency, iStopTarg.eventLatency, nStopCorrect);
                        iGoFastTrial = data.goFastTrial;
                end
                iGoFastSDF   = nanmean(spike_density_function(iGoTarg.signal(iGoFastTrial,:), Kernel), 1);
                iStopTargSDF   = nanmean(spike_density_function(iStopTarg.signal(iStopTargTrial,:), Kernel), 1);
                
                
                % Hanes et al 1998 t-test of spike rates 40 ms surrounding estimated ssrt
                stopTargSpike = sum(iStopTarg.signal(iStopTargTrial, spikeWindow + iStopTarg.align + iSSD + ssrt), 2);
                goTargFastSpike = sum(iGoTarg.signal(iGoFastTrial, spikeWindow + iGoTarg.align + iSSD + ssrt), 2);
                [h,p,ci,stats] = ttest2(stopTargSpike, goTargFastSpike);
                
                
                % Collect the dat for later analyses
                Data(kUnitIndex).targ(jTarg).stopTarg(i).ssd = iSSD;
                Data(kUnitIndex).targ(jTarg).stopTarg(i).pSignal = iSignalP;
                Data(kUnitIndex).targ(jTarg).stopTarg(i).raster = iStopTarg.signal(iStopTargTrial,:);
                Data(kUnitIndex).targ(jTarg).stopTarg(i).spike = stopTargSpike;
                Data(kUnitIndex).targ(jTarg).stopTarg(i).tTest.p = p;
                Data(kUnitIndex).targ(jTarg).stopTarg(i).tTest.stats = stats;
                
                Data(kUnitIndex).targ(jTarg).goTargFast(i).ssd = iSSD;
                Data(kUnitIndex).targ(jTarg).goTargFast(i).pSignal = iSignalP;
                Data(kUnitIndex).targ(jTarg).goTargFast(i).raster = iGoTarg.signal(iGoFastTrial,:);
                Data(kUnitIndex).targ(jTarg).goTargFast(i).spike = goTargFastSpike;
                Data(kUnitIndex).targ(jTarg).goTargFast(i).tTest.p = p;
                Data(kUnitIndex).targ(jTarg).goTargFast(i).tTest.stats = stats;
                
                
                
                if plotFlag
                    % _______  Set up axes  ___________
                    % to target (and stop incorrect) trials
                    % axes names
                    if iSignalInd <= nSignal/2
                        iCol = i;
                    else
                        iCol = i - nLGraph;
                    end
                    rStopTarg = 1;
                    ax(rStopTarg, iCol) = axes('units', 'centimeters', 'position', [xAxesPosition(rStopTarg, iCol) yAxesPosition(rStopTarg, iCol) axisWidth axisHeight]);
                    set(ax(rStopTarg, iCol), 'ylim', [0 sdfMax * 1.1], 'xlim', [epochRange(1) epochRange(end)])
                    cla
                    hold(ax(rStopTarg, iCol), 'on')
                    plot(ax(rStopTarg, iCol), [0 0], [0 sdfMax], '-k', 'linewidth', 2)
                    ttl = sprintf('SSD:  %d', iSSD);
                    title(ttl)
                    
                    if i > 1
                        set(ax(rStopTarg, iCol), 'yticklabel', [])
                        set(ax(rStopTarg, iCol), 'ycolor', [1 1 1])
                    end
                    
                    iSSD
                    iStopTarg.eventLatency
                    
                    plot(ax(rStopTarg, iCol), [iSSD, iSSD], [0 sdfMax], 'color', [.2 .2 .2], 'linewidth', 1)
                    plot(ax(rStopTarg, iCol), [iSSD + ssrt, iSSD + ssrt], [0 sdfMax], '--', 'color', [0 0 0], 'linewidth', 1)
                    plot(ax(rStopTarg, iCol), epochRange, iGoFastSDF(iGoTarg.align + epochRange), 'color', cMap(iSignalInd,:), 'linewidth', targLineW)
                    plot(ax(rStopTarg, iCol), epochRange, iStopTargSDF(iStopTarg.align + epochRange), 'color', cMap(iSignalInd,:), 'linewidth', 1)
                end
                
            end  % if usableStopTarg(iSignalInd, iSSDInd)
            
            
            
            
            
            
            % Canceled Stop vs latency-matched (slow) Go:  Top row of graphs first
            if usableStopStop(iSignalInd, iSSDInd)
                
                
                
                % Get the go trial data: these need to be split to latency-match with
                % the stop trial data
                iGoTarg      = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), epochName, markEvent, {'goTarg'}, iSignalP);
                % Get the stop trial data
                iStopTarg    = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), epochName, markEvent, {'stopTarg'}, iSignalP, iSSD);
                iStopStop    = ccm_concat_neural_conditions(Unit(kUnitIndex, jTarg), epochName, markEvent, {'stopStop'}, iSignalP, iSSD);
                
                switch latencyMatchMethod
                    case 'ssrt'
                        iStopLatency = iSSD + ssrt;
                        iGoFastTrial = iGoTarg.eventLatency <= iStopLatency;
                        iGoSlowTrial = iGoTarg.eventLatency > iStopLatency;
                    case 'mean'
                        iGoTargRT = sort(iGoTarg.eventLatency);
                        meanStopTargRT = nanmean(iStopTarg.eventLatency);
                        while nanmean(iGoTargRT) > meanStopTargRT
                            iGoTargRT(end) = [];
                        end
                        iStopLatency = iGoTargRT(end);
                        iGoFastTrial = iGoTarg.eventLatency <= iStopLatency;
                        iGoSlowTrial = iGoTarg.eventLatency > iStopLatency;
                    case 'match'
                        % Use nearest neighbor method to get rt-matched
                        % trials
                        nStopCorrect = size(iStopStop.signal, 1);
                        data = ccm_match_rt(iGoTarg.eventLatency, iStopTarg.eventLatency, nStopCorrect);
                        iGoFastTrial = data.goFastTrial;
                        iGoSlowTrial = data.goSlowTrial;
                end
                
                iGoSlowSDF   = nanmean(spike_density_function(iGoTarg.signal(iGoSlowTrial,:), Kernel), 1);
                
                
                
                
                
                % TEST #1:
                % Hanes et al 1998 (p.822) t-test of spike rates 40 ms surrounding estimated ssrt
                % ------------------------------------------------------------------------
                stopStopSpike = sum(iStopStop.signal(:, spikeWindow + iStopStop.align + iSSD + ssrt), 2);
                goTargSlowSpike = sum(iGoTarg.signal(iGoSlowTrial, spikeWindow + iGoTarg.align + iSSD + ssrt), 2);
                [h,p,ci,stats] = ttest2(stopStopSpike, goTargSlowSpike);
                
                
                
                
                % TEST #2:
                % Hanes et al 1998 (p.822) differential sdf test
                % ------------------------------------------------------------------------
                cancelTime = nan; % Initialize to NaN;
                sdfDiff = iGoSlowSDF(iGoTarg.align + (-599 : epochRange(end)))' - iStopStop.sdf(iStopStop.align + (-599 : epochRange(end)))';
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
                        cancelTime = iSSD + ssrt - pass50msTestInd;
                    end
                end
                
                
                
                fprintf('ssd: %d  \tgo v. stop: %.2f  %.2f sp, p = %.2f\t canceltime = %d\n',...
                    iSSD, mean(goTargSlowSpike), mean(stopStopSpike), p, cancelTime);
                
                
                
                
                
                % Collect the dat for later analyses
                Data(kUnitIndex).targ(jTarg).stopStop(i).ssd        = iSSD;
                Data(kUnitIndex).targ(jTarg).stopStop(i).pSignal    = iSignalP;
                Data(kUnitIndex).targ(jTarg).stopStop(i).raster     = iStopStop.signal;
                Data(kUnitIndex).targ(jTarg).stopStop(i).spike      = stopStopSpike;
                Data(kUnitIndex).targ(jTarg).stopStop(i).tTest.p    = p;
                Data(kUnitIndex).targ(jTarg).stopStop(i).tTest.stats = stats;
                
                Data(kUnitIndex).targ(jTarg).goTargSlow(i).ssd      = iSSD;
                Data(kUnitIndex).targ(jTarg).goTargSlow(i).pSignal  = iSignalP;
                Data(kUnitIndex).targ(jTarg).goTargSlow(i).raster   = iGoTarg.signal(iGoSlowTrial,:);
                Data(kUnitIndex).targ(jTarg).goTargSlow(i).spike    = goTargSlowSpike;
                Data(kUnitIndex).targ(jTarg).goTargSlow(i).tTest.p  = p;
                Data(kUnitIndex).targ(jTarg).goTargSlow(i).tTest.stats = stats;
                
                
                
                if plotFlag
                    
                    % _______  Set up axes  ___________
                    % to target (and stop correct) trials
                    if iSignalInd <= nSignal/2
                        iCol = i;
                    else
                        iCol = i - nLGraph;
                    end
                    rStopStop = 2;
                    ax(rStopStop, iCol) = axes('units', 'centimeters', 'position', [xAxesPosition(rStopStop, iCol) yAxesPosition(rStopStop, iCol) axisWidth axisHeight]);
                    set(ax(rStopStop, iCol), 'ylim', [0 sdfMax * 1.1], 'xlim', [epochRange(1) epochRange(end)])
                    cla
                    hold(ax(rStopStop, iCol), 'on')
                    plot(ax(rStopStop, iCol), [0 0], [0 sdfMax], '-k', 'linewidth', 2)
                    if ~usableStopTarg(iSignalInd, iSSDInd)
                        ttl = sprintf('SSD:  %d', iSSD);
                        title(ttl)
                    end
                    
                    if i > 1
                        set(ax(rStopStop, iCol), 'yticklabel', [])
                        set(ax(rStopStop, iCol), 'ycolor', [1 1 1])
                    end
                    
                    plot(ax(rStopStop, iCol), [iSSD, iSSD], [0 sdfMax], 'color', [.2 .2 .2], 'linewidth', 1)
                    plot(ax(rStopStop, iCol), [iSSD + ssrt, iSSD + ssrt], [0 sdfMax], '--', 'color', [0 0 0], 'linewidth', 1)
                    plot(ax(rStopStop, iCol), epochRange, iGoSlowSDF(iGoTarg.align + epochRange), 'color', cMap(iSignalInd,:), 'linewidth', targLineW)
                    plot(ax(rStopStop, iCol), epochRange, iStopStop.sdf(iStopStop.align + epochRange), 'color', cMap(iSignalInd,:), 'linewidth', 1)
                    if ~isnan(cancelTime)
                        plot(ax(rStopStop, iCol), iSSD + ssrt - cancelTime, iStopStop.sdf(iStopStop.align + iSSD + ssrt - cancelTime), '.r', 'markersize', 20)
                    end
                end
                
            end
            
            
            
            
            
            
        end  % i = 1 : nGraph
        
        
        if printPlot
            localFigurePath = local_figure_path;
            print(figureHandle-1,[localFigurePath, sessionID, '_',Unit(kUnitIndex, jTarg).name, '_ccm_neuron_stop_vs_go_Left.pdf'],'-dpdf', '-r300')
            print(figureHandle,[localFigurePath, sessionID, '_',Unit(kUnitIndex, jTarg).name, '_ccm_neuron_stop_vs_go_Right.pdf'],'-dpdf', '-r300')
        end
        
        
    end % for jTarg = 1 : nTargPair
end % for kUnitIndex = 1 : nUnit

end % function


