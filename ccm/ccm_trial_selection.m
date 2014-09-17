function  [trialList] = ccm_trial_selection(trialData, selectOpt)
% function  [trialList] = ccm_trial_selection(trialData, outcome, rightCheckerPct, ssd, targDir)
%
%
%
%
% [trialList] = ccm_trial_selection(trialData, selctOpt)
%
% Returns a list of the trial numbers with conditions specified in options
% structure. If called without any arguments, returns a default options structure.
% If options are input but one is not specified, it assumes default.
%
% Possible conditions are (default listed first):
%     selectOpt.outcome  = array of strings indicating the outcomes to include:
%           {'collapse',
%           'valid'
%           'goCorrectTarget', 'goCorrectDistractor',
%           'goIncorrect',
%           'stopCorrect',
%           'stopIncorrectTarget', 'stopIncorrectDistractor',
%           'targetHoldAbort', 'distractorHoldAbort',
%           'fixationAbort', 'saccadeAbort', 'checkerStimulusAbort'}
%     selectOpt.rightCheckerPct  = range of checkerboard percentage of right target checkers:
%           {'collapse', 'right', 'left'
%           a double array containing the values, e.g. [40 50 60]
%     selectOpt.ssd    = range of SSDs to include in the trial list:
%           {'collapse', 'any', 'none', or
%           a double array containing the values, e.g. [43 86 129]
%     selectOpt.targDir  = the angle of the CORRECT TARGET
%           {'collapse','left','right','up','down','upLeft','upRight',downLeft','downRight'<list of possible angels, e.g. [45 -45]
%     selectOpt.responseDir  = the angle of target to which a response was made
%           {'collapse','left','right','up','down','upLeft','upRight',downLeft','downRight'<list of possible angels, e.g. [45 -45]





% If not input, return the default options structure
if nargin < 2
   selectOpt.outcome      = 'valid';
   selectOpt.rightCheckerPct   = 'collapse';
   selectOpt.ssd               = 'collapse';
   selectOpt.targDir           = 'collapse';
   selectOpt.responseDir       = 'collapse';
   if nargin < 1
      trialList                   = selectOpt;
      return
   end
end



% if ~iscell(outcome)
%     error('ccm_trial_selection: need to enter the outcomArray as a cell, e.g. {''valid''}')
% end


nTrial = size(trialData, 1);
trialLogical = ones(nTrial, 1);

trialData = cell_to_mat(trialData);

if strcmp(selectOpt.outcome, 'valid')
   selectOpt.outcome = {...
      'goCorrectTarget', 'goCorrectDistractor', ...
      'goIncorrect', ...
      'stopCorrect', ...
      'stopIncorrectTarget', 'stopIncorrectDistractor'};
end




% Trials w.r.t. the outcome
if strcmp(selectOpt.outcome, 'collapse')
   outcomeLogical = ones(nTrial, 1);
else
   outcomeLogical = zeros(nTrial, 1);
   for iOutcomeIndex = 1 : length(selectOpt.outcome)
      iOutcome = selectOpt.outcome{iOutcomeIndex};
      
      outcomeLogical = outcomeLogical + strcmp(trialData.trialOutcome, iOutcome);
   end
end
trialLogical = trialLogical & outcomeLogical;





% Trials w.r.t. the checkerboard proportion of target1
% checkers
if strcmp(selectOpt.rightCheckerPct, 'collapse')
else
   if strcmp(selectOpt.rightCheckerPct, 'right')
      target1Proportion = selectOpt.rightCheckerPct/100 > 50;
   elseif strcmp(selectOpt.rightCheckerPct, 'left')
      target1Proportion = selectOpt.rightCheckerPct/100 < 50;
   else
      target1Proportion = selectOpt.rightCheckerPct / 100;
   end
   trialLogical = trialLogical & ismember(trialData.targ1CheckerProp, target1Proportion);
end








% Trials w.r.t. the SSDs
if strcmp(selectOpt.ssd, 'none')
   % take any trials without a stop signal (nan values for selectOpt.ssd)
   trialLogical = trialLogical & isnan(trialData.ssd);
elseif strcmp(selectOpt.ssd, 'any')
   % Do nothing- might want trials without regard to stop/go
elseif strcmp(selectOpt.ssd, 'collapse')
   ssd = min(trialData.ssd) : max(trialData.ssd);
   trialLogical = trialLogical & ismember(trialData.ssd, ssd);
else
   %     ssd = [ssd - 1, ssd, ssd + 1];
   % For now, use range to within an extra frame refresh
   ssd = [selectOpt.ssd - 13 : selectOpt.ssd + 18];
   trialLogical = trialLogical & ismember(trialData.ssd, ssd);
end





% Trials w.r.t. target angle (useful for 50%
% checkerboard displays wherein a random target is assigned
% Get list(s) of trials w.r.t. the SSDs
targAngle = trialData.targAngle;
if strcmp(selectOpt.targDir, 'collapse')
      % Do nothing
targTrial = ones(nTrial, 1);
elseif strcmp(selectOpt.targDir, 'right')
      targTrial = ((targAngle > 270) & (targAngle <= 360)) | ...
         ((targAngle >= 0) & (targAngle < 90)) | ...
         ((targAngle > -90) & (targAngle < 0)) | ...
         ((targAngle >= -360) & (targAngle < -270));
elseif strcmp(selectOpt.targDir, 'left')
      targTrial = ((targAngle > 90) & (targAngle <= 270)) | ...
         ((targAngle < -90) & (targAngle > -270));
elseif strcmp(selectOpt.targDir, 'leftUp')
      targTrial = targAngle == decAngleLeftUp;
elseif strcmp(selectOpt.targDir, 'leftDown')
      targTrial = targAngle == decAngleLeftDown;
elseif strcmp(selectOpt.targDir, 'rightUp')
      targTrial = targAngle == decAngleRightUp;
elseif strcmp(selectOpt.targDir, 'rightDown')
      targTrial = targAngle == decAngleRightDown;
else
      targTrial = ismember(targAngle,selectOpt.targDir);
end
trialLogical = trialLogical & targTrial;





if isfield(selectOpt, 'responseDir')
    saccAngle = nan(nTrial, 1);
   responseTrial = ~isnan(trialData.saccToTargIndex);

%    trialData.saccAngle(nanResp) = cellfun(@(x) [x 0], trialData.saccAngle(nanResp), 'uni', false);  % For trials without responses, need to pretend there is one to sort data (these trials won't be included in trialList)
   saccAngle(responseTrial) = cellfun(@(x,y) x(y), trialData.saccAngle(responseTrial), num2cell(trialData.saccToTargIndex(responseTrial)));
%    saccAngle = cell2num(trialData.saccAngle);
   %     switch selectOpt.responseDir
   if strcmp(selectOpt.responseDir, 'collapse')
      % Do nothing
   saccTrial = ones(nTrial, 1);
   elseif strcmp(selectOpt.responseDir, 'right')
      saccTrial = ((saccAngle > 270) & (saccAngle <= 360)) | ...
         ((saccAngle >= 0) & (saccAngle < 90)) | ...
         ((saccAngle > -90) & (saccAngle < 0)) | ...
         ((saccAngle >= -360) & (saccAngle < -270));
   elseif strcmp(selectOpt.responseDir, 'left')
      saccTrial = ((saccAngle > 90) & (saccAngle <= 270)) | ...
         ((saccAngle < -90) & (saccAngle > -270));
   elseif strcmp(selectOpt.responseDir, 'leftUp')
      saccTrial = saccAngle == decAngleLeftUp;
   elseif strcmp(selectOpt.responseDir, 'leftDown')
      saccTrial = saccAngle == decAngleLeftDown;
   elseif strcmp(selectOpt.responseDir, 'rightUp')
      saccTrial = saccAngle == decAngleRightUp;
   elseif strcmp(selectOpt.responseDir, 'rightDown')
      saccTrial = saccAngle == decAngleRightDown;
   else
      saccTrial = ismember(saccAngle,selectOpt.responseDir);
   end
   trialLogical = trialLogical & saccTrial;
   % For go trials and noncanceled stop trials, get rid of trials without
   % responses (for canceled stop trials all of them should be trials
   % without responses, so leave them in)
   if strcmp(selectOpt.ssd, 'none')
      trialLogical = trialLogical & responseTrial;
   end
end


% If there was supposed to be an RT but there wasn't (if there is a NaN for
% RT, get rid of those trials

% % RTs occur on the following trial types:
% if any(ismember(outcome, {...
%       'goCorrectTarget', ...
%       'goCorrectDistractor', ...
%       'goIncorrectTarget', ...
%       'goIncorrectDistractor', ...
%       'targetHoldAbort', ...
%       'distractorHoldAbort', ...
%       'stopIncorrectTarget', ...
%       'stopIncorrectDistractor'}))
%    rtTrial = strcmp(trialData.trialOutcome, 'goCorrectTarget') | ...
%       strcmp(trialData.trialOutcome, 'goCorrectDistractor') | ...
%       strcmp(trialData.trialOutcome, 'goIncorrectTarget') | ...
%       strcmp(trialData.trialOutcome, 'goIncorrectDistractor') | ...
%       strcmp(trialData.trialOutcome, 'targetHoldAbort') | ...
%       strcmp(trialData.trialOutcome, 'distractorHoldAbort') | ...
%       strcmp(trialData.trialOutcome, 'stopIncorrectTarget') | ...
%       strcmp(trialData.trialOutcome, 'stopIncorrectDistractor');
%    validRT = ~isnan(trialData.rt) & rtTrial;
%    trialLogical = trialLogical & validRT;
% end







trialList = find(trialLogical);

% toc
% disp('angle')





































%
%
%
%
%
%
%
% function  [trialList] = ccm_trial_selection(trialData, outcome, rightCheckerPct, ssd, targDir)
% % function  [trialList] = ccm_trial_selection(subjectID, sessionID, outcome, rightCheckerPct, ssd, targDir)
%
% % [trialList] = ccm_trial_selection(subjectID, sessionID, outcome, rightCheckerPct, ssd, targDir)
% %
% % outcome: array of strings indicating the outcomes to include:
% %           {'all',
% %           'valid'
% %           'goCorrectTarget', 'goCorrectDistractor',
% %           'goIncorrectTarget', 'goIncorrectDistractor'
% %           'stopCorrect',
% %           'stopIncorrectTarget', 'stopIncorrectDistractor',
% %           'targetHoldAbort', 'distractorHoldAbort',
% %           'fixationAbort', 'saccadeAbort', 'checkerStimulusAbort'}
% %
% % rightCheckerPct: range of checkerboard percentage of target 1
% % (the right target) checkers:
% %           'all', 'none', or
% %           a double array containing the values, e.g. [40 50 60]
% %
% % ssd: range of SSDs to include in the trial list:
% %           'all', 'none', or
% %           a double array containing the values, e.g. [43 86 129]
% %
% % targDir: the location of the CORRECT TARGET (may not be where the
% % saccade is directed: i.e., if targDir = 'right' and outcome
% % = {'goCorrectDistractor'}, a leftward saccade was made.
% %           'all', 'right', or 'left'. Note that
% %
% %
% %
% %
% %
% %
%
%
%
%
%
% if ~iscell(outcome)
%    error('ccm_trial_selection: need to enter the outcomArray as a cell, e.g. {''valid''}')
% end
%
%
% nTrial = size(trialData, 1);
% trialLogical = ones(nTrial, 1);
%
% trialData = cell_to_mat(trialData);
%
% if strcmp(outcome, 'valid')
%    outcome = {...
%       'goCorrectTarget', 'goCorrectDistractor', ...
%       'goIncorrectTarget', 'goIncorrectDistractor', ...
%       'stopCorrect', ...
%       'stopIncorrectTarget', 'stopIncorrectDistractor'};
% end
%
% % Get list(s) of trials w.r.t. the outcome
% if strcmp(outcome, 'all')
%    outcomeLogical = ones(nTrial, 1);
% else
%    outcomeLogical = zeros(nTrial, 1);
%    for iOutcomeIndex = 1 : length(outcome)
%       iOutcome = outcome{iOutcomeIndex};
%
%       outcomeLogical = outcomeLogical + strcmp(trialData.trialOutcome, iOutcome);
%    end
% end
% trialLogical = trialLogical & outcomeLogical;
% % sum(trialLogical)
%
% %
% % toc
% % disp('outcome')
%
%
%
%
%
% % Get list(s) of trials w.r.t. the checkerboard proportion of target1
% % checkers
% if strcmp(rightCheckerPct, 'all')
% else
%    target1Proportion = rightCheckerPct / 100;
%    trialLogical = trialLogical & ismember(trialData.targ1CheckerProp, target1Proportion);
% end
%
% % find(trialLogical)
% % toc
% % disp('checker')
% %
%
%
%
%
%
%
%
% % Get list(s) of trials w.r.t. the SSDs
% % ssdArray = unique(trialData.stopSignalOn - trialData.responseCueOn);
% % ssdArray(isnan(ssdArray)) = [];
% % trialData.ssd = trialData.stopSignalOn - trialData.responseCueOn;
% % trialData.ssd = trialData.SSD;
% if strcmp(ssd, 'none')
%    % take any trials without a stop signal (nan values for ssd)
%    trialLogical = trialLogical & isnan(trialData.ssd);
% elseif strcmp(ssd, 'any')
%    % Do nothing- might want trials without regard to stop/go
% elseif strcmp(ssd, 'all')
%    ssd = min(trialData.ssd) : max(trialData.ssd);
%    trialLogical = trialLogical & ismember(trialData.ssd, ssd);
% else
%    %     ssd = [ssd - 1, ssd, ssd + 1];
%    % For now, use range to within an extra frame refresh
%    ssd = [ssd - 13 : ssd + 18];
%    trialLogical = trialLogical & ismember(trialData.ssd, ssd);
% end
% % find(trialLogical)
%
% % toc
% % disp('ssds')
%
%
%
%
%
%
% % Get list(s) of trials w.r.t. target hemifield (useful for 50%
% % checkerboard displays wherein a random target is assigned
% % Get list(s) of trials w.r.t. the SSDs
% targAngle = trialData.targAngle;
% if strcmp(targDir, 'all')
%    % do nothing
% elseif strcmp(targDir, 'right')
%    targTrial = ((targAngle > 270) & (targAngle <= 360)) | ...
%       ((targAngle >= 0) & (targAngle <= 90)) | ...
%       ((targAngle > -90) & (targAngle <= 0)) | ...
%       ((targAngle >= -360) & (targAngle <= -270));
%    trialLogical = trialLogical & targTrial;
% elseif strcmp(targDir, 'left')
%    targTrial = ((targAngle > 90) & (targAngle <= 270)) | ...
%       ((targAngle <= -90) & (targAngle > -270));
%    trialLogical = trialLogical & targTrial;
% end
% % find(trialLogical)
%
%
%
%
%
% % If there was supposed to be an RT but there wasn't (if there is a NaN for
% % RT, get rid of those trials
%
% % % RTs occur on the following trial types:
% % if any(ismember(outcome, {...
% %       'goCorrectTarget', ...
% %       'goCorrectDistractor', ...
% %       'goIncorrectTarget', ...
% %       'goIncorrectDistractor', ...
% %       'targetHoldAbort', ...
% %       'distractorHoldAbort', ...
% %       'stopIncorrectTarget', ...
% %       'stopIncorrectDistractor'}))
% %    rtTrial = strcmp(trialData.trialOutcome, 'goCorrectTarget') | ...
% %       strcmp(trialData.trialOutcome, 'goCorrectDistractor') | ...
% %       strcmp(trialData.trialOutcome, 'goIncorrectTarget') | ...
% %       strcmp(trialData.trialOutcome, 'goIncorrectDistractor') | ...
% %       strcmp(trialData.trialOutcome, 'targetHoldAbort') | ...
% %       strcmp(trialData.trialOutcome, 'distractorHoldAbort') | ...
% %       strcmp(trialData.trialOutcome, 'stopIncorrectTarget') | ...
% %       strcmp(trialData.trialOutcome, 'stopIncorrectDistractor');
% %    validRT = ~isnan(trialData.rt) & rtTrial;
% %    trialLogical = trialLogical & validRT;
% % end
%
%
%
%
%
%
%
% trialList = find(trialLogical);
%
% % toc
% % disp('angle')
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%


















