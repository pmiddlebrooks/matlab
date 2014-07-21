function [ADvalues ADname] = plexon_ADchannels_translation(path,...
    file,...
    channel,...
    X_gain,...
    Y_gain,...
    X_offset,...
    Y_offset,...
    Date_Number)

% see: plx2mat_ADchannels.m

if nargin < 4
    X_gain      = 1;
    Y_gain      = 1;
    X_offset    = 0;
    Y_offset    = 0;
    Date_Number = 0;
end

% this is rig and date specific
% conditional statements may be added
if Date_Number < 734597
    x_channel = 49;
    y_channel = 50;
elseif Date_Number >= 734597 % 04-Apr-2011 (moved eye channels to top)
    x_channel = 63;
    y_channel = 64;
end


% name the channel 
if channel < 10
    ADname = ['AD0',num2str(channel)];
else
    ADname = ['AD',num2str(channel)];
end

if channel == x_channel
    ADname = 'EyeX_';
elseif channel == y_channel
    ADname = 'EyeY_';
end


% get the data for the channel
[adfreq, n, start_times, frag_ns, ADvalues] = plx_ad_v([path file],channel-1);

% get starting time for each fragment of analog data. (if data collection
% was interrupted there will be multiple fragments.)

% actual time stamps
start_times = round(start_times * 1000);
end_times   = frag_ns + start_times - 1;

start_frags(1) = 1;
for ii = 2:length(start_times)
    start_frags(ii) = start_frags(ii-1) + frag_ns(ii-1);
end

if length(start_frags)
    end_frags(1:length(start_frags ) - 1) = start_frags(2:end) - 1;
    end_frags(end + 1) = length(ADvalues);
else
    end_frags = length(ADvalues);
end

% now fill in zeros for all the time when we weren't actually collecting
% data.
time_corrected_data(1:end_times(end)) = 0;
for ii = 1:length(start_times)
    time_corrected_data(start_times(ii)+1:end_times(ii)+1) = ADvalues(start_frags(ii):end_frags(ii));
end
ADvalues = time_corrected_data';
clear time_corrected_data


% if it is an eye channel, do some post processing
if strcmp(ADname,'EyeX_') ||...
        strcmp(ADname,'EyeY_')
    
    % convert the channel from voltage to degrees
    if channel == x_channel
        ADvalues = (ADvalues * X_gain) - X_offset; %this may need to be done to take vector into account
    elseif channel == y_channel
        ADvalues = (ADvalues * Y_gain) - Y_offset; %this may need to be done to take vector into account
        ADvalues = -ADvalues;
    end    
    
    % gaussian polynomial for convolving eye traces
    poly_width = 12;
    polyn = gaussmf(poly_width/-2:poly_width/2, [poly_width/4,0]);
    polyn = polyn/sum(polyn); % now it sums to 1
    
    %smooth out analog line noise
    ADvalues = conv_2009a(ADvalues,polyn,'same'); 
    
end




