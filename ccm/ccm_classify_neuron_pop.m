function ccm_classify_neuron_pop(subject,projectRoot,projectDate)
%
% Create a table (using stats from all sessions) of sessions with neurons, classifying the neurons w.r.t different epochs:
%
dataPath = fullfile(projectRoot,'data',projectDate,subject);


% Open the sessions file and makes lists of the entries
fid=  fopen(fullfile(dataPath,['ccm_sessions_',subject,'.csv']));


nCol = 5;
formatSpec = '%s';
mHeader = textscan(fid, formatSpec, nCol, 'Delimiter', ',');

mData = textscan(fid, '%s %s %d %d %d', 'Delimiter', ',','TreatAsEmpty',{'NA','na'});

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


% neuronTypes = table();
load(fullfile(dataPath, 'ccm_neuronTypes'), 'neuronTypes')

lastSession = neuronTypes.sessionID(end);
ind = find(strcmp(lastSession, neuronTypes.sessionID));
% neuronTypes(ind, :) = [];
startInd = find(strcmp(lastSession, sessionList));
% for i = 1 : length(sessionList)
for i = startInd+1 : length(sessionList)
    if neuronLogical(i)
        fprintf('%02d\t%s\n',i,sessionList{i})
        
        % See how many units we'll loop through for this session (to save
        % disk space  - so matlab doesn't crash)
        [td, S, E] = load_data(subject, sessionList{i});
        nUnit = length(S.spikeUnitArray);
        
        opt.hemisphere = hemisphereList{i};
        opt.trialData = td;
        opt.SessionData = S;
        opt.ExtraVar = E;
        
        for j = 1 : nUnit
             opt.unitArray = S.spikeUnitArray(j);
            iData = ccm_session_data(subject, sessionList{i}, opt);
            iData.hemisphere = opt.hemisphere;
            jUnit = ccm_classify_neuron(iData);
            
            neuronTypes = [neuronTypes; jUnit];
            clear iData
        end
        
        save(fullfile(dataPath, 'ccm_neuronTypes'), 'neuronTypes')
    end
end

%
% nUnit = 0;
% for i = 1 : length(sessionList)
%     if neuronLogical(i)
% [td, S] = load_data(subject,sessionList{i});
% % m = matfile(fullfile(local_data_path, subject, sessionList{i}));
% iUnit = length(td.spikeData(1,:));
% nUnit = nUnit + iUnit
%     end
% end
% nUnit
%
% neuronTypes = cell(nUnit,13);
% poolID = parpool(4);
%
% parfor i = 1 : length(sessionList)
%     if neuronLogical(i)
%         fprintf('%02d\t%s\n',i,sessionList{i})
%
%         opt.hemisphere = hemisphereList{i};
%         iData = ccm_session_data(subject, sessionList{i}, opt);
%
%         for j = 1 : length(iData)
%             iData(j).hemisphere = opt.hemisphere;
%             jUnit = ccm_classify_neuron(iData(j));
%
%             neuronTypes = [neuronTypes; jUnit];
%         end
%
%         clear iData
% save([dataPath, 'ccm_neuronTypes'], 'neuronTypes')
%     end
% end
% delete(poolID);
