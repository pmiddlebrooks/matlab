function [SaccBegin,...
    SaccEnd,...
    SaccAmplitude,...
    SaccDirection,...
    SaccVelocity,...
    SaccDuration,...
    SaccsNBlinks, ...
    Sacc_of_interest] = saccade_data(EyeX_,...
    EyeY_,...
    TrialStart_, ...
    Target_, ...
    Correct_, ...
    Eot_, ...
    fixationWindowSize, ...
    eyeSampleHz)


% Need to multiply ms time stamps by this number to match the sampling
% rate, and divide all rates by it.
MS_PER_SAMPLE = 1000 / eyeSampleHz;

% Set velocity threshold (degrees per second) (may want to make input)
velocityThreshold = 30;

% Run function in with no user input if no input variables are present
if nargin < 1
    warning('DetectSaccades:DebugMode',...
        'Detect_Saccades() is running with no user input');
    varInList = {'EyeX_','EyeY_','TrialStart_'};
    varOutList = {'SaccBegin','SaccEnd','SaccAmplitude','SaccDirection',...
        'SaccVelocity','SaccDuration' };
    for i=1:size(varInList,2)
        iVar = varInList{i};
        eval(sprintf('%s = evalin(''base'',''%s'');',iVar,iVar));
    end
    No_Input = true;
else
    warning('off','DetectSaccades:SaccadeDuringTrialStart');
    warning('off','DetectSaccades:SaccadeBeginEndMismatch');
    warning('off','DetectSaccades:SaccadeDuringTrialEnd');
    warning('off','DetectSaccades:OverlappingSaccades');
    No_Input = false;
end


% Get maximum values for preallocating matrices and other operations
% NOTE; if trial lengths are too long here maxSamples will be too large.
% This is a problem b/c then we will preallocate all of our output to be
% huge matrices and it will lead to out of memory issues.  But trial length
% should be pretty short and constant right?  So who cares?  Well if you
% end up pausing the task during data collection you will have one really
% long trial which screws everything up.  To get around that, we check for
% outliers to the trial length and remove them.  Then we limit how long
% Saccade detection will proceed for in the ITI later in the code if we
% find outliers.
nTrial       = length(TrialStart_);
if nTrial > 1
    outlierLimit    = mean(diff(TrialStart_)) + (std(diff(TrialStart_)) * 5);  % Use 5 standard deviations as a cutoff
    samples         = (diff(TrialStart_));
    samples(samples > outlierLimit) = [];
    maxSamples      = max(samples);
else
    maxSamples      = Eot_;
    TrialStart_     = 1;  % If inputing
end

% Calculate velocity of eye traces in each dimension (horizontal and
% vertical components)
% deltaEyeX = [0 ; diff(EyeX_)];
% deltaEyeY = [0 ; diff(EyeY_)];
deltaEyeX = [0 ; diff(EyeX_)] ./ MS_PER_SAMPLE;
deltaEyeY = [0 ; diff(EyeY_)] ./ MS_PER_SAMPLE;

% Calculate velocity using pythagorean formula on the horizontal and
% vertical velocity vectors
velocityXY = sqrt((deltaEyeX.^2) + (deltaEyeY.^2));
clear deltaEyeX deltaEyeY %conserve memory for low powered machines

% Convert velocity to degrees per second
MS_PER_SECOND = 1000;
velocityXY = velocityXY * MS_PER_SECOND;

% Determine where velocity is greater than or equal to threshold
saccadeTime = velocityXY >= velocityThreshold;

% Preallocate matrices with all values set to NaN
SaccBegin(1:nTrial,1:maxSamples)     = NaN;
SaccEnd(1:nTrial,1:maxSamples)       = NaN;
SaccAmplitude(1:nTrial,1:maxSamples) = NaN;
SaccDirection(1:nTrial,1:maxSamples) = NaN;
SaccVelocity(1:nTrial,1:maxSamples)  = NaN;
SaccDuration(1:nTrial,1:maxSamples)  = NaN;
SaccsNBlinks(1:nTrial,1:maxSamples)  = NaN;

% Get threshold test
saccadeStartsEnds = [0 ; diff(saccadeTime)];

% Identify beginning of saccade
saccadeSarts = find(saccadeStartsEnds == 1) * MS_PER_SAMPLE;

% Identify end of saccade
saccadeEnds = (find(saccadeStartsEnds == -1) - 1) * MS_PER_SAMPLE;

