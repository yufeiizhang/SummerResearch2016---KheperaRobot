%% Script_Ini
% load('matlab.mat')
% load('Tracking5.mat')
% Global counter
counter = 1;

%% Tracking System Initialize
global frameRate;
lastFrameTime = -1.0;
lastFrameID = -1.0;
usePollingLoop =true;         % approach 1 : poll for mocap data in a tight loop using GetLastFrameOfData
usePollingTimer = false;        % approach 2 : poll using a Matlab timer callback ( better for UI based apps )
useFrameReadyEvent = false;      % approach 3 : use event callback from NatNet (no polling)
useUI = true;
DataSet = [];

display('Tracking System Initialize');
%% Run Client
try
    Script_Try; % Return 'theClient'
catch err
    display(err);
end
display('Run Client');

%% Agent Initial Location
data = theClient.GetLastFrameOfData();
agent = 1;

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
    DataSet(counter,(agent-1)*6+5) = angles(2) * 180.0 / pi;
    DataSet(counter,(agent-1)*6+6) = angles(3) * 180.0 / pi;   % must invert due to 180 flip above
end

%% Initialize Agents
% Script_IniAgent;

%% Initialize Controller on Agent
% for agent = 1 : AgentNumber
%     mbed(agent) = serial(SPort(agent),'BaudRate',9600);
%     fopen(mbed(agent));
% end

%% Information about Agent
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


%% Reading First group of data from Sensor
% for agent = 1 : AgentNumber
%     AgentStream(agent) = fgetl(mbed(agent));
%     % record 1 group of data every frame
%     %
%     n=0;p=0;marker=0;
%     % check the size of sensor reading data and
%     % check the value of sensor reading data
%     while((n~=1)||(p~=1))
%         DataTemp = sscanf(AgentStream(agent),'%d');
%         [n,p] = size(DataTemp);
%     end
%     Values(counter,agent) = DataTemp;
%     clear DataTemp;
% end


%% Measure Initial Orientation
% Move Agents
AgentMessage = fun_int2instruction(iniVel,iniVel);
while(movcounter<=iniMov)
    for agent = 1 : AgentNumber
        AgentDataOutput(agent).writeBytes(AgentMessage);
    end
    pause(0.1);
    movcounter = movcounter + 1;
end
% Stop
AgentMessage = fun_int2instruction(0,0);
for agent = 1 : AgentNumber
    AgentDataOutput(agent).writeBytes(AgentMessage);
end
% Agent
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
    DataSet(counter,(agent-1)*6+5) = angles(2) * 180.0 / pi;
    DataSet(counter,(agent-1)*6+6) = angles(3) * 180.0 / pi;   % must invert due to 180 flip above
end
% Calculate Orientation
angleData = DataSet(2,:)-DataSet(1,:);
for agent = 1 : AgentNumber
    iniAngle(agent) = atan2(angleData(3+(agent-1)*6),angleData(1+(agent-1)*6))*180/pi;
end
