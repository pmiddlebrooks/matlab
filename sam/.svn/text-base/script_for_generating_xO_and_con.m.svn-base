% rootDir = '/Users/paulmiddlebrooks/matlab/local_data/';

%%
% generateFrom = 'get_bnds';
% generateFrom = 'startVals';
generateFrom = 'bestFits';

varyGo      = false;
boundDist   = 1;


iSubj = 'broca';

rootDir = ['/Users/paulmiddlebrooks/matlab/local_data/sam/',iSubj,'/'];
inhibMechType = 'li';
simGoal = 'optimize';
solverType = 'fminsearchcon';
simScopeRead = 'go';
simScopeWrite = 'all';
nStartPoints = 20;


switch generateFrom
    case 'get_bnds'
        choiceMat = {'race', 'ffi', 'li'};
        condParamMat = {'zc', 'v', 't0'};
        
        choiceMechType = 'race';
        condParam = 'v';
        sizeX0 = [];
        % for iChoice = 1 : length(choiceMat)
        %     choiceMechType = choiceMat{iChoice};
        %     for jParam = 1 : length(condParamMat)
        %         condParam = condParamMat{jParam};
        
        %         choiceMechType
        %         condParam
        %
        
        % Get bounds and X0
        [LB,UB,X0,tg,linConA,linConB,nonLinCon] = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScopeWrite,solverType,iSubj);
        
        % Check this
        
        % [tg;num2cell(X0);num2cell(LB);num2cell(UB)]
        X0
        % Sample additional uniformly distributed starting values between LB and UB
        X0 = [X0;sam_sample_uniform_constrained_x0(nStartPoints,LB,UB,linConA,linConB,nonLinCon,solverType)];
        % X0 = [X0;sam_sample_uniform_constrained_x0(nStartPoints,LB,UB,linConA,linConB)];
        
        % sizeX0 = [sizeX0; size(X0, 1)]
        
        
        % Save starting values
        fNameX0 = sprintf('%s_x0_%strials_c%s_i%s_p%s.mat', iSubj, simScopeWrite, ...
            choiceMechType,inhibMechType,condParam);
        save(fullfile(rootDir,fNameX0),'X0','tg');
        %         fullfile(rootDir,fNameX0)
        
        
        
        
        
        % Save constraints
        fNameCon = sprintf('%s_constraints_%strials_c%s_i%s_p%s.mat', iSubj, simScopeWrite, ...
            choiceMechType,inhibMechType,condParam);
        save(fullfile(rootDir,fNameCon),'LB','UB','linConA','linConB','nonLinCon');
        %         fullfile(rootDir,fNameCon)
        
        
        
        
        
        % end
        % end
        
        
        
        
        
        
        
    case {'startVals'; 'bestFits'}
        
        choiceMat = {'race', 'ffi', 'li'};
        condParamMat = {'zc', 'v', 't0'};
        
        for iChoice = 1 : length(choiceMat)
            choiceMechType = choiceMat{iChoice};
            for jParam = 1 : length(condParamMat)
                condParam = condParamMat{jParam};
                
                {choiceMechType, condParam}
                
                [~,~,X0Read,tg,linconA,linconB,nonlincon] = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScopeRead,solverType,iSubj);
                [~,~,X0Write,tg,linconA,linconB,nonlincon] = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScopeWrite,solverType,iSubj);
                
                nX = length(X0Read);
                
                switch simScopeWrite
                    case 'go'
                        goParamInd = 1 : length(X0Read);
                        switch choiceMechType
                            case {'race','ffi'}
                                switch condParam
                                    case {'zc','t0'}
                                        posFree = 1:10;
                                        negFree = [];
                                    case 'v'
                                        posFree = 1:15;
                                        negFree = [];
                                end
                            case 'li'
                                switch condParam
                                    case {'zc','t0'}
                                        posFree = 1:10;
                                        negFree = 14;
                                    case 'v'
                                        posFree = 1:15;
                                        negFree = 19;
                                end
                        end
                    case 'all'
                        
                        
                        % Figure out the go parameter indices in the
                        % x0 to save
                        switch choiceMechType
                            case {'race','ffi'}
                                switch condParam
                                    case 'zc'
                                        goParamInd = [1, 3:8, 10, 12:13, 15:17];
                                    case 'v'
                                        goParamInd = [1, 3, 5:10, 12:18 20:22];
                                    case 't0'
                                        goParamInd = [1, 3, 5, 7:13, 15:17];
                                end
                            case 'li'
                                switch condParam
                                    case 'zc'
                                        goParamInd = [1, 3:8, 10, 12:13, 15:17, 19];
                                    case 'v'
                                        goParamInd = [1, 3, 5:10, 12:18 20:22, 24];
                                    case 't0'
                                        goParamInd = [1, 3, 5, 7:13, 15:17, 19];
                                end
                        end
                        
                        
                        % Figure out which parameters are positive and which
                        % are negative (so we know how to treat them to
                        % obtain upper and lower bounds)
                        if varyGo
                            switch choiceMechType
                                case {'race','ffi'}
                                    switch condParam
                                        case {'zc','t0'}
                                            posFree = 1:14;
                                            negFree = 20;
                                        case 'v'
                                            posFree = 1:19;
                                            negFree = 25;
                                    end
                                case 'li'
                                    switch condParam
                                        case {'zc','t0'}
                                            posFree = 1:14;
                                            negFree = 19:20;
                                        case 'v'
                                            posFree = 1:19;
                                            negFree = 24:25;
                                    end
                            end
                        else
                            switch choiceMechType
                                case {'race','ffi'}
                                    switch condParam
                                        case {'zc'}
                                            posFree = [2,9,11,14];
                                            negFree = 20;
                                        case 'v'
                                            posFree = [2,4,11,19];
                                            negFree = 25;
                                        case {'t0'}
                                            posFree = [2,4,6,14];
                                            negFree = 20;
                                    end
                                case 'li'
                                    switch condParam
                                        case {'zc'}
                                            posFree = [2,9,11,14];
                                            negFree = 20;
                                        case 'v'
                                            posFree = [2,4,11,19];
                                            negFree = 25;
                                        case {'t0'}
                                            posFree = [2,4,6,14];
                                            negFree = 20;
                                    end
                            end
                        end
                end
                
                
                
                
                %                 % Get the constraints
                %                 % LB = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScope,solverType,iSubj);
                %                 [~,~,xWrite,tg,linconA,linconB,nonlincon] = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScopeWrite,solverType,iSubj);;
                
                
                switch generateFrom
                    case 'startVals'
                        srcDir = fullfile(rootDir,'output/startVals/');
                        srcDir = fullfile(rootDir,'output/behavior2/startVal/');
                        expStr = sprintf('x0.*%s.*c%s_i%s_p%s.*.mat$',simScopeRead,choiceMechType,inhibMechType,condParam);
                        
                        % load cost and X0
                        fl = regexpdir(srcDir,expStr,false);
                        load(fl{1})
                        
                        vals = [cost, X0];
                        bestFits = sortrows(vals,1);
                        
                        xRead = bestFits(1,2:end);
                    case 'bestFits'
                        srcDir = fullfile(rootDir,'output/behavior2/');
                        expStr = sprintf('finalLog.*c%s_i%s_%s_%sTrials.*.mat$',choiceMechType,inhibMechType,condParam,simScopeRead);
                        
                        fls = regexpdir(srcDir,expStr,false);
                        
                        bestFits = nan(numel(fls),nX + 3);
                        nShow = min(25,numel(fls));
                        
                        for i = 1:numel(fls)
                            %     a = load(fls{i});
                            %     a.history
                            %     pause
                            
                            load(fls{i});
                            bestFits(i,1) = i;
                            bestFits(i,2) = exitFlag;
                            bestFits(i,3) = fVal;
                            bestFits(i,4:end) = X;
                            
                            clear exitFlag fVal X
                        end
                        
                        % Sort by exitsFlag, then by fVal
                        [bestFits, rnk] = sortrows(bestFits,[2,3]);
                        
