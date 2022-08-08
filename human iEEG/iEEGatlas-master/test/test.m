clean
load results
[n,nf]=size(S_spect);
i=200;
% i=172;
p=0.1;
s=log10(S_spect(i,:));
ppSpline = csaps(F,s,p);
[maxima, minima] = splineMaximaMinima(ppSpline);
ss = csaps(F,s,p,F)
plot(F,[ss',s']);
hold
plot(maxima,ppval(ppSpline,maxima),'r*');
plot(minima,ppval(ppSpline,minima),'g*');