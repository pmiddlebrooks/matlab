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


neuronTypes = table();

for i = 1 : length(sessionList)
    if neuronLogical(i)
        fprintf('%02d\t%s\n',i,sessionList{i})
        
        opt.hemisphere = hemisphereList{i};
        iData = ccm_session_data(subject, sessionList{i}, opt);
        
        for j = 1 : length(iData)
            iData(j).hemisphere = opt.hemisphere;
            jUnit = ccm_classify_neuron(iData(j));
            
            neuronTypes = [neuronTypes; jUnit];
        end
        
        clear iData
    end
end

save([dataPath, 'ccm_neuronTypes'], 'neuronTypes')
