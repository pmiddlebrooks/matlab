% rootDir = '/Users/paulmiddlebrooks/matlab/local_data/';
%%
iSubj = 'xena';
inhibMechType = 'li';
simGoal = 'optimize';
solverType = 'fminsearchcon';
simScope = 'go';
nStartPoints = 19;


noiseBound = true;
tBound = false;



switch matlabroot
    case '/Applications/MATLAB_R2013a.app'
        rootDir = fullfile(local_data_path,'sam');
    otherwise
        rootDir = '/scratch/middlepg/sam/';
end





choiceMat = {'race', 'ffi', 'li'};
condParamMat = {'zc', 'v', 't0'};
% condParamMat = {'zc'};


%   srcDir = fullfile(rootDir,sprintf('%s/fitLogs/',iSubj))
if ~noiseBound && ~tBound
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output');
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/newGo');
    %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/neural1');
    %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/allTrials_from_fit_GoTrials');
elseif noiseBound && ~tBound
%     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/noise');
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/newGo/noise');
%     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/test');
elseif ~noiseBound && tBound
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/tBound');
elseif noiseBound && tBound
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/tBound/noise');
end



sizeX0 = [];
for jParam = 1 : length(condParamMat)
    condParam = condParamMat{jParam};
    bestX = [];
    
    for iChoice = 1 : length(choiceMat)
        choiceMechType = choiceMat{iChoice};
        
        % Get bounds and X0
        [LB,~,~,tg,~,~,~] = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScope,solverType,iSubj);
        nX = numel(LB);
        if strcmp(simScope, 'go') && ~strcmp(choiceMechType, 'li')
            nX = nX+1;
        end
        clear LB
        
        
        
        expStr = sprintf('finalLog.*c%s_i%s_%s_%sTrials.*.mat$',choiceMechType,inhibMechType,condParam,simScope);
        % expStr = sprintf('iter.*c%s_i%s_%s_%sTrials.*.mat$',choiceMechType,inhibMechType,condParam,simScope)
        
        
        
        
        
        % fls = regexpdir(srcDir,expStr);
        fls = regexpdir(srcDir,expStr,false);
        
        allBestFits = nan(numel(fls),nX + 3);
        % nShow = min(30,numel(fls));
        nShow = 2;
        
        for i = 1:numel(fls)
            %                 a = load(fls{i});
            %                 a.history
            %                 pause

            load(fls{i});
            allBestFits(i,1) = i;
            allBestFits(i,2) = exitFlag;
            allBestFits(i,3) = fVal;
 
            
                    if strcmp(simScope, 'go') && ~strcmp(choiceMechType, 'li')
            X = [X nan];
                    end
                    
                    
                    allBestFits(i,4:end) = X;
            
            clear exitFlag fVal X
        end
        
        % Sort by exitsFlag, then by fVal
        [allBestFits, rnk] = sortrows(allBestFits,[2,3]);
        
        % allBestFits(1:nShow,:)
        fprintf('\n************   Choice: %s\tCondition: %s    ************ \n', choiceMechType, condParam)
        %         allBestFits
        disp(allBestFits(1:2,:))
        
        
        bestX = [bestX; allBestFits(1,:)];
        
        
        
    end
        tag = ['Chi2',tg];
    
    d = dataset();
    d.choiceMech = choiceMat';
    d = [d, mat2dataset(bestX(:,3:end),'VarNames',tag)];

    switch condParam
        case 'zc'
            paramZc = d;
            tagZc = tag;
        case 'v'
            paramV = d;
            tagV = tag;
        case 't0'
            paramT0 = d;
            tagT0 = tag;
    end
end