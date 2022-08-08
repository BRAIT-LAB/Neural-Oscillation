%% SLM
eeg=loadcnt('20180423_twoclass_oyr_oldbig_1.cnt','dataformat', 'int16');
x = eeg.data(35,11001:12000); %加载数据
fs = 200; %采样频率
[pxx,freq] = periodogram(x,rectwin(length(x)),length(x),fs); %周期图法
[pxx,freq] = pwelch(x,[],[],[],fs);  %welch方法
[pxx,freq] = pmtm(x,3,length(x),fs);
plot(freq,pow2db(pxx));
plot(freq(5:53),pxx(5:53));
prescription = slmset('plot','on','k',15,'predictions',1001);
slm = slmengine(freq(5:53),pxx(5:53),prescription);

xp = linspace(min(x),max(x),n);  %freq1-freqn , nfreq
yp = slmeval(xp,slm,0);  %获取拟合曲线点

title('功率谱密度')
xlabel('功率(Hz)')
ylabel('功率/频率（dB/Hz）')

%% PCA
cov = (djc_eeg1 * djc_eeg1' )/62;
[x,y] = eig(cov);
P = x';
K = P(62:62,:);
as = K*djc_eeg1;

%% edf read
[header, recorddata] = edfread('D:\my_matlab_file\Wakefulness_AllRegions\Amygdala_W.edf');


%% Fieldtrip
%预处理  ft_preprocessing
cfg            = [];
cfg.dataset    = 'Amygdala_W.edf';
cfg.continuous = 'yes';
cfg.channel    = 'all';
data           = ft_preprocessing(cfg);
%数据可视化  ft_databrowser
cfg            = [];
cfg.viewmode   = 'vertical';
ft_databrowser(cfg, data);
%获取数据
data.trial{1}(1,9)    %获取trial1的第1个通道的第9个样本点
data.fsample    %采样率
data.time   %时间点
%去除伪迹  ICA
cfg = ft_databrowser(cfg,data);
cfg.artfctdef.reject  = 'complete';
cleandata = ft_rejectartifact(cfg,data);
cfg.channel = 'MM077LA1W';
ic_data = ft_componentanalysis(cfg,cleandata);
cfg.viewmode = 'component';
cfg.continuous = 'yes';
cfg.blocksize = 30;
cfg.channels = [1:6];
ft_databrowser(cfg,ic_data);
%滤波器  lpfilter
cfg.hpfilter = 'yes';
cfg.hpfreq = [2.5];
data_lp = ft_preprocessing(cfg,data);
x=data.trial{1}(1,1:1000);
y=data_lp.trial{1}(1,1:1000);
[pxx,freq] = pwelch(x,[],[],[],200);
subplot(211);
plot(freq,pxx);
[pxx_lp,freq_lp] = pwelch(y,[],[],[],200);
subplot(212);
plot(freq_lp,pxx_lp);
%频率分析  ft_freqanalysis
cfg                =  [];
cfg.output         = 'pow';
cfg.method         = 'mtmconvol';
cfg.taper          = 'hanning';
cfg.foi            = 1:30;
cfg.t_ftimwin      = 4 ./ cfg.foi;
cfg.toi            = -0.5:0.05:2;
freq               = ft_freqanalysis(cfg, data);
%% test
% test for SLM  --single SLM
[header, recorddata] = edfread('D:\my_matlab_file\Wakefulness_AllRegions\Precentral gyrus_W.edf');
i = 4 ;
x = recorddata(i,1:1000);
fs = 200;
[pxx,freq] = pwelch(x,[],[],[],fs);  %welch方法
plot(freq(1:53),pxx(1:53));
title(['原信号:第 ', num2str(i),'导']);
prescription = slmset('plot','on','knots',15); 
slm = slmengine(freq(1:53),pxx(1:53),prescription);
title(['SLM:第 ', num2str(i),'导']);

%test for XiPi(SLM) --plot and compare the original-decomposed signal
for i=1:length(sigIt.K(1,:,1))
    subplot(4,2,i)
    plot(freq,spt(8,:),'linewidth',1);  %原拟合通道
    hold on
    plot(freq,sigIt.K(:,i,5),'linewidth',1);  
end

%test for xsptAndtdiag  --generate the original-SLM automatically
[header, recorddata] = edfread('D:\my_matlab_file\Wakefulness_AllRegions\Precentral gyrus_W.edf');
[~,freq,~,spt] = xspt(EEG.data,200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum 
for i=1:length(spt(:,1))
    plot(freq,spt(i,:),'color','blue');   
    hold on
    title(['MC0000555 : No. ', num2str(i),'channel']);
    nfreq = length(freq);
    prescription = slmset('plot','off','knots',nfreq/3); 
    slm = slmengine(freq,spt(i,:),prescription);
    yp = slmeval(freq,slm,0);
    plot(freq, yp,'color','red');
    legend('Original Spectrum', 'SLM fitted','Location','best')
    saveas(gcf,['D:\my_matlab_file\fig\cuba04\MC0000555\spectrum\channel',num2str(i),'.png']) 
    close;
end

% test for XiPi  --generate the decomposed-spt_ftd signal automatically
[~,freq,~,spt] = xspt(EEG.data,200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum  0.3906
for i=1:length(spt(:,1))
%     if i == 18
%         continue;
%     end
    try
        [spt_ftd,sigIt,lh,final] = scmem_unim(spt(i,:)',freq',[0 0 0]);
    catch
        disp(['频谱无法解析 channel',num2str(i)]);
        continue
    end
    if length(sigIt.K(1,:,1)) > 5
        continue;
    end
    for j=1:length(sigIt.K(1,:,1))
        subplot(3,2,j)
        plot(freq,spt(i,:));  %原拟合通道
        hold on
        plot(freq,sigIt.K(:,j,final));  
        legend('Original', 'Composed','Fontsize',4)
        xlabel('Freqency/Hz')
        ylabel('PSD')
    title('E36')
    end
    subplot(3,2,length(sigIt.K(1,:,1))+1)
    plot(freq,spt(i,:));
    hold on
    plot(freq,spt_ftd);
    legend('Original', 'fitted','Fontsize',4)
    xlabel('Freqency/Hz')
    ylabel('PSD')
    title('E36')
    print('-r300',['D:\my_matlab_file\fig\',num2str(i)],'-djpeg');
    close;
end

% test for XiPi compared with fof
% log
plot(fooof_results.freqs,fooof_results.power_spectrum,'color','r','linewidth',1)  % Original
hold on
plot(fooof_results.freqs,fooof_results.fooofed_spectrum,'color','g','linewidth',1)  % FOF fitted
plot(freq, log10(ftd),'color','b','linewidth',1)  % Xi-Pi fitted
legend('Original','fof-fitted','Xi-Pi fitted')
xlabel('Freqency/Hz')
ylabel('PSD')
title('P4')

% natual
fooofed_spectrum_natural=zeros(1,102);
for i = 1:102
    fooofed_spectrum_natural(1,i) = 10^(fooof_results.fooofed_spectrum(1,i));
end
plot(freq, spt,'color','r','linewidth',1)   % Original
hold on
plot(freq, fooofed_spectrum_natural,'color','g','linewidth',1)
plot(freq, ftd,'color','b','linewidth',1)   % Xi-Pi fitted
ylabel('PSD')
title('P4')
 
legend('Original','fof-fitted','Xi-Pi fitted')
xlabel('Freqency/Hz')

for i = 1:final
    subplot(6,2,i)
    plot(freq,spt(9,:),'linewidth',1,'color','r')  
    hold on
    sig = sigIt.K(:,:,i);
    result = sum(sig,2);
    plot(freq, result,'linewidth',1,'color','b');
    title(['No.',num2str(i)])
    legend('Original','ftd')
end

%% Nonparametric fitted
freq = freq';
sig_parametric = zeros(length(sigIt.K(:,1,1)),length(sigIt.K(1,:,1)));
% ap-fit
ap = sigIt.K(:,1,5);
[fitresult, ~] = ApFit(freq, ap);
a = fitresult.a; b = fitresult.b;
sig_parametric(:,1) = a*exp(b*freq);

% peak-fit
for i = 2:length(sigIt.K(1,:,1))
peak = sigIt.K(:,i,5);
[fitresult, ~] = GuessFit(freq, peak);
a1 = fitresult.a1; b1 = fitresult.b1; c1 = fitresult.c1; 
val = zeros(1,102);
    for j=1:length(freq)
        val(j) =  a1*exp(-((freq(j)-b1)/c1)^2);
    end
sig_parametric(:,i) = val;
end
% plot components
plot(freq,spt(8,:),'linewidth',1)
hold on
for i = 1:length(sig_parametric(1,:))
    plot(freq,sig_parametric(:,i),'linewidth',1)
end
legend('Original','Xi','Pi')
xlabel('Freq/Hz')
ylabel('PSD')
% plot ftd
np_ftd = sum(sig_parametric,2);
plot(freq,spt(8,:),'linewidth',1)
hold on
plot(freq,np_ftd,'linewidth',1)
legend('Original','np-ftd')
xlabel('Freq/Hz')
ylabel('PSD')

%% VMD
[~,freq,~,spt_or] = xspt(data,200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum  0.3906
tic;
[u, u_hat, omega]=VMD(EEG.data(9,:), 2000, 0, 4, 0, 1, 1e-6);  % O1
t = toc;
[~,freq,~,spt_peak] = xspt(u,200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum  0.3906
spt_xi = spt_or(9,:)-spt_peak(1,:)-spt_peak(3,:);
spt = [spt_or(9,:);spt_xi;spt_peak(1,:);spt_peak(3,:)];
for i = 1:4
    plot(freq,spt(i,:),'linewidth',1)
    hold on
end
xlabel('Freq/Hz')
ylabel('PSD')
legend('Original','Xi', 'peak1', 'peak2')

%% Para Extract for AllRegions
output = struct(); 
load cortexName.mat
for i = 1:38
    [header, recorddata] = edfread(['D:\my_matlab_file\Wakefulness_AllRegions\',char(filename(i,1)),'.edf']);
    [~,freq,~,spt] = xspt(recorddata,200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum  0.3906
    eval(['output.cortex',num2str(i),'=','struct()'])    % eval
    for j = 1:length(recorddata(:,1))
        try
            [spt_ftd,~,sig_para,final] = scmem_unim(spt(j,:)',freq',[0 0 0]);
        catch
            disp(['频谱无法解析 cortex',num2str(i),'channel',num2str(j)]);
            continue;
        end
        eval(['output.cortex',num2str(i),'.channel',num2str(j),'=','sig_para.peak(:,2)'])
        for k = 1:length(sig_para.peak(:,1))
            a = sig_para.ap(1,1) ; b = sig_para.ap(1,2); a1 = sig_para.peak(k,1);  cf = sig_para.peak(k,2); %cf
            eval(['output.cortex',num2str(i),'.channel',num2str(j),'(k,2)=','a*exp(b*cf)+a1'])
        end
    end
end
% Para Extract for AllRegions 2
output = zeros(30,1772);
channel_num = 1;
load cortexName.mat
for i = 1:38
    [header, recorddata] = edfread(['D:\my_matlab_file\Wakefulness_AllRegions\',char(filename(i,1)),'.edf']);
    [~,freq,~,spt] = xspt(recorddata,200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum  0.3906
    for j = 1:length(recorddata(:,1))
        try
            [spt_ftd,~,sig_para,final] = scmem_unim(spt(j,:)',freq',[0 0 0]);
        catch
            disp(['频谱无法解析 cortex',num2str(i),'channel',num2str(j)]);
            continue;
        end
        for k = 1:length(sig_para.peak(:,1))
            a = sig_para.ap(1,1) ; b = sig_para.ap(1,2); a1 = sig_para.peak(k,1);  cf = sig_para.peak(k,2); %cf
            spt_v = a*exp(b*cf)+a1;  % 谱值
            output((2*k-1),channel_num) = cf;
            output(2*k,channel_num) = spt_v;
        end
        channel_num = channel_num + 1;
    end
end


%% Test For WakefulnessMatlabFile
Data=Data';
channelRegion_ele = struct();
for i = 1:39
    eval(['channelRegion_ele.Region',num2str(i),'= Data(ChannelRegion==i,:)'])
end

num = 0 ;
for i = 1:39
    num = num + size(eval(['channelRegion_ele.Region',num2str(i)]),1);
end   % compute number of ele

% epoch
C=[];
for i =1:23
        data = Region2(i,1:13000);
        B = reshape(data,[1000,13]);
        C = [C;B'];
end

%% RE
re = zeros(1,1573);
load cortexName.mat
re_num = 1;
for i = 1:38
    [header, recorddata] = edfread(['D:\my_matlab_file\Wakefulness_AllRegions\',char(filename(i,1)),'.edf']);
    [~,freq,~,spt] = xspt(recorddata,200,40,0.3906,2.5);  %crossSpectrum--diag>>Spectrum  0.3906
    for j = 1:length(recorddata(:,1))
        try
            [spt_ftd,~,sig_para,final] = scmem_unim(spt(j,:)',freq',[0 0 0]);
        catch
            disp(['频谱无法解析 cortex',num2str(i),'channel',num2str(j)]);
            continue;
        end
        for k = 1:length(sig_para.peak(:,1))
            a = sig_para.ap(1,1) ; b = sig_para.ap(1,2); a1 = sig_para.peak(k,1);  cf = sig_para.peak(k,2); %cf
            spt_v = a*exp(b*cf)+a1;  % 谱值
            num = [cf,freq];
            num(2,:)=0;
            distmat = pdist(num');
            Z = squareform(distmat);
            Z = Z(1,2:end);
            [~,index] = min(Z);    % 寻找最近位置
            re(1,re_num) = spt_v - spt(j,index);
            re_num = re_num + 1;
        end
    end
end  

% 整体拟合质量评估
re = [];
for i = 1:1772
    try
            [spt_ftd,~,sig_para,final] = scmem_unim(spt_or(i,:)',freq',[0 0 0]);
        catch
            disp(['频谱无法解析','channel',num2str(i)]);
            re = [re,0];
            continue;
    end
    result = sum((spt_ftd' - spt_or(i,:)).^2)/102;
    re = [re,result];
end


