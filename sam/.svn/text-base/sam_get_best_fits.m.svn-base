function allBestFits = sam_get_best_fits(SAM)


iSubj             = SAM.des.iSubj;
choiceMechType    = SAM.des.choiceMech.type;
inhibMechType     = SAM.des.inhibMech.type;
condParam         = SAM.des.condParam;
simGoal           = 'optimize';
simScope          = SAM.sim.scope;
solverType        = 'fminsearchcon';


noiseBound = SAM.des.noiseBound;
tBound = SAM.des.tBound;




switch matlabroot
    case '/Applications/MATLAB_R2013a.app'
        rootDir = fullfile(local_data_path,'sam');
    otherwise
        rootDir = '/scratch/middlepg/sam/';
end


% Get the number of parameters
LB = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScope,solverType,iSubj);
nX = numel(LB);
clear LB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MERGE GO FINALLOG FILES INTO ONE DATASET(?) ARRAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   srcDir = fullfile(rootDir,sprintf('%s/fitLogs/',iSubj))
if ~noiseBound && ~tBound
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/newGo');
elseif noiseBound && ~tBound
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/newGo/noise');
elseif ~noiseBound && tBound
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/tBound');
elseif noiseBound && tBound
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/tBound/noise');
end
expStr = sprintf('finalLog.*c%s_i%s_%s_%sTrials.*.mat$',choiceMechType,inhibMechType,condParam,simScope);
%   expStr = sprintf('finalLog*.mat$');
fls = regexpdir(srcDir,expStr,false);

allBestFits = nan(numel(fls),nX + 3);

for i = 1:numel(fls)
    
    load(fls{i});
    allBestFits(i,1) = i;
    allBestFits(i,2) = exitFlag;
    allBestFits(i,3) = fVal;
    allBestFits(i,4:end) = X;
    
    clear exitFlag fVal X
end

% Sort by exitsFlag, then by fVal
[allBestFits, rnk] = sortrows(allBestFits,[2,3]);

% allBestFits

% allBestFits(1,:)


