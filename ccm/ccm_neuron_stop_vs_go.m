function Data = ccm_neuron_stop_vs_go(subjectID, sessionID, unitArray, options)

% ccm_neuron_stop_vs_go(subjectID, sessionID, options)
%
% Compares noncanceled stops trials vs. latency matched (fast) go trials and canceled stop trials vs. latency matched (slower) go trials.
%
% ALL CANCEL TIMES OUTPUT ARE RELATIVE TO CHECKERBOARD ONSET, SO YOU NEED
% TO SUBTRACT SSD AND SSRT TO CALCULATE CLASSIC "CANCEL TIME" (RELATIVE TO
% SSRT)
%
%
% If called without any arguments, returns a default options structure.
% If options are input but one is not specified, it assumes default.
%
% input:
%   subjectID: e.g. 'Broca', 'Xena', 'pm', etc
%   sessionID: e.g. 'bp111n01', 'Allsaccade'
%     unitArray       	= which units to analyze:
%           'each', <list of units in a cell array: e.g.:{'spikeUnit17a', spikeUnit17b'}>
%
% Possible options are (default listed first):
%     options.dataType        	= which recorded signal to analyze:
%           'neuron','lfp',eeg'
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

%%

% Set default options or return a default options structure
if nargin < 4
    %Data type to collect/analyze
    options.dataType        	= 'neuron';
    
    options.collapseSignal   	= false;
    options.collapseTarg        = true;
    options.latencyMatchMethod 	= 'ssrt';
    options.minTrialPerCond     = 10;
    options.cellType            =      'move';
    options.ssrt            =      [];
    options.USE_PRE_SSD = true;
    
    options.plotFlag            = true;
    options.printPlot           = true;
    
    % Return just the default options struct if no input
    if nargin == 0
        Data           = options;
        return
    end
end

% subjectID = 'broca';
% sessionID = 'bp093n02';
% unitArray = {'spikeUnit17a'};


dataType            = options.dataType;
collapseSignal      = options.collapseSignal;
latencyMatchMethod  = options.latencyMatchMethod;
minTrialPerCond     = options.minTrialPerCond;

plotFlag            = options.plotFlag;
printPlot           = options.printPlot;
stopStopFig        = 100;
stopTargFig        = 150;
nPlot               = 4; % plot only 3 conditions- those with highest number of stop trials

% latencyMatchMethod = 'match';
% latencyMatchMethod = 'rt';


Kernel.method = 'postsynaptic potential';
Kernel.growth = 1;
Kernel.decay = 20;


spikeWindow = -20 : 20;


epochName       = 'checkerOn';
markEvent   = 'responseOnset';
encodeTime      = 10;

epochRangeChecker      = 1 : 600;
epochRangeSacc      = -199 : 200;


%%   Get neural data from the session/unit:

optSess             = ccm_options;
optSess.plotFlag    = 0;
optSess.collapseTarg = options.collapseTarg;
optSess.unitArray   = unitArray;
optSess.USE_PRE_SSD   = options.USE_PRE_SSD;
Unit                = ccm_session_data(subjectID, sessionID, optSess);

if isempty(Unit)
    fprintf('Session %s does not contain spike data \n', sessionID)
    return
end

%%

% How many units were recorded?
[nUnit, nTargPair]  = size(Unit);
pSignalArray        = Unit(1).pSignalArray;
ssdArray            = Unit(1).ssdArray;

nSSD             = length(ssdArray);


%   Get the saccade receptive field
rf = ccm_find_saccade_rf(Unit);

%   Use rf to determine which color coherence conditions to analyze
switch rf
    case 'left'
        colorInd = pSignalArray < .5;
    case 'right'
        colorInd = pSignalArray > .5;
    case 'none'
        switch Unit(1).hemisphere
            case 'left'
                colorInd = pSignalArray > .5;
            case 'right'
                colorInd = pSignalArray < .5;
        end
end
rfColorCohArray = pSignalArray(colorInd);

%%   Get inhibition data from the session (unless user input in options):
optInh              = ccm_options;
optInh.plotFlag     = false;
dataInh             = ccm_inhibition(subjectID, sessionID, optInh);
%%

% Use only the color coherence conditions for the response field figured
% out above
nStopStop = dataInh.nStopStop(colorInd,:);
[nStopStop, indSS] = sort(nStopStop(:));
nStopTarg = dataInh.nStopTarg(colorInd,:);
[nStopTarg, indST] = sort(nStopTarg(:));

% Create arrays of the color coherence and ssd values that are
% usable (have enough data). Will loop through them below for each
% set of comparisons
usableStopStop = nStopStop >= minTrialPerCond;
usableStopTarg = nStopTarg >= minTrialPerCond;

% Vectorize color coherence and ssd matrices
colorCohMat = repmat(rfColorCohArray(:),1,nSSD);
colorCohMat = colorCohMat(:);

ssdMat = repmat(reshape(ssdArray,1,nSSD),length(rfColorCohArray),1);
ssdMat = ssdMat(:);

% Use sorted trial numbers to make lists of color coherence
% and ssd values to loop through for each condition
stopStopCoh = colorCohMat(indSS);
stopStopCoh = flipud(stopStopCoh(usableStopStop));
stopStopSsd = ssdMat(indSS);
stopStopSsd = flipud(stopStopSsd(usableStopStop));

stopTargCoh = colorCohMat(indST);
stopTargCoh = flipud(stopTargCoh(usableStopTarg));
stopTargSsd = ssdMat(indST);
stopTargSsd = flipud(stopTargSsd(usableStopTarg));




%%  Loop through Units and target pairs to collect and plot data

for kUnitIndex = 1 : nUnit
    
    disp(Unit(kUnitIndex).name)
    
    % Pre-allocate cell arrays
    cancelTime6Std = nan(length(stopStopCoh), 1);
    cancelTime4Std = nan(length(stopStopCoh), 1);
   cancelTime2Std = nan(length(stopStopCoh), 1);  % The index in the sdf after checker onset at wich the differential sdf passes the 50ms test
   pValue40msStopStop = nan(length(stopStopCoh), 1);  % The index in the sdf after checker onset at wich the differential sdf passes the 50ms test

    pValue40msStopTarg = nan(length(stopTargCoh), 1);  % The index in the sdf after checker onset at wich the differential sdf passes the 50ms test
  
    % Nonanceled Stop and Fast Go
    stopTargCheckerData          = cell(length(stopTargCoh), 1);
    stopTargCheckerFn          = cell(length(stopTargCoh), 1);
    stopTargCheckerEventLat  	= cell(length(stopTargCoh), 1);
    stopTargCheckerAlign      	= cell(length(stopTargCoh), 1);
    
    stopTargSaccData             = cell(length(stopTargCoh), 1);
    stopTargSaccFn             = cell(length(stopTargCoh), 1);
    stopTargSaccEventLat        = cell(length(stopTargCoh), 1);
    stopTargSaccAlign           = cell(length(stopTargCoh), 1);
    
    goTargFastCheckerData        = cell(length(stopTargCoh), 1);
    goTargFastCheckerFn        = cell(length(stopTargCoh), 1);
    goTargFastCheckerEventLat  	= cell(length(stopTargCoh), 1);
    goTargFastCheckerAlign    	= cell(length(stopTargCoh), 1);
    
    goTargFastSaccData        	= cell(length(stopTargCoh), 1);
    goTargFastSaccFn           = cell(length(stopTargCoh), 1);
    goTargFastSaccEventLat      = cell(length(stopTargCoh), 1);
    goTargFastSaccAlign         = cell(length(stopTargCoh), 1);
    
    stopTargSpike               = cell(length(stopTargCoh), 1);
    goTargFastSpike               = cell(length(stopTargCoh), 1);
    
    
    % Canceled Stop and Slow Go
    stopStopCheckerData          = cell(length(stopStopCoh), 1);
    stopStopCheckerFn          = cell(length(stopStopCoh), 1);
    stopStopCheckerEventLat  	= cell(length(stopStopCoh), 1);
    stopStopCheckerAlign      	= cell(length(stopStopCoh), 1);
    
    goTargSlowCheckerData        = cell(length(stopStopCoh), 1);
    goTargSlowCheckerFn        = cell(length(stopStopCoh), 1);
    goTargSlowCheckerEventLat  	= cell(length(stopStopCoh), 1);
    goTargSlowCheckerAlign    	= cell(length(stopStopCoh), 1);
    
    goTargSlowSaccData        	= cell(length(stopStopCoh), 1);
    goTargSlowSaccFn           = cell(length(stopStopCoh), 1);
    goTargSlowSaccEventLat      = cell(length(stopStopCoh), 1);
    goTargSlowSaccAlign         = cell(length(stopStopCoh), 1);
    
    
    stopStopSpike               = cell(length(stopStopCoh), 1);
    goTargSlowSpike               = cell(length(stopStopCoh), 1);
    
    
    % For now, use the grand SSRT via integratin method
    if isempty(options.ssrt)
        ssrt = round(mean(dataInh.ssrtIntegrationWeighted));
    else
        ssrt = options.ssrt;
    end
    
    
    
    
    
    
    % Loop through each (set of) usable (enough trials as per
    % minTrialPerCond) signal strength/ssd condition.
    
    
    
    
    % Creat a new figure if needed (for a new pair of targets and/or
    % left/right checker signal
    if plotFlag
        
        cMap = ccm_colormap(pSignalArray);
        stopColor = [.8 0 0];
        
        opt = ccm_concat_neural_conditions; % Get default options structure
        
        opt.epochName = 'responseOnset';
        opt.markEvent = markEvent;
        opt.conditionArray = {'goTarg'};
        opt.colorCohArray = rfColorCohArray;
        opt.ssdArray = ssdArray;
        
        dataAx           = ccm_concat_neural_conditions(Unit(kUnitIndex), opt);
        sdfMax         = 1.05 * max(nanmean(spike_density_function(dataAx.signal(:,:), Kernel), 1)) * 1.2;
        sdfMin = 0;
        
        goLineW = 2;
        stopLineW = 2;
        markSize = 20;
        tickWidth = 10;
        nRow = nPlot;
        nColumn = 2;
        colChkr = 1;
        colSacc = 2;
        
        stopStopFig = stopStopFig + 1;
        stopTargFig = stopTargFig + 1;
        %         if printPlot
        [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, 'portrait', stopStopFig);
        clf
        h=axes('Position', [0 0 1 1], 'Visible', 'Off');
        set(gcf, 'Name','Go v Canceled','NumberTitle','off')
        titleString = sprintf('%s \t %s', sessionID, Unit(kUnitIndex).name);
        text(0.5,1, titleString, 'HorizontalAlignment','Center', 'VerticalAlignment','Top')
        
        
        [~, ~, ~, ~] = standard_figure(nRow, nColumn, 'portrait', stopTargFig);
        clf
        h=axes('Position', [0 0 1 1], 'Visible', 'Off');
        set(gcf, 'Name','Go v Noncanceled','NumberTitle','off')
        titleString = sprintf('%s \t %s', sessionID, Unit(kUnitIndex).name);
        text(0.5,1, titleString, 'HorizontalAlignment','Center', 'VerticalAlignment','Top')
        %       else
        %             [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = screen_figure(nRow, nColumn, stopStopFig);
        %         clf
        %             [~, ~, ~, ~] = screen_figure(nRow, nColumn, stopTargFig);
        %         clf
        %         end
        axisHeight = axisHeight * .9;
        
    end
    
    
    
    
    
    
    
    %             $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %             $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %             $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    %%
    %               Noncanceled Stop vs latency-matched (fast) Go:
    if isempty(stopTargCoh)
        fprintf('Session %s doesn"t have enough noncanceled trials in any condiiton to analyze\n', sessionID)
    else
             fprintf('\nGo vs. Noncanceled:\n')
       for i = 1 : length(stopTargCoh)
            
            
            
            
            
            
            % Get the go trial data: these need to be split to latency-match with
            % the stop trial data
            opt                 = options; % Get default options structure
            
            opt.epochName       = epochName;
            opt.eventMarkName   = markEvent;
            opt.conditionArray  = {'goTarg'};
            opt.colorCohArray   = stopTargCoh(i);
            opt.ssdArray        = [];
            iGoTargChecker      = ccm_concat_neural_conditions(Unit(kUnitIndex), opt);
            
            opt.epochName       = 'responseOnset';
            opt.eventMarkName   = 'checkerOn';
            iGoTargSacc         = ccm_concat_neural_conditions(Unit(kUnitIndex), opt);
            
            
            
            
            % Get the stop trial data
            opt.epochName       = epochName;
            opt.eventMarkName   = markEvent;
            opt.conditionArray  = {'stopTarg'};
            opt.ssdArray        = stopTargSsd(i);
            iStopTargChecker    = ccm_concat_neural_conditions(Unit(kUnitIndex), opt);
            
            opt.conditionArray  = {'stopStop'};
            iStopStopChecker       = ccm_concat_neural_conditions(Unit(kUnitIndex), opt);
            
            opt.epochName       = 'responseOnset';
            opt.eventMarkName   = 'checkerOn';
            opt.conditionArray  = {'stopTarg'};
            iStopTargSacc       = ccm_concat_neural_conditions(Unit(kUnitIndex), opt);
            
            
            
                  
            % Use a latency-matching method to get a (fast)
            % subsample of go trials that match the noncanceled
            % stop trials
            switch latencyMatchMethod
                case 'ssrt'
                    iStopLatency = stopTargSsd(i) + ssrt;
                    iGoFastTrial = iGoTargChecker.eventLatency <= iStopLatency;
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
            
            
      % Use a subsample of the noncanceled stop RTs that are
            % later than the SSD plus some time to encode the stimulus
            if ~options.USE_PRE_SSD
                iGoFastTrial = iGoFastTrial & iGoTargChecker.eventLatency >  stopTargSsd(i) + encodeTime;
                iStopTargTrial = iStopTargChecker.eventLatency > stopTargSsd(i) + encodeTime;
            else
                % Do nothing for Go Trials, already got 'em above
                iStopTargTrial = 1 : length(iStopTargChecker.eventLatency);
            end
            
            
            
            % ****************************************************************
            % COLLECT (AND ANALYZE) THE RELEVANT DATA
            
            stopTargCheckerData{i}        = iStopTargChecker.signal(iStopTargTrial,:);
            stopTargCheckerAlign{i}     	= iStopTargChecker.align;
            stopTargCheckerEventLat{i}	= iStopTargChecker.eventLatency(iStopTargTrial,:);
            
            stopTargSaccData{i}           = iStopTargSacc.signal(iStopTargTrial,:);
            stopTargSaccAlign{i}         = iStopTargSacc.align;
            stopTargSaccEventLat{i}      = iStopTargSacc.eventLatency(iStopTargTrial,:);
            
            goTargFastCheckerData{i}      = iGoTargChecker.signal(iGoFastTrial,:);
            goTargFastCheckerAlign{i} 	= iGoTargChecker.align;
            goTargFastCheckerEventLat{i}	= iGoTargChecker.eventLatency(iGoFastTrial,:);
            
            goTargFastSaccData{i}         = iGoTargSacc.signal(iGoFastTrial,:);
            goTargFastSaccAlign{i}       = iGoTargSacc.align;
            goTargFastSaccEventLat{i}    = iGoTargSacc.eventLatency(iGoFastTrial,:);
            
            
            
            stopTargCheckerFn{i}      = nanmean(spike_density_function(stopTargCheckerData{i}, Kernel), 1);
            stopTargSaccFn{i}      = nanmean(spike_density_function(stopTargSaccData{i}, Kernel), 1);
            goTargFastCheckerFn{i}      = nanmean(spike_density_function(goTargFastCheckerData{i}, Kernel), 1);
            goTargFastSaccFn{i}         = nanmean(spike_density_function(goTargFastSaccData{i}, Kernel), 1);
            
            
            % Hanes et al 1998 t-test of spike rates 40 ms surrounding estimated ssrt
            stopTargSpike{i}     = sum(iStopTargChecker.signal(iStopTargTrial, spikeWindow + iStopTargChecker.align + stopTargSsd(i) + ssrt), 2);
            goTargFastSpike{i}   = sum(iGoTargChecker.signal(iGoFastTrial, spikeWindow + iGoTargChecker.align + stopTargSsd(i) + ssrt), 2);
            [h,p,ci,sts]                        = ttest2(stopTargSpike{i}, goTargFastSpike{i});
            
            pValue40msStopTarg(i)    = p;
            stats{i}     = sts;
            
         fprintf('ssd: %d  \tcolor: %.2f  \tgo v. stop: %.2f  %.2f sp, p = %.2f\n',...
                stopTargSsd(i), stopTargCoh(i), mean(goTargFastSpike{i}), mean(stopTargSpike{i}), p);
            
            
            
            if plotFlag && i <= nPlot
                figure(stopTargFig)
                
                % Data aligned on checkerboard onset
                ax(i, colChkr) = axes('units', 'centimeters', 'position', [xAxesPosition(i, colChkr) yAxesPosition(i, colChkr) axisWidth axisHeight]);
                set(ax(i, colChkr), 'ylim', [sdfMin sdfMax], 'xlim', [epochRangeChecker(1) epochRangeChecker(end)])
                cla
                hold(ax(i, colChkr), 'on')
                plot(ax(i, colChkr), [1 1], [sdfMin sdfMax * .9], '-k', 'linewidth', 2)
                ttl = sprintf('SSD: %d  pMag: %.2f', stopTargSsd(i), stopTargCoh(i));
                title(ttl)
                
                % Data aligned on response onset
                ax(i, colSacc) = axes('units', 'centimeters', 'position', [xAxesPosition(i, colSacc) yAxesPosition(i, colSacc) axisWidth axisHeight]);
                set(ax(i, colSacc), 'ylim', [sdfMin sdfMax], 'xlim', [epochRangeSacc(1) epochRangeSacc(end)])
                set(ax(i, colSacc), 'yticklabel', [], 'ycolor', [1 1 1])
                cla
                hold(ax(i, colSacc), 'on')
                plot(ax(i, colSacc), [1 1], [sdfMin sdfMax * .9], '-k', 'linewidth', 2)
                
                %     if i > 1
                %         set(ax(i, colChkr), 'yticklabel', [])
                %         set(ax(i, colChkr), 'ycolor', [1 1 1])
                %     end
                
                
                plot(ax(i, colChkr), [stopTargSsd(i), stopTargSsd(i)], [sdfMin sdfMax], 'color', [.2 .2 .2], 'linewidth', 1)
                plot(ax(i, colChkr), [stopTargSsd(i) + ssrt, stopTargSsd(i) + ssrt], [sdfMin sdfMax], '--', 'color', [0 0 0], 'linewidth', 1)
                
                iGoTargFastCheckerFn = goTargFastCheckerFn{i}(goTargFastCheckerAlign{i} + epochRangeChecker);
                plot(ax(i, colChkr), epochRangeChecker, iGoTargFastCheckerFn, 'color', cMap(pSignalArray == stopTargCoh(i),:), 'linewidth', goLineW)
                iGoTargRTMean = round(nanmean(goTargFastCheckerEventLat{i}));
                plot(ax(i, colChkr), iGoTargRTMean, iGoTargFastCheckerFn(iGoTargRTMean), '.k','markersize', markSize)
                
                iStopTargCheckerFn = stopTargCheckerFn{i}(stopTargCheckerAlign{i} + epochRangeChecker);
                plot(ax(i, colChkr), epochRangeChecker, iStopTargCheckerFn, 'color', stopColor, 'linewidth', stopLineW)
                iStopTargRTMean = round(nanmean(stopTargCheckerEventLat{i}));
                plot(ax(i, colChkr), iStopTargRTMean, iStopTargCheckerFn(iStopTargRTMean), '.k','markersize', markSize)
                
                
                iGoTargFastSaccFn = goTargFastSaccFn{i}(goTargFastSaccAlign{i} + epochRangeSacc);
                plot(ax(i, colSacc), epochRangeSacc, iGoTargFastSaccFn, 'color', cMap(pSignalArray == stopTargCoh(i),:), 'linewidth', goLineW)
                
                iStopTargSaccFn = stopTargSaccFn{i}(stopTargSaccAlign{i} + epochRangeSacc);
                plot(ax(i, colSacc), epochRangeSacc, iStopTargSaccFn, 'color', stopColor, 'linewidth', stopLineW)
                
                
            end
        end
        
    end
    
     
    
    %             $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %             $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %             $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    %%
    %               Canceled Stop vs latency-matched (Slow) Go:
    if isempty(stopStopCoh)
        fprintf('Session %s doesn"t have enough canceled trials in any condiiton to analyze\n', sessionID)
    else
             fprintf('\nGo vs. Canceled:\n')
        for i = 1 : length(stopStopCoh)
            
            
            
            
            % Get the go trial data: these need to be split to latency-match with
            % the stop trial data
            opt                 = options; % Get default options structure
            
            opt.epochName       = epochName;
            opt.eventMarkName   = markEvent;
            opt.conditionArray  = {'goTarg'};
            opt.colorCohArray   = stopStopCoh(i);
            opt.ssdArray        = [];
            iGoTargChecker      = ccm_concat_neural_conditions(Unit(kUnitIndex), opt);
            
            opt.epochName       = 'responseOnset';
            opt.eventMarkName   = 'checkerOn';
            iGoTargSacc         = ccm_concat_neural_conditions(Unit(kUnitIndex), opt);
            
            % Get the stop trial data
            opt.epochName       = epochName;
            opt.eventMarkName   = 'targOn';
            opt.conditionArray  = {'stopStop'};
            opt.ssdArray        = stopStopSsd(i);
            iStopStopChecker    = ccm_concat_neural_conditions(Unit(kUnitIndex), opt);
            
            opt.epochName       = epochName;
            opt.eventMarkName   = markEvent;
            opt.conditionArray  = {'stopTarg'};
            iStopTargChecker       = ccm_concat_neural_conditions(Unit(kUnitIndex), opt);
            
            
            
            % Use a latency-matching method to get a (fast)
            % subsample of go trials that match the noncanceled
            % stop trials
            switch latencyMatchMethod
                
                case 'ssrt'
                    iStopLatency = stopStopSsd(i) + ssrt;
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
            
            
            
            
            
            
            
            % ****************************************************************
            % COLLECT (AND ANALYZE) THE RELEVANT DATA
            
            stopStopCheckerData{i}        = iStopStopChecker.signal;
            stopStopCheckerAlign{i}     	= iStopStopChecker.align;
            stopStopCheckerEventLat{i}	= iStopStopChecker.eventLatency;
            
            goTargSlowCheckerData{i}      = iGoTargChecker.signal(iGoSlowTrial,:);
            goTargSlowCheckerAlign{i} 	= iGoTargChecker.align;
            goTargSlowCheckerEventLat{i}	= iGoTargChecker.eventLatency(iGoSlowTrial,:);
            
            goTargSlowSaccData{i}         = iGoTargSacc.signal(iGoSlowTrial,:);
            goTargSlowSaccAlign{i}       = iGoTargSacc.align;
            goTargSlowSaccEventLat{i}    = iGoTargSacc.eventLatency(iGoSlowTrial,:);
            
            
            
            
            stopStopCheckerFn{i} 	= iStopStopChecker.signalFn;
            goTargSlowCheckerFn{i}      = nanmean(spike_density_function(goTargSlowCheckerData{i}, Kernel), 1);
            goTargSlowSaccFn{i}         = nanmean(spike_density_function(goTargSlowSaccData{i}, Kernel), 1);
            
            
            
            
            
            % TEST #1:
            % Hanes et al 1998 (p.822) t-test of spike rates 40 ms surrounding estimated ssrt
            stopStopSpike{i}     = sum(iStopStopChecker.signal(:, spikeWindow + iStopStopChecker.align + stopStopSsd(i) + ssrt), 2) / length(spikeWindow) * 1000;
            goTargSlowSpike{i}   = sum(iGoTargChecker.signal(iGoSlowTrial, spikeWindow + iGoTargChecker.align + stopStopSsd(i) + ssrt), 2) / length(spikeWindow) * 1000;
            [h,p,ci,sts]       	= ttest2(stopStopSpike{i}, goTargSlowSpike{i});
            
            pValue40msStopStop(i)    = p;
            stats{i}     = sts;
            
            
            
            % TEST #2:
            % Hanes et al 1998 (p.822) differential sdf test
            % ------------------------------------------------------------------------
            sdfDiffCheckerOn = 500;
            % Differential sdf go - stopStop
            sdfDiff = goTargSlowCheckerFn{i}(iGoTargChecker.align + (-sdfDiffCheckerOn+1 : epochRangeChecker(end)))' - stopStopCheckerFn{i}(iStopStopChecker.align + (-sdfDiffCheckerOn+1 : epochRangeChecker(end)))';
            % If user thinks it's a fixation/stopping type cell, flip
            % the sign of the differential sdf
            if strcmp(options.cellType, 'fix')
                sdfDiff = -sdfDiff;
            end
            
            % Get the standard deviation of the differential sdf during the
            % 500 ms before checkerboard onset
            stdDiff = std(sdfDiff(1:sdfDiffCheckerOn));
            
            
            % are there times at which the difference between sdfs is
            % greater than 2 standard deviations of the difference 500
            % ms before checkerboard onset?
            std2Ind = sdfDiff(sdfDiffCheckerOn : end) > 2*stdDiff;
            
            % Look for a sequence of 50 ms for which the go sdf is 2
            % std greater than the stop sdf.
            % First whether the differential sdf was > 2*Std for the
            % first 50 ms
            if sum(std2Ind(1:50)) == 50
                cancelTime2Std(i) = 1;
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
                            cancelTime2Std(i) = riseAbove2Std(ind);
                        end
                        % If they're not equal, the last riseAbove2Std
                        % will last until the end of the sdf: see if
                        % that is at least 50 ms
                    elseif length(riseAbove2Std) > length(sinkBelow2Std)
                        if riseAbove2Std(end) < length(std2Ind) - 49
                            cancelTime2Std(i) = riseAbove2Std(end);
                        end
                    end
                end
            end
            
            
            % If there werwe 50 consecutive ms of sdfDiff > 2*Std,
            % check whether the difference ever reached 6*Std
            if ~isnan(cancelTime2Std(i))
                
                
                std4Ind = sdfDiff(sdfDiffCheckerOn : end) > 4*stdDiff;
                if sum(std4Ind)
                    
                    % Cancel time will be Negative if
                    % go SDF > stop SDF BEFORE SSRT (which is a good thing-
                    % means the neuron can contribute to controlling saccade
                    % initiation/inhibition.
                    cancelTime4Std(i) = find(std4Ind, 1) + cancelTime2Std(i);
                end
                std6Ind = sdfDiff(sdfDiffCheckerOn : end) > 6*stdDiff;
                if sum(std6Ind)
                     cancelTime6Std(i) = find(std6Ind, 1) + cancelTime2Std(i);
                end
                
                % If it didn't pass the 6 Std test, don't consider it to
                % have canceled (reset the 2 Std test to NaN
                if isnan(cancelTime6Std(i))
                    cancelTime2Std(i) = nan;
                end
            end
            
           fprintf('ssd: %d  \tcolor: %.2f  \tgo v. stop: %.1f  %.1f sp, p = %.2f\t canceltime = %d\n',...
                stopStopSsd(i), stopStopCoh(i), mean(goTargSlowSpike{i}), mean(stopStopSpike{i}), p, cancelTime2Std(i) - stopStopSsd(i) - ssrt);
            
            
            if plotFlag && i <= nPlot
                figure(stopStopFig)
                
                % Data aligned on checkerboard onset
                ax(i, colChkr) = axes('units', 'centimeters', 'position', [xAxesPosition(i, colChkr) yAxesPosition(i, colChkr) axisWidth axisHeight]);
                set(ax(i, colChkr), 'ylim', [sdfMin sdfMax], 'xlim', [epochRangeChecker(1) epochRangeChecker(end)])
                cla
                hold(ax(i, colChkr), 'on')
                plot(ax(i, colChkr), [1 1], [sdfMin sdfMax * .9], '-k', 'linewidth', 2)
                ttl = sprintf('SSD: %d  pMag: %.2f', stopStopSsd(i), stopStopCoh(i));
                title(ttl)
                
                % Data aligned on response onset
                ax(i, colSacc) = axes('units', 'centimeters', 'position', [xAxesPosition(i, colSacc) yAxesPosition(i, colSacc) axisWidth axisHeight]);
                set(ax(i, colSacc), 'ylim', [sdfMin sdfMax], 'xlim', [epochRangeSacc(1) epochRangeSacc(end)])
                set(ax(i, colSacc), 'yticklabel', [], 'ycolor', [1 1 1])
                cla
                hold(ax(i, colSacc), 'on')
                plot(ax(i, colSacc), [1 1], [sdfMin sdfMax * .9], '-k', 'linewidth', 2)
                
                
                
                plot(ax(i, colChkr), [stopStopSsd(i), stopStopSsd(i)], [sdfMin sdfMax], 'color', [.2 .2 .2], 'linewidth', 1)
                plot(ax(i, colChkr), [stopStopSsd(i) + ssrt, stopStopSsd(i) + ssrt], [sdfMin sdfMax], '--', 'color', [0 0 0], 'linewidth', 1)
                
                iGoTargRTMean = round(nanmean(goTargSlowCheckerEventLat{i}));
                
                % Checkerboard onset aligned
                iGoTargSlowCheckerFn = goTargSlowCheckerFn{i}(goTargSlowCheckerAlign{i} + epochRangeChecker);
                plot(ax(i, colChkr), epochRangeChecker, iGoTargSlowCheckerFn, 'color', cMap(pSignalArray == stopStopCoh(i),:), 'linewidth', goLineW)
                if iGoTargRTMean < length(iGoTargSlowCheckerFn)
                    plot(ax(i, colChkr), iGoTargRTMean, iGoTargSlowCheckerFn(iGoTargRTMean), '.k','markersize', markSize)
                end
                
                iStopStopCheckerFn = stopStopCheckerFn{i}(stopStopCheckerAlign{i} + epochRangeChecker);
                plot(ax(i, colChkr), epochRangeChecker, iStopStopCheckerFn, 'color', stopColor, 'linewidth', stopLineW)
%                 plot(ax(i, colChkr), epochRangeChecker, sdfDiff(sdfDiffCheckerOn-1:end), 'color', 'g', 'linewidth', stopLineW)
                
                % Saccade-aligned
                iGoTargSlowSaccFn = goTargSlowSaccFn{i}(goTargSlowSaccAlign{i} + epochRangeSacc);
                plot(ax(i, colSacc), epochRangeSacc, iGoTargSlowSaccFn, 'color', cMap(pSignalArray == stopStopCoh(i),:), 'linewidth', goLineW)
                
%                 iStopStopSaccFn = stopStopCheckerFn{i}(stopStopCheckerAlign{i} + iGoTargRTMean + epochRangeSacc);
%                 plot(ax(i, colSacc), epochRangeSacc, iStopStopSaccFn, 'color', stopColor, 'linewidth', stopLineW)
                
            end
        end
        
        
    end
    
    
   
    
    %             $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %             $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %             $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %             $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    
    
    
    % Collect the data for later analyses
   Data(kUnitIndex).rf      = {rf};
   Data(kUnitIndex).ssrt      = ssrt;

    %               Nonanceled Stop vs latency-matched (Fast) Go:
    Data(kUnitIndex).stopStopCoh      = stopStopCoh;
    Data(kUnitIndex).stopStopSsd      = stopStopSsd;
    Data(kUnitIndex).stopTargCoh      = stopTargCoh;
    Data(kUnitIndex).stopTargSsd      = stopTargSsd;

    Data(kUnitIndex).stopTargSpike      = stopTargSpike;
    Data(kUnitIndex).stopTargCheckerData        = stopTargCheckerData;
    Data(kUnitIndex).stopTargCheckerAlign        = stopTargCheckerAlign;
    Data(kUnitIndex).stopTargCheckerEventLat        = stopTargCheckerEventLat;
    Data(kUnitIndex).stopTargSaccData  	= stopTargSaccData;
    Data(kUnitIndex).stopTargSaccAlign        = stopTargSaccAlign;
    Data(kUnitIndex).stopTargSaccEventLat        = stopTargSaccEventLat;
    
    Data(kUnitIndex).goTargFastSpike    = goTargFastSpike;
    Data(kUnitIndex).goTargFastCheckerData      = goTargFastCheckerData;
    Data(kUnitIndex).goTargFastCheckerAlign      = goTargFastCheckerAlign;
    Data(kUnitIndex).goTargFastCheckerEventLat     = goTargFastCheckerEventLat;
    Data(kUnitIndex).goTargFastSaccData 	= goTargFastSaccData;
    Data(kUnitIndex).goTargFastSaccAlign      = goTargFastSaccAlign;
    Data(kUnitIndex).goTargFastSaccEventLat     = goTargFastSaccEventLat;
    
        Data(kUnitIndex).pValue40msStopTarg     = pValue40msStopTarg;

    
    
    %               Canceled Stop vs latency-matched (Slow) Go:
    Data(kUnitIndex).stopStopCheckerData        = stopStopCheckerData;
    Data(kUnitIndex).stopStopCheckerAlign        = stopStopCheckerAlign;
    Data(kUnitIndex).stopStopCheckerEventLat        = stopStopCheckerEventLat;
    
    Data(kUnitIndex).goTargSlowCheckerData      = goTargSlowCheckerData;
    Data(kUnitIndex).goTargSlowCheckerAlign      = goTargSlowCheckerAlign;
    Data(kUnitIndex).goTargSlowCheckerEventLat     = goTargSlowCheckerEventLat;
    
    Data(kUnitIndex).goTargSlowSaccData 	= goTargSlowSaccData;
    Data(kUnitIndex).goTargSlowSaccAlign      = goTargSlowSaccAlign;
    Data(kUnitIndex).goTargSlowSaccEventLat     = goTargSlowSaccEventLat;
    
    Data(kUnitIndex).stopStopSpike      = stopStopSpike;
    Data(kUnitIndex).goTargSlowSpike    = goTargSlowSpike;
    
    
    Data(kUnitIndex).stopTargCoh    = stopTargCoh;
    Data(kUnitIndex).stopTargSsd    = stopTargSsd;
    Data(kUnitIndex).stopStopCoh    = stopStopCoh;
    Data(kUnitIndex).stopStopSsd    = stopStopSsd;
    
    Data(kUnitIndex).pValue40msStopStop     = pValue40msStopStop;
    Data(kUnitIndex).cancelTime2Std    = cancelTime2Std;
    Data(kUnitIndex).cancelTime4Std    = cancelTime4Std;
    Data(kUnitIndex).cancelTime6Std    = cancelTime6Std;
    
    Data(kUnitIndex).inhibition    = dataInh;
    Data(kUnitIndex).pSignalArray    = pSignalArray;
    
    if printPlot
        print(stopTargFig,fullfile(local_figure_path, subjectID, [sessionID, '_ccm_go_vs_noncanceled_',Unit(kUnitIndex).name, '.pdf']),'-dpdf', '-r300')
        print(stopStopFig,fullfile(local_figure_path, subjectID, [sessionID, '_ccm_go_vs_canceled_',Unit(kUnitIndex).name, '.pdf']),'-dpdf', '-r300')
    end
    
    
end % for kUnitIndex = 1 : nUnit

end % function


