
%% robot_1
Robot_input_socket_1 = [];
Robot_message_1      = [];
Robot_host_1 = '192.168.1.50';
fprintf(1, 'Connecting to %s:%d\n', ...
    Robot_host_1, Robot_port);
Robot_input_socket_1 = Socket(Robot_host_1, Robot_port);
% get a buffered data input stream from the socket
Robot_input_stream_1   = Robot_input_socket_1.getInputStream;
Robot_output_stream_1   = Robot_input_socket_1.getOutputStream;
Robot_d_input_stream_1 = DataInputStream(Robot_input_stream_1);
Robot_d_output_stream_1 = DataOutputStream(Robot_output_stream_1);

Robot_message_1 = zeros(1,12,'uint8');
fprintf(1, 'Connected to Robot %d.\n', 1);

% %% robot_2
% Robot_input_socket_2 = [];
% Robot_message_2      = [];
% Robot_host_2 = '192.168.1.55';
% fprintf(1, 'Connecting to %s:%d\n', ...
%     Robot_host_2, Robot_port);
% Robot_input_socket_2 = Socket(Robot_host_2, Robot_port);
% % get a buffered data input stream from the socket
% Robot_input_stream_2   = Robot_input_socket_2.getInputStream;
% Robot_output_stream_2   = Robot_input_socket_2.getOutputStream;
% Robot_d_input_stream_2 = DataInputStream(Robot_input_stream_2);
% Robot_d_output_stream_2 = DataOutputStream(Robot_output_stream_2);
%  
% Robot_message_2 = zeros(1,12,'uint8');
% fprintf(1, 'Connected to Robot %d.\n', 2);
% 
% %% robot_3
% Robot_input_socket_3 = [];
% Robot_message_3      = [];
% Robot_host_3 = '192.168.1.60';
% fprintf(1, 'Connecting to %s:%d\n', ...
%     Robot_host_3, Robot_port);
% Robot_input_socket_3 = Socket(Robot_host_3, Robot_port);
% % get a buffered data input stream from the socket
% Robot_input_stream_3   = Robot_input_socket_3.getInputStream;
% Robot_output_stream_3   = Robot_input_socket_3.getOutputStream;
% Robot_d_input_stream_3 = DataInputStream(Robot_input_stream_3);
% Robot_d_output_stream_3 = DataOutputStream(Robot_output_stream_3);
%  
% Robot_message_3 = zeros(1,12,'uint8');
% fprintf(1, 'Connected to Robot %d.\n', 3);
% 
% %% robot_4
% Robot_input_socket_4 = [];
% Robot_message_4      = [];
% Robot_host_4 = '192.168.1.121';
% fprintf(1, 'Connecting to %s:%d\n', ...
%     Robot_host_4, Robot_port);
% Robot_input_socket_4 = Socket(Robot_host_4, Robot_port);
% % get a buffered data input stream from the socket
% Robot_input_stream_4   = Robot_input_socket_4.getInputStream;
% Robot_output_stream_4   = Robot_input_socket_4.getOutputStream;
% Robot_d_input_stream_4 = DataInputStream(Robot_input_stream_4);
% Robot_d_output_stream_4 = DataOutputStream(Robot_output_stream_4);
%  
% Robot_message_4 = zeros(1,12,'uint8');
% fprintf(1, 'Connected to Robot %d.\n', 4);
