function batch

%%      GET FIGURES FOR CCM: CCM_SINGLE_NEURON, CCM_DDM_LIKE, AND CCM_NEURON_STOP_VS_GO

dataPath = 'Broca_sessions.mat';
load(dataPath)
nSession = length(sessions.ccm.stop);

subjectID = 'Broca';
taskID = 'ccm';
dataIncludeArray = {'spike'};

sessionList = find_sessions_data(subjectID, taskID, dataIncludeArray);

for i = 30 : length(sessionList)
    iSessionID = sessionList{i}
    [data, options] = ccm_session_data(subjectID, iSessionID,'neuron', 'normalize', false, 'filterData', true,'collapseSignal', false, 'printPlot', true);
    [data, options] = ccm_session_data(subjectID, iSessionID,'neuron', 'normalize', false, 'filterData', true,'collapseSignal', true, 'printPlot', true);
    ccm_neuron_stop_vs_go(subjectID, iSessionID, 'collapseSignal', 1, 'printPlot', 1);
    ddmLike = ccm_ddm_like(subjectID, iSessionID, 'printPlot', 1);
end