for iTrial = 1 : nTrial
    
    % Find beginning of this trial
    iTrialStart = TrialStart_(iTrial);
    
    % Find the end and treat the final trial differently
    if nTrial == 1
        nextTrialStart = Eot_;
    elseif iTrial ~= nTrial
        nextTrialStart = TrialStart_(iTrial + 1);
    else
        nextTrialStart = TrialStart_(end);
    end
    
    % Process this trial (see below)
    [iSaccBegins,...
        iSaccEnds,...
        iSaccAmps,...
        iSaccDirs,...
        iSaccVels,...
        iSaccDurs,...
        iSaccsNBlinks] = processTrial(iTrialStart,...
        nextTrialStart,...
        EyeX_,...
        EyeY_,...
        velocityXY,...
        saccadeSarts,...
        saccadeEnds,...
        maxSamples,...
        MS_PER_SAMPLE);
    

%   disp(iSaccBegins)
%     pause
    
    % Insert into matrices for whole recording session
    SaccBegin(iTrial,1:length(iSaccBegins))      = iSaccBegins;
    SaccEnd(iTrial,1:length(iSaccEnds))          = iSaccEnds;
    SaccAmplitude(iTrial,1:length(iSaccAmps))    = iSaccAmps;
    SaccDirection(iTrial,1:length(iSaccDirs))    = iSaccDirs;
    SaccVelocity(iTrial,1:length(iSaccVels))     = iSaccVels;
    SaccDuration(iTrial,1:length(iSaccDurs))     = iSaccDurs;
    SaccsNBlinks(iTrial,1:length(iSaccsNBlinks)) = iSaccsNBlinks;
end

% trim nans
if nTrial == 1
    nanPoint = find(isnan(SaccBegin), 1, 'first');
else
    nanPoint = find((nansum(SaccBegin))== 0, 1, 'first');
end
%Trim preallocated matrices down to size needed
SaccBegin(:, nanPoint:end)     = [];
SaccEnd(:, nanPoint:end)       = [];
SaccAmplitude(:, nanPoint:end) = [];
SaccDirection(:, nanPoint:end) = [];
SaccVelocity(:, nanPoint:end)  = [];
SaccDuration(:, nanPoint:end)  = [];
nanPoint = find((nansum(SaccsNBlinks)) == 0, 1, 'first');
SaccsNBlinks(:, nanPoint)      = [];

cols                = size(SaccBegin, 2);
subtractTrialStart  = repmat(TrialStart_, 1, cols);
SaccBegin           = SaccBegin - subtractTrialStart;
SaccEnd             = SaccEnd - subtractTrialStart;

cols                = size(SaccsNBlinks, 2);
subtractTrialStart  = repmat(TrialStart_, 1, cols);
SaccsNBlinks        = SaccsNBlinks - subtractTrialStart;

% visualize trial by trial
if (No_Input)
    % write variables back out to MATLAB workspace
    for i = 1 : size(varOutList, 2)
        iVar = varOutList{i};
        eval(sprintf('assignin(''base'',''%s'',%s);',iVar,iVar));
    end
    % additional variables for Visualization
    assignin('base', 'velocityXY', velocityXY);
    Visualize_Trials
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         &
% FIND THE SACCADE OF INTEREST ON ALL TRIALS                      &
%                                                                         &
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sacc_of_interest is the first saccade which begins after Target_ and
% before Correct_ or EOT_.  Note that I have imposed the additional
% criteria that saccades must be at least 5 degrees in amplitude for them to
% count, so we may have saccade events which do not actually determine
% trial outcome and are therefore not classified as Sacc_of_interest. This
% is because the dist of error sacccade amps is bimodal with some small
% saccades happening around fixation.  These fixational saccades tend to
% have longer amplitudes and probably reflect the fact that it is hard to
% keep the eye immobilized for 2 X the allowed time for a saccade.  If they
% are left in error RTs have a long tail which violates assumption of
% independance in race model.
[rows cols] = size(SaccBegin);


after_Target_   = repmat(Target_,1,cols);
before_time     = Correct_;
% On error trials Correct_doesn't happen but we still want a
% Sacc_of_interest event.  In this case, look at any saccades which
% happened after target onset but before the end of the trial.
before_time(isnan(before_time)) = Eot_(isnan(before_time));
before_time     = repmat(before_time,1,cols);

