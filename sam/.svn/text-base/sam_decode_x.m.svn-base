function [A,B,C,D,V,SE,SI,Z0,ZC,accumOns] = ...
sam_decode_x(SAM,X,stimOns,stimDur,N,M,VCor,VIncor,S) 
% SAM_DECODE_X <Synopsis of what this function does> 
%  
% DESCRIPTION 
% <Describe more extensively what this function does> 
%  
% SYNTAX 
% SAM_DECODE_X; 
%  
% EXAMPLES 
%  
%  
% REFERENCES 
%  
% ......................................................................... 
% Bram Zandbelt, bramzandbelt@gmail.com 
% $Created : Fri 23 Aug 2013 11:47:36 CDT by bram 
% $Modified: Fri 23 Aug 2013 11:47:36 CDT by bram 

 
% CONTENTS 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. PROCESS INPUTS AND SPECIFY VARIABLES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1.1. Process inputs
% =========================================================================

% Choice mechanism type
choiceMechType = SAM.des.choiceMech.type;

% Inhibition mechanism type
inhibMechType = SAM.des.inhibMech.type;

% Parameter that varies across task conditions
condParam = SAM.des.condParam;

% Scope of the simulation
simScope = SAM.sim.scope;

% Number of conditions
nCnd = SAM.des.expt.nCnd;

% Indices of GO inputs, per condition
iGO = SAM.des.iGO;


% #.#. Specify dynamic variables
% ========================================================================= 

trueN = arrayfun(@(x) true(x,1),N,'Uni',0);
trueM = arrayfun(@(x) true(x,1),M,'Uni',0);
 
% 
% ------------------------------------------------------------------------- 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% #. CONVERT X TO INDIVIDUAL PARAMETERS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% PARAMETERS
%z0G  - starting point of GO units
%z0S  - starting point of STOP unit
%zcG  - threshold of GO units
%zcS  - threshold of STOP unit
%vCG  - go-signal accumulation rate to target GO unit
%vCS  - stop-signal accumulation rate to STOP unit
%vIG  - go-signal accumulation rate to non-target GO units
%t0G  - go-signal non-decision time
%t0S  - stop-signal non-decision time
%se   - extrinsic noise level
%si   - intrinsic noise level
%kG   - GO unit leakage constant
%kS   - STOP unit leakage constant
%wG   - lateral inhibition exerted by GO unit
%wS   - lateral inhibition exerted by STOP unit

% MODEL
% 1. Choice mechanism           - race (R), feed-forward inhibition (F), or 
%                                 lateral inhibition (L)
% 2. Inhibition mechanism       - race (R), blocked input (B), or lateral
%                                 inhibition (L)
% 3. Task condition parameter   - non-decision time (T0), accumulation rate
%                                 (V), or threshold (Zc)
% 4. Optimization scope         - go trials (G), or go and stop trials (A)

% -------------------------------------------------------------------------
%             |                         Parameter                         |
% -------------------------------------------------------------------------
% Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
% -------------------------------------------------------------------------
% R-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |

% R-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |

% R-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
% R-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
% R-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% R-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |

% F-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |

% F-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |

% F-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
% F-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
% F-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
% F-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |

% L-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
% L-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
% L-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
% L-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
% L-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
% L-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

% L-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
% L-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
% L-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
% L-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
% L-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
% L-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

% L-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
% L-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
% L-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
% L-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
% L-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
% L-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

% =========================================================================

