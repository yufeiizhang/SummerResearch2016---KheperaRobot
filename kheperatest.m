% test khepera robot
% not for the experiment


%/*1encoder=0.000675m/s=0.675mm/s*/
% MATLAB CODES FOR KHEPERA 4 COMMUNICATION
AgentSocket = [];
AgentMessage = 'L0000R0000';
AgentAddress = '192.168.1.55';
AgentPort = 344;
messageLen = 10;
%
import java.net.Socket
import java.io.*
%
AgentSocket = Socket( AgentAddress , AgentPort );
AgentDataInput = DataInputStream( AgentSocket.getInputStream );
AgentDataOutput = DataOutputStream( AgentSocket.getOutputStream );
%
tic;
counter  = 1;
while(counter<=100) 
    AgentMessage = 'L+100R+100';
    AgentDataOutput.writeBytes(AgentMessage);
    pause(0.1);
    counter = counter + 1;
end
toc
AgentMessage = 'S0000S0000';
AgentDataOutput.writeBytes(AgentMessage);
