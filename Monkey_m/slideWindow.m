stepn = 2000; %10s
windowsize = 6000; %30s
res_wake_xipi = [];
for i = 12:50
    [Svv,F,Ns,PSD] = xspt(data(1,i * stepn + 1:i * stepn+windowsize),200,45,1,3);
%     plot(F,log10(PSD));
%     hold on
    [psd_ftd,components] = scmem_unim_log(F',log10(PSD)',[1 1 1]);
    res_wake_xipi = [res_wake_xipi;components(:,1)'];
end

[pxx,f] = pwelch(data,hamming(128),64,256,128);
data=welch_spt(11,:);
[psd_ftd,components] = scmem_unim(f(2:101)',data(2:101),[0 0 0]);
XiPi_plot(original_spt,components)
XiPi_plot(f(2:101),data(2:101),components)

XiPi_plot(f,data,components)