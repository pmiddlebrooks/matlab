%make grand average coherence plots
% RPH

% frequency windows to average over

% NOTE: The below will create temporal coherence functions averaging across
% some frequency window.  If sigOnly is set to 1, only sessions with
% significant coherence in that region will be included (as it is set, it
% includes all time periods).  Keep in mind that when changing to, say, a
% lower frequency window, different sessions may thus be included as
% compared to a higher frequency window.

%frequency for plotting
sigOnly_both_range1 = [.01 10];
sigOnly_both_range2 = [35 100];

%frequency for plotting
freqwin = [35 100];
%freqwin = [.01 10];

%frequencies to check significance on
sigOnly_freqrange = [35 100];
%sigOnly_freqrange = [.01 10];


basewin = [-200 -100];

allGrandaverage = 0;
sigOnly = 1; %only use sessions that had some number of significant clusters
sigOnly_both = 0; %Coherence matrices must have significant coherence changes in both the gamma and low frequency bands

%make sure we've set things properly
if (sigOnly == 1 && sigOnly_both == 1); error('Check SigOnly Conditions'); end

truncate_at_RT = 0; %do you want to truncate each matrix at RT?


basecorrect_coh = 1; %do you want to baseline correct the coherence matrices (only works for raw)?
propFlag = 0; %do you want to plot Tin / Din or Tin - Din.  Set to 1 for former

