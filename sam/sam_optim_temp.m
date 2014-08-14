function [SAM, varargout] = sam_optim_temp(SAM)
% SAM_OPTIM <Synopsis of what this function does> 
%  
% DESCRIPTION 
% <Describe more extensively what this function does> 
%  
% SYNTAX 
% SAM_OPTIM; 
%  
% EXAMPLES 
%  
%  
% REFERENCES 
%  
% ......................................................................... 
% Bram Zandbelt, bramzandbelt@gmail.com 
% $Created : Fri 12 Jul 2013 14:50:04 CDT by bram 
% $Modified: Fri 12 Jul 2013 14:54:00 CDT by bram
 
% CONTENTS 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. PROCESS INPUTS & SPECIFY VARIABLES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1.1. Process inputs
% =========================================================================

% Load data
% -------------------------------------------------------------------------
load(SAM.spec.data,'obs')

% Choice mechanism
% -------------------------------------------------------------------------
choiceMech  = SAM.spec.des.choiceMech;

% Inhibition mechanism
% -------------------------------------------------------------------------
inhibMech   = SAM.spec.des.inhibMech;

% Parameter that varies across conditions
% -------------------------------------------------------------------------
condParam   = SAM.spec.des.condParam;

% Simulation settings
% -------------------------------------------------------------------------

% Goal of simulation
simGoal     = SAM.sim.goal;

% Scope of simulation
simScope    = SAM.sim.scope;

% Number of simulated trials
nSim        = SAM.sim.nSim;

% Random number generator ID
rngID       = SAM.sim.rngID;


switch lower(simGoal)
  case 'optimize'
    
    % Optimization settings
    % ---------------------------------------------------------------------
    
    % Solver
    solver      = SAM.optim.solver;
    
  case 'explore'
end




% Cost function
costFun     = SAM.optim.costFun.name;



% Starting values
X0          = SAM.optim.solver.X0;

% Bounds
LB          = SAM.optim.solver.LB;
UB          = SAM.optim.solver.UB;

% Simulation function
% -------------------------------------------------------------------------
simFun      = SAM.optim.simFun;

% Cumulative probabilities for which to compute quantiles
% -------------------------------------------------------------------------
cumProb     = SAM.optim.costFun.cumProb;

% Minimum bin size (in number of trials per bin)
% -------------------------------------------------------------------------
minBinSize  = SAM.optim.costFun.minBinSize;

% Whether or not to plot RT distributions
% -------------------------------------------------------------------------
doPlot      = SAM.optim.doPlot;


% 1.2. Specify static variables
% =========================================================================
N_CND       = 3;              % Number of conditions
N_SSD       = 5;              % Number of stop-signal delays
iMGo        = {3:4,2:5,1:6};  % Inputs go-signal, per condition
iM_COR_GO   = 3;              % Index of correct go-signal
STATE       = struct([]);     % Somehow, this is needed for de_search.m

FITDATA     = struct('rt',[],...
                     'N',[],...
                     'P',[],...
                     'rtQ',[],...
                     'f',[],...
                     'pM',[]);
                   
DYNDATA     = struct('GoCorr',[], ...
                     'GoComm',[], ...
                     'StopSuccess',[], ...
                     'StopFailure',[]);

TDIAGRAM = struct('stim',[], ...
                  'modelinput',[]);                   
                   
% 1.3. Specify dynamic variables
% =========================================================================

switch lower(simScope)
  case 'go'
    N = 6;
    M = 6;
  case 'all'
    N = [6 1];
    M = [6 1];
    iMStop  = {7,7,7};          % Inputs stop-signal, per condition
end