switch condParam
  case 't0'
    switch simScope
      case 'go'
        switch choiceMechType
          case 'li'
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % L-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
            % L-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
            % L-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
            
            z0      = X(1);     % z0G
            zc      = X(2);     % zcG
            vcor    = X(3);     % vCG
            vincor  = X(4);     % vIG
            t0      = X(5:7);   % t0G_c1,t0G_c2,t0G_c3
            se      = X(8);     % se
            si      = X(9);     % si
            k       = X(10);    % kG
            w       = X(11);    % wG
            
          otherwise
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % R-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-R-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-B-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-L-T0-G    | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            
            z0      = X(1);     % z0G
            zc      = X(2);     % zcG
            vcor    = X(3);     % vCG
            vincor  = X(4);     % vIG
            t0      = X(5:7);   % t0G_c1,t0G_c2,t0G_c3
            se      = X(8);     % se
            si      = X(9);     % si
            
        end        
      case 'all'
        switch choiceMechType
          case 'li'
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % L-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            
            z0      = X(1:2);   % z0G,z0S
            zc      = X(3:4);   % zcG,zcS
            vcor    = X(5:6);   % vCG,vCS
            vincor  = X(7);     % vIG
            t0      = X(8:11);  % t0G_c1,t0G_c2,t0G_c3,t0S
            se      = X(12);    % se
            si      = X(13);    % si
            k       = X(14:15); % kG,kS
            w       = X(16:17); % wG,wS
            
          otherwise
            switch inhibMechType
              case 'li'
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                % F-L-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                
                z0      = X(1:2);   % z0G,z0S
                zc      = X(3:4);   % zcG,zcS
                vcor    = X(5:6);   % vCG,vCS
                vincor  = X(7);     % vIG
                t0      = X(8:11);  % t0G_c1,t0G_c2,t0G_c3,t0S
                se      = X(12);    % se
                si      = X(13);    % si
                w       = X(14:15); % wG,wS
                
              otherwise
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % R-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-R-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-B-T0-A    | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                
                z0      = X(1:2);   % z0G,z0S
                zc      = X(3:4);   % zcG,zcS
                vcor    = X(5:6);   % vCG,vCS
                vincor  = X(7);     % vIG
                t0      = X(8:11);  % t0G_c1,t0G_c2,t0G_c3,t0S
                se      = X(12);    % se
                si      = X(13);    % si
                
            end
        end 
    end
  case 'v'
    switch simScope
      case 'go'
        switch choiceMechType
          case 'li'
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % L-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
            % L-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
            % L-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
            
            z0      = X(1);     % z0G
            zc      = X(2);     % zcG
            vcor    = X(3:5);   % vCG_c1,vCG_c2,vCG_c3
            vincor  = X(6);     % vIG
            t0      = X(7);     % t0G
            se      = X(8);     % se
            si      = X(9);     % si
            k       = X(10);    % kG
            w       = X(11);    % wG
            
          otherwise
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % R-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-R-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-B-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-L-V-G     | 1 | 0 | 1 | 0 | 3 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            
            z0      = X(1);     % z0G
            zc      = X(2);     % zcG
            vcor    = X(3:5);   % vCG_c1,vCG_c2,vCG_c3
            vincor  = X(6);     % vIG
            t0      = X(7);     % t0G
            se      = X(8);     % se
            si      = X(9);     % si
            
        end        
      case 'all'
        switch choiceMechType
          case 'li'
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % L-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            
            z0      = X(1:2);   % z0G,z0S
            zc      = X(3:4);   % zcG,zcS
            vcor    = X(5:8);   % vCG_c1,vCG_c2,vCG_c3,vCS
            vincor  = X(9);     % vIG
            t0      = X(10:11); % t0G,t0S
            se      = X(12);    % se
            si      = X(13);    % si
            k       = X(14:15); % kG,kS
            w       = X(16:17); % wG,wS
            
          otherwise
            switch inhibMechType
              case 'li'
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                % F-L-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                
                z0      = X(1:2);   % z0G,z0S
                zc      = X(3:4);   % zcG,zcS
                vcor    = X(5:8);   % vCG_c1,vCG_c2,vCG_c3,vCS
                vincor  = X(9);     % vIG
                t0      = X(10:11); % t0G,t0S
                se      = X(12);    % se
                si      = X(13);    % si
                w       = X(14:15); % wG,wS
                
              otherwise
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % R-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-R-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-B-V-A     | 1 | 1 | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                
                z0      = X(1:2);   % z0G,z0S
                zc      = X(3:4);   % zcG,zcS
                vcor    = X(5:8);   % vCG_c1,vCG_c2,vCG_c3,vCS
                vincor  = X(9);     % vIG
                t0      = X(10:11); % t0G,t0S
                se      = X(12);    % se
                si      = X(13);    % si
                
            end
        end
    end
  case 'zc'
    switch simScope
      case 'go'
        switch choiceMechType
          case 'li'
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % L-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
            % L-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
            % L-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
            
            z0      = X(1);     % z0G
            zc      = X(2:4);   % zcG_c1,zcG_c2,zcG_c3
            vcor    = X(5);     % vCG
            vincor  = X(6);     % vIG
            t0      = X(7);     % t0G
            se      = X(8);     % se
            si      = X(9);     % si
            k       = X(10);    % kG
            w       = X(11);    % wG
            
          otherwise
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % R-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % R-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-R-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-B-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            % F-L-Zc-G    | 1 | 0 | 3 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
            
            z0      = X(1);     % z0G
            zc      = X(2:4);   % zcG_c1,zcG_c2,zcG_c3
            vcor    = X(5);     % vCG
            vincor  = X(6);     % vIG
            t0      = X(7);     % t0G
            se      = X(8);     % se
            si      = X(9);     % si
            
        end        
      case 'all'
        switch choiceMechType
          case 'li'
            % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
            % L-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            % L-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
            
            z0      = X(1:2);   % z0G,z0S
            zc      = X(3:6);   % zcG_c1,zcG_c2,zcG_c3,zcS
            vcor    = X(7:8);   % vCG,vCS
            vincor  = X(9);     % vIG
            t0      = X(10:11); % t0G,t0S
            se      = X(12);    % se
            si      = X(13);    % si
            k       = X(14:15); % kG,kS
            w       = X(16:17); % wG,wS
            
          otherwise
            switch inhibMechType
              case 'li'
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                % F-L-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
                
                z0      = X(1:2);   % z0G,z0S
                zc      = X(3:6);   % zcG_c1,zcG_c2,zcG_c3,zcS
                vcor    = X(7:8);   % vCG,vCS
                vincor  = X(9);     % vIG
                t0      = X(10:11); % t0G,t0S
                se      = X(12);    % se
                si      = X(13);    % si
                w       = X(14:15); % wG,wS
                
              otherwise
                % Model       |z0G|z0S|zcG|zcS|vCG|vCS|vIG|t0G|t0S| se| si| kG| kS| wG| wS|
                % R-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % R-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-R-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                % F-B-Zc-A    | 1 | 1 | 3 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
                
                z0      = X(1:2);   % z0G,z0S
                zc      = X(3:6);   % zcG_c1,zcG_c2,zcG_c3,zcS
                vcor    = X(7:8);   % vCG,vCS
                vincor  = X(9);     % vIG
                t0      = X(10:11); % t0G,t0S
                se      = X(12);    % se
                si      = X(13);    % si
                
            end
        end
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% #. ENCODE CONNECTIVITY MATRICES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

