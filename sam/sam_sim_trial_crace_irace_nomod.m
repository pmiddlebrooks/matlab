function [rt,resp,z] = sam_sim_trial_crace_irace_nomod(u,A,~,C,~,Sin, ...
                                                         Z0,ZC,ZLB,dt, ...
                                                         tau,T, ...
                                                         terminate,~,~)
% SAM_SIM_TRIAL <Synopsis of what this function does> 
%  
% DESCRIPTION 
% <Describe more extensively what this function does> 
% 
%
% Let there be M inputs, N units, P time points
%
%
%
% SYNTAX 
%
% u           - MxP inputs to the accumulators
% A           - NxN endogenous connectivity matrix
% B           - NxNxM extrinsic modulation matrix
% C           - NxM exogenous connectivity matrix
% D           - NxNxN intrinsic modulation matrix
% Sin         - MxM intrinsic noise strength
% Z0          - Nx1 double of starting values
% ZC          - Nx1 double of thresholds
% ZLB         - Nx1 double of lower bounds on activation
% dt          - time step (1x1 double)
% tau         - time scale (1x1 double)
% T           - time points (1xP double)
% terminate   - Nx1 logical indicating which units can terminate 
%               accumulation after having crossed threshold
% blockInput  - MxN logical indicating which units block which inputs after
%               having crossed threshold
% latInhib    - NxN logical indicating which elements in A are set to 0 as
%               long as unit n (indexed by the columns of A) has not
%               reached threshold (indexed by resp)
%
% SAM_SIM_TRIAL; 
%  
% EXAMPLES 
% Example 1: 
% 2-Go-choice,1-Stop-choice
% Choice mechanism:     race
% Inhibition mechanism: input blocking
%
% sam_sim_demo(1);
% 
%
% Example 2: Choice process is a race, Inhibition process is a race
%
%
%
%  
% REFERENCES 
%  
% ......................................................................... 
% Bram Zandbelt, bramzandbelt@gmail.com 
% $Created : Wed 24 Jul 2013 12:14:48 CDT by bram 
% $Modified: Wed 31 Jul 2013 14:37:18 CDT by bram

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% #. PROCESS INPUTS & SPECIFY VARIABLES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% #.#. Dynamic variables
% =========================================================================
n       = size(A,1);  % Number of units
% m       = size(C,1);  % Number of inputs to units
p       = size(u,2);  % Number of time points
t       = 1;          % Time index

% #.#. Pre-allocate arrays
% =========================================================================
rt      = inf(n,1);
resp    = false(n,1);     % Indicates whether a unit has reached zc
z       = nan(n,p);
z(:,1)  = Z0;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% #. STOCHASTIC ACCUMULATION PROCESS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

while t < p - 1
  
  % Endogenous connectivity at time t (note that this is required in case
  % the inhibition mechanism is lateral inhibition
  % ---------------------------------------------------------------------
%   At = A;
  
  % Extrinsic modulation at time t
  % ---------------------------------------------------------------------
%   Bt          = zeros(m,m);
%   for i = 1:m
%     Bt        = Bt + u(i,t)*B(:,:,i);
%   end

  % Intrinsic modulation at time t
  % ---------------------------------------------------------------------
%   Dt          = zeros(n,n);
%   for j = 1:n
%     Dt        = Dt + z(j,t)*D(:,:,j);
%   end

  % Inhibition mechanism 1: block input(s), if any
  % ---------------------------------------------------------------------
%   u(any(blockInput(:,resp),2),t) = 0;
  
  % Inhibition mechanism 2: lateral inhibition
  % ---------------------------------------------------------------------
%   At(latInhib(:,~resp)) = 0;
  
  % Change in activation from time t to t + 1
  % ---------------------------------------------------------------------
%   dzdt        = (At + Bt + Dt)  * z(:,t)      * dt/tau + ...  % 
%                 C               * u(:,t)      * dt/tau + ...  % Inputs
%                 Sin             * randn(n,1)  * sqrt(dt/tau); % Noise (in)
              
  dzdt        = C               * u(:,t)      * dt/tau + ...  % Inputs
                Sin             * randn(n,1)  * sqrt(dt/tau); % Noise (in)
              
  % Log new activation level
  % ---------------------------------------------------------------------
  z(:,t+1)    = z(:,t) + dzdt;

  % Rectify activation if below zLB
  % ---------------------------------------------------------------------
  z(z(:,t+1) < ZLB,t+1) = ZLB(z(:,t+1) < ZLB);

  % Identify units that crossed threshold
  % ---------------------------------------------------------------------
  resp(z(:,t+1) > ZC) = true;
  
  % Determine time of crossing threshold
  % ---------------------------------------------------------------------
  rt(resp & isinf(rt)) = T(t + 1);
  
  % Break accumulation if termination criterion has been met
  % ---------------------------------------------------------------------
  if any(terminate(resp))
    break
  end
  
  % Update time
  % ---------------------------------------------------------------------
  t = t + 1;
  
end