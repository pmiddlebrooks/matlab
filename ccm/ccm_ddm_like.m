function ddmLike = ccm_ddm_like(subjectID, sessionID, varargin)


% ccm_ddm_like(subjectID, sessionID, varargin)
%
% Compares noncanceled stops trials vs. latency matched (fast) go trials and canceled stop trials vs. latency matched (slower) go trials.
%
% input:
%   subjectID: e.g. 'Broca', 'Xena', 'pm', etc
%   sessionID: e.g. 'bp111n01', 'Allsaccade'
%
%   varargin: property names and their values:
%           'plotFlag': 0 or 1
%           'printPlot': 0 or 1: If set to 1, this prints the figure in the local_figures folder
%           'unitArray': a single unit, like 'spikeUnit17a', or an array of units, like {'spikeUnit17a', 'spikeUnit17b'}
%           'latencyMatchMethod': 'ssrt' or 'rt': do latency matching based on 'ssrt' or using the rt distributions to latcency match

%%
% Set defaults
plotFlag    = 1;
printPlot   = 0;
unitArray   = {};
figureHandle = 5000;
for i = 1 : 2 : length(varargin)
   switch varargin{i}
      case 'plotFlag'
         plotFlag = varargin{i+1};
      case 'printPlot'
         printPlot = varargin{i+1};
      case 'unitArray'
         unitArray = varargin{i+1};
      case 'figureHandle'
         figureHandle = varargin{i+1};
      otherwise
   end
end

% ________________________________________________________________
% DELCARE CONSTNANTS AND PREPARE DATA
% Constants: 

% These will determine the trial-to-trial epochs used for analyses:
epochOffset = 80;  % When to begin spike rate analysis after stimulus (checkerboard) onset
preSaccadeBuffer = 50; % When to cut off spike rate analysis before saccade onset
minEpochDuration = 20; % Only include trials for which the determined epoch is this long



% Load the data
[trialData, SessionData, ExtraVar] = load_data(subjectID, sessionID);
pSignalArray = ExtraVar.pSignalArray;
ssdArray = ExtraVar.ssdArray;
pSignalArray = pSignalArray(pSignalArray ~= .5);

if ~isfield(SessionData, 'spikeUnitArray') || isempty(SessionData.spikeUnitArray)
   fprintf('Session %s does not contain spike data \n', sessionID)
   ddmLike = [];
   return
end

if isempty(unitArray)
   unitArray = SessionData.spikeUnitArray;
end
[a, spikeUnit] = ismember(unitArray, SessionData.spikeUnitArray);




% For now use a convolved spike density function.. but see Ding and Gold,
% who do calculations on an "unfiltered spike density function".
Kernel.method = 'postsynaptic potential';
Kernel.growth = 1;
Kernel.decay = 20;


% MIN_RT = 120;
% RT must be before the sum of the following to be included in analyses:
MIN_RT = epochOffset + minEpochDuration + preSaccadeBuffer; 
MAX_RT = 1200;
STD_MULTIPLE = 3;
% Get rid of trials with outlying RTs
[allRT, rtOutlierTrial] = truncate_rt(trialData.rt, MIN_RT, MAX_RT, STD_MULTIPLE);
% rtOutlierTrial = [];
trialData(rtOutlierTrial,:) = [];
trialData(isnan(trialData.rt),:) = [];

signalLeftP = pSignalArray(pSignalArray < .5);
signalRightP = pSignalArray(pSignalArray > .5);

% Get default trial selection options
selectOpt = ccm_trial_selection;
selectOpt.ssd = 'none';
selectOpt.outcome = {'goCorrectTarget'};

selectOpt.rightCheckerPct = signalLeftP * 100;
leftTrial = ccm_trial_selection(trialData, selectOpt);
selectOpt.rightCheckerPct = signalRightP * 100;
rightTrial = ccm_trial_selection(trialData, selectOpt);

trialData = [trialData(leftTrial,:); trialData(rightTrial,:)];
nTrial = size(trialData, 1);
leftTrial = 1 : length(leftTrial);
rightTrial = 1 + length(leftTrial) : nTrial;



