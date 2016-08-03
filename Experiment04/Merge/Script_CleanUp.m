%% Script_CleanUp

% Stop Agents
AgentMessage = 'S0000S0000';
for agent = 1 : AgentNumber
    AgentDataOutput(agent).writeBytes(AgentMessage);
end

% Sensor System
% for agent = 1 : AgentNumber
%     fclose(mbed(agent));
% end

% Tracking System
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
