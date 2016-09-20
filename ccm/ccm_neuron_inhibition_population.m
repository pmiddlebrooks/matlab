function Data = ccm_neuron_inhibition_population(subject, projectRoot, projectDate, Opt)

% Plot and analyze inhibition data from a subset of sessions with recorded
% neural data.
tic
if nargin < 3
    %     Use default options structure if one isn't input
    Opt = ccm_options;
end


% ____________________    LOAD DATA    ____________________
dataPath = fullfile(projectRoot,'data',projectDate,subject);
load(fullfile(dataPath, ['ccm_',Opt.categoryName,'_neurons'])) % Load Data struct for that population
sessionList = neurons.sessionID;
unitList = neurons.unit;


nSession = length(neurons.sessionID);

ssrtColorCoh = nan(nSession, 4);
ssrtSession = nan(nSession, 1);

InhOpt = Opt;
InhOpt.plotFlag = false;
InhOpt.printPlot     = false;
InhOpt.ssrt     = [];

poolID = parpool(3);
parfor i = 1 : nSession
% for i = 1 : nSession
    sessionList{i}
%     InhOpt.unitArray = neurons.unit(i);
    iData               = ccm_neuron_stop_vs_go(subject, sessionList{i}, unitList(i), InhOpt);
    % iInh = ccm_inhibition(subject, sessionList{i}, InhOpt);
    colorCohArray = iData.pSignalArray;
    
    easyLeftInd = 1;
    hardLeftInd = length(colorCohArray) / 2;
    hardRightInd = hardLeftInd + 1;
    easyRightInd = length(colorCohArray);
    
    ssrtColorCoh(i,:) = iData.inhibition.ssrtIntegrationWeighted([easyLeftInd, hardLeftInd, hardRightInd, easyRightInd]);
    
    ssrtSession(i) = iData.inhibition.ssrtCollapseIntegrationWeighted;
    
    
%     clear iData
end
delete(poolID);

% For ssrt per session data, get rid of redundant session ssrts (sessions
% with multiple neuronal units).
[sess sessInd ~] = unique(neurons.sessionID);

Data.ssrtColorCoh = ssrtColorCoh(sessInd);
Data.ssrtSession = ssrtSession(sessInd);

toc