switch choiceMechType
  case 'race'
    
    % No lateral connections
    AS = zeros(sum(N),sum(N));
    AOs = zeros(sum(N),sum(N));
    
    % No feed-forward inhibition
    wFFI = 0;
    
  case 'ffi'
    
    % No lateral connections
    AS = zeros(sum(N),sum(N));
    AOs = zeros(sum(N),sum(N));
        
    % Feed-forward inhibition: normalized ffi of go-signals to all non-target GO units
    wFFI = -1/(N(1)-1);
    
  case 'li'
    
    % Connectivity to self (leakage)
    boolAS = logical(eye(sum(N)));
    AS = boolAS*diag(blkdiag(trueN{:})*k(:));
    
    % Connectivity to other units of same class
    boolAOs = blkdiag(trueN{:})*blkdiag(trueN{:})' - boolAS;
    AOs = boolAOs*diag(blkdiag(trueN{:})*w(:));
    
    % No feed-forward inhibition
    wFFI = 0;
    
end

switch lower(simScope)
  case 'all'
    switch lower(inhibMechType)
      case 'li'

        % Lateral inhibition to other units of other class
        boolAOo = ~blkdiag(trueN{:})*blkdiag(trueN{:})';
        AOo = boolAOo*diag(blkdiag(trueN{:})*w(:));

      otherwise

        % No lateral inhibition between GO and STOP
        AOo = zeros(sum(N),sum(N));

    end
  otherwise
    
    % No lateral inhibition between GO and STOP
    AOo = zeros(sum(N),sum(N));
end    


% Ednogenous connectivity matrix
A = AS + AOs + AOo;

% Exogneous connectivity matrix
CGo = zeros(N(1));
CGo = CGo + diag(ones(N(1),1),0);
for i = 1:N(1)-1;
  CGo = CGo + diag(wFFI*ones(N(1)-i,1),i);
  CGo = CGo + diag(wFFI*ones(N(1)-i,1),-i);
end

switch lower(simScope)
  case 'go'
    C = blkdiag(CGo);
  case 'all'
    CStop = 1;
    C = blkdiag(CGo,CStop);
end

% Extrinsic and intrinsic modulation
B = zeros(sum(N),sum(N),sum(M));
D = zeros(sum(N),sum(N),sum(N));

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% #. ENCODE STARTING POINT MATRIX
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

Z0 = blkdiag(trueN{:})*z0(:);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% #. ENCODE THRESHOLD MATRIX
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

