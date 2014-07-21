function [LB,UB,X0,tg,linconA,linconB,nonlincon] = sam_get_bnds_pgm(varargin)
% Returns parameter bounds, starting values, and names for given model
%
% DESCRIPTION
% Returns parameter lower and upper bounds, starting values, and names,
% based on the specified choice mechanism, inhibition mechanism, condition
% parameter, and scope of simulation.
%
%
% SYNTAX
% SAM_GET_BNDS;
% choiceMechType  - choice mechanism (char array)
%                   * 'race', race
%                   * 'ffi', feed-forward inhibition
%                   * 'li', lateral inhibition
% inhibMechType   - inhibition mechanism (char array)
%                   * 'race', race
%                   * 'bi', blocked-input
%                   * 'li', lateral inhibition
% condParam       - condition parameter (char array)
%                   * 't0', non-decision time
%                   * 'v', accumulation rate of target
%                   * 'zc', threshold
% simScope        - scope of simulation (char array)
%                   * 'go', only go trials
%                   * 'all', go and stopp trials
%
% LB              - lower bounds of parameters
% UB              - upper bounds of parameters
% X0              - starting values of parameters
% tg              - parameter names
% linconA         - term A in the linear inequality A*X <= B
% linconB         - term B in the linear inequality A*X <= B
% nonlincon       - function accepting X and returning the nonlinear
% inequalities and equalities
%
% EXAMPLE
% [LB,UB,X0,tg,linconA,linconB,nonlincon] = sam_get_bnds('race','race','t0','optimize','all');
%
% .........................................................................
% Bram Zandbelt, bramzandbelt@gmail.com
% $Created : Thu 19 Sep 2013 09:48:27 CDT by bram
% $Modified: Sat 21 Sep 2013 12:03:08 CDT by bram

% CONTENTS
% 1.SET LB, UB, X0 VALUES
% 1.1.Starting value (z0)
% 1.1.1.GO units
% 1.1.2.STOP unit
% 1.2.Threshold (zc)
% 1.2.1.GO units
% 1.2.2.STOP unit
% 1.3.Accumulation rate correct (vCor)
% 1.3.1.GO units
% 1.3.2.STOP unit
% 1.4.Accumulation rate incorrect (vIncor)
% 1.5.Non-decision time (t0)
% 1.5.1.GO units
% 1.5.2.STOP unit
% 1.6.Extrinsic noise (se)
% 1.7.Intrinsic noise (si)
% 1.8.Leakage constant (k)
% 1.8.1.GO units
% 1.8.2.STOP unit
% 1.9.Lateral inhibition weight (w)
% 1.9.1.GO units
% 1.9.2.STOP unit
% 2. GENERATE LB, UB, AND X0 VECTORS



if nargin == 1 % Input is SAM
    
    SAM = varargin{1};
    
    % Choice mechanism
    % -------------------------------------------------------------------------
    choiceMechType = SAM.des.choiceMech.type;
    
    % Inhibition mechanism
    % -------------------------------------------------------------------------
    inhibMechType = SAM.des.inhibMech.type;
    
    % Parameter that varies across task conditions
    % -------------------------------------------------------------------------
    condParam = SAM.des.condParam;
    
    % Goal of the simulation
    % -------------------------------------------------------------------------
    simGoal = SAM.sim.goal;
    
    % Scope of the simulation
    % -------------------------------------------------------------------------
    simScope = SAM.sim.scope;
    
    % Which subject are we fitting/simulating?
    % -------------------------------------------------------------------------
    iSubj = SAM.des.iSubj;
    
    switch lower(simGoal)
        case 'optimize'
            % Type of optimization solver
            % -------------------------------------------------------------------
            solverType = SAM.optim.solverType;
        case 'startvals'
            % Type of optimization solver
            % -------------------------------------------------------------------
            solverType = SAM.startvals.solverType;
    end
    
