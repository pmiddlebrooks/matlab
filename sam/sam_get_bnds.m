function [LB,UB,X0,tg] = sam_get_bnds(choiceMechType,inhibMechType,condParam,simScope)
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
%
% EXAMPLE
% [LB,UB,X0,tg] = sam_get_bnds('race','race','t0','all');
%  
% ......................................................................... 
% Bram Zandbelt, bramzandbelt@gmail.com 
% $Created : Thu 19 Sep 2013 09:48:27 CDT by bram 
% $Modified: Sat 21 Sep 2013 12:03:08 CDT by bram

% CONTENTS 
% 1.SET LB, UB, X0 VALUES
%   1.1.Starting value (z0)
%       1.1.1.GO units
%       1.1.2.STOP unit
%   1.2.Threshold (zc)
%       1.2.1.GO units
%       1.2.2.STOP unit
%   1.3.Accumulation rate correct (vCor)
%       1.3.1.GO units
%       1.3.2.STOP unit
%   1.4.Accumulation rate incorrect (vIncor)
%   1.5.Non-decision time (t0)
%       1.5.1.GO units
%       1.5.2.STOP unit
%   1.6.Extrinsic noise (se)
%   1.7.Intrinsic noise (si)
%   1.8.Leakage constant (k)
%       1.8.1.GO units
%       1.8.2.STOP unit
%   1.9.Lateral inhibition weight (w)
%       1.9.1.GO units
%       1.9.2.STOP unit
% 2. GENERATE LB, UB, AND X0 VECTORS

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 1. SET LB, UB, X0 VALUES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% 1.1. Starting value (z0)
% ========================================================================= 

% 1.1.1. GO units
% -------------------------------------------------------------------------
z0GLB     = 0;
z0GUB     = 200;
z0GX0     = 0;
z0Gtg     = 'z0G';

% 1.1.2. STOP unit
% -------------------------------------------------------------------------
z0SLB     = 0;
z0SUB     = 200;
z0SX0     = 0;
z0Stg     = 'z0S';

% 1.2. Threshold (zc)
% ========================================================================= 

% 1.2.1. GO units
% -------------------------------------------------------------------------
zcGLB     = 0;
zcGUB     = 1000;
zcGX0     = 200;
zcGtg     = 'zcG';

zcGX0_c1  = 100;
zcGX0_c2  = 200;
zcGX0_c3  = 300;
zcGtg_c1   = 'zcG_c1';
zcGtg_c2   = 'zcG_c2';
zcGtg_c3   = 'zcG_c3';

% 1.2.2. STOP unit
% -------------------------------------------------------------------------
zcSLB     = 0;
zcSUB     = 1000;
zcSX0     = 200;
zcStg     = 'zcS';

% 1.3. Accumulation rate correct (vCor)
% ========================================================================= 

% 1.3.1. GO units
% -------------------------------------------------------------------------
vCGLB     = 0;
vCGUB     = 5;
vCGX0     = 1/2;
vCGtg     = 'vCG';

vCGX0_c1  = 1;
vCGX0_c2  = 1/2;
vCGX0_c3  = 1/3;

vCGtg_c1  = 'vCG_c1';
vCGtg_c2  = 'vCG_c2';
vCGtg_c3  = 'vCG_c3';

% 1.3.2. STOP unit
% -------------------------------------------------------------------------
vCSLB     = 0;
vCSUB     = 50;
vCSX0     = 4;
vCStg     = 'vCS';

% 1.4. Accumulation rate incorrect (vIncor)
% ========================================================================= 

% 1.4.1.  units
% -------------------------------------------------------------------------
vIGLB     = 0;
vIGUB     = 5;
vIGX0     = 0.4;
vIGtg     = 'vIG';

% 1.5. Non-decision time (t0)
% ========================================================================= 

% 1.5.1. GO units
% -------------------------------------------------------------------------
t0GLB     = 0;
t0GUB     = 300;
t0GX0     = 200;
t0Gtg     = 't0G';

t0GX0_c1  = 100;
t0GX0_c2  = 200;
t0GX0_c3  = 300;

