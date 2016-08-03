%% Script_Parameter

% Number of Agent
AgentNumber = 4;

% Serial Port of mbed Controller
% SPort(1) = 'COM1';
% SPort(2) = 'COM2';
% SPort(3) = 'COM3';
% SPort(4) = 'COM4';

% Agent Address
agentAddr1 = '192.168.1.50';
agentAddr2 = '192.168.1.55';
agentAddr3 = '192.168.1.60';
agentAddr4 = '192.168.1.121';

% Frame Pausing
PauseTime = 0.1;
breakTime = 2;

% Sensor Reading Threshold
% SensorThreshold = 2500;

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

%
epsilon = 0.00005;