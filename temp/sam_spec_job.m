% Script specifying job details
%
% DESCRIPTION
% This script contains all the details for the job to run
%
% .........................................................................
% Bram Zandbelt, bramzandbelt@gmail.com
% $Created : Mon 09 Sep 2013 13:07:49 CDT by bram
% $Modified: Sat 21 Sep 2013 12:24:04 CDT by bram


% CONTENTS

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% #. INPUT/OUTPUT
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SAM.io.jobDir                     = '/Users/bramzandbelt/Documents/PROJECTS/SAM/output/test/';
% SAM.io.jobName                    = 'test';
% SAM.io.outDir                     = '/Users/bramzandbelt/Documents/PROJECTS/SAM/output/test/';
%
%
% SAM.io.obsFile                    = '/Users/bramzandbelt/Documents/PROJECTS/SAM/output/data_preproc_subj08.mat';
%
% load(SAM.io.obsFile);

%%
exploreFromFile = false;



SAM.io.jobDir                     = '/Users/paulmiddlebrooks/matlab/local_data/';
SAM.io.jobName                    = 'test';


%%
timeStr = datestr(now,'yyyy-mm-dd-THHMMSS');
tS = tic;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% #. SPECIFY THE ENVIRONMENT
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch matlabroot
    case '/Applications/MATLAB_R2013a.app'
        env = 'local';
    otherwise
        env = 'accre';
end
% env = 'accre';

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% #. INPUT/OUTPUT
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Determine which subject to fit
switch env
  case 'local'
    iSubj = 'broca';
%     iSubj = 'xena';
%     iSubj = 'human';
   case 'accre'
    iSubj = str2double(getenv('subject'));
end
SAM.des.iSubj   = iSubj;



