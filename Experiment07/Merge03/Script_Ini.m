%% Script_Ini

display('Initialize System.');
display('load Example Dataset...');

% load previous field
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
%mbed(1) = serial(sPort(1,:),'BaudRate',9600);
%pause;
%mbed(1).InputBufferSize = 32;
%fopen(mbed(1));
%readasync(mbed(1));
for agent = 1 : AgentNumber
    btIns(agent) = instrhwinfo('Bluetooth',SPort(agent,:));
    btChannel(agent) = str2double(btIns(agent).Channels);
    mbed(agent) = Bluetooth(SPort(agent,:),btChannel(agent));
    pause;
    mbed(agent).InputBufferSize = 512;
    mbed(agent).ReadAsyncMode='Manual';
    fopen(mbed(agent));
    mbed(agent).ReadAsyncMode='Manual';
    %readasync(mbed(agent));
end
mbed
pause;
% Show serial port information

% Set Serial Port Status


%% Agent Calibration
display('Start Calibrate Sensor on Khepera Robot...');
% display('skip calibration.');
% CalibNum = 100;% test the code here
AgentStream = [];
for ccounter = 1 : CalibNum
    for agent = 1 : AgentNumber
        if ccounter == 1
            sensorCal(ccounter,agent) = fun_SensorReader(mbed(agent),800);
        else
            sensorCal(ccounter,agent) = fun_SensorReader(mbed(agent),sensorCal(ccounter-1,agent));
        end
    end
    pause(0.25);
end
sensorBG = mean(sensorCal);
% sensorBG overwrite that file.
display('Finish Calibration.');


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


%% Measure Initial Orientation
display('Measure Initial Orientation of Agent.');
display('Start Moving the Agent...');
% Move Agents
AgentMessage = fun_int2instruction(iniVel,iniVel);
movcounter = 1;
while(movcounter<=iniMov)
    for agent = 1 : AgentNumber
        AgentDataOutput(agent).writeBytes(AgentMessage);
        InstRec(InsCoun,:) = AgentMessage;
        InsCoun = InsCoun+1;
    end
    pause(PauseTime);
    movcounter = movcounter + 1;
end
% Stop
AgentMessage = fun_int2instruction(0,0);
for agent = 1 : AgentNumber
    AgentDataOutput(agent).writeBytes(AgentMessage);
    InstRec(InsCoun,:) = AgentMessage;
    InsCoun = InsCoun+1;
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



%% Initial Algorithm
display('Test the Algorithm...');
Script_IniAgent;

%% Test data
r1_s = [];
r2_s = [];
r3_s = [];
r4_s = [];

display('Pause...');
pause;% Waiting for diffusion field

%% Calculate Initial Distance Between Agent and Group Center.
iniCenter = 0;
r1_T=[DataSet(counter,1); DataSet(counter,3)];
r2_T=[DataSet(counter,1+6); DataSet(counter,3+6)];
r3_T=[DataSet(counter,1+12); DataSet(counter,3+12)];
r4_T=[DataSet(counter,1+18); DataSet(counter,3+18)];
r1=fun_Trac2Simulation(r1_T);
r2=fun_Trac2Simulation(r2_T);
r3=fun_Trac2Simulation(r3_T);
r4=fun_Trac2Simulation(r4_T);
iniCenter = mean([r1,r2,r3,r4]')';
r1_d = r1 - iniCenter;
r2_d = r2 - iniCenter;
r3_d = r3 - iniCenter;
r4_d = r4 - iniCenter;

%% Reading First group of data from Sensor
display('Read 1st group of data.');
for agent = 1 : AgentNumber
    RawValues(1,agent) = fun_SensorReader(mbed(agent),0) - sensorBG(agent) + iniBG;
    Values(1,agent) = RawValues(1,agent);
end

%% Reading Second group of data from Sensor
% Because the counter become 2 instead
display('Read 2nd group of data.');
for agent = 1 : AgentNumber
    RawValues(counter,agent) = fun_SensorReader(mbed(agent),RawValues(1,agent)) - sensorBG(agent) + iniBG;
    Values(counter,agent) = RawValues(counter,agent);
end

pause(breakTime);