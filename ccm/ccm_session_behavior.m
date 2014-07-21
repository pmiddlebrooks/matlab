function [SessionData] = ccm_session_behavior(subjectID, sessionID, varargin)
%%

% Set defaults
plotFlag = 1;
printPlot = 0;
collapseTarg = false;
for i = 1 : 2 : length(varargin)
   switch varargin{i}
      case 'plotFlag'
         plotFlag = varargin{i+1};
      case 'printPlot'
         printPlot = varargin{i+1};
      case 'collapseTarg'
         collapseTarg = varargin{i+1};
      otherwise
   end
end

DO_STOPS = 1;

% Load the data
[trialData, SD, ExtraVar] = load_data(subjectID, sessionID);
pSignalArray = ExtraVar.pSignalArray;
ssdArray = ExtraVar.ssdArray;
nTrial = size(trialData, 1);

if ~strcmp(SD.taskID, 'ccm')
   fprintf('Not a choice countermanding session, try again\n')
   return
end





% axes names
pRightVsPCorrect = 7;




if plotFlag
   %     nRow = 3;
   %     nColumn = 3;
   %     screenOrSave = 'save';
   figureHandle = 9239;
   %         if printPlot
   %             [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(nRow, nColumn, figureHandle);
   %         else
   %             [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = screen_figure(nRow, nColumn, figureHandle);
   %         end
   % %     [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = big_figure(nRow, nColumn, figureHandle, screenOrSave);
   %     clf
   %     choicePlotXMargin = .03;
   %     ssdMargin = 20;
   %     ylimArray = [];
   
end










% ***********************************************************************
% Inhibition Function:
%       &
% SSD vs. Proportion of Response trials
%       &
% SSD vs. Proportion(Correct Choice)
% ***********************************************************************


disp('Stopping data')
optInh              = ccm_inhibition;
optInh.collapseTarg = collapseTarg;
optInh.printPlot    = printPlot;
dataInh             = ccm_inhibition(subjectID, sessionID, optInh);

stopRespondProb     = dataInh.stopRespondProb;
nStop               = dataInh.nStop;
nStopStop           = dataInh.nStopStop;
nStopTarg           = dataInh.nStopTarg;
nStopDist           = dataInh.nStopDist;
stopTargetProb      = dataInh.stopTargetProb;
inhibitionFn        = dataInh.inhibitionFn;
ssrtGrand          	= dataInh.ssrtGrand;
ssrtMean          	= dataInh.ssrtMean;
ssrtIntegration   	= dataInh.ssrtIntegration;
ssrtIntegrationWeighted 	= dataInh.ssrtIntegrationWeighted;
ssrtIntegrationSimple   	= dataInh.ssrtIntegrationSimple;
stopRespondProbGrand        = dataInh.stopRespondProbGrand;
inhibitionFnGrand           = dataInh.inhibitionFnGrand;
ssrtCollapseGrand           = dataInh.ssrtCollapseGrand;
ssrtCollapseIntegrationWeighted 	= dataInh.ssrtCollapseIntegrationWeighted;
ssrtCollapseIntegration             = dataInh.ssrtCollapseIntegration;
ssrtCollapseMean                    = dataInh.ssrtCollapseMean;









%
%
% % ***********************************************************************
% % Probability(Rightward response) vs Proportion(Correct Choice)
% % ***********************************************************************
goTargTotal      = cell(length(pSignalArray), 1);
goDistTotal      = cell(length(pSignalArray), 1);
nGoTargTotal      = nan(length(pSignalArray), 1);
nGoDistTotal      = nan(length(pSignalArray), 1);
% Get default trial selection options
selectOpt = ccm_trial_selection;

for iPropIndex = 1 : length(pSignalArray);
   iPct = pSignalArray(iPropIndex) * 100;
   selectOpt.rightCheckerPct = iPct;
   
   selectOpt.ssd = 'none';
   selectOpt.outcome     = {'goCorrectDistractor'};
   goDist = ccm_trial_selection(trialData, selectOpt);
   iGoDistIndices = zeros(nTrial, 1);
   iGoDistIndices(goDist) = 1;
   
   oddData = find(isnan(trialData.saccToTargIndex) & iGoDistIndices & ismember(trialData.targ1CheckerProp, pSignalArray));
   if oddData
      fprintf('%d trials are listed as %s but don''t have valid saccades to target:\n', length(oddData), selectOpt.outcome{:})
      %         disp(oddData)
      %         trialData(goDist,:)
   end
   iGoDistIndices(oddData) = 0;
   
   if sum(iGoDistIndices)
      iGoDist = find(iGoDistIndices);
      goDistTotal{iPropIndex} = iGoDist;  % Keep track of totals for grand inhibition fnct
      nGoDistTotal(iPropIndex) = length(iGoDist);  % Keep track of totals for grand inhibition fnct
   end
   
   
   selectOpt.outcome     = {'goCorrectTarget'};
   goTarg = ccm_trial_selection(trialData, selectOpt);
   iGoTargIndices = zeros(nTrial, 1);
   iGoTargIndices(goTarg) = 1;
   
   oddData = find(isnan(trialData.saccToTargIndex) & iGoTargIndices & ismember(trialData.targ1CheckerProp, pSignalArray));
   if oddData
      fprintf('%d trials are listed as %s but don''t have valid saccades to target:\n', length(oddData), selectOpt.outcome{:})
      %         disp(oddData)
      %         trialData(goTarg,:)
   end
   iGoTargIndices(oddData) = 0;
   
   if sum(iGoTargIndices)
      iGoTarg = find(iGoTargIndices);
      goTargTotal{iPropIndex} = iGoTarg;  % Keep track of totals for grand inhibition fnct
      nGoTargTotal(iPropIndex) = length(iGoTarg);  % Keep track of totals for grand inhibition fnct
   end
end

goTargetProb = nGoTargTotal ./ (nGoTargTotal + nGoDistTotal);
goTargetProb(isnan(goTargetProb)) = 1;
%
% if plotFlag
%     % p(rightward response) vs p(correct choice)
%     ax(pRightVsPCorrect) = axes('units', 'centimeters', 'position', [xAxesPosition(1, 3) yAxesPosition(1, 3) axisWidth axisHeight]);
%     hold(ax(pRightVsPCorrect), 'on')
%     plot(ax(pRightVsPCorrect), pSignalArray, goTargetProb, 'color', 'k', 'linewidth', 2)
%
%     set(ax(pRightVsPCorrect), 'xtick', pSignalArray)
%     set(ax(pRightVsPCorrect), 'xtickLabel', pSignalArray*100)
%     set(get(ax(pRightVsPCorrect), 'ylabel'), 'String', 'p(Correct)')
%     set(ax(pRightVsPCorrect),'XLim',[pSignalArray(1) - choicePlotXMargin pSignalArray(end) + choicePlotXMargin])
%     set(ax(pRightVsPCorrect),'YLim',[.45 1])
%     plot(ax(pRightVsPCorrect), [.5 .5], ylim, '--k')
%
%     minColorGun = .25;
%     maxColorGun = 1;
%     if ~isempty(ssdArray) && DO_STOPS
%         for jSSDIndex = 1 : length(ssdArray)
%             % Determine color to use for plot based on which checkerboard color
%             % proportion being used. Normalize the available color spectrum to do
%             % it
%             ssdFrac = ssdArray(jSSDIndex) / ssdArray(end);
%             colorGun = minColorGun + (maxColorGun - minColorGun) * ssdFrac;
%             ssdColor = [colorGun 0 0];
%
%             plot(ax(pRightVsPCorrect), pSignalArray, stopTargetProb(:, jSSDIndex), 'color', ssdColor, 'linewidth', 2)
%         end
%     end
%
% end % plotFlag
%








% ***********************************************************************
% Psychometric Function: Proportion(Red Checker) vs Probability(go Right)
% ***********************************************************************
disp('Psychometric data')
optPsy = ccm_psychometric;
optPsy.collapseTarg = collapseTarg;
optPsy.printPlot = printPlot;
dataPsych = ccm_psychometric(subjectID, sessionID, optPsy);
% [nGo, nGoRight, nStopIncorrect, nStopIncorrectRight, goRightLogical, goRightSignalStrength, stopRightLogical, stopRightSignalStrength] = ccm_psychometric(subjectID, sessionID, plotFlag);
nGo                 = dataPsych.nGo;
nGoRight            = dataPsych.nGoRight;
nStopIncorrect      = dataPsych.nStopIncorrect;
nStopIncorrectRight = dataPsych.nStopIncorrectRight;
goRightLogical      = dataPsych.goRightLogical;
goRightSignalStrength = dataPsych.goRightSignalStrength;
stopRightLogical    = dataPsych.stopRightLogical;
stopRightSignalStrength = dataPsych.stopRightSignalStrength;
%















% ***********************************************************************
% Chronometric Function:     Proportion(Right) vs RT
% ***********************************************************************
% [signalStrengthLeft, signalStrengthRight ...
%     goLeftToTarg, goRightToTarg, goLeftToDist, goRightToDist ...
%     stopLeftToTarg, stopRightToTarg, stopLeftToDist, stopRightToDist] ...
disp('Chronometric data')
optChr = ccm_chronometric;
optChr.collapseTarg = collapseTarg;
optChr.printPlot = printPlot;
dataChron = ccm_chronometric(subjectID, sessionID, optChr);

pSignalArrayLeft 	= dataChron.pSignalArrayLeft;
pSignalArrayRight	= dataChron.pSignalArrayRight;
goLeftToTarg      	= dataChron.goLeftToTarg;
goRightToTarg     	= dataChron.goRightToTarg;
goLeftToDist       	= dataChron.goLeftToDist;
goRightToDist      	= dataChron.goRightToDist;
stopLeftToTarg    	= dataChron.stopLeftToTarg;
stopRightToTarg    	= dataChron.stopRightToTarg;
stopLeftToDist     	= dataChron.stopLeftToDist;
stopRightToDist    	= dataChron.stopRightToDist;








for i = 1 : size(dataChron, 1)
   
   SessionData(i).pSignalArray    = pSignalArray;
SessionData(i).ssdArray        = ssdArray;


SessionData(i).stopRespondProb      = dataInh(i).stopRespondProb;
SessionData(i).nStop                = dataInh(i).nStop;
SessionData(i).nStopStop            = dataInh(i).nStopStop;
SessionData(i).nStopTarg            = dataInh(i).nStopTarg;
SessionData(i).nStopDist            = dataInh(i).nStopDist;
% SessionData(i).goTargetProb         = dataInh(i).goTargetProb;
SessionData(i).stopTargetProb       = dataInh(i).stopTargetProb;
SessionData(i).inhibitionFn         = dataInh(i).inhibitionFn;
SessionData(i).ssrtGrand            = dataInh(i).ssrtGrand;
SessionData(i).ssrtMean             = dataInh(i).ssrtMean;
SessionData(i).ssrtIntegration      = dataInh(i).ssrtIntegration;
SessionData(i).ssrtIntegrationWeighted = dataInh(i).ssrtIntegrationWeighted;
SessionData(i).ssrtIntegrationSimple = dataInh(i).ssrtIntegrationSimple;
SessionData(i).ssrtCollapseGrand   	= dataInh(i).ssrtCollapseGrand;
SessionData(i).ssrtCollapseIntegrationWeighted     	= dataInh(i).ssrtCollapseIntegrationWeighted;
SessionData(i).ssrtCollapseIntegration  	= dataInh(i).ssrtCollapseIntegration;
SessionData(i).ssrtCollapseMean    	= dataInh(i).ssrtCollapseMean;
SessionData(i).stopRespondProbGrand = dataInh(i).stopRespondProbGrand;
SessionData(i).inhibitionFnGrand    = dataInh(i).inhibitionFnGrand;


SessionData(i).nGo                  = dataPsych(i).nGo;
SessionData(i).nGoRight             = dataPsych(i).nGoRight;
SessionData(i).nStopIncorrect       = dataPsych(i).nStopIncorrect;
SessionData(i).nStopIncorrectRight  = dataPsych(i).nStopIncorrectRight;
SessionData(i).goRightLogical       = dataPsych(i).goRightLogical;
SessionData(i).goRightSignalStrength = dataPsych(i).goRightSignalStrength;
SessionData(i).stopRightLogical     = dataPsych(i).stopRightLogical;
SessionData(i).stopRightSignalStrength = dataPsych(i).stopRightSignalStrength;


SessionData(i).pSignalArrayLeft = dataChron(i).pSignalArrayLeft;
SessionData(i).pSignalArrayRight = dataChron(i).pSignalArrayRight;
SessionData(i).goLeftToTarg    = dataChron(i).goLeftToTarg;
SessionData(i).goRightToTarg   = dataChron(i).goRightToTarg;
SessionData(i).goLeftToDist    = dataChron(i).goLeftToDist;
SessionData(i).goRightToDist   = dataChron(i).goRightToDist;
SessionData(i).stopLeftToTarg  = dataChron(i).stopLeftToTarg;
SessionData(i).stopRightToTarg = dataChron(i).stopRightToTarg;
SessionData(i).stopLeftToDist  = dataChron(i).stopLeftToDist;
SessionData(i).stopRightToDist = dataChron(i).stopRightToDist;
end



if printPlot
   localFigurePath = local_figure_path;
   print(figureHandle,[localFigurePath, sessionID,'_ccm_behavior'],'-dpdf', '-r300')
end
% delete(localDataFile);


