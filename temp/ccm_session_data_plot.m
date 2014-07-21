function ccm_session_data_plot(Data, dataType, options)

%%
% Set defaults

% for i = 1 : 2 : length(varargin)
%    switch varargin{i}
%       case 'printPlot'
%          printPlot = varargin{i+1};
%       case 'figureHandle'
%          figureHandle = varargin{i+1};
%       case 'collapseSignal'
%          collapseSignal = varargin{i+1};
%       case 'filterData'
%          filterData = varargin{i+1};
%       case 'doStops'
%          DO_STOPS = varargin{i+1};
%       case 'dataArray'
%          dataArray = varargin{i+1};
%       case 'pSignalArray'
%          pSignalArray = varargin{i+1};
%       case 'ssdArray'
%          ssdArray = varargin{i+1};
%       otherwise
%    end
% end

dataArray   = Data(1).dataArray;
pSignalArray = Data(1).pSignalArray;
ssdArray    = Data(1).ssdArray;
sessionID   = Data(1).sessionID;
subjectID   = Data(1).subjectID;

printPlot   = options.printPlot;
filterData  = options.filterData;
DO_STOPS    = options.DO_STOPS;
stopHz      = options.stopHz;
figureHandle = options.figureHandle;
collapseSignal  = options.collapseSignal;


kernelMethod = 'gaussian';
SIGMA = 20;
kernelMethod = 'postsynaptic potential';
GROWTH = 1;
DECAY = 20;
% kernelIn = [SIGMA];

PLOT_ERROR  = true;

epochArray = {'targOn', 'checkerOn', 'stopSignalOn', 'responseOnset', 'rewardOn'};

nUnit = length(Data);

nSignal = length(pSignalArray);
% If collapsing data across signal strength, adjust the pSignalArray here
if collapseSignal
   nSignal = 2;
end

if collapseSignal
   cMap = ccm_colormap([0 1]);
else
   cMap = ccm_colormap(pSignalArray);
end

