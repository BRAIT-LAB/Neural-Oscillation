% AwakeEyesOpend pwelch spectrum fitting
EyesOpenedWelch = [];
EyesClosedWelch = [];
AnesthetizedWelch = [];
for i = 1:128
%     time = AwakeEyesOpened(i,1:12800);
%     [pxx,f] = pwelch(time,hamming(200),100,400,200); 
%     EyesOpenedWelch = [EyesOpenedWelch;pxx'];
    
%     time = AwakeEyesClosed(i,1:12800);
%     [pxx,f] = pwelch(time,hamming(200),100,400,200); 
%     EyesClosedWelch = [EyesClosedWelch;pxx'];
%     
%     time = Anesthetized(i,1:12800);
%     [pxx,f] = pwelch(time,hamming(200),100,400,200); 
%     AnesthetizedWelch = [AnesthetizedWelch;pxx'];
end