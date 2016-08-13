%% Script_Parameter

display('Start to load Parameters of Algorithm.');
% Number of Agent
AgentNumber = 4;

% Serial Port of mbed Controller
SPort(1,:) = 'COM32';
SPort(2,:) = 'COM33';
SPort(3,:) = 'COM35';
SPort(4,:) = 'COM37';

% Agent Address
agentAddr1 = '192.168.1.50';
agentAddr2 = '192.168.1.55';
agentAddr3 = '192.168.1.60';
agentAddr4 = '192.168.1.121';

display('Finish loading Agent information.');

% Frame Pausing
PauseTime = 0.1;
breakTime = 2;

% Sensor Reading Threshold
SensorThreshold = 2500;

% Length of Command 
messageLen = 10;

% Orientation Measurement
iniMov = 20;
iniVel = 50;

% Agent Velocity Control
velocityMultiplier = 250;
omegaMultiplier = 1;
agentLength = 0.15*500;

% Loop
loopNum = 4+800;
stepLength = 8;

% Acceptable Motion Error
epsilon = 0.00005;

% Sensor Calibration loop counter
CalibNum = 1000;