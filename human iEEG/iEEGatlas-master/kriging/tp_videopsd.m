% original channel is ordered by subjects
% summarize the psd as age, region
clean;
load WakefulnessMatlabFile.mat;
% load psdf;
clearvars -except AgeAtTimeOfStudy ChannelRegion RegionName psdall freq Patient
[nf,nc]=size(psdall);

% Note that patients (51, 86, 95, 105) are unused
% figure, histogram(Patient,110);
idx1 = Patient>=52&Patient<=85;
idx2 = Patient>=87&Patient<=94;
idx3 = Patient>=96&Patient<=104;
idx4 = Patient>=106;
Patient(idx1)=Patient(idx1)-1;
Patient(idx2)=Patient(idx2)-2;
Patient(idx3)=Patient(idx3)-3;
Patient(idx4)=Patient(idx4)-4;
clear idx*;

ChannelAge = zeros(nc,1);
for i=1:nc
    ChannelAge(i)=AgeAtTimeOfStudy(Patient(i));
end

% sort by region and age
[ChannelRegionSorted, idx_region]=sort(ChannelRegion);
PsdSortByRegion=psdall(:,idx_region);
ChannelAgeSortByRegion=ChannelAge(idx_region);

[ChannelAgeSorted, idx_age]=sort(ChannelAge);
PsdSortByAge=psdall(:,idx_age);
ChannelRegionSortByAge=ChannelRegion(idx_age);

% Region vs. Age
figure,plot(ChannelAgeSorted,ChannelRegionSortByAge,'.','markersize',10)
xlim([13 62]);ylim([1 38]); xlabel('Age'); ylabel('Region');set(gca,'fontsize',12);
set(gca,'ytick',1:38)

% make video
v1=VideoWriter('PsdSortByRegion.avi');
v2=VideoWriter('PsdSortByAge.avi');
rect = 0.98*[-56 -56 544 430];
maxpsd = max(psdall(:));
open(v1);
open(v2);

for i=1:nc
    f1=figure; plot(freq,PsdSortByRegion(:,i),'linewidth',2);
    xlabel('Frequencies'); ylabel('PSD'); title(RegionName{ChannelRegionSorted(i)});set(gca,'fontsize',12);
    
    f2=figure; plot(freq,PsdSortByAge(:,i),'linewidth',2);
    xlabel('Frequencies'); ylabel('PSD'); title(strcat('Age=',num2str(ChannelAgeSorted(i))));set(gca,'fontsize',12);
    
    figure(f1), drawnow;    ax = gca;
    %     ax.Units = 'pixels';     pos = ax.Position;
    %     ti = ax.TightInset;     rect1 = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
    a1 = getframe(ax,rect);
    
    figure(f2), drawnow;    ax = gca;
    %     ax.Units = 'pixels';     pos = ax.Position;
    %     ti = ax.TightInset;     rect2 = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
    a2 = getframe(ax,rect);
    
    close all;
    
    disp(i);
    
    writeVideo(v1,a1.cdata);
    writeVideo(v2,a2.cdata);
end
close(v1);
close(v2);