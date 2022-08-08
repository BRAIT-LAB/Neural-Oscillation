clean
load WakefulnessMatlabFile.mat

dchdch=pdist(ChannelPosition);
dchch=squareform(dchdch);
subplot(131)
imagesc(dchch)
axis square
colorbar
Nodes=[NodesLeft;NodesRight];
Faces=[FacesLeft;FacesRight];
[nnodes,~]=size(Nodes);
dchno=pdist2(ChannelPosition,Nodes);
subplot(132)
imagesc(dchno)
axis normal
colorbar
[m,j]=min(dchno,[],2);
u=unique(j);
used(u)=1;
used=sparse(used);
subplot(133)
spy(used'*used)
axis square
colorbar

x=zeros(nnodes,1);
x(j)=m;
plot_peter(x,Nodes,Faces);

[nnodesL,~]=size(NodesLeft);
xleft=x(1:nnodesL);
plot_peter(xleft,NodesLeftInflated,FacesLeft);

[nnodesR,~]=size(NodesRight);
xright=x(1:nnodesR);
plot_peter(xright,NodesRightInflated,FacesRight);

