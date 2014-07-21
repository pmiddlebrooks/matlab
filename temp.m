%%
% taskID = 'vis'
% subjectID = 'Broca'
% location = 'home';
location = 'work';


mArray = {'Xena', 'Broca'};
for m = 1 : length(mArray)
   subjectID = mArray{m}
   
   
   
   
   
   
   % Open the current sessions file, or create one if it doesn't exist
   sessionsFile = [subjectID, '_sessions.mat'];
   if exist(sessionsFile, 'file') ~= 2
      sessions = struct();
      save(sessionsFile, 'sessions', '-mat')
   end
   load(sessionsFile);
   
   
   
   
   [tebaDataPath, localDataPath] = subject_data_path(subjectID);
   % tebaDataPath = '/Volumes/SchallLab/data/';
   humanDataPath = '/Volumes/middlepg/HumanData/ChoiceStopTask/';
   humanDir = [humanDataPath];
   monkeyDir = [tebaDataPath];
   
   
   directory = dir([monkeyDir, '*.mat']);
   
   size(directory, 1)
   for i = 1 : size(directory, 1)
      if isempty(regexp(directory(i).name, '_legacy', 'once')) && ...
            isempty(regexp(directory(i).name, '2012', 'once')) && ...
            strcmp(directory(i).name, [directory(i).name(1:end-4), '.mat'])
         directory(i).name(1:end-4)
         
         load([localDataPath, directory(i).name])
         
         
         %             [a, b] = ismember('fixationSpotOnset', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'fixOn'; end
         %             [a, b] = ismember('fixationSpotDuration', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'fixDuration'; end
         %             [a, b] = ismember('fixationWindowEntered', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'fixWindowEntered'; end
         %             [a, b] = ismember('targetOnset', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'targOn'; end
         %             [a, b] = ismember('targetDuration', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'targDuration'; end
         %             [a, b] = ismember('targetWindowEntered', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'targWindowEntered'; end
         %             [a, b] = ismember('saccadeOnset', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'saccBegin'; end
         %             [a, b] = ismember('saccadeToTargetIndex', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'saccToTargIndex'; end
         %             [a, b] = ismember('saccadeDuration', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'saccDuration'; end
         %             [a, b] = ismember('saccadeAmplitude', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'saccAmp'; end
         %             [a, b] = ismember('saccadeDirection', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'saccAngle'; end
         %             [a, b] = ismember('rewardOnset', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'rewardOn'; end
         %             [a, b] = ismember('abortOnset', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'abortTime'; end
         %             [a, b] = ismember('fixationAmplitude', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'fixAmp'; end
         %             [a, b] = ismember('fixationAngle', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'fixAngle'; end
         %             [a, b] = ismember('fixationSize', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'fixSize'; end
         %             [a, b] = ismember('fixationWindow', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'fixWindow'; end
         %             [a, b] = ismember('targetSize', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'targSize'; end
         %             [a, b] = ismember('targetWindow', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'targWindow'; end
         %             [a, b] = ismember('eyePositionX', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'eyeX'; end
         %             [a, b] = ismember('eyePositionY', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'eyeY'; end
         %             [a, b] = ismember('target1CheckerProportion', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'targ1CheckerProp'; end
         %             [a, b] = ismember('preTargetFixDuration', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'preTargFixDuration'; end
         %             [a, b] = ismember('postTargetFixDuration', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'postTargFixDuration'; end
         %             [a, b] = ismember('distractorOnset', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'distOn'; end
         %             [a, b] = ismember('distractorDuration', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'distDuration'; end
         %             [a, b] = ismember('choiceStimulusOnset', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'checkerOn'; end
         %             [a, b] = ismember('choiceStimulusDuration', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'checkerDuration'; end
         %             [a, b] = ismember('responseCueOnset', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'responseCueOn'; end
         %             [a, b] = ismember('stopOnset', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'stopSignalOn'; end
         %             [a, b] = ismember('stopTrialProportion', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'stopTrialProp'; end
         %             [a, b] = ismember('distractorAmplitude', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'distAmp'; end
         %             [a, b] = ismember('distractorAngle', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'distAngle'; end
         %             [a, b] = ismember('distractorSize', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'distSize'; end
         %             [a, b] = ismember('distractorWindow', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'distWindow'; end
         %             [a, b] = ismember('choiceStimulusAmplitude', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'checkerAmp'; end
         %             [a, b] = ismember('choiceStimulusAngle', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'checkerAngle'; end
         %             [a, b] = ismember('choiceStimulusSize', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'checkerSize'; end
         %             [a, b] = ismember('choiceStimulusWindow', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'checkerWindow'; end
         %             [a, b] = ismember('checkerBoardArray', trialData.Properties.VarNames);
         %             if a; trialData.Properties.VarNames{b} = 'checkerArray'; end
         %         [a, b] = ismember('targetAngle', trialData.Properties.VarNames);
         %         if a; trialData.Properties.VarNames{b} = 'targAngle'; end
         %        [a, b] = ismember('targetAmplitude', trialData.Properties.VarNames);
         %         if a; trialData.Properties.VarNames{b} = 'targAmp'; end
         
         SessionData = sessionData;
         %             save([tebaDataPath, directory(i).name], 'trialData', '-append')
         % %             Save a local copy too
         %             saveLocalName = [localDataPath, directory(i).name];
         %             save(saveLocalName, 'trialData', '-append')
         save([tebaDataPath, directory(i).name], 'trialData', 'SessionData')
         % Save a local copy too
         saveLocalName = [localDataPath, directory(i).name];
         save(saveLocalName, 'trialData', 'SessionData')
         
         
         
      end
   end
end

%%
humanDataPath = '/Volumes/middlepg/HumanData/ChoiceStopTask/';
humanDir = [humanDataPath];
directory = dir([humanDir, '*.mat'])

size(directory, 1)
for i = 1 : size(directory, 1)
   if isempty(regexp(directory(i).name, '_legacy', 'once')) && ...
         isempty(regexp(directory(i).name, '2012', 'once')) && ...
         strcmp(directory(i).name, [directory(i).name(1:end-4), '.mat'])
      directory(i).name(1:end-4)
      
      load([humanDataPath, directory(i).name])
      
      
      %         [a, b] = ismember('fixationSpotOnset', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'fixOn'; end
      %         [a, b] = ismember('fixationSpotDuration', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'fixDuration'; end
      %         [a, b] = ismember('fixationWindowEntered', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'fixWindowEntered'; end
      %         [a, b] = ismember('targetOnset', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'targOn'; end
      %         [a, b] = ismember('targetDuration', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'targDuration'; end
      %         [a, b] = ismember('targetWindowEntered', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'targWindowEntered'; end
      [a, b] = ismember('saccadeOnset', trialData.Properties.VarNames);
      if a; trialData.Properties.VarNames{b} = 'saccBegin'; end
      [a, b] = ismember('saccOnset', trialData.Properties.VarNames);
      if a; trialData.Properties.VarNames{b} = 'saccBegin'; end
      %         [a, b] = ismember('saccadeToTargetIndex', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'saccToTargIndex'; end
      %         [a, b] = ismember('saccadeDuration', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'saccDuration'; end
      %         [a, b] = ismember('saccadeAmplitude', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'saccAmp'; end
      %         [a, b] = ismember('saccadeDirection', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'saccAngle'; end
      %         [a, b] = ismember('rewardOnset', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'rewardOn'; end
      %         [a, b] = ismember('abortOnset', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'abortTime'; end
      %         [a, b] = ismember('fixationAmplitude', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'fixAmp'; end
      %         [a, b] = ismember('fixationAngle', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'fixAngle'; end
      %         [a, b] = ismember('fixationSize', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'fixSize'; end
      %         [a, b] = ismember('fixationWindow', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'fixWindow'; end
      %         [a, b] = ismember('targetSize', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'targSize'; end
      %         [a, b] = ismember('targetWindow', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'targWindow'; end
      %         [a, b] = ismember('eyePositionX', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'eyeX'; end
      %         [a, b] = ismember('eyePositionY', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'eyeY'; end
      %         [a, b] = ismember('target1CheckerProportion', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'targ1CheckerProp'; end
      %         [a, b] = ismember('preTargetFixDuration', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'preTargFixDuration'; end
      %         [a, b] = ismember('postTargetFixDuration', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'postTargFixDuration'; end
      %         [a, b] = ismember('distractorOnset', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'distOn'; end
      %         [a, b] = ismember('distractorDuration', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'distDuration'; end
      %         [a, b] = ismember('choiceStimulusOnset', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'checkerOn'; end
      %         [a, b] = ismember('choiceStimulusDuration', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'checkerDuration'; end
      %         [a, b] = ismember('responseCueOnset', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'responseCueOn'; end
      %         [a, b] = ismember('stopOnset', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'stopSignalOn'; end
      %         [a, b] = ismember('stopTrialProportion', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'stopTrialProp'; end
      %         [a, b] = ismember('distractorAmplitude', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'distAmp'; end
      %         [a, b] = ismember('distractorAngle', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'distAngle'; end
      %         [a, b] = ismember('distractorSize', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'distSize'; end
      %         [a, b] = ismember('distractorWindow', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'distWindow'; end
      %         [a, b] = ismember('choiceStimulusAmplitude', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'checkerAmp'; end
      %         [a, b] = ismember('choiceStimulusAngle', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'checkerAngle'; end
      %         [a, b] = ismember('choiceStimulusSize', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'checkerSize'; end
      %         [a, b] = ismember('choiceStimulusWindow', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'checkerWindow'; end
      [a, b] = ismember('choiceStimulusColor', trialData.Properties.VarNames);
      if a; trialData.Properties.VarNames{b} = 'checkerColor'; end
      [a, b] = ismember('checkerboardArray', trialData.Properties.VarNames);
      if a; trialData.Properties.VarNames{b} = 'checkerArray'; end
      %         [a, b] = ismember('targetAngle', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'targAngle'; end
      %        [a, b] = ismember('targetAmplitude', trialData.Properties.VarNames);
      %         if a; trialData.Properties.VarNames{b} = 'targAmp'; end
      [a, b] = ismember('SSD', trialData.Properties.VarNames);
      if a; trialData.Properties.VarNames{b} = 'ssd'; end
      [a, b] = ismember('eyelinkSaccadeOnset', trialData.Properties.VarNames);
      if a; trialData.Properties.VarNames{b} = 'eyelinkSaccOnset'; end
      
      [a, b] = ismember('fixationOnset', trialData.Properties.VarNames);
      if a; trialData.Properties.VarNames{b} = 'fixWindowEntered'; end
      
      
      %         save([humanDataPath, directory(i).name], 'trialData', '-append')
      %         % Save a local copy too
      %         saveLocalName = [localDataPath, directory(i).name];
      %         save(saveLocalName, 'trialData', '-append')
      
      
      
      
      SessionData = sessionData;
      if exist('sessionIDArray', 'var')
         save([humanDataPath, directory(i).name], 'trialData', 'SessionData', 'sessionIDArray')
         saveLocalName = [localDataPath, directory(i).name];
         save(saveLocalName, 'trialData', 'SessionData', 'sessionIDArray')
      else
         save([humanDataPath, directory(i).name], 'trialData', 'SessionData')
         saveLocalName = [localDataPath, directory(i).name];
         save(saveLocalName, 'trialData', 'SessionData')
      end
      
      
      
   end
end


%%
subjectID = 'Xena';
sessionID = 'xp054n02';
[tebaDataPath, localDataPath] = subject_data_path(subjectID);




load([tebaDataPath, sessionID])


[a, b] = ismember('fixationSpotOnset', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'fixOn'; end
[a, b] = ismember('fixationSpotDuration', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'fixDuration'; end
[a, b] = ismember('fixationWindowEntered', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'fixWindowEntered'; end
[a, b] = ismember('targetOnset', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'targOn'; end
[a, b] = ismember('targetDuration', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'targDuration'; end
[a, b] = ismember('targetWindowEntered', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'targWindowEntered'; end
[a, b] = ismember('saccadeOnset', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'saccBegin'; end
[a, b] = ismember('saccadeToTargetIndex', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'saccToTargIndex'; end
[a, b] = ismember('saccadeDuration', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'saccDuration'; end
[a, b] = ismember('saccadeAmplitude', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'saccAmp'; end
[a, b] = ismember('saccadeDirection', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'saccAngle'; end
[a, b] = ismember('rewardOnset', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'rewardOn'; end
[a, b] = ismember('abortOnset', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'abortTime'; end
[a, b] = ismember('fixationAmplitude', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'fixAmp'; end
[a, b] = ismember('fixationAngle', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'fixAngle'; end
[a, b] = ismember('fixationSize', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'fixSize'; end
[a, b] = ismember('fixationWindow', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'fixWindow'; end
[a, b] = ismember('targetSize', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'targSize'; end
[a, b] = ismember('targetWindow', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'targWindow'; end
[a, b] = ismember('eyePositionX', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'eyeX'; end
[a, b] = ismember('eyePositionY', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'eyeY'; end
[a, b] = ismember('target1CheckerProportion', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'targ1CheckerProp'; end
[a, b] = ismember('preTargetFixDuration', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'preTargFixDuration'; end
[a, b] = ismember('postTargetFixDuration', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'postTargFixDuration'; end
[a, b] = ismember('distractorOnset', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'distOn'; end
[a, b] = ismember('distractorDuration', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'distDuration'; end
[a, b] = ismember('choiceStimulusOnset', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'checkerOn'; end
[a, b] = ismember('choiceStimulusDuration', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'checkerDuration'; end
[a, b] = ismember('responseCueOnset', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'responseCueOn'; end
[a, b] = ismember('stopOnset', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'stopSignalOn'; end
[a, b] = ismember('stopTrialProportion', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'stopTrialProp'; end
[a, b] = ismember('distractorAmplitude', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'distAmp'; end
[a, b] = ismember('distractorAngle', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'distAngle'; end
[a, b] = ismember('distractorSize', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'distSize'; end
[a, b] = ismember('distractorWindow', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'distWindow'; end
[a, b] = ismember('choiceStimulusAmplitude', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'checkerAmp'; end
[a, b] = ismember('choiceStimulusAngle', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'checkerAngle'; end
[a, b] = ismember('choiceStimulusSize', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'checkerSize'; end
[a, b] = ismember('choiceStimulusWindow', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'checkerWindow'; end
[a, b] = ismember('checkerBoardArray', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'checkerArray'; end
[a, b] = ismember('targetAngle', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'targAngle'; end
[a, b] = ismember('targetAmplitude', trialData.Properties.VarNames);
if a; trialData.Properties.VarNames{b} = 'targAmp'; end

SessionData = sessionData;
save([tebaDataPath, sessionID], 'trialData', 'SessionData')
% Save a local copy too
saveLocalName = [localDataPath, sessionID];
save(saveLocalName, 'trialData', 'SessionData')




%% Population SSRT
%******************************************************************************
subjectID = 'Xena';

switch subjectID
   case 'Human'
      signalStrength = [.35 .42 .46 .5 .54 .58 .65];
   case 'Broca'
      signalStrength = [.41 .45 .48 .5 .52 .55 .59];
   case 'Xena'
      signalStrength = [.35 .42 .47 .5 .53 .58 .65];
end
[sessionArray, subjectIDArray] = task_session_array(subjectID, task)
% signalStrength = unique([populationData.signalStrengthLeft{1}, populationData.signalStrengthRight{1}])';



nSession = length(sessionArray);
% signalStrength = unique([populationData.signalStrengthLeft{1}, populationData.signalStrengthRight{1}])';

for iSession = 1 : nSession
   
   
   % Load the data
   [dataFile, localDataPath, localDataFile] = data_file_path(subjectIDArray{iSession}, sessionArray{iSession});
   % If the file hasn't already been copied to a local directory, do it now
   if exist(localDataFile, 'file') ~= 2
      copyfile(dataFile, localDataPath)
   end
   load(localDataFile);
   
   
   % Convert cells to doubles if necessary
   trialData = cell_to_mat(trialData);
   
   
   
   
   % Need to do a little SSD value adjusting, due to ms difference and 1-frame
   % differences in SSD values
   ssdArrayRaw = trialData.stopSignalOn - trialData.responseCueOn;
   ssdArray = unique(ssdArrayRaw);
   ssdArray = ssdArray(~isnan(ssdArray));
   if ~isempty(ssdArray) && DO_STOPS
      a = diff(ssdArray);
      ssdArray(a == 1) = ssdArray(a == 1) + 1;
      ssdArray = unique(ssdArray);
      b = [ssdArray(1); diff(ssdArray)];
      ssdArray(b < 18) = [];
   end
   
   
   sessionArray{iSession}
   ssdArray
   
end







%%
% taskID = 'vis'
% subjectID = 'Broca'
% location = 'home';
location = 'work';


mArray = {'Broca', 'Xena'};
for m = 1 %: length(mArray)
   subjectID = mArray{m}
   
   
   [tebaDataPath, localDataPath] = subject_data_path(subjectID);
   monkeyDir = [tebaDataPath];
   
   
   directory = dir([monkeyDir, '*.mat']);
   
   
   for i = 11 : size(directory, 1)
      if isempty(regexp(directory(i).name, '_legacy', 'once')) && ...
            isempty(regexp(directory(i).name, '2012', 'once')) && ...
            strcmp(directory(i).name, [directory(i).name(1:end-4), '.mat'])
         
         if exist(localDataPath, 'file') ~= 2
            load([tebaDataPath, directory(i).name])
         else
            load([tebaDataPath, directory(i).name])
         end
         
         
         if strcmp(SessionData.taskID, 'ccm') && ...
               ismember('goCheckerProportion', trialData.Properties.VarNames) && ...
               ~ismember('targ1CheckerProp', trialData.Properties.VarNames)
            
            SessionData.taskID = 'gng';
            
            fprintf('%s: %d /n', directory(i).name, i)
            
            
            
            save([tebaDataPath, directory(i).name], 'SessionData', '-append')
            % Save a local copy too
            saveLocalName = [localDataPath, directory(i).name];
            save(saveLocalName,'trialData', 'SessionData')
            
         end
         
         
      end
   end
end


%%
sessionArray = {'bp043n03'}%, ...
%    'bp043n01', ...
%    'bp014n02', ...
%    'bp058n04'};

[tebaDataPath, localDataPath] = subject_data_path(subjectID);


for i = 1 : length(sessionArray)
   sessionID = sessionArray{i};
   
   fileName =  [sessionID, '.mat'];
   
   
   if isempty(regexp(fileName, '_legacy', 'once')) && ...
         isempty(regexp(fileName, '2012', 'once'))
      
      if exist(localDataPath, 'file') ~= 2
         load([localDataPath, fileName])
      else
         load([tebaDataPath, fileName])
      end
      
      
      if strcmp(SessionData.taskID, 'ccm') && ...
            ismember('goCheckerProportion', trialData.Properties.VarNames) && ...
            ~ismember('targ1CheckerProp', trialData.Properties.VarNames)
         
         SessionData.taskID = 'gng';
         
         fprintf('%s: %d \n', fileName, i)
         
         
         
         save([tebaDataPath, fileName], 'SessionData', '-append')
         % Save a local copy too
         saveLocalName = [localDataPath, fileName];
         save(saveLocalName,'trialData', 'SessionData')
         
      end
      
   end
end



%%   TASK ID SWITCH CODE/LIST
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Mem list
% sessionArray = {'bp016n01', ...
%    'bp018n01', ...
%    'bp019n03', ...
%    'bp020n03', ...
%    'bp021n01', ...
%    'bp023n01', ...
%    'bp024n01', ...
%    'bp026n01', ...
%    'bp029n01', ...
%    'bp030n04', ...
%    'bp032n01', ...
%    'bp032n05', ...
%    'bp033n01', ...
%    'bp034n01', ...
%    'bp035n01', ...
%    'bp036n03', ...
%    'bp038n01', ...
%    'bp039n03', ...
%    'bp041n01', ...
%    'bp042n03', ...
%    'bp044n03', ...
%    'bp045n01', ...
%    'bp046n01', ...
%    'bp047n01', ...
%    'bp048n01', ...
%    'bp049n03', ...
%    'bp050n01', ...
%    'bp051n01', ...
%    'bp055n01', ...
%    'bp056n01', ...
%    'bp057n01', ...
%    'bp057n03', ...
%    'bp058n03', ...
%    'bp059n01', ...
%    'bp061n01', ...
%    'bp068n01', ...
%    'bp069n01', ...
%    'bp082n01', ...
%    'bp083n01', ...
%    'bp084n01', ...
%    'bp085n01', ...
%    'bp087n01', ...
%    'bp088n01', ...
%    'bp089n01', ...
%    'bp090n01', ...
%    'bp091n01', ...
%    'bp092n01', ...
%    'bp093n01', ...
%    'bp094n01', ...
%    'bp095n01', ...
%    'bp096n01', ...
%    'bp097n01', ...
%    'bp099n01', ...
%    'bp112n01', ...
%    'bp115n01', ...
%    'bp116n01', ...
%    'bp119n01', ...
%    'bp120n01', ...
%    'bp121n01', ...
%    'bp121n03', ...
%    'bp122n01', ...
%    'bp124n01', ...
%    'bp124n03', ...
%    'bp126n01', ...
%    'bp127n01', ...
%    'bp128n01', ...
%    'bp129n01', ...
%    'bp130n01', ...
%    'bp130n03', ...
%    'bp131n01', ...
%    'bp132n01'}


% % Vis list
% sessionArray = {'bp019n02', ...
%    'bp020n01', ...
%    'bp030n01', ...
%    'bp034n05', ...
%    'bp036n01', ...
%    'bp037n01', ...
%    'bp040n01', ...
%    'bp058n01'}

% % Del list
% sessionArray = {'bp018n03', ...
%    'bp019n01', ...
%    'bp020n02', ...
%    'bp024n03', ...
%    'bp025n01', ...
%    'bp028n01', ...
%    'bp029n03', ...
%    'bp030n02', ...
%    'bp031n02', ...
%    'bp032n03', ...
%    'bp033n03', ...
%    'bp034n03', ...
%    'bp036n05', ...
%    'bp038n03', ...
%    'bp039n01', ...
%    'bp042n01', ...
%    'bp046n03', ...
%    'bp049n01', ...
%    'bp050n03', ...
%    'bp051n03', ...
%    'bp056n02', ...
%    'bp057n02', ...
%    'bp058n02'}


% % GNG list
% sessionArray = {'bp001n03', ...
%    'bp006n01', ...
%    'bp013n02', ...
%    'bp014n03', ...
%    'bp016n03', ...
%    'bp017n02', ...
%    'bp028n02', ...
%    'bp043n01', ...
%    'bp043n03', ...
%    'bp058n04'}

sessionArray = {'bp058n05'}


[tebaDataPath, localDataPath] = subject_data_path(subjectID);


for i = 1 : length(sessionArray)
   sessionID = sessionArray{i};
   
   fileName =  [sessionID, '.mat'];
   if exist([tebaDataPath, fileName], 'file') == 2
      
      if isempty(regexp(fileName, '_legacy', 'once')) && ...
            isempty(regexp(fileName, '2012', 'once'))
         
         if exist([localDataPath, fileName], 'file') == 2
            load([localDataPath, fileName])
         else
            load([tebaDataPath, fileName])
         end
         
         
         if strcmp(SessionData.taskID, 'ccm') && ...
               ~ismember('targ1CheckerProp', trialData.Properties.VarNames)
            
            SessionData.taskID = 'cmd';
            
            fprintf('%s: %d \n', fileName, i)
            
            
            
            save([tebaDataPath, fileName], 'SessionData', '-append')
            % Save a local copy too
            saveLocalName = [localDataPath, fileName];
            save(saveLocalName,'trialData', 'SessionData')
            
         end
      else
         fprintf('\n\n\n ******* NEED TO TRANSFER %s ********** \n\n\n\n\n', fileName)
      end
      
   end
end




%%   TRANSLATION CODE/LIST

% Mem list
sessionArray = {'bp016n01', ...
   'bp018n01', ...
   'bp019n03', ...
   'bp020n03', ...
   'bp021n01', ...
   'bp023n01', ...
   'bp024n01', ...
   'bp026n01', ...
   'bp029n01', ...
   'bp030n04', ...
   'bp032n01', ...
   'bp032n05', ...
   'bp033n01', ...
   'bp034n01', ...
   'bp035n01', ...
   'bp036n03', ...
   'bp038n01', ...
   'bp039n03', ...
   'bp041n01', ...
   'bp042n03', ...
   'bp044n03', ...
   'bp045n01', ...
   'bp046n01', ...
   'bp047n01', ...
   'bp048n01', ...
   'bp049n03', ...
   'bp050n01', ...
   'bp051n01', ...
   'bp055n01', ...
   'bp056n01', ...
   'bp057n01', ...
   'bp057n03', ...
   'bp058n03', ...
   'bp059n01', ...
   'bp061n01', ...
   'bp068n01', ...
   'bp069n01', ...
   'bp082n01', ...
   'bp083n01', ...
   'bp084n01', ...
   'bp085n01', ...
   'bp087n01', ...
   'bp088n01', ...
   'bp089n01', ...
   'bp090n01', ...
   'bp091n01', ...
   'bp092n01', ...
   'bp093n01', ...
   'bp094n01', ...
   'bp095n01', ...
   'bp096n01', ...
   'bp097n01', ...
   'bp099n01', ...
   'bp112n01', ...
   'bp115n01', ...
   'bp116n01', ...
   'bp119n01', ...
   'bp120n01', ...
   'bp121n01', ...
   'bp121n03', ...
   'bp122n01', ...
   'bp124n01', ...
   'bp124n03', ...
   'bp126n01', ...
   'bp127n01', ...
   'bp128n01', ...
   'bp129n01', ...
   'bp130n01', ...
   'bp130n03', ...
   'bp131n01', ...
   'bp132n01'}

% % Vis list
% sessionArray = {'bp019n02', ...
%    'bp020n01', ...
%    'bp030n01', ...
%    'bp034n05', ...
%    'bp036n01', ...
%    'bp037n01', ...
%    'bp040n01', ...
%    'bp058n01'}
% 
% % Del list
% sessionArray = {'bp018n03', ...
%    'bp019n01', ...
%    'bp020n02', ...
%    'bp024n03', ...
%    'bp025n01', ...
%    'bp028n01', ...
%    'bp029n03', ...
%    'bp030n02', ...
%    'bp031n02', ...
%    'bp032n03', ...
%    'bp033n03', ...
%    'bp034n03', ...
%    'bp036n05', ...
%    'bp038n03', ...
%    'bp039n01', ...
%    'bp042n01', ...
%    'bp046n03', ...
%    'bp049n01', ...
%    'bp050n03', ...
%    'bp051n03', ...
%    'bp056n02', ...
%    'bp057n02', ...
%    'bp058n02'}
% 
% % GNG list
% sessionArray = {'bp001n03', ...
%    'bp004n01', ...
%    'bp006n01', ...
%    'bp013n02', ...
%    'bp014n03', ...
%    'bp016n03', ...
%    'bp017n02', ...
%    'bp028n02', ...
%    'bp043n01', ...
%    'bp043n03', ...
%    'bp058n04'}

subjectID = 'Broca';
monkeyDataPath = 'Broca/';
tebaDataPath = ['t:/data/',monkeyDataPath];


for i = 1 : length(sessionArray)
    sessionID = sessionArray{i};
    
    fileName =  [sessionID, '.mat'];
    
    
    if isempty(regexp(fileName, '_legacy', 'once')) && ...
            isempty(regexp(fileName, '2012', 'once'))
        
        load([tebaDataPath, fileName], 'SessionData')
        
        SessionData.taskID
        if strcmp(SessionData.taskID, 'cmd')
            
            fprintf('\n\n\n\n ********** TRANSLATING %s  ********** \n\n\n\n', sessionID)
            plexon_translate_datafile('Broca', sessionID)
            fprintf('\n\n\n\n ********** TRANSLATED %s  ********** \n\n\n\n', sessionID)
        end
        
    end
end


%%
sessionArray = {'bp062n01', ...
   'bp071n02', ...
   'bp072n02'}
for i = 1 : length(sessionArray)
    sessionID = sessionArray{i};
    
    fileName =  [sessionID, '.mat'];
    
    
            plexon_translate_datafile('Broca', sessionID)
            fprintf('\n\n\n\n ********** TRANSLATED %s  ********** \n\n\n\n', sessionID)
        
end

%%
location = 'work';


mArray = {'broca', 'xena'};
for m = 2 %: length(mArray)
   subjectID = mArray{m}
   
   
   [tebaDataPath, localDataPath] = subject_data_path(subjectID);
   monkeyDir = [tebaDataPath];
   
   
   directory = dir([monkeyDir, '*.mat']);
   
   
   for i = 1 : size(directory, 1)
      if isempty(regexp(directory(i).name, '_legacy', 'once')) && ...
            isempty(regexp(directory(i).name, '2012', 'once')) && ...
            strcmp(directory(i).name, [directory(i).name(1:end-4), '.mat'])
         
            fprintf('%s: %d \n', directory(i).name, i)

            if exist(localDataPath, 'file') ~= 2
            load([tebaDataPath, directory(i).name])
         else
            load([localDataPath, directory(i).name])
         end
         
             
            SessionData.taskID = SessionData.task.taskID;
            
            

            save([tebaDataPath, directory(i).name], 'SessionData', '-append')
            % Save a local copy too
            saveLocalName = [localDataPath, directory(i).name];
            save(saveLocalName,'trialData', 'SessionData')
            
         
         
      end
   end
end


%%

% Figure out how to make vanderbilt and pgh maskbet translations the same

[sd, S, E] = load_data('shuffles','sp154n01');
[bd, B, E] = load_data('broca','bp150n01');
d = setxor(sd.Properties.VarNames,bd.Properties.VarNames)

sNotB = {};
bNotS = {};
for i = 1 : length(d)
    
inS = ismember(d{i}, sd.Properties.VarNames)
inB = ismember(d{i}, bd.Properties.VarNames);
if inS && ~inB
    sNotB = [sNotB; d{i}];
end
if inB && ~inS
    bNotS = [bNotS; d{i}];
end

end











