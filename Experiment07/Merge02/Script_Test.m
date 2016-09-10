% Script_test
Script_Parameter;
AgentNumber = 1;

%% Initialize Controller on Agent
display('Init Micro-Controller on Agent...');
for agent = 1 : AgentNumber
    mbed(agent) = serial(SPort(agent,:),'BaudRate',9600);
    mbed(agent).InputBufferSize = 16;
    %mbed(agent).ReadAsyncMode = 'continuous'
    fopen(mbed(agent));
    readasync(mbed(agent));
end
mbed
%% Agent Calibration
display('Start Calibrate Sensor on Khepera Robot...');
% display('skip calibration.');
% CalibNum = 100;% test the code here
AgentStream = [];
for ccounter = 1 : CalibNum
    for agent = 1 : AgentNumber
        %flushinput(mbed(agent));
        sensorCal(ccounter,agent) = str2num(fgetl(mbed(agent)));
    end
    pause(0.2);
end
sensorBG = mean(sensorCal);
% sensorBG overwrite that file.
display('Finish Calibration.');