ZC = cell(3,1);
switch lower(condParam)
  case 'zc'

    switch lower(simScope)
      % #.#.#. Optimize go trials only
      % -------------------------------------------------------------------
      case 'go'
        zcc1 = zc(1);
        ZC{1,1} = blkdiag(trueN{:})*zcc1(:);
        zcc2 = zc(2);
        ZC{2,1} = blkdiag(trueN{:})*zcc2(:);
        zcc3 = zc(3);
        ZC{3,1} = blkdiag(trueN{:})*zcc3(:);
        
      % #.#.#. Optimize all trials
      % -------------------------------------------------------------------
      case 'all'
        zcc1 = zc([1,4]);
        ZC{1,1} = blkdiag(trueN{:})*zcc1(:);
        zcc2 = zc([2,4]);
        ZC{2,1} = blkdiag(trueN{:})*zcc2(:);
        zcc3 = zc([3,4]);
        ZC{3,1} = blkdiag(trueN{:})*zcc3(:);
    end
    
  otherwise
    ZC = cellfun(@(a) blkdiag(trueN{:})*zc(:),ZC,'Uni',0);
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% #. ACCUMULATION RATES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

switch condParam
  
  % #.#. Rate varies between conditions
  % =======================================================================
  case 'v' 
    
    switch lower(simScope)
      
      
      % #.#.#. Optimize go trials only
      % -------------------------------------------------------------------
      case 'go'
        vc1 = vcor(1); % rate go-signal in condition 1
        vc2 = vcor(2); % rate go-signal in condition 2
        vc3 = vcor(3); % rate go-signal in condition 3
      
      % #.#.#. Optimize all trials
      % -------------------------------------------------------------------
      case 'all'
        vc1 = vcor([1,4]); % rate go-signal and stop-signal in condition 1
        vc2 = vcor([2,4]); % rate go-signal and stop-signal in condition 2
        vc3 = vcor([3,4]); % rate go-signal and stop-signal in condition 3
        
        vincor = [vincor;0];    % Add an error rate for Stop units (no choice => no error rate)
    end
    
    % Rates in condition 1
    V(1,:) = cellfun(@(a,b) a*vc1(:) + b*vincor,VCor,VIncor,'Uni',0);
    
    % Rates in condition 2
    V(2,:) = cellfun(@(a,b) a*vc2(:) + b*vincor,VCor,VIncor,'Uni',0);
    
    % Rates in condition 3
    V(3,:) = cellfun(@(a,b) a*vc3(:) + b*vincor,VCor,VIncor,'Uni',0);
  
  % #.#. Rate does not vary between conditions
  % =======================================================================
  otherwise
    
    switch lower(simScope)
      case 'go'
      case 'all'
        vincor = [vincor;0];
    end
    
    V = cellfun(@(a,b) a*vcor(:) + b*vincor,VCor,VIncor,'Uni',0);
    
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% #. EXTRINSIC AND INTRINSIC NOISE
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

switch lower(simScope)
  case 'go'
    SE = cellfun(@(a) a*se,S,'Uni',0);
    SI = cellfun(@(a) a*si,S,'Uni',0); 
  case 'all'
    SE = cellfun(@(a) a*[se se]',S,'Uni',0);
    SI = cellfun(@(a) a*[si si]',S,'Uni',0); 
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% #. SPECIFY ONSETS AND DURATIONS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Accumulation
% =========================================================================
switch condParam
  
  case 't0' % Non-decision time varies between conditions
    
    switch lower(simScope)
      case 'go'
        t0c1 = t0(1);
        t0c2 = t0(2);
        t0c3 = t0(3);
      case 'all'
        t0c1 = t0([1,4]);
        t0c2 = t0([2,4]);
        t0c3 = t0([3,4]);
    end
    
    % Condition 1
    accumOns(1,:) = cellfun(@(a) a + blkdiag(trueM{:})*t0c1(:),stimOns(1,:),'Uni',0);
    
    % Condition 2
    accumOns(2,:) = cellfun(@(a) a + blkdiag(trueM{:})*t0c2(:),stimOns(2,:),'Uni',0);
    
    % Condition 3
    accumOns(3,:) = cellfun(@(a) a + blkdiag(trueM{:})*t0c3(:),stimOns(3,:),'Uni',0);
        
  otherwise % Non-decision time does not vary between conditions
    
    accumOns = cellfun(@(a) a + blkdiag(trueM{:})*t0(:),stimOns,'Uni',0);
    
end