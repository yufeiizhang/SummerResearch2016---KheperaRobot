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
end; % Return 'theClient'
catch err
    display(err);
end