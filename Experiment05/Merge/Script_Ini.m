%% Script_Ini

display('Initialize System.');
display('load Example Dataset...');

load('matlab.mat')

%% Tracking System Initialize
display('Initialize Tracking System...');
global frameRate;
lastFrameTime = -1.0;
lastFrameID = -1.0;
usePollingLoop =true;         % approach 1 : poll for mocap data in a tight loop using GetLastFrameOfData
usePollingTimer = false;        % approach 2 : poll using a Matlab timer callback ( better for UI based apps )
useFrameReadyEvent = false;      % approach 3 : use event callback from NatNet (no polling)
useUI = true;
DataSet = [];
%% Run Client
try
    Script_Try; % Return 'theClient'
catch err
    display(err);
end

%% Agent Initial Location
display('Get Orientation of Agent...');
data = theClient.GetLastFrameOfData();
agent = 1;
counter = 1;
% Agent
for agent = 1 : AgentNumber
    x = data.RigidBodies(agent).x;
    DataSet(counter,(agent-1)*6+1) = x;
    y = data.RigidBodies(agent).y;
    DataSet(counter,(agent-1)*6+2) = y;
    z = data.RigidBodies(agent).z;
    DataSet(counter,(agent-1)*6+3) = z;
    
    q = [ data.RigidBodies(agent).qx, data.RigidBodies(agent).qy, ...
        data.RigidBodies(agent).qz, data.RigidBodies(agent).qw ];
    angles = quaternion( q );
    DataSet(counter,(agent-1)*6+4) = angles(1) * 180.0 / pi;   % must invert due to 180 flip above
    DataSet(counter,(agent-1)*6+5) = -angles(2) * 180.0 / pi;
    DataSet(counter,(agent-1)*6+6) = angles(3) * 180.0 / pi;   % must invert due to 180 flip above
end


%% Initialize Controller on Agent
display('Init Micro-Controller on Agent...');
for agent = 1 : AgentNumber
    mbed(agent) = serial(SPort(agent,:),'BaudRate',9600);
    fopen(mbed(agent));
end
mbed
% Show serial port information

%% Initialize Agents
display('Init Khepera IV Robot...');
% Common Part
import java.net.Socket
import java.io.*
AgentPort = 344;
% AgentSocket = [];
AgentMessage = fun_int2instruction(0,0);
% Different Agents
for agent = 1 : AgentNumber
    % IP Address
    switch ( agent )
        case 1
            AgentAddress = agentAddr1;
        case 2
            AgentAddress = agentAddr2;
        case 3
            AgentAddress = agentAddr3;
        case 4
            AgentAddress = agentAddr4;
        otherwise
            display('IP Address ERROR!');
    end
    % Init Socket
    AgentSocket( agent ) = Socket( AgentAddress , AgentPort );
    AgentDataInput( agent ) = DataInputStream( AgentSocket(agent).getInputStream );
    AgentDataOutput( agent ) = DataOutputStream( AgentSocket(agent).getOutputStream );
end

%% Agent Calibration
display('Start Calibrate Sensor on Khepera Robot...');
display('skip calibration.');
CalibNum = 2;% just test the code here
AgentStream = [];
for ccounter = 1 : CalibNum
    for agent = 1 : AgentNumber
        sensorCal(ccounter,agent) = str2num(fgetl(mbed(agent)));
    end
end
% sensorBG = mean(sensorCal);
% sensorBG should be loaded in advance...
display('Finish Calibration.');


%% Measure Initial Orientation
display('Measure Initial Orientation of Agent.');
display('Start Moving the Agent...');
% Move Agents
AgentMessage = fun_int2instruction(iniVel,iniVel);
movcounter = 1;
while(movcounter<=iniMov)
    for agent = 1 : AgentNumber
        AgentDataOutput(agent).writeBytes(AgentMessage);
    end
    pause(PauseTime);
    movcounter = movcounter + 1;
end
% Stop
AgentMessage = fun_int2instruction(0,0);
for agent = 1 : AgentNumber
    AgentDataOutput(agent).writeBytes(AgentMessage);
end
% Agent Position
counter = counter + 1;
for agent = 1 : AgentNumber
    x = data.RigidBodies(agent).x;
    DataSet(counter,(agent-1)*6+1) = x;
    y = data.RigidBodies(agent).y;
    DataSet(counter,(agent-1)*6+2) = y;
    z = data.RigidBodies(agent).z;
    DataSet(counter,(agent-1)*6+3) = z;
    
    q = [ data.RigidBodies(agent).qx, data.RigidBodies(agent).qy, ...
        data.RigidBodies(agent).qz, data.RigidBodies(agent).qw ];
    angles = quaternion( q );
    DataSet(counter,(agent-1)*6+4) = angles(1) * 180.0 / pi;   % must invert due to 180 flip above
    DataSet(counter,(agent-1)*6+5) = -angles(2) * 180.0 / pi;
    DataSet(counter,(agent-1)*6+6) = angles(3) * 180.0 / pi;   % must invert due to 180 flip above
end
% Calculate Orientation
display('Start Calculating Orientation...');
angleData = DataSet(counter,:)-DataSet(counter-1,:);
for agent = 1 : AgentNumber
    iniAngle(agent) = atan2(angleData(3+(agent-1)*6),angleData(1+(agent-1)*6))*180/pi;
end

%% Reading First group of data from Sensor
display('Read 1st group of data.');
for agent = 1 : AgentNumber
    Values(1,agent) = str2num(fgetl(mbed(agent)));
end

%% Reading Second group of data from Sensor
% Because the counter become 2 instead
display('Read 2nd group of data.');
for agent = 1 : AgentNumber
    Values(counter,agent) = str2num(fgetl(mbed(agent)));
end

%% Initial Algorithm
display('Test the Algorithm...');
Script_IniAgent;

%% Test data
r1_s = [];
r2_s = [];
r3_s = [];
r4_s = [];

display('Pause...');
pause(breakTime);
