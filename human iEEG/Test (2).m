%% Fig1.a/b 整体拟合
[~,freq,Ns,spt] = xspt(data,200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum  0.3906
[header, recorddata] = edfread(['D:\my_matlab_file\Wakefulness_AllRegions\Angular gyrus_W.edf']);

[spt_ftd,sigIt,sig_para,final] = scmem_unim(badChannel_1(1,:)',freq',[1 1 1]);
[spt_ftd,sigIt,sig_para,final] = scmem_unim(welch_spt(14,:)',f',[1 1 1]);
%old
[spt_ftd,sigIt,lh] = scmem_unim(badChannel_1(19,:)',freq',[1 1 1]);


settings =  struct(...
        'peak_width_limits', [1, 12], ...
        'max_n_peaks', Inf, ...
        'min_peak_height', 0.0, ...
        'peak_threshold', 2.0, ...
        'aperiodic_mode', 'knee', ...
        'verbose', true);
fooof_results = fooof(f,data, [0 50], settings, 1);

% log plot
plot(freq,log10(spt(12,:)),'linewidth',1,'Marker','*')
hold on
plot(f(1:101),log10(spt_ftd),'linewidth',2)
plot(freq,fooof_results.fooofed_spectrum,'linewidth',2)
legend('raw PSD','full XiPi model','full fooof model')
xlabel('freq.Hz')
ylabel('log power')

% linear plot
plot(freq,spt(12,:),'linewidth',1,'Marker','*')
hold on
plot(freq,spt_ftd,'linewidth',2)

plot(f,10.^fooof_results.fooofed_spectrum,'linewidth',2)
legend('raw PSD','full XiPi model','full fooof model')
xlabel('freq.Hz')
ylabel('linear power')


%% Fig1.a  非周期振荡和周期振荡分离
[~,freq,~,spt] = xspt(EEG.data,200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum  0.3906
[spt_ftd,sigIt,sig_para,final] = scmem_unim(spt(12,:)',freq',[0 1 1]);

settings = struct();
fooof_results = fooof(freq, spt(12,:), [0 40], settings, 1);

% linear plot
plot(freq,spt(12,:),'linewidth',1,'Marker','*')
hold on
plot(freq,sigIt.K(:,1,final),'linewidth',2)
% plot(freq,sigIt.K(:,2,final),'linewidth',2)

plot(freq,10.^fooof_results.ap_fit,'linewidth',2)
legend('raw PSD','XiPi aperiodic','fooof aperiodic')
xlabel('freq.Hz')
ylabel('linear power')
ylim([0 4000])

% log plot
plot(freq,log10(spt(12,:)),'linewidth',1,'Marker','*')
hold on
plot(freq,log10(sigIt.K(:,1,5)),'linewidth',2)
% plot(freq,sigIt.K(:,2,final),'linewidth',2)

plot(freq,fooof_results.ap_fit,'linewidth',2)
legend('raw PSD','XiPi aperiodic','fooof aperiodic')
xlabel('freq.Hz')
ylabel('log power')

%% validate EM
[header, recorddata] = edfread(['D:\my_matlab_file\Wakefulness_AllRegions\Angular gyrus_W.edf']);
[~,freq,~,spt] = xspt(recorddata,200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum  0.3906

[spt_ftd,sigIt,sig_para,final] = scmem_unim(spt(12,:)',freq',[0 1 1]);

% plot
plot(freq,spt(12,:),'linewidth',1,'Marker','*')
hold on 

for j = 1 : 5
    plot(freq,sigIt.K(:,j,3),'linewidth',2)
end
title('EM algorithm-4')
legend('raw PSD','aperiodic','peak1','peak2','peak3','peak4')
xlabel('freq.Hz')
ylabel('linear power')

%% error
[~,freq,~,spt] = xspt(Data',200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum  0.3906

a=zeros(1,1772);
% power=ones(1,100); %加权
for i=1:1772
    try
        disp(['正在拟合--->',num2str(i)]);
        [spt_ftd,sigIt,~,~] = scmem_unim(welch_spt(1491,1:101)',f(1:101)',[1 0 0]);
        % log
%         e1=log10(welch_spt(i,2:101))-log10(spt_ftd');
%         e1=sum(e1.^2);
        % linear
         e1=welch_spt(i,2:101)-spt_ftd';
         e1=sum(e1.^2);
         a(i)=e1;
    catch
        continue;
    end
end

b=zeros(1,1772);
for i=1:1772
    settings = struct('peak_width_limits',1);
    fooof_results = fooof(f(1:101), welch_spt(i,1:101), [0 50], settings,1);
    e2=fooof_results.power_spectrum-fooof_results.fooofed_spectrum;
	e2=sum(e2.^2);
    b(i)=e2;
end


%% All test
% one test
[psd_ftd,sigIt,sig_parameter,~] = scmem_unim(welch_spt(12,2:101)',f(2:101)',[0 0 0]);
% 原始谱  自然尺度
plot(f(2:101),pxx(101,2:101),'linewidth',1.5,'color','k')
hold on
% 背景谱 自然尺度
plot(f(2:101),sigIt.K(:,1,8),'linewidth',1.5,'color','b');
% 谱峰 自然尺度
plot(f(2:101),sigIt.K(:,2,8),'linewidth',1.5,'color','g');
plot(f(2:101),sigIt.K(:,3,8),'linewidth',1.5,'color','r');
ylim([0 110])
% 参数重建背景谱
a = sig_parameter.ap(1,1); b = sig_parameter.ap(1,2);
ap_fit = a*exp(b * f(2:101));
plot(f(2:101),ap_fit,'linewidth',1.5);
% 参数重建谱峰
a = sig_parameter.peak(2,1); c = sig_parameter.peak(2,2); w = sig_parameter.peak(2,3);
peak2 = a*exp(-((f(2:101)-c)/w).^2);
plot(f(2:101),peaks,'linewidth',1.5);
xlabel('freq/Hz');  ylabel('power'); title('Isolating the neural power spectra')
legend('Original Spectrum','aperiodic Spectrum','Peak1','Peak2')

settings = [];
fooof_results = fooof(f(1:101),pxx(101,1:101) , [0 50], settings, 1);
c = fooof_results.peak_params(1,1);
w = 10^fooof_results.peak_params(1,2);
a = fooof_results.peak_params(1,3);
% 原始谱 自然尺度
plot(fooof_results.freqs,10.^fooof_results.power_spectrum,'linewidth',1.5);
hold on;
% 整体拟合 自然尺度
plot(fooof_results.freqs,10.^fooof_results.fooofed_spectrum,'linewidth',1.5);
% 背景谱 自然尺度
plot(fooof_results.freqs,10.^fooof_results.ap_fit,'linewidth',1.5);
ylim([0 5000])
% 重建谱峰 自然尺度
plot(fooof_results.freqs,a*exp(-((fooof_results.freqs-c).^2) / (2 * w.^2)),'linewidth',1.5)

% no peaks
ap_parameter_nopeaks =[];
freq = f(2:101);
for i=1:349
    ap = log10(no_peaks_spt(i,2:101));
    [fitresult, ~] = createFit(freq, ap);  
    ap_1 = fitresult.b; ap_2 = fitresult.a;
    ap_parameter_nopeaks = [ap_parameter_nopeaks,[ap_1;ap_2]];
end


% TODO : 算ieeg可解析的所有非周期振荡参数

ap_paras=zeros(2,1772);
peak_paras = [];
R=zeros(1,1772);
Error=zeros(1,1772);
for i=1:1772
        try
            disp(['正在拟合--->',num2str(i)])
            [psd_ftd,sigIt,sig_parameter,~] = scmem_unim(welch_spt(i,1:101)',f(1:101)',[0 0 0]);
            R(i)=sig_parameter.r_squared;
            Error(i)=sig_parameter.error;
            ap_paras(1,i)=sig_parameter.ap(1);  ap_paras(2,i)=sig_parameter.ap(2);  % 偏移 指数 
            for j=1:size(sig_parameter.peak,1)
                peak_paras = [peak_paras,sig_parameter.peak(j,:)'];
            end
        catch
            disp(['频谱无法解析--->',num2str(i)]);
            continue;
        end
end

ap_paras_fof=zeros(2,19);
peak_paras_fof = [];
for i=1:1772
        try
            disp(['正在拟合--->',num2str(i)]);
            settings = struct('peak_width_limits',[1 12]);
            fooof_results = fooof(f(1:102),welch_spt(i,1:102) , [0 50], settings, 1);
            %Error_fof(i)= w*((10.^fooof_results.fooofed_spectrum - 10.^fooof_results.power_spectrum).^2)';
            ap_paras_fof(1,i)=fooof_results.aperiodic_params(1);  ap_paras_fof(2,i)=fooof_results.aperiodic_params(2);
%             for j=1:size(fooof_results.peak_params,1)
%                 peak_paras_fof = [peak_paras_fof,fooof_results.peak_params(j,:)'];
%             end
        catch
            disp(['频谱无法解析--->',num2str(i)]);
            continue;
        end
end

%% Cluster
b=[];
for i=1:1772
    if(a(i)==1)
        b=[b;i];
    end
end

[silh3,h] = silhouette(error_fit,idx3,'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')

badChannel_1=[];
badChannel_2=[];
badChannel_3=[];
for i=1:199
    if(idx3(i)==1)
        badChannel_1=[badChannel_1;badChannel(i,:)];
    end
    if(idx3(i)==2)
        badChannel_2=[badChannel_2;badChannel(i,:)];
    end
    if(idx3(i)==3)
        badChannel_3=[badChannel_3;badChannel(i,:)];
	end
end

[idx,C]=kmeans(no_peaks_spt_1,3);

%% 包络
data=badChannel_1(1,:);
y = hilbert(data);
env = abs(y);
plot(freq,[data;env])
legend('original','envolope')

fl1 = 8;
[up1,lo1] = envelope(data,fl1,'peak');
plot(freq,data);
hold on
plot(freq,lo1);
plot(freq,data-lo1);

%% welch --> ieegData
data = EEG.data';
[pxx,f] = pwelch(data,hamming(200),100,400,200);  % 时间序列  hanmming长度  重叠点数  FFT点  采样率
pxx=pxx';
plot(f,pxx(1,1:201));
[spt_ftd,sigIt,sig_para,final] = scmem_unim(spt',freq',[1 1 1]);

settings = struct();
fooof_results = fooof(f, pxx, [0 40], settings, 1);
plot(fooof_results.freqs,fooof_results.fooofed_spectrum);
plot(fooof_results.freqs,fooof_results.power_spectrum);
%% Findpeaks
freq = freq;
psd = p + abs(min(p));
npsd = psd./max(psd);
figure;
[pks,fma,fw] = findpeaks(npsd,freq,'minpeakwidth',0.9,'minpeakheight',0.07,'minpeakprominence',0.025);
[vlys,fmi] = findpeaks(-psd./max(psd),freq,'minpeakwidth',0.85,'minpeakheight',-0.8,'minpeakprominence',0.025,'npeaks',length(pks));


findpeaks(npsd,freq,'minpeakwidth',0.9,'minpeakheight',0.07,'minpeakprominence',0.025); hold on
plot(fmi,-vlys,'r^','linewidth',2,'markerfacecolor','r');
xlabel('Frequency'), ylabel('Power'),legend({'Spt','Pks','Vlys'});
set(gca,'fontsize',14);ylim([0 1.0785])

%% saveJPG
for i = 1:1772
    if(welch_fit(i) == 1)
        plot(f(2:101) , welch_spt(i,2:101));
        print('-r300',['D:\my_matlab_file\fig\spt_error_welch\',num2str(i)],'-djpeg');
        close;
    end
end

%% using Welch function to test
for i = 1:1772
    [pxx,f] = pwelch(Data(i,:),hamming(200),100,400,200); 
    welch_spt = [welch_spt;pxx'];
end

R_fof=zeros(1,1772);
Error_fof=zeros(1,1772);
for i=1:1772
        try
            disp(['正在拟合--->',num2str(i)])
            settings = struct('peak_width_limits',[1 10]);
            fooof_results = fooof(f(1:101),welch_spt(i,1:101) ,[0 50], settings, 1);
            R_fof(i)=fooof_results.r_squared;
            Error_fof(i)=sum(((10.^fooof_results.fooofed_spectrum)-(10.^fooof_results.power_spectrum)).^2);
        catch
            disp(['频谱无法解析--->',num2str(i)]);
            continue;
        end
end

%  a1*exp(-((x-b1)/c1)^2)

%% Statistics
% boxplot
boxplot([c',d'],'DataLim',[0 20])

% bar
% center freq
delta = ans(ans>0.5 & ans<4);
theta = ans(ans>4 & ans<8);
alpha = ans(ans>8 & ans<14);
beta = ans(ans>14 & ans<30);
gama = ans(ans>30);

X = categorical({'δ';'θ';'α';'β';'γ'});
X = reordercats(X,{'δ';'θ';'α';'β';'γ'});
b = bar(X,data,0.5,'r');
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
title('Central Frequency Distribution')

% bandWidth
a1 = ans(ans>0 & ans<1);
a2 = ans(ans>1 & ans<2);
a3 = ans(ans>2 & ans<3);
a4 = ans(ans>3 & ans<4);
a5 = ans(ans>4 & ans<5);
a6 = ans(ans>5 & ans<6);
a7 = ans(ans>6 & ans<7);
a8 = ans(ans>7 & ans<8);
a9 = ans(ans>8 & ans<9);
a10 = ans(ans>9 & ans<10);

X = categorical({'0-1';'1-2';'2-3';'3-4';'4-5';'5-6';'6-7';'7-8';'8-9';'9-10'});
X = reordercats(X,{'0-1';'1-2';'2-3';'3-4';'4-5';'5-6';'6-7';'7-8';'8-9';'9-10'});
b = bar(X,data,0.5,'r');
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')


%% 脑区分析
regionFlag = zeros(1772,1);
regionFlag(ChannelRegion == 38) = 1;
region = welch_spt((regionFlag == 1),:);
regionName = 'Amygdala';
len = sum(regionFlag);

ap_paras=zeros(2,len);
peak_paras = [];
for i=1:len
        try
            disp(['正在拟合--->',num2str(i)])
            [psd_ftd,sigIt,sig_parameter,~] = scmem_unim(region(i,1:101)',f(1:101)',[0 0 0]);
%             R(i)=sig_parameter.r_squared;
%             Error(i)=sig_parameter.error;
            ap_paras(1,i)=sig_parameter.ap(1);  ap_paras(2,i)=sig_parameter.ap(2);
            for j=1:size(sig_parameter.peak,1)
                peak_paras = [peak_paras,sig_parameter.peak(j,:)'];
            end
            peak_paras = [peak_paras,NaN(3,1)];
        catch
            disp(['频谱无法解析--->',num2str(i)]);
            continue;
        end
end

ap_paras_fof=zeros(2,len);
peak_paras_fof = [];
for i=1:len
        try
            disp(['正在拟合--->',num2str(i)]);
            settings = struct('peak_width_limits',[1 12]);
            fooof_results = fooof(f(1:101),region(i,1:101) ,[0 50], settings, 1);
            %Error_fof(i)= w*((10.^fooof_results.fooofed_spectrum - 10.^fooof_results.power_spectrum).^2)';
            ap_paras_fof(1,i)=fooof_results.aperiodic_params(1);  ap_paras_fof(2,i)=fooof_results.aperiodic_params(2);
            for j=1:size(fooof_results.peak_params,1)
                peak_paras_fof = [peak_paras_fof,fooof_results.peak_params(j,:)'];
            end
            peak_paras_fof = [peak_paras_fof,NaN(3,1)];
        catch
            disp(['频谱无法解析--->',num2str(i)]);
            continue;
        end
end
save Amygdala.mat spt ap_paras ap_paras_fof peak_paras peak_paras_fof


%% simulate
% ieeg 235 channel
% time = X(:,235)';
time = no_peak_time';
[pxx1,f] = pwelch(time,hamming(200),100,400,200); 

fs = 200; N = 13600;
n=0:N-1; t = n/fs;
% time = time + 3*sin(2 * pi * 13 * t) +4*sin(2 * pi * 15 * t)+5*sin(2 * pi * 30 * t);
time = time + 5*sin(2 * pi * 11 * t)+ 5*sin(2 * pi * 17 * t)+ 5*sin(2 * pi * 23 * t)+ 5*sin(2 * pi * 26 * t)+ 5*sin(2 * pi * 29 * t)+5*sin(2 * pi * 32 * t)+5*sin(2 * pi * 35 * t)+5*sin(2 * pi * 38 * t)+5*sin(2 * pi * 41 * t);
[pxx2,f] = pwelch(time,hamming(200),100,400,200); 
plot(f,pxx1); hold on
plot(f,pxx2);

[psd_ftd,sigIt,sig_parameter,~] = scmem_unim(pxx2(1:101),f(1:101),[1 1 1]);
settings = struct('peak_width_limits',[1 10]);
fooof_results = fooof(f(1:101),pxx2(1:101) ,[0 50], settings, 1);
% plot 
plot(f(2:101),pxx1(2:101),'linewidth',1.5)
plot(f(2:101),pxx2(2:101),'linewidth',1.5)
ylim([0 180])
hold on
xlabel('freq/Hz')
ylabel('power')

plot(f(2:101),sigIt.K(:,1,4),'linewidth',1.5)
plot(f(2:101),sigIt.K(:,2,4),'linewidth',1.5)
plot(f(2:101),psd_ftd,'linewidth',1.5)
c = fooof_results.gaussian_params(9,1);
a = fooof_results.gaussian_params(9,2);
w = fooof_results.gaussian_params(9,3);
% fd = a*exp(-((fooof_results.freqs-c).^2) / (2 * w^2));
% ***
plot(fooof_results.freqs,(10.^(a*exp(-((fooof_results.freqs-c).^2) / (2 * w^2)))).*(10.^fooof_results.ap_fit)-10.^fooof_results.ap_fit,'linewidth',1.5)
% ***
plot(fooof_results.freqs,10.^fooof_results.ap_fit,'linewidth',1.5);
plot(fooof_results.freqs,10.^fooof_results.fooofed_spectrum,'linewidth',1.5);

plot(fooof_results.freqs,a*exp(-((fooof_results.freqs-c).^2) / (2 * w^2)),'linewidth',1.5)
plot(fooof_results.freqs,fooof_results.ap_fit,'linewidth',1.5);
plot(fooof_results.freqs,fooof_results.fooofed_spectrum,'linewidth',1.5);
%% boxplot -- 分组统计ap_XiPi
x = []; g = []; filename = '';
for i = 1:39
filename = RegionName{i, 1};
load(filename,'ap_paras')
len = size(ap_paras,2);

x1 = ap_paras(2,:);
x = [x;x1'];
g1 = repmat({filename},len,1);
g = [g;g1];
end

boxplot(x,g,'Orientation','horizontal');

%% likehood
res = zeros(2,1000);
for i = 1:1000
    disp(i);
    org_data = welch_spt(i,2:101);
    try
    [xipi_psd,sigIt,~] = scmem_unim(org_data',f(2:101)',[0 0 0]);
    catch
        continue;
    end
    if isempty(xipi_psd)
        continue;
    end
    
    settings = struct('peak_width_limits',[1 10]);
    fooof_results = fooof(f(2:101),org_data ,[0 50], settings, 1);
    fooof_psd = 10.^fooof_results.fooofed_spectrum;
    
    likelyhood_xipi = sum(log(xipi_psd)'+org_data./xipi_psd');
    likelyhood_fof = sum(log(fooof_psd)+org_data./fooof_psd);
    
    res(1,i) = likelyhood_xipi;
    res(2,i) = likelyhood_fof;
end

%% log-log尺度分析
load log_log.mat
[pxx,f] = pwelch(data',hamming(200),100,400,200);
freq=f(2:91); psd=pxx(2:91,5);
[xipi_psd,components] = scmem_unim(freq,psd,[0 0 0]);
settings = struct('peak_width_limits',[1 7],'aperiodic_mode','knee');
fooof_results = fooof(freq,psd ,[0 45], settings, 1);

plot(log10(freq),log10(psd))
hold on
plot(log10(freq),log10(components(:,1)))
plot(log10(freq),fooof_results.ap_fit)