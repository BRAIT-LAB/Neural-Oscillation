clean;
load WakefulnessMatlabFile;
dbstop if error
np = max(Patient);
% note the eletrodes are sorted in order according to subjects
eleidx4sbj=zeros(np,2); % 
for i=1:np
a=find(Patient==i);
if isempty(a), continue; end
eleidx4sbj(i,:)=[min(a), max(a)];
end

elen = eleidx4sbj(:,2)-eleidx4sbj(:,1);
% elen

figure,plot(1:np,elen,'b.','markersize',10); xlabel('Subjects'); ylabel('# of electrodes');