possible_saccs  = (SaccBegin - after_Target_) > 0   &...
    (SaccBegin - before_time) <= 0 &...
    SaccAmplitude > 2;


Sacc_of_interest(1:rows,1:2)   = nan;
Sacc_of_interest_end(1:rows,1) = nan;
%figure out saccade starting and ending positions
sacc_pos(1:rows,1:4) = nan;
X_starts = 1;
X_ends   = 2;
Y_starts = 3;
Y_ends   = 4;

for ii = 1:rows
    foundIt = 0;
    jSacc = find(possible_saccs(ii, :), 1, 'first');
    if ~isempty(jSacc)
        while ~foundIt && jSacc <= length(find(~isnan(SaccBegin(ii, :))))
            %             troubleTrial = 398;
            %             if ii == troubleTrial
            %                 fixationWindowSize(ii)/2
            %                 EyeX_(TrialStart_(ii) +SaccEnd(ii, jSacc))
            %                 EyeY_(TrialStart_(ii) +SaccEnd(ii, jSacc))
            %                 pause
            %             end
            if (EyeX_((TrialStart_(ii) + SaccEnd(ii, jSacc)) / MS_PER_SAMPLE) < -fixationWindowSize(ii)/2 || ...
                    EyeX_((TrialStart_(ii) +SaccEnd(ii, jSacc)) / MS_PER_SAMPLE) > fixationWindowSize(ii)/2)% && ...
                %                     (EyeY_(TrialStart_(ii) +SaccEnd(ii, jSacc)) < -fixationWindowSize(ii)/2 || ...
                %                     EyeY_(TrialStart_(ii) +SaccEnd(ii, jSacc)) > fixationWindowSize(ii)/2)
                
                foundIt = 1;
                %     if ~isempty(curr_Sacc)
                Sacc_of_interest(ii,2)   = jSacc;
                Sacc_of_interest(ii,1)   = SaccBegin(ii, jSacc);
                Sacc_of_interest_end(ii) = SaccEnd(ii, jSacc);
                
                sacc_pos(ii,X_starts) = EyeX_((Sacc_of_interest(ii,1)   + TrialStart_(ii)) / MS_PER_SAMPLE);
                sacc_pos(ii,X_ends)   = EyeX_((Sacc_of_interest_end(ii) + TrialStart_(ii)) / MS_PER_SAMPLE);
                sacc_pos(ii,Y_starts) = EyeY_((Sacc_of_interest(ii,1)   + TrialStart_(ii)) / MS_PER_SAMPLE);
                sacc_pos(ii,Y_ends)   = EyeY_((Sacc_of_interest_end(ii) + TrialStart_(ii)) / MS_PER_SAMPLE);
                %     end
            else
                jSacc = jSacc + 1;
            end
        end
    end
end

%use same algorithm to find the SecondSacc for saving to file
[rows cols] = size(SaccsNBlinks);
after_Sacc_of_interest = repmat(Sacc_of_interest(:,1),1,cols);
possible_saccs  = (SaccsNBlinks - after_Sacc_of_interest) > 0;
SecondSacc(1:rows,1:2)   = nan;
for ii = 1:rows
    curr_Sacc = find(possible_saccs(ii,:),1,'first');
    if ~isempty(curr_Sacc)
        SecondSacc(ii,2) = curr_Sacc;
        SecondSacc(ii,1) = SaccsNBlinks(ii,curr_Sacc);
    end
end


end











% subfunction

function [iSaccBegins,...
    iSaccEnds,...
    iSaccAmps,...
    iSaccDirs,...
    iSaccVels,...
    iSaccDurs,...
    iSaccsNBlinks] = processTrial(iTrialStart,...
    nextTrialStart,...
    EyeX_,...
    EyeY_,...
    velocityXY,...
    AllStarts,...
    AllEnds,...
    maxSamples,...
    MS_PER_SAMPLE)

%physiologically impossible saccade cutoff
velocityCutoff = 1000;

% Which saccades happened on this trial?
iSaccBegins = AllStarts(AllStarts >= iTrialStart &...
    AllStarts < nextTrialStart);
iSaccEnds = AllEnds(AllEnds >= iTrialStart &...
    AllEnds < nextTrialStart);

