function [sessionArray, subjectIDArray] = task_session_array(subject, task, sessionSet, stopFlag)


stop = 1;
noStop = 0;
if nargin < 3
   sessionSet = 'behavior';
end
if nargin < 4
   stopFlag = stop;
end

subject = lower(subject);

switch subject
   
   
   
   % ********************************************************************
   % ************           HUMAN                         ***************
   case 'human'
      switch task
         
         case 'ccm'
            switch stopFlag
               case stop
                  % Human
                  subjectIDArray = ...
                     {'bz', ...
                     'pm', ...
                     'cb', ...
                     'kf', ...
                     'xb', ...
                     'oe', ...
                     'ts', ...
                     'dm'};
                  sessionArray = ...
                     {'Allsaccade', ...
                     'Allsaccade', ...
                     'Allsaccade', ...
                     'Allsaccade', ...
                     'Allsaccade', ...
                     'Allsaccade', ...
                     'Allsaccade', ...
                     'Allsaccade'};
                  %                     case stop
                  %                         % Human
                  %                         subjectIDArray = ...
                  %                             {'bz', ...
                  %                             'pg', ...
                  %                             'xx', ...
                  %                             'kf'};
                  %                         sessionArray = ...
                  %                             {'Allkeypress', ...
                  %                             'Allkeypress', ...
                  %                             'Allkeypress', ...
                  %                             '0802keypress'};
               case noStop
            end
         otherwise
            fprintf('No sessions yet for %s"s %s task\n', subject, task)
      end
      
      
      
      
      
      % ********************************************************************
      % ************           BROCA                         ***************
      
   case 'broca'
      switch task
         case 'ccm'
            switch stopFlag
               case stop
                  switch sessionSet
                     case 'behavior1'
                        % Behavioral sessions used in Middlebrooks & Schall
                        % 2013
                        sessionArray = ...
                           {'bp040n02', ...
                           'bp041n02', ...
                           'bp042n02', ...
                           'bp043n02', ...
                           'bp045n02', ...
                           'bp046n02', ...
                           'bp049n02', ...
                           'bp050n02', ...
                           'bp051n02', ...
                           'bp055n02', ...
                           'bp056n04', ...
                           'bp060n01', ...
                           'bp061n02', ...
                           'bp063n01', ...
                           'bp064n01'};
                        %                         % For testing
                        %                         sessionArray = ...
                        %                             {'bp040n02', ...
                        %                             'bp061n02', ...
                        %                             'bp064n01'};
                        
                     case 'neural1'
                        % These sessions are neural recordings all with pSignal = [40 43 46 54 57 60]
                        sessionArray = {...
                           'bp084n02-pm', ...
                           'bp086n01', ...
                           'bp087n02-pm', ...
                           'bp088n02-pm', ...
                           'bp089n02', ...
                           'bp090n02', ...
                           'bp091n02-pm', ...
                           'bp092n02-pm', ...
                           'bp093n02-pm', ...
                           'bp103n01', ...
                           'bp104n01', ...
                           'bp106n01', ...
                           'bp107n01'};
                     case 'neural2'
                        % These sessions are neural recordings all with pSignal = [40 43 46 54 57 60]
                        sessionArray = {...
                           'bp119n02-pm', ...
                           'bp120n02-pm', ...
                           'bp121n02-pm', ...
                           'bp121n04', ...
                           'bp122n02', ...
                           'bp123n01', ...
                           'bp124n02', ...
                           'bp124n04', ...
                           'bp126n02-pm', ...
                           'bp127n02', ...
                           'bp128n02', ...
                           'bp129n02-pm', ...
                           'bp130n04', ...
                           'bp131n02', ...
                           'bp132n02-pm'};
                     case 'behavior2'
                        % These sessions are behavior recordings all with
                        % pSignal = [43 45 47 53 55 57] and only 5 SSDs
                        sessionArray = {...
                           'bp174n02', ...
                           'bp175n02', ...
                           'bp176n02', ...
                           'bp177n02', ...
                           'bp178n02', ...
                           'bp179n02', ...
                           'bp180n02', ...
                           'bp181n02', ...
                           'bp182n02', ...
                           'bp183n02', ...
                           'bp185n02', ...
                           'bp186n02', ...
                           'bp187n02', ...
                           'bp188n02', ...
                           'bp189n02', ...
                           };
                 end % switch sessionSet
               case noStop
                  sessionArray = ...
                     {'bp042n04', ...
                     'bp043n04', ...
                     'bp044n04', ...
                     'bp046n04', ...
                     'bp050n04', ...
                     'bp051n04', ...
                     'bp056n03', ...
                     'bp057n03'};
            end
         otherwise
            fprintf('No sessions yet for %s"s %s task\n', subject, task)
      end
      
      
      
      
      
      
      
      
      
      
      
      
      % ********************************************************************
      % ************           XENA                         ***************
   case 'xena'
      switch task
         
         case 'ccm'
            switch stopFlag
               case stop
                  switch sessionSet
                     case 'behavior1'
                        % Behavioral sessions used in Middlebrooks & Schall
                        % 2013
                  sessionArray = ...
                     {'xp036n02', ...
                     'xp038n02', ...
                     'xp040n02', ...
                     'xp041n02', ...
                     'xp042n02', ...
                     'xp043n02', ...
                     'xp046n02', ...
                     'xp048n02', ...
                     'xp049n04', ...
                     'xp050n02', ...
                     'xp051n01', ...
                     'xp052n02', ...
                     'xp053n03', ...
                     'xp055n01', ...
                     'xp056n01'};
                  end
               case noStop
                  sessionArray = ...
                     {'xp036n03', ...
                     'xp043n03', ...
                     'xp048n03', ...
                     'xp049n03'};
            end
            
         otherwise
            fprintf('No sessions yet for %s"s %s task\n', subject, task)
      end
      
      
      
      
end % switch subject

if ~strcmp(subject, 'human')
   subjectIDArray = repmat({subject}, length(sessionArray), 1);
end
