function Opt = ccm_options
% function Opt = ccm_options
%
% Returns default options structure for use as input in muliple choice
% countermanding analysis functions.
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
%
%           valid = any non-aborts
%
%     selectOpt.choiceAccuracy  = default is collapse across all choices. Segments
%           with respect to weather a choice was correct or error (does not count
%           if no choice was made.
%           options: 'collapse' (default), 'correct', 'error'.
%
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

Opt.outcome             = 'valid';
Opt.choiceAccuracy      = 'collapse';
Opt.rightCheckerPct     = 'collapse';
Opt.ssd                 = 'any';
Opt.targDir             = 'collapse';
Opt.responseDir         = 'collapse';
