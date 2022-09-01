%% plot initialized components and peaks/troughs
%plotflag = [1 1 1];
% unimodal fitting
tic;
[spt_ftd,sigIt,sig_para,final] = scmem_unim(spt(9,:)',freq',[0 1 1]);
ts = toc;

[spt_ftd,sigIt,lh] = scmem_unim(log10(spt(1,:))',freq',[1 1 0]);

% spt和freq必须为列向量
tic;
settings = struct();
fooof_results = fooof(freq, spt(9,:), [0 40], settings, 1);
fof_t = toc;

%
re=[];
for i = 1:1772    
    try
            fooof_results = fooof(freq, spt_or(i,:), [0 40], settings, 1);
        catch
            disp(['频谱无法解析','channel',num2str(i)]);
            continue;
    end
    fooofed_spectrum_natural=zeros(1,102);
    for j = 1:102
        fooofed_spectrum_natural(1,j) = 10^(fooof_results.fooofed_spectrum(1,j));
    end
    result = sum((fooofed_spectrum_natural - spt_or(i,:)).^2)/102;
    re = [re,result];
end