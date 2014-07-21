function ccm_concat_sessions_behavior(subjectID, sessionArray)
%%
% subjectID = 'human';
% subjectID = 'xena'
subjectID = 'broca'

% sessionSet = 'neural1';
sessionSet = 'behavior2';

task = 'ccm';
if nargin < 2
    [sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
end
%
% subjectID = 'pm'
% sessionSet = 'allsaccade';
% sessionArray = {'pmAllsaccade'}
% subjectIDArray = {'pm'}
nSession = length(sessionArray);


sessionTag      = [];
responseOnset   = [];
targ1CheckerProp = [];
responseCueOn   = [];
stopSignalOn    = [];
trialOutcome    = [];
targAngle       = [];
targAmp         = [];`
distAngle       = [];
ssd             = [];
saccAmp        	= [];
saccAngle     	= [];
saccBegin      	= [];
checkerOn      	= [];
saccToTargIndex = [];

for iSession = 1 : nSession
    
    % Load the data
    iSessionID = sessionArray{iSession}
    iSubjectID = subjectIDArray{iSession};
    [trialData, SessionData, ExtraVar] = load_data(iSubjectID, iSessionID);
    
    %     if ~strcmp(SessionData.taskID, 'ccm')
    %         error('Not a choice countermanding session, try again\n')
    %     end
    
    
    iSessionTag         = iSession * ones(size(trialData, 1), 1);
    sessionTag          = [sessionTag; iSessionTag];
    responseOnset       = [responseOnset; trialData.responseOnset];
    targ1CheckerProp    = [targ1CheckerProp; trialData.targ1CheckerProp];
    responseCueOn       = [responseCueOn; trialData.responseCueOn];
    stopSignalOn        = [stopSignalOn; trialData.stopSignalOn];
    ssd                 = [ssd; trialData.ssd];
    trialOutcome        = [trialOutcome; trialData.trialOutcome];
    targAngle           = [targAngle; trialData.targAngle];
    targAmp             = [targAmp; trialData.targAmp];
    distAngle           = [distAngle; trialData.distAngle];
    saccAmp             = [saccAmp; trialData.saccAmp];
    saccAngle           = [saccAngle; trialData.saccAngle];
    saccBegin          	= [saccBegin; trialData.saccBegin];
    checkerOn         	= [checkerOn; trialData.checkerOn];
    saccToTargIndex    	= [saccToTargIndex; trialData.saccToTargIndex];
    
end


trialData = dataset();
trialData.sessionTag        = sessionTag;
trialData.responseOnset     = responseOnset;
trialData.targ1CheckerProp  = targ1CheckerProp;
trialData.responseCueOn     = responseCueOn;
trialData.stopSignalOn      = stopSignalOn;
trialData.ssd               = ssd;
trialData.trialOutcome      = trialOutcome;
trialData.targAngle         = targAngle;
trialData.targAmp           = targAmp;
trialData.distAngle         = distAngle;
trialData.saccAngle           = saccAngle;
trialData.saccAmp           = saccAmp;
trialData.saccBegin         = saccBegin;
trialData.checkerOn         = checkerOn;
trialData.saccToTargIndex  	= saccToTargIndex;

switch lower(subjectID)
    case 'human'
        pSignalArray = [.35 .42 .46 .54 .58 .65];
    case 'broca'
        switch sessionSet
            case 'behavior1'
                pSignalArray = [.41 .45 .48 .52 .55 .59];
            case 'neural1'
                pSignalArray = [.41 .44 .47 .53 .56 .59];
            case 'neural2'
                pSignalArray = [.42 .44 .46 .54 .56 .58];
            otherwise
                pSignalArray = ExtraVar.pSignalArray;
        end
    case 'xena'
        switch sessionSet
            case 'behavior'
                pSignalArray = [.35 .42 .47 .53 .58 .65];
                trialData.targ1CheckerProp(trialData.targ1CheckerProp == .52) = .53;
        end
end



SessionData.taskID = 'ccm';

save(['~/matlab/local_data/', subjectID, '/', subjectID, '_', sessionSet, '.mat'], 'SessionData', 'trialData', '-mat')



