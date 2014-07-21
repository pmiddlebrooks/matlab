function cost = sam_cost(X,SAM,obsOptimData,prdOptimData,VCor,VIncor,S,terminate,blockInput,latInhib)
% SAM_COST <Synopsis of what this function does>
%
% DESCRIPTION
% <Describe more extensively what this function does>
%
% SYNTAX
% SAM_COST;
%
% EXAMPLES
%
%
% REFERENCES
%
% .........................................................................
% Bram Zandbelt, bramzandbelt@gmail.com
% $Created : Sat 21 Sep 2013 19:43:58 CDT by bram
% $Modified: Sat 21 Sep 2013 19:47:47 CDT by bram

 
% CONTENTS
 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. SIMULATE EXPERIMENT
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prdOptimData = sam_sim_expt('optimize',X,SAM,VCor,VIncor,S,terminate,blockInput,latInhib,prdOptimData);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. COMPUTE COST
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% #.2.1. Compute probability masses
% -------------------------------------------------------------------------

nSim = SAM.sim.nSim;
% nSimCell = num2cell(nSim(:,[1 1 2:end]));
nSimCell = num2cell(nSim);
% nSimCell = num2cell(nSim(:, [1 1]));

% nSimCell = num2cell(nSim.*ones(size(prdOptimData.P)));

prdOptimData.pM = cellfun(@(a,b,c) histc(a(:),[-Inf,b,Inf])./c,prdOptimData.rt,obsOptimData.rtQ,nSimCell,'Uni',0);
prdOptimData.pM = cellfun(@(a) a(1:end-1),prdOptimData.pM,'Uni',0);
prdOptimData.pM = cellfun(@(a) a(:),prdOptimData.pM,'Uni',0);

% Identify non-empty arrays
iNonEmpty = cell2mat(cellfun(@(a) ~isempty(a),prdOptimData.pM,'Uni',0));

% Make a double vector of observed trial frequencies
fObs = cell2mat(obsOptimData.f(iNonEmpty));

% Make a double vector of all observed probability masses
pMObs = cell2mat(obsOptimData.pM(iNonEmpty));

% Make a double vector of all predicted probability masses
pMPrd = cell2mat(prdOptimData.pM(iNonEmpty));

% Add a small value to bins with a probablity mass of 0 (to prevent
% division by 0 and hampering optimization)
pMPrd(pMPrd == 0) = 0.001;

% Identify bins with observations
iAnyObs = fObs > 0;

% #.2.#. Compute the cost
% -------------------------------------------------------------------------
cost = sam_chi_square(pMObs(iAnyObs),pMPrd(iAnyObs),fObs(iAnyObs));

% sam_plot_obs_prd(SAM,obsOptimData,prdOptimData);





