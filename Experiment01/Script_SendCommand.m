steps = 601;
i=1;
while i < steps
    fprintf('step: %d\n', i);
    if i < 271
        Robot_d_output_stream_1.writeBytes(char(send_rot_1));
%         Robot_d_output_stream_2.writeBytes(char(send_rot_1));
%         Robot_d_output_stream_3.writeBytes(char(send_rot_1));
%         Robot_d_output_stream_4.writeBytes(char(send_rot_1));
    elseif i == 271
        Robot_d_output_stream_1.writeBytes(char(send_rot_1));
%         Robot_d_output_stream_2.writeBytes(char(send_rot_1));
%         Robot_d_output_stream_3.writeBytes(char(send_rot_1));
%         Robot_d_output_stream_4.writeBytes(char('0000.0000.00'));
    elseif i < 500
        Robot_d_output_stream_1.writeBytes(char(send_rot_1));
%         Robot_d_output_stream_2.writeBytes(char(send_rot_1));
%         Robot_d_output_stream_3.writeBytes(char(send_rot_1));
%         %Robot_d_output_stream_4.writeBytes(char(send_dist_4));
    elseif i < 600
        Robot_d_output_stream_1.writeBytes(char(send_dist_1));
%         Robot_d_output_stream_2.writeBytes(char(send_dist_1));
%         Robot_d_output_stream_3.writeBytes(char(send_dist_1));
%         Robot_d_output_stream_4.writeBytes(char(send_dist_1));
    else
        Robot_d_output_stream_1.writeBytes(char('0000.0000.00'));
%         Robot_d_output_stream_2.writeBytes(char('0000.0000.00'));
%         Robot_d_output_stream_3.writeBytes(char('0000.0000.00'));
%         Robot_d_output_stream_4.writeBytes(char('0000.0000.00'));
    end

    
    Robot_d_output_stream_1.flush;
%     Robot_d_output_stream_2.flush;
%     Robot_d_output_stream_3.flush;
%     Robot_d_output_stream_4.flush;
%     disp('new position sent');
    i = i + 1;
end
    disp('new position sent');
