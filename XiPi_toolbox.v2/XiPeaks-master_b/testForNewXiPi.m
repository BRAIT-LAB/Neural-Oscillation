freq = f(2:101);
data = EyesClosedWelch(3,2:101);
datalog = log10(data);
[fitresult, ~] = createFit(freq, datalog);   % b-log(x^a)
b = fitresult.b; a = fitresult.a;

y = b-log10(freq.^a);
plot(freq,datalog); hold on
plot(freq,y)

settings = struct('peak_width_limits',[1 10]);
fooof_results = fooof(freq,data ,[0 50], settings, 1);
plot(freq,fooof_results.ap_fit)