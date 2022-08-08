clean;
load fitrs5_initial; %presmooth
load('psdf.mat');
parall = reshape(parall,4,15,1772);
par = reshape(parall,4,15*1772); par(:,par(1,:)==0)=[];
re = rssq(sigall-psdall)./rssq(psdall); % fitting error

noc = squeeze(sum(parall(1,:,:)~=0,2)); % # of components

% # of peaks and fitting error
figure('name','Fitting error'),
subplot(221),histogram(noc); title('# of components');set(gca,'fontsize',12);% # of peaks
subplot(222), histogram(re); title('Fittting Error');set(gca,'fontsize',12);
subplot(2,2,[3 4]), plot(re);xlim([1 1772]);xlabel('Channels');ylabel('Fitting Error');set(gca,'fontsize',12);

% all para
figure('name','all'),
subplot(221),histogram(log10(par(1,:))),title('log amp');
subplot(222),histogram((par(2,:))),title('freq');
subplot(223),histogram((par(3,:))),title('std');
subplot(224),histogram(log10(par(4,:))),title('log nu');

figure('name','all'), 
subplot(131), plot(par(2,:),(par(1,:)),'.k'), xlabel('Freq locs'), ylabel('Amp');axis square;set(gca,'fontsize',12);
subplot(132), histogram2(par(2,:),log10(par(1,:)),[100 100],'facecolor','flat'); view(2),colormap(hot);xlabel('Freq locs'),ylabel('log Amp'); axis square;set(gca,'fontsize',12);
subplot(133), histogram2(par(2,:),log10(par(3,:)),[100 100],'facecolor','flat'); view(2),colormap(hot);xlabel('Freq locs'),ylabel('log Std'); axis square;set(gca,'fontsize',12);

% all para = Xi + peaks
par_peaks=par(:,par(2,:)>0.4); par_xi=par(:,par(2,:)<=0.4);

figure('name','peaks')
subplot(221),histogram(log10(par_peaks(1,:))),title('log amp');
subplot(222),histogram((par_peaks(2,:))),title('Freq locs');
subplot(223),histogram((par_peaks(3,:))),title('std');
subplot(224),histogram(log10(par_peaks(4,:))),title('log nu');

figure('name','peaks'),
subplot(121),scatter(log10(par_peaks(4,:)),log10(par_peaks(3,:)),15,log10(par_peaks(1,:)));
colormap(hot);xlabel('log nu'),ylabel('log std');title('C: peaks amps'); axis square;set(gca,'fontsize',12);
subplot(122),scatter3(log10(par_peaks(4,:)),log10(par_peaks(3,:)),log10(par_peaks(1,:)),15,(par_peaks(2,:)));
colormap(hot);xlabel('log nu'),ylabel('log std'),zlabel('log amp'), title('C: peaks frequency locs'); axis square;set(gca,'fontsize',12);

figure('name','xi')
subplot(221),histogram(log10(par_xi(1,:))),title('log amp');
subplot(222),histogram((par_xi(2,:))),title('Freq locs');
subplot(223),histogram((par_xi(3,:))),title('Std');
subplot(224),histogram(log10(par_xi(4,:))),title('log nu');

figure('name','Xi'),
subplot(121),scatter(log10(par_xi(4,:)),log10(par_xi(3,:)),15,log10(par_xi(1,:)));
colormap(hot);xlabel('log nu'),ylabel('log std');title('C: Xi amps'); axis square;set(gca,'fontsize',12);
subplot(122),scatter3(log10(par_xi(4,:)),log10(par_xi(3,:)),log10(par_xi(1,:)),15,(par_xi(2,:)));
colormap(hot);xlabel('log nu'),ylabel('log std'),zlabel('log amp'), title('C: Xi frequency locs'); axis square;set(gca,'fontsize',12);

% check meta
figure('name','meta'), 
subplot(121), plot(meta(1:3,:)'); xlim([1 1772]), legend({'Likelihood','AIC','BIC'});xlabel('Channels'); axis square;set(gca,'fontsize',12);
subplot(122), histogram(meta(4,:)); title('ExitFlag'); axis square;set(gca,'fontsize',12);

figure('name','meta'),
subplot(131),scatter(noc,re); title('Fitting error vs. # of Comps'); axis square;
subplot(132),scatter(meta(3,:),re); title('Fitting error vs. BIC'); axis square;
subplot(133),scatter(noc,meta(3,:)); title('BIC vs. # of Components'); axis square;

% [r1,p1]=corr([log10(par_peaks(4,:));log10(par_peaks(3,:));log10(par_peaks(1,:))]');
% [r2,p2]=corr([log10(par_xi(4,:));log10(par_xi(3,:));log10(par_xi(1,:))]');