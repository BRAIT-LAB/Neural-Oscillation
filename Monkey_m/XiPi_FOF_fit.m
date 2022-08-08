freq = f(2:100);  %0.5 - 49.5Hz
len = 128;
ap_paras=zeros(2,len);
peak_paras = [];
ap_paras_fof=zeros(2,len);
peak_paras_fof = [];

for i = 1:128
         try
              disp(['正在拟合--->',num2str(i)])
              [psd_ftd,sigIt,sig_parameter,~] = scmem_unim(EyesOpenedWelch(i,2:100)',freq,[0 0 0]);
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

settings = struct('peak_width_limits',[1 10]);
a = [];
for i= 1:128
    fooof_results = fooof(freq,EyesOpenedWelch(i,2:100) ,[0 50], settings, 1);
    ap_paras_fof(1,i)=fooof_results.aperiodic_params(1);  ap_paras_fof(2,i)=fooof_results.aperiodic_params(2);
         for j=1:size(fooof_results.peak_params,1)
             peak_paras_fof = [peak_paras_fof,fooof_results.peak_params(j,:)'];
         end
         a = [a,fooof_results.peak_params(1,:)'];
    peak_paras_fof = [peak_paras_fof,NaN(3,1)];
end

plot(freq,EyesClosedWelch(84,2:100),'linewidth',1.5)
plot(freq,log10(EyesClosedWelch(84,2:100)),'linewidth',1.5)
hold on
plot(freq,sigIt.K(:,1,4),'linewidth',1.5)
plot(freq,sigIt.K(:,2,4),'linewidth',1.5)

[fitresult, ~] = createFit(freq, log10(EyesClosedWelch(i,2:100)));
[fitresult, ~] = createFit(freq, log10(sigIt.K(:,1,4)));
plot(freq,5.347 -log10(freq.^ 2.648),':','linewidth',1.5)