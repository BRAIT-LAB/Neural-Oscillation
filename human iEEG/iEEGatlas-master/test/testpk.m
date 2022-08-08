clear;
clc;
load results
[n,nf]=size(S_spect);
p=0.2;
% p=0.5;
% p=0.7; % select the p value

ID = [];Channel = []; Frequency = []; Amplitude = []; % for table struct
Column_name = {'ID','Channel','Frequency','Amplitude'};
Peaks_table = table(ID,Channel,Frequency,Amplitude,'VariableNames',Column_name);

for i=1:size(S_spect,1)
    disp(['-------- check for ',num2str(i),' channel --------']);
    tmp = S_spect(i,:);
    s=log10(S_spect(i,:));
    ppSpline = csaps(F,s,p);
    [maxima, minima] = splineMaximaMinima(ppSpline);
    s_smooth = csaps(F,s,p,F);
%     plot(F,[s_smooth',s']);
%     hold
%     plot(maxima,ppval(ppSpline,maxima),'r*');
%     plot(minima,ppval(ppSpline,minima),'gs');
%     close all;
    if ~isempty(maxima)
        for ss=1:length(maxima)
            [minx, indx] = min(abs(F-maxima(ss))); % find the closest frequency to maxima
            cell_table = {ss,i,F(indx),tmp(indx)}; % save in the table
            tmp_table = cell2table(cell_table);
            tmp_table.Properties.VariableNames = Column_name;
            Peaks_table = [Peaks_table;tmp_table];
        end
    end
end

id = 1:length(Peaks_table.ID); id_cell = num2cell(id'); % change the id
Peaks_table.ID = id_cell;

% save peaks_table_0_2 Peaks_table;   % save for peaks with p=0.2
% save peaks_table_0_5 Peaks_table; % save for peaks with p=0.5
save peaks_table_0_7 Peaks_table; % save for peaks with p=0.5