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
% subjectID = 'xena';
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
        td.rewardOn, ...
        td.toneOn, ...
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
        'rewardOn',...
        'toneOn',...
        'rt'}) ;
    
    
    trialData = [trialData; iTable];
end

% monkeyB.rt          = rt;
% monkeyB.colorCoh    = colorCoh;
% monkeyB.saccDir     = saccDir;
% monkeyB.accuracy    = accuracy;
% monkeyB.session     = session;

save(['~/matlab/local_data/',subjectID,'/',subjectID,'_',sessionSet,'.mat'], 'trialData')
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




%%
[sessionArray, subjectIDArray] = task_session_array('broca', 'ccm', 'behavior1');
nSession = length(sessionArray);

for i = 1 : nSession
    
    
    ccm_rt_triplets({'broca'}, sessionArray{i});
    
end

%% Use eyeballed movement cell list (by Jacob) to create a table of all the sessions with neurons, classifying the neurons w.r.t different epochs:
fid=  fopen('~/Documents/Projects/Choice_StopSignal/Broca/MovementNeurons.csv');

nCol = 4;
formatSpec = '%s';
mHeader = textscan(fid, formatSpec, nCol, 'Delimiter', ',');

mData = textscan(fid, '%s %d %s %s', 'Delimiter', ',','TreatAsEmpty',{'NA','na'});

sessionList = mData{1};
channelList = mData{2};
unitList = mData{3};
rfList = mData{4}; % receptive field list

% for i = 1 : length(sessionList)
%     fprintf('%s\tspikeUnit%02d%s\n',sessionList{i}, channelList(i),unitList{i})
% end

subjectID = 'broca';

% Build the unitArray list from the spreadsheet
unitArray = cell(length(sessionList), 1);
for i = 1 : length(sessionList)
    unitArray{i} = sprintf('spikeUnit%02d%s',channelList(i),unitList{i});
    
    %   [trialData, SessionData, ExtraVar] = load_data(subjectID, sessionList{i});
    %   iColorCoh = unique(trialData.targ1CheckerProp);
    
end

% wanna do a subset of the data?
doInd = 1:length(sessionList);
unitArray = unitArray(doInd);
sessionList = sessionList(doInd);
rfList = rfList(doInd);

opt             = ccm_options;
opt.sessionArray = sessionList;
opt.sessionSet  = [];
opt.unitArray   = unitArray;
opt.rfList      = rfList;
opt.howProcess  = 'plot';
opt.plotFlag    = false;
opt.dataType    = 'neuron';
opt.collapseTarg 	= true;
opt.doStops 	= true;

Data = ccm_population_neuron(subjectID, opt)

%%
dataIncludeArray = 'spike';
sessionList = find_sessions_data('broca', 'ccm', dataIncludeArray);

%% Create a table (using stats from all sessions) of sessions with neurons, classifying the neurons w.r.t different epochs:
subjectID = 'broca';
dataPath = fullfile(projectRoot,'data',projectDate,subjectID);


% Open the sessions file and makes lists of the entries
fid=  fopen(fullfile(dataPath,['ccm_sessions_',subjectID,'.csv']));

% fid=  fopen('~/Documents/Projects/Choice_StopSignal/Broca/ccm_sessions_broca.csv');
% subjectID = 'broca';

nCol = 5;
formatSpec = '%s';
mHeader = textscan(fid, formatSpec, nCol, 'Delimiter', ',');

mData = textscan(fid, '%s %s %d %d %d', 'Delimiter', ',','TreatAsEmpty',{'NA','na'});
return
sessionList     = mData{1};
hemisphereList  = mData{2};
neuronLogical   = mData{3};
lfpLogical      = mData{4};
eegLogical      = mData{5};

opt             = ccm_options;
opt.howProcess  = 'each';
opt.plotFlag    = false;
opt.printPlot    = false;
opt.dataType    = 'neuron';
opt.collapseTarg 	= true;
opt.collapseSignal 	= true;
opt.doStops 	= false;


neuronTypes = table();

for i = 1 : length(sessionList)
    if neuronLogical(i)
        fprintf('%02d\t%s\n',i,sessionList{i})
        
        opt.hemisphere = hemisphereList{i};
        iData = ccm_session_data(subjectID, sessionList{i}, opt);
        
        for j = 1 : length(iData)
            iData(j).hemisphere = opt.hemisphere;
            jUnit = ccm_categorize_neuron(iData(j));
            
            neuronTypes = [neuronTypes; jUnit];
        end
        ind = neuronTypes.presacc & ~neuronTypes.vis; % & ~neuronTypes.postsacc;
        sum(ind)
        ind = neuronTypes.presacc & ~neuronTypes.vis  & ~neuronTypes.postsacc;
        sum(ind)
        
        clear iData
    end
end

brocaPath = [local_data_path, '/broca/'];
save([brocaPath, 'ccm_neuronTypes'], 'neuronTypes')
%%

brocaPath = [local_data_path, '/broca/'];
load([brocaPath, 'ccm_neuronTypes'])
subjectID = 'broca';

ind = neuronTypes.presacc & neuronTypes.vis; % & ~neuronTypes.postsacc;

sum(ind)
sessionArray = neuronTypes.sessionID(ind);
unitArray = neuronTypes.unit(ind);
rfList = neuronTypes.rf(ind);
hemList = neuronTypes.hemisphere(ind);