for iUnit = 1 : length(spikeUnit)
   % Go to Target trials
   alignmentTimeList = trialData.checkerOn;
   [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(:, spikeUnit(iUnit)), alignmentTimeList);
   sdfLeft = nanmean(spike_density_function(alignedRasters(leftTrial,:), Kernel), 1);
   sdfRight = nanmean(spike_density_function(alignedRasters(rightTrial,:), Kernel), 1);
   alignedRasters = num2cell(alignedRasters, 2);
   
   
   medianLeftRT = round(nanmedian(trialData.rt(leftTrial)));
   medianRightRT = round(nanmedian(trialData.rt(rightTrial)));
   
   
   
   
   % Ding and Gold use the median RT for their end-of-epoch, and truncate
   % the epochs on a trial-to-trial basis when a trial RT is shorter than the
   % median RT. My RTs are pretty quick as is, though, so I will define an
   % epoch ending on every trial based on the RT of that trial (and thus
   % skip the first pass of using median RT).
   
   %    epochEnd = [medianLeftRT * ones(length(leftTrial), 1); medianRightRT * ones(length(rightTrial), 1)];
   epochEnd = [nan(length(leftTrial), 1); nan(length(rightTrial), 1)];
   %    epochEnd = epochEnd - preSaccadeBuffer;
   % replace epoch-cutoffs for trials with rts shorter than the median RT
   %    epochEnd(leftTrial) = alignmentIndex + min(trialData.rt(leftTrial) - preSaccadeBuffer, epochEnd(leftTrial));
   %    epochEnd(rightTrial) = alignmentIndex + min(trialData.rt(rightTrial) - preSaccadeBuffer, epochEnd(rightTrial));
   epochEnd(leftTrial) = alignmentIndex + trialData.rt(leftTrial) - preSaccadeBuffer;
   epochEnd(rightTrial) = alignmentIndex + trialData.rt(rightTrial) - preSaccadeBuffer;
   epochBegin = alignmentIndex + epochOffset * ones(nTrial, 1);
   epochDuration = epochEnd - epochBegin;
   
   excludeTrial = find(epochDuration < minEpochDuration);
   leftTrial(ismember(leftTrial, excludeTrial))= [];
   rightTrial(ismember(rightTrial, excludeTrial))= [];
   
   nSpike = cellfun(@(x,y,z) sum(x(y:z)), alignedRasters, num2cell(epochBegin), num2cell(epochEnd), 'uniformoutput', false);
   spikeRate = cell2mat(nSpike) .* 1000 ./ epochDuration;
   
   
   
   data(iUnit).spikeRate      = spikeRate;
   data(iUnit).leftTrial      = leftTrial;
   data(iUnit).rightTrial     = rightTrial;
   data(iUnit).signalP        = trialData.targ1CheckerProp;
   data(iUnit).alignedRasters = alignedRasters;
   data(iUnit).alignIndex     = alignmentIndex;
   data(iUnit).epochOffset    = epochOffset;
   
   
   
   [ddmData] = ding_gold_ddm_like(data(iUnit));
   choiceDependent(iUnit) = ddmData.choiceDependent;
   coherenceDependent(iUnit) = ddmData.coherenceDependent;
   ddmLike(iUnit) = ddmData.ddmLike;
   
   clear data alignedRasters
   
   
   
   
   
   
   %%
   
   % ________________________________________________________________
   % PLOT THE DATA
   
   if plotFlag
      
      % SET UP PLOT
      lineW = 2;
      plotEpochRange = [-200 : 300];
      plotEpochRange = [-49 : 250];
      cMap = ccm_colormap(pSignalArray);
      leftColor = cMap(1,:) .* .8;
      rightColor = cMap(end,:) .* .8;
      nRow = 2;
      nColumn = 3;
      figureHandle = figureHandle + 1;
      if printPlot
         [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(nRow, nColumn, figureHandle);
      else
         [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = screen_figure(nRow, nColumn, figureHandle);
      end
      clf
      axChoice = 1;
      axCoh = 2;
      axCohL = 3;
      axCohR = 4;
      
      
      
      ax(axChoice) = axes('units', 'centimeters', 'position', [xAxesPosition(axChoice, 2) yAxesPosition(axChoice, 2) axisWidth axisHeight]);
      cla
      hold(ax(axChoice), 'on')
      switch choiceDependent(iUnit)
         case true
            choiceStr = 'YES';
         otherwise
            choiceStr = 'NO';
      end
      tt = sprintf('Choice dependence: %s', choiceStr);
      title(tt)
      
      ax(axCohL) = axes('units', 'centimeters', 'position', [xAxesPosition(2, 1) yAxesPosition(2, 1) axisWidth axisHeight]);
      cla
      hold(ax(axCohL), 'on')
      title('Coherence dependence')
      
      ax(axCohR) = axes('units', 'centimeters', 'position', [xAxesPosition(2, 3) yAxesPosition(2, 3) axisWidth axisHeight]);
      cla
      hold(ax(axCohR), 'on')
      title('Coherence dependence')
      
      ax(axCoh) = axes('units', 'centimeters', 'position', [xAxesPosition(2, 2)*1.1 yAxesPosition(2, 2)*.9 axisWidth/2 axisHeight]);
      cla
      hold(ax(axCoh), 'all')
      switch coherenceDependent(iUnit)
         case true
            cohStr = 'YES';
         otherwise
            cohStr = 'NO';
      end
      tt = sprintf('Coherence dependence: %s', cohStr);
      title(tt)
      
      
      sdfMax = max(max(sdfLeft(alignmentIndex + plotEpochRange)), max(sdfRight(alignmentIndex + plotEpochRange)));
      yMax = 1.1 * sdfMax;
      fillX = [epochOffset, nanmean(epochEnd)-alignmentIndex, nanmean(epochEnd)-alignmentIndex, epochOffset];
      fillY = [.1 .1 yMax yMax];
      fillColor = [1 1 .5];
      
      % CHOICE DEPENDENCE PLOTTING(LEFT VS. RIGHT CHOICE FOR CORRECT TRIALS)
      axes(ax(axChoice))
      h = fill(fillX, fillY, fillColor);
      set(h, 'edgecolor', 'none');
%       plot(ax(axChoice), [min(epochEnd)-alignmentIndex min(epochEnd)-alignmentIndex], [0 yMax], '-b', 'linewidth', 1);
%       plot(ax(axChoice), [max(epochEnd)-alignmentIndex max(epochEnd)-alignmentIndex], [0 yMax], '-b', 'linewidth', 1);
      plot(ax(axChoice), plotEpochRange, sdfLeft(alignmentIndex + plotEpochRange), 'color', leftColor, 'linewidth', lineW)
      plot(ax(axChoice), plotEpochRange, sdfRight(alignmentIndex + plotEpochRange), 'color', rightColor, 'linewidth', lineW)
      plot(ax(axChoice), [1 1], [0 yMax], '-k', 'linewidth', 2);
      set(ax(axChoice), 'xlim', [plotEpochRange(1) plotEpochRange(end)], 'ylim', [0 yMax])
      
      
      
      
      
      
      
      % COHERENCE PLOTTING
      
      minColorGun = 0;
      maxColorGun = 1;
      epochRange = ccm_epoch_range('checkerOn', 'plot');
      % Leftward trials
      
      plot(ax(axCohL), [0 0], [0 yMax], '-k', 'linewidth', 2);
      axes(ax(axCohL))
      h = fill(fillX, fillY, fillColor);
      set(h, 'edgecolor', 'none');
      
      for i = 1 : length(signalLeftP)
         iProp = pSignalArray(i);
         
         % Determine color to use for plot based on which checkerboard color
         % proportion being used. Normalize the available color spectrum to do
         % it
         inhColor = cMap(i,:);
         
         leftTrialData = trialData(leftTrial,:);
         signalTrial = leftTrial(leftTrialData.targ1CheckerProp == iProp);
         % Go to Target trials
         alignmentTimeList = trialData.checkerOn(signalTrial);
         [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(signalTrial, spikeUnit(iUnit)), alignmentTimeList);
         sdfLeft = nanmean(spike_density_function(alignedRasters, Kernel), 1);
         
         plot(ax(axCohL), plotEpochRange, sdfLeft(alignmentIndex + plotEpochRange), 'color', inhColor, 'linewidth', lineW)
         set(ax(axCohL), 'xlim', [plotEpochRange(1) plotEpochRange(end)], 'ylim', [0 yMax])
         
%          scatter(ax(axCoh), trialData.targ1CheckerProp(signalTrial), spikeRate(signalTrial), 'o', 'markeredgecolor', inhColor, 'markerfacecolor', inhColor, 'sizedata', 20)
%          boxplot(ax(axCoh), trialData.targ1CheckerProp(signalTrial), spikeRate(signalTrial))
%          boxplot(ax(axCoh), spikeRate(signalTrial), trialData.targ1CheckerProp(signalTrial))
      end % for i = 1 : length(signalLeftP)
      
      
      
      % Rightward trials
      
      plot(ax(axCohR), [0 0], [0 yMax], '-k', 'linewidth', 2);
      axes(ax(axCohR))
      h = fill(fillX, fillY, fillColor);
      set(h, 'edgecolor', 'none');
      for i = (i+1) : (length(signalLeftP) + length(signalRightP))
         iProp = pSignalArray(i);
         
         % Determine color to use for plot based on which checkerboard color
         % proportion being used. Normalize the available color spectrum to do
         % it
         inhColor = cMap(i,:);
         
         rightTrialData = trialData(rightTrial,:);
         signalTrial = rightTrial(rightTrialData.targ1CheckerProp == iProp);
         % Go to Target trials
         alignmentTimeList = trialData.checkerOn(signalTrial);
         if ~isempty(alignmentTimeList)
            [alignedRasters, alignmentIndex] = spike_to_raster(trialData.spikeData(signalTrial, spikeUnit(iUnit)), alignmentTimeList);
            sdfRight = nanmean(spike_density_function(alignedRasters, Kernel), 1);
            
            plot(ax(axCohR), plotEpochRange, sdfRight(alignmentIndex + plotEpochRange), 'color', inhColor, 'linewidth', lineW)
            set(ax(axCohR), 'xlim', [plotEpochRange(1) plotEpochRange(end)], 'ylim', [0 yMax])
            
%             scatter(ax(axCoh), trialData.targ1CheckerProp(signalTrial), spikeRate(signalTrial), 'o', 'markeredgecolor', inhColor, 'markerfacecolor', inhColor, 'sizedata', 30)
         end
      end % for i = 1 : length(signalRightP)
      
      
         boxplot(ax(axCoh), spikeRate, trialData.targ1CheckerProp, 'position', pSignalArray, 'colors', cMap, 'plotstyle', 'compact')
%          set(ax(axCoh), 'ylim', [0 yMax])
      
      % regressions on trial-by-trial spike rates in the epoch
      xLeft = (signalLeftP(1) : .01 : signalLeftP(end));
      xRight = (signalRightP(1) : .01 : signalRightP(end));
      switch ddmData.leftIsIn
         case true
            yLeft = ddmData.pIn(1) .* xLeft + ddmData.pIn(2);
            yRight = ddmData.pOut(1) .* xRight + ddmData.pOut(2);
         case false
            yRight = ddmData.pIn(1) .* xRight + ddmData.pIn(2);
            yLeft = ddmData.pOut(1) .* xLeft + ddmData.pOut(2);
      end
      plot(ax(axCoh), xLeft, yLeft, '-k', 'lineWidth', lineW)
      plot(ax(axCoh), xRight, yRight, '-k', 'lineWidth', lineW)
      set(ax(axCoh), 'Xlim', [signalLeftP(1)-.02 signalRightP(end)+.02])
      set(ax(axCoh), 'xtick', pSignalArray)
      set(ax(axCoh), 'xtickLabel', pSignalArray*100)
      
      
      h=axes('Position', [0 0 1 1], 'Visible', 'Off');
      if choiceDependent(iUnit) && coherenceDependent(iUnit)
         ddmStr = 'YES';
      else
         ddmStr = 'NO';
      end
      titleString = sprintf('%s \t %s \t DDM-Like: %s', sessionID, SessionData.spikeUnitArray{spikeUnit(iUnit)}, ddmStr);
      text(0.5,1, titleString, 'HorizontalAlignment','Center', 'VerticalAlignment','Top')
      
      if printPlot
         localFigurePath = local_figure_path;
         print(figureHandle,[localFigurePath, sessionID, '_', SessionData.spikeUnitArray{spikeUnit(iUnit)}, '_ccm_ddm_like', '.pdf'],'-dpdf', '-r300')
      end
   end % if plotFlag
end % for iUnit = 1 : length(spikeUnit)







end