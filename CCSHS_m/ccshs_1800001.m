clean;clear;

load ccshs-trec-1800001.mat

% wake state : 
% *0-10020s 10410-10500s 10590-11010s 18210-18300s 20040-20070s
% 21570-21600s 21750-21780s 24420-24450s 27150-27180s 28860-28890s
% 32160-32190s 32880-32910s 33150-33210s 34440-34470s 35220-35250s
% 37230-37260s 37500-38070s 38130-38160s 38370-38400s 38850-38910s
% 40500-40530s 40620-40650s 41160-41220s
startTime = 21780;
endTime = 24150;
wake_1 = data(1,startTime*128+1:endTime*128);
fs = 128;
[pxx,f] = pwelch(wake_1,hamming(128),64,256,128);
plot(f(1:100),log10(pxx(1:100)))
plot(f(1:100),pxx(1:100))

[Svv,F,Ns,PSD] = xspt(wake_1,fs,50,1,3);
plot(F,PSD)
plot(F,log10(PSD))

[xipi_psd,components] = scmem_unim(f(2:91),pxx(2:91,3),[1 1 1]);

settings = struct('peak_width_limits',[1 10],'aperiodic_mode','knee');
fooof_results = fooof(f,pxx(:,3) ,[0 45], settings, 1);
% N2 state:
% 10110-10410s 10530-10590s 11100-11460s 11490-11520s 13710-13740s
% 13980-14580s 14670-14700s 15000-15720s *18300-19400s



% REM state:
% 14580-14670s 14700-15000s 20910-21570s 21600-21750s *21780-24150s

%% 滑动窗口
stepn = 10*128; %20s
windowsize = 30*128; %30s
res_REM_fof = [];
for i = 1:37
    disp(i);
    [pxx,f] = pwelch(REMdata(i * stepn + 1:i * stepn+windowsize),hamming(128),64,256,128);
    freq = f(2:92); psd=pxx(2:92);
%     [psd_ftd,components] = scmem_unim_log(freq,log10(psd),[0 0 0]);
    settings = struct('peak_width_limits',[1 20]);
    fooof_results = fooof(freq,psd ,[0 45], settings, 1);
    res_REM_fof(1,i) = fooof_results.aperiodic_params(1); res_REM_fof(2,i) = fooof_results.aperiodic_params(2); 
end

%% 参数拟合/回归
REM = [];
for i=1:37
    data = res_REM_xipi(i,:);
    [fitresult, ~] = ApFit(f,data);
    REM(1,i) = fitresult.a; REM(2,i) = fitresult.b;
end