clear all
% clear all
% close all
% rand('seed',5107);
% randn('seed',5107);
rand('seed',4);
randn('seed',4);

record_movie = 0;
FrameCount = 0;
do_ind_trials = 1; %do you want to animate each individual trial?
do_all_trials = 0; %do you want to show a final product?

sd = .6; %drift constant
numsamps = 1100; %number of samps per trial - keep high to ensure
numtrials = 100; %number of trials
%convergence on a decision
%criterion = 15;
criterion = 25; %relative evidence for resp
%drift = .5;
drift = .55;

X_ax = [0 1000];

for numSims = 1:1
    

    
    respA = 0;
    respB = 0; %set # responses for resp a and b to 0
    %hold all %hold "all" cycles through colors...hold "on" uses a single color
    crt = 0; %counter for correct finishing times
    err = 0; %counter for error finishing times
    
    %samp = zeros(numtrials,numsamps); %initialize memory for array
    
    %tic
    
    finishingTimesCorrect(1:numtrials) = NaN;
    finishingTimesErrors(1:numtrials) = NaN;
    
    for trial = 1:numtrials
        samp(trial,1) = 0; %start diffusion at 0
        %disp(trial);

        
        %drift = randn*sd + .75; %drift of .75 with variability
        
        trlNoise = randn*sd;
        
        for sampdex = 2:numsamps %use enough trials that will converge on a decision
            
            if randn + trlNoise < drift
                samp(trial,sampdex) = samp(trial,sampdex-1) + 1;
            else
                samp(trial,sampdex) = samp(trial,sampdex-1) - 1;
            end
            
            if samp(trial,sampdex) > criterion
                respA = respA + 1;
                finishingTimesCorrect(trial) = sampdex;
                finishingTimesErrors(trial) = 0;
                crt = crt + 1;
                break
            elseif samp(trial,sampdex) < criterion*-1
                respB = respB + 1;
                finishingTimesErrors(trial) = sampdex;
                finishingTimesCorrect(trial) = 0;
                err = err + 1;
                break
            end
            
        end
    end
    %toc
    %     figure
    %     subplot(3,1,2)
    %     hist(finishingTimesCorrect,10);
    %     subplot(3,1,3)
    %     %hist(finishingTimesErrors,10);
    %
    %     %print out accuracy rate
    %     acc = respA / (respA + respB)
    %     meanCrt = mean(finishingTimesCorrect)
    %meanErr = mean(finishingTimesErrors)
end
pC = round((crt) / (crt+err)*100)/100;
pE = round((err) / (crt+err)*100)/100;

disp(['% Correct = ' mat2str(pC)])
disp(['% Error = ' mat2str(pE)])

%remove unwanted (RT too long)
remove = find(finishingTimesCorrect > 500);
finishingTimesCorrect(remove) = [];
samp(remove,:) = [];


[tempn] = histc(finishingTimesCorrect,1:10:X_ax(2));
topHist_correct = max(tempn);

[tempn] = histc(finishingTimesErrors,1:10:X_ax(2));
topHist_errors = max(tempn);


%find trials in which the evidence was negative, then went positive
for trl = 12:12%size(samp,1)
    if length(find(samp(trl,:) < 0)) > 1 && length(find(samp(trl,:) > 0)) > 1
        bothtrl(trl,1) = 1;
    else
        bothtrl(trl,1) = 0;
    end
end

bothtrls = find(bothtrl);

