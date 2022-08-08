% clean;
load WakefulnessMatlabFile;
% load MatlabFile_Dec2019.mat

% Full normal HmS
options.figname='Normal';
patch.faces=[FacesLeft;FacesRight+size(NodesLeft,1)];
patch.vertices=[NodesLeft;NodesRight];
options.texture=zeros(size(patch.vertices,1),1);
spm_eeg_render(patch,options);

% % Right HmS
% options.figname='Right HmS';
% patch.faces=FacesRight;
% patch.vertices=NodesRight;
% options.texture=rand(size(NodesRight,1),1);
% spm_eeg_render(patch,options);

% Inflated
% options.figname='Inflated';
% patch.faces=[FacesLeft;FacesRight+size(NodesLeftInflated,1)];
% patch.vertices=[NodesLeftInflated;NodesRightInflated];
% options.texture=rand(size(patch.vertices,1),1);
% spm_eeg_render(patch,options);

% % Right Inflated
% options.figname='Right Inflated';
% patch.faces=FacesRight;
% patch.vertices=NodesRightInflated;
% options.texture=rand(size(NodesRightInflated,1),1);
% spm_eeg_render(patch,options);


% create atlas for brainsotrm visualization and simulation
close all;
cortex15002 = load('/home/shu/brainstorm_db/Protocol01/anat/Subject01/tess_cortex_pial_low.mat');
Scouts = cortex15002.Atlas(3).Scouts;
Region = [NodesRegionLeft;NodesRegionRight];
Scouts(40:end) = [];
for i=1:length(RegionName)
    Scouts(i).Vertices = find(Region==i)';
    Scouts(i).Label = RegionName{i};
    Scouts(i).Region = [];
    Scouts(i).Seed = [];
end
clearvars -except Scouts patch cortex15002;
cortex_iEEG = cortex15002;
cortex_iEEG.Vertices = patch.vertices/1000;
cortex_iEEG.Faces = patch.faces;
cortex_iEEG.Atlas = struct('Name','default','Scouts',Scouts);
cortex_iEEG.VertNormals = [];
cortex_iEEG.VertConn = [];
cortex_iEEG.Comment = 'cortex_iEEG238436V';
cortex_iEEG.Curvature = [];
cortex_iEEG.SulciMap = [];
cortex_iEEG.tess2mri_interp = [];
cortex_iEEG.iAtlas = 1;
% rotate the axis
Ref = cortex15002.Vertices;
vertices = cortex_iEEG.Vertices;
tmp = cortex_iEEG.Vertices;
tmp(:,1) = vertices(:,2);
tmp(:,2) = -vertices(:,1);
tmp(:,3) = vertices(:,3);
nver = size(tmp,1);
tmp = tmp./repmat(max(tmp) - min(tmp),nver,1).*repmat(max(Ref)-min(Ref),nver,1);
cortex_iEEG.Vertices = tmp + repmat(max(Ref) - max(tmp),nver,1);
cortex_iEEG.Reg.Sphere.Vertices=[];
% cortex_iEEG.Vertices = cortex_iEEG.Vertices * 0.8; % avoid the vertives override the innerskull
% mannually fix by clicking 'force into skull'
% cortex_iEEG=rmfield(cortex_iEEG,'mrimask');
% import cortex_iEEG from MATLAB workspace to Brainstorm subject

iEEGmat = load('WakefulnessMatlabFile.mat');
chan19 = load('/home/shu/brainstorm_db/Protocol01/data/Subject01/@intra/channel_10-20_19.mat');
chan_iEEG = chan19;
chan_iEEG.Channel = repmat(chan_iEEG.Channel(1),[1772,1]);
chan_iEEG.Comment = 'iEEG';
for i=1:1772
chan_iEEG.Channel(i).Loc = iEEGmat.ChannelPosition(i,:)./100;
chan_iEEG.Channel(i).Name = iEEGmat.ChannelName(i);
chan_iEEG.Channel(i).Type = 'SEEG';
chan_iEEG.Channel(i).Comment = iEEGmat.ChannelRegion(i);
end

fid = fopen('ele/elec_allregion_mni.txt','w');
for i=1:1772
fprintf(fid,'%s %.4f %.4f %.4f\n',num2str(i),iEEGmat.ChannelPosition(i,1),iEEGmat.ChannelPosition(i,2),iEEGmat.ChannelPosition(i,3));
end
fclose(fid);

for r=1:39
    region = iEEGmat.RegionName{r};
    chn = find(iEEGmat.ChannelRegion == r);
    fid = fopen(['ele/elec_',region,'_mni.txt'],'w');
    for i=1:length(chn)
        c = chn(i);
        fprintf(fid,'%s %.4f %.4f %.4f\n',iEEGmat.ChannelName{c},iEEGmat.ChannelPosition(c,1),...
            iEEGmat.ChannelPosition(c,2),iEEGmat.ChannelPosition(c,3));
    end
    fclose(fid);
end