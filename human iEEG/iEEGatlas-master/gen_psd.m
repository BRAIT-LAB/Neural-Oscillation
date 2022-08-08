% Andy Hu, Jan. 15, 2018
clean;
addpath(genpath(cd));
IEEG = load('WakefulnessMatlabFile.mat');
data = IEEG.Data_W'; 
data = data( IEEG.ChannelRegion==3,:); clear IEEG;

nc = size(data,1);
fs = 200; % Hz
fmax = 77/2.56; % maximum frequency
sl = 512; % segment length
nfft = sl;
fr = 1/2.56;
f = (0:nfft/2)*fr;
idx = f>0&f<=fmax;
nw = 3;
nf = sum(idx == 1);

% check the scale factor
m = mean(data,2); % zero
v = var(data,0,2); % High Heterogeneity

% segment
[ne, nt] = size(data);
ns = floor(nt/sl); % # of segments
data(:,ns*sl+1:end)=[];
data = zscore(data,0,2); % remove the scale factor
data = reshape(data,[ne, sl, ns]);
data2 = reshape(data,[ne,sl*ns])';

% multitaper spectrum analysis
Pxx = zeros(length(f), ne, ns);
for i = 1:ns
    Pxx(:,:,i) = pmtm(data(:,:,i)', nw, nfft, fs);
end
Pxx = mean(Pxx,3);
spt_mt = Pxx(idx,:)';

% pwelch
Pxx = pwelch(data2,sl,sl/2,nfft,fs);
spt_wl = Pxx(idx,:)';

% xspt
% Pxy = xspt(data,nw,fs,fmax);
% spt_cs = tdiag(Pxy);
% 
% Pxy = xspectrum(data2',fs,fmax,fr,nw);
% spt_bc = tdiag(Pxy);

% Pxy = cpsd(data2,data2,sl,nfft/2,nfft);

x = zeros(nf,3,nc);
x(:,1,:) = reshape(spt_mt',[nf,1,nc]);
% x(:,2,:) = reshape(spt_cs',[nf,1,nc]);
% x(:,3,:) = reshape(spt_bc',[nf,1,nc]);
% x = median(x,3);
x = x./repmat(sum(x),[nf,1,1]);

figure('name','semilogx'),
for chn=1:nc
subplot(4,5,chn)
semilogx(f(idx),x(:,:,chn));
% plot(f(idx),x(:,:,chn));
xlim ([fr fmax]);
title(num2str(chn));
end
% legend({'Pmtm','Xspt','Welch'});
legend({'Pmtm','Xspt','Bc'});

figure('name','natural scale'),
for chn=1:nc
subplot(4,5,chn)
% semilogx(f(idx),x(:,:,chn));
plot(f(idx),x(:,:,chn));
xlim ([fr fmax]);
title(num2str(chn));
end
% legend({'Pmtm','Xspt','Welch'});
legend({'Pmtm','Xspt','Bc'});