targLineW = 2;
distLineW = 1;
for kDataIndex = 1 : nUnit
   nRow = 3;
   nEpoch = length(epochArray);
   nColumn = nEpoch * 2 + 1;
   figureHandle = figureHandle + 1;
   if printPlot
      [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(nRow, nColumn, figureHandle);
   else
      [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = screen_figure(nRow, nColumn, figureHandle);
   end
   clf
   
   yLimMax = Data(kDataIndex).yMax * 1.1;
   yLimMin = min(Data(kDataIndex).yMin * 1.1);
   
   for mEpoch = 1 : nEpoch
      mEpochName = epochArray{mEpoch};
      epochRange = ccm_epoch_range(mEpochName, 'plot');
      
      % _______  Set up axes  ___________
      % axes names
      axGo = 1;
      axStopGo = 2;
      axStopStop = 3;
      
      % Set up plot axes
      % Left target Go trials
      ax(axGo, mEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axGo, mEpoch) yAxesPosition(axGo, mEpoch) axisWidth axisHeight]);
      set(ax(axGo, mEpoch), 'ylim', [yLimMin yLimMax], 'xlim', [epochRange(1) epochRange(end)])
      cla
      hold(ax(axGo, mEpoch), 'on')
      plot(ax(axGo, mEpoch), [1 1], [yLimMin yLimMax * .9], '-k', 'linewidth', 2)
      title(epochArray{mEpoch})
      
      % Right target Go trials
      ax(axGo, mEpoch+nEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axGo, mEpoch+nEpoch+1) yAxesPosition(axGo, mEpoch+nEpoch+1) axisWidth axisHeight]);
      set(ax(axGo, mEpoch+nEpoch), 'ylim', [yLimMin yLimMax], 'xlim', [epochRange(1) epochRange(end)])
      cla
      hold(ax(axGo, mEpoch+nEpoch), 'on')
      plot(ax(axGo, mEpoch+nEpoch), [1 1], [yLimMin yLimMax * .9], '-k', 'linewidth', 2)
      title(epochArray{mEpoch})
      %             set(ax(axRight, mEpoch), 'Xtick', [0 : 100 : epochRange(end) - epochRange(1)], 'XtickLabel', [epochRange(1) : 100: epochRange(end)])
      
      % Left target Stop Incorrect trials
      ax(axStopGo, mEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axStopGo, mEpoch) yAxesPosition(axStopGo, mEpoch) axisWidth axisHeight]);
      set(ax(axStopGo, mEpoch), 'ylim', [yLimMin yLimMax], 'xlim', [epochRange(1) epochRange(end)])
      cla
      hold(ax(axStopGo, mEpoch), 'on')
      plot(ax(axStopGo, mEpoch), [1 1], [yLimMin yLimMax * .9], '-k', 'linewidth', 2)
      
      % Right target Stop Incorrect trials
      ax(axStopGo, mEpoch+nEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axStopGo, mEpoch+nEpoch+1) yAxesPosition(axStopGo, mEpoch+nEpoch+1) axisWidth axisHeight]);
      set(ax(axStopGo, mEpoch+nEpoch), 'ylim', [yLimMin yLimMax], 'xlim', [epochRange(1) epochRange(end)])
      cla
      hold(ax(axStopGo, mEpoch+nEpoch), 'on')
      plot(ax(axStopGo, mEpoch+nEpoch), [1 1], [yLimMin yLimMax * .9], '-k', 'linewidth', 2)
      
      % Left target Stop Correct trials
      ax(axStopStop, mEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axStopStop, mEpoch) yAxesPosition(axStopStop, mEpoch) axisWidth axisHeight]);
      set(ax(axStopStop, mEpoch), 'ylim', [yLimMin yLimMax], 'xlim', [epochRange(1) epochRange(end)])
      cla
      hold(ax(axStopStop, mEpoch), 'on')
      plot(ax(axStopStop, mEpoch), [1 1], [yLimMin yLimMax * .9], '-k', 'linewidth', 2)
      
      % Right target Stop Correct trials
      ax(axStopStop, mEpoch+nEpoch) = axes('units', 'centimeters', 'position', [xAxesPosition(axStopStop, mEpoch+nEpoch+1) yAxesPosition(axStopStop, mEpoch+nEpoch+1) axisWidth axisHeight]);
      set(ax(axStopStop, mEpoch+nEpoch), 'ylim', [yLimMin yLimMax], 'xlim', [epochRange(1) epochRange(end)])
      cla
      hold(ax(axStopStop, mEpoch+nEpoch), 'on')
      plot(ax(axStopStop, mEpoch+nEpoch), [1 1], [yLimMin yLimMax * .9], '-k', 'linewidth', 2)
      
      if mEpoch > 1
         set(ax(axGo, mEpoch), 'yticklabel', [])
         set(ax(axGo, mEpoch+nEpoch), 'yticklabel', [])
         set(ax(axStopGo, mEpoch), 'yticklabel', [])
         set(ax(axStopGo, mEpoch+nEpoch), 'yticklabel', [])
         set(ax(axStopStop, mEpoch), 'yticklabel', [])
         set(ax(axStopStop, mEpoch+nEpoch), 'yticklabel', [])
         
         set(ax(axGo, mEpoch), 'ycolor', [1 1 1])
         set(ax(axGo, mEpoch+nEpoch), 'ycolor', [1 1 1])
         set(ax(axStopGo, mEpoch), 'ycolor', [1 1 1])
         set(ax(axStopGo, mEpoch+nEpoch), 'ycolor', [1 1 1])
         set(ax(axStopStop, mEpoch), 'ycolor', [1 1 1])
         set(ax(axStopStop, mEpoch+nEpoch), 'ycolor', [1 1 1])
      end
      
      
      
      
      
      
      
      
      % __________ Loop signal strengths and plot  _________
      
      
      
      
      
      
      % PLOT LEFT TARGET TRIALS
      for i = 1 : nSignal/2
         iPropIndexL = nSignal/2 + 1 - i;
         
         
         
         % Go trials
         switch dataType
            case 'neuron'
               dataSignal = 'sdfMean';
            case 'lfp'
               dataSignal = 'lfpMean';
            case 'erp'
               dataSignal = 'erp';
         end
         
         if ~strcmp(mEpochName, 'stopSignalOn')  % No stop signals on go trials
            
            alignGoTarg = Data(kDataIndex).signalStrength(iPropIndexL).goTarg.(mEpochName).alignTime;
            alignGoDist = Data(kDataIndex).signalStrength(iPropIndexL).goDist.(mEpochName).alignTime;
            
            if ~isempty(alignGoTarg)
               sigGoTarg = Data(kDataIndex).signalStrength(iPropIndexL).goTarg.(mEpochName).(dataSignal);
               %                         plot(ax(axGo, mEpoch), epochRange, sigGoTarg(alignGoTarg + epochRange), 'color', goC(iPropIndex,:), 'linewidth', targLineW)
               plot(ax(axGo, mEpoch), epochRange, sigGoTarg(alignGoTarg + epochRange), 'color', cMap(iPropIndexL,:), 'linewidth', targLineW)
            end
            if ~isempty(alignGoDist) && PLOT_ERROR
               sigGoDist = Data(kDataIndex).signalStrength(iPropIndexL).goDist.(mEpochName).(dataSignal);
               plot(ax(axGo, mEpoch), epochRange, sigGoDist(alignGoDist + epochRange), '--', 'color', cMap(iPropIndexL,:), 'linewidth', distLineW)
            end
         end
         
         
         % Stop signal trials
         switch dataType
            case 'neuron'
               dataSignal = 'sdf';
            case 'lfp'
               dataSignal = 'lfp';
            case 'erp'
               dataSignal = 'eeg';
         end
         stopTargSig = cell(1, length(ssdArray));
         stopTargAlign = cell(1, length(ssdArray));
         stopDistSig = cell(1, length(ssdArray));
         stopDistAlign = cell(1, length(ssdArray));
         stopCorrectSig = cell(1, length(ssdArray));
         stopCorrectAlign = cell(1, length(ssdArray));
         for jSSDIndex = 1 : length(ssdArray)
            stopTargSig{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexL).stopTarg.ssd(jSSDIndex).(mEpochName).(dataSignal);
            stopTargAlign{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexL).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime;
            
            stopDistSig{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexL).stopDist.ssd(jSSDIndex).(mEpochName).(dataSignal);
            stopDistAlign{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexL).stopDist.ssd(jSSDIndex).(mEpochName).alignTime;
            
            if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
               stopCorrectSig{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexL).stopCorrect.ssd(jSSDIndex).(mEpochName).(dataSignal);
               stopCorrectAlign{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexL).stopCorrect.ssd(jSSDIndex).(mEpochName).alignTime;
            end
            
         end  % jSSDIndex = 1 : length(ssdArray)
         
         [rasStopTarg, alignStopTarg] = align_raster_sets(stopTargSig, stopTargAlign);
         [rasStopDist, alignStopDist] = align_raster_sets(stopDistSig, stopDistAlign);
         switch dataType
            case 'neuron'
               sigStopTarg = nanmean(rasStopTarg, 1);
               sigStopDist = nanmean(rasStopDist, 1);
            case {'lfp','erp'}
               if filterData
                  sigStopTarg = lowpass(nanmean(rasStopTarg, 1)', stopHz)';
                  sigStopDist = lowpass(nanmean(rasStopDist, 1)', stopHz)';
               else
                  sigStopTarg = nanmean(rasStopTarg, 1);
                  sigStopDist = nanmean(rasStopDist, 1);
               end
         end
         if size(sigStopTarg, 2) == 1, sigStopTarg = []; end;
         if size(sigStopDist, 2) == 1, sigStopDist = []; end;
         
         if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
            [rasStopCorrect, alignStopCorrect] = align_raster_sets(stopCorrectSig, stopCorrectAlign);
            switch dataType
               case 'neuron'
                  sigStopCorrect = nanmean(rasStopCorrect, 1);
               case {'lfp','erp'}
                  if filterData
                     sigStopCorrect = lowpass(nanmean(rasStopCorrect, 1)', stopHz)';
                  else
                     sigStopCorrect = nanmean(rasStopCorrect, 1);
                  end
            end
            if size(sigStopCorrect, 2) == 1, sigStopCorrect = []; end;
         end
         
         
         
         
         if ~isempty(sigStopTarg)
            plot(ax(axStopGo, mEpoch), epochRange, sigStopTarg(alignStopTarg + epochRange), 'color', cMap(iPropIndexL,:), 'linewidth', targLineW)
         end
         if PLOT_ERROR && ~isempty(sigStopDist)
            plot(ax(axStopGo, mEpoch), epochRange, sigStopDist(alignStopDist + epochRange), '--', 'color', cMap(iPropIndexL,:), 'linewidth', distLineW)
         end
         
         if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
            if ~isempty(sigStopCorrect)
               plot(ax(axStopStop, mEpoch), epochRange, sigStopCorrect(alignStopCorrect + epochRange), 'color', cMap(iPropIndexL,:), 'linewidth', targLineW)
            end
         end
         
         
         
         
         
         
         
         % Then the right target trials
         %                 iPropIndexR = nSignal + 1 - iPropIndex;  % Reverse order of plotting to keep color overlays similar between left and right target
         iPropIndexR = i + nSignal/2;  % Reverse order of plotting to keep color overlays similar between left and right target
         
         
         % Go trials
         switch dataType
            case 'neuron'
               dataSignal = 'sdfMean';
            case 'lfp'
               dataSignal = 'lfpMean';
            case 'erp'
               dataSignal = 'erp';
         end
         if ~strcmp(mEpochName, 'stopSignalOn')  % No stop signals on go trials
            alignGoTarg = Data(kDataIndex).signalStrength(iPropIndexR).goTarg.(mEpochName).alignTime;
            alignGoDist = Data(kDataIndex).signalStrength(iPropIndexR).goDist.(mEpochName).alignTime;
            
            if ~isempty(sigGoTarg)
               sigGoTarg = Data(kDataIndex).signalStrength(iPropIndexR).goTarg.(mEpochName).(dataSignal);
               %                         plot(ax(axGo, mEpoch + nEpoch), epochRange, sigGoTarg(alignGoTarg + epochRange), 'color', goC(iPropIndexR,:), 'linewidth', targLineW)
               plot(ax(axGo, mEpoch + nEpoch), epochRange, sigGoTarg(alignGoTarg + epochRange), 'color', cMap(iPropIndexR,:), 'linewidth', targLineW)
            end
            if PLOT_ERROR && ~isempty(sigGoDist)
               sigGoDist = Data(kDataIndex).signalStrength(iPropIndexR).goDist.(mEpochName).(dataSignal);
               %                         plot(ax(axGo, mEpoch + nEpoch), epochRange, sigGoDist(alignGoDist + epochRange), '--', 'color', goC(iPropIndexR,:), 'linewidth', distLineW)
               plot(ax(axGo, mEpoch + nEpoch), epochRange, sigGoDist(alignGoDist + epochRange), '--', 'color', cMap(iPropIndexR,:), 'linewidth', distLineW)
            end
         end
         
         
         
         % Stop signal trials
         switch dataType
            case 'neuron'
               dataSignal = 'sdf';
            case 'lfp'
               dataSignal = 'lfp';
            case 'erp'
               dataSignal = 'eeg';
         end
         stopTargSig = cell(1, length(ssdArray));
         stopTargAlign = cell(1, length(ssdArray));
         stopDistSig = cell(1, length(ssdArray));
         stopDistAlign = cell(1, length(ssdArray));
         stopCorrectSig = cell(1, length(ssdArray));
         stopCorrectAlign = cell(1, length(ssdArray));
         for jSSDIndex = 1 : length(ssdArray)
            stopTargSig{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexR).stopTarg.ssd(jSSDIndex).(mEpochName).(dataSignal);
            stopTargAlign{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexR).stopTarg.ssd(jSSDIndex).(mEpochName).alignTime;
            
            if PLOT_ERROR
               stopDistSig{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexR).stopDist.ssd(jSSDIndex).(mEpochName).(dataSignal);
               stopDistAlign{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexR).stopDist.ssd(jSSDIndex).(mEpochName).alignTime;
            end
            
            if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
               stopCorrectSig{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexR).stopCorrect.ssd(jSSDIndex).(mEpochName).(dataSignal);
               stopCorrectAlign{jSSDIndex} = Data(kDataIndex).signalStrength(iPropIndexR).stopCorrect.ssd(jSSDIndex).(mEpochName).alignTime;
            end
            
         end  % jSSDIndex = 1 : length(ssdArray)
         
         
         [rasStopTarg, alignStopTarg] = align_raster_sets(stopTargSig, stopTargAlign);
         [rasStopDist, alignStopDist] = align_raster_sets(stopDistSig, stopDistAlign);
         
         switch dataType
            case 'neuron'
               sigStopTarg = nanmean(rasStopTarg, 1);
               sigStopDist = nanmean(rasStopDist, 1);
            case {'lfp','erp'}
               if filterData
                  sigStopTarg = lowpass(nanmean(rasStopTarg, 1)', stopHz)';
                  sigStopDist = lowpass(nanmean(rasStopDist, 1)', stopHz)';
               else
                  sigStopTarg = nanmean(rasStopTarg, 1);
                  sigStopDist = nanmean(rasStopDist, 1);
               end
         end
         if size(sigStopTarg, 2) == 1, sigStopTarg = []; end;
         if size(sigStopDist, 2) == 1, sigStopDist = []; end;
         
         if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
            [rasStopCorrect, alignStopCorrect] = align_raster_sets(stopCorrectSig, stopCorrectAlign);
            switch dataType
               case 'neuron'
                  sigStopCorrect = nanmean(rasStopCorrect, 1);
               case {'lfp','erp'}
                  if filterData
                     sigStopCorrect = lowpass(nanmean(rasStopCorrect, 1)', stopHz)';
                  else
                     sigStopCorrect = nanmean(rasStopCorrect, 1);
                  end
            end
            if size(sigStopCorrect, 2) == 1, sigStopCorrect = []; end;
         end
         
         
         
         if ~isempty(sigStopTarg)
            plot(ax(axStopGo, mEpoch + nEpoch), epochRange, sigStopTarg(alignStopTarg + epochRange), 'color', cMap(iPropIndexR,:), 'linewidth', targLineW)
         end
         if PLOT_ERROR && ~isempty(sigStopDist)
            plot(ax(axStopGo, mEpoch + nEpoch), epochRange, sigStopDist(alignStopDist + epochRange), '--', 'color', cMap(iPropIndexR,:), 'linewidth', distLineW)
         end
         if ~strcmp(mEpochName, 'responseOnset')  % No stop signals on go trials
            if ~isempty(sigStopCorrect)
               plot(ax(axStopStop, mEpoch + nEpoch), epochRange, sigStopCorrect(alignStopCorrect + epochRange), 'color', cMap(iPropIndexR,:), 'linewidth', targLineW)
            end
         end
      end % iPropIndex
      
   end % mEpoch
   
   %                             legend(ax(axGo, 1), {num2cell(pSignalArray'), num2str(pSignalArray')})
   
   %         colorbar('peer', ax(axGo, 1), 'location', 'west')
   %         colorbar('peer', ax(axStopGo, 1), 'location', 'west')
   h=axes('Position', [0 0 1 1], 'Visible', 'Off');
   titleString = sprintf('%s \t %s', sessionID, Data(kDataIndex).name);
   text(0.5,1, titleString, 'HorizontalAlignment','Center', 'VerticalAlignment','Top')
   if printPlot && ~collapseSignal
      print(figureHandle,[local_figure_path, sessionID, '_', Data(kDataIndex).name, '_ccm_single_neuron'],'-dpdf', '-r300')
   elseif printPlot && collapseSignal
      print(figureHandle,[local_figure_path, sessionID, '_', Data(kDataIndex).name, '_ccm_single_neuron_collapse'],'-dpdf', '-r300')
   end
   end
end % kDataIndex


