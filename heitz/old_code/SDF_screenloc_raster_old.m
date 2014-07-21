%Richard P. Heitz
%Vanderbilt
%Draws SDFs and Rasters by screen location
%Runs on open file
%10/18/2007

%Do you want to save?
saveflag = 0;
Align_ = 'r';
%Call script "fixErrors" to make sure we have that variable

% if exist('ContrastFlag')
%     if ContrastFlag == 1
%         eval('fixErrors_CONTRAST')
%     else
%         eval('fixErrors')
%     end
% else
%     eval('fixErrors')
% end


CellName = [];
varlist = who;
%Set SDF parameters

%Fix "Errors_" variable
if exist('ContrastFlag') == 1
    if ContrastFlag == 1
        eval('fixErrors_CONTRAST')
    else
        eval('fixErrors')
    end
else
    eval('fixErrors')
end


%Get SRT from Eye Traces
if exist('SRT') == 0
    SRT = getSRT(EyeX_,EyeY_);
end


%Find Valid Trials (SRT >= 100 & difference between SRT & Decide < 40 ms)
if exist('ValidTrials') == 0
    [ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,CorrectTrials);
end

if Align_ == 's'
    Align_Time(1:length(Correct_),1) = 500;
    SDFPlot_Time = [-200 2000];
   % plot_time = (1:2500)*4-3;
elseif Align_ == 'r'
    Align_Time = SRT(:,1);
    SDFPlot_Time = [-400 400];
    
    %undo 500 ms SRT correction; spike times relative to 500 ms baseline
    Align_Time = Align_Time + 500;
   % plot_time = (1:801)*4-3;
end



%%%%%%%%%SRT(find(Target_(:,2) == 0),1)
%=================================================
%
%CALL SCRIPT getCellnames
%script because passed variables changes every file
eval('getCellnames')
%
%=================================================