% If we have saccades...
if ~isempty(iSaccBegins) && ~isempty(iSaccEnds)
    % ...do the starts and ends of the saccades match each other?
    if iSaccEnds(1) < iSaccBegins(1) % then we matched a saccade end from the last trial with a saccade begin from this trial
        iSaccEnds(1) = []; % delete it b/c saccades are classified based on when they start not end (see below)
    end
    
    if length(iSaccBegins) > length(iSaccEnds) % then a saccade was in flight during the end of the current trial
        % If a multiple trials were sent to saccade_data.m (assuming a single trial
        % takes less than 20 seconds, we can look ahead to the next trial for the
        % saccade end....
        if length(AllStarts) > 20000
            missedEndIndex = find(AllEnds >= nextTrialStart,1,'first'); % get the index of the end from the next trial
            iMissedEnd = AllEnds(missedEndIndex); % and then get the saccade end time
            iSaccEnds(end + 1) = iMissedEnd; % NOTE: the next trial should fall into the conditional statement above this one.
            % ...but if a single trial was sent, to saccade_data.m, we can't look into
            % the next trial and thus can't figure out when the saccade
            % ended. Just cutoff the last saccade start then
        else
            iSaccBegins(end) = [];
        end
    end
    
    % if this ever happens my logic is flawed.
    if length(~isnan(iSaccBegins)) ~= length(~isnan(iSaccEnds))
        warning(sprintf('David screwed up!\nSaccade begin & end mismatch!\nPANIC! PANIC!'));
    end
    
    % If no saccades store a NaN
elseif isempty(iSaccBegins) || isempty(iSaccEnds)
    iSaccBegins = NaN;
    iSaccEnds = NaN;
end



% Preallocate matrices with all values set to NaN
clear iSaccAmps iSaccDirs iSaccDurs iSaccVels
iSaccAmps(1, 1:length(iSaccBegins)) = NaN;
iSaccDirs(1, 1:length(iSaccBegins)) = NaN;
iSaccDurs(1, 1:length(iSaccBegins)) = NaN;
iSaccVels(1, 1:length(iSaccBegins)) = NaN;

% Compute saccade dynamics
for jSaccade = 1 : sum(~isnan(iSaccBegins))
    jBegin = iSaccBegins(jSaccade) / MS_PER_SAMPLE;
    jEnd   = iSaccEnds(jSaccade) / MS_PER_SAMPLE;
    deltaX    = EyeX_(jBegin) - EyeX_(jEnd);
    deltaY    = EyeY_(jBegin) - EyeY_(jEnd);
    
    % Compute saccade amplitude
    iSaccAmps(1, jSaccade) = sqrt(deltaX^2 + deltaY^2);
    
    % Compute saccade direction
    iSaccDirs(1, jSaccade) = mod((180/pi * atan2(deltaY, deltaX)), 360);
    
    % Compute saccade duration
    iSaccDurs(1, jSaccade) = jEnd - jBegin;
    
    % Compute saccade velocity
    iSaccVels(1, jSaccade) = max(velocityXY(jBegin:jEnd));
    
end

% Use a few common sense checks to remove physiologically impossible saccades
iSaccsNBlinks = iSaccBegins;
iSaccBegins(iSaccVels > velocityCutoff) = [];
iSaccEnds  (iSaccVels > velocityCutoff) = [];
iSaccAmps  (iSaccVels > velocityCutoff) = [];
iSaccDirs  (iSaccVels > velocityCutoff) = [];
iSaccDurs  (iSaccVels > velocityCutoff) = [];
iSaccVels  (iSaccVels > velocityCutoff) = [];

iSaccBegins(iSaccAmps == 0) = [];
iSaccEnds  (iSaccAmps == 0) = [];
iSaccDirs  (iSaccAmps == 0) = [];
iSaccDurs  (iSaccAmps == 0) = [];
iSaccVels  (iSaccAmps == 0) = [];
iSaccAmps  (iSaccAmps == 0) = [];

% Make sure we don't have too many saccades (see comment about calculating
% maxSamples above)
if length(iSaccBegins) > maxSamples
    
    iSaccBegins(maxSamples+1 : end) = [];
    iSaccEnds  (maxSamples+1 : end) = [];
    iSaccDirs  (maxSamples+1 : end) = [];
    iSaccDurs  (maxSamples+1 : end) = [];
    iSaccVels  (maxSamples+1 : end) = [];
    iSaccAmps  (maxSamples+1 : end) = [];
    
end



end
