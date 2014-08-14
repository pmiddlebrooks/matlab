

% keep iSubj;
% close all;

iSubj             = 'broca';
condParam         = 't0';
choiceMechType    = 'race';
inhibMechType     = 'li';
simGoal           = 'optimize';
simScope          = 'go';  % go or all
solverType        = 'fminsearchcon';

% noiseBound = true;
% tBound      = true;
%


switch matlabroot
    case '/Applications/MATLAB_R2014a.app'
        rootDir = fullfile(local_data_path,'sam');
    otherwise
        rootDir = '/scratch/middlepg/sam/';
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
% elseif noiseBound && ~tBound
%     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/newGo/noise');
% elseif ~noiseBound && tBound
%     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/tBound');
% elseif noiseBound && tBound
%     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/tBound/noise');
% end

srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/behavior2');
% srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/noise');

expStr = sprintf('finalLog.*c%s_i%s_%s_%sTrials.*.mat$',choiceMechType,inhibMechType,condParam,simScope)
%   expStr = sprintf('finalLog*.mat$');

% fls = regexpdir(srcDir,expStr);
fls = regexpdir(srcDir,expStr,false);

allBestFits = nan(numel(fls),nX + 3);
nShow = min(25,numel(fls));

for i = 1:numel(fls)
    %     a = load(fls{i});
    %     a.history
    %     pause
    
    load(fls{i});
    allBestFits(i,1) = i;
    allBestFits(i,2) = exitFlag;
    allBestFits(i,3) = fVal;
    allBestFits(i,4:end) = X;
    
    clear exitFlag fVal X
end

% Sort by exitsFlag, then by fVal
[allBestFits, rnk] = sortrows(allBestFits,[2,3]);

% allBestFits(1:nShow,:)
allBestFits(1:5,:)



% Save as ASCII text
fValX = allBestFits(1,3:end);
FValXFName = fullfile(rootDir,iSubj,sprintf('bestFValX_%strials_c%s_i%s_p%s_%s.txt',simScope,choiceMechType,inhibMechType,condParam,iSubj));
save(FValXFName,'fValX','-ascii');






%
%     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/startVal');
%
% expStr = sprintf('finalLog.*c%s_i%s_%s_%sTrials.*.mat$',choiceMechType,inhibMechType,condParam,simScope)
% % fls = regexpdir(srcDir,expStr);
% fls = regexpdir(srcDir,expStr,false);
%
% allBestFits = nan(numel(fls),nX + 3);
% nShow = min(25,numel(fls));
%
% for i = 1:numel(fls)
%     %     a = load(fls{i});
%     %     a.history
%     %     pause
%
%     load(fls{i});
%     allBestFits(i,1) = i;
%     allBestFits(i,2) = exitFlag;
%     allBestFits(i,3) = fVal;
%     allBestFits(i,4:end) = X;
%
%     clear exitFlag fVal X
% end
%
% % Sort by exitsFlag, then by fVal
% [allBestFits, rnk] = sortrows(allBestFits,[2,3]);
%
% % allBestFits(1:nShow,:)
% allBestFits(1:5,:)



%%


% iSubj             = 'xena';
% choiceMechType    = 'ffi';
% inhibMechType     = 'li';
% condParam         = 'zc';
% simGoal           = 'optimize';
% simScope          = 'all';  % go or all
% solverType        = 'fminsearchcon';





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


if ~noiseBound && ~tBound
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output');
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/newGo');
    %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/neural1');
    %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/allTrials_from_fit_GoTrials');
elseif noiseBound && ~tBound
    %     srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/noise');
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/newGo/noise');
elseif ~noiseBound && tBound
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/tBound');
elseif noiseBound && tBound
    srcDir = fullfile(rootDir,sprintf('%s/',iSubj),'output/tBound/noise');
end
expStr = sprintf('iter.*c%s_i%s_%s_%sTrials.*.mat$',choiceMechType,inhibMechType,condParam,simScope);
%   expStr = sprintf('finalLog*.mat$');

fls = regexpdir(srcDir,expStr);
% fls = regexpdir(srcDir,expStr,false);

iterBestFits = nan(numel(fls),nX + 3);
nShow = min(10,numel(fls));

for i = 1:numel(fls)
    
    load(fls{i});
    %     history(90:104,:)
    % which is last index of fitting?
    ind = find(isnan(history(:,1)),1) - 1;
    
    iterBestFits(i,1) = i;
    iterBestFits(i,2) = nan;
    iterBestFits(i,3:end) = history(ind,:);
    %     allBestFits(i,4:end) = X;
    
    clear history
end

% Sort by exitsFlag, then by fVal
[iterBestFits, rnk] = sortrows(iterBestFits,3);

iterBestFits(1:nShow,:)

%
%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %       DISPLAY THE VARIOUS FITS RELATIVE TO STARTING VALUES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Load the starting parameters and their labels
xoDir = '/Users/paulmiddlebrooks/matlab/local_data/sam/';
expStr = sprintf('%s_x0.*%strials_c%s_i%s_p%s.*.mat$',iSubj,simScope,choiceMechType,inhibMechType,condParam);
regexpdir(xoDir,expStr)
t = load(char(regexpdir(xoDir,expStr)));

X0 = t.X0(rnk, :);
tg = t.tg;
for i = 1 %: size(allBestFits, 1)
    fprintf('\n %d \t %.2f\n', allBestFits(i,1), allBestFits(i,3))
    % disp(allBestFits(i,[1 3]))
    disp(tg(1:end-3))
    fitStartRatio = allBestFits(i,4:end-3) ./ X0(i,1:end-3);
    disp(fitStartRatio)
    
    figure(22)
    plot(fitStartRatio, '.k')
    disp('')
end
%