opt             = ccm_options;
opt.sessionArray = neuronTypes.sessionID(ind);
opt.sessionSet  = [];
opt.unitArray   = neuronTypes.unit(ind);
opt.rfList      = neuronTypes.rf(ind);
opt.hemisphereList      = neuronTypes.hemisphere(ind);
opt.howProcess  = 'plot';
opt.plotFlag    = false;
opt.dataType    = 'neuron';
opt.collapseTarg 	= true;
opt.doStops 	= true;

Data = ccm_population_neuron(subjectID, opt)


Data.neuronTypes = 'visPresacc';
brocaPath = [local_data_path, '/broca/'];

neuronTypes = neuronTypes(ind, :);
save([brocaPath, 'neuronPresaccNotVis'], 'Data', 'neuronTypes')

%%
[sessionArray, unitArray, rfList, hemList]
%%
brocaPath = [local_data_path, '/broca/'];
load([brocaPath, 'neuronPresaccNotVis'])  % load Data and neuronTypes subset
%%
brocaPath = [local_data_path, '/broca/'];
load([brocaPath, 'ccm_saccCells'])

%%
opt             = ccm_options;
opt.howProcess  = 'print';
opt.plotFlag    = true;
opt.printPlot    = true;
opt.dataType    = 'neuron';
opt.collapseTarg 	= true;
opt.collapseSignal 	= true;
opt.doStops 	= false;

brocaPath = [local_data_path, '/broca/'];

% if ~exist('neuronTypes','var')
neurons = table();
% end
startInd = 1;

for i = startInd : size(neuronTypes, 1)
    unitInfo = table();
    unitInfo.sessionID  = neuronTypes.sessionID(i);
    unitInfo.unit       = neuronTypes.unit(i);
    unitInfo.hemisphere       = neuronTypes.hemisphere(i);
    unitInfo.rf = neuronTypes.rf(i);
    
    fprintf('%02d\t%s\t%s\n',i,sessionArray{i},unitArray{i})
    fprintf('Hem: %s\tRF: %s\n',hemList{i},rfList{i})
    
    opt.unitArray = unitInfo.unit;
    
    opt.hemisphere = neuronTypes.hemisphere{i};
    iData = ccm_session_data(subjectID, neuronTypes.sessionID{i}, opt);
    
    prompt = 'add to list?';
    addToList = input(prompt);
    if addToList
        
        neurons = [neurons; unitInfo];
        save([brocaPath, 'ccm_spike_visPresacc'], 'neurons')
        
    end
    clear iData
end


%%
brocaPath = [local_data_path, '/broca/'];
load([brocaPath, 'ccm_spike_visPresacc'])

opt             = ccm_options;
opt.sessionArray = neurons.sessionID;
opt.sessionSet  = [];
opt.unitArray   = neurons.unit;
opt.rfList      = neurons.rf;
opt.hemisphereList      = neurons.hemisphere;
opt.howProcess  = 'plot';
opt.plotFlag    = false;
opt.dataType    = 'neuron';
opt.collapseTarg 	= true;
opt.doStops 	= true;

Data = ccm_population_neuron(subjectID, opt)


%%
epoch = 'fixWindowEntered';
epoch = 'targOn';
% epoch = 'checkerOn';
epoch = 'responseOnset';
% epoch = 'rewardOn';
close all
figure()
hold all
plot(mean(Data.easyIn.stopTarg.(epoch).sdf), '--k')
% plot(mean(Data.easyIn.stopStop.(epoch).sdf), 'r')
plot(mean(Data.easyIn.goFast.(epoch).sdf), 'b')
plot(mean(Data.easyIn.goSlow.(epoch).sdf), '--b')
plot(mean(Data.easyIn.goTarg.(epoch).sdf), 'k')
% plot(mean(Data.hardIn.goTarg.(epoch).sdf), 'color', [.4 .4 .4])
% plot(mean(Data.easyOut.goTarg.(epoch).sdf), 'b')
% plot(mean(Data.hardOut.goTarg.(epoch).sdf), 'r')
%
ylim([0 60])
plot([300 300], [0 60])
%%
figure(44)
hold all
plot(mean(Data.easyIn.goTarg.(epoch).sdf), 'k')
plot(mean(Data.easyIn.stopTarg.(epoch).sdf), 'r')
plot(mean(Data.hardIn.goTarg.(epoch).sdf), '--k')
plot(mean(Data.hardIn.stopTarg.(epoch).sdf), '--r')
ylim([0 60])
plot([300 300], [0 60])

%%

fid=  fopen('~/Documents/Projects/Choice_StopSignal/Broca/ccm_sessions_broca.csv');
subjectID = 'broca';

nCol = 5;
formatSpec = '%s';
mHeader = textscan(fid, formatSpec, nCol, 'Delimiter', ',');

mData = textscan(fid, '%s %s %d %d %d', 'Delimiter', ',','TreatAsEmpty',{'NA','na'});
brocaPath = [local_data_path, '/broca/'];

neuronexus = {};

sessionList     = mData{1};
neuronLogical   = mData{3};
startInd = find(strcmp(sessionList, 'bp228n02'));
for i = startInd : length(sessionList)
    if neuronLogical(i)
        neuronexus = [neuronexus; sessionList(i)];
    end
end
%%
map.neuronexus = 32:-1:1;
map.plexon = [8:-1:1,24:-1:17,32:-1:25,16:-1:9];
save([brocaPath, 'neuronexusList'], 'neuronexus', 'map');

%%

sList = {'bp203n02',...
    'bp204n02',...
    'bp246n02',...
    'bp247n02',...
    'bp206n01'};
poolID = parpool(5)
parfor i = 1 : length(sList)
    Data = ccm_session_data('broca',sList{i});
end
delete(poolID)