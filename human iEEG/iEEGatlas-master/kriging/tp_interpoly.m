clean;
load presmooth
nPeaks = size(par,2);
nVertices = size(cortex.vertices,1);
Dd = Geo_dist(par(5,:),par(5,:)).^2; % distances between 2 peaks
Df = squareform(pdist(par(2,:)')).^2;
amp = par(1,:)';

% hyperparameters
hDRange = logspace(-1,2,25);
hFRange = logspace(-1,2,25);

for i = 1:numel(hDRange)
    hD = hDRange(i);
    for j = 1:numel(hFRange)
        disp([i j])
        hF = hFRange(j);
        
        W = exp(-Dd/hD - Df/hF) - eye(nPeaks);
        W = W ./ repmat(sum(W,2),1,nPeaks); 
        
        amp0 = W*amp;
        
        cverr(i,j) = sqrt(mean(amp0-amp).^2);
    end
end

%optCVIndex = [3 15];
optCVIndex = [23 14];

hD = hDRange(optCVIndex(1));
hF = hFRange(optCVIndex(2));

Dd = Geo_dist(:,par(5,:)).^2;
Frequencies = 1:40;

for f = 1:numel(Frequencies)
    Df = repmat((par(2,:)-Frequencies(f)).^2,nVertices,1);
    W = exp(-Dd/hD - Df/hF);
    W = W ./ repmat(sum(W,2),1,nPeaks); 
    fittedamp(f,:) = W*amp;
end

save fittedamp fittedamp Frequencies cverr cortex;