t0Gtg_c1  = 't0G_c1';
t0Gtg_c2  = 't0G_c2';
t0Gtg_c3  = 't0G_c3';

% 1.5.2. STOP unit
% -------------------------------------------------------------------------
t0SLB     = 0;
t0SUB     = 500;
t0SX0     = 300;

t0Stg     = 't0S';

% 1.6. Extrinsic noise (se)
% ========================================================================= 
seLB      = 0;
seUB      = 0;
seX0      = 0;
setg      = 'se';

% 1.7. Intrinsic noise (si)
% ========================================================================= 
siLB      = 1;
siUB      = 1;
siX0      = 1;
sitg      = 'si';

% 1.8. Leakage constant (k)
% ========================================================================= 

% 1.8.1. GO units
% -------------------------------------------------------------------------
kGLB      = -0.005;
kGUB      = 0;
kGX0      = -0.001;
kGtg      = 'kG';

% 1.8.2. STOP unit
% -------------------------------------------------------------------------
kSLB      = -0.005;
kSUB      = 0;
kSX0      = -0.001;
kStg      = 'kS';

% 1.9. Lateral inhibition weight (w)
% ========================================================================= 

% 1.9.1. GO units
% -------------------------------------------------------------------------
wGLB      = -1;
wGUB      = 0;
wGX0      = -0.02;
wGtg      = 'wG';

