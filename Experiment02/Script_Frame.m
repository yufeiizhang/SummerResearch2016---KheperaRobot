%% Script_Frame

%% Frame Header
counter = counter + 1;

%% Agent Location
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
    DataSet(counter,(agent-1)*6+4) = -angles(1) * 180.0 / pi;   % must invert due to 180 flip above
    DataSet(counter,(agent-1)*6+5) = angles(2) * 180.0 / pi;
    DataSet(counter,(agent-1)*6+6) = -angles(3) * 180.0 / pi;   % must invert due to 180 flip above
end
% fun_Trac2Simulation([DataSet(2,1);DataSet(2,3)])

%% Sensor Reading
% for agent = 1 : AgentNumber
%     AgentStream(agent) = fgetl(mbed(agent));
%     % record 1 group of data every frame
%     %
%     n=0;p=0;marker=0;
%     % check the size of sensor reading data and 
%     % check the value of sensor reading data
%     while((n~=1)||(p~=1)||(marker~=1))
%         DataTemp = sscanf(AgentStream(agent),'%d');
%         [n,p] = size(DataTemp);
%         if( abs( DataTemp-Values(counter-1,agent) ) <= SensorThreshold )
%             marker=1;
%         end
%     end
%     Values(counter,agent) = DataTemp;
%     clear DataTemp;
% end

%% Run Algorithm
Script_Algorithm;

%% Run Agent
% Navigator
Script_AgentNavigator;
Script_SendCommand;

%% Waiting
pause(PauseTime);
