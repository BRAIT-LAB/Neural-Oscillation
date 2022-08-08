clean;
addpath(genpath(cd))
load fittedamp; % smoothed amps
load presmooth
idx = [2 5 10 26];
tl = {'Delta','Theta','Alpha','Beta'};
figure,
for j=1:4
    i = idx(j);
    options.figname=num2str(j);
    options.texture=fittedamp(i,:)';
    subplot(2,2,j)
%     subplot(3,3,i-31); 
%     title(strcat('f = ',num2str(i)));
    title(tl{j});
    options.Parentaxis=gca;
    options.hfig=gcf;
    spm_eeg_render(cortex,options); 
    colormap(gca,jet);
    
end

figure,imagesc(log(fittedamp)),colormap(hot);
title('Smoothed Amps over vertices'); 
xlabel('Vertices'); ylabel('Amps');
[min,max]=bounds(allpeaks(1,:));
c=log10(allpeaks(1,:));
figure, scatter(allpeaks(5,:),allpeaks(2,:),15,c);