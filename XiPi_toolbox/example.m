xipi = XiPi('time_series',[1 2 3 ;1 2 3],'channel_number',3);
sep = xipi.startSeparate();

preprocess = xipi.startPreprocess();
preprocess.re_reference() % ...

separatation = preprocess.startSeparate();
separatation.spectra_separate;

paras = separatation.startParameterization();
paras.parameterization


separate.plot();