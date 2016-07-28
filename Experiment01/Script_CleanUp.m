%% Script_CleanUp

% Sensor System
fclose(mbed(1));
fclose(mbed(2));
fclose(mbed(3));
fclose(mbed(4));

% % Tracking System
% if(usePollingTimer)
%     stop(TimerData);
%     delete(TimerData);
% end
% theClient.Uninitialize();
% if(useFrameReadyEvent)
%     if(~isempty(ls))
%         delete(ls);
%     end
% end
% clear functions;

% Agent System
server_socket.close;
output_socket.close;

