%%
subjectID = 'broca';
task = 'ccm';
sessionSet = 'behavior1';

[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
nSession = length(sessionArray);



trial       = [];
rt          = [];
colorCoh    = [];
ssd         = [];
saccDir   	= [];
accuracy  	= [];
session    	= [];


for i = 1 : nSession
    
    [td, S, E] = load_data(subjectID,sessionArray{i});
    td.trial = 1 : size(td, 1);
    
    % Truncate RTs
    MIN_RT = 120;
    MAX_RT = 1200;
    nSTD   = 3;
    [allRT, outlierTrial]   = truncate_rt(td.rt, MIN_RT, MAX_RT, nSTD);
    td(outlierTrial, :) = [];

    % Exclude 50% color coherence trials
    td.targ1CheckerProp(td.targ1CheckerProp == .58) = .59;
%     td(td.targ1CheckerProp == .5, :) = [];
    
    
    
    opt = ccm_trial_selection;
    opt.outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    opt.ssd = 'none';
    trial = ccm_trial_selection(td, opt);
    td = td(trial,:);
    
    session = [session; i * ones(length(trial), 1)];
    rt      = [rt; td.rt];
    colorCoh = [colorCoh; td.targ1CheckerProp];
    
    iAccuracy = zeros(length(trial), 1);
    iAccuracy(strcmp(td.trialOutcome, 'goCorrectTarget')) = 1;
    accuracy = [accuracy; iAccuracy];
    
    iSaccDir = zeros(length(trial), 1);
    iSaccDir(strcmp(td.trialOutcome, 'goCorrectTarget') & (td.targAngle > -90 & td.targAngle < 90)) = 1;
    iSaccDir(strcmp(td.trialOutcome, 'goCorrectDistractor') & (td.targAngle > 90 & td.targAngle < 270)) = 1;
    saccDir = [saccDir; iSaccDir];
    
    
end

monkeyB.rt          = rt;
monkeyB.colorCoh    = colorCoh;
monkeyB.saccDir     = saccDir;
monkeyB.accuracy    = accuracy;
monkeyB.session     = session;

save('~/matlab/local_data/broca/brocaRT.mat', 'monkeyB')
disp('done')
%%
subjectID = 'xena';
task = 'ccm';
sessionSet = 'behavior1';

[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
nSession = length(sessionArray);



rt          = [];
colorCoh    = [];
saccDir   	= [];
accuracy  	= [];
session    	= [];


for i = 1 : nSession
    
    [td, S, E] = load_data(subjectID,sessionArray{i});
    
    
    % Truncate RTs
    MIN_RT = 120;
    MAX_RT = 1200;
    nSTD   = 3;
    [allRT, outlierTrial]   = truncate_rt(td.rt, MIN_RT, MAX_RT, nSTD);
    td(outlierTrial, :) = [];
    
    % Exclude 50% color coherence trials
%     td(td.targ1CheckerProp == .5, :) = [];
     td.targ1CheckerProp(td.targ1CheckerProp == .52) = .53;
   
    
    
    opt = ccm_trial_selection;
    opt.outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    opt.ssd = 'none';
    trial = ccm_trial_selection(td, opt);
    td = td(trial,:);
    
    session = [session; i * ones(length(trial), 1)];
    rt      = [rt; td.rt];
    colorCoh = [colorCoh; td.targ1CheckerProp];
    
    iAccuracy = zeros(length(trial), 1);
    iAccuracy(strcmp(td.trialOutcome, 'goCorrectTarget')) = 1;
    accuracy = [accuracy; iAccuracy];
    
    iSaccDir = zeros(length(trial), 1);
    iSaccDir(strcmp(td.trialOutcome, 'goCorrectTarget') & (td.targAngle > -90 & td.targAngle < 90)) = 1;
    iSaccDir(strcmp(td.trialOutcome, 'goCorrectDistractor') & (td.targAngle > 90 & td.targAngle < 270)) = 1;
    saccDir = [saccDir; iSaccDir];
    
    
end

monkeyX.rt = rt;
monkeyX.colorCoh = colorCoh;
monkeyX.saccDir = saccDir;
monkeyX.accuracy = accuracy;
monkeyX.session = session;

save('~/matlab/local_data/monkeyX.mat', 'monkeyX')



%%
subjectID = 'human';
task = 'ccm';
sessionSet = 'behavior';

[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
nSession = length(sessionArray);





for i = 1 : nSession
    
    [td, S, E] = load_data(subjectIDArray{i},[subjectIDArray{i},sessionArray{i}]);
    
    iSubject = sprintf('human%d', i);
    
    % Truncate RTs
    MIN_RT = 120;
    MAX_RT = 1200;
    nSTD   = 3;
    [allRT, outlierTrial]   = truncate_rt(td.rt, MIN_RT, MAX_RT, nSTD);
    td(outlierTrial, :) = [];
    
    % Exclude 50% color coherence trials
%     td(td.targ1CheckerProp == .5, :) = [];
    
    
    
    opt = ccm_trial_selection;
    opt.outcome = {'goCorrectTarget', 'goCorrectDistractor'};
    opt.ssd = 'none';
    trial = ccm_trial_selection(td, opt);
    td = td(trial,:);
    
%     data.session = [session; i * ones(length(trial), 1)];
    data.rt      = td.rt;
    data.colorCoh = td.targ1CheckerProp;
    
    iAccuracy = zeros(length(trial), 1);
    iAccuracy(strcmp(td.trialOutcome, 'goCorrectTarget')) = 1;
    data.accuracy = iAccuracy;
    
    iSaccDir = zeros(length(trial), 1);
    iSaccDir(strcmp(td.trialOutcome, 'goCorrectTarget') & (td.targAngle > -90 & td.targAngle < 90)) = 1;
    iSaccDir(strcmp(td.trialOutcome, 'goCorrectDistractor') & (td.targAngle > 90 & td.targAngle < 270)) = 1;
    data.saccDir = iSaccDir;
    
 save(['~/matlab/local_data/',iSubject,'.mat'], 'data')
   
end



%%
% Build a behavioral data table for broca across sessions (for trial
% history RT anlyses)

subjectID = 'broca';
subjectID = 'xena';
task = 'ccm';
sessionSet = 'behavior1';

[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
nSession = length(sessionArray);

trialData = cell2table({});

for i = 1 : nSession
    
    [td, S, E] = load_data(subjectID,sessionArray{i});
%     td.trial = 1 : size(td, 1);
    
    % Truncate RTs
    MIN_RT = 120;
    MAX_RT = 1200;
    nSTD   = 3;
    [allRT, outlierTrial]   = truncate_rt(td.rt, MIN_RT, MAX_RT, nSTD);
    td(outlierTrial, :) = [];

    % Exclude 50% color coherence trials
    td.targ1CheckerProp(td.targ1CheckerProp == .58) = .59;
%     td(td.targ1CheckerProp == .5, :) = [];
    nTrial = size(td, 1);
    sessionTag = i * ones(nTrial, 1);

    saccAngle = nan(nTrial, 1);
    responseTrial = ~isnan(td.saccToTargIndex);
    saccAngle(responseTrial) = cellfun(@(x,y) x(y), td.saccAngle(responseTrial), num2cell(td.saccToTargIndex(responseTrial)));

    responseDir = cell(nTrial, 1);
    responseL = (saccAngle < -89 & saccAngle > -270) | ...
        (saccAngle > 90 & saccAngle < 269);
    responseR = (saccAngle < 90 & saccAngle >= 0) | ...
        (saccAngle <= 0 & saccAngle > -90) | ...
        (saccAngle > 270 & saccAngle <= 360);
    
    responseDir(responseL) = {'left'};
    responseDir(responseR) = {'right'};

iTable = table(...
     sessionTag, ...
     td.trialOutcome, ...
     td.targOn, ...
     td.checkerOn, ...
     td.responseCueOn, ...
     td.ssd, ...
     td.targAmp, ...
     td.targAngle, ...
     saccAngle, ...
     responseDir, ...
     td.targ1CheckerProp, ...
     td.preTargFixDuration, ...
     td.postTargFixDuration, ...
     td.checkerAngle, ...
     td.iTrial, ...
     td.trialOnset, ...
     td.rt, ...
     'VariableNames', {...
     'sessionTag', ...
     'trialOutcome', ...
     'targOn',...
     'checkerOn', ...  
     'responseCueOn',...
     'ssd',...
     'targAmp',...
     'targAngle',...
     'saccAngle',...
     'responseDirection',...
     'targ1CheckerProp',...
     'preTargFixDuration',...
     'postTargFixDuration',...
     'checkerAngle',...
     'trial',...
     'trialOnset',...
     'rt'}) ;  

    
    trialData = [trialData; iTable];
end

% monkeyB.rt          = rt;
% monkeyB.colorCoh    = colorCoh;
% monkeyB.saccDir     = saccDir;
% monkeyB.accuracy    = accuracy;
% monkeyB.session     = session;

save(['~/matlab/local_data/',subjectID,'/',subjectID,'RT.mat'], 'trialData')
disp('done')


%%
% Build a behavioral data table for broca across sessions (for trial
% history RT anlyses)

subjectID = 'xena';
task = 'ccm';
sessionSet = 'behavior1';

[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
nSession = length(sessionArray);

trialData = cell2table({});

for i = 1 : nSession
    
    [td, S, E] = load_data(subjectID,sessionArray{i});
%     td.trial = 1 : size(td, 1);
    
    % Truncate RTs
    MIN_RT = 120;
    MAX_RT = 1200;
    nSTD   = 3;
    [allRT, outlierTrial]   = truncate_rt(td.rt, MIN_RT, MAX_RT, nSTD);
    td(outlierTrial, :) = [];

    % Exclude 50% color coherence trials
    td.targ1CheckerProp(td.targ1CheckerProp == .58) = .59;
%     td(td.targ1CheckerProp == .5, :) = [];
    
    sessionTag = i * ones(size(td, 1), 1);

iTable = table(...
     sessionTag, ...
     td.trialOutcome, ...
     td.targOn, ...
     td.checkerOn, ...
     td.responseCueOn, ...
     td.ssd, ...
     td.targAmp, ...
     td.targAngle, ...
     td.targ1CheckerProp, ...
     td.preTargFixDuration, ...
     td.postTargFixDuration, ...
     td.checkerAngle, ...
     td.iTrial, ...
     td.trialOnset, ...
     td.rt, ...
     'VariableNames', {...
     'sessionTag', ...
     'trialOutcome', ...
     'targOn',...
     'checkerOn', ...  
     'responseCueOn',...
     'ssd',...
     'targAmp',...
     'targAngle',...
     'targ1CheckerProp',...
     'preTargFixDuration',...
     'postTargFixDuration',...
     'checkerAngle',...
     'trial',...
     'trialOnset',...
     'rt'}) ;  

    
    trialData = [trialData; iTable];
end

% monkeyB.rt          = rt;
% monkeyB.colorCoh    = colorCoh;
% monkeyB.saccDir     = saccDir;
% monkeyB.accuracy    = accuracy;
% monkeyB.session     = session;

save('~/matlab/local_data/xena/xenaRT.mat', 'trialData')
disp('done')


%%
% Build a behavioral data table for broca across sessions (for trial
% history RT anlyses)

subjectID = 'human';
task = 'ccm';
sessionSet = 'behavior1';

[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
nSession = length(sessionArray);

trialData = cell2table({});

for i = 1 : nSession
    
    [td, S, E] = load_data(subjectID,[subjectIDArray{i},sessionArray{i}]);
%     td.trial = 1 : size(td, 1);
    td(1:10,:)
    % Truncate RTs
    MIN_RT = 120;
    MAX_RT = 1200;
    nSTD   = 3;
    [allRT, outlierTrial]   = truncate_rt(td.rt, MIN_RT, MAX_RT, nSTD);
    td(outlierTrial, :) = [];

    % Exclude 50% color coherence trials
%     td.targ1CheckerProp(td.targ1CheckerProp == .58) = .59;
%     td(td.targ1CheckerProp == .5, :) = [];
    sessionTag = i * ones(size(td, 1), 1);
%  sum(strcmp(td.Properties.VariableNames, 'preTargFixDuration'))

iTable = table(...
     sessionTag, ...
     td.trialOutcome, ...
     td.fixWindowEntered, ...
     td.targOn, ...
     td.checkerOn, ...
     td.responseCueOn, ...
     td.ssd, ...
     td.targAmp, ...
     td.targAngle, ...
     td.targ1CheckerProp, ...
     td.checkerAngle, ...
     td.iTrial, ...
     td.trialOnset, ...
     td.rt, ...
     'VariableNames', {...
     'sessionTag', ...
     'trialOutcome', ...
     'fixWindowEntered', ...
     'targOn',...
     'checkerOn', ...  
     'responseCueOn',...
     'ssd',...
     'targAmp',...
     'targAngle',...
     'targ1CheckerProp',...
     'checkerAngle',...
     'trial',...
     'trialOnset',...
     'rt'}) ;  

    
    trialData = [trialData; iTable];
end

% monkeyB.rt          = rt;
% monkeyB.colorCoh    = colorCoh;
% monkeyB.saccDir     = saccDir;
% monkeyB.accuracy    = accuracy;
% monkeyB.session     = session;

save('~/matlab/local_data/human/humanRT.mat', 'trialData')
disp('done')




%%
subjectID = 'broca';
[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
nSession = length(sessionArray);

for i = 1 : nSession

    [td, S, E] = load_data(subjectID,sessionArray{i});
if ismember('eegData',td.Properties.VarNames)
    disp(1)
else
    disp(0)
end
end


%%
% Build a behavioral data table for broca across sessions (for trial
% history RT anlyses)

subjectID = 'broca';
task = 'ccm';
sessionSet = 'behavior1';

[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
nSession = length(sessionArray);

trialData = cell2table({});

for i = 1 : nSession
    if strcmp(sessionArray{i}, 'bp061n02')
        continue
    end
    
    [td, S, E] = load_data(subjectID,sessionArray{i});
%     td.trial = 1 : size(td, 1);
    
    % Truncate RTs
    MIN_RT = 120;
    MAX_RT = 1200;
    nSTD   = 3;
    [allRT, outlierTrial]   = truncate_rt(td.rt, MIN_RT, MAX_RT, nSTD);
    td(outlierTrial, :) = [];

    % Exclude 50% color coherence trials
    td.targ1CheckerProp(td.targ1CheckerProp == .58) = .59;
%     td(td.targ1CheckerProp == .5, :) = [];
  
sessionArray{i}
td.eegData(1:5,:)

iTable = table(...
     td.trialOutcome, ...
     td.targOn, ...
     td.checkerOn, ...
     td.responseCueOn, ...
     td.ssd, ...
     td.targAmp, ...
     td.targAngle, ...
     td.targ1CheckerProp, ...
     td.preTargFixDuration, ...
     td.postTargFixDuration, ...
     td.checkerAngle, ...
     td.iTrial, ...
     td.trialOnset, ...
     td.rt, ...
     td.eegData, ...
     'VariableNames', {...
     'trialOutcome', ...
     'targOn',...
     'checkerOn', ...  
     'responseCueOn',...
     'ssd',...
     'targAmp',...
     'targAngle',...
     'targ1CheckerProp',...
     'preTargFixDuration',...
     'postTargFixDuration',...
     'checkerAngle',...
     'trial',...
     'trialOnset',...
     'rt',...
     'eegData'}) ;  

    
    trialData = [trialData; iTable];
end

% monkeyB.rt          = rt;
% monkeyB.colorCoh    = colorCoh;
% monkeyB.saccDir     = saccDir;
% monkeyB.accuracy    = accuracy;
% monkeyB.session     = session;

save('~/matlab/local_data/broca/brocaEEG.mat', 'trialData', '-v7.3')
disp('done')


%%
% Build a behavioral data table for broca across sessions (for trial
% history RT anlyses)

subjectID = 'xena';
task = 'ccm';
sessionSet = 'behavior1';

[sessionArray, subjectIDArray] = task_session_array(subjectID, task, sessionSet);
nSession = length(sessionArray);

trialData = cell2table({});

for i = 1 : nSession
    
    [td, S, E] = load_data(subjectID,sessionArray{i});
%     td.trial = 1 : size(td, 1);
    
    % Truncate RTs
    MIN_RT = 120;
    MAX_RT = 1200;
    nSTD   = 3;
    [allRT, outlierTrial]   = truncate_rt(td.rt, MIN_RT, MAX_RT, nSTD);
    td(outlierTrial, :) = [];

    % Exclude 50% color coherence trials
    td.targ1CheckerProp(td.targ1CheckerProp == .58) = .59;
%     td(td.targ1CheckerProp == .5, :) = [];
    

iTable = table(...
     td.trialOutcome, ...
     td.targOn, ...
     td.checkerOn, ...
     td.responseCueOn, ...
     td.ssd, ...
     td.targAmp, ...
     td.targAngle, ...
     td.targ1CheckerProp, ...
     td.preTargFixDuration, ...
     td.postTargFixDuration, ...
     td.checkerAngle, ...
     td.iTrial, ...
     td.trialOnset, ...
     td.rt, ...
     td.eegData, ...
     'VariableNames', {...
     'trialOutcome', ...
     'targOn',...
     'checkerOn', ...  
     'responseCueOn',...
     'ssd',...
     'targAmp',...
     'targAngle',...
     'targ1CheckerProp',...
     'preTargFixDuration',...
     'postTargFixDuration',...
     'checkerAngle',...
     'trial',...
     'trialOnset',...
     'rt',...
     'eegData'}) ;  

    
    trialData = [tiralData; iTable];
end

% monkeyB.rt          = rt;
% monkeyB.colorCoh    = colorCoh;
% monkeyB.saccDir     = saccDir;
% monkeyB.accuracy    = accuracy;
% monkeyB.session     = session;

save('~/matlab/local_data/xena/xenaEEG.mat', 'trialData', '-v7.3')
disp('done')




