function plotslice (data,frg)
% PLOTSLICE plot all the slice of cross spectra tensor into a box
% Input 
%          data --- cross coherence tensor Nc*Nc*Nf
%           frg  --- frequency range [fmin,fmax] or whole vector of freq
%           bins

[Nc,~,Nf] = size(data);

[x,y,z] = meshgrid(1:1:Nc,1:1:Nc,linspace(frg(1),frg(end),Nf));

v = data;
xslice = [1, Nc];
yslice = [1, Nc];
zslice = [frg(1),frg(end)];
figure,slice(x,y,z,v,xslice,yslice,zslice);
xlim([1 Nc]), ylim([1 Nc]);
xlabel('Electrodes','color','w'),ylabel('Electrodes','color','w'),zlabel('Freq/Hz','color','w'); 
set(gca,'fontsize',12,'xcolor','w','ycolor','w','zcolor','w');
colorbar; colormap jet;
set(gcf,'color','k'); colorbar('color','w');
view(3)
end