%simulations computed, now animate
if do_ind_trials == 1;
    %initialize frames
    figure
    scrsz = get(0,'ScreenSize');
    %full screen
    figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)])
    plotBW
    
    %start histograms
    subplot(6,1,1)
    plotBW
    set(gca,'fontsize',40)
    ylabel('Correct','fontsize',40','fontweight','bold')
    set(gca,'xticklabel',0:200:1000)
    ylim([0 topHist_correct])
    xlim([0 250])
    set(gca,'xtick',[])
    
    subplot(6,1,6)
    plotBW
    set(gca,'fontsize',40)
    ylabel('Error','fontsize',40','fontweight','bold')
    xlim([0 250])
    set(gca,'xticklabel',0:200:1000)
    ylim([0 topHist_correct/3])
    set(gca,'YDir','reverse');
    set(gca,'xtick',[])
    
    subplot(6,1,2:5)
    plotBW
    set(gca,'fontsize',40)
    hold on
    %ylim([-1*(criterion+10) criterion+10]);
    ylim([-35 35])
    xlim([X_ax(1) X_ax(2)])
    h1 = hline(criterion,'--white');
    h2 = hline(-criterion,'--white');
    h3 = hline(0,'white');
    ylabel('Activation','fontsize',40,'fontweight','bold')
    
    set(h1,'linewidth',2)
    set(h2,'linewidth',2)
    set(h3,'linewidth',2)
%     
%     F(FrameCount) = getframe(gcf);
%     FrameCount = FrameCount + 1;
    
    for trl = 12:12%size(samp,1)
        subplot(6,1,2:5)
        ylabel('Activation','fontsize',40,'fontweight','bold')
        
        endt = find(samp(trl,:),1,'last');
        for time = 1:1:endt
            FrameCount = FrameCount + 1;
            plot(nonzeros(samp(trl,1:time)),'r','linewidth',2);
            pause(.00001)
            ylim([-1*(criterion+10) criterion+10]);
            %xlim([X_ax(1) X_ax(2)])
            xlim([0 250])
            set(gca,'xticklabel',0:200:1000)
            
            if record_movie; F(FrameCount) = getframe(gcf); end
        end
        
        %now draw tentative histogram
        subplot(6,1,1)
        cla
        box off
        set(gca,'fontsize',40)
        %[n,bin] = histc(finishingTimesCorrect(1:trl),1:10:X_ax(2));
        [n,bin] = histc(finishingTimesCorrect(12),1:10:X_ax(2));
        bar(1:10:X_ax(2),n,'facecolor','r','edgecolor','r');
        %xlim([X_ax(1) X_ax(2)])
        plotBW
%         set(gca,'color','k')
        xlim([0 250])
        set(gca,'xticklabel',0:200:1000) %this is WRONG but I want it to look right (just a demonstration)
        ylim([0 topHist_correct])
        set(gca,'xtick',[])
        ylabel('Correct','fontsize',40,'fontweight','bold')
        
        %if ~isempty(find(~isnan(finishingTimesErrors)))
        subplot(6,1,6)
        cla
        box off
        set(gca,'fontsize',40)
        %[n,bin] = histc(finishingTimesErrors(1:trl),1:10:X_ax(2));
        [n,bin] = histc(finishingTimesErrors(12),1:10:X_ax(2));
        bar(1:10:X_ax(2),n,'facecolor','r','edgecolor','r')
        %xlim([X_ax(1) X_ax(2)])
        %set(gca,'color','k')
        plotBW
        xlim([0 250])
        set(gca,'xticklabel',0:200:1000) %this is WRONG but I want it to look right (just a demonstration)
        ylim([0 topHist_correct/3])
        set(gca,'YDir','reverse');
        set(gca,'xtick',[])
        ylabel('Errors','fontsize',40','fontweight','bold')
        %end
    end
end

if do_all_trials == 1;
    figure
    plotBW
    
    subplot(6,1,1)
    plotBW
    ylabel('Correct','fontsize',20,'fontweight','bold')
    
    subplot(6,1,6)
    set(gca,'color','k')
    ylabel('Error','fontsize',20,'fontweight','bold')
    
    subplot(6,1,2:5)
    plotBW
    hold on
    ylabel('Activation','fontsize',20,'fontweight','bold')
    
    
    for trl = 1:size(samp,1)
        plot(nonzeros(samp(trl,:)),'r','linewidth',2)
    end
    %xlim([X_ax(1) X_ax(2)])
    xlim([0 250])
    set(gca,'xticklabel',0:200:1000)
    %ylim([-1*(criterion+10) criterion+10]);
    ylim([-35 35])
    h1 = hline(criterion,'--white');
    h2 = hline(-criterion,'--white');
    h3 = hline(0,'white');
    
    set(h1,'linewidth',2)
    set(h2,'linewidth',2)
    set(h3,'linewidth',2)
    text(80,30,['p(Correct) = ' mat2str(pC)],'fontsize',20,'fontweight','bold')
    
    subplot(6,1,1)
    [n,bin] = histc(finishingTimesCorrect,1:10:X_ax(2));
    bar(1:10:X_ax(2),n,'facecolor','r')
    %xlim([X_ax(1) X_ax(2)])
    plotBW
    xlim([0 250])
    set(gca,'xticklabel',0:200:1000) %this is WRONG but I want it to look right (just a demonstration)
    ylim([0 topHist_correct])
    set(gca,'xtick',[])
    ylabel('Correct','fontsize',20,'fontweight','bold')
    
    %if ~isempty(find(~isnan(finishingTimesErrors)))
    subplot(6,1,6)
    [n,bin] = histc(finishingTimesErrors,1:10:X_ax(2));
    bar(1:10:X_ax(2),n,'facecolor','r')
    plotBW
    %xlim([X_ax(1) X_ax(2)])
    xlim([0 250])
    set(gca,'xticklabel',0:200:1000) %this is WRONG but I want it to look right (just a demonstration)
    ylim([0 topHist_correct/3])
    set(gca,'YDir','reverse')
    set(gca,'xtick',[]);
    ylabel('Errors','fontsize',20','fontweight','bold')
    %  end
    
    %make sure black background actually prints to file.
    set(gcf, 'InvertHardCopy', 'off')
end