for k = 1:length(CellNames)
    figure;
    orient landscape;
    set(gcf,'Color','white')
    CellName = eval(cell2mat(CellNames(k)));


    %draw SDFs

    for j = 0:7
        %Will be plotting with subplot, but need to specify where each
        %screen location will fall in subplot coordinates
        switch j
            case 0
                screenloc = 6;
            case 1
                screenloc = 3;
            case 2
                screenloc = 2;
            case 3
                screenloc = 1;
            case 4
                screenloc = 4;
            case 5
                screenloc = 7;
            case 6
                screenloc = 8;
            case 7
                screenloc = 9;
        end

        SDF=[];
               %[SDF] = spikedensityfunct_lgn_old(CellName, Align_Time, SDFPlot_Time, ValidTrials(find(Target_(ValidTrials,2) == j)), TrialStart_);
               [SDF] = spikedensityfunct_lgn_old(CellName, Align_Time, SDFPlot_Time, ValidTrials(find(Target_(ValidTrials,2) == j)), TrialStart_);


        %Find max firing rate (this is an efficient method and should be
        %revised in the future!)

        maxFire = 0;
        for SDF_j = 0:7
            Trls = ValidTrials(find(Target_(ValidTrials,2) == SDF_j));
            [temp_SDF] = spikedensityfunct_lgn_old(CellName, Align_Time, SDFPlot_Time, Trls, TrialStart_);
            if max(temp_SDF) > maxFire
                maxFire = max(temp_SDF);
            end
            clear Trls temp_SDF
        end



        subplot(3,3,screenloc)
        plot(SDFPlot_Time(1):SDFPlot_Time(2),SDF,'r','LineWidth',.5)


        numticks = round(maxFire/5);

        set(gca,'YTick',0:numticks:maxFire);
        

        if maxFire == 0
            ylim([0 1])
        else
            ylim([0 maxFire])
        end

        %LINE to mark average RT
        %  line([mean(SRT(ValidTrials,1)) mean(SRT(:,1))],[-10 10],'color','g')


        %title(CellNames(i))
        %     if max(SDF) > maxspike
        %         maxspike = max(SDF);
        %     end
        %         %set axis limits based on max SDF
        %         if j == 7
        %             ymax = max(SDF);
        %         end
        %ylim([0 100]);
        xlim(SDFPlot_Time);

        %Plot Raster

        %Find set of spikes corresponding to correct trials at current screen
        %location
        spikeset = CellName(ValidTrials(find(Target_(ValidTrials,2) == j)),:);
        trial_SRTs = SRT(ValidTrials(find(Target_(ValidTrials,2) == j)),1);

        hold on

        %========================RASTER=======================
        %want to fill each location from top to bottom with raster.  To
        %figure out the spacing, take the ylim(2) (here, the variable "a"
        %holds that), then divide by the number of trials, and that's your
        %spacing.
        trl = (maxFire/size(spikeset,1))/3;
        stepsz = (maxFire/size(spikeset,1))/3;
        
        if Align_ == 's'
            for t = 1:size(spikeset,1)
                if ~isempty(nonzeros(spikeset(t,find(spikeset(t,:)-500 <= SDFPlot_Time(2) & spikeset(t,:)-500 >= SDFPlot_Time(1)))))
                    plot(nonzeros(spikeset(t,find(spikeset(t,:)-500 <= SDFPlot_Time(2) & spikeset(t,:)-500 >= SDFPlot_Time(1))))-500,trl,'k')
                end
                trl = trl + stepsz;
            end
        elseif Align_ == 'r'
            
                %draw line at 0 to indicate response-locked
                line([0 0],[0 maxFire])
            for t = 1:size(spikeset,1)
                t
                if ~isempty(nonzeros(spikeset(t,find(spikeset(t,:)-Align_Time(t,1) <= SDFPlot_Time(2) & spikeset(t,:)-Align_Time(t,1) >= SDFPlot_Time(1)))))
                    plot(nonzeros(spikeset(t,find(spikeset(t,:)-Align_Time(t,1) <= SDFPlot_Time(2) & spikeset(t,:)-Align_Time(t,1) >= SDFPlot_Time(1))))-Align_Time(t,1),trl,'k')
                    plot(trial_SRTs(t)*-1,trl,'b^')
                end
                trl = trl + stepsz;
            end
        end

        %Plot CDF
        hold on
   if Align_ == 's'
        [RTs,bins] = hist(SRT(ValidTrials(find(Target_(ValidTrials,2) == j)),1),100);
        RT_cdf = (cumsum(RTs))/length(SRT(ValidTrials(find(Target_(ValidTrials,2) == j)),1)) * 100;
        ax1 = gca;
        ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
        hold on
        plot(bins,RT_cdf,'Parent',ax2,'color','b')
   end
        xlim(get(ax1,'xlim'))
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        hold off
        %title each subplot with number of observations
        title(strcat('nRT =  ',mat2str(sum(RTs)),'   nSDF =  ',mat2str(size(nonzeros(spikeset(:,1)),1))),'FontWeight','bold')
    end


    %draw FULL raster in center position
    subplot(3,3,5)
    ylim([0 size(CellName,1)])
    xlim(SDFPlot_Time)
    a = ylim;
    trl = a(2)/size(CellName,1);
    stepsz = a(2)/size(CellName,1);
    hold on

    for t = 1:size(CellName,1)
        if ~isempty(nonzeros(CellName(t,find(CellName(t,:)-500 <= SDFPlot_Time(2) & CellName(t,:)-500 >= SDFPlot_Time(1)))))
            %plot(nonzeros(CellName(t,:))-500,trl,'Color','k')
            plot(nonzeros(CellName(t,find(CellName(t,:)-500 <= SDFPlot_Time(2) & CellName(t,:)-500 >= SDFPlot_Time(1))))-500,trl,'k')
        end
        trl = trl + stepsz;
    end
    title(strcat('N =  ',mat2str(size(nonzeros(CellName(:,1)),1))),'FontWeight','bold')


    [ax,h1] = suplabel('Time from Target (ms)');
    set(h1,'FontSize',15)
    [ax,h2] = suplabel('spikes/sec','y');
    set(h2,'FontSize',15)

    if exist('newfile')
        [ax,h3] = suplabel(strcat('File: ',newfile,'     Cell: ',mat2str(cell2mat(CellNames(k))),'   Generated: ',date),'t');
        set(h3,'FontSize',12)
    elseif exist('batch_list')
        [ax,h3] = suplabel(strcat('File: ',batch_list(i).name,'     Cell: ',mat2str(cell2mat(CellNames(k))),'   Generated: ',date),'t');
        set(h3,'FontSize',12)

    else
        [ax,h3] = suplabel(strcat('Cell: ',mat2str(cell2mat(CellNames(k)))),'t');
        set(h3,'FontSize',12)
    end

    if saveflag == 1
        if exist('newfile') == 1
            eval(['print -dpdf ',newfile,'_',cell2mat(CellNames(k)),'_1.pdf']);
        elseif exist('batch_list')
            eval(['print -dpdf ',batch_list(i).name,'_',cell2mat(CellNames(k)),'_1.pdf']);
        end
    end

end
