function [x0, sigk_ini] = initialfit1(psd,freq,plotflag)
% Initialize the starting point and bounds for fmincon
% Input
%        psd --- power spectrum density in natural scale
%        freq --- frequency bins
%        plotflag --- [1 1], plot initialized separate components & picked extremes; ~1, not plot
% Ouput
%        x0 --- starting point
%        lb/ub --- lower/upper bounds
%        ank --- actual number of components
% See also FMINCON, PKEXTREM

% Shiang Hu, Jul. 2018

if nargin==2
    plotflag = [];
end

npsd = psd./max(psd);   % psd归一化


[pks,fma,fw] = findpeaks(npsd,freq,'minpeakwidth',0.9,'minpeakheight',0.07,'minpeakprominence',0.025);
if length(pks) == 0
    disp('频谱无峰')
    x0=[]; sigk_ini=[];
    return;
end
[~,fmi] = findpeaks(-psd./max(psd),freq,'minpeakwidth',0.85,'minpeakheight',-0.8,'minpeakprominence',0.025,'npeaks',length(pks));


% paras
nk = length(pks) + 1;
mp = max(psd);   % 最大原始信号
x0 = zeros(4,nk);  % 4*nk 的 0 矩阵
x0(1:2,1) = [psd(1);freq(1)];
x0(1:3,2:end) = [pks';fma';fw';]; 
fmas = x0(2,:);  %起始频率+峰值y  --> x0(1,:) 起始谱值+峰值x

% vis
if plotflag(1)==1,    f1=figure; end % show components
% if plotflag(2)==1,    f2=figure; end % show extremes

% roughly estimate the paras separately
if length(fma)>length(fmi)
    fmi = [fmi;freq(end)];
end   %re...

sigk_ini = zeros(length(freq),nk);

for i=1:nk
    if i==1
        [extrem, ~] = pkextrem1(psd,freq,fmas,fmi,i); %
        x0(:,i) = tp(psd, freq, extrem);
        psd_fit =  stc(x0(:,i),freq);
        % 拟合初始背景谱... ap_psd
        sigk_ini(:,i) = psd_fit;
        
        if plotflag(1)==1, figure(f1), plotspfit(freq, psd, psd_fit, i, mp); end
        psd = psd - psd_fit;
    else
        extrem.fma = fma(i-1);
        extrem.fmi = fmi(i-1);
        
        x0(:,i) = tp(psd, freq, extrem);
        psd_fit =  stc(x0(:,i),freq);
        sigk_ini(:,i) = psd_fit;
        
        if plotflag(1)==1, figure(f1), plotspfit(freq, psd, psd_fit, i, mp); end

        psd = psd - psd_fit;
    end
    
end

% x0=x0(:,1:nk);
% sigk_ini = stc(x0,freq);
end