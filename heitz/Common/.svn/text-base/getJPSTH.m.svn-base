%script to return JPSTH - takes care of all the setup routines
%window = time window to use
%binwidth = size of bins to count spikes
%coin_width = width (in ms) for the coincidence histogram (x ms / 2 on either side of main diagonal... i.e., average over lags)
%
%RPH

function [output] = getJPSTH(sig1,sig2,window,binwidth,coin_width,trls,plotFlag)

if nargin < 7; plotFlag = 0; end
if nargin < 6; trls = 1:size(sig1,1); end
if nargin < 5 || isempty(coin_width); coin_width = 20; end
if nargin < 4 || isempty(binwidth); binwidth = 5; end
if nargin < 3 || isempty(window); window = [-500 2500]; end

Target_ = evalin('caller','Target_');

 sig1_aligned = align_timestamps(sig1(trls,:),Target_(trls,1));
 sig2_aligned = align_timestamps(sig2(trls,:),Target_(trls,1));

% FixTime_Jit_ = evalin('caller','FixTime_Jit_');
% sig1_aligned = sig1 - repmat(FixTime_Jit_,1,size(sig1,2));
% sig2_aligned = sig2 - repmat(FixTime_Jit_,1,size(sig2,2));

sig1_aligned = trim_time_stamps(sig1_aligned,window,binwidth);
sig2_aligned = trim_time_stamps(sig2_aligned,window,binwidth);

counts1 = spike_counts(sig1_aligned,window,binwidth);
counts2 = spike_counts(sig2_aligned,window,binwidth);

output = jpsth(counts1,counts2,coin_width);

if plotFlag
    fig2
    subplot(4,4,[2:4 6:8 10:12])
    imagesc(window(1):binwidth:window(2),window(1):binwidth:window(2),output.normalized_jpsth)
    axis xy
    colorbar
    set(gca,'xticklabel',[])
    set(gca,'yticklabel',[])
    dline
    
    subplot(4,4,[14:16])
    plot(window(1):binwidth:window(2)-1,output.psth_1)
    box off
    colorbar
    xlim([window(1) window(2)])
    set(gca,'ydir','reverse')
    set(gca,'yticklabel',[])
    xlabel('Neuron 1')
    
    subplot(4,4,[1 5 9])
    plot(output.psth_2,window(1):binwidth:window(2)-1)
    ylim([window(1) window(2)])
    set(gca,'xticklabel',[])
    set(gca,'xdir','reverse')
    box off
    ylabel('Neuron 2')
    
    
    fig1
    subplot(221)
    plot(window(1):binwidth:window(2)-1,output.pstch)
    xlim([window(1) window(2)])
    title(['Coincidence Histogram of width ' mat2str(coin_width) ' ms'])
    
    subplot(222)
    plot(-50:50,output.covariogram)
    title('Covariogram over entire time window')
    xlabel('Lag (ms)')
    vline(0,'k')
end