function varargout = sam_run_job(SAM)
% SAM_RUN_JOB <Synopsis of what this function does> 
%  
% DESCRIPTION 
% <Describe more extensively what this function does> 
%  
% SYNTAX 
% SAM_RUN_JOB; 
%  
% EXAMPLES 
%  
%  
% REFERENCES 
%  
% ......................................................................... 
% Bram Zandbelt, bramzandbelt@gmail.com 
% $Created : Sat 21 Sep 2013 12:48:45 CDT by bram 
% $Modified: Sat 21 Sep 2013 12:56:52 CDT by bram

 
% CONTENTS 
% 1.PROCESS INPUTS AND SPECIFY VARIABLES
%   1.1. Process inputs
%   1.2. Specify static variables
%   1.3. Pre-allocate empty arrays
% 2.RUN JOB

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 1. PROCESS INPUTS AND SPECIFY VARIABLES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% 1.1. Process inputs
% ========================================================================= 

% Output directory
outDir = SAM.io.outDir;

% Choice mechanism
choiceMechType = SAM.des.choiceMech.type;

% Inhibition mechanism
inhibMechType = SAM.des.inhibMech.type;

% Parameter that varies across conditions
condParam = SAM.des.condParam;


% Number of conditions
nCnd        = SAM.des.expt.nCnd;

% Number of stop-signal delays
nSsd        = SAM.des.expt.nSsd;

% Stimulus onsets
stimOns     = SAM.des.expt.stimOns;

% Stimulus durations
stimDur     = SAM.des.expt.stimDur;

% Goal of the simulation
simGoal     = SAM.sim.goal;

% Scope of the simulation
simScope    = SAM.sim.scope;

% Random number generator seed
rngID       = SAM.sim.rngID;

% Trial simulation function
trialSimFun = SAM.sim.trialSimFun;

% % Parameter values 
% X           = SAM.explore.X;

switch lower(simGoal)
  case 'explore'
    % Parameter values
    X = SAM.explore.X;
  case 'explorex0'
    
    % Bounds
    LB = SAM.explorex0.LB;
    UB = SAM.explorex0.UB;
    
    % Linear constraints
    linConA = SAM.explorex0.linConA;
    linConB = SAM.explorex0.linConB;
    
    % Nonlinear constraints
    nonLinCon = SAM.explorex0.nonLinCon;
    
end


% 1.2. Pre-allocate empty arrays
% =========================================================================

% Structure for logging model dynamics                   
dynData       = struct('GoCorr',[], ...
                       'GoComm',[], ...
                       'StopSuccess',[], ...
                       'StopFailure',[]);

% Structure for logging timing diagrams
tDiagram      = struct('stim',[], ...
                       'modelinput',[]);    

% Dataset array for logging model predictions
switch lower(simScope)
  case 'go'
    prd  = dataset({nan(nCnd,1),'pGoCorr'}, ...
                   {nan(nCnd,1),'pGoComm'}, ...
                   {nan(nCnd,1),'pGoOmit'}, ...
                   {cell(nCnd,1),'rtGoCorr'}, ...
                   {cell(nCnd,1),'rtGoComm'}, ...
                   {repmat({tDiagram},nCnd,1),'tDiagram'}, ...
                   {stimOns,'stimOns'}, ...
                   {stimDur,'stimDur'});
    switch lower(SAM.sim.goal)
      case 'explore'
        prd = [prd,dataset({repmat({dynData},nCnd,1),'dyn'})];
    end
  case 'all'
    prd  = dataset({nan(nCnd,1),'pGoCorr'}, ...
                   {nan(nCnd,1),'pGoComm'}, ...
                   {nan(nCnd,1),'pGoOmit'}, ...
                   {nan(nCnd,nSsd),'pStopFailure'}, ...
                   {nan(nCnd,nSsd),'pStopSuccess'}, ...
                   {cell(nCnd,1),'inhibFunc'}, ...
                   {cell(nCnd,1),'rtGoCorr'}, ...
                   {cell(nCnd,1),'rtGoComm'}, ...
                   {cell(nCnd,nSsd),'rtStopFailure'}, ...
                   {cell(nCnd,nSsd),'rtStopSuccess'}, ...
                   {repmat({tDiagram},nCnd,1 + nSsd),'tDiagram'}, ...
                   {stimOns,'stimOns'}, ...
                   {stimDur,'stimDur'});
    switch lower(SAM.sim.goal)
      case 'explore'
        prd = [prd,dataset({repmat({dynData},nCnd,1 + nSsd),'dyn'})];
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 2. RUN JOB
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