% % OLDER VERSION:
% 
% function cost = sam_cost(SAM,X,prd,VCor,VIncor,S,terminate,blockInput,latInhib)
% % SAM_COST <Synopsis of what this function does> 
% %  
% % DESCRIPTION 
% % <Describe more extensively what this function does> 
% %  
% % SYNTAX 
% % SAM_COST; 
% %  
% % EXAMPLES 
% %  
% %  
% % REFERENCES 
% %  
% % ......................................................................... 
% % Bram Zandbelt, bramzandbelt@gmail.com 
% % $Created : Sat 21 Sep 2013 19:43:58 CDT by bram 
% % $Modified: Sat 21 Sep 2013 19:47:47 CDT by bram
% 
%  
% % CONTENTS 
%  
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
%  
% 
% SAM.sim.goal                          = 'explore';
% 
% % #.#. Scope of simulation
% % =========================================================================
% % This specifies what data will be simulated
% % 'go'        - Simulate Go trials only
% % 'all'       - Simulate Go and Stop trials
% 
% SAM.sim.scope                         = 'all';
% 
% % #.#. Number of simulated trials
% % =========================================================================
% % The same number of trials is used for each trial type
% 
% SAM.sim.nSim                          = 100;
% 
% % #.#. Random number generator seed
% % =========================================================================
% 
% SAM.sim.rngID                         = rng('shuffle'); % MATLAB's default
% 
% 
% % #.#. Experiment simulation function
% % =========================================================================
% 
% SAM.sim.exptSimFun                    = @sam_sim_expt;
% 
% % #.#. Trial simulation function
% % =========================================================================
% 
% switch lower([SAM.spec.des.choiceMech.type,'-',SAM.spec.des.inhibMech.type])
%   case 'race-race'
% %     SAM.sim.trialSimFun = @sam_sim_trial_crace_irace_nomodbd_mex;
%     SAM.sim.trialSimFun = @sam_sim_trial_crace_irace_nomodbd;
%   case 'race-bi'
% %     SAM.sim.trialSimFun = @sam_sim_trial_crace_ibi_nomodbd_mex;
%     SAM.sim.trialSimFun = @sam_sim_trial_crace_ibi_nomodbd;
%   case 'race-li'
% %     SAM.sim.trialSimFun = @sam_sim_trial_crace_ili_nomodbd_mex;
%     SAM.sim.trialSimFun = @sam_sim_trial_crace_ili_nomodbd;
%   case 'ffi-race'
% %     SAM.sim.trialSimFun = @sam_sim_trial_cffi_irace_nomodbd_mex;
%     SAM.sim.trialSimFun = @sam_sim_trial_cffi_irace_nomodbd;
%   case 'ffi-bi'
% %     SAM.sim.trialSimFun = @sam_sim_trial_cffi_ibi_nomodbd_mex;
%     SAM.sim.trialSimFun = @sam_sim_trial_cffi_ibi_nomodbd;
%   case 'ffi-li'
% %     SAM.sim.trialSimFun = @sam_sim_trial_cffi_ili_nomodbd_mex;
%     SAM.sim.trialSimFun = @sam_sim_trial_cffi_ili_nomodbd;
%   case 'li-race'
% %     SAM.sim.trialSimFun = @sam_sim_trial_cli_irace_nomodbd_mex;
%     SAM.sim.trialSimFun = @sam_sim_trial_cli_irace_nomodbd;
%   case 'li-bi'
% %     SAM.sim.trialSimFun = @sam_sim_trial_cli_ibi_nomodbd_mex;
%     SAM.sim.trialSimFun = @sam_sim_trial_cli_ibi_nomodbd;
%   case 'li-li'
% %     SAM.sim.trialSimFun = @sam_sim_trial_cli_ili_nomodbd_mex;
%     SAM.sim.trialSimFun = @sam_sim_trial_cli_ili_nomodbd;
% end
% 
% % Specify parameter bounds, starting values, and names
% % =========================================================================
%                                     % OUTPUTS
% [LB, ...                            % Lower bounds
%  UB, ...                            % Upper bounds 
%  X0, ...                            % Starting values
%  tg] ...                            % Parameter name
%  ...
%  = sam_get_bnds(...                 % FUNCTION
%  ...                                % INPUTS
%  SAM.des.choiceMech.type, ...       % Choice mechanism
%  SAM.des.inhibMech.type, ...        % Inhibition mechanism
%  SAM.des.condParam, ...             % Parameter varying across conditios
%  SAM.sim.scope);  
% 
% 
% 
% % 1.1. Process inputs
% % ========================================================================= 
% 
% 
% 
% % Scope of simulation
% simScope              = SAM.sim.scope;
% 
% 
% % Number of simulated trials
% nSim                  = SAM.sim.nSim;
% 
% % 
% % ------------------------------------------------------------------------- 
% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% % #. SIMULATE EXPERIMENT
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% prdOptimData = sam_sim_expt(simGoal,X,SAM,VCor,VIncor,S,terminate,blockInput,latInhib,prdOptimData);
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% % #. COMPUTE COST
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% % #.1. Organize predictions: trial numbers, probabilities, response times
% % =========================================================================
% 
% % #.1.1. Go trials
% % -------------------------------------------------------------------------
% prd.fit.P       = [prd.pGoCorr,prd.pGoComm];
% prd.fit.rt      = [prd.rtGoCorr,prd.rtGoComm];
% 
% % #.1.2. Stop trials
% % -------------------------------------------------------------------------
% switch lower(optimScope)
%   case 'all'
%     prd.fit.P   = [prd.fit.P,prd.pStopFailure];
%     prd.fit.rt  = [prd.fit.rt,prd.rtStopFailure];
% end
% 
% % #.1.3. All trials
% % -------------------------------------------------------------------------
% 
% % Number of simulated trials, per condition (rows) and trial type (columns)
% nSimCell        = num2cell(nSim*ones(N_CND,nTrType + 1));
% 
% % #.2. Compute cost
% % =========================================================================
% 
% % #.2.1. Compute probability masses
% % -------------------------------------------------------------------------
% prd.fit.pM  = cellfun(@(a,b,c) histc(a(:),[-Inf,b,Inf])./c,prd.fit.rt,obs.fit.rtQ,nSimCell,'Uni',0);
% prd.fit.pM  = cellfun(@(a) a(1:end-1),prd.fit.pM,'Uni',0);
% prd.fit.pM  = cellfun(@(a) a(:),prd.fit.pM,'Uni',0);
% 
% % Identify non-empty arrays
% iNonEmpty   = cell2mat(cellfun(@(a) ~isempty(a),prd.fit.pM,'Uni',0));
% 
% % Make a double vector of observed trial frequencies
% fObs        = cell2mat(obs.fit.f(iNonEmpty));
% 
% % Make a double vector of all observed probability masses
% pMObs       = cell2mat(obs.fit.pM(iNonEmpty));
% 
% % Make a double vector of all predicted probability masses
% pMPrd       = cell2mat(prd.fit.pM(iNonEmpty));
% 
% % Identify non-zero predicted probabilities masses
% iNonZero    = pMPrd ~= 0;
% 
% % #.2.#. Compute the cost
% % -------------------------------------------------------------------------
% cost        = sam_chi_square(pMObs(iNonZero),pMPrd(iNonZero),fObs(iNonZero));