iM = mat2cell((1:sum(M))',M(:),1);

trueN     = arrayfun(@(x) true(x,1),N,'Uni',0);
trueM     = arrayfun(@(x) true(x,1),M,'Uni',0);
falseM    = arrayfun(@(x) false(x,1),M,'Uni',0);

% 1.4. Pre-allocate empty arrays
% =========================================================================

fitObs = FITDATA;
fitPrd = FITDATA;
  
% Dataset array for logging model predictions
switch lower(simScope)
  case 'go'
    prd  = dataset({nan(N_CND,1),'pGoCorr'}, ...
                   {nan(N_CND,1),'pGoOmit'}, ...
                   {nan(N_CND,1),'pGoComm'}, ...
                   {cell(N_CND,1),'rtGoCorr'}, ...
                   {cell(N_CND,1),'rtGoComm'}, ...
                   {repmat(TDIAGRAM,N_CND,1),'tDiagram'}, ...
                   {obs.onset,'onset'}, ...
                   {obs.duration,'duration'});
    switch lower(SAM.sim.goal)
      case 'explore'
        prd = [prd,dataset({repmat(DYNDATA,N_CND,1),'dyn'})];
    end
  case 'all'
    prd  = dataset({nan(N_CND,1),'pGoCorr'}, ...
                   {nan(N_CND,1),'pGoOmit'}, ...
                   {nan(N_CND,1),'pGoComm'}, ...
                   {nan(N_CND,N_SSD),'pStopFailure'}, ...
                   {nan(N_CND,N_SSD),'pStopSuccess'}, ...
                   {obs.ssd,'ssd'}, ...
                   {cell(N_CND,1),'inhibFunc'}, ...
                   {cell(N_CND,1),'rtGoCorr'}, ...
                   {cell(N_CND,1),'rtGoComm'}, ...
                   {cell(N_CND,N_SSD),'rtStopFailure'}, ...
                   {cell(N_CND,N_SSD),'rtStopSuccess'}, ...
                   {repmat(TDIAGRAM,N_CND,N_SSD),'tDiagram'}, ...
                   {obs.onset,'onset'}, ...
                   {obs.duration,'duration'});
    switch lower(SAM.sim.goal)
      case 'explore'
        prd = [prd,dataset({repmat(DYNDATA,N_CND,1),'dyn'})];
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. CHARACTERIZE OBSERVED DATA
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2.1. Organize the data: trial numbers, probabilities, response times
% =========================================================================

switch lower(simScope)
  case 'go'
    fitObs.N   = [obs.nGo,obs.nGo];
    fitObs.P   = [obs.pGoCorr,obs.pGoComm];
    fitObs.rt  = [obs.rtGoCorr,obs.rtGoComm];
  case 'all'
    fitObs.N   = [obs.nGo,obs.nGo,obs.nStop];
    fitObs.P   = [obs.pGoCorr,obs.pGoComm,obs.pStopFailure];
    fitObs.rt  = [obs.rtGoCorr,obs.rtGoComm,obs.rtStopFailure];
end

% 2.2. Compute response time bin statistics
% =========================================================================
[fitObs.rtQ, ...         % Quantiles
 fitObs.pDefect, ...     % Defective probabilities
 fitObs.f, ...           % Frequencies
 fitObs.pM] ...          % Probability masses
 = cellfun(@(a,b,c) sam_bin_data(a,b,c,cumProb,minBinSize), ...
 fitObs.rt, ...          % Response times
 num2cell(fitObs.P), ... % Response probabilities
 num2cell(fitObs.N), ... % Response frequencies
 'Uni',0);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. SPECIFY PRECURSOR AND PARAMETER-INDEPENDENT MODEL MATRICES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% #.1. Precursor matrix for accumulation rates to target unit(s)
% =========================================================================
VCor          = get_model_mat('VCor');

% #.2. Precursor matrix for accumulation rates to nontarget unit(s)
% =========================================================================
VIncor        = get_model_mat('VIncor');

% #.3. Precursor matrix for extrinsic and intrinsic noise levels
% =========================================================================
S             = get_model_mat('S');

% #.4. Termination matrix
% =========================================================================
terminate     = get_model_mat('terminate');

% #.5. Blocked innput matrix
% =========================================================================
blockInput    = get_model_mat('blockInput');

% #.6. Lateral inhibition matrix
% =========================================================================
latInhib      = get_model_mat('latInhib');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. OPTIMIZE THE MODEL
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4.1. Seed the random number generator
% =========================================================================
% clear(char(simFun));  % Clear MEX function
rng(rngID);

doPlot = 1;

switch simGoal
  case 'explore'
    [cost,prd] = costFun(simGoal, ...
                         X0, ...
                         STATE, ...
                         obs, ...
                         prd, ...
                         SAM, ...
                         nSim, ...
                         simFun, ...
                         simScope, ...
                         VCor, ...
                         VIncor, ...
                         S, ...
                         terminate, ...
                         blockInput, ...
                         latInhib, ...
                         doPlot);
    
    varargout{1} = cost;
    varargout{2} = prd;
    
  case 'optimize'

    fprintf('Time: %s. \n',datestr(now,'HH:MM:SS'));
    
    % Run estimation
    % =====================================================================
    switch lower(solver.type)
      case 'fminsearchbnd'

        [X, ...
         fVal, ...
         exitFlag, ...
         solverOutput] = fminsearchbnd(@(X0)  costFun(simGoal, ...
                                                      X0, ...
                                                      STATE, ...
                                                      obs, ...
                                                      prd, ...
                                                      SAM, ...
                                                      nSim, ...
                                                      simFun, ...
                                                      simScope, ...
                                                      VCor, ...
                                                      VIncor, ...
                                                      S, ...
                                                      terminate, ...
                                                      blockInput, ...
                                                      latInhib, ...
                                                      doPlot), ...
                                                      ...
                                                      X0, ...
                                                      LB, ...
                                                      UB, ...
                                                      solver.options);


      case 'de'
      case 'ga'

        nX = numel(LB);
        Aineq=[];bineq=[];Aeq=[];beq=[];
        
        [X, ...
         fVal, ...
         exitFlag, ...
         solverOutput, ...
         pop, ...
         cost] = ga(@(X)  costFun(simGoal, ...
                                  X0, ...
                                  STATE, ...
                                  obs, ...
                                  prd, ...
                                  SAM, ...
                                  nSim, ...
                                  simFun, ...
                                  simScope, ...
                                  VCor, ...
                                  VIncor, ...
                                  S, ...
                                  terminate, ...
                                  blockInput, ...
                                  latInhib, ...
                                  doPlot), ...
                                  ...
                                  nX, ...
                                  Aineq, ...
                                  bineq, ...
                                  Aeq, ...
                                  beq, ...
                                  LB, ...
                                  UB, ...
                                  [], ...
                                  solver.options);

      case 'sa'

        [X, ...
         fVal, ...
         exitFlag, ...
         solverOutput] = simulannealbnd(@(X)  costFun(simGoal, ...
                                                      X0, ...
                                                      STATE, ...
                                                      obs, ...
                                                      prd, ...
                                                      SAM, ...
                                                      nSim, ...
                                                      simFun, ...
                                                      simScope, ...
                                                      VCor, ...
                                                      VIncor, ...
                                                      S, ...
                                                      terminate, ...
                                                      blockInput, ...
                                                      latInhib, ...
                                                      doPlot), ...
                                                      ...
                                                      X0, ...
                                                      LB, ...
                                                      UB, ...
                                                      solver.options);
    end

    SAM.estim.X             = X;
    SAM.estim.fVal          = fVal;
    SAM.estim.exitFlag      = exitFlag;
    SAM.estim.solverOutput  = solverOutput;

end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 5. NESTED FUNCTIONS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% #.1. Function for specifying precursor and parameter-independent model matrices
% =========================================================================
function varargout = get_model_mat(matType)

end