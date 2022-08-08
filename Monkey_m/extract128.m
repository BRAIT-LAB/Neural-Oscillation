% AwakeEyesOpened AND AwakeEyesClosed  Session 1
AwakeEyesOpened = [];
AwakeEyesClosed = [];
for i = 1:128
    filename = ['ECoG_ch',num2str(i)];
    load(filename);
    data = eval(['ECoGData_ch',num2str(i)]);
    Opened = data(1000:750000);  % 5分钟 1- 301 s
    AwakeEyesOpened = [AwakeEyesOpened,Opened'];
    
    Closed = data(2662530:3383284); % 5分钟 2700 - 3000 s
    AwakeEyesClosed = [AwakeEyesClosed,Closed'];
end

% Anesthetized  Session 2
Anesthetized = [];
for i = 1:128
    filename = ['ECoG_ch',num2str(i)];
    load(filename);
    data = eval(['ECoGData_ch',num2str(i)]);
    Anesthetizion = data(700000:1293294);  % 5分钟 700- 1000 s
    Anesthetized = [Anesthetized,Anesthetizion'];
end