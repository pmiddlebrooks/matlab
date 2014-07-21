function script_for_selecting_best_startvals

%%



% keep iSubj;
close all;

iSubj             = 'broca';
% condParam         = 'v';
% choiceMechType    = 'race';
inhibMechType     = 'li';
simGoal           = 'optimize';
simScope          = 'go';  % go or all
solverType        = 'fminsearchcon';

noiseBound = true;
tBound      = true;



switch matlabroot
    case '/Applications/MATLAB_R2013a.app'
        rootDir = fullfile(local_data_path,'sam',iSubj);
    otherwise
        rootDir = '/scratch/middlepg/sam/';
end





choiceMat = {'race', 'ffi', 'li'};
condParamMat = {'zc', 'v', 't0'};

for iChoice = 1 : length(choiceMat)
    choiceMechType = choiceMat{iChoice};
    for jParam = 1 : length(condParamMat)
        condParam = condParamMat{jParam};
        
        
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

        
        
        
        % Get the number of parameters
        % LB = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScope,solverType,iSubj);
        [LB,UB,X0,tg,linconA,linconB,nonlincon] = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScope,solverType,iSubj);;
        nX = numel(LB);
        clear LB
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % MERGE GO FINALLOG FILES INTO ONE DATASET(?) ARRAY
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % %   srcDir = fullfile(rootDir,sprintf('%s/fitLogs/',iSubj))
        % if ~noiseBound && ~tBound
        %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output');
        %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/newGo');
        %     %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/neural1');
        %     %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/allTrials_from_fit_GoTrials');
        % elseif noiseBound && ~tBound
        % %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/noise');
        %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/newGo/noise');
        % %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/test');
        % elseif ~noiseBound && tBound
        %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/tBound');
        % elseif noiseBound && tBound
        %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/tBound/noise');
        % end
        
        
        srcDir = fullfile(rootDir,'output/startVals/');
        srcDir = fullfile(rootDir,'output/behavior2/startVal/');
        
        expStr = sprintf('x0.*c%s_i%s_%s_%s.*.mat$',choiceMechType,inhibMechType,condParam,simScope);
        expStr = sprintf('x0.*%s.*c%s_i%s_p%s.*.mat$',simScope,choiceMechType,inhibMechType,condParam)
        %   expStr = sprintf('finalLog*.mat$');
        
        fl = regexpdir(srcDir,expStr,false);
        
        
        load(fl{1})
        
        vals = [cost, X0];
        bestFits = sortrows(vals,1);
        
        bestFits(1:15,:)
        
        X0 = bestFits(1,2:end);
        
        LB = X0;
        LB(posFree) = 0
        size(LB)
        LB(negFree) = LB(negFree) .* 2
        
        UB = X0;
        UB(negFree) = 0;
        UB(posFree) = UB(posFree) .* 2;
        
        
%         [X0;LB;UB]
%         pause
       
        
        
        
        
        % Alter the starting X0 if desired
        
        
        
        
        
        
        
        
        % Generate new starting points and constraints
        
        nStartPoints = 20;
        
        
        
        
        
        % Get bounds and X0
        [~,~,~,tg,linConA,linConB,nonLinCon] = sam_get_bnds_pgm(choiceMechType,inhibMechType,condParam,simGoal,simScope,solverType,iSubj);
        
        % Sample additional uniformly distributed starting values between LB and UB
        X0 = [X0;sam_sample_uniform_constrained_x0(nStartPoints,LB,UB,linConA,linConB,nonLinCon,solverType)];
        % X0 = [X0;sam_sample_uniform_constrained_x0(nStartPoints,LB,UB,linConA,linConB)];
        
        
        
        
        
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



end