if sigOnly == 1
    for sess = 1:size(Pcoh_all.in.all,3)
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.all(:,:,sess) = NaN;
            Pcoh_all.out.all(:,:,sess) = NaN;
            nsig.all(sess,1) = 0;
        else
            nsig.all(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.ss2(:,:,sess) = NaN;
            Pcoh_all.out.ss2(:,:,sess) = NaN;
            nsig.ss2(sess,1) = 0;
        else
            nsig.ss2(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.ss4(:,:,sess) = NaN;
            Pcoh_all.out.ss4(:,:,sess) = NaN;
            nsig.ss4(sess,1) = 0;
        else
            nsig.ss4(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.ss8(:,:,sess) = NaN;
            Pcoh_all.out.ss8(:,:,sess) = NaN;
            nsig.ss8(sess,1) = 0;
        else
            nsig.ss8(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.fast.ss2(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss2(:,:,sess) = NaN;
            nsig.fast.ss2(sess,1) = 0;
        else
            nsig.fast.ss2(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.fast.ss4(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss4(:,:,sess) = NaN;
            nsig.fast.ss4(sess,1) = 0;
        else
            nsig.fast.ss4(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.fast.ss8(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss8(:,:,sess) = NaN;
            nsig.fast.ss8(sess,1) = 0;
        else
            nsig.fast.ss8(sess,1) = 1;
        end
        
        
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.slow.ss2(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss2(:,:,sess) = NaN;
            nsig.slow.ss2(sess,1) = 0;
        else
            nsig.slow.ss2(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.slow.ss4(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss4(:,:,sess) = NaN;
            nsig.slow.ss4(sess,1) = 0;
        else
            nsig.slow.ss4(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.slow.ss8(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss8(:,:,sess) = NaN;
            nsig.slow.ss8(sess,1) = 0;
        else
            nsig.slow.ss8(sess,1) = 1;
        end
        
        
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.fast.all(:,:,sess) = NaN;
            Pcoh_all.out.fast.all(:,:,sess) = NaN;
            nsig.fast.all(sess,1) = 0;
        else
            nsig.fast.all(sess,1) = 1;
        end
        
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.slow.all(:,:,sess) = NaN;
            Pcoh_all.out.slow.all(:,:,sess) = NaN;
            nsig.slow.all(sess,1) = 0;
        else
            nsig.slow.all(sess,1) = 1;
        end
        
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
            Pcoh_all.in.err(:,:,sess) = NaN;
            Pcoh_all.out.err(:,:,sess) = NaN;
            nsig.err(sess,1) = 0;
        else
            nsig.err(sess,1) = 1;
        end
    end
else
    nsig.all = size(Pcoh_all.in.all,3);
    nsig.ss2 = size(Pcoh_all.in.ss2,3);
    nsig.ss4 = size(Pcoh_all.in.ss4,3);
    nsig.ss8 = size(Pcoh_all.in.ss8,3);
    nsig.fast = size(Pcoh_all.in.fast,3);
    nsig.slow = size(Pcoh_all.in.slow,3);
    nsig.err = size(Pcoh_all.in.err,3);
end


if sigOnly_both == 1
    for sess = 1:size(Pcoh_all.in.all,3)
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.all(:,:,sess) = NaN;
            Pcoh_all.out.all(:,:,sess) = NaN;
            nsig.all(sess,1) = 0;
        else
            nsig.all(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.ss2(:,:,sess) = NaN;
            Pcoh_all.out.ss2(:,:,sess) = NaN;
            nsig.ss2(sess,1) = 0;
        else
            nsig.ss2(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.ss4(:,:,sess) = NaN;
            Pcoh_all.out.ss4(:,:,sess) = NaN;
            nsig.ss4(sess,1) = 0;
        else
            nsig.ss4(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.ss8(:,:,sess) = NaN;
            Pcoh_all.out.ss8(:,:,sess) = NaN;
            nsig.ss8(sess,1) = 0;
        else
            nsig.ss8(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.fast.ss2(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss2(:,:,sess) = NaN;
            nsig.fast.ss2(sess,1) = 0;
        else
            nsig.fast.ss2(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.fast.ss4(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss4(:,:,sess) = NaN;
            nsig.fast.ss4(sess,1) = 0;
        else
            nsig.fast.ss4(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.fast.ss8(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss8(:,:,sess) = NaN;
            nsig.fast.ss8(sess,1) = 0;
        else
            nsig.fast.ss8(sess,1) = 1;
        end
        
        
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.slow.ss2(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss2(:,:,sess) = NaN;
            nsig.slow.ss2(sess,1) = 0;
        else
            nsig.slow.ss2(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.slow.ss4(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss4(:,:,sess) = NaN;
            nsig.slow.ss4(sess,1) = 0;
        else
            nsig.slow.ss4(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.slow.ss8(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss8(:,:,sess) = NaN;
            nsig.slow.ss8(sess,1) = 0;
        else
            nsig.slow.ss8(sess,1) = 1;
        end
        
        
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.fast.all(:,:,sess) = NaN;
            Pcoh_all.out.fast.all(:,:,sess) = NaN;
            nsig.fast.all(sess,1) = 0;
        else
            nsig.fast.all(sess,1) = 1;
        end
        
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.slow.all(:,:,sess) = NaN;
            Pcoh_all.out.slow.all(:,:,sess) = NaN;
            nsig.slow.all(sess,1) = 0;
        else
            nsig.slow.all(sess,1) = 1;
        end
        
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range1(1) & f_shuff <= sigOnly_both_range1(2)),sess))) || ...
                ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=sigOnly_both_range2(1) & f_shuff <= sigOnly_both_range2(2)),sess)))
            Pcoh_all.in.err(:,:,sess) = NaN;
            Pcoh_all.out.err(:,:,sess) = NaN;
            nsig.err(sess,1) = 0;
        else
            nsig.err(sess,1) = 1;
        end
    end
else
    nsig.all = size(Pcoh_all.in.all,3);
    nsig.ss2 = size(Pcoh_all.in.ss2,3);
    nsig.ss4 = size(Pcoh_all.in.ss4,3);
    nsig.ss8 = size(Pcoh_all.in.ss8,3);
    nsig.fast = size(Pcoh_all.in.fast,3);
    nsig.slow = size(Pcoh_all.in.slow,3);
    nsig.err = size(Pcoh_all.in.err,3);
end


if truncate_at_RT == 1
    for sess = 1:size(Pcoh_all.in.all,3)
        Pcoh_all.in.all(find(tout >= RTs.all(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.all(find(tout >= RTs.all(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.ss2(find(tout >= RTs.ss2(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.ss2(find(tout >= RTs.ss2(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.ss4(find(tout >= RTs.ss4(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.ss4(find(tout >= RTs.ss4(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.ss8(find(tout >= RTs.ss8(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.ss8(find(tout >= RTs.ss8(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.err(find(tout >= RTs.err(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.err(find(tout >= RTs.err(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.fast.all(find(tout >= RTs.fast.all(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.fast.all(find(tout >= RTs.fast.all(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.fast.ss2(find(tout >= RTs.fast.ss2(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.fast.ss2(find(tout >= RTs.fast.ss2(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.fast.ss4(find(tout >= RTs.fast.ss4(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.fast.ss4(find(tout >= RTs.fast.ss4(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.fast.ss8(find(tout >= RTs.fast.ss8(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.fast.ss8(find(tout >= RTs.fast.ss8(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.slow.all(find(tout >= RTs.slow.all(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.slow.all(find(tout >= RTs.slow.all(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.slow.ss2(find(tout >= RTs.slow.ss2(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.slow.ss2(find(tout >= RTs.slow.ss2(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.slow.ss4(find(tout >= RTs.slow.ss4(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.slow.ss4(find(tout >= RTs.slow.ss4(sess,1)):length(tout),:,sess) = NaN;
        
        Pcoh_all.in.slow.ss8(find(tout >= RTs.slow.ss8(sess,1)):length(tout),:,sess) = NaN;
        Pcoh_all.out.slow.ss8(find(tout >= RTs.slow.ss8(sess,1)):length(tout),:,sess) = NaN;
        
    end
end

%grand average coherence using all data
if allGrandaverage == 1 & propFlag == 1
    
    %============
    % ALL
    d_all = nanmean(abs(Pcoh_all.in.all),3) ./ nanmean(abs(Pcoh_all.out.all),3);
    
    
    figure
    imagesc(tout,f,d_all')
    axis xy
    xlim([-50 500])
    colorbar
    z.all = get(gca,'clim');
    fw
    title('Tin - Tout ALL Full data set')
    
    
    
    %============
    % SS2
    d_ss2 = nanmean(abs(Pcoh_all.in.ss2),3) ./ nanmean(abs(Pcoh_all.out.ss2),3);
    
    
    figure
    imagesc(tout,f,d_ss2')
    axis xy
    xlim([-50 500])
    colorbar
    z.ss2 = get(gca,'clim');
    fw
    title('Tin - Tout SS2 Full data set')
    
    
    
    %============
    % ss4
    d_ss4 = nanmean(abs(Pcoh_all.in.ss4),3) ./ nanmean(abs(Pcoh_all.out.ss4),3);
    
    figure
    imagesc(tout,f,d_ss4')
    axis xy
    xlim([-50 500])
    colorbar
    set(gca,'clim',z.ss2) %set to ss2
    fw
    title('Tin - Tout ss4 Full data set')
    
    
    
    
    %============
    % ss8
    d_ss8 = nanmean(abs(Pcoh_all.in.ss8),3) ./ nanmean(abs(Pcoh_all.out.ss8),3);
    
    
    figure
    imagesc(tout,f,d_ss8')
    axis xy
    xlim([-50 500])
    colorbar
    set(gca,'clim',z.ss2) %set to ss2
    fw
    title('Tin - Tout ss8 Full data set')
    
    
    
    %============
    % fast
    d_fast = nanmean(abs(Pcoh_all.in.fast),3) ./ nanmean(abs(Pcoh_all.out.fast),3);
    
    
    figure
    imagesc(tout,f,d_fast')
    axis xy
    xlim([-50 500])
    colorbar
    z.fast = get(gca,'clim');
    fw
    title('Tin - Tout fast Full data set')
    
    %============
    % slow
    d_slow = nanmean(abs(Pcoh_all.in.slow),3) ./ nanmean(abs(Pcoh_all.out.slow),3);
    
    %     in_removed = Pcoh_all.in.slow;
    %     in_removed(:,:,find(remove)) = NaN;
    %
    %     out_removed = Pcoh_all.out.slow;
    %     out_removed(:,:,find(remove)) = NaN;
    %
    %     d_removed = nanmean(abs(in_removed),3) ./ nanmean(abs(out_removed),3);
    
    
    figure
    imagesc(tout,f,d_slow')
    axis xy
    xlim([-50 500])
    colorbar
    set(gca,'clim',z.fast)
    fw
    title('Tin - Tout slow Full data set')
    
    %============
    
    
    %============
    % err
    d_err = nanmean(abs(Pcoh_all.in.err),3) ./ nanmean(abs(Pcoh_all.out.err),3);
    
    
    figure
    imagesc(tout,f,d_err')
    axis xy
    xlim([-50 500])
    colorbar
    set(gca,'clim',z.all) %rescale to all correct trial matrix
    fw
    title('Tin - Tout err Full data set')
    
    
elseif allGrandaverage == 1 & propFlag == 0
    
    %============
    % ALL
    d_all = nanmean(abs(Pcoh_all.in.all),3) - nanmean(abs(Pcoh_all.out.all),3);
    
    if basecorrect_coh == 1
        d_all = baseline_correct(d_all',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout,f,d_all')
    axis xy
    xlim([-50 500])
    colorbar
    z.all = get(gca,'clim');
    fw
    title('Tin - Tout ALL Full data set')
    
    
    %============
    % SS2
    d_ss2 = nanmean(abs(Pcoh_all.in.ss2),3) - nanmean(abs(Pcoh_all.out.ss2),3);
    
    if basecorrect_coh == 1
        d_ss2 = baseline_correct(d_ss2',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout,f,d_ss2')
    axis xy
    xlim([-50 500])
    colorbar
    z.ss2 = get(gca,'clim');
    fw
    title('Tin - Tout SS2 Full data set')
    
    
    %============
    % ss4
    d_ss4 = nanmean(abs(Pcoh_all.in.ss4),3) - nanmean(abs(Pcoh_all.out.ss4),3);
    
    if basecorrect_coh == 1
        d_ss4 = baseline_correct(d_ss4',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout,f,d_ss4')
    axis xy
    xlim([-50 500])
    colorbar
    set(gca,'clim',z.ss2)
    fw
    title('Tin - Tout ss4 Full data set')
    
    
    %============
    % ss8
    d_ss8 = nanmean(abs(Pcoh_all.in.ss8),3) - nanmean(abs(Pcoh_all.out.ss8),3);
    
    if basecorrect_coh == 1
        d_ss8 = baseline_correct(d_ss8',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout,f,d_ss8')
    axis xy
    xlim([-50 500])
    colorbar
    set(gca,'clim',z.ss2)
    fw
    title('Tin - Tout ss8 Full data set')
    
    
    
    %============
    % fast
    d_fast = nanmean(abs(Pcoh_all.in.fast),3) - nanmean(abs(Pcoh_all.out.fast),3);
    
    if basecorrect_coh == 1
        d_fast = baseline_correct(d_fast',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout,f,d_fast')
    axis xy
    xlim([-50 500])
    colorbar
    z.fast = get(gca,'clim');
    fw
    title('Tin - Tout fast Full data set')
    
    
    %============
    % slow
    d_slow = nanmean(abs(Pcoh_all.in.slow),3) - nanmean(abs(Pcoh_all.out.slow),3);
    
    
    if basecorrect_coh == 1
        d_slow = baseline_correct(d_slow',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout,f,d_slow')
    axis xy
    xlim([-50 500])
    colorbar
    set(gca,'clim',z.fast)
    fw
    title('Tin - Tout slow Full data set')
    
    
    
    %============
    % err
    d_err = nanmean(abs(Pcoh_all.in.err),3) - nanmean(abs(Pcoh_all.out.err),3);
    
    
    if basecorrect_coh == 1
        d_err = baseline_correct(d_err',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    
    figure
    imagesc(tout,f,d_err')
    axis xy
    xlim([-50 500])
    colorbar
    set(gca,'clim',z.all)
    fw
    title('Tin - Tout err Full data set')
    
    
end
%========================
%========================
% Time based-analyses


dif.all_sub = abs(Pcoh_all.in.all_sub) - abs(Pcoh_all.out.all_sub);
dif.all = abs(Pcoh_all.in.all) - abs(Pcoh_all.out.all);
dif.ss2 = abs(Pcoh_all.in.ss2) - abs(Pcoh_all.out.ss2);
dif.ss4 = abs(Pcoh_all.in.ss4) - abs(Pcoh_all.out.ss4);
dif.ss8 = abs(Pcoh_all.in.ss8) - abs(Pcoh_all.out.ss8);
dif.fast.ss2 = abs(Pcoh_all.in.fast.ss2) - abs(Pcoh_all.out.fast.ss2);
dif.fast.ss4 = abs(Pcoh_all.in.fast.ss4) - abs(Pcoh_all.out.fast.ss4);
dif.fast.ss8 = abs(Pcoh_all.in.fast.ss8) - abs(Pcoh_all.out.fast.ss8);
dif.slow.ss2 = abs(Pcoh_all.in.slow.ss2) - abs(Pcoh_all.out.slow.ss2);
dif.slow.ss4 = abs(Pcoh_all.in.slow.ss4) - abs(Pcoh_all.out.slow.ss4);
dif.slow.ss8 = abs(Pcoh_all.in.slow.ss8) - abs(Pcoh_all.out.slow.ss8);
dif.fast.all = abs(Pcoh_all.in.fast.all) - abs(Pcoh_all.out.fast.all);
dif.slow.all = abs(Pcoh_all.in.slow.all) - abs(Pcoh_all.out.slow.all);
dif.err = abs(Pcoh_all.in.err) - abs(Pcoh_all.out.err);

%======
% Baseline corrected versions

allsubdif_bc = baseline_correct(transpose3(dif.all_sub),[find(tout == basewin(1)) find(tout == basewin(2))]);
alldif_bc = baseline_correct(transpose3(dif.all),[find(tout == basewin(1)) find(tout == basewin(2))]);
s2dif_bc = baseline_correct(transpose3(dif.ss2),[find(tout == basewin(1)) find(tout == basewin(2))]);
s4dif_bc = baseline_correct(transpose3(dif.ss4),[find(tout == basewin(1)) find(tout == basewin(2))]);
s8dif_bc = baseline_correct(transpose3(dif.ss8),[find(tout == basewin(1)) find(tout == basewin(2))]);
fs_ss2_dif_bc = baseline_correct(transpose3(dif.fast.ss2),[find(tout == basewin(1)) find(tout == basewin(2))]);
fs_ss4_dif_bc = baseline_correct(transpose3(dif.fast.ss4),[find(tout == basewin(1)) find(tout == basewin(2))]);
fs_ss8_dif_bc = baseline_correct(transpose3(dif.fast.ss8),[find(tout == basewin(1)) find(tout == basewin(2))]);
sl_ss2_dif_bc = baseline_correct(transpose3(dif.slow.ss2),[find(tout == basewin(1)) find(tout == basewin(2))]);
sl_ss4_dif_bc = baseline_correct(transpose3(dif.slow.ss4),[find(tout == basewin(1)) find(tout == basewin(2))]);
sl_ss8_dif_bc = baseline_correct(transpose3(dif.slow.ss8),[find(tout == basewin(1)) find(tout == basewin(2))]);
fs_all_dif_bc = baseline_correct(transpose3(dif.fast.all),[find(tout == basewin(1)) find(tout == basewin(2))]);
sl_all_dif_bc = baseline_correct(transpose3(dif.slow.all),[find(tout == basewin(1)) find(tout == basewin(2))]);
errdif_bc = baseline_correct(transpose3(dif.err),[find(tout == basewin(1)) find(tout == basewin(2))]);

allsubdif_bc = squeeze(nanmean(allsubdif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
alldif_bc = squeeze(nanmean(alldif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s2dif_bc = squeeze(nanmean(s2dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s4dif_bc = squeeze(nanmean(s4dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s8dif_bc = squeeze(nanmean(s8dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fs_ss2_dif_bc = squeeze(nanmean(fs_ss2_dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fs_ss4_dif_bc = squeeze(nanmean(fs_ss4_dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fs_ss8_dif_bc = squeeze(nanmean(fs_ss8_dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sl_ss2_dif_bc = squeeze(nanmean(sl_ss2_dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sl_ss4_dif_bc = squeeze(nanmean(sl_ss4_dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sl_ss8_dif_bc = squeeze(nanmean(sl_ss8_dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fs_all_dif_bc = squeeze(nanmean(fs_all_dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sl_all_dif_bc = squeeze(nanmean(sl_all_dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
errdif_bc = squeeze(nanmean(errdif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));


%===========
% No baseline correction version
allsubdif = transpose3(dif.all_sub);
alldif = transpose3(dif.all);
s2dif = transpose3(dif.ss2);
s4dif = transpose3(dif.ss4);
s8dif = transpose3(dif.ss8);
fs_ss2_dif = transpose3(dif.fast.ss2);
fs_ss4_dif = transpose3(dif.fast.ss4);
fs_ss8_dif = transpose3(dif.fast.ss8);
sl_ss2_dif = transpose3(dif.slow.ss2);
sl_ss4_dif = transpose3(dif.slow.ss4);
sl_ss8_dif = transpose3(dif.slow.ss8);
fs_all_dif = transpose3(dif.fast.all);
sl_all_dif = transpose3(dif.slow.all);
errdif = transpose3(dif.err);


allsubdif = squeeze(nanmean(allsubdif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
alldif = squeeze(nanmean(alldif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s2dif = squeeze(nanmean(s2dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s4dif = squeeze(nanmean(s4dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s8dif = squeeze(nanmean(s8dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fs_ss2_dif = squeeze(nanmean(fs_ss2_dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fs_ss4_dif = squeeze(nanmean(fs_ss4_dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fs_ss8_dif = squeeze(nanmean(fs_ss8_dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sl_ss2_dif = squeeze(nanmean(sl_ss2_dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sl_ss4_dif = squeeze(nanmean(sl_ss4_dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sl_ss8_dif = squeeze(nanmean(sl_ss8_dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fs_all_dif = squeeze(nanmean(fs_all_dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sl_all_dif = squeeze(nanmean(sl_all_dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
errdif = squeeze(nanmean(errdif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));



% Time Tests for fast vs. slow
% Use Wilcoxon signrank test (versus 0) to find timing of fast vs slow
% gamma band coherence. Start at 100 ms
start = find(tout == 100);

for t = start:size(fs_all_dif,1)
    if ~all(isnan(fs_all_dif(t,:)))
        [fsp(t) fsh(t)] = signrank(fs_all_dif(t,:));
        [fsp_bc(t) fsh_bc(t)] = signrank(fs_all_dif_bc(t,:));
    else
        fsp(t) = 1;
        fsh(t) = 0;
        fsp_bc(t) = 1;
        fsh_bc(t) = 0;
    end
end

temp = tout(findRuns(fsh,10));
time_fast = min(temp(find(temp > 0)));
clear temp

temp = tout(findRuns(fsh_bc,10));
time_fast_bc = min(temp(find(temp > 0)));
clear temp


for t = start:size(sl_all_dif,1)
    if ~all(isnan(sl_all_dif(t,:)))
        [slp(t) slh(t)] = signrank(sl_all_dif(t,:));
        [slp_bc(t) slh_bc(t)] = signrank(sl_all_dif_bc(t,:));
    else
        slp(t) = 1;
        slh(t) = 0;
        slp_bc(t) = 1;
        slh_bc(t) = 0;
    end
end

temp = tout(findRuns(slh,10));
time_slow = min(temp(find(temp > 0)));
clear temp

temp = tout(findRuns(slh_bc,10));
time_slow_bc = min(temp(find(temp > 0)));
clear temp

%=========
figure
subplot(3,2,1)
plot(tout,nanmean(s2dif,2),'b',tout,nanmean(s4dif,2),'r',tout,nanmean(s8dif,2),'g')
xlim([-200 500])
hline(0,'k')
title('Tin - Din Full No Baseline Correction')

subplot(3,2,3)
plot(tout,nanmean(fs_all_dif,2),'r',tout,nanmean(sl_all_dif,2),'b')
xlim([-200 500])
hline(0,'k')
title('Tin - Din Full no Baseline Correction')

subplot(3,2,5)
plot(tout,nanmean(alldif,2),'k',tout,nanmean(allsubdif,2),'--k',tout,nanmean(errdif,2),'r')
xlim([-200 500])
hline(0,'k')
hline(0,'k')
title('Errors Full no Baseline Correction')

subplot(3,2,2)
plot(tout,nanmean(s2dif_bc,2),'b',tout,nanmean(s4dif_bc,2),'r',tout,nanmean(s8dif_bc,2),'g')
xlim([-200 500])
hline(0,'k')
title('Tin - Din Full Baseline Correction')

subplot(3,2,4)
plot(tout,nanmean(fs_all_dif_bc,2),'r',tout,nanmean(sl_all_dif_bc,2),'b')
xlim([-200 500])
hline(0,'k')
title('Tin - Din Full Baseline Correction')

subplot(3,2,6)
plot(tout,nanmean(alldif_bc,2),'k',tout,nanmean(allsubdif_bc,2),'--k',tout,nanmean(errdif_bc,2),'r')
xlim([-200 500])
hline(0,'k')
title('Errors Full Baseline Correction')
%=========


%=======
figure
subplot(2,2,1)
plot(tout,nanmean(fs_all_dif,2),'r',tout,nanmean(sl_all_dif,2),'b')
vline(time_fast,'r')
vline(time_slow,'b')
xlim([-200 500])
hline(0,'k')
title('No baseline correct, full data set')


subplot(2,2,3)
plot(tout,nanmean(fs_all_dif_bc,2),'r',tout,nanmean(sl_all_dif_bc,2),'b')
vline(time_fast_bc,'r')
vline(time_slow_bc,'b')
xlim([-200 500])
hline(0,'k')
title('Baseline corrected, full data set')