% Subsample the SSDs (because there are so many collected across sessions?
subSampleSSDFlag = 1;

if subSampleSSDFlag == 1
    obsFileName                       = ['obs_',iSubj, '_concat_sam_sub.mat'];
else
    obsFileName                       = ['obs_',iSubj, '_concat_sam.mat'];
end





% Path settings
switch env
    case 'local'
        
        %      % Add directories to search path
        %       bzenv('all')
        
        % Specify
        rootDir = ['/Users/paulmiddlebrooks/matlab/local_data/sam/',iSubj];
        
        % Subject directory and observations file
        SAM.io.outDir = fullfile(rootDir, 'output/');
        SAM.io.obsFile = fullfile(rootDir,obsFileName);
        
    case 'accre' % ACCRE
        
        % Add directories to search path
        addpath('/home/middlepg/sam/');
        addpath(genpath('/home/middlepg/m-files/general/'));
        
        rootDir = ['/scratch/middlepg/sam/',SAM.des.iSubj];
        
        % Subject directory and observations file
        SAM.io.outDir = fullfile(rootDir, 'output/');
        %       SAM.io.outDir = fullfile(rootDir, 'output/noise/');
        SAM.io.obsFile = fullfile(rootDir,obsFileName);
        
end

%
load(SAM.io.obsFile);
%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% #. SPECIFY MODEL DESIGN
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% #.1. Choice mechanism
% =========================================================================

% Choice mechanism type
% -------------------------------------------------------------------------
% 'race' - Race
% 'ffi' - Feed-forward inhibition
% 'li' - Lateral inhibition

switch env
    case 'local'
%         SAM.des.choiceMech.type = 'race';
%             SAM.des.choiceMech.type            = 'ffi';
            SAM.des.choiceMech.type            = 'li';
    case 'accre'
        iChoiceMechType = str2double(getenv('choiceMech'));
        switch iChoiceMechType
            case 1
                SAM.des.choiceMech.type = 'race';
            case 2
                SAM.des.choiceMech.type = 'ffi';
            case 3
                SAM.des.choiceMech.type = 'li';
        end
end


% #.2. Inhibition mechanism
% =========================================================================

% Inhibition mechanism type
% -------------------------------------------------------------------------
% 'race' - Race
% 'bi' - Blocked input
% 'li' - Lateral inhibition

switch env
    case 'local'
        %     SAM.des.inhibMech.type = 'race';
        %     SAM.des.inhibMech.type = 'bi';
        SAM.des.inhibMech.type = 'li';
    case 'accre'
        iInhibMechType = str2double(getenv('inhibMech'));
        switch iInhibMechType
            case 1
                SAM.des.inhibMech.type = 'race';
            case 2
                SAM.des.inhibMech.type = 'bi';
            case 3
                SAM.des.inhibMech.type = 'li';
        end
end


% #.3. Accumulation mechanism
% =========================================================================

% Lower bound on activation
% -------------------------------------------------------------------------
SAM.des.accumMech.zLB              = 0;

% Time window during which accumulation is 'recorded'
% -------------------------------------------------------------------------
% Time is relative to trial onset
% SAM.des.accumMech.timeWindow       = [240 2250];
SAM.des.accumMech.timeWindow       = [0 2000];   % pgm: acccounting for variable stimulus onset time, so always start at stimulus onset

% Time step
% -------------------------------------------------------------------------
SAM.des.time.dt                    = 5;

% Time constant
% -------------------------------------------------------------------------
SAM.des.time.tau                   = 1;

% Dependency of intrinsic noise on model input
% -------------------------------------------------------------------------
SAM.des.inpDepNoise = true;


% #.4. Experiment parameters
% =========================================================================


% if subSampleSSDFlag
%    % Subsample the SSDs for simulation purposes
%    allStop     = obs.nStopSuccess + obs.nStopFailureCorr + obs.nStopFailureComm;
%    pStop       = allStop ./ sum(allStop);
%
%    [pks, loc] 	= findpeaks(pStop);
%    loc         = reshape(loc, length(loc), 1);
%    loc(loc == 1 | loc == 2) = [];
%
%    subIndices = [1 2 loc(1:end-3)'];  % Use the first 2 ssds and whatever values findpeaks returned
%
%    subPStop    = pStop(subIndices);
%    normSubPStop = subPStop ./ max(subPStop);
%
%
%    % Go through and subsample the relevant variables in the observation
%    % dataset:
%    obs.ssd                 = obs.ssd(:, subIndices);
%    obs.onset               = obs.onset(:, [1 subIndices]);
%    obs.duration            = obs.duration(:, [1 subIndices]);
%    obs.nStop               = obs.nStop(:, subIndices);
%    obs.nStopFailureCorr    = obs.nStopFailureCorr(:, subIndices);
%    obs.nStopFailureComm    = obs.nStopFailureComm(:, subIndices);
%    obs.nStopSuccess        = obs.nStopSuccess(:, subIndices);
%    obs.pStopFailure        = obs.pStopFailure(:, subIndices);
%    obs.pStopFailureCorr    = obs.pStopFailureCorr(:, subIndices);
%    obs.pStopFailureComm    = obs.pStopFailureComm(:, subIndices);
%    obs.inhibFunc           = obs.inhibFunc(:, subIndices);
%    obs.rtStopFailureCorr   = obs.rtStopFailureCorr(:, subIndices);
%    obs.rtStopFailureComm   = obs.rtStopFailureComm(:, subIndices);
%
% else
allStop     = obs.nStopSuccess + obs.nStopFailureCorr + obs.nStopFailureComm;
allStop     = sum(allStop, 1);
pStop       = allStop ./ sum(allStop);
normSubPStop = pStop ./ max(pStop);
% end



% Number of task conditions
% -------------------------------------------------------------------------
% SAM.des.expt.nCnd                  = 3;
SAM.des.expt.nCnd                  = size(obs, 1);    % pgm

% Number of stop-signal delays
% -------------------------------------------------------------------------
% SAM.des.expt.nSsd                  = 5;
SAM.des.expt.nSsd                  = length(obs.ssd(1,:));    % pgm:
% SAM.des.expt.nSsd                  = length(subSSD(1,:));    % pgm:

% Stimulus onsets
% -------------------------------------------------------------------------
SAM.des.expt.stimOns               = obs.onset;
% SAM.des.expt.stimOns               = subOnset;

% Stimulus durations
% -------------------------------------------------------------------------
SAM.des.expt.stimDur               = obs.duration;
% SAM.des.expt.stimDur               = subDuration;

% #.5. Model parameters
% =========================================================================

% Parameter that varies across task conditions
% -------------------------------------------------------------------------
switch env
    case 'local'
%               SAM.des.condParam                  = 't0';
                    SAM.des.condParam = 'v';
%         SAM.des.condParam = 'zc';
    case 'accre'
        iCondParam = str2double(getenv('condParam'));
        switch iCondParam
            case 1
                SAM.des.condParam = 't0';
            case 2
                SAM.des.condParam = 'v';
            case 3
                SAM.des.condParam = 'zc';
        end
end


% Number of units
% -------------------------------------------------------------------------
% SAM.des.nGO                        = 6;
SAM.des.nGO                        = 2;   % pgm
SAM.des.nSTOP                      = 1;

% Indices of GO inputs, per condition
% -------------------------------------------------------------------------
% SAM.des.iGO                        = {3:4,2:5,1:6};
% SAM.des.iGO                        = {1:2, 1:2, 1:2, 2:-1:1, 2:-1:1, 2:-1:1};  % pgm
SAM.des.iGO                        = {1:2, 1:2, 1:2, 1:2, 1:2, 1:2};  % pgm

% Indices of target GO inputs, per condition
% -------------------------------------------------------------------------
% SAM.des.iGOT                       = {3,3,3};
SAM.des.iGOT                       = {1, 1, 1, 2, 2, 2}; % pgm
% SAM.des.iGOT                       = {1, 1, 1, 1, 1, 1}; % pgm

% Indices of nontarget GO inputs, per condition
% -------------------------------------------------------------------------
% SAM.des.iGONT                      = cellfun(@(a,b) setdiff(a,b),SAM.des.iGO,SAM.des.iGOT,'Uni',0);
SAM.des.iGONT                       = {2, 2, 2, 1, 1, 1}; % pgm
% SAM.des.iGONT                       = {2, 2, 2, 2, 2, 2}; % pgm

% Indices of Stop inputs, per condition
% -------------------------------------------------------------------------
% SAM.des.iSTOP                      = {7,7,7};
SAM.des.iSTOP                      = {3, 3, 3, 3, 3, 3};    % pgm

% Duration of STOP process
% -------------------------------------------------------------------------
% 'stop-signal' - the STOP unit is active for the period that
% the stop-signal is presented
% 'trial' - the STOP process is active for the entire
% duration of the trial

SAM.des.durationSTOP = 'trial';



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% #. SPECIFY MODEL SIMULATION SETTINGS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% #.#. Goal of simulation
% =========================================================================
% Optimization can proceed in two ways:
% 'startvals' - Find good starting values by sampling uniformly
%       distributed starting points with bounds, linear, and/or
%       nonlinear constraints, and then computing the fit between
%       observations and model predictions.
% 'optimize'   - An optimization algorithm automatically tries to find the
%                 optimal solution to the cost function (specified below).
% 'explore'    - No actual optimization takes place; the model is run and
%                 figures are produced showing observations and model
%                 predictions with current parameters. The parameters can
%                 then be adjusted manually, and the model is run again, in
%                 order to get starting parameters that produce predictions

switch env
    case 'local'
        SAM.sim.goal = 'explore';
        %             SAM.sim.goal = 'optimize';
    case 'accre'
        iSimGoal = str2double(getenv('simGoal'));
        switch iSimGoal
            case 1
                SAM.sim.goal = 'startvals';
            case 2
                SAM.sim.goal = 'optimize';
        end
end


% #.#. Scope of simulation
% =========================================================================
% This specifies what data will be simulated
% 'go' - Simulate Go trials only
% 'all' - Simulate Go and Stop trials

switch env
    case 'local'
        SAM.sim.scope = 'go';
              SAM.sim.scope = 'all';
    case 'accre'
        iSimScope = str2double(getenv('simScope'));
        switch iSimScope
            case 1
                SAM.sim.scope = 'go';
            case 2
                SAM.sim.scope = 'all';
        end
end




% #.#. Number of simulated trials
% =========================================================================
% The same number of trials is used for each trial type
switch env
    case 'local'
        % For go trials, use a single value
        nSimGo     = 4000;
        nSimStop   = round(nSimGo .* normSubPStop);
    case 'accre'
        % For go trials, use a single value
        nSimGo     = 2000;
        nSimStop   = round(nSimGo .* normSubPStop);
end

switch lower(SAM.sim.goal)
    case 'explore'
        switch SAM.sim.scope
            case 'go'
                SAM.sim.nSim                          = repmat(nSimGo, SAM.des.expt.nCnd, 1);
            case 'all'
                SAM.sim.nSim                          = repmat([nSimGo nSimStop], SAM.des.expt.nCnd, 1);
                %             SAM.sim.nSim                          = nSimGo;
        end
        
        % If we're optimizing, need to make nSim larger to accomodate  each outcome
        % possible that is used when calculting cost function, see sam_sim_expt.m
        % line 951 (+ a few lines) for the structure needed
    case 'optimize'
        switch SAM.sim.scope
            case 'go'
                SAM.sim.nSim                          = repmat([nSimGo nSimGo], SAM.des.expt.nCnd, 1);
            case 'all'
                SAM.sim.nSim                          = repmat([nSimGo nSimGo nSimStop nSimStop], SAM.des.expt.nCnd, 1);
                %             SAM.sim.nSim                          = nSimGo;
        end
end





% #.#. Random number generator seed
% =========================================================================

SAM.sim.rngID                         = rng('shuffle'); % MATLAB's default


% #.#. Moment in the simulation when to seed the random number generator
% =========================================================================
% 'sam_sim_expt' - The RNG is seeded in sam_sim_expt.m (i.e. every
%       simulation of an experiment). This will give
%       model predictions given identical parameters.
% 'sam_run_job' - The RNG is seeded in sam_run_job.m (i.e. only
%       once). This will usually give different predictions
%       with identical parameters, because the the
%       optimization routine starts from different points
%       usually.

SAM.sim.rngSeedStage = 'sam_sim_expt';

% #.#. Experiment simulation function
% =========================================================================

SAM.sim.exptSimFun                    = @sam_sim_expt;

% #.#. Trial simulation function
% =========================================================================

if SAM.des.inpDepNoise
    switch lower([SAM.des.choiceMech.type,'-',SAM.des.inhibMech.type])
        case 'race-race'
            SAM.sim.trialSimFun = @sam_sim_trial_crace_irace_nomodbd_inpdepnoise_mex;
        case 'race-bi'
            SAM.sim.trialSimFun = @sam_sim_trial_crace_ibi_nomodbd_inpdepnoise_mex;
        case 'race-li'
            SAM.sim.trialSimFun = @sam_sim_trial_crace_ili_nomodbd_inpdepnoise_mex;
        case 'ffi-race'
            SAM.sim.trialSimFun = @sam_sim_trial_cffi_irace_nomodbd_inpdepnoise_mex;
        case 'ffi-bi'
            SAM.sim.trialSimFun = @sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise_mex;
        case 'ffi-li'
            SAM.sim.trialSimFun = @sam_sim_trial_cffi_ili_nomodbd_inpdepnoise_mex;
        case 'li-race'
            SAM.sim.trialSimFun = @sam_sim_trial_cli_irace_nomodbd_inpdepnoise_mex;
        case 'li-bi'
            SAM.sim.trialSimFun = @sam_sim_trial_cli_ibi_nomodbd_inpdepnoise_mex;
        case 'li-li'
            SAM.sim.trialSimFun = @sam_sim_trial_cli_ili_nomodbd_inpdepnoise_mex;
    end
else
    switch lower([SAM.des.choiceMech.type,'-',SAM.des.inhibMech.type])
        case 'race-race'
            SAM.sim.trialSimFun = @sam_sim_trial_crace_irace_nomodbd_mex;
        case 'race-bi'
            SAM.sim.trialSimFun = @sam_sim_trial_crace_ibi_nomodbd_mex;
        case 'race-li'
            SAM.sim.trialSimFun = @sam_sim_trial_crace_ili_nomodbd_mex;
        case 'ffi-race'
            SAM.sim.trialSimFun = @sam_sim_trial_cffi_irace_nomodbd_mex;
        case 'ffi-bi'
            SAM.sim.trialSimFun = @sam_sim_trial_cffi_ibi_nomodbd_mex;
        case 'ffi-li'
            SAM.sim.trialSimFun = @sam_sim_trial_cffi_ili_nomodbd_mex;
        case 'li-race'
            SAM.sim.trialSimFun = @sam_sim_trial_cli_irace_nomodbd_mex;
        case 'li-bi'
            SAM.sim.trialSimFun = @sam_sim_trial_cli_ibi_nomodbd_mex;
        case 'li-li'
            SAM.sim.trialSimFun = @sam_sim_trial_cli_ili_nomodbd_mex;
    end
end




% Starting value index
% -------------------------------------------------------------------------
% There may be a set of starting values from which optimization begins

switch lower(env)
    case 'local'
        iStartVal = 1;
    case 'accre'
        iStartVal = str2double(getenv('iStartVal'));
end


switch lower(SAM.sim.goal)
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % #. SPECIFY STARTING POINT EXPLORATION SETTINGS
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    case 'startvals'
        
        % Number of starting points
        SAM.startvals.nX0 = 100;
        
        % Specify parameter bounds, starting values, and names
        % =====================================================================
        [LB, ... % Lower bounds
            UB, ... % Upper bounds
            ~, ... % Starting values
            tg, ... % Parameter name
            linConA, ... % Term A in linear inequality A*X <= B
            linConB, ... % Term B in linear inequality A*X <= B
            nonLinCon] ... % Function accepting X and returning
            ... % nonlinear inequalities and equalities
            ...
            = sam_get_bnds_pgm(... % FUNCTION
            ... % INPUTS
            SAM);
        
        % Lower bounds
        SAM.startvals.LB = LB;
        
        % Upper bounds
        SAM.startvals.UB = UB;
        
        % Linear constraints
        SAM.startvals.linConA = linConA;
        SAM.startvals.linConB = linConB;
        
        % Nonlinear constraints
        SAM.startvals.nonLinCon = nonLinCon;
        
        
        % Cost function specifics
        % =====================================================================
        
        % Cost function
        % ---------------------------------------------------------------------
        SAM.startvals.costFun = @sam_cost;
        
        % Cost function statistic type
        % ---------------------------------------------------------------------
        SAM.startvals.costStat = 'chisquare';
        
        % Cumulative probabilities for which to compute quantiles
        % ---------------------------------------------------------------------
        SAM.startvals.cumProb = [.1 .3 .5 .7 .9];
        
        % Minimum bin size (in number of trials per bin)
        SAM.startvals.minBinSize = 40;
        
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % #. SPECIFY MODEL OPTIMIZATION SETTINGS
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    case 'optimize'
        
        % Optimization solver
        % =====================================================================
        
        % Solver type
        % ---------------------------------------------------------------------
        % de - differential evolution
        % fminsearchbnd - bounded simplex
        % fminsearchcon - constrained simplex
        % fmincon - find constrained minimum with 'interior-point'
        % algorithm
        % ga - genetic algorithm
        % sa - simulated annealing
        
        SAM.optim.solverType = 'fminsearchcon';
        
        
        
        
        % Specify parameter bounds, starting values, and names
        % =====================================================================
        
        % Solver options
        % ---------------------------------------------------------------------
        %
        % Solver Options structure function Important fields
        % ------ -------------------------- ---------------------
        % 'de' ?
        % 'fminsearchcon' optimset(@fminsearch)
        % 'ga' gaoptimset(@ga)
        % 'sa' saoptimset(@simulannealbnd)
        %
        
        switch lower(SAM.optim.solverType)
            case 'de'
                error('Don''t know which option structure to use. Implement this.');
            case 'fminsearchbnd'
                SAM.optim.solverOpts = optimset(@fminsearch);
            case 'fminsearchcon'
                SAM.optim.solverOpts = optimset(@fminsearch);
            case 'fmincon'
                SAM.optim.solverOpts = optimset(@fmincon);
            case 'ga'
                SAM.optim.solverOpts = gaoptimset(@ga);
            case 'sa'
                SAM.optim.solverOpts = saoptimset(@simulannealbnd);
        end
        
        % General options
        SAM.optim.solverOpts.Display = 'iter';
        SAM.optim.solverOpts.PlotFcns = {[]};
        
        % Solver-specific options
        switch lower(SAM.optim.solverType)
            case 'de'
                
                % OPTIONS:
                % These options may be specified using parameter, value pairs or by
                % passing a structure. Defaults are shown in parentheses.
                % popsize - total number of individuals. (100)
                % generations - (10)
                % strategy - mutation strategy (see MUTATE for options)
                % step_weight - stepsize weight (between 0 and 2) to apply to
                % differentials when mutating parameters (0.85)
                % crossover - crossover probability constant (between 0 and
                % 1). Percentage of random new mutated
                % parameters to use in the new population (1)
                % range_bound - boolean indicating whether parameters are
                % strictly bound by the values in ranges (true)
                % start_file - path to a MAT-file containing two variables:
                % fitness
                % parameters
                % collect_erfvec - if true, erf values will be saved. (false)
                
                
            case 'fminsearchbnd'
                
                SAM.optim.solverOpts.MaxFunEvals = 150000;
                SAM.optim.solverOpts.MaxIter = 50;
                SAM.optim.solverOpts.TolFun = 1e-4;
                SAM.optim.solverOpts.TolX = 1e-4;
                
            case 'fminsearchcon'
                
                SAM.optim.solverOpts.MaxFunEvals = 2000;
                SAM.optim.solverOpts.MaxIter = 2000;
                SAM.optim.solverOpts.TolFun = 1e-5;
                SAM.optim.solverOpts.TolX = 1e-5;
                
            case 'fmincon'
                
                SAM.optim.solverOpts.MaxFunEvals = 1000;
                SAM.optim.solverOpts.MaxIter = 50;
                SAM.optim.solverOpts.TolFun = 1e-4;
                SAM.optim.solverOpts.TolX = 1e-4;
                SAM.optim.solverOpts.Algorithm = 'interior-point';
            case 'ga'
                
                popSize=30;
                nOfColony=1;
                popVec=ones(1,nOfColony)*popSize;
                
                SAM.optim.solverOpts.PopInitRange = [LB;UB];
                SAM.optim.solverOpts.PopulationSize = popVec;
                SAM.optim.solverOpts.EliteCount = floor(popSize*.2);
                SAM.optim.solverOpts.Generations = 2;
                SAM.optim.solverOpts.CrossoverFcn = {@crossoverscattered};
                SAM.optim.solverOpts.MutationFcn = {@mutationadaptfeasible};
                SAM.optim.solverOpts.SelectionFcn = {@selectionroulette};
                SAM.optim.solverOpts.Vectorized = 'off';
                SAM.optim.solverOpts.PlotFcns = {@gaplotbestf,@gaplotbestindiv};
                
            case 'sa'
                
                SAM.optim.solverOpts.PlotFcns = {@optimplotx, ...
                    @optimplotfval, ...
                    @optimplotfunccount};
        end
        
        % Read starting values, bounds, and constraints from file
        % ---------------------------------------------------------------------
        % fName = fullfile(SAM.io.outDir,sprintf('x0_%strials_c%s_i%s_p%s.mat', ...
        % SAM.sim.scope, ...
        % SAM.des.choiceMech.type, ...
        % SAM.des.inhibMech.type, ...
        % SAM.des.condParam));
        %
        % % Load the file with starting values
        % X0Struct = load(fName,'X0');
        %
        % % Select X0 corresponding to the starting value index
        % SAM.optim.X0 = X0Struct.X0(iStartVal,:);
        
        outDir            = SAM.io.outDir;
        choiceMechType    = SAM.des.choiceMech.type;
        inhibMechType     = SAM.des.inhibMech.type;
        condParam         = SAM.des.condParam;
        simScope          = SAM.sim.scope;
        solverType        = SAM.optim.solverType;
        
        % Specify file with starting values
        X0fName           = sprintf('%s_x0_%strials_c%s_i%s_p%s.mat', iSubj, simScope, ...
            choiceMechType,inhibMechType,condParam);
        X0Path            = fullfile(rootDir,X0fName);
        
        % Load the file with starting values
        X0Struct          = load(X0Path);
        
        % Set the starting values and parameter names
        SAM.optim.X0      = X0Struct.X0(iStartVal,:);
        SAM.optim.XName   = X0Struct.tg;
        
        % Specify file with constraints
        constrfName       = sprintf('%s_constraints_%strials_c%s_i%s_p%s.mat', iSubj, simScope, ...
            choiceMechType,inhibMechType,condParam);
        constrPath        = fullfile(rootDir,constrfName);
        
        % Load the file with constraints
        constrStruct      = load(constrPath);
        
        % Lower and upper bounds
        % ---------------------------------------------------------------------
        switch lower(solverType)
            case {'fminsearchbnd','fminsearchcon','fmincon','ga'}
                SAM.optim.LB = constrStruct.LB;
                SAM.optim.UB = constrStruct.UB;
        end
        
        % Linear and nonlinear (in)equalities
        % ---------------------------------------------------------------------
        switch lower(SAM.optim.solverType)
            case {'fminsearchcon','fmincon','ga'}
                SAM.optim.linConA = constrStruct.linConA;
                SAM.optim.linConB = constrStruct.linConB;
                SAM.optim.nonLinCon = constrStruct.nonLinCon;
        end
        
        % Cost function specifics
        % =====================================================================
        
        % Cost function
        % ---------------------------------------------------------------------
        SAM.optim.costFun = @sam_cost;
        
        % Cost function statistic type
        % ---------------------------------------------------------------------
        SAM.optim.costStat = 'chisquare';
        
        % Cumulative probabilities for which to compute quantiles
        % ---------------------------------------------------------------------
        SAM.optim.cumProb = [.1 .3 .5 .7 .9];
        
        % Minimum bin size (in number of trials per bin)
        SAM.optim.minBinSize = 40;
        
        % Logging optimization
        % =====================================================================
        
        % File name of observations file
        [~,fName,fExt] = fileparts(SAM.io.obsFile);
        
        % General file name string for iteration and final log file
        fNameStr = [fName,'_', ...
            'c',SAM.des.choiceMech.type,'_', ...
            'i',SAM.des.inhibMech.type,'_', ...
            SAM.des.condParam,'_', ...
            SAM.sim.scope,'Trials_', ...
            'iX',sprintf('%.3d',iStartVal),'_' ...
            timeStr, ...
            '.mat'];
        
        % Iteration log file
        % ---------------------------------------------------------------------
        SAM.optim.iterLogFile = fullfile(SAM.io.outDir,['iterLog_',fNameStr]);
        
        % Iteration log frequency
        % ---------------------------------------------------------------------
        % Set to inf if iterations should not be logged
        SAM.optim.iterLogFreq = 50; % Iterations
        
        % Final log file
        % ---------------------------------------------------------------------
        SAM.optim.finalLogFile = fullfile(SAM.io.outDir,['finalLog_',fNameStr]);
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % #. SPECIFY MODEL EXPLORATION SETTINGS
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    case 'explore'
        
        % Specify parameter bounds, starting values, and names
        % =====================================================================
        
        [LB, ... % Lower bounds
            UB, ... % Upper bounds
            X, ... % Starting values
            tg, ... % Parameter name
            linConA, ... % Term A in linear inequality A*X <= B
            linConB, ... % Term B in linear inequality A*X <= B
            nonLinCon] ... % Function accepting X and returning
            ... % nonlinear inequalities and equalities
            ...
            = sam_get_bnds_pgm(... % FUNCTION
            ... % INPUTS
            SAM);
        
        if exploreFromFile
            disp('Using parameters from a fit (sam_spec_job.m: exploreFromFile set to true)');
            
            fitInd = 1;
            allBestFits = sam_get_best_fits(SAM);
            
            
%             outDir = SAM.io.outDir;
%             choiceMechType = SAM.des.choiceMech.type;
%             inhibMechType = SAM.des.inhibMech.type;
%             condParam = SAM.des.condParam;
%             simScope = SAM.sim.scope;
%             
%             % Specify file with starting values
%             X0fName = sprintf('x0_%strials_c%s_i%s_p%s.mat',simScope, ...
%                 choiceMechType,inhibMechType,condParam);
%             X0Path = fullfile(outDir,X0fName);
%             
%             % Load the file with starting values
%             X0Struct = load(X0Path);
%             
            % Set the starting values and parameter names
            %         SAM.explore.X = X0Struct.X;
            X = allBestFits(fitInd, 4:end);
%             tg = X0Struct.tg;
            
            
            
        end
        
        % Set the starting values and parameter names
        
        SAM.explore.X = X;
        SAM.explore.XName = tg;
        
        % #.#. Time windows for event alignments
        % =====================================================================
        
        % Alignment on go-signal
        SAM.explore.tWinGo = [-250 2250];
        
        % Alignment on stop-signal
        SAM.explore.tWinStop = [-250 2250];
        
        % Alignment on response
        SAM.explore.tWinResp = [-500 0];
        
        % #.#. Whether or not to plot RT distributions
        % =====================================================================
        SAM.explore.doPlot = false;
        
        %     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % % #. SPECIFY MODEL EXPLORATION SETTINGS
        % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   case 'explore'
        %
        %
        %     % Starting values
        %     % ---------------------------------------------------------------------
        %     SAM.explore.X                                 = X0;
        %
        %
        %     % #.#. Time windows for event alignments
        %     % =====================================================================
        %
        %     % Alignment on go-signal
        %     SAM.explore.tWinGo                            = [-250 2000];
        %
        %     % Alignment on stop-signal
        %     SAM.explore.tWinStop                          = [-250 2000];
        %
        %     % Alignment on response
        %     SAM.explore.tWinResp                          = [-500 0];
        %
        %     % #.#. Whether or not to plot RT distributions
        %     % =====================================================================
        %     SAM.explore.doPlot                            = false;
        
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% #. SAVE JOB
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch env
    case 'local' % Run job, do not save it
    case 'accre' % Save and run job
        simGoal = SAM.sim.goal;
        simScope = SAM.sim.scope;
        choiceMechType = SAM.des.choiceMech.type;
        inhibMechType = SAM.des.inhibMech.type;
        condParam = SAM.des.condParam;
        
        fName = sprintf('job_%s_%strials_c%s_i%s_p%s_iX%s_%s.mat',simGoal,simScope, ...
            choiceMechType,inhibMechType,condParam,sprintf('%.3d',iStartVal),timeStr);
        
        save(fullfile(SAM.io.outDir,fName),'SAM');
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% #. RUN JOB
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(SAM.sim.goal)
    case 'startvals'
        sam_run_job(SAM);
    case 'optimize'
        [X,fVal,exitFlag,solverOutput,history] = sam_run_job(SAM);
        tElapse = toc(tS);
        assignin('base','X',X);
        assignin('base','fVal',fVal);
        assignin('base','exitFlag',exitFlag);
        assignin('base','solverOutput',solverOutput);
        assignin('base','history',history);
        assignin('base','tElapse',tElapse);
    case 'explore'
        [prd,modelMat] = sam_run_job(SAM);
        tElapse = toc(tS);
        assignin('base','prd',prd);
        assignin('base','modelMat',modelMat);
        assignin('base','tElapse',tElapse);
end