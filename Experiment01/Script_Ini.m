%% Script_Ini
load('matlab.mat')
load('Tracking5.mat')
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
    
%     q = quaternion( data.RigidBodies(agent).qx, data.RigidBodies(agent).qy, ...
%         data.RigidBodies(agent).qz, data.RigidBodies(agent).qw );
%     qRot = quaternion( 0, 0, 0, 1);     % rotate pitch 180 to avoid 180/-180 flip for nicer graphing
%     q = mtimes(q, qRot);
%     angles = EulerAngles(q,'zyx');
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
% mbed(1) = serial(SPort1,'BaudRate',9600);
% mbed(2) = serial(SPort2,'BaudRate',9600);
% mbed(3) = serial(SPort3,'BaudRate',9600);
% mbed(4) = serial(SPort4,'BaudRate',9600);
% fopen(mbed(1));
% fopen(mbed(2));
% fopen(mbed(3));
% fopen(mbed(4));

%% Initialize Agent Client
% fun_ClientIni();


%% Information about Agent
import java.net.Socket
import java.io.*
Robot_port = 344;
Script_AgentConn;


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
send_save = [];
r1_S=[];
rk1_S=[];
% send_save = [ '0000.0000.00' , '0000.0000.00' ];
