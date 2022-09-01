function [psd_ftd,components] = scmem_unim( freq, psd_real, plotflag)
% SCM EM algorithm with unimodal nonparametric fitting
% Input
%       psd_real --- power spectrum nf * 1
%       freq --- frequency vector nf*1
%       plotflag --- [1 0 0], plot for initialization
%       w  ----  error vector, default : ones(1,length(freq))
% Output
%       psd_ftd --- [nf-1 * 1] fitted spectrum
%       sigIt --- save sigk, sige, sigk_sdo in each interation as structure
%       meta --- [4*maxIt], lh, aic, bic and exitflag with iterations
% See SCM-EM v7

% Shiang Hu, Aug. 2, 2018
% Heuristic fitting
[~,sigk_ini] = initialfit1(psd_real,freq,plotflag);

if isempty(sigk_ini)
    psd_ftd = psd_real;components = psd_real;
    return;
end

% EM

[sigIt, sigk, sige, lh, maxIt, ank, nf] = em_initial (sigk_ini, 4);
for i=1:maxIt
    % E step
    c = sum(sigk,2)+sige;
    w = repmat((psd_real-c)./c.^2,[1,ank]);
    sigk_sdo = sigk + w.*sigk.^2;
    sige_sdo = sige + w(:,1).*sige.^2;
    
    % M step
    sigk = mstep_unim(sigk_sdo, freq,i);
    sige = mean(sige_sdo)*ones(nf,1);
    
    % save
    [sigIt,  lh] = em_save(sigIt, lh, sigk, sige, sigk_sdo, sige_sdo, i);
 
    if i>1 && abs(lh(i)-lh(i-1))<1e-4
        final = i+1;
        break;
    else
        final = i+1;
    end
end

components = sigIt.K(:,:,final);
psd_ftd = sum(components,2);

end