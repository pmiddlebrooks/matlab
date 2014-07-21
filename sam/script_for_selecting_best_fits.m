

keep iSubj;close all;

iSubj             = 'xena';
inhibMechType     = 'li';
simGoal           = 'optimize';
simScope          = 'go';  % go or all
solverType        = 'fminsearchcon';

condParam = 'v';
choiceMat = {'race', 'ffi', 'li'};



noiseBound = false;

nInclude = 1;


switch matlabroot
    case '/Applications/MATLAB_R2013a.app'
        rootDir = fullfile(local_data_path,'sam');
    otherwise
        rootDir = '/scratch/middlepg/sam/';
end


bestFits = [];

for iChoice = 1 : length(choiceMat)
    choiceMechType = choiceMat{iChoice};
    
    
    % Get the number of parameters
    [LB,~,~,tg,~,~,~] = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScope,solverType,iSubj);
    nX = numel(LB);
    clear LB
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MERGE GO FINALLOG FILES INTO ONE DATASET(?) ARRAY
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %   srcDir = fullfile(rootDir,sprintf('%s/fitLogs/',iSubj))
    if ~noiseBound
        srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output');
    else
        srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/noise');
    end
    expStr = sprintf('finalLog.*c%s_i%s_%s_%sTrials.*.mat$',choiceMechType,inhibMechType,condParam,simScope);
    %   expStr = sprintf('finalLog*.mat$');
    
    fls = regexpdir(srcDir,expStr,false);
    
    
    allBestFits = nan(numel(fls),nX + 1);
    
    for i = 1:numel(fls)
        
        load(fls{i});
        allBestFits(i,1) = fVal;
        allBestFits(i,2:end) = X;
        
        clear fVal X
    end
    
    % Sort by exitsFlag, then by fVal
    [allBestFits, rnk] = sortrows(allBestFits,1);
    
    
    bestFits = [bestFits; allBestFits(nInclude,:)];
end % for iChoice = 1 : length(choiceMat);



