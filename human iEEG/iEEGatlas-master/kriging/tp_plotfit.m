clean;
addpath(genpath(cd));
% load psdf;
load fitrs3;
par = reshape(parall,4,15*1772); par(:,par(1,:)==0)=[];
re = rssq(sigall-psdall)./rssq(psdall); % fitting error
% figure, plot(re); xlim([1 1772]); xlabel('Channels'), ylabel('Fitting error');
figure, %subplot(121), 
histogram(re,20), xlabel('Fitting Error'); 
% %  subplot(122), histogram(re,20,'normalization','probability'), xlabel('Fitting Error');
 
% check outliers
idx = find(re>=0.6);

% for i=1:20
%     idx = a(15*i-14:15*i);
    figure,
    for j=1:15
    subplot(3,5,j)
    plot(freq,[psdall(:,idx(j)),sigall(:,idx(j))]);
    legend({'Real','Fit'})
    end
% end