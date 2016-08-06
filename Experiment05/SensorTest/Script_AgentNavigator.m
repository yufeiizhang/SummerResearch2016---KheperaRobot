%% Agent Navigator
% clear xTar zTar
% Target of Agents
% for agent = 1 : AgentNumber
%     
%     xTar(agent) = 0;%%need more information
%     zTar(agent) = 0;
% end

mcounter = 1;
flag = [0,0,0,0];
while(1)
    % escape condition
    if mcounter >= stepLength
        break;
    end
    if sum(flag) >= 4
        break;
    end
    % algrithm for different agent
    for agent  = 1 : AgentNumber
        % check error
        error = (data.RigidBodies(agent).x-xTar(agent))^2 + (data.RigidBodies(agent).z-zTar(agent))^2;
        if flag(agent) == 1
            continue;
        end
        if error <= epsilon
            flag(agent) = 1;
            continue;
        end
        % Prepare
        q = [ data.RigidBodies(agent).qx, data.RigidBodies(agent).qy, ...
            data.RigidBodies(agent).qz, data.RigidBodies(agent).qw ];
        angles = quaternion( q );
        ori = -angles(2) * 180.0 / pi;
        % Seeking Algorithm
        [ velocity , omega ] = fun_mov2Point( data.RigidBodies(agent).x , data.RigidBodies(agent).z  , ...
            xTar(agent) , zTar(agent) , iniAngle(agent) , ...
            ori , velocityMultiplier , omegaMultiplier );
        [ lspeed , rspeed ] = fun_revolution( velocity , omega , agentLength );
        AgentMessage = fun_int2instruction( lspeed , rspeed );
        % Send Instruction
        AgentDataOutput(agent).writeBytes(AgentMessage);
    end
    % pause
    pause(PauseTime);
    mcounter = mcounter + 1;
end