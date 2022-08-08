%Spatial analysis of peaks
clean
load WakefulnessMatlabFile.mat

% downsample the cortex
ResCortex = 6000;
cortex = downSample2Surfaces(NodesLeft,FacesLeft, NodesRight, FacesRight, ResCortex, ResCortex);

% Asociate the electrodes to cortical point
dchno=pdist2(ChannelPosition,cortex.vertices);
[m,closest_vertex]=min(dchno,[],2);

nver = size(cortex.vertices,1);  % 网格点数
nfaces = size(cortex.faces,1);    % faces数
A=sparse(nver,nver);

for k=1:nfaces
    node1=cortex.faces(k,1);
    node2=cortex.faces(k,2);
    node3=cortex.faces(k,3);
    A(node1,node2)=1;
    A(node2,node1)=1;
    A(node1,node3)=1;
    A(node3,node1)=1;
    A(node2,node3)=1;
    A(node3,node2)=1;
end
G=graph(A);
Geo_dist=distances(G,'method','positive');

load fitrs
clearvars -except Geo_dist cortex parall closest_vertex


par = reshape(parall,4,15*1772);
closest_ver_allpeak = repmat(closest_vertex',15,1);
par(5,:) = closest_ver_allpeak(:)';
par(:,par(1,:)==0)=[];

save presmooth Geo_dist cortex par