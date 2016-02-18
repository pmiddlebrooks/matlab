function data = ccm_go_vs_canceled_population(subjectID, sessionSet)

if nargin < 2
   sessionSet = 'neural1';
end
%%

% subjectID = 'broca';
% sessionSet = 'behavior';
% sessionSet = 'neural1';
task = 'ccm';


[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
nSession = length(sessionArray);

switch lower(subjectID)
   case 'human'
      signalStrength = [.35 .42 .46 .5 .54 .58 .65];
   case 'broca'
      switch sessionSet
         case 'behavior'
            signalStrength = [.41 .45 .48 .5 .52 .55 .59];
         case 'neural1'
            signalStrength = [.41 .44 .47 .53 .56 .59];
         case 'neural2'
            signalStrength = [.42 .44 .46 .54 .56 .58];
      end
   case 'xena'
      signalStrength = [.35 .42 .47 .5 .53 .58 .65];
end
nSignalStrength = length(signalStrength);




opt              = ccm_go_vs_canceled;
opt.plotFlag     = 0;

% % Determine whether there is a 50% condition
% if mod(nSignalStrength, 2)
%    opt.include50    = 1;
% else
%    opt.include50    = 0;
% end



for i = 1 : nSession
   
   
      sessionArray{i}
      
   iData               = ccm_go_vs_canceled(subjectIDArray{i}, sessionArray{i}, opt);
   
nUnit       = max(size(iData));
nTargPair   = max(size(iData.targ));

for j = 1 : nUnit
    for k = 1 : nTargPair
        
        
        
        
        stopStopSpike       = Data(j).targ(k).stopStopSpike;
        goTargSlowSpike     = Data(j).targ(k).goTargSlowSpike;
        cancelTime          = Data(j).targ(k).cancelTime;
        
        % For each cell, need to figure out which signal strengths and target to
        % analyze (which conditions are in neuron's response/receptive field)
        
        
        for m = 1 : nSignal
            for n = 1 : nSSD
                
            end %  n = 1 : nSSD
        end %  m = 1 : nSignal
        
        
    end %  k = 1 : nTargPair
end %  j = 1 : nUnit




iInh.ssrtIntegration = cellfun(@nanmean, iInh.ssrtIntegration);
   
   ssrtIntW(i,:) = iInh.ssrtIntegrationWeighted';
   
end %  i = 1 : nSession





ssrtIntWMean = median(ssrtIntW, 1);






%%
figureHandle = 61;
[axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nSignalStrength, 1, 'landscape', figureHandle);
cMap = ccm_colormap(signalStrength);

for j = 1 : nSignalStrength
   
   ax(j) = axes('units', 'centimeters', 'position', [xAxesPosition(j) yAxesPosition(j) axisWidth axisHeight]);
   hold on;
   set(ax(j), 'xlim', [min(ssrtIntW(:)) max(ssrtIntW(:))])
   set(ax(j), 'ylim', [0 .5])
   
   
   [jY, jX] = hist(ssrtIntW(:,j), nSession);
   bar(jX, jY/nSession, 1, 'facecolor', cMap(j,:))
   
   plot([ssrtIntWMean(j) ssrtIntWMean(j)], ylim)
end


data.ssrtIntW = ssrtIntW;

