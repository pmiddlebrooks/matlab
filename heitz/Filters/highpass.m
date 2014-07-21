function sig = highpass(sig,stopfreq)
%HIGHPASS Returns a discrete-time filter object.

%
% M-File generated by MATLAB(R) 7.8 and the Signal Processing Toolbox 6.11.
%
% Generated on: 27-Apr-2009 14:46:36
%

% Butterworth Highpass filter designed using FDESIGN.HIGHPASS.

% All frequency values are in Hz.
% Fs = 1000;  % Sampling Frequency
%
% Fstop = 40;          % Stopband Frequency
% Fpass = 41;          % Passband Frequency
% Astop = 80;          % Stopband Attenuation (dB)
% Apass = 1;           % Passband Ripple (dB)
% match = 'stopband';  % Band to match exactly
%
% % Construct an FDESIGN object and call its BUTTER method.
% h  = fdesign.highpass(Fstop, Fpass, Astop, Apass, Fs);
% Hd = design(h, 'butter', 'MatchExactly', match);

%forward & reverse FIR filter (zero-phase shift)
%not sure why order == 20

parallelFlag = 0;
if matlabpool('size') > 0; parallelFlag = 1; end

Order = 20;
Fs = 1000;
[b a] = fir1(Order,(stopfreq/(Fs/2)),'high');


%if matrix, do trial-by-trial; otherwise just filter vector
if isvector(sig)
    sig = filtfilt(b,a,sig);
else
    if parallelFlag
        parfor trl = 1:size(sig,1)
            sig(trl,:) = filtfilt(b,a,sig(trl,:));
        end
    else
        for trl = 1:size(sig,1)
            sig(trl,:) = filtfilt(b,a,sig(trl,:));
        end
    end
end