% 1.9.2. STOP unit
% -------------------------------------------------------------------------
wSLB      = -1;
wSUB      = 0;
wSX0      = -0.2;
wStg      = 'wS';

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
            
            LB = [z0GLB,zcGLB,vCGLB,vIGLB,t0GLB,t0GLB,t0GLB,seLB,siLB,kGLB,wGLB];
            UB = [z0GUB,zcGUB,vCGUB,vIGUB,t0GUB,t0GUB,t0GUB,seUB,siUB,kGUB,wGUB];
            X0 = [z0GX0,zcGX0,vCGX0,vIGX0,t0GX0_c1,t0GX0_c2,t0GX0_c3,seX0,siX0,kGX0,wGX0];
            tg = {z0Gtg,zcGtg,vCGtg,vIGtg,t0Gtg_c1,t0Gtg_c2,t0Gtg_c3,setg,sitg,kGtg,wGtg};
            
          case {'race','ffi'}
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % R-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            
            LB = [z0GLB,zcGLB,vCGLB,vIGLB,t0GLB,t0GLB,t0GLB,seLB,siLB];
            UB = [z0GUB,zcGUB,vCGUB,vIGUB,t0GUB,t0GUB,t0GUB,seUB,siUB];
            X0 = [z0GX0,zcGX0,vCGX0,vIGX0,t0GX0_c1,t0GX0_c2,t0GX0_c3,seX0,siX0];
            tg = {z0Gtg,zcGtg,vCGtg,vIGtg,t0Gtg_c1,t0Gtg_c2,t0Gtg_c3,setg,sitg};
            
        end        
      case 'all'
        switch lower(choiceMechType)
          case 'li'
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % L-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            
            LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0GLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB,wGLB,wSLB];
            UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0GUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB,wGUB,wSUB];
            X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0_c1,t0GX0_c2,t0GX0_c3,t0SX0,seX0,siX0,kGX0,kSX0,wGX0,wSX0];
            tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg,vCStg,vIGtg,t0Gtg_c1,t0Gtg_c2,t0Gtg_c3,t0Stg,setg,sitg,kGtg,kStg,wGtg,wStg};
            
          case {'race','ffi'}
            switch lower(inhibMechType)
              case 'li'
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                % F-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                
                LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0GLB,t0GLB,t0SLB,seLB,siLB,wGLB,wSLB];
                UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0GUB,t0GUB,t0SUB,seUB,siUB,wGUB,wSUB];
                X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0_c1,t0GX0_c2,t0GX0_c3,t0SX0,seX0,siX0,wGX0,wSX0];
                tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg,vCStg,vIGtg,t0Gtg_c1,t0Gtg_c2,t0Gtg_c3,t0Stg,setg,sitg,wGtg,wStg};
                
              case {'race','bi'}
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % R-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                
                LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0GLB,t0GLB,t0SLB,seLB,siLB];
                UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0GUB,t0GUB,t0SUB,seUB,siUB];
                X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0_c1,t0GX0_c2,t0GX0_c3,t0SX0,seX0,siX0];
                tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg,vCStg,vIGtg,t0Gtg_c1,t0Gtg_c2,t0Gtg_c3,t0Stg,setg,sitg};
                
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
            
            LB = [z0GLB,zcGLB,vCGLB,vCGLB,vCGLB,vIGLB,t0GLB,seLB,siLB,kGLB,wGLB];
            UB = [z0GUB,zcGUB,vCGUB,vCGUB,vCGUB,vIGUB,t0GUB,seUB,siUB,kGUB,wGUB];
            X0 = [z0GX0,zcGX0,vCGX0_c1,vCGX0_c2,vCGX0_c3,vIGX0,t0GX0,seX0,siX0,kGX0,wGX0];
            tg = {z0Gtg,zcGtg,vCGtg_c1,vCGtg_c2,vCGtg_c3,vIGtg,t0Gtg,setg,sitg,kGtg,wGtg};
                        
          case {'race','ffi'}
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % R-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            
            LB = [z0GLB,zcGLB,vCGLB,vCGLB,vCGLB,vIGLB,t0GLB,seLB,siLB];
            UB = [z0GUB,zcGUB,vCGUB,vCGUB,vCGUB,vIGUB,t0GUB,seUB,siUB];
            X0 = [z0GX0,zcGX0,vCGX0_c1,vCGX0_c2,vCGX0_c3,vIGX0,t0GX0,seX0,siX0];
            tg = {z0Gtg,zcGtg,vCGtg_c1,vCGtg_c2,vCGtg_c3,vIGtg,t0Gtg,setg,sitg};
                        
        end        
      case 'all'
        switch lower(choiceMechType)
          case 'li'
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % L-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            
            LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCGLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB,wGLB,wSLB];
            UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCGUB,vCGUB,vCSUB,vIGUB,t0GUB,t0GUB,seUB,siUB,kGUB,kSUB,wGUB,wSUB];
            X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0_c1,vCGX0_c2,vCGX0_c3,vCSX0,vIGX0,t0GX0,t0SX0,seX0,siX0,kGX0,kSX0,wGX0,wSX0];
            tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg_c1,vCGtg_c2,vCGtg_c3,vCStg,vIGtg,t0Gtg,t0Stg,setg,sitg,kGtg,kStg,wGtg,wStg};
            
          case {'race','ffi'}
            switch lower(inhibMechType)
              case 'li'
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                % F-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                
                LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCGLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,wGLB,wSLB];
                UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCGUB,vCGUB,vCSUB,vIGUB,t0GUB,t0GUB,seUB,siUB,wGUB,wSUB];
                X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0_c1,vCGX0_c2,vCGX0_c3,vCSX0,vIGX0,t0GX0,t0SX0,seX0,siX0,wGX0,wSX0];
                tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg_c1,vCGtg_c2,vCGtg_c3,vCStg,vIGtg,t0Gtg,t0Stg,setg,sitg,wGtg,wStg};
                                
              case {'race','bi'}
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % R-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                
                LB = [z0GLB,z0SLB,zcGLB,zcSLB,vCGLB,vCGLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB];
                UB = [z0GUB,z0SUB,zcGUB,zcSUB,vCGUB,vCGUB,vCGUB,vCSUB,vIGUB,t0GUB,t0GUB,seUB,siUB];
                X0 = [z0GX0,z0SX0,zcGX0,zcSX0,vCGX0_c1,vCGX0_c2,vCGX0_c3,vCSX0,vIGX0,t0GX0,t0SX0,seX0,siX0];
                tg = {z0Gtg,z0Stg,zcGtg,zcStg,vCGtg_c1,vCGtg_c2,vCGtg_c3,vCStg,vIGtg,t0Gtg,t0Stg,setg,sitg};
                
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
            
            LB = [z0GLB,zcGLB,zcGLB,zcGLB,vCGLB,vIGLB,t0GLB,seLB,siLB,kGLB,wGLB];
            UB = [z0GUB,zcGUB,zcGUB,zcGUB,vCGUB,vIGUB,t0GUB,seUB,siUB,kGUB,wGUB];
            X0 = [z0GX0,zcGX0_c1,zcGX0_c2,zcGX0_c3,vCGX0,vIGX0,t0GX0,seX0,siX0,kGX0,wGX0];
            tg = {z0Gtg,zcGtg_c1,zcGtg_c2,zcGtg_c3,vCGtg,vIGtg,t0Gtg,setg,sitg,kGtg,wGtg};
            
          case {'race','ffi'}
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % R-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            
            LB = [z0GLB,zcGLB,zcGLB,zcGLB,vCGLB,vIGLB,t0GLB,seLB,siLB];
            UB = [z0GUB,zcGUB,zcGUB,zcGUB,vCGUB,vIGUB,t0GUB,seUB,siUB];
            X0 = [z0GX0,zcGX0_c1,zcGX0_c2,zcGX0_c3,vCGX0,vIGX0,t0GX0,seX0,siX0];
            tg = {z0Gtg,zcGtg_c1,zcGtg_c2,zcGtg_c3,vCGtg,vIGtg,t0Gtg,setg,sitg};
            
        end        
      case 'all'
        switch lower(choiceMechType)
          case 'li'
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % L-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            
            LB = [z0GLB,z0SLB,zcGLB,zcGLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,kGLB,kSLB,wGLB,wSLB];
            UB = [z0GUB,z0SUB,zcGUB,zcGUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,kGUB,kSUB,wGUB,wSUB];
            X0 = [z0GX0,z0SX0,zcGX0_c1,zcGX0_c2,zcGX0_c3,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0,t0SX0,seX0,siX0,kGX0,kSX0,wGX0,wSX0];
            tg = {z0Gtg,z0Stg,zcGtg_c1,zcGtg_c2,zcGtg_c3,zcStg,vCGtg,vCStg,vIGtg,t0Gtg,t0Stg,setg,sitg,kGtg,kStg,wGtg,wStg};
            
          case {'race','ffi'}
            switch lower(inhibMechType)
              case 'li'
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                % F-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                
                LB = [z0GLB,z0SLB,zcGLB,zcGLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB,wGLB,wSLB];
                UB = [z0GUB,z0SUB,zcGUB,zcGUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB,wGUB,wSUB];
                X0 = [z0GX0,z0SX0,zcGX0_c1,zcGX0_c2,zcGX0_c3,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0,t0SX0,seX0,siX0,wGX0,wSX0];
                tg = {z0Gtg,z0Stg,zcGtg_c1,zcGtg_c2,zcGtg_c3,zcStg,vCGtg,vCStg,vIGtg,t0Gtg,t0Stg,setg,sitg,wGtg,wStg};
                
              case {'race','bi'}
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % R-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                
                LB = [z0GLB,z0SLB,zcGLB,zcGLB,zcGLB,zcSLB,vCGLB,vCSLB,vIGLB,t0GLB,t0SLB,seLB,siLB];
                UB = [z0GUB,z0SUB,zcGUB,zcGUB,zcGUB,zcSUB,vCGUB,vCSUB,vIGUB,t0GUB,t0SUB,seUB,siUB];
                X0 = [z0GX0,z0SX0,zcGX0_c1,zcGX0_c2,zcGX0_c3,zcSX0,vCGX0,vCSX0,vIGX0,t0GX0,t0SX0,seX0,siX0];
                tg = {z0Gtg,z0Stg,zcGtg_c1,zcGtg_c2,zcGtg_c3,zcStg,vCGtg,vCStg,vIGtg,t0Gtg,t0Stg,setg,sitg};
                                
            end
        end
    end
end