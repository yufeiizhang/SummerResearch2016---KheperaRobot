
%% Script_Try
% Add NatNet .NET assembly so that Matlab can access its methods, delegates, etc.
% Note : The NatNetML.DLL assembly depends on NatNet.dll, so make sure they
% are both in the same folder and/or path if you move them.
display('[NatNet] Creating Client.')
% TODO : update the path to your NatNetML.DLL file here
dllPath = fullfile('c:','NatNet_SDK_2.6','lib','x64','NatNetML.dll');
assemblyInfo = NET.addAssembly(dllPath);

% Create an instance of a NatNet client
theClient = NatNetML.NatNetClientML(0); % Input = iConnectionType: 0 = Multicast, 1 = Unicast
version = theClient.NatNetVersion();
fprintf( '[NatNet] Client Version : %d.%d.%d.%d\n', version(1), version(2), version(3), version(4) );

% Connect to an OptiTrack server (e.g. Motive)
display('[NatNet] Connecting to OptiTrack Server.')
hst = java.net.InetAddress.getLocalHost;
HostIP = char(hst.getHostAddress);
%HostIP = char('127.0.0.1');
flg = theClient.Initialize(HostIP, HostIP); % Flg = returnCode: 0 = Success
if (flg == 0)
    display('[NatNet] Initialization Succeeded')
else
    display('[NatNet] Initialization Failed')
end

% print out a list of the active tracking Models in Motive
GetDataDescriptions(theClient)