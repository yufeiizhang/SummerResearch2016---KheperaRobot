%% Pre-Define Parameter
agent = 1;
agentAddr = '192.168.1.50';
PauseTime = 0.1;
messageLen = 10;
iniMov = 50;
iniVel = 50;
xTar = 0;
zTar = 0;
errThreshold = 0.2;
velocityMultiplier = 1;
omegaMultiplier = 1;
agentLength = 0.15;

%% Initialize Tracking System
global frameRate;
lastFrameTime = -1.0;
lastFrameID = -1.0;
usePollingLoop =true;
usePollingTimer = false;
useFrameReadyEvent = false;
useUI = true;
DataSet = [];
try
    Script_Try; % Return 'theClient'
catch err
    display(err);
end

%% Get Agent Initial Location
data = theClient.GetLastFrameOfData();
counter = 1;
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

%% Initialize Agent
import java.net.Socket
import java.io.*% Agent
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
AgentPort = 344;
AgentMessage = fun_int2instruction(0,0);
AgentAddress = agentAddr;
AgentSocket( agent ) = Socket( AgentAddress , AgentPort );
AgentDataInput( agent ) = DataInputStream( AgentSocket(agent).getInputStream );
AgentDataOutput( agent ) = DataOutputStream( AgentSocket(agent).getOutputStream );

%% Get Initial Orientation of Agent
% Move Agent
AgentMessage = fun_int2instruction(iniVel,iniVel);
movcounter = 1;
while(movcounter<=iniMov)
    AgentDataOutput(agent).writeBytes(AgentMessage);
    pause(PauseTime);
    movcounter = movcounter + 1;
end
% Stop agent
AgentMessage = fun_int2instruction(0,0);
AgentDataOutput(agent).writeBytes(AgentMessage);
% Get Position
counter = counter + 1;
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
% Calculate Orientation
angleData = DataSet(2,:)-DataSet(1,:);
iniAngle(agent) = atan2(angleData(3+(agent-1)*6),angleData(1+(agent-1)*6))*180/pi;

%% Frame
% Frame Header
while(1)
    counter = counter + 1;
    % Agent Location
    x = data.RigidBodies(agent).x;
    DataSet(counter,(agent-1)*6+1) = x;
    y = data.RigidBodies(agent).y;
    DataSet(counter,(agent-1)*6+2) = y;
    z = data.RigidBodies(agent).z;
    DataSet(counter,(agent-1)*6+3) = z;
    
    q = [ data.RigidBodies(agent).qx, data.RigidBodies(agent).qy, ...
        data.RigidBodies(agent).qz, data.RigidBodies(agent).qw ];
    angles = quaternion( q );
    DataSet(counter,(agent-1)*6+4) = -angles(1) * 180.0 / pi;   % must invert due to 180 flip above
    DataSet(counter,(agent-1)*6+5) = angles(2) * 180.0 / pi;
    DataSet(counter,(agent-1)*6+6) = -angles(3) * 180.0 / pi;   % must invert due to 180 flip above
    % Trigger
    err = ( x - xTar ) ^2 + ( z - zTar ) ^2;
    if abs( sqrt( err ) ) <= errThreshold
        break;
    end
    if counter >= 100
        break;
    end
    % Seeking Algorithm
    [ velocity , omega ] = fun_mov2Point( x , z  , xTar , zTar , iniAngle(agent) , ...
        DataSet(counter,(agent-1)*6+5) , velocityMultiplier , omegaMultiplier );
    [ lspeed , rspeed ] = fun_revolution( velocity , omega , agentLength );
    [ velocity , omega , lspeed , rspeed ]
    AgentMessage = fun_int2instruction( lspeed , rspeed );
    % Send Instruction
    AgentDataOutput(agent).writeBytes(AgentMessage);
    pause(PauseTime);
end

%% Clean Up
AgentMessage = 'S0000S0000';
AgentDataOutput(agent).writeBytes(AgentMessage);
if(usePollingTimer)
    stop(TimerData);
    delete(TimerData);
end
theClient.Uninitialize();
if(useFrameReadyEvent)
    if(~isempty(ls))
        delete(ls);
    end
end
clear functions;