switch lower(simGoal)
  
  % 2.1. Find optimim starting values
  % =======================================================================
  case 'startvals'
    
    switch lower(SAM.sim.rngSeedStage)
      case 'sam_run_job'
        % #.#.#. Seed the random number generator
        % -----------------------------------------------------------------
        % Note: MEX functions stay in memory until they are cleared.
        % Seeding of the random number generator should be accompanied by
        % clearing MEX functions.
        
        clear(char(trialSimFun));
        rng(rngID);
    end
    
    
    % #.#.#. Find optimal starting values
    % ---------------------------------------------------------------------
    
    [cost,X0] = sam_optim_start_vals(SAM);
    
    % #.#.#. Save starting values
    % ---------------------------------------------------------------------
    
    % File name
    fName = sprintf('x0_%strials_c%s_i%s_p%s.mat',simScope, ...
                    choiceMechType,inhibMechType,condParam);
       
    save(fullfile(outDir,fName),'cost','X0');   
    
  % 2.2. Model optimization
  % =======================================================================
  case 'optimize'
    
    switch lower(SAM.sim.rngSeedStage)
      case 'sam_run_job'
        % 2.1.1. Seed the random number generator
        % -----------------------------------------------------------------
        % Note: MEX functions stay in memory until they are cleared.
        % Seeding of the random number generator should be accompanied by
        % clearing MEX functions.
        
        clear(char(trialSimFun));
        rng(rngID);
    end
    
    [X,fVal,exitFlag,solverOutput,history] = sam_optim(SAM);
    
    % #.#.#. Save starting values
    % ---------------------------------------------------------------------
    
    varargout{1} = X;
    varargout{2} = fVal;
    varargout{3} = exitFlag;
    varargout{4} = solverOutput;
    varargout{5} = history;
    
   % 2.2. Model exploration
  % =======================================================================
  case 'explore'
    
    % 2.2.1. Seed the random number generator
    % ---------------------------------------------------------------------
    % Note: MEX functions stay in memory until they are cleared. Reseeding
    % of the random number generator should be accompanied by clearing MEX
    % functions/
    clear(char(trialSimFun));
    rng(rngID);
    
    % 2.2.2. Specify precursor and parameter-independent model matrices
    % ---------------------------------------------------------------------
                                  % OUTPUTS
    [VCor, ...                    % Precursor matrix for correct rates
     VIncor, ...                  % Precursor matrix for error rates
     S, ...                       % Precursor matrix for noise
     terminate, ...               % Termination matrix
     blockInput, ...              % Blocked input matrix
     latInhib] ...                % Lateral inhibition matrix
     = sam_spec_general_mat ...   % FUNCTION
     ...                          % INPUTS
     (SAM);                       % SAM structure
    
    % 2.2.3. Simulate an experiment
    % ---------------------------------------------------------------------
                                  % OUTPUTS
    [prd, ...                     % Model predictions
     modelMat] ...                % Model matrices
     = sam_sim_expt ...           % FUNCTION
     ...                          % INPUTS
     (simGoal, ...                % Goal of the simulation
      X, ...                      % Vector of parameters
      SAM, ...                    % SAM structure
      VCor, ...                   % Precursor matrix for correct rates
      VIncor, ...                 % Precursor matrix for error rates
      S, ...                      % Precursor matrix for noise
      terminate, ...              % Termination matrix
      blockInput, ...             % Blocked input matrix
      latInhib, ...               % Lateral inhibition matrix
      prd);                       % Dataset for logging model predictions
    
    % Model predictions
    varargout{1} = prd;
    
    % Model matrices
    varargout{2} = modelMat;
    
end