elseif nargin > 1 % Input is something like ('race,'race','t0','optimize','all')
    
    choiceMechType = varargin{1};
    inhibMechType = varargin{2};
    condParam = varargin{3};
    simGoal = varargin{4};
    simScope = varargin{5};
    
    switch lower(simGoal)
        case 'optimize'
            solverType = varargin{6};
    end
    
    if nargin == 7
        iSubj = varargin{7};
    else
        iSubj = SAM.des.iSubj;
    end
    
end
LB          = [];
UB          = [];
linconA     = [];
linconB     = [];
nonlincon   = [];
% 1.2. Specify static variables
% =========================================================================

% How far the lower and upper bounds are set from the best-fitting
% parameter (fraction between 0 and 1)


noiseBound = true;
tBound = false;




% if ~noiseBound && ~tBound
%     
% %     switch iSubj
% %         case 'broca'
% %             boundDistGo = .3;
% %             boundDistStop = .3;
% %         case 'xena'
% %             boundDistGo = .3;
% %             boundDistStop = .3;
% %         case 'human'
% %             boundDistGo = .3;
% %             boundDistStop = .3;
% %     end
%     switch iSubj
%         case 'broca'
%             boundDistGo = 0;
%             boundDistStop = 1;
%         case 'xena'
%             boundDistGo = 0;
%             boundDistStop = 1;
%         case 'human'
%             boundDistGo = 0;
%             boundDistStop = 1;
%     end
%     
%     
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % 1. SET LB, UB, X0 VALUES
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.1. Starting value (z0)                                              ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 5.3665;
%                         case 'ffi'
%                             z0GX0     = 4.7224;
%                         case 'li'
%                             z0GX0     = .15876;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = .23316;
%                         case 'ffi'
%                             z0GX0     = 2.0336;
%                         case 'li'
%                             z0GX0     = .090541;
%                             %                             z0GX0     = 1; % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 7.9072;
%                         case 'ffi'
%                             z0GX0     = .0016322;
%                         case 'li'
%                             z0GX0     = 10.617;
%                     end
%             end
%             
%             % Go bounds
%             z0Gtg     = 'z0G';
%             z0GLB = (1-boundDistGo)*z0GX0;
%             z0GUB = (1+boundDistGo)*z0GX0;
%             % z0GLB     = 0;
%             % z0GUB     = 200;
%             
%             
%             
%             % 1.1.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 1;
%                         case 'ffi'
%                             z0SX0     = 1;
%                         case 'li'
%                             z0SX0     = 1;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 1;
%                         case 'ffi'
%                             z0SX0     = 1;
%                         case 'li'
%                             z0SX0     = 1;
%                             %                             z0SX0     = 0; % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 1;
%                         case 'ffi'
%                             z0SX0     = 1;
%                         case 'li'
%                             z0SX0     = 1;
%                     end
%             end
%             
%             
%             % Stop bounds
%             z0Stg     = 'z0S';
% %             z0SLB = (1-boundDistStop)*z0SX0;
% %             z0SUB = (1+boundDistStop)*z0SX0;
%                         z0SLB     = 0;
%                         z0SUB     = 10;
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 8.3913;
%                         case 'ffi'
%                             z0GX0     = .36805;
%                         case 'li'
%                             z0GX0     = 31.762;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 25.25;
%                         case 'ffi'
%                             z0GX0     = 12.981;
%                         case 'li'
%                             z0GX0     = 29.953;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 2.0553;
%                         case 'ffi'
%                             z0GX0     = 2.5578;
%                         case 'li'
%                             z0GX0     = 15.537;
%                     end
%             end
%             
%             % Go bounds
%             z0Gtg     = 'z0G';
%             z0GLB = (1-boundDistGo)*z0GX0;
%             z0GUB = (1+boundDistGo)*z0GX0;
%             %             z0GLB     = 0;
%             %             z0GUB     = 70;
%             
%             
%             % 1.1.2. STOP unit
%             % -------------------------------------------------------------------------
%             z0SX0     = 1;
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 1;
%                         case 'ffi'
%                             z0SX0     = 1;
%                         case 'li'
%                             z0SX0     = 1;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 1;
%                         case 'ffi'
%                             z0SX0     = 1;
%                         case 'li'
%                             z0SX0     = 1;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 1;
%                         case 'ffi'
%                             z0SX0     = 1;
%                         case 'li'
%                             z0SX0     = 1;
%                     end
%             end
%             
%             
%             % Stop bounds
%             z0Stg     = 'z0S';
% %             z0SLB = (1-boundDistStop)*z0SX0;
% %             z0SUB = (1+boundDistStop)*z0SX0;
%                         z0SLB     = 0;
%                         z0SUB     = 10;
%                         
%             
%             
%         case 'human'
%             % ############################################################
%             %                                                    HUMAN
%             % ############################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 6.9681;
%                         case 'ffi'
%                             z0GX0     = .98829;
%                         case 'li'
%                             z0GX0     = 8.3072;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 9.6823;
%                         case 'ffi'
%                             z0GX0     = .45491;
%                         case 'li'
%                             z0GX0     = 13.184;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 13.601;
%                         case 'ffi'
%                             z0GX0     = .86648;
%                         case 'li'
%                             z0GX0     = 7.1265;
%                     end
%             end
%             
%             % Go bounds
%             z0Gtg     = 'z0G';
%             z0GLB = (1-boundDistGo)*z0GX0;
%             z0GUB = (1+boundDistGo)*z0GX0;
%             %             z0GLB     = 0;
%             %             z0GUB     = 200;
%             
%             
%             
%             % 1.1.2. STOP unit
%             % -------------------------------------------------------------------------
%             z0SX0     = 1;
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 1;
%                         case 'ffi'
%                             z0SX0     = 1;
%                         case 'li'
%                             z0SX0     = 1;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 1;
%                         case 'ffi'
%                             z0SX0     = 1;
%                         case 'li'
%                             z0SX0     = 1;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 1;
%                         case 'ffi'
%                             z0SX0     = 1;
%                         case 'li'
%                             z0SX0     = 1;
%                     end
%             end
%             
%             
%             % Stop bounds
%             z0Stg     = 'z0S';
% %             z0SLB = (1-boundDistStop)*z0SX0;
% %             z0SUB = (1+boundDistStop)*z0SX0;
%                         z0SLB     = 0;
%                         z0SUB     = 10;
%             
%             
%         otherwise
%             disp('sam_get_bnds_pgm.m: the iSubj variable is wrong')
%             return
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.2. Threshold (zc)                                                   ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 33.443;
%                         case 'ffi'
%                             zcGX0     = 25.28;
%                         case 'li'
%                             zcGX0     = 19.835;
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
%                     %     zcGLB     = 0;
%                     %     zcGUB     = 400;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 56.222;
%                         case 'ffi'
%                             zcGX0     = 21.371;
%                         case 'li'
%                             zcGX0     = 32.692;
%                             %                             zcGX0     = 30;     % sim from SfN
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
%                     %     zcGLB     = 0;
%                     %     zcGUB     = 400;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0_c1  = 35.588;
%                             zcGX0_c2  = 36.679;
%                             zcGX0_c3  = 39.212;
%                             zcGX0_c4  = 38.198;
%                             zcGX0_c5  = 39.031;
%                             zcGX0_c6  = 37.875;
%                         case 'ffi'
%                             zcGX0_c1  = 27.793;
%                             zcGX0_c2  = 29.707;
%                             zcGX0_c3  = 29.698;
%                             zcGX0_c4  = 27.823;
%                             zcGX0_c5  = 29.626;
%                             zcGX0_c6  = 29.622;
%                         case 'li'
%                             zcGX0_c1  = 19.512;
%                             zcGX0_c2  = 22.03;
%                             zcGX0_c3  = 24.075;
%                             zcGX0_c4  = 23.468;
%                             zcGX0_c5  = 25.549;
%                             zcGX0_c6  = 23.087;
%                     end
%                     zcGtg_c1   = 'zcG_c1';
%                     zcGtg_c2   = 'zcG_c2';
%                     zcGtg_c3   = 'zcG_c3';
%                     zcGtg_c4   = 'zcG_c4';
%                     zcGtg_c5   = 'zcG_c5';
%                     zcGtg_c6   = 'zcG_c6';
%                     
%                     zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
%                     zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
%             end % switch lower(condParam)
%             
%             % 1.2.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                             %                             zcSX0     = 15;   % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%             end
%             
%             
%             zcStg     = 'zcS';
% %             zcSLB = (1-boundDistStop)*zcSX0;
% %             zcSUB = (1+boundDistStop)*zcSX0;
%                         zcSLB     = 0;
%                         zcSUB     = 35;
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 55.632;
%                         case 'ffi'
%                             zcGX0     = 37.66;
%                         case 'li'
%                             zcGX0     = 50.15;
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
%                     %                     zcGLB     = 0;
%                     %                     zcGUB     = 200;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 73.757;
%                         case 'ffi'
%                             zcGX0     = 38.994;
%                         case 'li'
%                             zcGX0     = 53.515;
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
%                     %                     zcGLB     = 0;
%                     %                     zcGUB     = 200;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0_c1  = 30.073;
%                             zcGX0_c2  = 31.284;
%                             zcGX0_c3  = 31.645;
%                             zcGX0_c4  = 28.939;
%                             zcGX0_c5  = 27.53;
%                             zcGX0_c6  = 26.473;
%                         case 'ffi'
%                             zcGX0_c1  = 23.264;
%                             zcGX0_c2  = 24.314;
%                             zcGX0_c3  = 27.772;
%                             zcGX0_c4  = 22.977;
%                             zcGX0_c5  = 20.607;
%                             zcGX0_c6  = 21.541;
%                         case 'li'
%                             zcGX0_c1  = 28.115;
%                             zcGX0_c2  = 34.245;
%                             zcGX0_c3  = 32.636;
%                             zcGX0_c4  = 28.016;
%                             zcGX0_c5  = 26.724;
%                             zcGX0_c6  = 29.077;
%                     end
%                     zcGtg_c1   = 'zcG_c1';
%                     zcGtg_c2   = 'zcG_c2';
%                     zcGtg_c3   = 'zcG_c3';
%                     zcGtg_c4   = 'zcG_c4';
%                     zcGtg_c5   = 'zcG_c5';
%                     zcGtg_c6   = 'zcG_c6';
%                     
%                     zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
%                     zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
%                     %                     zcGLB     = 0;
%                     %                     zcGUB     = 400;
%                     %                     zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
%                     %                     zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
%             end % switch lower(condParam)
%             
%             % 1.2.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                             %                             zcSX0     = 15;   % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%             end
%             
%             
%             zcStg     = 'zcS';
% %             zcSLB = (1-boundDistStop)*zcSX0;
% %             zcSUB = (1+boundDistStop)*zcSX0;
%                         zcSLB     = 0;
%                         zcSUB     = 35;
%             
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 75.1;
%                         case 'ffi'
%                             zcGX0     = 47.924;
%                         case 'li'
%                             zcGX0     = 62.784;
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
%                     %                     zcGLB     = 0;
%                     %                     zcGUB     = 400;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 68.424;
%                         case 'ffi'
%                             zcGX0     = 45.219;
%                         case 'li'
%                             zcGX0     = 64.479;
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
%                     %                     zcGLB     = 0;
%                     %                     zcGUB     = 400;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0_c1  = 109.33;
%                             zcGX0_c2  = 110.54;
%                             zcGX0_c3  = 115.76;
%                             zcGX0_c4  = 115.22;
%                             zcGX0_c5  = 109.13;
%                             zcGX0_c6  = 106.52;
%                         case 'ffi'
%                             zcGX0_c1  = 44.949;
%                             zcGX0_c2  = 45.085;
%                             zcGX0_c3  = 49.793;
%                             zcGX0_c4  = 50.103;
%                             zcGX0_c5  = 47.623;
%                             zcGX0_c6  = 44.862;
%                         case 'li'
%                             zcGX0_c1  = 80.158;
%                             zcGX0_c2  = 84.677;
%                             zcGX0_c3  = 81.945;
%                             zcGX0_c4  = 79.257;
%                             zcGX0_c5  = 82.311;
%                             zcGX0_c6  = 80.36;
%                     end
%                     zcGtg_c1   = 'zcG_c1';
%                     zcGtg_c2   = 'zcG_c2';
%                     zcGtg_c3   = 'zcG_c3';
%                     zcGtg_c4   = 'zcG_c4';
%                     zcGtg_c5   = 'zcG_c5';
%                     zcGtg_c6   = 'zcG_c6';
%                     
%                     zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
%                     zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
%                     %                     zcGLB     = 0;
%                     %                     zcGUB     = 400;
%                     %                     zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
%                     %                     zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
%             end % switch lower(condParam)
%             
%             % 1.2.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                             %                             zcSX0     = 15;   % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%             end
%             
%             
%             zcStg     = 'zcS';
% %             zcSLB = (1-boundDistStop)*zcSX0;
% %             zcSUB = (1+boundDistStop)*zcSX0;
%                         zcSLB     = 0;
%                         zcSUB     = 35;
%            
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.3. Accumulation rate correct (vCor)                                 ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.3.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .15509;
%                         case 'ffi'
%                             vCGX0     = .18419;
%                         case 'li'
%                             vCGX0     = .18333;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
%                     %     vCGLB     = 0;
%                     %     vCGUB     = 10;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0_c1  = .36897;  % go trials fit value
%                             vCGX0_c2  = .29287;  % go trials fit value
%                             vCGX0_c3  = .16563;  % go trials fit value
%                             vCGX0_c4  = .1426;  % go trials fit value
%                             vCGX0_c5  = .29812;  % go trials fit value
%                             vCGX0_c6  = .38163;  % go trials fit value
%                             
%                         case 'ffi'
%                             vCGX0_c1  = .28951;  % go trials fit value
%                             vCGX0_c2  = .11176;  % go trials fit value
%                             vCGX0_c3  = .081531;  % go trials fit value
%                             vCGX0_c4  = .18455;  % go trials fit value
%                             vCGX0_c5  = .31028;  % go trials fit value
%                             vCGX0_c6  = .19652;  % go trials fit value
%                             
%                         case 'li'
%                             vCGX0_c1  = .3885;
%                             vCGX0_c2  = .30201;
%                             vCGX0_c3  = .23602;
%                             vCGX0_c4  = .22196;
%                             vCGX0_c5  = .27871;
%                             vCGX0_c6  = .38785;
%                             
%                             %                             vCGX0_c1  = .22;  % sim from SfN
%                             %                             vCGX0_c2  = .21;
%                             %                             vCGX0_c3  = .19;
%                             %                             vCGX0_c4  = .15;
%                             %                             vCGX0_c5  = .16;
%                             %                             vCGX0_c6  = .17;
%                             
%                             
%                     end
%                     vCGtg_c1  = 'vCG_c1';
%                     vCGtg_c2  = 'vCG_c2';
%                     vCGtg_c3  = 'vCG_c3';
%                     vCGtg_c4  = 'vCG_c4';
%                     vCGtg_c5  = 'vCG_c5';
%                     vCGtg_c6  = 'vCG_c6';
%                     vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                     vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                     %     vCGLB     = 0;
%                     %     vCGUB     = 10;
%                     
%                     
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .17867;
%                         case 'ffi'
%                             vCGX0     = .10473;
%                         case 'li'
%                             vCGX0     = .20587;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
%                     %     vCGLB     = 0;
%                     %     vCGUB     = 10;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.3.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                             %                             vCSX0     = 1.5;  % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%             end
%             vCStg     = 'vCS';
% %             vCSLB = (1-boundDistStop)*vCSX0;
% %             vCSUB = (1+boundDistStop)*vCSX0;
%                         vCSLB     = 0;
%                         vCSUB     = 2;
%             
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.3.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .2737;
%                         case 'ffi'
%                             vCGX0     = .19812;
%                         case 'li'
%                             vCGX0     = .30126;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
%                     %                     vCGLB     = 0;
%                     %                     vCGUB     = 2;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0_c1  = .33086;
%                             vCGX0_c2  = .2796;
%                             vCGX0_c3  = .25557;
%                             vCGX0_c4  = .19565;
%                             vCGX0_c5  = .33915;
%                             vCGX0_c6  = .44455;
%                             
%                         case 'ffi'
%                             vCGX0_c1  = .43113;
%                             vCGX0_c2  = .46421;
%                             vCGX0_c3  = .35717;
%                             vCGX0_c4  = .50387;
%                             vCGX0_c5  = .49834;
%                             vCGX0_c6  = .50534;
%                             
%                         case 'li'
%                             vCGX0_c1  = .45744;
%                             vCGX0_c2  = .44585;
%                             vCGX0_c3  = .3281;
%                             vCGX0_c4  = .39444;
%                             vCGX0_c5  = .49759;
%                             vCGX0_c6  = .6011;
%                             
%                     end
%                     vCGtg_c1  = 'vCG_c1';
%                     vCGtg_c2  = 'vCG_c2';
%                     vCGtg_c3  = 'vCG_c3';
%                     vCGtg_c4  = 'vCG_c4';
%                     vCGtg_c5  = 'vCG_c5';
%                     vCGtg_c6  = 'vCG_c6';
%                     vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                     vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                     %                     vCGLB     = 0;
%                     %                     vCGUB     = 2;
%                     %                     vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
%                     %                     vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
%                     
%                     
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .15714;
%                         case 'ffi'
%                             vCGX0     = .19356;
%                         case 'li'
%                             vCGX0     = .28617;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
%                     %                     vCGLB     = 0;
%                     %                     vCGUB     = 2;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.3.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                             %                             vCSX0     = 1.5;  % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%             end
%             vCStg     = 'vCS';
% %             vCSLB = (1-boundDistStop)*vCSX0;
% %             vCSUB = (1+boundDistStop)*vCSX0;
%                         vCSLB     = 0;
%                         vCSUB     = 2;
%             
%             
%             
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             % 1.3.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .12417;
%                         case 'ffi'
%                             vCGX0     = .083469;
%                         case 'li'
%                             vCGX0     = .12882;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
%                     %                     vCGLB     = 0;
%                     %                     vCGUB     = 4;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0_c1  = .13349;
%                             vCGX0_c2  = .12298;
%                             vCGX0_c3  = .1052;
%                             vCGX0_c4  = .10846;
%                             vCGX0_c5  = .12605;
%                             vCGX0_c6  = .13532;
%                             
%                         case 'ffi'
%                             vCGX0_c1  = .1244;
%                             vCGX0_c2  = .10135;
%                             vCGX0_c3  = .16559;
%                             vCGX0_c4  = .13008;
%                             vCGX0_c5  = .11269;
%                             vCGX0_c6  = .12181;
%                             
%                         case 'li'
%                             vCGX0_c1  = .15384;
%                             vCGX0_c2  = .14429;
%                             vCGX0_c3  = .12717;
%                             vCGX0_c4  = .12684;
%                             vCGX0_c5  = .14449;
%                             vCGX0_c6  = .1587;
%                             
%                             
%                     end
%                     vCGtg_c1  = 'vCG_c1';
%                     vCGtg_c2  = 'vCG_c2';
%                     vCGtg_c3  = 'vCG_c3';
%                     vCGtg_c4  = 'vCG_c4';
%                     vCGtg_c5  = 'vCG_c5';
%                     vCGtg_c6  = 'vCG_c6';
%                     
%                     vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                     vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                     %                                         vCGLB     = 0;
%                     %                                         vCGUB     = 4;
%                     %                                         vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
%                     %                                         vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
%                     %
%                     
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .14978;
%                         case 'ffi'
%                             vCGX0     = .10861;
%                         case 'li'
%                             vCGX0     = .20219;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
%                     %                     vCGLB     = 0;
%                     %                     vCGUB     = 2;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.3.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%             end
%             vCStg     = 'vCS';
% %             vCSLB = (1-boundDistStop)*vCSX0;
% %             vCSUB = (1+boundDistStop)*vCSX0;
%                         vCSLB     = 0;
%                         vCSUB     = 2;
%             
%             
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.4. Accumulation rate incorrect (vIncor)                             ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.4.1.  units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .0056554;
%                         case 'ffi'
%                             vIGX0     = .097697;
%                         case 'li'
%                             vIGX0     = .02687;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
%                     %             vIGLB     = 0;
%                     %             vIGUB     = 10;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0_c1  = .037023;  % go trials fit value
%                             vIGX0_c2  = .052158;  % go trials fit value
%                             vIGX0_c3  = .1573;  % go trials fit value
%                             vIGX0_c4  = .117;  % go trials fit value
%                             vIGX0_c5  = .034845;  % go trials fit value
%                             vIGX0_c6  = .0021946;  % go trials fit value
%                             
%                         case 'ffi'
%                             vIGX0_c1  = .13689;  % go trials fit value
%                             vIGX0_c2  = .013546;  % go trials fit value
%                             vIGX0_c3  = .071602;  % go trials fit value
%                             vIGX0_c4  = .16905;  % go trials fit value
%                             vIGX0_c5  = .2248;  % go trials fit value
%                             vIGX0_c6  = .037268;  % go trials fit value
%                             
%                         case 'li'
%                             vIGX0_c1  = 0.082717;
%                             vIGX0_c2  = 0.033183;
%                             vIGX0_c3  = 0.13215;
%                             vIGX0_c4  = 0.14713;
%                             vIGX0_c5  = 0.014546;
%                             vIGX0_c6  = 0.02178;
%                             
%                             %                             vIGX0_c1  = 0.008;  % sim from SfN
%                             %                             vIGX0_c2  = 0.008;
%                             %                             vIGX0_c3  = 0.008;
%                             %                             vIGX0_c4  = 0.008;
%                             %                             vIGX0_c5  = 0.008;
%                             %                             vIGX0_c6  = 0.008;
%                             
%                     end
%                     
%                     vIGtg_c1  = 'vIG_c1';
%                     vIGtg_c2  = 'vIG_c2';
%                     vIGtg_c3  = 'vIG_c3';
%                     vIGtg_c4  = 'vIG_c4';
%                     vIGtg_c5  = 'vIG_c5';
%                     vIGtg_c6  = 'vIG_c6';
%                     vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                     vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                     %     vIGLB     = 0;
%                     %     vIGUB     = 10;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .055527;
%                         case 'ffi'
%                             vIGX0     = .0055808;
%                         case 'li'
%                             vIGX0     = .0056551;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
%                     %             vIGLB     = 0;
%                     %             vIGUB     = 10;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.4.1.  units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .11556;
%                         case 'ffi'
%                             vIGX0     = .088415;
%                         case 'li'
%                             vIGX0     = .1113;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
%                     %                     vIGLB     = 0;
%                     %                     vIGUB     = 2;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0_c1  = .057653;
%                             vIGX0_c2  = .055706;
%                             vIGX0_c3  = .065227;
%                             vIGX0_c4  = .19802;
%                             vIGX0_c5  = .14971;
%                             vIGX0_c6  = .070878;
%                             
%                         case 'ffi'
%                             vIGX0_c1  = .23069;
%                             vIGX0_c2  = .31145;
%                             vIGX0_c3  = .27321;
%                             vIGX0_c4  = .52254;
%                             vIGX0_c5  = .34665;
%                             vIGX0_c6  = .20517;
%                             
%                         case 'li'
%                             vIGX0_c1  = .10729;
%                             vIGX0_c2  = .12722;
%                             vIGX0_c3  = .14208;
%                             vIGX0_c4  = .44577;
%                             vIGX0_c5  = .19749;
%                             vIGX0_c6  = .010149;
%                     end
%                     
%                     vIGtg_c1  = 'vIG_c1';
%                     vIGtg_c2  = 'vIG_c2';
%                     vIGtg_c3  = 'vIG_c3';
%                     vIGtg_c4  = 'vIG_c4';
%                     vIGtg_c5  = 'vIG_c5';
%                     vIGtg_c6  = 'vIG_c6';
%                     
%                     vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                     vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                     %                     vIGLB     = 0;
%                     %                     vIGUB     = 2;
%                     %                     vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
%                     %                     vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .039033;
%                         case 'ffi'
%                             vIGX0     = .11288;
%                         case 'li'
%                             vIGX0     = .10306;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
%                     %                     vIGLB     = 0;
%                     %                     vIGUB     = 2;
%             end % switch lower(condParam)
%             
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             % 1.4.1.  units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .060783;
%                         case 'ffi'
%                             vIGX0     = .0087358;
%                         case 'li'
%                             vIGX0     = .044513;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
%                     %                     vIGLB     = 0;
%                     %                     vIGUB     = 3;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0_c1  = .030384;
%                             vIGX0_c2  = .045945;
%                             vIGX0_c3  = .059214;
%                             vIGX0_c4  = .061498;
%                             vIGX0_c5  = .031818;
%                             vIGX0_c6  = .036;
%                             
%                         case 'ffi'
%                             vIGX0_c1  = .0056732;
%                             vIGX0_c2  = .015372;
%                             vIGX0_c3  = .1218;
%                             vIGX0_c4  = .073167;
%                             vIGX0_c5  = .011283;
%                             vIGX0_c6  = .000004;
%                             
%                         case 'li'
%                             vIGX0_c1  = .0069956;
%                             vIGX0_c2  = .045451;
%                             vIGX0_c3  = .073632;
%                             vIGX0_c4  = .067091;
%                             vIGX0_c5  = .024963;
%                             vIGX0_c6  = .018678;
%                             
%                     end
%                     
%                     vIGtg_c1  = 'vIG_c1';
%                     vIGtg_c2  = 'vIG_c2';
%                     vIGtg_c3  = 'vIG_c3';
%                     vIGtg_c4  = 'vIG_c4';
%                     vIGtg_c5  = 'vIG_c5';
%                     vIGtg_c6  = 'vIG_c6';
%                     vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                     vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                     %                     vIGLB     = 0;
%                     %                     vIGUB     = .11;
%                     %                     vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
%                     %                     vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .078509;
%                         case 'ffi'
%                             vIGX0     = .066098;
%                         case 'li'
%                             vIGX0     = .05;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
%                     %                                 vIGLB     = 0;
%                     %                                 vIGUB     = .2;
%             end % switch lower(condParam)
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.5. Non-decision time (t0)                                           ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.5.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0_c1  = 113.5;
%                             t0GX0_c2  = 113.15;
%                             t0GX0_c3  = 128.04;
%                             t0GX0_c4  = 118.54;
%                             t0GX0_c5  = 133.97;
%                             t0GX0_c6  = 134.22;
%                             
%                         case 'ffi'
%                             t0GX0_c1  = 142.33;
%                             t0GX0_c2  = 136.56;
%                             t0GX0_c3  = 146.37;
%                             t0GX0_c4  = 147.98;
%                             t0GX0_c5  = 155.36;
%                             t0GX0_c6  = 157.15;
%                             
%                         case 'li'
%                             t0GX0_c1  = 135.51;
%                             t0GX0_c2  = 127.2;
%                             t0GX0_c3  = 144.52;
%                             t0GX0_c4  = 144.23;
%                             t0GX0_c5  = 147.78;
%                             t0GX0_c6  = 152.56;
%                     end
%                     
%                     t0Gtg_c1  = 't0G_c1';
%                     t0Gtg_c2  = 't0G_c2';
%                     t0Gtg_c3  = 't0G_c3';
%                     t0Gtg_c4  = 't0G_c4';
%                     t0Gtg_c5  = 't0G_c5';
%                     t0Gtg_c6  = 't0G_c6';
%                     t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
%                     t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
%                     %             t0GLB     = 0;
%                     %             t0GUB     = 300;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 98.355; %
%                         case 'ffi'
%                             t0GX0     = 137.26;
%                         case 'li'
%                             t0GX0     = 127.83;
%                             %                             t0GX0     = 62;     % sim from SfN
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
%                     %     t0GLB     = 0;
%                     %     t0GUB     = 300;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 129.74;
%                         case 'ffi'
%                             t0GX0     = 134.67;
%                         case 'li'
%                             t0GX0     = 109.13;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
%                     %     t0GLB     = 0;
%                     %     t0GUB     = 300;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.5.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%             end
%             
%             t0Stg     = 't0S';
% %             t0SLB = (1-boundDistStop)*t0SX0;
% %             t0SUB = (1+boundDistStop)*t0SX0;
%                         t0SLB     = 20;
%                         t0SUB     = 70;
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.5.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0_c1  = 133.72;
%                             t0GX0_c2  = 142.62;
%                             t0GX0_c3  = 151.35;
%                             t0GX0_c4  = 144.43;
%                             t0GX0_c5  = 131.62;
%                             t0GX0_c6  = 131.65;
%                             
%                         case 'ffi'
%                             t0GX0_c1  = 174.09;
%                             t0GX0_c2  = 131.59;
%                             t0GX0_c3  = 147.14;
%                             t0GX0_c4  = 148.48;
%                             t0GX0_c5  = 161.64;
%                             t0GX0_c6  = 167.25;
%                             
%                         case 'li'
%                             t0GX0_c1  = 155.43;
%                             t0GX0_c2  = 164.35;
%                             t0GX0_c3  = 143;
%                             t0GX0_c4  = 159;
%                             t0GX0_c5  = 152.98;
%                             t0GX0_c6  = 158.83;
%                     end
%                     
%                     t0Gtg_c1  = 't0G_c1';
%                     t0Gtg_c2  = 't0G_c2';
%                     t0Gtg_c3  = 't0G_c3';
%                     t0Gtg_c4  = 't0G_c4';
%                     t0Gtg_c5  = 't0G_c5';
%                     t0Gtg_c6  = 't0G_c6';
%                     
%                     t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
%                     t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
%                     %                     t0GLB     = 20;
%                     %                     t0GUB     = 180;
%                     %                     t0GLB = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
%                     %                     t0GUB = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 158.36;
%                         case 'ffi'
%                             t0GX0     = 185.54;
%                         case 'li'
%                             t0GX0     = 152.58;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
%                     %                     t0GLB     = 20;
%                     %                     t0GUB     = 180;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 163.89;
%                         case 'ffi'
%                             t0GX0     = 178.28;
%                         case 'li'
%                             t0GX0     = 175.85;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
% %                                         t0GLB     = 20;
% %                                         t0GUB     = 100;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.5.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%             end
%             
%             t0Stg     = 't0S';
% %             t0SLB = (1-boundDistStop)*t0SX0;
% %             t0SUB = (1+boundDistStop)*t0SX0;
%                         t0SLB     = 20;
%                         t0SUB     = 70;
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             % 1.5.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0_c1  = 103.39;
%                             t0GX0_c2  = 114.37;
%                             t0GX0_c3  = 124.33;
%                             t0GX0_c4  = 140.42;
%                             t0GX0_c5  = 110.2;
%                             t0GX0_c6  = 94.536;
%                             
%                         case 'ffi'
%                             t0GX0_c1  = 271;
%                             t0GX0_c2  = 254.85;
%                             t0GX0_c3  = 196.29;
%                             t0GX0_c4  = 223.41;
%                             t0GX0_c5  = 258.33;
%                             t0GX0_c6  = 252.82;
%                             
%                         case 'li'
%                             t0GX0_c1  = 119.67;
%                             t0GX0_c2  = 117.07;
%                             t0GX0_c3  = 125.18;
%                             t0GX0_c4  = 132.64;
%                             t0GX0_c5  = 124.98;
%                             t0GX0_c6  = 113.02;
%                     end
%                     
%                     t0Gtg_c1  = 't0G_c1';
%                     t0Gtg_c2  = 't0G_c2';
%                     t0Gtg_c3  = 't0G_c3';
%                     t0Gtg_c4  = 't0G_c4';
%                     t0Gtg_c5  = 't0G_c5';
%                     t0Gtg_c6  = 't0G_c6';
%                     t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
%                     t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
%                     %                     t0GLB     = 20;
%                     %                     t0GUB     = 500;
%                     %                     t0GLB = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
%                     %                     t0GUB = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 181.19;
%                         case 'ffi'
%                             t0GX0     = 325.47;
%                         case 'li'
%                             t0GX0     = 158.05;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
%                     %                     t0GLB     = 0;
%                     %                     t0GUB     = 500;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 8.6895;
%                         case 'ffi'
%                             t0GX0     = 335.81;
%                         case 'li'
%                             t0GX0     = 195.45;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
% %                                         t0GLB     = 0;
% %                                         t0GUB     = 500;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.5.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%             end
%             
%             t0Stg     = 't0S';
% %             t0SLB = (1-boundDistStop)*t0SX0;
% %             t0SUB = (1+boundDistStop)*t0SX0;
%                         t0SLB     = 20;
%                         t0SUB     = 200;
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.6. Extrinsic noise (se)                                             ===================
%     % ============================================================================================
%     seLB      = 0;
%     seUB      = 0;
%     seX0      = 0;
%     setg      = 'se';
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.7. Intrinsic noise (si)                                             ===================
%     % ============================================================================================
%     switch iSubj
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.9005; 
%                         case 'ffi'
%                             siX0      = 2.0785;
%                         case 'li'
%                             siX0      = 1.7392;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 2.4994; 
%                         case 'ffi'
%                             siX0      = 1.6078;
%                         case 'li'
%                             siX0      = 2.1283;
%                             %                             siX0      = 1.2; % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.9283;
%                         case 'ffi'
%                             siX0      = 2.3069;
%                         case 'li'
%                             siX0      = 2.0518;
%                     end
%             end
%             sitg      = 'si';
%                         siLB = siX0;
%                         siUB = siX0;
% %             siLB      = .2;
% %             siUB      = 2.5;
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 2.0856;
%                         case 'ffi'
%                             siX0      = 2.4996;
%                         case 'li'
%                             siX0      = 2.1793;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 2.491;
%                         case 'ffi'
%                             siX0      = 2.3544;
%                         case 'li'
%                             siX0      = 2.4102;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.5988;
%                         case 'ffi'
%                             siX0      = 1.7259;
%                         case 'li'
%                             siX0      = 1.8828;
%                     end
%             end
%             sitg      = 'si';
%                         siLB = siX0;
%                         siUB = siX0;
% %             siLB      = .2;
% %             siUB      = 2.5;
%             
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.0001;
%                         case 'ffi'
%                             siX0      = 1.563;
%                         case 'li'
%                             siX0      = .93764;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.0461;
%                         case 'ffi'
%                             siX0      = 1.755;
%                         case 'li'
%                             siX0      = 1.0039;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.048;
%                         case 'ffi'
%                             siX0      = 1.991;
%                         case 'li'
%                             siX0      = 1.5153;
%                     end
%             end
%             sitg      = 'si';
%                         siLB = siX0;
%                         siUB = siX0;
% %             siLB      = .2;
% %             siUB      = 2.5;
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.8. Leakage constant (k)                                             ===================
%     % ============================================================================================
%     
%     % 1.8.1. GO units
%     % -------------------------------------------------------------------------
%     kGX0 = -realmin;
%     kGtg = 'kG';
%     kGLB = -realmin;
%     kGUB = -realmin; % Note: this should not be 0 to satisfy non-linear constraints
%     
%     % 1.8.2. STOP unit
%     % -------------------------------------------------------------------------
%     kSX0 = -realmin;
%     kStg = 'kS';
%     kSLB = -realmin;
%     kSUB = -realmin; % Note: this should not be 0 to satisfy non-linear constraints
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.9. Lateral inhibition weight (w)                                    ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.9.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(choiceMechType)
%                 case 'li'
%                     switch lower(condParam)
%                         case 't0'
%                             wGX0      = -3.3013;
%                         case 'v'
%                             wGX0      = -1.747;
%                             %                     wGX0      = -.005; % from SfN simulations
%                         case 'zc'
%                             wGX0      = -1.4538;
%                     end
%                     wGUB = (1-boundDistGo)*wGX0;
%                     wGLB = (1+boundDistGo)*wGX0;
%                     %       wGLB      = -5;
%                     %       wGUB      = 0;
%                 case {'race','ffi'}
%                     wGX0      = 0;
%                     wGLB      = 0;
%                     wGUB      = 0;
%             end
%             wGtg      = 'wG';
%             
%             
%             % 1.9.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -1.5553;
%                         case 'ffi'
%                             wSX0      = -.50919;
%                         case 'li'
%                             wSX0      = -.90838;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -1.8923;
%                         case 'ffi'
%                             wSX0      = -1.2838;
%                         case 'li'
%                             wSX0      = -.52669;
%                             %                             wSX0      = -.8; % from SfN simulations
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.30985;
%                         case 'ffi'
%                             wSX0      = -.12857;
%                         case 'li'
%                             wSX0      = -.31559;
%                     end
%             end
%             
%             wStg      = 'wS';
% %             wSLB = (1+boundDistStop)*wSX0;
% %             wSUB = (1-boundDistStop)*wSX0;
%                         wSLB      = -4;
%                         wSUB      = 0;
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.9.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(choiceMechType)
%                 case 'li'
%                     switch lower(condParam)
%                         case 't0'
%                             wGX0      = -.80432;
%                         case 'v'
%                             wGX0      = -2.6439;
%                         case 'zc'
%                             wGX0      = -.51972;
%                     end
%                     wGUB = (1-boundDistGo)*wGX0;
%                     wGLB = (1+boundDistGo)*wGX0;
%                     %             wGLB      = -4;
%                     %             wGUB      = 0;
%                 case {'race','ffi'}
%                     wGX0      = 0;
%                     wGLB      = 0;
%                     wGUB      = 0;
%             end
%             wGtg      = 'wG';
%             
%             
%             % 1.9.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.39507;
%                         case 'ffi'
%                             wSX0      = -3.1456;
%                         case 'li'
%                             wSX0      = -1.479;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.31858;
%                         case 'ffi'
%                             wSX0      = -2.7771;
%                         case 'li'
%                             wSX0      = -.278722;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.34189;
%                         case 'ffi'
%                             wSX0      = -1.167;
%                         case 'li'
%                             wSX0      = -.79117;
%                     end
%             end
%             
%             wStg      = 'wS';
% %             wSLB = (1+boundDistStop)*wSX0;
% %             wSUB = (1-boundDistStop)*wSX0;
%                         wSLB      = -4;
%                         wSUB      = 0;
%             
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             % 1.9.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(choiceMechType)
%                 case 'li'
%                     switch lower(condParam)
%                         case 't0'
%                             wGX0      = -.63116;
%                         case 'v'
%                             wGX0      = -.57378;
%                         case 'zc'
%                             wGX0      = -.035811;
%                     end
%                     wGUB = (1-boundDistGo)*wGX0;
%                     wGLB = (1+boundDistGo)*wGX0;
%                     %             wGLB      = -5;
%                     %             wGUB      = 0;
%                 case {'race','ffi'}
%                     wGX0      = 0;
%                     wGLB      = 0;
%                     wGUB      = 0;
%             end
%             wGtg      = 'wG';
%             
%             
%             % 1.9.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.6073;
%                         case 'ffi'
%                             wSX0      = -3.725;
%                         case 'li'
%                             wSX0      = -2.0568;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -1.2212;
%                         case 'ffi'
%                             wSX0      = -.93407;
%                         case 'li'
%                             wSX0      = -.2184;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.46434;
%                         case 'ffi'
%                             wSX0      = -1.189;
%                         case 'li'
%                             wSX0      = -3.9082;
%                     end
%             end
%             
%             wStg      = 'wS';
% %             wSLB = (1+boundDistStop)*wSX0;
% %             wSUB = (1-boundDistStop)*wSX0;
%                         wSLB      = -4;
%                         wSUB      = 0;
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
if noiseBound && ~tBound
    
    
%     switch iSubj
%         case 'broca'
%             boundDistGo = .3;
%             boundDistStop = .3;
%         case 'xena'
%             boundDistGo = .3;
%             boundDistStop = .3;
%         case 'human'
%             boundDistGo = .3;
%             boundDistStop = .3;
%     end
    switch iSubj
        case 'broca'
            boundDistGo = .7;
            boundDistStop = .7;
        case 'xena'
            boundDistGo = 0.7;
            boundDistStop = .7;
        case 'human'
            boundDistGo = .7;
            boundDistStop = .7;
    end
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1. SET LB, UB, X0 VALUES
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    % ============================================================================================
    % 1.1. Starting value (z0)                                              ===================
    % ============================================================================================
    
    switch iSubj
        
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 24.689;
                        case 'ffi'
                            z0GX0     = 9.6684;
                        case 'li'
                            z0GX0     = 70.562;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 4.4556;
                        case 'ffi'
                            z0GX0     = 7.7704;
                        case 'li'
                            z0GX0     = 9.1215;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 15.066;
                        case 'ffi'
                            z0GX0     = 9.7177;
                        case 'li'
                            z0GX0     = 32.232;
                    end
            end
            
            % Go bounds
            z0Gtg     = 'z0G';
            z0GLB = (1-boundDistGo)*z0GX0;
            z0GUB = (1+boundDistGo)*z0GX0;
            z0GLB     = 0;
            z0GUB     = 40;

            
            
            % 1.1.2. STOP unit
            % -------------------------------------------------------------------------
            z0SX0     = 1;
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 10;
                        case 'ffi'
                            z0SX0     = 10;
                        case 'li'
                            z0SX0     = 10;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 10;
                        case 'ffi'
                            z0SX0     = 10;
                        case 'li'
                            z0SX0     = 10;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 10;
                        case 'ffi'
                            z0SX0     = 10;
                        case 'li'
                            z0SX0     = 10;
                    end
            end
            
            
            % Stop bounds
            z0Stg     = 'z0S';
            z0SLB = (1-boundDistStop)*z0SX0;
            z0SUB = (1+boundDistStop)*z0SX0;
%                         z0SLB     = 0;
%                         z0SUB     = 40;
%             
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 17.165;
                        case 'ffi'
                            z0GX0     = 15.086;
                        case 'li'
                            z0GX0     = 11.527;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 22.219;
                        case 'ffi'
                            z0GX0     = 12.024;
                        case 'li'
                            z0GX0     = 13.816;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 8.8999;
                        case 'ffi'
                            z0GX0     = 29.054;
                        case 'li'
                            z0GX0     = 17.718;
                    end
            end
            
            % Go bounds
            z0Gtg     = 'z0G';
%             z0GLB = (1-boundDistGo)*z0GX0;
%             z0GUB = (1+boundDistGo)*z0GX0;
            z0GLB     = 0;
            z0GUB     = 40;
            
            
            % 1.1.2. STOP unit
            % -------------------------------------------------------------------------
            z0SX0     = 1;
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
            end
            
            
            % Stop bounds
            z0Stg     = 'z0S';
%             z0SLB = (1-boundDistStop)*z0SX0;
%             z0SUB = (1+boundDistStop)*z0SX0;
                        z0SLB     = 0;
                        z0SUB     = 40;
            
            
        case 'human'
            % ############################################################
            %                                                    HUMAN
            % ############################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 5.8825;
                        case 'ffi'
                            z0GX0     = 1.219;
                        case 'li'
                            z0GX0     = 12.038;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 12.634;
                        case 'ffi'
                            z0GX0     = .49734;
                        case 'li'
                            z0GX0     = 14.342;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 18.975;
                        case 'ffi'
                            z0GX0     = 2.0676;
                        case 'li'
                            z0GX0     = 6.6546;
                    end
            end
            
            % Go bounds
            z0Gtg     = 'z0G';
            z0GLB = (1-boundDistGo)*z0GX0;
            z0GUB = (1+boundDistGo)*z0GX0;
%             z0GLB     = 0;
%             z0GUB     = 40;
            
            
            
            % 1.1.2. STOP unit
            % -------------------------------------------------------------------------
            z0SX0     = 1;
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 6;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
            end
            
            
            % Stop bounds
            z0Stg     = 'z0S';
            z0SLB = (1-boundDistStop)*z0SX0;
            z0SUB = (1+boundDistStop)*z0SX0;
%                         z0SLB     = 0;
%                         z0SUB     = 40;
            
            
        otherwise
            disp('sam_get_bnds_pgm.m: the iSubj variable is wrong')
            return
            
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.2. Threshold (zc)                                                   ===================
    % ============================================================================================
    
    switch iSubj
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 41.041;
                        case 'ffi'
                            zcGX0     = 18.018;
                        case 'li'
                            zcGX0     = 96.278;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
                        zcGLB     = 0;
                        zcGUB     = 250;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 27.853;
                        case 'ffi'
                            zcGX0     = 17.738;
                        case 'li'
                            zcGX0     = 56.966;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
                        zcGLB     = 0;
                        zcGUB     = 250;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcGX0_c1  = 27.148;
                            zcGX0_c2  = 27.296;
                            zcGX0_c3  = 29.355;
                            zcGX0_c4  = 31.975;
                            zcGX0_c5  = 31.953;
                            zcGX0_c6  = 31.351;
                        case 'ffi'
                            zcGX0_c1  = 16.374;
                            zcGX0_c2  = 17.342;
                            zcGX0_c3  = 17.232;
                            zcGX0_c4  = 18.898;
                            zcGX0_c5  = 21.068;
                            zcGX0_c6  = 20.416;
                        case 'li'
                            zcGX0_c1  = 191.25;
                            zcGX0_c2  = 191.87;
                            zcGX0_c3  = 188.76;
                            zcGX0_c4  = 174.93;
                            zcGX0_c5  = 206.56;
                            zcGX0_c6  = 196.19;
                    end
                    zcGtg_c1   = 'zcG_c1';
                    zcGtg_c2   = 'zcG_c2';
                    zcGtg_c3   = 'zcG_c3';
                    zcGtg_c4   = 'zcG_c4';
                    zcGtg_c5   = 'zcG_c5';
                    zcGtg_c6   = 'zcG_c6';
                    
                    zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                    zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                                        zcGLB     = 0;
                                        zcGUB     = 250;
                                        zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
                                        zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
            end % switch lower(condParam)
            
            % 1.2.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 50;
                        case 'ffi'
                            zcSX0     = 50;
                        case 'li'
                            zcSX0     = 50;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 50;
                        case 'ffi'
                            zcSX0     = 50;
                        case 'li'
                            zcSX0     = 50;
                            %                             zcSX0     = 15;   % sim from SfN
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 50;
                        case 'ffi'
                            zcSX0     = 50;
                        case 'li'
                            zcSX0     = 50;
                    end
            end
            
            
            zcStg     = 'zcS';
            zcSLB = (1-boundDistStop)*zcSX0;
            zcSUB = (1+boundDistStop)*zcSX0;
%                         zcSLB     = 0;
%                         zcSUB     = 150;
            
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 38.659;
                        case 'ffi'
                            zcGX0     = 25.702;
                        case 'li'
                            zcGX0     = 17.808;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
                        zcGLB     = 0;
                        zcGUB     = 250;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 93.172;
                        case 'ffi'
                            zcGX0     = 22.641;
                        case 'li'
                            zcGX0     = 111.39;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
                        zcGLB     = 0;
                        zcGUB     = 250;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcGX0_c1  = 28.719;
                            zcGX0_c2  = 30.875;
                            zcGX0_c3  = 30.979;
                            zcGX0_c4  = 29.224;
                            zcGX0_c5  = 28.2;
                            zcGX0_c6  = 27.146;
                        case 'ffi'
                            zcGX0_c1  = 37.665;
                            zcGX0_c2  = 39.465;
                            zcGX0_c3  = 38.452;
                            zcGX0_c4  = 37.88;
                            zcGX0_c5  = 37.542;
                            zcGX0_c6  = 37.451;
                        case 'li'
                            zcGX0_c1  = 26.833;
                            zcGX0_c2  = 29.757;
                            zcGX0_c3  = 29.21;
                            zcGX0_c4  = 25.459;
                            zcGX0_c5  = 26.756;
                            zcGX0_c6  = 25.706;
                    end
                    zcGtg_c1   = 'zcG_c1';
                    zcGtg_c2   = 'zcG_c2';
                    zcGtg_c3   = 'zcG_c3';
                    zcGtg_c4   = 'zcG_c4';
                    zcGtg_c5   = 'zcG_c5';
                    zcGtg_c6   = 'zcG_c6';
                    
                     zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                    zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                                        zcGLB     = 0;
                                        zcGUB     = 250;
                                        zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
                                        zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
            end % switch lower(condParam)
            
            % 1.2.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                            %                             zcSX0     = 15;   % sim from SfN
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                    end
            end
            
            
            zcStg     = 'zcS';
%             zcSLB = (1-boundDistStop)*zcSX0;
%             zcSUB = (1+boundDistStop)*zcSX0;
                        zcSLB     = 0;
                        zcSUB     = 150;
           
            
            
            
        case 'human'
            % #####################################################
            %                                               HUMAN
            % #####################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 73.448;
                        case 'ffi'
                            zcGX0     = 25.27;
                        case 'li'
                            zcGX0     = 50.788;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
                        zcGLB     = 0;
                        zcGUB     = 250;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 68.873;
                        case 'ffi'
                            zcGX0     = 26.098;
                        case 'li'
                            zcGX0     = 52.557;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
%                         zcGLB     = 0;
%                         zcGUB     = 250;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcGX0_c1  = 84.425;
                            zcGX0_c2  = 85.986;
                            zcGX0_c3  = 89.625;
                            zcGX0_c4  = 89.792;
                            zcGX0_c5  = 85.604;
                            zcGX0_c6  = 83.604;
                        case 'ffi'
                            zcGX0_c1  = 24.2;
                            zcGX0_c2  = 22.525;
                            zcGX0_c3  = 25.93;
                            zcGX0_c4  = 22.58;
                            zcGX0_c5  = 22.919;
                            zcGX0_c6  = 21.379;
                        case 'li'
                            zcGX0_c1  = 40.647;
                            zcGX0_c2  = 41.591;
                            zcGX0_c3  = 44.053;
                            zcGX0_c4  = 41.56;
                            zcGX0_c5  = 42.514;
                            zcGX0_c6  = 41.06;
                    end
                    zcGtg_c1   = 'zcG_c1';
                    zcGtg_c2   = 'zcG_c2';
                    zcGtg_c3   = 'zcG_c3';
                    zcGtg_c4   = 'zcG_c4';
                    zcGtg_c5   = 'zcG_c5';
                    zcGtg_c6   = 'zcG_c6';
                    
                    zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                    zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
%                                         zcGLB     = 0;
%                                         zcGUB     = 250;
%                                         zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
%                                         zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
            end % switch lower(condParam)
            
            
            % 1.2.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 70;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                            %                             zcSX0     = 15;   % sim from SfN
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                    end
            end
            
            
            zcStg     = 'zcS';
            zcSLB = (1-boundDistStop)*zcSX0;
            zcSUB = (1+boundDistStop)*zcSX0;
%                         zcSLB     = 0;
%                         zcSUB     = 150;
            
    end
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.3. Accumulation rate correct (vCor)                                 ===================
    % ============================================================================================
    
    switch iSubj
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.3.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .11692;
                        case 'ffi'
                            vCGX0     = .35254;
                        case 'li'
                            vCGX0     = 1.4481;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCGX0_c1  = .20218;  % go trials fit value
                            vCGX0_c2  = .17324;  % go trials fit value
                            vCGX0_c3  = .14261;  % go trials fit value
                            vCGX0_c4  = .10716;  % go trials fit value
                            vCGX0_c5  = .11409;  % go trials fit value
                            vCGX0_c6  = .14093;  % go trials fit value
                            
                        case 'ffi'
                            vCGX0_c1  = .38736;  % go trials fit value
                            vCGX0_c2  = .34986;  % go trials fit value
                            vCGX0_c3  = .24104;  % go trials fit value
                            vCGX0_c4  = .24292;  % go trials fit value
                            vCGX0_c5  = .314;  % go trials fit value
                            vCGX0_c6  = .23236;  % go trials fit value
                            
                        case 'li'
                            vCGX0_c1  = 1.05;
                            vCGX0_c2  = .96052;
                            vCGX0_c3  = .89294;
                            vCGX0_c4  = 1.0383;
                            vCGX0_c5  = 1.1298;
                            vCGX0_c6  = 1.2134;
                            
                            
                            
                    end
                    vCGtg_c1  = 'vCG_c1';
                    vCGtg_c2  = 'vCG_c2';
                    vCGtg_c3  = 'vCG_c3';
                    vCGtg_c4  = 'vCG_c4';
                    vCGtg_c5  = 'vCG_c5';
                    vCGtg_c6  = 'vCG_c6';
                    vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
                    vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
                                                            vCGLB     = 0;
                                                            vCGUB     = 2;
                                                            vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
                                                            vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
                    
                    
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .10859;
                        case 'ffi'
                            vCGX0     = .34738;
                        case 'li'
                            vCGX0     = 1.8181;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
            end % switch lower(condParam)
            
            
            
            
            % 1.3.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .28;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
            end
            vCStg     = 'vCS';
            vCSLB = (1-boundDistStop)*vCSX0;
            vCSUB = (1+boundDistStop)*vCSX0;
%                         vCSLB     = 0;
%                         vCSUB     = 2;
             
            
            
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.3.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .13823;
                        case 'ffi'
                            vCGX0     = .11288;
                        case 'li'
                            vCGX0     = .16483;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCGX0_c1  = .32161;
                            vCGX0_c2  = .30307;
                            vCGX0_c3  = .28438;
                            vCGX0_c4  = .28548;
                            vCGX0_c5  = .35215;
                            vCGX0_c6  = .3897;
                            
                        case 'ffi'
                            vCGX0_c1  = .2963;
                            vCGX0_c2  = .41695;
                            vCGX0_c3  = .36719;
                            vCGX0_c4  = .32874;
                            vCGX0_c5  = .41119;
                            vCGX0_c6  = .39941;
                            
                        case 'li'
                            vCGX0_c1  = .83508;
                            vCGX0_c2  = .90075;
                            vCGX0_c3  = .72285;
                            vCGX0_c4  = .6619;
                            vCGX0_c5  = .75454;
                            vCGX0_c6  = .69709;
                            
                    end
                    vCGtg_c1  = 'vCG_c1';
                    vCGtg_c2  = 'vCG_c2';
                    vCGtg_c3  = 'vCG_c3';
                    vCGtg_c4  = 'vCG_c4';
                    vCGtg_c5  = 'vCG_c5';
                    vCGtg_c6  = 'vCG_c6';
                    vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
                    vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
                                                            vCGLB     = 0;
                                                            vCGUB     = 2;
                                                            vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
                                                            vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
                    
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .12992;
                        case 'ffi'
                            vCGX0     = .33542;
                        case 'li'
                            vCGX0     = .19588;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
            end % switch lower(condParam)
            
            
            
            
            % 1.3.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
            end
            vCStg     = 'vCS';
%             vCSLB = (1-boundDistStop)*vCSX0;
%             vCSUB = (1+boundDistStop)*vCSX0;
                        vCSLB     = 0;
                        vCSUB     = 2;
            
            
            
            
            
            
        case 'human'
            % #####################################################
            %                                               HUMAN
            % #####################################################
            % 1.3.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .12332;
                        case 'ffi'
                            vCGX0     = .10611;
                        case 'li'
                            vCGX0     = .12741;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCGX0_c1  = .13046;
                            vCGX0_c2  = .11917;
                            vCGX0_c3  = .10238;
                            vCGX0_c4  = .10596;
                            vCGX0_c5  = .12305;
                            vCGX0_c6  = .13373;
                            
                        case 'ffi'
                            vCGX0_c1  = .078031;
                            vCGX0_c2  = .06946;
                            vCGX0_c3  = .048594;
                            vCGX0_c4  = .10348;
                            vCGX0_c5  = .063449;
                            vCGX0_c6  = .078019;
                            
                        case 'li'
                            vCGX0_c1  = .14804;
                            vCGX0_c2  = .139;
                            vCGX0_c3  = .12165;
                            vCGX0_c4  = .1186;
                            vCGX0_c5  = .13372;
                            vCGX0_c6  = .15033;
                            
                            
                    end
                    vCGtg_c1  = 'vCG_c1';
                    vCGtg_c2  = 'vCG_c2';
                    vCGtg_c3  = 'vCG_c3';
                    vCGtg_c4  = 'vCG_c4';
                    vCGtg_c5  = 'vCG_c5';
                    vCGtg_c6  = 'vCG_c6';
                    
                    vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
                    vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                                                             vCGLB     = 0;
%                                                             vCGUB     = 2;
%                                                             vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
%                                                             vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
                    
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .12385;
                        case 'ffi'
                            vCGX0     = .090335;
                        case 'li'
                            vCGX0     = .11964;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
            end % switch lower(condParam)
            
            
            
            
            % 1.3.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .75;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
            end
            vCStg     = 'vCS';
            vCSLB = (1-boundDistStop)*vCSX0;
            vCSUB = (1+boundDistStop)*vCSX0;
%                         vCSLB     = 0;
%                         vCSUB     = 2;
%             
            
            
    end
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.4. Accumulation rate incorrect (vIncor)                             ===================
    % ============================================================================================
    
    switch iSubj
        
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.4.1.  units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .019266;
                        case 'ffi'
                            vIGX0     = .2971;
                        case 'li'
                            vIGX0     = 1.1963;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vIGX0_c1  = .023165;  % go trials fit value
                            vIGX0_c2  = .072028;  % go trials fit value
                            vIGX0_c3  = .069156;  % go trials fit value
                            vIGX0_c4  = .070338;  % go trials fit value
                            vIGX0_c5  = .055366;  % go trials fit value
                            vIGX0_c6  = .023363;  % go trials fit value
                            
                        case 'ffi'
                            vIGX0_c1  = .27496;  % go trials fit value
                            vIGX0_c2  = .27299;  % go trials fit value
                            vIGX0_c3  = .20308;  % go trials fit value
                            vIGX0_c4  = .19967;  % go trials fit value
                            vIGX0_c5  = .2495;  % go trials fit value
                            vIGX0_c6  = .16837;  % go trials fit value
                            
                        case 'li'
                            vIGX0_c1  = 0.68137;
                            vIGX0_c2  = 0.70374;
                            vIGX0_c3  = 0.73652;
                            vIGX0_c4  = 0.88788;
                            vIGX0_c5  = 0.87268;
                            vIGX0_c6  = 0.82165;
                            
                    end
                    
                    vIGtg_c1  = 'vIG_c1';
                    vIGtg_c2  = 'vIG_c2';
                    vIGtg_c3  = 'vIG_c3';
                    vIGtg_c4  = 'vIG_c4';
                    vIGtg_c5  = 'vIG_c5';
                    vIGtg_c6  = 'vIG_c6';
                    vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
                    vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
                                        vIGLB     = 0;
                                        vIGUB     = 2;
                                        vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
                                        vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .023732;
                        case 'ffi'
                            vIGX0     = .28398;
                        case 'li'
                            vIGX0     = 1.6105;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
            end % switch lower(condParam)
            
            
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.4.1.  units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .070667;
                        case 'ffi'
                            vIGX0     = .064961;
                        case 'li'
                            vIGX0     = .068503;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vIGX0_c1  = .18702;
                            vIGX0_c2  = .20329;
                            vIGX0_c3  = .24988;
                            vIGX0_c4  = .32891;
                            vIGX0_c5  = .26689;
                            vIGX0_c6  = .25234;
                            
                        case 'ffi'
                            vIGX0_c1  = .20333;
                            vIGX0_c2  = .34285;
                            vIGX0_c3  = .31758;
                            vIGX0_c4  = .34093;
                            vIGX0_c5  = .36544;
                            vIGX0_c6  = .24824;
                            
                        case 'li'
                            vIGX0_c1  = .73018;
                            vIGX0_c2  = .73622;
                            vIGX0_c3  = .69664;
                            vIGX0_c4  = .60359;
                            vIGX0_c5  = .60234;
                            vIGX0_c6  = .45174;
                    end
                    
                    vIGtg_c1  = 'vIG_c1';
                    vIGtg_c2  = 'vIG_c2';
                    vIGtg_c3  = 'vIG_c3';
                    vIGtg_c4  = 'vIG_c4';
                    vIGtg_c5  = 'vIG_c5';
                    vIGtg_c6  = 'vIG_c6';
                    
                    vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
                    vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
                                        vIGLB     = 0;
                                        vIGUB     = 2;
                                        vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
                                        vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .055856;
                        case 'ffi'
                            vIGX0     = .2913;
                        case 'li'
                            vIGX0     = .11441;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
            end % switch lower(condParam)
            
            
            
        case 'human'
            % #####################################################
            %                                               HUMAN
            % #####################################################
            % 1.4.1.  units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .062368;
                        case 'ffi'
                            vIGX0     = .061328;
                        case 'li'
                            vIGX0     = .036413;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vIGX0_c1  = .02745;
                            vIGX0_c2  = .04365;
                            vIGX0_c3  = .06113;
                            vIGX0_c4  = .061388;
                            vIGX0_c5  = .034049;
                            vIGX0_c6  = .034802;
                            
                        case 'ffi'
                            vIGX0_c1  = .014778;
                            vIGX0_c2  = .011741;
                            vIGX0_c3  = .022398;
                            vIGX0_c4  = .071554;
                            vIGX0_c5  = .0028011;
                            vIGX0_c6  = .0038103;
                            
                        case 'li'
                            vIGX0_c1  = .0083354;
                            vIGX0_c2  = .040311;
                            vIGX0_c3  = .054012;
                            vIGX0_c4  = .058292;
                            vIGX0_c5  = .034668;
                            vIGX0_c6  = .018879;
                            
                    end
                    
                    vIGtg_c1  = 'vIG_c1';
                    vIGtg_c2  = 'vIG_c2';
                    vIGtg_c3  = 'vIG_c3';
                    vIGtg_c4  = 'vIG_c4';
                    vIGtg_c5  = 'vIG_c5';
                    vIGtg_c6  = 'vIG_c6';
                    vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
                    vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                                         vIGLB     = 0;
%                                         vIGUB     = 2;
%                                         vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
%                                         vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .062801;
                        case 'ffi'
                            vIGX0     = .050324;
                        case 'li'
                            vIGX0     = .028507;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
            end % switch lower(condParam)
            
    end
    
    
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.5. Non-decision time (t0)                                           ===================
    % ============================================================================================
    
    switch iSubj
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.5.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0GX0_c1  = 99.499;
                            t0GX0_c2  = 103.5;
                            t0GX0_c3  = 108.01;
                            t0GX0_c4  = 113.69;
                            t0GX0_c5  = 124.69;
                            t0GX0_c6  = 107.82;
                            
                        case 'ffi'
                            t0GX0_c1  = 130.78;
                            t0GX0_c2  = 135.77;
                            t0GX0_c3  = 136.99;
                            t0GX0_c4  = 140.37;
                            t0GX0_c5  = 150.4;
                            t0GX0_c6  = 143.68;
                            
                        case 'li'
                            t0GX0_c1  = 77.736;
                            t0GX0_c2  = 74.784;
                            t0GX0_c3  = 82.676;
                            t0GX0_c4  = 74.61;
                            t0GX0_c5  = 92.583;
                            t0GX0_c6  = 95.424;
                    end
                    
                    t0Gtg_c1  = 't0G_c1';
                    t0Gtg_c2  = 't0G_c2';
                    t0Gtg_c3  = 't0G_c3';
                    t0Gtg_c4  = 't0G_c4';
                    t0Gtg_c5  = 't0G_c5';
                    t0Gtg_c6  = 't0G_c6';
                    t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                    t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                                t0GLB     = 20;
                                t0GUB     = 100;
                                t0GLB     = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
                                t0GUB     = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 90.589;
                        case 'ffi'
                            t0GX0     = 139.49;
                        case 'li'
                            t0GX0     = 93.914;
                            %                             t0GX0     = 62;     % sim from SfN
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 100;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 117.24;
                        case 'ffi'
                            t0GX0     = 143.67;
                        case 'li'
                            t0GX0     = 37.238;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 100;
            end % switch lower(condParam)
            
            
            
            
            % 1.5.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
            end
            
            t0Stg     = 't0S';
%             t0SLB = (1-boundDistStop)*t0SX0;
%             t0SUB = (1+boundDistStop)*t0SX0;
                        t0SLB     = 20;
                        t0SUB     = 75;
            
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.5.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0GX0_c1  = 151.77;
                            t0GX0_c2  = 153.9;
                            t0GX0_c3  = 158.7;
                            t0GX0_c4  = 149.65;
                            t0GX0_c5  = 150.38;
                            t0GX0_c6  = 147.63;
                            
                        case 'ffi'
                            t0GX0_c1  = 185.11;
                            t0GX0_c2  = 153.05;
                            t0GX0_c3  = 182.37;
                            t0GX0_c4  = 192.51;
                            t0GX0_c5  = 167.68;
                            t0GX0_c6  = 187.15;
                            
                        case 'li'
                            t0GX0_c1  = 165.65;
                            t0GX0_c2  = 169.65;
                            t0GX0_c3  = 174.13;
                            t0GX0_c4  = 160.33;
                            t0GX0_c5  = 167.81;
                            t0GX0_c6  = 165.9;
                    end
                    
                    t0Gtg_c1  = 't0G_c1';
                    t0Gtg_c2  = 't0G_c2';
                    t0Gtg_c3  = 't0G_c3';
                    t0Gtg_c4  = 't0G_c4';
                    t0Gtg_c5  = 't0G_c5';
                    t0Gtg_c6  = 't0G_c6';
                    
                    t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                    t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                                t0GLB     = 20;
                                t0GUB     = 70;
                                t0GLB     = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
                                t0GUB     = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 76.079;
                        case 'ffi'
                            t0GX0     = 157.86;
                        case 'li'
                            t0GX0     = 67.734;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 70;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 158.21;
                        case 'ffi'
                            t0GX0     = 195.52;
                        case 'li'
                            t0GX0     = 138.41;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 70;
            end % switch lower(condParam)
            
            
            
            
            % 1.5.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
            end
            
            t0Stg     = 't0S';
%             t0SLB = (1-boundDistStop)*t0SX0;
%             t0SUB = (1+boundDistStop)*t0SX0;
                        t0SLB     = 20;
                        t0SUB     = 70;
            
            
        case 'human'
            % #####################################################
            %                                               HUMAN
            % #####################################################
            % 1.5.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0GX0_c1  = 98.806;
                            t0GX0_c2  = 118.67;
                            t0GX0_c3  = 152.82;
                            t0GX0_c4  = 148.68;
                            t0GX0_c5  = 107.04;
                            t0GX0_c6  = 92.753;
                            
                        case 'ffi'
                            t0GX0_c1  = 321.02;
                            t0GX0_c2  = 298.17;
                            t0GX0_c3  = 352.04;
                            t0GX0_c4  = 330.54;
                            t0GX0_c5  = 320.82;
                            t0GX0_c6  = 317.94;
                            
                        case 'li'
                            t0GX0_c1  = 207.28;
                            t0GX0_c2  = 209.95;
                            t0GX0_c3  = 221.44;
                            t0GX0_c4  = 246.05;
                            t0GX0_c5  = 212.6;
                            t0GX0_c6  = 182.36;
                    end
                    
                    t0Gtg_c1  = 't0G_c1';
                    t0Gtg_c2  = 't0G_c2';
                    t0Gtg_c3  = 't0G_c3';
                    t0Gtg_c4  = 't0G_c4';
                    t0Gtg_c5  = 't0G_c5';
                    t0Gtg_c6  = 't0G_c6';
                    t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                    t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                                t0GLB     = 20;
                                t0GUB     = 200;
                                t0GLB     = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
                                t0GUB     = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 110.41;
                        case 'ffi'
                            t0GX0     = 323.58;
                        case 'li'
                            t0GX0     = 222.46;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
%                                         t0GLB     = 20;
%                                         t0GUB     = 200;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 118.57;
                        case 'ffi'
                            t0GX0     = 349.66;
                        case 'li'
                            t0GX0     = 259.23;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 200;
            end % switch lower(condParam)
            
            
            
            
            % 1.5.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 120;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
            end
            
            t0Stg     = 't0S';
            t0SLB = (1-boundDistStop)*t0SX0;
            t0SUB = (1+boundDistStop)*t0SX0;
%                         t0SLB     = 20;
%                         t0SUB     = 250;
            
    end
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.6. Extrinsic noise (se)                                             ===================
    % ============================================================================================
    seLB      = 0;
    seUB      = 0;
    seX0      = 0;
    setg      = 'se';
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.7. Intrinsic noise (si)                                             ===================
    % ============================================================================================
    siX0      = 1; % go trial fit value
    sitg      = 'si';
    siLB = siX0;
    siUB = siX0;
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.8. Leakage constant (k)                                             ===================
    % ============================================================================================
    
    % 1.8.1. GO units
    % -------------------------------------------------------------------------
    kGX0 = -realmin;
    kGtg = 'kG';
    kGLB = -realmin;
    kGUB = -realmin; % Note: this should not be 0 to satisfy non-linear constraints
    
    % 1.8.2. STOP unit
    % -------------------------------------------------------------------------
    kSX0 = -realmin;
    kStg = 'kS';
    kSLB = -realmin;
    kSUB = -realmin; % Note: this should not be 0 to satisfy non-linear constraints
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.9. Lateral inhibition weight (w)                                    ===================
    % ============================================================================================
    
    switch iSubj
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.9.1. GO units
            % -------------------------------------------------------------------------
            switch lower(choiceMechType)
                case 'li'
                    switch lower(condParam)
                        case 't0'
                            wGX0      = -1.0286;
                        case 'v'
                            wGX0      = -2.7235;
                        case 'zc'
                            wGX0      = -.75905;
                    end
                    wGUB = (1-boundDistGo)*wGX0;
                    wGLB = (1+boundDistGo)*wGX0;
                             wGLB      = -1;
                             wGUB      = 0;
                case {'race','ffi'}
                    wGX0      = 0;
                    wGLB      = 0;
                    wGUB      = 0;
            end
            wGtg      = 'wG';
            
            
            % 1.9.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -01;
                        case 'ffi'
                            wSX0      = -01;
                        case 'li'
                            wSX0      =  -01;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            wSX0      =  -01;
                        case 'ffi'
                            wSX0      =  -01;
                        case 'li'
                            wSX0      =  -01;
                            %                             wSX0      = -.8; % from SfN simulations
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -01;
                        case 'ffi'
                            wSX0      = -01;
                        case 'li'
                            wSX0      = -01;
                    end
            end
            
            wStg      = 'wS';
            wSLB = (1+boundDistStop)*wSX0;
            wSUB = (1-boundDistStop)*wSX0;
%                      wSLB      = -4;
%                      wSUB      = 0;
            
            
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.9.1. GO units
            % -------------------------------------------------------------------------
            switch lower(choiceMechType)
                case 'li'
                    switch lower(condParam)
                        case 't0'
                            wGX0      = -.88604;
                        case 'v'
                            wGX0      = -7.5885;
                        case 'zc'
                            wGX0      = -.085514;
                    end
                    wGUB = (1-boundDistGo)*wGX0;
                    wGLB = (1+boundDistGo)*wGX0;
                             wGLB      = -4;
                             wGUB      = 0;
                case {'race','ffi'}
                    wGX0      = 0;
                    wGLB      = 0;
                    wGUB      = 0;
            end
            wGtg      = 'wG';
            
            
            % 1.9.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -.68525;
                        case 'ffi'
                            wSX0      = -1.8824;
                        case 'li'
                            wSX0      = -1.0995;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -.6421;
                        case 'ffi'
                            wSX0      = -1.6076;
                        case 'li'
                            wSX0      = -.076495;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -.46355;
                        case 'ffi'
                            wSX0      = -1.1361;
                        case 'li'
                            wSX0      = -1.2786;
                    end
            end
            
            wStg      = 'wS';
%             wSLB = (1+boundDistStop)*wSX0;
%             wSUB = (1-boundDistStop)*wSX0;
                     wSLB      = -4;
                     wSUB      = 0;
            
            
            
            
        case 'human'
            % #####################################################
            %                                               HUMAN
            % #####################################################
            % 1.9.1. GO units
            % -------------------------------------------------------------------------
            switch lower(choiceMechType)
                case 'li'
                    switch lower(condParam)
                        case 't0'
                            wGX0      = -.81042;
                        case 'v'
                            wGX0      = -.04614;
                        case 'zc'
                            wGX0      = -.73375;
                    end
                    wGUB = (1-boundDistGo)*wGX0;
                    wGLB = (1+boundDistGo)*wGX0;
%                              wGLB      = -4;
%                              wGUB      = 0;
                case {'race','ffi'}
                    wGX0      = 0;
                    wGLB      = 0;
                    wGUB      = 0;
            end
            wGtg      = 'wG';
            
            
            % 1.9.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -3.0593;
                        case 'ffi'
                            wSX0      = -2.074;
                        case 'li'
                            wSX0      = -3.3301;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -1.1088;
                        case 'ffi'
                            wSX0      = -.56863;
                        case 'li'
                            wSX0      = -1.5529;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -.78283;
                        case 'ffi'
                            wSX0      = -.92364;
                        case 'li'
                            wSX0      = -4.9926;
                    end
            end
            
            wStg      = 'wS';
            wSLB = (1+boundDistStop)*wSX0;
            wSUB = (1-boundDistStop)*wSX0;
%                      wSLB      = -4;
%                      wSUB      = 0;
            
    end
    
    
    
    
    
    
    
    
    
    
    
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     
%     
%     
%     
%     
%     
%     
%     
% 
% elseif ~noiseBound && tBound
%     
% %     switch iSubj
% %         case 'broca'
% %             boundDistGo = .3;
% %             boundDistStop = .3;
% %         case 'xena'
% %             boundDistGo = .3;
% %             boundDistStop = .3;
% %         case 'human'
% %             boundDistGo = .3;
% %             boundDistStop = .3;
% %     end
%     switch iSubj
%         case 'broca'
%             boundDistGo = 0;
%             boundDistStop = 1;
%         case 'xena'
%             boundDistGo = 0;
%             boundDistStop = 1;
%         case 'human'
%             boundDistGo = 0;
%             boundDistStop = 1;
%     end
%     
%     
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % 1. SET LB, UB, X0 VALUES
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.1. Starting value (z0)                                              ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 2.0995;
%                         case 'ffi'
%                             z0GX0     = 2.7579;
%                         case 'li'
%                             z0GX0     = 8.3901;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = .00046927;
%                         case 'ffi'
%                             z0GX0     = .072664;
%                         case 'li'
%                             z0GX0     = 8.6809;
%                             %                             z0GX0     = 1; % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = .0001;
%                         case 'ffi'
%                             z0GX0     = 9.0016322;
%                         case 'li'
%                             z0GX0     = 2.4216;
%                     end
%             end
%             
%             % Go bounds
%             z0Gtg     = 'z0G';
%             z0GLB = (1-boundDistGo)*z0GX0;
%             z0GUB = (1+boundDistGo)*z0GX0;
% %             z0GLB     = 0;
% %             z0GUB     = 100;
%             
%             
%             
%             % 1.1.2. STOP unit
%             % -------------------------------------------------------------------------
%             z0SX0     = 1;
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 01;
%                         case 'ffi'
%                             z0SX0     = 01;
%                         case 'li'
%                             z0SX0     = 01;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 01;
%                         case 'ffi'
%                             z0SX0     = 01;
%                         case 'li'
%                             z0SX0     = 01;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 01;
%                         case 'ffi'
%                             z0SX0     = 01;
%                         case 'li'
%                             z0SX0     = 01;
%                     end
%             end
%             
%             
%             % Stop bounds
%             z0Stg     = 'z0S';
% %             z0SLB = (1-boundDistStop)*z0SX0;
% %             z0SUB = (1+boundDistStop)*z0SX0;
%                         z0SLB     = 0;
%                         z0SUB     = 10;
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 86.092;
%                         case 'ffi'
%                             z0GX0     = .16833;
%                         case 'li'
%                             z0GX0     = 92.615;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = .44428;
%                         case 'ffi'
%                             z0GX0     = 4.3986;
%                         case 'li'
%                             z0GX0     = 17.885;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = .17786;
%                         case 'ffi'
%                             z0GX0     = .47855;
%                         case 'li'
%                             z0GX0     = 15.925;
%                     end
%             end
%             
%             % Go bounds
%             z0Gtg     = 'z0G';
%             z0GLB = (1-boundDistGo)*z0GX0;
%             z0GUB = (1+boundDistGo)*z0GX0;
% %             z0GLB     = 0;
% %             z0GUB     = 100;
%             
%             
%             % 1.1.2. STOP unit
%             % -------------------------------------------------------------------------
%             z0SX0     = 1;
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 01;
%                         case 'ffi'
%                             z0SX0     = 01;
%                         case 'li'
%                             z0SX0     = 01;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 01;
%                         case 'ffi'
%                             z0SX0     = 01;
%                         case 'li'
%                             z0SX0     = 01;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 01;
%                         case 'ffi'
%                             z0SX0     = 01;
%                         case 'li'
%                             z0SX0     = 01;
%                     end
%             end
%             
%             
%             % Stop bounds
%             z0Stg     = 'z0S';
% %             z0SLB = (1-boundDistStop)*z0SX0;
% %             z0SUB = (1+boundDistStop)*z0SX0;
%                         z0SLB     = 0;
%                         z0SUB     = 10;
%             
%             
%             
%         case 'human'
%             % ############################################################
%             %                                                    HUMAN
%             % ############################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = .89003;
%                         case 'ffi'
%                             z0GX0     = .090995;
%                         case 'li'
%                             z0GX0     = 51.643;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 9.2215;
%                         case 'ffi'
%                             z0GX0     = 3.0566;
%                         case 'li'
%                             z0GX0     = 13.275;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0GX0     = 25.687;
%                         case 'ffi'
%                             z0GX0     = 1.3762;
%                         case 'li'
%                             z0GX0     = 8.4988;
%                     end
%             end
%             
%             % Go bounds
%             z0Gtg     = 'z0G';
%             z0GLB = (1-boundDistGo)*z0GX0;
%             z0GUB = (1+boundDistGo)*z0GX0;
% %             z0GLB     = 0;
% %             z0GUB     = 100;
%             
%             
%             
%             % 1.1.2. STOP unit
%             % -------------------------------------------------------------------------
%             z0SX0     = 1;
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 01;
%                         case 'ffi'
%                             z0SX0     = 01;
%                         case 'li'
%                             z0SX0     = 01;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 01;
%                         case 'ffi'
%                             z0SX0     = 01;
%                         case 'li'
%                             z0SX0     = 01;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             z0SX0     = 01;
%                         case 'ffi'
%                             z0SX0     = 01;
%                         case 'li'
%                             z0SX0     = 01;
%                     end
%             end
%             
%             
%             % Stop bounds
%             z0Stg     = 'z0S';
% %             z0SLB = (1-boundDistStop)*z0SX0;
% %             z0SUB = (1+boundDistStop)*z0SX0;
%                         z0SLB     = 0;
%                         z0SUB     = 10;
%            
%             
%         otherwise
%             disp('sam_get_bnds_pgm.m: the iSubj variable is wrong')
%             return
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.2. Threshold (zc)                                                   ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 46.077;
%                         case 'ffi'
%                             zcGX0     = 34.199;
%                         case 'li'
%                             zcGX0     = 311.2;
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
% %                         zcGLB     = 0;
% %                         zcGUB     = 250;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 62.016;
%                         case 'ffi'
%                             zcGX0     = 45.935;
%                         case 'li'
%                             zcGX0     = 32.618;
%                             %                             zcGX0     = 30;     % sim from SfN
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
% %                         zcGLB     = 0;
% %                         zcGUB     = 250;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0_c1  = 53.483;
%                             zcGX0_c2  = 60.311;
%                             zcGX0_c3  = 58.755;
%                             zcGX0_c4  = 70.082;
%                             zcGX0_c5  = 72.56;
%                             zcGX0_c6  = 67.787;
%                         case 'ffi'
%                             zcGX0_c1  = 32.81;
%                             zcGX0_c2  = 36.553;
%                             zcGX0_c3  = 36.837;
%                             zcGX0_c4  = 38.743;
%                             zcGX0_c5  = 44.554;
%                             zcGX0_c6  = 41.534;
%                         case 'li'
%                             zcGX0_c1  = 26.104;
%                             zcGX0_c2  = 28.518;
%                             zcGX0_c3  = 29.694;
%                             zcGX0_c4  = 30.619;
%                             zcGX0_c5  = 37.119;
%                             zcGX0_c6  = 37.724;
%                     end
%                     zcGtg_c1   = 'zcG_c1';
%                     zcGtg_c2   = 'zcG_c2';
%                     zcGtg_c3   = 'zcG_c3';
%                     zcGtg_c4   = 'zcG_c4';
%                     zcGtg_c5   = 'zcG_c5';
%                     zcGtg_c6   = 'zcG_c6';
%                     
%                     zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
%                     zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
% %                                         zcGLB     = 0;
% %                                         zcGUB     = 250;
% %                                         zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
% %                                         zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
%             end % switch lower(condParam)
%             
%             % 1.2.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                             %                             zcSX0     = 15;   % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%             end
%             
%             
%             zcStg     = 'zcS';
% %             zcSLB = (1-boundDistStop)*zcSX0;
% %             zcSUB = (1+boundDistStop)*zcSX0;
%                         zcSLB     = 0;
%                         zcSUB     = 35;
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 204.39;
%                         case 'ffi'
%                             zcGX0     = 47.099;
%                         case 'li'
%                             zcGX0     = 241.48;
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
% %                         zcGLB     = 0;
% %                         zcGUB     = 250;
%                case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 97.706;
%                         case 'ffi'
%                             zcGX0     = 54.729;
%                         case 'li'
%                             zcGX0     = 244.92;
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
% %                         zcGLB     = 0;
% %                         zcGUB     = 250;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0_c1  = 46.83;
%                             zcGX0_c2  = 48.595;
%                             zcGX0_c3  = 48.068;
%                             zcGX0_c4  = 46.098;
%                             zcGX0_c5  = 45.984;
%                             zcGX0_c6  = 45.769;
%                         case 'ffi'
%                             zcGX0_c1  = 38.812;
%                             zcGX0_c2  = 38.127;
%                             zcGX0_c3  = 37.646;
%                             zcGX0_c4  = 35.862;
%                             zcGX0_c5  = 38.994;
%                             zcGX0_c6  = 42.563;
%                         case 'li'
%                             zcGX0_c1  = 128.06;
%                             zcGX0_c2  = 127.49;
%                             zcGX0_c3  = 118.68;
%                             zcGX0_c4  = 98.934;
%                             zcGX0_c5  = 116.26;
%                             zcGX0_c6  = 116.29;
%                     end
%                     zcGtg_c1   = 'zcG_c1';
%                     zcGtg_c2   = 'zcG_c2';
%                     zcGtg_c3   = 'zcG_c3';
%                     zcGtg_c4   = 'zcG_c4';
%                     zcGtg_c5   = 'zcG_c5';
%                     zcGtg_c6   = 'zcG_c6';
%                     
%                     zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
%                     zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
% %                                         zcGLB     = 0;
% %                                         zcGUB     = 250;
% %                                         zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
% %                                         zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
%             end % switch lower(condParam)
%             
%             % 1.2.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                             %                             zcSX0     = 15;   % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%             end
%             
%             
%             zcStg     = 'zcS';
% %             zcSLB = (1-boundDistStop)*zcSX0;
% %             zcSUB = (1+boundDistStop)*zcSX0;
%                         zcSLB     = 0;
%                         zcSUB     = 35;
%            
%             
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             % 1.1.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 132.24;
%                         case 'ffi'
%                             zcGX0     = 89.022;
%                         case 'li'
%                             zcGX0     = 104.35;
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
% %                         zcGLB     = 0;
% %                         zcGUB     = 250;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0     = 88.309;
%                         case 'ffi'
%                             zcGX0     = 71.579;
%                         case 'li'
%                             zcGX0     = 74.222;
%                     end
%                     zcGtg     = 'zcG';
%                     zcGLB = (1-boundDistGo)*zcGX0;
%                     zcGUB = (1+boundDistGo)*zcGX0;
% %                         zcGLB     = 0;
% %                         zcGUB     = 250;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcGX0_c1  = 211.08;
%                             zcGX0_c2  = 213.46;
%                             zcGX0_c3  = 225.61;
%                             zcGX0_c4  = 226.11;
%                             zcGX0_c5  = 214.18;
%                             zcGX0_c6  = 209.91;
%                         case 'ffi'
%                             zcGX0_c1  = 64.767;
%                             zcGX0_c2  = 60.853;
%                             zcGX0_c3  = 59.224;
%                             zcGX0_c4  = 62.748;
%                             zcGX0_c5  = 62.484;
%                             zcGX0_c6  = 61.708;
%                         case 'li'
%                             zcGX0_c1  = 149.5;
%                             zcGX0_c2  = 154.12;
%                             zcGX0_c3  = 146.99;
%                             zcGX0_c4  = 149.66;
%                             zcGX0_c5  = 156.89;
%                             zcGX0_c6  = 147.26;
%                     end
%                     zcGtg_c1   = 'zcG_c1';
%                     zcGtg_c2   = 'zcG_c2';
%                     zcGtg_c3   = 'zcG_c3';
%                     zcGtg_c4   = 'zcG_c4';
%                     zcGtg_c5   = 'zcG_c5';
%                     zcGtg_c6   = 'zcG_c6';
%                     
%                     zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
%                     zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
% %                                         zcGLB     = 0;
% %                                         zcGUB     = 250;
% %                                         zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
% %                                         zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
%             end % switch lower(condParam)
%             
%             % 1.2.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                             %                             zcSX0     = 15;   % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             zcSX0     = 15;
%                         case 'ffi'
%                             zcSX0     = 15;
%                         case 'li'
%                             zcSX0     = 15;
%                     end
%             end
%             
%             
%             zcStg     = 'zcS';
% %             zcSLB = (1-boundDistStop)*zcSX0;
% %             zcSUB = (1+boundDistStop)*zcSX0;
%                         zcSLB     = 0;
%                         zcSUB     = 35;
%             
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.3. Accumulation rate correct (vCor)                                 ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.3.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .21044;
%                         case 'ffi'
%                             vCGX0     = .18781;
%                         case 'li'
%                             vCGX0     = 2.8389;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
% %                         vCGLB     = 0;
% %                         vCGUB     = 2;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0_c1  = .43167;  % go trials fit value
%                             vCGX0_c2  = .3828;  % go trials fit value
%                             vCGX0_c3  = .26161;  % go trials fit value
%                             vCGX0_c4  = .25524;  % go trials fit value
%                             vCGX0_c5  = .22595;  % go trials fit value
%                             vCGX0_c6  = .29073;  % go trials fit value
%                             
%                         case 'ffi'
%                             vCGX0_c1  = .30469;  % go trials fit value
%                             vCGX0_c2  = .21815;  % go trials fit value
%                             vCGX0_c3  = .26022;  % go trials fit value
%                             vCGX0_c4  = .23739;  % go trials fit value
%                             vCGX0_c5  = .20164;  % go trials fit value
%                             vCGX0_c6  = .22477;  % go trials fit value
%                             
%                         case 'li'
%                             vCGX0_c1  = .30984;
%                             vCGX0_c2  = .30349;
%                             vCGX0_c3  = .25951;
%                             vCGX0_c4  = .16913;
%                             vCGX0_c5  = .17431;
%                             vCGX0_c6  = .21982;
%                             
%                             %                             vCGX0_c1  = .22;  % sim from SfN
%                             %                             vCGX0_c2  = .21;
%                             %                             vCGX0_c3  = .19;
%                             %                             vCGX0_c4  = .15;
%                             %                             vCGX0_c5  = .16;
%                             %                             vCGX0_c6  = .17;
%                             
%                             
%                     end
%                     vCGtg_c1  = 'vCG_c1';
%                     vCGtg_c2  = 'vCG_c2';
%                     vCGtg_c3  = 'vCG_c3';
%                     vCGtg_c4  = 'vCG_c4';
%                     vCGtg_c5  = 'vCG_c5';
%                     vCGtg_c6  = 'vCG_c6';
%                     
%                     vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                     vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
% %                                                             vCGLB     = 0;
% %                                                             vCGUB     = 2;
% %                                                             vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
% %                                                             vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
%                     
%                     
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .30679;
%                         case 'ffi'
%                             vCGX0     = .1565;
%                         case 'li'
%                             vCGX0     = .2218;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
% %                         vCGLB     = 0;
% %                         vCGUB     = 2;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.3.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%             end
%             vCStg     = 'vCS';
% %             vCSLB = (1-boundDistStop)*vCSX0;
% %             vCSUB = (1+boundDistStop)*vCSX0;
%                         vCSLB     = 0;
%                         vCSUB     = 2;
%              
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.3.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .46325;
%                         case 'ffi'
%                             vCGX0     = .22474;
%                         case 'li'
%                             vCGX0     = 1.5014;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
% %                         vCGLB     = 0;
% %                         vCGUB     = 2;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0_c1  = .37521;
%                             vCGX0_c2  = .35054;
%                             vCGX0_c3  = .32895;
%                             vCGX0_c4  = .3005;
%                             vCGX0_c5  = .38459;
%                             vCGX0_c6  = .44398;
%                             
%                         case 'ffi'
%                             vCGX0_c1  = .49812;
%                             vCGX0_c2  = .48526;
%                             vCGX0_c3  = .35742;
%                             vCGX0_c4  = .51689;
%                             vCGX0_c5  = .41399;
%                             vCGX0_c6  = .4339;
%                             
%                         case 'li'
%                             vCGX0_c1  = 1.3129;
%                             vCGX0_c2  = 1.6386;
%                             vCGX0_c3  = 1.5038;
%                             vCGX0_c4  = 1.2975;
%                             vCGX0_c5  = 1.2925;
%                             vCGX0_c6  = 1.299;
%                             
%                     end
%                     vCGtg_c1  = 'vCG_c1';
%                     vCGtg_c2  = 'vCG_c2';
%                     vCGtg_c3  = 'vCG_c3';
%                     vCGtg_c4  = 'vCG_c4';
%                     vCGtg_c5  = 'vCG_c5';
%                     vCGtg_c6  = 'vCG_c6';
%  
%                                         vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                     vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
% %                                                             vCGLB     = 0;
% %                                                             vCGUB     = 2;
% %                                                             vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
% %                                                             vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
% 
%                     
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .18793;
%                         case 'ffi'
%                             vCGX0     = .0948;
%                         case 'li'
%                             vCGX0     = .50571;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
% %                         vCGLB     = 0;
% %                         vCGUB     = 2;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.3.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%             end
%             vCStg     = 'vCS';
% %             vCSLB = (1-boundDistStop)*vCSX0;
% %             vCSUB = (1+boundDistStop)*vCSX0;
%                         vCSLB     = 0;
%                         vCSUB     = 2;
%             
%             
%             
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             % 1.3.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .2221;
%                         case 'ffi'
%                             vCGX0     = .68121;
%                         case 'li'
%                             vCGX0     = .19739;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
% %                         vCGLB     = 0;
% %                         vCGUB     = 2;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0_c1  = .14067;
%                             vCGX0_c2  = .13426;
%                             vCGX0_c3  = .11899;
%                             vCGX0_c4  = .12124;
%                             vCGX0_c5  = .13649;
%                             vCGX0_c6  = .14515;
%                             
%                         case 'ffi'
%                             vCGX0_c1  = .10112;
%                             vCGX0_c2  = .11709;
%                             vCGX0_c3  = .14791;
%                             vCGX0_c4  = .12769;
%                             vCGX0_c5  = .1059;
%                             vCGX0_c6  = .11208;
%                             
%                         case 'li'
%                             vCGX0_c1  = .1485;
%                             vCGX0_c2  = .13744;
%                             vCGX0_c3  = .12416;
%                             vCGX0_c4  = .12839;
%                             vCGX0_c5  = .14007;
%                             vCGX0_c6  = .14514;
%                             
%                             
%                     end
%                     vCGtg_c1  = 'vCG_c1';
%                     vCGtg_c2  = 'vCG_c2';
%                     vCGtg_c3  = 'vCG_c3';
%                     vCGtg_c4  = 'vCG_c4';
%                     vCGtg_c5  = 'vCG_c5';
%                     vCGtg_c6  = 'vCG_c6';
%                     
%                     vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                     vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
% %                                                             vCGLB     = 0;
% %                                                             vCGUB     = 2;
% %                                                             vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
% %                                                             vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
%                     %
%                     
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCGX0     = .31194;
%                         case 'ffi'
%                             vCGX0     = .076483;
%                         case 'li'
%                             vCGX0     = .27902;
%                     end
%                     vCGtg     = 'vCG';
%                     vCGLB = (1-boundDistGo)*vCGX0;
%                     vCGUB = (1+boundDistGo)*vCGX0;
% %                         vCGLB     = 0;
% %                         vCGUB     = 2;
%             end % switch lower(condParam)
%             
%             
%             
%             
%              % 1.3.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vCSX0     = .55;
%                         case 'ffi'
%                             vCSX0     = .55;
%                         case 'li'
%                             vCSX0     = .55;
%                     end
%             end
%             vCStg     = 'vCS';
% %             vCSLB = (1-boundDistStop)*vCSX0;
% %             vCSUB = (1+boundDistStop)*vCSX0;
%                         vCSLB     = 0;
%                         vCSUB     = 2;
%             
%             
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.4. Accumulation rate incorrect (vIncor)                             ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.4.1.  units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .039731;
%                         case 'ffi'
%                             vIGX0     = .0751;
%                         case 'li'
%                             vIGX0     = 2.3216;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
% %                                 vIGLB     = 0;
% %                                 vIGUB     = 2;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0_c1  = .030059;  % go trials fit value
%                             vIGX0_c2  = .068359;  % go trials fit value
%                             vIGX0_c3  = .0099427;  % go trials fit value
%                             vIGX0_c4  = .088255;  % go trials fit value
%                             vIGX0_c5  = .038398;  % go trials fit value
%                             vIGX0_c6  = .0099046;  % go trials fit value
%                             
%                         case 'ffi'
%                             vIGX0_c1  = .0044144;  % go trials fit value
%                             vIGX0_c2  = .028757;  % go trials fit value
%                             vIGX0_c3  = .10094;  % go trials fit value
%                             vIGX0_c4  = .17232;  % go trials fit value
%                             vIGX0_c5  = .049037;  % go trials fit value
%                             vIGX0_c6  = .00004;  % go trials fit value
%                             
%                         case 'li'
%                             vIGX0_c1  = 0.0024846;
%                             vIGX0_c2  = 0.050506;
%                             vIGX0_c3  = 0.042773;
%                             vIGX0_c4  = 0.056716;
%                             vIGX0_c5  = 0.0042738;
%                             vIGX0_c6  = 0.031627;
%                             
%                             %                             vIGX0_c1  = 0.008;  % sim from SfN
%                             %                             vIGX0_c2  = 0.008;
%                             %                             vIGX0_c3  = 0.008;
%                             %                             vIGX0_c4  = 0.008;
%                             %                             vIGX0_c5  = 0.008;
%                             %                             vIGX0_c6  = 0.008;
%                             
%                     end
%                     
%                     vIGtg_c1  = 'vIG_c1';
%                     vIGtg_c2  = 'vIG_c2';
%                     vIGtg_c3  = 'vIG_c3';
%                     vIGtg_c4  = 'vIG_c4';
%                     vIGtg_c5  = 'vIG_c5';
%                     vIGtg_c6  = 'vIG_c6';
%                     vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                     vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
% %                                         vIGLB     = 0;
% %                                         vIGUB     = 2;
% %                                         vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
% %                                         vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .076224;
%                         case 'ffi'
%                             vIGX0     = .010766;
%                         case 'li'
%                             vIGX0     = .022178;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
% %                                 vIGLB     = 0;
% %                                 vIGUB     = 2;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.4.1.  units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .33238;
%                         case 'ffi'
%                             vIGX0     = .12564;
%                         case 'li'
%                             vIGX0     = 1.2709;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
% %                                 vIGLB     = 0;
% %                                 vIGUB     = 2;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0_c1  = .19566;
%                             vIGX0_c2  = .19746;
%                             vIGX0_c3  = .24142;
%                             vIGX0_c4  = .31137;
%                             vIGX0_c5  = .2732;
%                             vIGX0_c6  = .16506;
%                             
%                         case 'ffi'
%                             vIGX0_c1  = .31615;
%                             vIGX0_c2  = .33563;
%                             vIGX0_c3  = .2921;
%                             vIGX0_c4  = .52505;
%                             vIGX0_c5  = .28414;
%                             vIGX0_c6  = .22962;
%                             
%                         case 'li'
%                             vIGX0_c1  = 1.0708;
%                             vIGX0_c2  = 1.3001;
%                             vIGX0_c3  = 1.3313;
%                             vIGX0_c4  = 1.3367;
%                             vIGX0_c5  = 1.0411;
%                             vIGX0_c6  = .86583;
%                     end
%                     
%                     vIGtg_c1  = 'vIG_c1';
%                     vIGtg_c2  = 'vIG_c2';
%                     vIGtg_c3  = 'vIG_c3';
%                     vIGtg_c4  = 'vIG_c4';
%                     vIGtg_c5  = 'vIG_c5';
%                     vIGtg_c6  = 'vIG_c6';
%                     
%                     vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                     vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
% %                                         vIGLB     = 0;
% %                                         vIGUB     = 2;
% %                                         vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
% %                                         vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .093119;
%                         case 'ffi'
%                             vIGX0     = .0098093;
%                         case 'li'
%                             vIGX0     = .28539;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
% %                                 vIGLB     = 0;
% %                                 vIGUB     = 2;
%             end % switch lower(condParam)
%             
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             % 1.4.1.  units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .10804;
%                         case 'ffi'
%                             vIGX0     = .59066;
%                         case 'li'
%                             vIGX0     = .090335;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
% %                                 vIGLB     = 0;
% %                                 vIGUB     = 2;
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0_c1  = .032466;
%                             vIGX0_c2  = .0492;
%                             vIGX0_c3  = .076691;
%                             vIGX0_c4  = .074984;
%                             vIGX0_c5  = .039836;
%                             vIGX0_c6  = .035402;
%                             
%                         case 'ffi'
%                             vIGX0_c1  = .0065882;
%                             vIGX0_c2  = .02232;
%                             vIGX0_c3  = .098583;
%                             vIGX0_c4  = .07127;
%                             vIGX0_c5  = .013416;
%                             vIGX0_c6  = .0038145;
%                             
%                         case 'li'
%                             vIGX0_c1  = .008698;
%                             vIGX0_c2  = .040879;
%                             vIGX0_c3  = .075929;
%                             vIGX0_c4  = .072076;
%                             vIGX0_c5  = .024561;
%                             vIGX0_c6  = .029747;
%                             
%                     end
%                     
%                     vIGtg_c1  = 'vIG_c1';
%                     vIGtg_c2  = 'vIG_c2';
%                     vIGtg_c3  = 'vIG_c3';
%                     vIGtg_c4  = 'vIG_c4';
%                     vIGtg_c5  = 'vIG_c5';
%                     vIGtg_c6  = 'vIG_c6';
%                     vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                     vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
% %                                         vIGLB     = 0;
% %                                         vIGUB     = 2;
% %                                         vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
% %                                         vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             vIGX0     = .17703;
%                         case 'ffi'
%                             vIGX0     = .015412;
%                         case 'li'
%                             vIGX0     = .10903;
%                     end
%                     vIGtg     = 'vIG';
%                     vIGLB = (1-boundDistGo)*vIGX0;
%                     vIGUB = (1+boundDistGo)*vIGX0;
% %                                 vIGLB     = 0;
% %                                 vIGUB     = 2;
%             end % switch lower(condParam)
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.5. Non-decision time (t0)                                           ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.5.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0_c1  = 50.369;
%                             t0GX0_c2  = 34.441;
%                             t0GX0_c3  = 35.647;
%                             t0GX0_c4  = 65.778;
%                             t0GX0_c5  = 64.364;
%                             t0GX0_c6  = 68.535;
%                             
%                         case 'ffi'
%                             t0GX0_c1  = 54.404;
%                             t0GX0_c2  = 48.254;
%                             t0GX0_c3  = 52.689;
%                             t0GX0_c4  = 54.14;
%                             t0GX0_c5  = 53.85;
%                             t0GX0_c6  = 55.831;
%                             
%                         case 'li'
%                             t0GX0_c1  = 30.712;
%                             t0GX0_c2  = 45.775;
%                             t0GX0_c3  = 31.692;
%                             t0GX0_c4  = 23.198;
%                             t0GX0_c5  = 44.765;
%                             t0GX0_c6  = 28.743;
%                     end
%                     
%                     t0Gtg_c1  = 't0G_c1';
%                     t0Gtg_c2  = 't0G_c2';
%                     t0Gtg_c3  = 't0G_c3';
%                     t0Gtg_c4  = 't0G_c4';
%                     t0Gtg_c5  = 't0G_c5';
%                     t0Gtg_c6  = 't0G_c6';
%                     t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
%                     t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
% %                                 t0GLB     = 20;
% %                                 t0GUB     = 70;
% %                                 t0GLB     = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
% %                                 t0GUB     = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 65.888;
%                         case 'ffi'
%                             t0GX0     = 69.967;
%                         case 'li'
%                             t0GX0     = 68.385;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
% %                                         t0GLB     = 20;
% %                                         t0GUB     = 70;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 67.843;
%                         case 'ffi'
%                             t0GX0     = 69.084;
%                         case 'li'
%                             t0GX0     = 63.217;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
% %                                         t0GLB     = 20;
% %                                         t0GUB     = 70;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.5.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%             end
%             
%             t0Stg     = 't0S';
% %             t0SLB = (1-boundDistStop)*t0SX0;
% %             t0SUB = (1+boundDistStop)*t0SX0;
%                         t0SLB     = 20;
%                         t0SUB     = 70;
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.5.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0_c1  = 50.168;
%                             t0GX0_c2  = 63.643;
%                             t0GX0_c3  = 68.949;
%                             t0GX0_c4  = 69.687;
%                             t0GX0_c5  = 45.846;
%                             t0GX0_c6  = 42.295;
%                             
%                         case 'ffi'
%                             t0GX0_c1  = 61.736;
%                             t0GX0_c2  = 54.372;
%                             t0GX0_c3  = 63.573;
%                             t0GX0_c4  = 53.172;
%                             t0GX0_c5  = 53.019;
%                             t0GX0_c6  = 58.574;
%                             
%                         case 'li'
%                             t0GX0_c1  = 50.171;
%                             t0GX0_c2  = 50.168;
%                             t0GX0_c3  = 50.242;
%                             t0GX0_c4  = 49.911;
%                             t0GX0_c5  = 50.15;
%                             t0GX0_c6  = 56.799;
%                     end
%                     
%                     t0Gtg_c1  = 't0G_c1';
%                     t0Gtg_c2  = 't0G_c2';
%                     t0Gtg_c3  = 't0G_c3';
%                     t0Gtg_c4  = 't0G_c4';
%                     t0Gtg_c5  = 't0G_c5';
%                     t0Gtg_c6  = 't0G_c6';
%                     t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
%                     t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
% %                                 t0GLB     = 20;
% %                                 t0GUB     = 70;
% %                                 t0GLB     = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
% %                                 t0GUB     = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 46.865;
%                         case 'ffi'
%                             t0GX0     = 59.96;
%                         case 'li'
%                             t0GX0     = 32.48;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
% %                                         t0GLB     = 20;
% %                                         t0GUB     = 70;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 66.661;
%                         case 'ffi'
%                             t0GX0     = 67.688;
%                         case 'li'
%                             t0GX0     = 28.339;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
% %                                         t0GLB     = 20;
% %                                         t0GUB     = 70;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.5.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%             end
%             
%             t0Stg     = 't0S';
% %             t0SLB = (1-boundDistStop)*t0SX0;
% %             t0SUB = (1+boundDistStop)*t0SX0;
%                         t0SLB     = 20;
%                         t0SUB     = 70;
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             % 1.5.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0_c1  = 79.064;
%                             t0GX0_c2  = 89.715;
%                             t0GX0_c3  = 67.494;
%                             t0GX0_c4  = 90.208;
%                             t0GX0_c5  = 76.431;
%                             t0GX0_c6  = 60.858;
%                             
%                         case 'ffi'
%                             t0GX0_c1  = 30.6;
%                             t0GX0_c2  = 63.893;
%                             t0GX0_c3  = 57.746;
%                             t0GX0_c4  = 98.705;
%                             t0GX0_c5  = 85.391;
%                             t0GX0_c6  = 99.088;
%                             
%                         case 'li'
%                             t0GX0_c1  = 84.473;
%                             t0GX0_c2  = 92.465;
%                             t0GX0_c3  = 76.324;
%                             t0GX0_c4  = 82.904;
%                             t0GX0_c5  = 60.61;
%                             t0GX0_c6  = 63.663;
%                     end
%                     
%                     t0Gtg_c1  = 't0G_c1';
%                     t0Gtg_c2  = 't0G_c2';
%                     t0Gtg_c3  = 't0G_c3';
%                     t0Gtg_c4  = 't0G_c4';
%                     t0Gtg_c5  = 't0G_c5';
%                     t0Gtg_c6  = 't0G_c6';
%                     
%                     t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
%                     t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
% %                                 t0GLB     = 20;
% %                                 t0GUB     = 100;
% %                                 t0GLB     = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
% %                                 t0GUB     = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 59.755;
%                         case 'ffi'
%                             t0GX0     = 68.839;
%                         case 'li'
%                             t0GX0     = 66.726;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
% %                                         t0GLB     = 20;
% %                                         t0GUB     = 70;
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0GX0     = 49.116;
%                         case 'ffi'
%                             t0GX0     = 69.897;
%                         case 'li'
%                             t0GX0     = 64.224;
%                     end
%                     t0Gtg     = 't0G';
%                     t0GLB = (1-boundDistGo)*t0GX0;
%                     t0GUB = (1+boundDistGo)*t0GX0;
% %                                         t0GLB     = 20;
% %                                         t0GUB     = 70;
%             end % switch lower(condParam)
%             
%             
%             
%             
%             % 1.5.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             t0SX0      = 40;
%                         case 'ffi'
%                             t0SX0      = 40;
%                         case 'li'
%                             t0SX0      = 40;
%                     end
%             end
%             
%             t0Stg     = 't0S';
% %             t0SLB = (1-boundDistStop)*t0SX0;
% %             t0SUB = (1+boundDistStop)*t0SX0;
%                         t0SLB     = 20;
%                         t0SUB     = 200;
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.6. Extrinsic noise (se)                                             ===================
%     % ============================================================================================
%     seLB      = 0;
%     seUB      = 0;
%     seX0      = 0;
%     setg      = 'se';
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.7. Intrinsic noise (si)                                             ===================
%     % ============================================================================================
%     switch iSubj
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.7384; 
%                         case 'ffi'
%                             siX0      = 1.8236;
%                         case 'li'
%                             siX0      = 2.097;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 2.3447; 
%                         case 'ffi'
%                             siX0      = 2.4549;
%                         case 'li'
%                             siX0      = 1.3074;
%                             %                             siX0      = 1.2; % sim from SfN
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 2.4958;
%                         case 'ffi'
%                             siX0      = 2.2352;
%                         case 'li'
%                             siX0      = 1.3814;
%                     end
%             end
%             sitg      = 'si';
%                         siLB = siX0;
%                         siUB = siX0;
% %             siLB      = .2;
% %             siUB      = 2.5;
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 2.4676;
%                         case 'ffi'
%                             siX0      = 2.4954;
%                         case 'li'
%                             siX0      = 1.7442;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.9596;
%                         case 'ffi'
%                             siX0      = 2.3322;
%                         case 'li'
%                             siX0      = 1.3384;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.1386;
%                         case 'ffi'
%                             siX0      = 2.0163;
%                         case 'li'
%                             siX0      = 2.4733;
%                     end
%             end
%             sitg      = 'si';
%                         siLB = siX0;
%                         siUB = siX0;
% %             siLB      = .2;
% %             siUB      = 2.5;
% 
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.7573;
%                         case 'ffi'
%                             siX0      = 2.3594;
%                         case 'li'
%                             siX0      = 1.2971;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 1.0132;
%                         case 'ffi'
%                             siX0      = 1.7927;
%                         case 'li'
%                             siX0      = .90155;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             siX0      = 2.364;
%                         case 'ffi'
%                             siX0      = 1.6079;
%                         case 'li'
%                             siX0      = 1.8876;
%                     end
%             end
%             sitg      = 'si';
%                         siLB = siX0;
%                         siUB = siX0;
% %             siLB      = .2;
% %             siUB      = 2.5;
% 
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.8. Leakage constant (k)                                             ===================
%     % ============================================================================================
%     
%     % 1.8.1. GO units
%     % -------------------------------------------------------------------------
%     kGX0 = -realmin;
%     kGtg = 'kG';
%     kGLB = -realmin;
%     kGUB = -realmin; % Note: this should not be 0 to satisfy non-linear constraints
%     
%     % 1.8.2. STOP unit
%     % -------------------------------------------------------------------------
%     kSX0 = -realmin;
%     kStg = 'kS';
%     kSLB = -realmin;
%     kSUB = -realmin; % Note: this should not be 0 to satisfy non-linear constraints
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ============================================================================================
%     % 1.9. Lateral inhibition weight (w)                                    ===================
%     % ============================================================================================
%     
%     switch iSubj
%         
%         case 'broca'
%             % #####################################################
%             %                                               BROCA
%             % #####################################################
%             % 1.9.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(choiceMechType)
%                 case 'li'
%                     switch lower(condParam)
%                         case 't0'
%                             wGX0      = -1.1427;
%                         case 'v'
%                             wGX0      = -2.65;
%                             %                     wGX0      = -.005; % from SfN simulations
%                         case 'zc'
%                             wGX0      = -2.0519;
%                     end
%                     wGUB = (1-boundDistGo)*wGX0;
%                     wGLB = (1+boundDistGo)*wGX0;
% %                           wGLB      = -4;
% %                           wGUB      = 0;
%                 case {'race','ffi'}
%                     wGX0      = 0;
%                     wGLB      = 0;
%                     wGUB      = 0;
%             end
%             wGtg      = 'wG';
%             
%             
%             % 1.9.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -1.5553;
%                         case 'ffi'
%                             wSX0      = -.50919;
%                         case 'li'
%                             wSX0      = -.90838;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -1.8923;
%                         case 'ffi'
%                             wSX0      = -1.2838;
%                         case 'li'
%                             wSX0      = -.52669;
%                             %                             wSX0      = -.8; % from SfN simulations
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.30985;
%                         case 'ffi'
%                             wSX0      = -.12857;
%                         case 'li'
%                             wSX0      = -.31559;
%                     end
%             end
%             
%             wStg      = 'wS';
% %             wSLB = (1+boundDistStop)*wSX0;
% %             wSUB = (1-boundDistStop)*wSX0;
%                         wSLB      = -4;
%                         wSUB      = 0;
%             
%             
%             
%             
%         case 'xena'
%             % ######################################################
%             %                                               XENA
%             % ######################################################
%             % 1.9.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(choiceMechType)
%                 case 'li'
%                     switch lower(condParam)
%                         case 't0'
%                             wGX0      = -3.5402;
%                         case 'v'
%                             wGX0      = -1.8711;
%                         case 'zc'
%                             wGX0      = -.46108;
%                     end
%                     wGUB = (1-boundDistGo)*wGX0;
%                     wGLB = (1+boundDistGo)*wGX0;
% %                           wGLB      = -4;
% %                           wGUB      = 0;
%                 case {'race','ffi'}
%                     wGX0      = 0;
%                     wGLB      = 0;
%                     wGUB      = 0;
%             end
%             wGtg      = 'wG';
%             
%             
%             % 1.9.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.39507;
%                         case 'ffi'
%                             wSX0      = -3.1456;
%                         case 'li'
%                             wSX0      = -1.479;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.31858;
%                         case 'ffi'
%                             wSX0      = -2.7771;
%                         case 'li'
%                             wSX0      = -.078722;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.34189;
%                         case 'ffi'
%                             wSX0      = -1.167;
%                         case 'li'
%                             wSX0      = -.79117;
%                     end
%             end
%             
%             wStg      = 'wS';
% %             wSLB = (1+boundDistStop)*wSX0;
% %             wSUB = (1-boundDistStop)*wSX0;
%                         wSLB      = -4;
%                         wSUB      = 0;
%             
%             
%             
%         case 'human'
%             % #####################################################
%             %                                               HUMAN
%             % #####################################################
%             % 1.9.1. GO units
%             % -------------------------------------------------------------------------
%             switch lower(choiceMechType)
%                 case 'li'
%                     switch lower(condParam)
%                         case 't0'
%                             wGX0      = -4.6242;
%                         case 'v'
%                             wGX0      = -.51532;
%                         case 'zc'
%                             wGX0      = -.87632;
%                     end
%                     wGUB = (1-boundDistGo)*wGX0;
%                     wGLB = (1+boundDistGo)*wGX0;
% %                           wGLB      = -4;
% %                           wGUB      = 0;
%                 case {'race','ffi'}
%                     wGX0      = 0;
%                     wGLB      = 0;
%                     wGUB      = 0;
%             end
%             wGtg      = 'wG';
%             
%             
%             % 1.9.2. STOP unit
%             % -------------------------------------------------------------------------
%             switch lower(condParam)
%                 case 't0'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.6073;
%                         case 'ffi'
%                             wSX0      = -3.725;
%                         case 'li'
%                             wSX0      = -2.0568;
%                     end
%                 case 'v'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -1.2212;
%                         case 'ffi'
%                             wSX0      = -.93407;
%                         case 'li'
%                             wSX0      = -.1184;
%                     end
%                 case 'zc'
%                     switch choiceMechType
%                         case 'race'
%                             wSX0      = -.46434;
%                         case 'ffi'
%                             wSX0      = -1.189;
%                         case 'li'
%                             wSX0      = -3.9082;
%                     end
%             end
%             
%             wStg      = 'wS';
% %             wSLB = (1+boundDistStop)*wSX0;
% %             wSUB = (1-boundDistStop)*wSX0;
%                         wSLB      = -4;
%                         wSUB      = 0;
%             
%     end
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     % ----------||||||||||||----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
% elseif noiseBound && tBound
    

elseif noiseBound && tBound

    
%     switch iSubj
%         case 'broca'
%             boundDistGo = .3;
%             boundDistStop = .3;
%         case 'xena'
%             boundDistGo = .3;
%             boundDistStop = .3;
%         case 'human'
%             boundDistGo = .3;
%             boundDistStop = .3;
%     end
    switch iSubj
        case 'broca'
            boundDistGo = .7;
            boundDistStop = .7;
        case 'xena'
            boundDistGo = .7;
            boundDistStop = .7;
        case 'human'
            boundDistGo = .7;
            boundDistStop = .7;
    end
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1. SET LB, UB, X0 VALUES
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    % ============================================================================================
    % 1.1. Starting value (z0)                                              ===================
    % ============================================================================================
    
    switch iSubj
        
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 86.663;
                        case 'ffi'
                            z0GX0     = .27432;
                        case 'li'
                            z0GX0     = 99.988;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 9.3013;
                        case 'ffi'
                            z0GX0     = .40078;
                        case 'li'
                            z0GX0     = 6.1014;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 5.6111;
                        case 'ffi'
                            z0GX0     = 1.601;
                        case 'li'
                            z0GX0     = 106.34;
                    end
            end
            
            % Go bounds
            z0Gtg     = 'z0G';
            z0GLB = (1-boundDistGo)*z0GX0;
            z0GUB = (1+boundDistGo)*z0GX0;
%             z0GLB     = 0;
%             z0GUB     = 30;
            
            
            
            % 1.1.2. STOP unit
            % -------------------------------------------------------------------------
            z0SX0     = 1;
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 6.3669;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
            end
            
            
            % Stop bounds
            z0Stg     = 'z0S';
%             z0SLB = (1-boundDistStop)*z0SX0;
%             z0SUB = (1+boundDistStop)*z0SX0;
                        z0SLB     = 0;
                        z0SUB     = 30;
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 13.111;
                        case 'ffi'
                            z0GX0     = .0054574;
                        case 'li'
                            z0GX0     = 96.212;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 22.669;
                        case 'ffi'
                            z0GX0     = 1.1009;
                        case 'li'
                            z0GX0     = 11.497;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 11.972;
                        case 'ffi'
                            z0GX0     = 22.224;
                        case 'li'
                            z0GX0     = 54.442;
                    end
            end
            
            % Go bounds
            z0Gtg     = 'z0G';
            z0GLB = (1-boundDistGo)*z0GX0;
            z0GUB = (1+boundDistGo)*z0GX0;
            z0GLB     = 0;
            z0GUB     = 30;
            
            
            % 1.1.2. STOP unit
            % -------------------------------------------------------------------------
            z0SX0     = 1;
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
            end
            
            
            % Stop bounds
            z0Stg     = 'z0S';
%             z0SLB = (1-boundDistStop)*z0SX0;
%             z0SUB = (1+boundDistStop)*z0SX0;
                        z0SLB     = 0;
                        z0SUB     = 30;
            
            
            
        case 'human'
            % ############################################################
            %                                                    HUMAN
            % ############################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 6.8444;
                        case 'ffi'
                            z0GX0     = .18543;
                        case 'li'
                            z0GX0     = 84.41;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 11.933;
                        case 'ffi'
                            z0GX0     = 3.1855;
                        case 'li'
                            z0GX0     = 16.791;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0GX0     = 15.192;
                        case 'ffi'
                            z0GX0     = .96643;
                        case 'li'
                            z0GX0     = 18.396;
                    end
            end
            
            % Go bounds
            z0Gtg     = 'z0G';
            z0GLB = (1-boundDistGo)*z0GX0;
            z0GUB = (1+boundDistGo)*z0GX0;
            z0GLB     = 0;
            z0GUB     = 30;
            
            
            
            % 1.1.2. STOP unit
            % -------------------------------------------------------------------------
            z0SX0     = 1;
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            z0SX0     = 01;
                        case 'ffi'
                            z0SX0     = 01;
                        case 'li'
                            z0SX0     = 01;
                    end
            end
            
            
            % Stop bounds
            z0Stg     = 'z0S';
%             z0SLB = (1-boundDistStop)*z0SX0;
%             z0SUB = (1+boundDistStop)*z0SX0;
                        z0SLB     = 0;
                        z0SUB     = 30;
            
            
        otherwise
            disp('sam_get_bnds_pgm.m: the iSubj variable is wrong')
            return
            
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.2. Threshold (zc)                                                   ===================
    % ============================================================================================
    
    switch iSubj
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 112.87;
                        case 'ffi'
                            zcGX0     = 18.157;
                        case 'li'
                            zcGX0     = 131.97;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
                        zcGLB     = 0;
                        zcGUB     = 200;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 43.006;
                        case 'ffi'
                            zcGX0     = 18.432;
                        case 'li'
                            zcGX0     = 38.302;
                            %                             zcGX0     = 30;     % sim from SfN
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
%                         zcGLB     = 0;
%                         zcGUB     = 200;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcGX0_c1  = 26.426;
                            zcGX0_c2  = 26.445;
                            zcGX0_c3  = 27.698;
                            zcGX0_c4  = 30.632;
                            zcGX0_c5  = 33.414;
                            zcGX0_c6  = 31.845;
                        case 'ffi'
                            zcGX0_c1  = 17.022;
                            zcGX0_c2  = 16.327;
                            zcGX0_c3  = 16.99;
                            zcGX0_c4  = 18.712;
                            zcGX0_c5  = 21.368;
                            zcGX0_c6  = 20.917;
                        case 'li'
                            zcGX0_c1  = 169.56;
                            zcGX0_c2  = 168.61;
                            zcGX0_c3  = 194.8;
                            zcGX0_c4  = 174.6;
                            zcGX0_c5  = 212.21;
                            zcGX0_c6  = 206.54;
                    end
                    zcGtg_c1   = 'zcG_c1';
                    zcGtg_c2   = 'zcG_c2';
                    zcGtg_c3   = 'zcG_c3';
                    zcGtg_c4   = 'zcG_c4';
                    zcGtg_c5   = 'zcG_c5';
                    zcGtg_c6   = 'zcG_c6';
                    
                    zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                    zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                                        zcGLB     = 0;
                                        zcGUB     = 200;
                                        zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
                                        zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
            end % switch lower(condParam)
            
            % 1.2.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 83.358;
                            zcSX0     = 40;
                            %                             zcSX0     = 15;   % sim from SfN
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                    end
            end
            
            
            zcStg     = 'zcS';
%             zcSLB = (1-boundDistStop)*zcSX0;
%             zcSUB = (1+boundDistStop)*zcSX0;
                        zcSLB     = 0;
                        zcSUB     = 100;
            
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 62.741;
                        case 'ffi'
                            zcGX0     = 19.682;
                        case 'li'
                            zcGX0     = 168.61;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
                        zcGLB     = 0;
                        zcGUB     = 200;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 100.33;
                        case 'ffi'
                            zcGX0     = 23.14;
                        case 'li'
                            zcGX0     = 95.691;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
                        zcGLB     = 0;
                        zcGUB     = 200;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcGX0_c1  = 52.61;
                            zcGX0_c2  = 55.53;
                            zcGX0_c3  = 53.756;
                            zcGX0_c4  = 51.446;
                            zcGX0_c5  = 51.003;
                            zcGX0_c6  = 50.942;
                        case 'ffi'
                            zcGX0_c1  = 41.69;
                            zcGX0_c2  = 42.967;
                            zcGX0_c3  = 41.96;
                            zcGX0_c4  = 40.434;
                            zcGX0_c5  = 40.932;
                            zcGX0_c6  = 40.187;
                        case 'li'
                            zcGX0_c1  = 200.17;
                            zcGX0_c2  = 207.75;
                            zcGX0_c3  = 213.71;
                            zcGX0_c4  = 179.36;
                            zcGX0_c5  = 198.27;
                            zcGX0_c6  = 194.74;
                    end
                    zcGtg_c1   = 'zcG_c1';
                    zcGtg_c2   = 'zcG_c2';
                    zcGtg_c3   = 'zcG_c3';
                    zcGtg_c4   = 'zcG_c4';
                    zcGtg_c5   = 'zcG_c5';
                    zcGtg_c6   = 'zcG_c6';
                    
                    zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                    zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                                        zcGLB     = 0;
                                        zcGUB     = 200;
                                        zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
                                        zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
            end % switch lower(condParam)
            
            % 1.2.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                            %                             zcSX0     = 15;   % sim from SfN
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                    end
            end
            
            
            zcStg     = 'zcS';
%             zcSLB = (1-boundDistStop)*zcSX0;
%             zcSUB = (1+boundDistStop)*zcSX0;
                        zcSLB     = 0;
                        zcSUB     = 100;
            
            
            
            
        case 'human'
            % #####################################################
            %                                               HUMAN
            % #####################################################
            % 1.1.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 88.639;
                        case 'ffi'
                            zcGX0     = 38.116;
                        case 'li'
                            zcGX0     = 87.87;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
                        zcGLB     = 0;
                        zcGUB     = 200;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcGX0     = 81.993;
                        case 'ffi'
                            zcGX0     = 41.796;
                        case 'li'
                            zcGX0     = 74.141;
                    end
                    zcGtg     = 'zcG';
                    zcGLB = (1-boundDistGo)*zcGX0;
                    zcGUB = (1+boundDistGo)*zcGX0;
                        zcGLB     = 0;
                        zcGUB     = 200;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcGX0_c1  = 88.957;
                            zcGX0_c2  = 90.33;
                            zcGX0_c3  = 93.827;
                            zcGX0_c4  = 92.252;
                            zcGX0_c5  = 92.048;
                            zcGX0_c6  = 87.753;
                        case 'ffi'
                            zcGX0_c1  = 43.214;
                            zcGX0_c2  = 41.952;
                            zcGX0_c3  = 36.521;
                            zcGX0_c4  = 37.49;
                            zcGX0_c5  = 41.757;
                            zcGX0_c6  = 41.062;
                        case 'li'
                            zcGX0_c1  = 57.132;
                            zcGX0_c2  = 58.578;
                            zcGX0_c3  = 55.922;
                            zcGX0_c4  = 57.275;
                            zcGX0_c5  = 58.694;
                            zcGX0_c6  = 54.246;
                    end
                    zcGtg_c1   = 'zcG_c1';
                    zcGtg_c2   = 'zcG_c2';
                    zcGtg_c3   = 'zcG_c3';
                    zcGtg_c4   = 'zcG_c4';
                    zcGtg_c5   = 'zcG_c5';
                    zcGtg_c6   = 'zcG_c6';
                    
                    zcGLB = (1-boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                    zcGUB = (1+boundDistGo).*[zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6];
                                        zcGLB     = 0;
                                        zcGUB     = 200;
                                        zcGLB = [zcGLB,zcGLB,zcGLB,zcGLB,zcGLB,zcGLB];
                                        zcGUB = [zcGUB,zcGUB,zcGUB,zcGUB,zcGUB,zcGUB];
            end % switch lower(condParam)
            
            
            % 1.2.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                            %                             zcSX0     = 15;   % sim from SfN
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            zcSX0     = 15;
                        case 'ffi'
                            zcSX0     = 15;
                        case 'li'
                            zcSX0     = 15;
                    end
            end
            
            
            zcStg     = 'zcS';
%             zcSLB = (1-boundDistStop)*zcSX0;
%             zcSUB = (1+boundDistStop)*zcSX0;
                        zcSLB     = 0;
                        zcSUB     = 100;
           
            
    end
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.3. Accumulation rate correct (vCor)                                 ===================
    % ============================================================================================
    
    switch iSubj
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.3.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .13697;
                        case 'ffi'
                            vCGX0     = .42529;
                        case 'li'
                            vCGX0     = 1.3536;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCGX0_c1  = .21568;  % go trials fit value
                            vCGX0_c2  = .20122;  % go trials fit value
                            vCGX0_c3  = .16479;  % go trials fit value
                            vCGX0_c4  = .11333;  % go trials fit value
                            vCGX0_c5  = .13743;  % go trials fit value
                            vCGX0_c6  = .15674;  % go trials fit value
                            
                        case 'ffi'
                            vCGX0_c1  = .38857;  % go trials fit value
                            vCGX0_c2  = .36803;  % go trials fit value
                            vCGX0_c3  = .26571;  % go trials fit value
                            vCGX0_c4  = .3235;  % go trials fit value
                            vCGX0_c5  = .34749;  % go trials fit value
                            vCGX0_c6  = .29034;  % go trials fit value
                            
                        case 'li'
                            vCGX0_c1  = .31661;
                            vCGX0_c2  = .25095;
                            vCGX0_c3  = .24024;
                            vCGX0_c4  = .17239;
                            vCGX0_c5  = .18749;
                            vCGX0_c6  = .21868;
                            
                            
                            
                    end
                    vCGtg_c1  = 'vCG_c1';
                    vCGtg_c2  = 'vCG_c2';
                    vCGtg_c3  = 'vCG_c3';
                    vCGtg_c4  = 'vCG_c4';
                    vCGtg_c5  = 'vCG_c5';
                    vCGtg_c6  = 'vCG_c6';
                    vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
                    vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
%                                                             vCGLB     = 0;
%                                                             vCGUB     = 2;
%                                                             vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
%                                                             vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
                    
                    
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .13146;
                        case 'ffi'
                            vCGX0     = .34553;
                        case 'li'
                            vCGX0     = 1.8642;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
            end % switch lower(condParam)
            
            
            
            
            % 1.3.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .77;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
            end
            vCStg     = 'vCS';
            vCSLB = (1-boundDistStop)*vCSX0;
            vCSUB = (1+boundDistStop)*vCSX0;
%                         vCSLB     = 0;
%                         vCSUB     = 2;
            
            
            
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.3.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .19258;
                        case 'ffi'
                            vCGX0     = .84051;
                        case 'li'
                            vCGX0     = 1.0079;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCGX0_c1  = .32266;
                            vCGX0_c2  = .31963;
                            vCGX0_c3  = .28957;
                            vCGX0_c4  = .2733;
                            vCGX0_c5  = .34648;
                            vCGX0_c6  = .37425;
                            
                        case 'ffi'
                            vCGX0_c1  = .32649;
                            vCGX0_c2  = .42874;
                            vCGX0_c3  = .39223;
                            vCGX0_c4  = .84612;
                            vCGX0_c5  = .44792;
                            vCGX0_c6  = .41052;
                            
                        case 'li'
                            vCGX0_c1  = .98395;
                            vCGX0_c2  = .43555;
                            vCGX0_c3  = .42134;
                            vCGX0_c4  = .54909;
                            vCGX0_c5  = .57322;
                            vCGX0_c6  = .49984;
                            
                    end
                    vCGtg_c1  = 'vCG_c1';
                    vCGtg_c2  = 'vCG_c2';
                    vCGtg_c3  = 'vCG_c3';
                    vCGtg_c4  = 'vCG_c4';
                    vCGtg_c5  = 'vCG_c5';
                    vCGtg_c6  = 'vCG_c6';
                    vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
                    vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
                                                            vCGLB     = 0;
                                                            vCGUB     = 2;
                                                            vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
                                                            vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
                    
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .16365;
                        case 'ffi'
                            vCGX0     = .35317;
                        case 'li'
                            vCGX0     = 1.4021;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
            end % switch lower(condParam)
            
            
            
            
            % 1.3.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
            end
            vCStg     = 'vCS';
            vCSLB = (1-boundDistStop)*vCSX0;
            vCSUB = (1+boundDistStop)*vCSX0;
                        vCSLB     = 0;
                        vCSUB     = 2;
            
            
            
            
            
            
        case 'human'
            % #####################################################
            %                                               HUMAN
            % #####################################################
            % 1.3.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .13377;
                        case 'ffi'
                            vCGX0     = .1011;
                        case 'li'
                            vCGX0     = .1578;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCGX0_c1  = .12448;
                            vCGX0_c2  = .11976;
                            vCGX0_c3  = .10378;
                            vCGX0_c4  = .10212;
                            vCGX0_c5  = .11936;
                            vCGX0_c6  = .13003;
                            
                        case 'ffi'
                            vCGX0_c1  = .084761;
                            vCGX0_c2  = .10289;
                            vCGX0_c3  = .13123;
                            vCGX0_c4  = .12788;
                            vCGX0_c5  = .067776;
                            vCGX0_c6  = .088839;
                            
                        case 'li'
                            vCGX0_c1  = .13872;
                            vCGX0_c2  = .13553;
                            vCGX0_c3  = .12141;
                            vCGX0_c4  = .1234;
                            vCGX0_c5  = .13265;
                            vCGX0_c6  = .14282;
                            
                            
                    end
                    vCGtg_c1  = 'vCG_c1';
                    vCGtg_c2  = 'vCG_c2';
                    vCGtg_c3  = 'vCG_c3';
                    vCGtg_c4  = 'vCG_c4';
                    vCGtg_c5  = 'vCG_c5';
                    vCGtg_c6  = 'vCG_c6';
                    
                    vCGLB = (1-boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
                    vCGUB = (1+boundDistGo).*[vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6];
                                                            vCGLB     = 0;
                                                            vCGUB     = 2;
                                                            vCGLB = [vCGLB,vCGLB,vCGLB,vCGLB,vCGLB,vCGLB];
                                                            vCGUB = [vCGUB,vCGUB,vCGUB,vCGUB,vCGUB,vCGUB];
                    
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCGX0     = .12627;
                        case 'ffi'
                            vCGX0     = .050438;
                        case 'li'
                            vCGX0     = .10719;
                    end
                    vCGtg     = 'vCG';
                    vCGLB = (1-boundDistGo)*vCGX0;
                    vCGUB = (1+boundDistGo)*vCGX0;
                        vCGLB     = 0;
                        vCGUB     = 2;
            end % switch lower(condParam)
            
            
            
            
            % 1.3.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vCSX0     = .55;
                        case 'ffi'
                            vCSX0     = .55;
                        case 'li'
                            vCSX0     = .55;
                    end
            end
            vCStg     = 'vCS';
%             vCSLB = (1-boundDistStop)*vCSX0;
%             vCSUB = (1+boundDistStop)*vCSX0;
                        vCSLB     = 0;
                        vCSUB     = 2;
             
            
            
    end
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.4. Accumulation rate incorrect (vIncor)                             ===================
    % ============================================================================================
    
    switch iSubj
        
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.4.1.  units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .033077;
                        case 'ffi'
                            vIGX0     = .36794;
                        case 'li'
                            vIGX0     = 1.1364;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vIGX0_c1  = .0056359;  % go trials fit value
                            vIGX0_c2  = .068294;  % go trials fit value
                            vIGX0_c3  = .040034;  % go trials fit value
                            vIGX0_c4  = .10248;  % go trials fit value
                            vIGX0_c5  = .10447;  % go trials fit value
                            vIGX0_c6  = .0607;  % go trials fit value
                            
                        case 'ffi'
                            vIGX0_c1  = .28732;  % go trials fit value
                            vIGX0_c2  = .28904;  % go trials fit value
                            vIGX0_c3  = .20514;  % go trials fit value
                            vIGX0_c4  = .28898;  % go trials fit value
                            vIGX0_c5  = .30289;  % go trials fit value
                            vIGX0_c6  = .23122;  % go trials fit value
                            
                        case 'li'
                            vIGX0_c1  = 0.048714;
                            vIGX0_c2  = 0.089504;
                            vIGX0_c3  = 0.10362;
                            vIGX0_c4  = 0.19126;
                            vIGX0_c5  = 0.1082;
                            vIGX0_c6  = 0.046007;
                            
                    end
                    
                    vIGtg_c1  = 'vIG_c1';
                    vIGtg_c2  = 'vIG_c2';
                    vIGtg_c3  = 'vIG_c3';
                    vIGtg_c4  = 'vIG_c4';
                    vIGtg_c5  = 'vIG_c5';
                    vIGtg_c6  = 'vIG_c6';
                    vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
                    vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
%                                         vIGLB     = 0;
%                                         vIGUB     = 2;
%                                         vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
%                                         vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .030343;
                        case 'ffi'
                            vIGX0     = .27713;
                        case 'li'
                            vIGX0     = 1.6245;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
            end % switch lower(condParam)
            
            
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.4.1.  units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .13531;
                        case 'ffi'
                            vIGX0     = .80102;
                        case 'li'
                            vIGX0     = .84882;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vIGX0_c1  = .18241;
                            vIGX0_c2  = .1948;
                            vIGX0_c3  = .24801;
                            vIGX0_c4  = .30616;
                            vIGX0_c5  = .28906;
                            vIGX0_c6  = .22468;
                            
                        case 'ffi'
                            vIGX0_c1  = .24476;
                            vIGX0_c2  = .36441;
                            vIGX0_c3  = .35391;
                            vIGX0_c4  = .84897;
                            vIGX0_c5  = .39817;
                            vIGX0_c6  = .30286;
                            
                        case 'li'
                            vIGX0_c1  = .74575;
                            vIGX0_c2  = .38829;
                            vIGX0_c3  = .39942;
                            vIGX0_c4  = .46719;
                            vIGX0_c5  = .51284;
                            vIGX0_c6  = .15556;
                    end
                    
                    vIGtg_c1  = 'vIG_c1';
                    vIGtg_c2  = 'vIG_c2';
                    vIGtg_c3  = 'vIG_c3';
                    vIGtg_c4  = 'vIG_c4';
                    vIGtg_c5  = 'vIG_c5';
                    vIGtg_c6  = 'vIG_c6';
                    
                    vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
                    vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
                                        vIGLB     = 0;
                                        vIGUB     = 2;
                                        vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
                                        vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .098742;
                        case 'ffi'
                            vIGX0     = .31428;
                        case 'li'
                            vIGX0     = 1.3413;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
            end % switch lower(condParam)
            
            
            
        case 'human'
            % #####################################################
            %                                               HUMAN
            % #####################################################
            % 1.4.1.  units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .074368;
                        case 'ffi'
                            vIGX0     = .061481;
                        case 'li'
                            vIGX0     = .076442;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
                case 'v'
                    switch choiceMechType
                        case 'race'
                            vIGX0_c1  = .030741;
                            vIGX0_c2  = .042672;
                            vIGX0_c3  = .063085;
                            vIGX0_c4  = .061792;
                            vIGX0_c5  = .032773;
                            vIGX0_c6  = .034449;
                            
                        case 'ffi'
                            vIGX0_c1  = .028;
                            vIGX0_c2  = .050527;
                            vIGX0_c3  = .09987;
                            vIGX0_c4  = .096891;
                            vIGX0_c5  = .015977;
                            vIGX0_c6  = .027096;
                            
                        case 'li'
                            vIGX0_c1  = .010856;
                            vIGX0_c2  = .040145;
                            vIGX0_c3  = .069138;
                            vIGX0_c4  = .078481;
                            vIGX0_c5  = .020947;
                            vIGX0_c6  = .013526;
                            
                    end
                    
                    vIGtg_c1  = 'vIG_c1';
                    vIGtg_c2  = 'vIG_c2';
                    vIGtg_c3  = 'vIG_c3';
                    vIGtg_c4  = 'vIG_c4';
                    vIGtg_c5  = 'vIG_c5';
                    vIGtg_c6  = 'vIG_c6';
                    vIGLB = (1-boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
                    vIGUB = (1+boundDistGo).*[vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6];
                                        vIGLB     = 0;
                                        vIGUB     = 2;
                                        vIGLB = [vIGLB,vIGLB,vIGLB,vIGLB,vIGLB,vIGLB];
                                        vIGUB = [vIGUB,vIGUB,vIGUB,vIGUB,vIGUB,vIGUB];
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            vIGX0     = .064655;
                        case 'ffi'
                            vIGX0     = .0090493;
                        case 'li'
                            vIGX0     = .019867;
                    end
                    vIGtg     = 'vIG';
                    vIGLB = (1-boundDistGo)*vIGX0;
                    vIGUB = (1+boundDistGo)*vIGX0;
                                vIGLB     = 0;
                                vIGUB     = 2;
            end % switch lower(condParam)
            
    end
    
    
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.5. Non-decision time (t0)                                           ===================
    % ============================================================================================
    
    switch iSubj
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.5.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0GX0_c1  = 50.418;
                            t0GX0_c2  = 60.806;
                            t0GX0_c3  = 62.567;
                            t0GX0_c4  = 66.808;
                            t0GX0_c5  = 62.545;
                            t0GX0_c6  = 56.862;
                            
                        case 'ffi'
                            t0GX0_c1  = 56.702;
                            t0GX0_c2  = 55.632;
                            t0GX0_c3  = 68.771;
                            t0GX0_c4  = 56.827;
                            t0GX0_c5  = 49.663;
                            t0GX0_c6  = 66.827;
                            
                        case 'li'
                            t0GX0_c1  = 50.285;
                            t0GX0_c2  = 46.07;
                            t0GX0_c3  = 29.529;
                            t0GX0_c4  = 45.88;
                            t0GX0_c5  = 61.395;
                            t0GX0_c6  = 61.854;
                    end
                    
                    t0Gtg_c1  = 't0G_c1';
                    t0Gtg_c2  = 't0G_c2';
                    t0Gtg_c3  = 't0G_c3';
                    t0Gtg_c4  = 't0G_c4';
                    t0Gtg_c5  = 't0G_c5';
                    t0Gtg_c6  = 't0G_c6';
                    t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                    t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                                t0GLB     = 20;
                                t0GUB     = 100;
                                t0GLB     = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
                                t0GUB     = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 42.772;
                        case 'ffi'
                            t0GX0     = 58.778;
                        case 'li'
                            t0GX0     = 43.532;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 60;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 67.163;
                        case 'ffi'
                            t0GX0     = 68.732;
                        case 'li'
                            t0GX0     = 38.007;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 100;
            end % switch lower(condParam)
            
            
            
            
            % 1.5.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 60;
                            t0SX0      = 51;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
            end
            
            t0Stg     = 't0S';
%             t0SLB = (1-boundDistStop)*t0SX0;
%             t0SUB = (1+boundDistStop)*t0SX0;
                        t0SLB     = 25;
                        t0SUB     = 75;
            
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.5.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0GX0_c1  = 50.196;
                            t0GX0_c2  = 54.374;
                            t0GX0_c3  = 52.846;
                            t0GX0_c4  = 50.13;
                            t0GX0_c5  = 47.852;
                            t0GX0_c6  = 53.84;
                            
                        case 'ffi'
                            t0GX0_c1  = 50.227;
                            t0GX0_c2  = 51.689;
                            t0GX0_c3  = 23.399;
                            t0GX0_c4  = 38.371;
                            t0GX0_c5  = 51.654;
                            t0GX0_c6  = 47.399;
                            
                        case 'li'
                            t0GX0_c1  = 42.008;
                            t0GX0_c2  = 27.998;
                            t0GX0_c3  = 33.543;
                            t0GX0_c4  = 22.995;
                            t0GX0_c5  = 42.245;
                            t0GX0_c6  = 49.916;
                    end
                    
                    t0Gtg_c1  = 't0G_c1';
                    t0Gtg_c2  = 't0G_c2';
                    t0Gtg_c3  = 't0G_c3';
                    t0Gtg_c4  = 't0G_c4';
                    t0Gtg_c5  = 't0G_c5';
                    t0Gtg_c6  = 't0G_c6';
                    t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                    t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                                t0GLB     = 20;
                                t0GUB     = 100;
                                t0GLB     = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
                                t0GUB     = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 54.062;
                        case 'ffi'
                            t0GX0     = 52.506;
                        case 'li'
                            t0GX0     = 55.414;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 100;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 57.751;
                        case 'ffi'
                            t0GX0     = 53.111;
                        case 'li'
                            t0GX0     = 33.803;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 100;
            end % switch lower(condParam)
            
            
            
            
            % 1.5.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
            end
            
            t0Stg     = 't0S';
%             t0SLB = (1-boundDistStop)*t0SX0;
%             t0SUB = (1+boundDistStop)*t0SX0;
                        t0SLB     = 20;
                        t0SUB     = 80;
            
            
        case 'human'
            % #####################################################
            %                                               HUMAN
            % #####################################################
            % 1.5.1. GO units
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0GX0_c1  = 50.308;
                            t0GX0_c2  = 64.813;
                            t0GX0_c3  = 69.011;
                            t0GX0_c4  = 68.95;
                            t0GX0_c5  = 41.661;
                            t0GX0_c6  = 33.521;
                            
                        case 'ffi'
                            t0GX0_c1  = 64.449;
                            t0GX0_c2  = 59.349;
                            t0GX0_c3  = 63.602;
                            t0GX0_c4  = 63.89;
                            t0GX0_c5  = 65.806;
                            t0GX0_c6  = 67.005;
                            
                        case 'li'
                             t0GX0_c1  = 39.402;
                            t0GX0_c2  = 56.485;
                            t0GX0_c3  = 42.363;
                            t0GX0_c4  = 52.883;
                            t0GX0_c5  = 41.626;
                            t0GX0_c6  = 55.858;
                    end
                    
                    t0Gtg_c1  = 't0G_c1';
                    t0Gtg_c2  = 't0G_c2';
                    t0Gtg_c3  = 't0G_c3';
                    t0Gtg_c4  = 't0G_c4';
                    t0Gtg_c5  = 't0G_c5';
                    t0Gtg_c6  = 't0G_c6';
                    
                    t0GLB = (1-boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                    t0GUB = (1+boundDistGo).*[t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6];
                                t0GLB     = 20;
                                t0GUB     = 150;
                                t0GLB     = [t0GLB,t0GLB,t0GLB,t0GLB,t0GLB,t0GLB];
                                t0GUB     = [t0GUB,t0GUB,t0GUB,t0GUB,t0GUB,t0GUB];
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 62.22;
                        case 'ffi'
                            t0GX0     = 63.936;
                        case 'li'
                            t0GX0     = 62.195;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 150;
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0GX0     = 60.229;
                        case 'ffi'
                            t0GX0     = 46.932;
                        case 'li'
                            t0GX0     = 63.523;
                    end
                    t0Gtg     = 't0G';
                    t0GLB = (1-boundDistGo)*t0GX0;
                    t0GUB = (1+boundDistGo)*t0GX0;
                                        t0GLB     = 20;
                                        t0GUB     = 150;
            end % switch lower(condParam)
            
            
            
            
            % 1.5.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            t0SX0      = 40;
                        case 'ffi'
                            t0SX0      = 40;
                        case 'li'
                            t0SX0      = 40;
                    end
            end
            
            t0Stg     = 't0S';
            t0SLB = (1-boundDistStop)*t0SX0;
            t0SUB = (1+boundDistStop)*t0SX0;
                        t0SLB     = 20;
                        t0SUB     = 200;
            
    end
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.6. Extrinsic noise (se)                                             ===================
    % ============================================================================================
    seLB      = 0;
    seUB      = 0;
    seX0      = 0;
    setg      = 'se';
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.7. Intrinsic noise (si)                                             ===================
    % ============================================================================================
    siX0      = 1; % go trial fit value
    sitg      = 'si';
    siLB = siX0;
    siUB = siX0;
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.8. Leakage constant (k)                                             ===================
    % ============================================================================================
    
    % 1.8.1. GO units
    % -------------------------------------------------------------------------
    kGX0 = -realmin;
    kGtg = 'kG';
    kGLB = -realmin;
    kGUB = -realmin; % Note: this should not be 0 to satisfy non-linear constraints
    
    % 1.8.2. STOP unit
    % -------------------------------------------------------------------------
    kSX0 = -realmin;
    kStg = 'kS';
    kSLB = -realmin;
    kSUB = -realmin; % Note: this should not be 0 to satisfy non-linear constraints
    
    
    
    
    
    
    
    
    
    
    % ============================================================================================
    % 1.9. Lateral inhibition weight (w)                                    ===================
    % ============================================================================================
    
    switch iSubj
        
        case 'broca'
            % #####################################################
            %                                               BROCA
            % #####################################################
            % 1.9.1. GO units
            % -------------------------------------------------------------------------
            switch lower(choiceMechType)
                case 'li'
                    switch lower(condParam)
                        case 't0'
                            wGX0      = -1.0841;
                        case 'v'
                            wGX0      = -1.198;
%                             wGX0      = -.198;
                        case 'zc'
                            wGX0      = -.74267;
                    end
                    wGUB = (1-boundDistGo)*wGX0;
                    wGLB = (1+boundDistGo)*wGX0;
                             wGLB      = -1.5;
                             wGUB      = -0.2;
                case {'race','ffi'}
                    wGX0      = 0;
                    wGLB      = 0;
                    wGUB      = 0;
            end
            wGtg      = 'wG';
            
            
            % 1.9.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -1.0732;
                        case 'ffi'
                            wSX0      = -.35403;
                        case 'li'
                            wSX0      = -.84984;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -1.1942;
                        case 'ffi'
                            wSX0      = -1.2603;
                        case 'li'
                            wSX0      = -1.0855;
                            %                             wSX0      = -.8; % from SfN simulations
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -.42416;
                        case 'ffi'
                            wSX0      = -.4059;
                        case 'li'
                            wSX0      = -.57464;
                    end
            end
            
            wStg      = 'wS';
%             wSLB = (1+boundDistStop)*wSX0;
%             wSUB = (1-boundDistStop)*wSX0;
                     wSLB      = -1.5;
                     wSUB      = -.5;
            
            
            
            
            
        case 'xena'
            % ######################################################
            %                                               XENA
            % ######################################################
            % 1.9.1. GO units
            % -------------------------------------------------------------------------
            switch lower(choiceMechType)
                case 'li'
                    switch lower(condParam)
                        case 't0'
                            wGX0      = -1.858;
                        case 'v'
                            wGX0      = -4.7949;
                        case 'zc'
                            wGX0      = -.01509;
                    end
                    wGUB = (1-boundDistGo)*wGX0;
                    wGLB = (1+boundDistGo)*wGX0;
                             wGLB      = -4;
                             wGUB      = 0;
                case {'race','ffi'}
                    wGX0      = 0;
                    wGLB      = 0;
                    wGUB      = 0;
            end
            wGtg      = 'wG';
            
            
            % 1.9.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -.68525;
                        case 'ffi'
                            wSX0      = -1.8824;
                        case 'li'
                            wSX0      = -1.0995;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -.6421;
                        case 'ffi'
                            wSX0      = -1.6076;
                        case 'li'
                            wSX0      = -.076495;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -.46355;
                        case 'ffi'
                            wSX0      = -1.1361;
                        case 'li'
                            wSX0      = -1.2786;
                    end
            end
            
            wStg      = 'wS';
%             wSLB = (1+boundDistStop)*wSX0;
%             wSUB = (1-boundDistStop)*wSX0;
                     wSLB      = -4;
                     wSUB      = 0;
            
            
            
            
        case 'human'
            % #####################################################
            %                                               HUMAN
            % #####################################################
            % 1.9.1. GO units
            % -------------------------------------------------------------------------
            switch lower(choiceMechType)
                case 'li'
                    switch lower(condParam)
                        case 't0'
                            wGX0      = -.12526;
                        case 'v'
                            wGX0      = -.10779;
                        case 'zc'
                            wGX0      = -.7984;
                    end
                    wGUB = (1-boundDistGo)*wGX0;
                    wGLB = (1+boundDistGo)*wGX0;
                             wGLB      = -4;
                             wGUB      = 0;
                case {'race','ffi'}
                    wGX0      = 0;
                    wGLB      = 0;
                    wGUB      = 0;
            end
            wGtg      = 'wG';
            
            
            % 1.9.2. STOP unit
            % -------------------------------------------------------------------------
            switch lower(condParam)
                case 't0'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -3.0593;
                        case 'ffi'
                            wSX0      = -2.074;
                        case 'li'
                            wSX0      = -3.3301;
                    end
                case 'v'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -1.1088;
                        case 'ffi'
                            wSX0      = -.56863;
                        case 'li'
                            wSX0      = -1.5529;
                    end
                case 'zc'
                    switch choiceMechType
                        case 'race'
                            wSX0      = -.78283;
                        case 'ffi'
                            wSX0      = -.92364;
                        case 'li'
                            wSX0      = -4.9926;
                    end
            end
            
            wStg      = 'wS';
%             wSLB = (1+boundDistStop)*wSX0;
%             wSUB = (1-boundDistStop)*wSX0;
                     wSLB      = -4;
                     wSUB      = 0;
            
    end
    
    
    
    
    
    
    
    
    
    
    
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    % ----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&----------&&&&&&&&&&&&
    
    
    
    
    
     
    
    
    
    
    
    
    
    
    
    
    
 end



























% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. GENERATE LB, UB, AND X0 VECTORS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(condParam)
    case 't0'
        switch lower(simScope)
            case 'go'
                switch lower(choiceMechType)
                    case 'li'
                        % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                        % L-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
                        % L-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
                        % L-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
                        
                        X0 = [z0GX0,zcGX0,vCGX0,vIGX0,t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6,seX0,siX0,kGX0,wGX0];
                        tg = {z0Gtg,zcGtg,vCGtg,vIGtg,t0Gtg_c1,t0Gtg_c2,t0Gtg_c3,t0Gtg_c4,t0Gtg_c5,t0Gtg_c6,setg,sitg,kGtg,wGtg};
                        
                        switch lower(simGoal)
                            case {'optimize','startvals'}
                                
                                % Bounds
                                % ---------------------------------------------------------
                                LB = [z0GLB,zcGLB,vCGLB,vIGLB,t0GLB,seLB,siLB,kGLB,wGLB];
                                UB = [z0GUB,zcGUB,vCGUB,vIGUB,t0GUB,seUB,siUB,kGUB,wGUB];
                                
                                % Linear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case {'fminsearchcon','fmincon','ga'}
                                        linconA = [1 -1 0 0 0 0 0 0 0 0 0 0 0 0]; % z0G - zcG <= 0
                                        linconB = 0;
                                end
                                
                                % Nonlinear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case 'fminsearchcon'
                                        % Inequality constraints
                                        nonlincon = @(x) x(2) - x(3)./-x(13); % zcG - vCG./-kG <= 0
                                        
                                    case {'fmincon','ga'}
                                        % Inequality and equality constraints
                                        c = @(x) x(2) - x(3) ./ -x(13); % zcG - vCG./-kG <= 0
                                        ceq = @(x) [];
                                        
                                        nonlincon = @(x) deal(c(x),ceq(x));
                                end
                        end
                        
                        
                    case {'race','ffi'}
                        % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                        % R-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % R-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % R-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % F-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % F-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % F-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        
                        X0 = [z0GX0,zcGX0,vCGX0,vIGX0,t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6,seX0,siX0,kGX0];
                        tg = {z0Gtg,zcGtg,vCGtg,vIGtg,t0Gtg_c1,t0Gtg_c2,t0Gtg_c3,t0Gtg_c4,t0Gtg_c5,t0Gtg_c6,setg,sitg,kGtg};
                        
                        switch lower(simGoal)
                            case {'optimize','startvals'}
                                
                                % Bounds
                                % ---------------------------------------------------------
                                LB = [z0GLB,zcGLB,vCGLB,vIGLB,t0GLB,seLB,siLB,kGLB];
                                UB = [z0GUB,zcGUB,vCGUB,vIGUB,t0GUB,seUB,siUB,kGUB];
                                
                                % Linear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case {'fminsearchcon','fmincon','ga'}
                                        linconA = [1 -1 0 0 0 0 0 0 0 0 0 0 0]; % z0G - zcG <= 0
                                        linconB = 0;
                                end
                                
                                % Nonlinear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case 'fminsearchcon'
                                        % Inequality constraints
                                        nonlincon = @(x) x(2) - x(3)./-x(13); % zcG - vCG./-kG <= 0
                                        
                                    case {'fmincon','ga'}
                                        % Inequality and equality constraints
                                        c = @(x) x(2) - x(3)./-x(13); % zcG - vCG./-kG <= 0
                                        ceq = @(x) [];
                                        
                                        nonlincon = @(x) deal(c(x),ceq(x));
                                end
                        end
                end
                
            case 'all'
                switch lower(choiceMechType)
                    case 'li'
                        % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                        % L-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
                        % L-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
                        % L-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
                        
                        X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6,t0SX0,seX0,siX0,kGX0,kSX0,wGX0,wSX0];
                        tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg,vCStg,vIGtg,t0Gtg_c1,t0Gtg_c2,t0Gtg_c3,t0Gtg_c4,t0Gtg_c5,t0Gtg_c6,t0Stg,setg,sitg,kGtg,kStg,wGtg,wStg};
                        
                        switch lower(simGoal)
                            case {'optimize','startvals'}
                                
                                % Bounds
                                % ---------------------------------------------------------
                                
                                LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB,wGLB,wSLB];
                                UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB,wGUB,wSUB];
                                
                                % Linear constraints
                                % ---------------------------------------------------------
                                
                                linconA = [1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG <= 0
                                    0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % z0S - zcS <= 0
                                linconB = [0; ...
                                    0];
                                
                                % Nonlinear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case 'fminsearchcon'
                                        % Inequality constraints
                                        nonlincon = @(x) [x(3) - x(5)./-x(17); ... % zcG - vCG./-kG <= 0
                                            x(4) - x(6)./-x(18)]; % zcS - vCS./-kS <= 0
                                    case {'fmincon','ga'}
                                        % Inequality and equality constraints
                                        c(1) = @(x) [x(3) - x(5)./-x(17); ... % zcG - vCG./-kG <= 0
                                            x(4) - x(6)./-x(18)]; % zcS - vCS./-kS <= 0
                                        ceq = @(x) [];
                                        
                                        nonlincon = @(x) deal(c(x),ceq(x));
                                end
                        end
                        
                    case {'race','ffi'}
                        switch lower(inhibMechType)
                            case 'li'
                                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                                % R-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                                % F-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                                
                                X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6,t0SX0,seX0,siX0,kGX0,kSX0,wGX0,wSX0];
                                tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg,vCStg,vIGtg,t0Gtg_c1,t0Gtg_c2,t0Gtg_c3,t0Gtg_c4,t0Gtg_c5,t0Gtg_c6,t0Stg,setg,sitg,kGtg,kStg,wGtg,wStg};
                                
                                switch lower(simGoal)
                                    case {'optimize','startvals'}
                                        
                                        % Bounds
                                        % -----------------------------------------------------
                                        LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB,wGLB,wSLB];
                                        UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB,wGUB,wSUB];
                                        
                                        % Linear constraints
                                        % -----------------------------------------------------
                                        linconA = [1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG <= 0
                                            0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % z0S - zcS <= 0
                                        linconB = [0; ...
                                            0];
                                        
                                        % Nonlinear constraints
                                        % -----------------------------------------------------
                                        switch lower(solverType)
                                            case 'fminsearchcon'
                                                % Inequality constraints
                                                nonlincon = @(x) [x(3) - x(5)./-x(17); ... % zcG - vCG./-kG <= 0
                                                    x(4) - x(6)./-x(18)]; % zcS - vCS./-kS <= 0
                                            case {'fmincon','ga'}
                                                % Inequality and equality constraints
                                                c(1) = @(x) [x(3) - x(5)./-x(17); ... % zcG - vCG./-kG <= 0
                                                    x(4) - x(6)./-x(18)]; % zcS - vCS./-kS <= 0
                                                ceq = @(x) [];
                                                
                                                nonlincon = @(x) deal(c(x),ceq(x));
                                        end
                                end
                            case {'race','bi'}
                                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                                % R-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                % R-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                % F-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                % F-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                
                                X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0_c1,t0GX0_c2,t0GX0_c3,t0GX0_c4,t0GX0_c5,t0GX0_c6,t0SX0,seX0,siX0,kGX0,kSX0];
                                tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg,vCStg,vIGtg,t0Gtg_c1,t0Gtg_c2,t0Gtg_c3,t0Gtg_c4,t0Gtg_c5,t0Gtg_c6,t0Stg,setg,sitg,kGtg,kStg};
                                switch lower(simGoal)
                                    case {'optimize','startvals'}
                                        
                                        % Bounds
                                        % -----------------------------------------------------
                                        LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB];
                                        UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB];
                                        
                                        % Linear constraints
                                        % -----------------------------------------------------
                                        linconA = [1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG <= 0
                                            0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % z0S - zcS <= 0
                                        linconB = [0; ...
                                            0];
                                        
                                        % Nonlinear constraints
                                        % -----------------------------------------------------
                                        switch lower(solverType)
                                            case 'fminsearchcon'
                                                % Inequality constraints
                                                nonlincon = @(x) [x(3) - x(5)./-x(17); ... % zcG - vCG./-kG <= 0
                                                    x(4) - x(6)./-x(18)]; % zcS - vCS./-kS <= 0
                                            case {'fmincon','ga'}
                                                % Inequality and equality constraints
                                                c(1) = @(x) [x(3) - x(5)./-x(17); ... % zcG - vCG./-kG <= 0
                                                    x(4) - x(6)./-x(18)]; % zcS - vCS./-kS <= 0
                                                ceq = @(x) [];
                                                
                                                nonlincon = @(x) deal(c(x),ceq(x));
                                        end
                                end
                                
                        end
                end
        end
    case 'v'
        switch lower(simScope)
            case 'go'
                switch lower(choiceMechType)
                    case 'li'
                        % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                        % L-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
                        % L-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
                        % L-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
                        
                        X0 = [z0GX0,zcGX0,vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6,vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6,t0GX0,seX0,siX0,kGX0,wGX0];
                        tg = {z0Gtg,zcGtg,vCGtg_c1,vCGtg_c2,vCGtg_c3,vCGtg_c4,vCGtg_c5,vCGtg_c6,vIGtg_c1,vIGtg_c2,vIGtg_c3,vIGtg_c4,vIGtg_c5,vIGtg_c6,t0Gtg,setg,sitg,kGtg,wGtg};
                        
                        switch lower(simGoal)
                            case {'optimize','startvals'}
                                
                                % Bounds
                                % ---------------------------------------------------------
                                LB = [z0GLB,zcGLB,vCGLB,vIGLB,t0GLB,seLB,siLB,kGLB,wGLB];
                                UB = [z0GUB,zcGUB,vCGUB,vIGUB,t0GUB,seUB,siUB,kGUB,wGUB];
                                
                                % Linear constraints
                                % ---------------------------------------------------------
                                linconA = [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % z0G - zcG <= 0
                                linconB = 0;
                                
                                % Nonlinear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case 'fminsearchcon'
                                        % Inequality constraints
                                        nonlincon = @(x) [x(2) - x(3)./-x(18); ... % zcG - vCG_c1./-kG <= 0
                                            x(2) - x(4)./-x(18); ... % zcG - vCG_c2./-kG <= 0
                                            x(2) - x(5)./-x(18); ... % zcG - vCG_c3./-kG <= 0
                                            x(2) - x(6)./-x(18); ... % zcG - vCG_c4./-kG <= 0
                                            x(2) - x(7)./-x(18); ... % zcG - vCG_c5./-kG <= 0
                                            x(2) - x(8)./-x(18)]; ... % zcG - vCG_c6./-kG <= 0
                                    case {'fmincon','ga'}
                                    % Inequality and equality constraints
                                    c = @(x) [x(2) - x(3)./-x(18); ... % zcG - vCG_c1./-kG <= 0
                                        x(2) - x(4)./-x(18); ... % zcG - vCG_c2./-kG <= 0
                                        x(2) - x(5)./-x(18); ... % zcG - vCG_c3./-kG <= 0
                                        x(2) - x(6)./-x(18); ... % zcG - vCG_c4./-kG <= 0
                                        x(2) - x(7)./-x(18); ... % zcG - vCG_c5./-kG <= 0
                                        x(2) - x(8)./-x(18)]; ... % zcG - vCG_c6./-kG <= 0
                                        
                                    ceq = @(x) [];
                                    
                                    nonlincon = @(x) deal(c(x),ceq(x));
                                end
                        end
                        
                    case {'race','ffi'}
                        % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                        % R-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % R-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % R-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % F-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % F-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % F-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        
                        X0 = [z0GX0,zcGX0,vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6,vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6,t0GX0,seX0,siX0,kGX0];
                        tg = {z0Gtg,zcGtg,vCGtg_c1,vCGtg_c2,vCGtg_c3,vCGtg_c4,vCGtg_c5,vCGtg_c6,vIGtg_c1,vIGtg_c2,vIGtg_c3,vIGtg_c4,vIGtg_c5,vIGtg_c6,t0Gtg,setg,sitg,kGtg};
                        
                        switch lower(simGoal)
                            case {'optimize','startvals'}
                                
                                % Bounds
                                % ---------------------------------------------------------
                                LB = [z0GLB,zcGLB,vCGLB,vIGLB,t0GLB,seLB,siLB,kGLB];
                                UB = [z0GUB,zcGUB,vCGUB,vIGUB,t0GUB,seUB,siUB,kGUB];
                                
                                % Linear constraints
                                % ---------------------------------------------------------
                                linconA = [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % z0G - zcG <= 0
                                linconB = 0;
                                
                                % Nonlinear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case 'fminsearchcon'
                                        % Inequality constraints
                                        nonlincon = @(x) [x(2) - x(3)./-x(18); ... % zcG - vCG_c1./-kG <= 0
                                            x(2) - x(4)./-x(18); ... % zcG - vCG_c2./-kG <= 0
                                            x(2) - x(5)./-x(18); ... % zcG - vCG_c3./-kG <= 0
                                            x(2) - x(6)./-x(18); ... % zcG - vCG_c4./-kG <= 0
                                            x(2) - x(7)./-x(18); ... % zcG - vCG_c5./-kG <= 0
                                            x(2) - x(8)./-x(18)]; ... % zcG - vCG_c6./-kG <= 0
                                    case {'fmincon','ga'}
                                    % Inequality and equality constraints
                                    c = @(x) [x(2) - x(3)./-x(18); ... % zcG - vCG_c1./-kG <= 0
                                        x(2) - x(4)./-x(18); ... % zcG - vCG_c2./-kG <= 0
                                        x(2) - x(5)./-x(18); ... % zcG - vCG_c3./-kG <= 0
                                        x(2) - x(6)./-x(18); ... % zcG - vCG_c4./-kG <= 0
                                        x(2) - x(7)./-x(18); ... % zcG - vCG_c5./-kG <= 0
                                        x(2) - x(8)./-x(18)]; ... % zcG - vCG_c6./-kG <= 0
                                        
                                    ceq = @(x) [];
                                    
                                    nonlincon = @(x) deal(c(x),ceq(x));
                                end
                        end
                        
                end
            case 'all'
                switch lower(choiceMechType)
                    case 'li'
                        % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                        % L-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
                        % L-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
                        % L-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
                        
                        X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6,vCSX0,vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6,t0GX0,t0SX0,seX0,siX0,kGX0,kSX0,wGX0,wSX0];
                        tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg_c1,vCGtg_c2,vCGtg_c3,vCGtg_c4,vCGtg_c5,vCGtg_c6,vCStg,vIGtg_c1,vIGtg_c2,vIGtg_c3,vIGtg_c4,vIGtg_c5,vIGtg_c6,t0Gtg,t0Stg,setg,sitg,kGtg,kStg,wGtg,wStg};
                        
                        switch lower(simGoal)
                            case {'optimize','startvals'}
                                
                                % Bounds
                                % ---------------------------------------------------------
                                LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB,wGLB,wSLB];
                                UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB,wGUB,wSUB];
                                
                                % Linear constraints
                                % ---------------------------------------------------------
                                linconA = [1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG <= 0
                                    0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % z0S - zcS <= 0
                                linconB = [0; ...
                                    0];
                                
                                % Nonlinear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case 'fminsearchcon'
                                        % Inequality constraints
                                        nonlincon = @(x) [x(3) - x(5)./-x(22); ... % zcG - vCG_c1./-kG <= 0
                                            x(3) - x(6)./-x(22); ... % zcG - vCG_c2./-kG <= 0
                                            x(3) - x(7)./-x(22); ... % zcG - vCG_c3./-kG <= 0
                                            x(3) - x(8)./-x(22); ... % zcG - vCG_c4./-kG <= 0
                                            x(3) - x(9)./-x(22); ... % zcG - vCG_c5./-kG <= 0
                                            x(3) - x(10)./-x(22); ... % zcG - vCG_c6./-kG <= 0
                                            x(4) - x(11)./-x(23)]; ... % zcS - vCS./-kS <= 0
                                    case {'fmincon','ga'}
                                    % Inequality and equality constraints
                                    c = @(x) [x(3) - x(5)./-x(22); ... % zcG - vCG_c1./-kG <= 0
                                        x(3) - x(6)./-x(22); ... % zcG - vCG_c2./-kG <= 0
                                        x(3) - x(7)./-x(22); ... % zcG - vCG_c3./-kG <= 0
                                        x(3) - x(8)./-x(22); ... % zcG - vCG_c4./-kG <= 0
                                        x(3) - x(9)./-x(22); ... % zcG - vCG_c5./-kG <= 0
                                        x(3) - x(10)./-x(22); ... % zcG - vCG_c6./-kG <= 0
                                        x(4) - x(11)./-x(23)]; ... % zcS - vCS./-kS <= 0
                                        ceq = @(x) [];
                                    
                                    nonlincon = @(x) deal(c(x),ceq(x));
                                end
                        end
                    case {'race','ffi'}
                        switch lower(inhibMechType)
                            case 'li'
                                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                                % R-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                                % F-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                                
                                X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6,vCSX0,vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6,t0GX0,t0SX0,seX0,siX0,kGX0,kSX0,wGX0,wSX0];
                                tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg_c1,vCGtg_c2,vCGtg_c3,vCGtg_c4,vCGtg_c5,vCGtg_c6,vCStg,vIGtg_c1,vIGtg_c2,vIGtg_c3,vIGtg_c4,vIGtg_c5,vIGtg_c6,t0Gtg,t0Stg,setg,sitg,kGtg,kStg,wGtg,wStg};
                                
                                switch lower(simGoal)
                                    case {'optimize','startvals'}
                                        
                                        % Bounds
                                        % -----------------------------------------------------
                                        LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB,wGLB,wSLB];
                                        UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB,wGUB,wSUB];
                                        
                                        % Linear constraints
                                        % -----------------------------------------------------
                                        linconA = [1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG <= 0
                                            0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % z0S - zcS <= 0
                                        linconB = [0; ...
                                            0];
                                        
                                        % Nonlinear constraints
                                        % -----------------------------------------------------
                                        switch lower(solverType)
                                            case 'fminsearchcon'
                                                % Inequality constraints
                                                nonlincon = @(x) [x(3) - x(5)./-x(22); ... % zcG - vCG_c1./-kG <= 0
                                                    x(3) - x(6)./-x(22); ... % zcG - vCG_c2./-kG <= 0
                                                    x(3) - x(7)./-x(22); ... % zcG - vCG_c3./-kG <= 0
                                                    x(3) - x(8)./-x(22); ... % zcG - vCG_c4./-kG <= 0
                                                    x(3) - x(9)./-x(22); ... % zcG - vCG_c5./-kG <= 0
                                                    x(3) - x(10)./-x(22); ... % zcG - vCG_c6./-kG <= 0
                                                    x(4) - x(11)./-x(23)]; ... % zcS - vCS./-kS <= 0
                                            case {'fmincon','ga'}
                                            % Inequality and equality constraints
                                            c = @(x) [x(3) - x(5)./-x(22); ... % zcG - vCG_c1./-kG <= 0
                                                x(3) - x(6)./-x(22); ... % zcG - vCG_c2./-kG <= 0
                                                x(3) - x(7)./-x(22); ... % zcG - vCG_c3./-kG <= 0
                                                x(3) - x(8)./-x(22); ... % zcG - vCG_c4./-kG <= 0
                                                x(3) - x(9)./-x(22); ... % zcG - vCG_c5./-kG <= 0
                                                x(3) - x(10)./-x(22); ... % zcG - vCG_c6./-kG <= 0
                                                x(4) - x(11)./-x(23)]; ... % zcS - vCS./-kS <= 0
                                                ceq = @(x) [];
                                            
                                            nonlincon = @(x) deal(c(x),ceq(x));
                                        end
                                end
                            case {'race','bi'}
                                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                                % R-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                % R-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                % F-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                % F-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                
                                X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0_c1,vCGX0_c2,vCGX0_c3,vCGX0_c4,vCGX0_c5,vCGX0_c6,vCSX0,vIGX0_c1,vIGX0_c2,vIGX0_c3,vIGX0_c4,vIGX0_c5,vIGX0_c6,t0GX0,t0SX0,seX0,siX0,kGX0,kSX0];
                                tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg_c1,vCGtg_c2,vCGtg_c3,vCGtg_c4,vCGtg_c5,vCGtg_c6,vCStg,vIGtg_c1,vIGtg_c2,vIGtg_c3,vIGtg_c4,vIGtg_c5,vIGtg_c6,t0Gtg,t0Stg,setg,sitg,kGtg,kStg};
                                
                                switch lower(simGoal)
                                    case {'optimize','startvals'}
                                        
                                        % Bounds
                                        % -----------------------------------------------------
                                        LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB];
                                        UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB];
                                        
                                        % Linear constraints
                                        % -----------------------------------------------------
                                        linconA = [1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG <= 0
                                            0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % z0S - zcS <= 0
                                        linconB = [0; ...
                                            0];
                                        
                                        % Nonlinear constraints
                                        % -----------------------------------------------------
                                        switch lower(solverType)
                                            case 'fminsearchcon'
                                                % Inequality constraints
                                                nonlincon = @(x) [x(3) - x(5)./-x(19); ... % zcG - vCG_c1./-kG <= 0
                                                    x(3) - x(6)./-x(19); ... % zcG - vCG_c2./-kG <= 0
                                                    x(3) - x(7)./-x(19); ... % zcG - vCG_c3./-kG <= 0
                                                    x(3) - x(8)./-x(19); ... % zcG - vCG_c4./-kG <= 0
                                                    x(3) - x(9)./-x(19); ... % zcG - vCG_c5./-kG <= 0
                                                    x(3) - x(10)./-x(19); ... % zcG - vCG_c6./-kG <= 0
                                                    x(4) - x(11)./-x(20)]; ... % zcS - vCS./-kS <= 0
                                            case {'fmincon','ga'}
                                            % Inequality and equality constraints
                                            c = @(x) [x(3) - x(5)./-x(19); ... % zcG - vCG_c1./-kG <= 0
                                                x(3) - x(6)./-x(19); ... % zcG - vCG_c2./-kG <= 0
                                                x(3) - x(7)./-x(19); ... % zcG - vCG_c3./-kG <= 0
                                                x(3) - x(8)./-x(19); ... % zcG - vCG_c4./-kG <= 0
                                                x(3) - x(9)./-x(19); ... % zcG - vCG_c5./-kG <= 0
                                                x(3) - x(10)./-x(19); ... % zcG - vCG_c6./-kG <= 0
                                                x(4) - x(11)./-x(20)]; ... % zcS - vCS./-kS <= 0
                                                ceq = @(x) [];
                                            
                                            nonlincon = @(x) deal(c(x),ceq(x));
                                        end
                                end
                                
                        end
                end
        end
    case 'zc'
        switch lower(simScope)
            case 'go'
                switch lower(choiceMechType)
                    case 'li'
                        % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                        % L-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
                        % L-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
                        % L-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
                        
                        X0 = [z0GX0,zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6,vCGX0,vIGX0,t0GX0,seX0,siX0,kGX0,wGX0];
                        tg = {z0Gtg,zcGtg_c1,zcGtg_c2,zcGtg_c3,zcGtg_c4,zcGtg_c5,zcGtg_c6,vCGtg,vIGtg,t0Gtg,setg,sitg,kGtg,wGtg};
                        
                        switch lower(simGoal)
                            case {'optimize','startvals'}
                                
                                % Bounds
                                % ---------------------------------------------------------
                                LB = [z0GLB,zcGLB,vCGLB,vIGLB,t0GLB,seLB,siLB,kGLB,wGLB];
                                UB = [z0GUB,zcGUB,vCGUB,vIGUB,t0GUB,seUB,siUB,kGUB,wGUB];
                                
                                % Linear constraints
                                % ---------------------------------------------------------
                                linconA = [1 -1 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c1 <= 0
                                    1 0 -1 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c2 <= 0
                                    1 0 0 -1 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c3 <= 0
                                    1 0 0 0 -1 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c4 <= 0
                                    1 0 0 0 0 -1 0 0 0 0 0 0 0 0; ... % z0G - zcG_c5 <= 0
                                    1 0 0 0 0 0 -1 0 0 0 0 0 0 0]; % z0G - zcG_c6 <= 0
                                linconB = [0; ...
                                    0; ...
                                    0; ...
                                    0; ...
                                    0; ...
                                    0];
                                
                                % Nonlinear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case 'fminsearchcon'
                                        % Inequality constraints
                                        nonlincon = @(x) [x(2) - x(8) ./-x(13); ... % zcG_c1 - vCG./-kG <= 0
                                            x(3) - x(8) ./-x(13); ... % zcG_c2 - vCG./-kG <= 0
                                            x(4) - x(8) ./-x(13); ... % zcG_c3 - vCG./-kG <= 0
                                            x(5) - x(8) ./-x(13); ... % zcG_c4 - vCG./-kG <= 0
                                            x(6) - x(8) ./-x(13); ... % zcG_c5 - vCG./-kG <= 0
                                            x(7) - x(8) ./-x(13)]; % zcG_c6 - vCG./-kG <= 0
                                    case {'fmincon','ga'}
                                        % Inequality and equality constraints
                                        c = @(x) [x(2) - x(8) ./-x(13); ... % zcG_c1 - vCG./-kG <= 0
                                            x(3) - x(8) ./-x(13); ... % zcG_c2 - vCG./-kG <= 0
                                            x(4) - x(8) ./-x(13); ... % zcG_c3 - vCG./-kG <= 0
                                            x(5) - x(8) ./-x(13); ... % zcG_c4 - vCG./-kG <= 0
                                            x(6) - x(8) ./-x(13); ... % zcG_c5 - vCG./-kG <= 0
                                            x(7) - x(8) ./-x(13)]; % zcG_c6 - vCG./-kG <= 0
                                        
                                        ceq = @(x) [];
                                        
                                        nonlincon = @(x) deal(c(x),ceq(x));
                                end
                        end
                        
                    case {'race','ffi'}
                        % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                        % R-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % R-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % R-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % F-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % F-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        % F-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
                        
                        X0 = [z0GX0,zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6,vCGX0,vIGX0,t0GX0,seX0,siX0,kGX0];
                        tg = {z0Gtg,zcGtg_c1,zcGtg_c2,zcGtg_c3,zcGtg_c4,zcGtg_c5,zcGtg_c6,vCGtg,vIGtg,t0Gtg,setg,sitg,kGtg};
                        
                        switch lower(simGoal)
                            case {'optimize','startvals'}
                                
                                % Bounds
                                % ---------------------------------------------------------
                                LB = [z0GLB,zcGLB,vCGLB,vIGLB,t0GLB,seLB,siLB,kGLB];
                                UB = [z0GUB,zcGUB,vCGUB,vIGUB,t0GUB,seUB,siUB,kGUB];
                                
                                % Linear constraints
                                % ---------------------------------------------------------
                                linconA = [1 -1 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c1 <= 0
                                    1 0 -1 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c2 <= 0
                                    1 0 0 -1 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c3 <= 0
                                    1 0 0 0 -1 0 0 0 0 0 0 0 0; ... % z0G - zcG_c4 <= 0
                                    1 0 0 0 0 -1 0 0 0 0 0 0 0; ... % z0G - zcG_c5 <= 0
                                    1 0 0 0 0 0 -1 0 0 0 0 0 0]; % z0G - zcG_c6 <= 0
                                linconB = [0; ...
                                    0; ...
                                    0; ...
                                    0; ...
                                    0; ...
                                    0];
                                
                                % Nonlinear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case 'fminsearchcon'
                                        % Inequality constraints
                                        nonlincon = @(x) [x(2) - x(8) ./-x(13); ... % zcG_c1 - vCG./-kG <= 0
                                            x(3) - x(8) ./-x(13); ... % zcG_c2 - vCG./-kG <= 0
                                            x(4) - x(8) ./-x(13); ... % zcG_c3 - vCG./-kG <= 0
                                            x(5) - x(8) ./-x(13); ... % zcG_c4 - vCG./-kG <= 0
                                            x(6) - x(8) ./-x(13); ... % zcG_c5 - vCG./-kG <= 0
                                            x(7) - x(8) ./-x(13)]; % zcG_c6 - vCG./-kG <= 0
                                    case {'fmincon','ga'}
                                        % Inequality and equality constraints
                                        c = @(x) [x(2) - x(8) ./-x(13); ... % zcG_c1 - vCG./-kG <= 0
                                            x(3) - x(8) ./-x(13); ... % zcG_c2 - vCG./-kG <= 0
                                            x(4) - x(8) ./-x(13); ... % zcG_c3 - vCG./-kG <= 0
                                            x(5) - x(8) ./-x(13); ... % zcG_c4 - vCG./-kG <= 0
                                            x(6) - x(8) ./-x(13); ... % zcG_c5 - vCG./-kG <= 0
                                            x(7) - x(8) ./-x(13)]; % zcG_c6 - vCG./-kG <= 0
                                        
                                        ceq = @(x) [];
                                        
                                        nonlincon = @(x) deal(c(x),ceq(x));
                                end
                        end
                        
                end
            case 'all'
                switch lower(choiceMechType)
                    case 'li'
                        % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                        % L-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
                        % L-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
                        % L-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
                        
                        X0 = [z0GX0,z0SX0,zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0,t0SX0,seX0,siX0,kGX0,kSX0,wGX0,wSX0];
                        tg = {z0Gtg,z0Stg,zcGtg_c1,zcGtg_c2,zcGtg_c3,zcGtg_c4,zcGtg_c5,zcGtg_c6,zcStg,vCGtg,vCStg,vIGtg,t0Gtg,t0Stg,setg,sitg,kGtg,kStg,wGtg,wStg};
                        
                        switch lower(simGoal)
                            case {'optimize','startvals'}
                                
                                % Bounds
                                % ---------------------------------------------------------
                                LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB,wGLB,wSLB];
                                UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB,wGUB,wSUB];
                                
                                % Linear constraints
                                % ---------------------------------------------------------
                                linconA = [1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c1 <= 0
                                    1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c2 <= 0
                                    1 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c3 <= 0
                                    1 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c4 <= 0
                                    1 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c5 <= 0
                                    1 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c6 <= 0
                                    0 1 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0]; % z0S - zcS <= 0
                                linconB = [0; ...
                                    0; ...
                                    0; ...
                                    0; ...
                                    0; ...
                                    0; ...
                                    0];
                                
                                % Nonlinear constraints
                                % ---------------------------------------------------------
                                switch lower(solverType)
                                    case 'fminsearchcon'
                                        % Inequality constraints
                                        nonlincon = @(x) [x(3) - x(10) ./-x(17); ... % zcG_c1 - vCG./-kG <= 0
                                            x(4) - x(10) ./-x(17); ... % zcG_c2 - vCG./-kG <= 0
                                            x(5) - x(10) ./-x(17); ... % zcG_c3 - vCG./-kG <= 0
                                            x(6) - x(10) ./-x(17); ... % zcG_c4 - vCG./-kG <= 0
                                            x(7) - x(10) ./-x(17); ... % zcG_c5 - vCG./-kG <= 0
                                            x(8) - x(10) ./-x(17); ... % zcG_c6 - vCG./-kG <= 0
                                            x(9) - x(11) ./-x(18)]; % zcS - vCS./-kS <= 0
                                    case {'fmincon','ga'}
                                        % Inequality and equality constraints
                                        c = @(x) [x(3) - x(10) ./-x(17); ... % zcG_c1 - vCG./-kG <= 0
                                            x(4) - x(10) ./-x(17); ... % zcG_c2 - vCG./-kG <= 0
                                            x(5) - x(10) ./-x(17); ... % zcG_c3 - vCG./-kG <= 0
                                            x(6) - x(10) ./-x(17); ... % zcG_c4 - vCG./-kG <= 0
                                            x(7) - x(10) ./-x(17); ... % zcG_c5 - vCG./-kG <= 0
                                            x(8) - x(10) ./-x(17); ... % zcG_c6 - vCG./-kG <= 0
                                            x(9) - x(11) ./-x(18)]; % zcS - vCS./-kS <= 0
                                        
                                        ceq = @(x) [];
                                        
                                        nonlincon = @(x) deal(c(x),ceq(x));
                                end
                        end
                        
                    case {'race','ffi'}
                        switch lower(inhibMechType)
                            case 'li'
                                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                                % R-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                                % F-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                                
                                X0 = [z0GX0,z0SX0,zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0,t0SX0,seX0,siX0,kGX0,kSX0,wGX0,wSX0];
                                tg = {z0Gtg,z0Stg,zcGtg_c1,zcGtg_c2,zcGtg_c3,zcGtg_c4,zcGtg_c5,zcGtg_c6,zcStg,vCGtg,vCStg,vIGtg,t0Gtg,t0Stg,setg,sitg,kGtg,kStg,wGtg,wStg};
                                
                                switch lower(simGoal)
                                    case {'optimize','startvals'}
                                        
                                        % Bounds
                                        % -----------------------------------------------------
                                        LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB,wGLB,wSLB];
                                        UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB,wGUB,wSUB];
                                        
                                        % Linear constraints
                                        % -----------------------------------------------------
                                        linconA = [1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c1 <= 0
                                            1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c2 <= 0
                                            1 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c3 <= 0
                                            1 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c4 <= 0
                                            1 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c5 <= 0
                                            1 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c6 <= 0
                                            0 1 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0]; % z0S - zcS <= 0
                                        linconB = [0; ...
                                            0; ...
                                            0; ...
                                            0; ...
                                            0; ...
                                            0; ...
                                            0];
                                        
                                        % Nonlinear constraints
                                        % -----------------------------------------------------
                                        switch lower(solverType)
                                            case 'fminsearchcon'
                                                % Inequality constraints
                                                nonlincon = @(x) [x(3) - x(10) ./-x(17); ... % zcG_c1 - vCG./-kG <= 0
                                                    x(4) - x(10) ./-x(17); ... % zcG_c2 - vCG./-kG <= 0
                                                    x(5) - x(10) ./-x(17); ... % zcG_c3 - vCG./-kG <= 0
                                                    x(6) - x(10) ./-x(17); ... % zcG_c4 - vCG./-kG <= 0
                                                    x(7) - x(10) ./-x(17); ... % zcG_c5 - vCG./-kG <= 0
                                                    x(8) - x(10) ./-x(17); ... % zcG_c6 - vCG./-kG <= 0
                                                    x(9) - x(11) ./-x(18)]; % zcS - vCS./-kS <= 0
                                            case {'fmincon','ga'}
                                                % Inequality and equality constraints
                                                c = @(x) [x(3) - x(10) ./-x(17); ... % zcG_c1 - vCG./-kG <= 0
                                                    x(4) - x(10) ./-x(17); ... % zcG_c2 - vCG./-kG <= 0
                                                    x(5) - x(10) ./-x(17); ... % zcG_c3 - vCG./-kG <= 0
                                                    x(6) - x(10) ./-x(17); ... % zcG_c4 - vCG./-kG <= 0
                                                    x(7) - x(10) ./-x(17); ... % zcG_c5 - vCG./-kG <= 0
                                                    x(8) - x(10) ./-x(17); ... % zcG_c6 - vCG./-kG <= 0
                                                    x(9) - x(11) ./-x(18)]; % zcS - vCS./-kS <= 0
                                                
                                                ceq = @(x) [];
                                                
                                                nonlincon = @(x) deal(c(x),ceq(x));
                                        end
                                end
                            case {'race','bi'}
                                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                                % R-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                % R-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                % F-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                % F-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                                
                                X0 = [z0GX0,z0SX0,zcGX0_c1,zcGX0_c2,zcGX0_c3,zcGX0_c4,zcGX0_c5,zcGX0_c6,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0,t0SX0,seX0,siX0,kGX0,kSX0];
                                tg = {z0Gtg,z0Stg,zcGtg_c1,zcGtg_c2,zcGtg_c3,zcGtg_c4,zcGtg_c5,zcGtg_c6,zcStg,vCGtg,vCStg,vIGtg,t0Gtg,t0Stg,setg,sitg,kGtg,kStg};
                                
                                switch lower(simGoal)
                                    case {'optimize','startvals'}
                                        
                                        % Bounds
                                        % -----------------------------------------------------
                                        LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB];
                                        UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB];
                                        
                                        % Linear constraints
                                        % -----------------------------------------------------
                                        linconA = [1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c1 <= 0
                                            1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c2 <= 0
                                            1 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c3 <= 0
                                            1 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c4 <= 0
                                            1 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c5 <= 0
                                            1 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 0; ... % z0G - zcG_c6 <= 0
                                            0 1 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0]; % z0S - zcS <= 0
                                        linconB = [0; ...
                                            0; ...
                                            0; ...
                                            0; ...
                                            0; ...
                                            0; ...
                                            0];
                                        
                                        % Nonlinear constraints
                                        % -----------------------------------------------------
                                        switch lower(solverType)
                                            case 'fminsearchcon'
                                                % Inequality constraints
                                                nonlincon = @(x) [x(3) - x(10) ./-x(17); ... % zcG_c1 - vCG./-kG <= 0
                                                    x(4) - x(10) ./-x(17); ... % zcG_c2 - vCG./-kG <= 0
                                                    x(5) - x(10) ./-x(17); ... % zcG_c3 - vCG./-kG <= 0
                                                    x(6) - x(10) ./-x(17); ... % zcG_c4 - vCG./-kG <= 0
                                                    x(7) - x(10) ./-x(17); ... % zcG_c5 - vCG./-kG <= 0
                                                    x(8) - x(10) ./-x(17); ... % zcG_c6 - vCG./-kG <= 0
                                                    x(9) - x(11) ./-x(18)]; % zcS - vCS./-kS <= 0
                                            case {'fmincon','ga'}
                                                % Inequality and equality constraints
                                                c = @(x) [x(3) - x(10) ./-x(17); ... % zcG_c1 - vCG./-kG <= 0
                                                    x(4) - x(10) ./-x(17); ... % zcG_c2 - vCG./-kG <= 0
                                                    x(5) - x(10) ./-x(17); ... % zcG_c3 - vCG./-kG <= 0
                                                    x(6) - x(10) ./-x(17); ... % zcG_c4 - vCG./-kG <= 0
                                                    x(7) - x(10) ./-x(17); ... % zcG_c5 - vCG./-kG <= 0
                                                    x(8) - x(10) ./-x(17); ... % zcG_c6 - vCG./-kG <= 0
                                                    x(9) - x(11) ./-x(18)]; % zcS - vCS./-kS <= 0
                                                
                                                ceq = @(x) [];
                                                
                                                nonlincon = @(x) deal(c(x),ceq(x));
                                        end
                                end
                                
                        end
                end
        end
end