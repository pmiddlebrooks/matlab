function varargout = sam_optim_start_vals(SAM)
% Optimizes starting values for optimization
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
% $Created : Sat 21 Sep 2013 12:53:48 CDT by bram
% $Modified: Sat 21 Sep 2013 19:40:18 CDT by bram

 
% CONTENTS
% 1.PROCESS INPUTS AND SPECIFY VARIABLES
% 1.1.Process inputs
% 1.2. Pre-allocate empty arrays
% 2.SPECIFY PRECURSOR AND PARAMETER-INDEPENDENT MODEL MATRICES
% 3.CHARACTERIZE OBSERVED DATA
% 3.1. Organize observations
% 3.2. Compute response time bin statistics
% 4.OPTIMIZE STARTING VALUES

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. PROCESS INPUTS AND SPECIFY VARIABLES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% 1.1. Process inputs
% =========================================================================

% Number of conditions
nCnd = SAM.des.expt.nCnd;

% Number of stop-signal delays
nSsd = SAM.des.expt.nSsd;

% Scope of the simulation
simScope = SAM.sim.scope;

% Number of simulated trials
nSim = SAM.sim.nSim;


switch lower(simScope)
  case 'go'
    
    % Number of trial types
    nTrType = 2; % Go correct, Go commission error
    
  case 'all'
    
    % Number of trial types
    nTrType = 2 + nSsd; % Go correct, Go commission error, Stop trials
    
end

% Number of starting values to sample for each parameter
% ---------------------------------------------------------------------
nX0 = SAM.startvals.nX0;

% Lower and upper bounds
% ---------------------------------------------------------------------
LB = SAM.startvals.LB;
UB = SAM.startvals.UB;

% Linear and nonlinear (in)equalities
% ---------------------------------------------------------------------
linConA = SAM.startvals.linConA;
linConB = SAM.startvals.linConB;
nonLinCon = SAM.startvals.nonLinCon;

% Cost function
costFun = SAM.startvals.costFun;

% Cumulative probabilities for which to compute quantiles
cumProb = SAM.startvals.cumProb;

% Minimum bin size (in number of trials per bin)
minBinSize = SAM.startvals.minBinSize;

% Solver type
solverType = SAM.startvals.solverType;

% 1.2. Pre-allocate empty arrays
% =========================================================================

% Structure for logging predicted trial probabilities and response times
prdOptimData = struct('P',[],...
                       'rt',[]);

% Structure for logging data for optimization
obsOptimData = struct('rt',[],...
                       'N',[],...
                       'P',[],...
                       'rtQ',[],...
                       'f',[],...
                       'pM',[]);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. CHARACTERIZE OBSERVED DATA
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load observations
dataIn = load(SAM.io.obsFile);
obs = dataIn.obs;

% 2.1. Organize observations
% =========================================================================

switch lower(simScope)
  case 'go'
    
    % Observed trial numbers
    obsOptimData.N = [obs.nGo,obs.nGo];
    
    % Observed trial probabilities
    obsOptimData.P = [obs.pGoCorr,obs.pGoComm];
    
    % Observed response times
    obsOptimData.rt = [obs.rtGoCorr,obs.rtGoComm];
    
  case 'all'
    
    % Observed trial numbers
    obsOptimData.N = [obs.nGo,obs.nGo,obs.nStop];
    
    % Observed trial probabilities
    obsOptimData.P = [obs.pGoCorr,obs.pGoComm,obs.pStopFailure];
    
    % Observed response times
    obsOptimData.rt = [obs.rtGoCorr,obs.rtGoComm,obs.rtStopFailure];
end

% 2.2. Compute response time bin statistics
% =========================================================================
[obsOptimData.rtQ, ... % Quantiles
 obsOptimData.pDefect, ... % Defective probabilities
 obsOptimData.f, ... % Frequencies
 obsOptimData.pM] ... % Probability masses
 = cellfun(@(a,b,c) sam_bin_data(a,b,c,cumProb,minBinSize), ...
 obsOptimData.rt, ... % Response times
 num2cell(obsOptimData.P), ... % Response probabilities
 num2cell(obsOptimData.N), ... % Response frequencies
 'Uni',0);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. OPTIMIZE STARTING VALUES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3.1. Sample uniformly distributed constrained starting values
% =========================================================================
X0 = sam_sample_uniform_constrained_x0(nX0,LB,UB,linConA,linConB,nonLinCon,solverType);

% 3.2. Compute cost of each starting value
% =========================================================================
cost = nan(nX0,1);
    
for i = 1:nX0

    % Print progress and time on screen
  % -----------------------------------------------------------------------
  fprintf(['Similating %d trials in %d conditions and computing cost ', ...
           'of starting value set %d out of %d (%s) \n'],nSim(1),nCnd,i, ...
           nX0,datestr(now,'dd-mmm-yyyy HH:MM:SS'));
  
  % #.#.#. Specify precursor and parameter-independent model matrices
  % -----------------------------------------------------------------------
                                % OUTPUTS
  [VCor, ... % Precursor matrix for correct rates
   VIncor, ... % Precursor matrix for error rates
   S, ... % Precursor matrix for noise
   terminate, ... % Termination matrix
   blockInput, ... % Blocked input matrix
   latInhib] ... % Lateral inhibition matrix
   = sam_spec_general_mat ... % FUNCTION
   ... % INPUTS
   (SAM); % SAM structure

  % #.#.#. Simulate an experiment and compute cost
  % ---------------------------------------------------------------------

                                % OUTPUTS
  cost(i,1) ... % Cost
  = sam_cost ... % FUNCTION
  ... % INPUTS
  (X0(i,:), ... % Starting values
  SAM, ... % SAM structure
  obsOptimData, ... % Log structure for optimization
  prdOptimData, ... % Log structure for predicted trial probabilities and response times
  VCor, ... % Precursor matrix for correct rates
  VIncor, ... % Precursor matrix for error rates
  S, ... % Precursor matrix for noise
  terminate, ... % Termination matrix
  blockInput, ... % Blocked input matrix
  latInhib); % Lateral inhibition matrix

end
    
% 3.3. Sort according to cost
% =========================================================================
costX0sorted = sortrows([cost,X0]);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. OUTPUT
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

varargout{1} = costX0sorted(:,1);
varargout{2} = costX0sorted(:,2:end);