%                         bestFits(1:5,:)
                        xRead = bestFits(1,4:end);
                end
                
                
                
                
                
                X0Write(goParamInd) = xRead;
                
                % Generate Lower and Upper Bounds based on X0 and desired
                % boundDistance
                LB = X0Write;
                LB(posFree) = (1 - boundDist) .* LB(posFree);
                LB(negFree) = (1 + boundDist) .* LB(negFree);
                
                UB = X0Write;
                UB(negFree) = (1 - boundDist) .* UB(negFree);
                UB(posFree) = (1 + boundDist) .* UB(posFree);
                
                
                
                
                
                % Generate new starting points and constraints
                
                nStartPoints = 20;
                
                
                
                
                
                % Get bounds and X0
                [~,~,~,tg,linConA,linConB,nonLinCon] = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScope,solverType,iSubj);
                
                % Sample additional uniformly distributed starting values between LB and UB
                X0Write = [X0Write; sam_sample_uniform_constrained_x0(nStartPoints,LB,UB,linConA,linConB,nonLinCon,solverType)]
                % X0 = [X0;sam_sample_uniform_constrained_x0(nStartPoints,LB,UB,linConA,linConB)];
                
                X0Write
                X0 = X0Write;
                %                 pause
                
                
                
                                % Save starting values
                                fNameX0 = sprintf('%s_x0_%strials_c%s_i%s_p%s.mat', iSubj, simScope, ...
                                    choiceMechType,inhibMechType,condParam);
                                save(fullfile(rootDir,fNameX0),'X0','tg');
                
                
                
                
                                % Save constraints
                                fNameCon = sprintf('%s_constraints_%strials_c%s_i%s_p%s.mat', iSubj, simScope, ...
                                    choiceMechType,inhibMechType,condParam);
                                save(fullfile(rootDir,fNameCon),'LB','UB','linConA','linConB','nonLinCon');
                                %         fullfile(rootDir,fNameCon)
                
                
                
                
            end
        end
        
end % switch generateFrom

