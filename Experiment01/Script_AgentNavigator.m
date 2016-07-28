%%%% robot_1
%rk1_T = [0.1000;0.2000];
%r1_T = [0.0000;0.2000];
rk1 = rk1_T*100;
r1 = r1_T*100;
dist1 = sqrt((r1(1,1)-rk1(1,1))^2 + (r1(2,1)-rk1(2,1))^2);
CoordRot1 = DataSet(counter,5); 
CoordRot1_rad = CoordRot1*pi/180;
RotMatrix1 = [cos(CoordRot1_rad) -sin(CoordRot1_rad);sin(CoordRot1_rad) cos(CoordRot1_rad)];
Trasla1 = r1-rk1;
newxy1 = RotMatrix1*Trasla1;
RobRot1 = atan2(newxy1(1),newxy1(2))*180/pi;
if RobRot1 <= 0
    rot1 = RobRot1*(-1);
else
    rot1 = 360-RobRot1;
end
dist11 = sprintf('%.2f',dist1);
rot11 = sprintf('%.2f',rot1);
if length(dist11) == 4
    dist_1 = ['0',dist11];
else
    dist_1 = dist11;
end
if length(rot11) == 5
    rot_1 = ['00',rot11];
else
    rot_1 = ['0',rot11];
end
send_rot_1 = [rot_1 '00.00'];
send_dist_1 = ['0000.00' dist_1];
send_save = [ send_save ; send_rot_1 , send_dist_1 ];
%send_rot_1 = [ '0150.00' '00.00'];
%send_dist_1 = ['0000.00' '10.00'];

% %%%% robot_2
% rk2 = rk2_T*100;
% r2 = r2_T*100;
% dist2 = sqrt((r2(1,1)-rk2(1,1))^2 + (r2(2,1)-rk2(2,1))^2);
% CoordRot2 = DataSet(counter,11); 
% CoordRot2_rad = CoordRot2*pi/180;
% RotMatrix2 = [cos(CoordRot2_rad) -sin(CoordRot2_rad);sin(CoordRot2_rad) cos(CoordRot2_rad)];
% Trasla2 = r2-rk2;
% newxy2 = RotMatrix2*Trasla2;
% RobRot2 = atan2(newxy2(1),newxy2(2))*180/pi;
% if RobRot2 <= 0
%     rot2 = RobRot2*(-1);
% else
%     rot2 = 360-RobRot2;
% end
% dist22 = sprintf('%.2f',dist2);
% rot22 = sprintf('%.2f',rot2);
% if length(dist22) == 4
%     dist_2 = ['0',dist22];
% else
%     dist_2 = dist22;
% end
% if length(rot22) == 5
%     rot_2 = ['00',rot22];
% else
%     rot_2 = ['0',rot22];
% end
% send_rot_2 = [rot_2 '00.00'];
% send_dist_2 = ['0000.00' dist_2];
% %send_rot_2 = [ '0150.00' '00.00'];
% %send_dist_2 = ['0000.00' '10.00'];
% 
% %%%% robot_3
% rk3 = rk3_T*100;
% r3 = r3_T*100;
% dist3 = sqrt((r3(1,1)-rk3(1,1))^2 + (r3(2,1)-rk3(2,1))^2);
% CoordRot3 = DataSet(counter,17); 
% CoordRot3_rad = CoordRot3*pi/180;
% RotMatrix3 = [cos(CoordRot3_rad) -sin(CoordRot3_rad);sin(CoordRot3_rad) cos(CoordRot3_rad)];
% Trasla3 = r3-rk3;
% newxy3 = RotMatrix3*Trasla3;
% RobRot3 = atan2(newxy3(1),newxy3(2))*180/pi;
% if RobRot3 <= 0
%     rot3 = RobRot3*(-1);
% else
%     rot3 = 360-RobRot3;
% end
% dist33 = sprintf('%.2f',dist3);
% rot33 = sprintf('%.2f',rot3);
% if length(dist33) == 4
%     dist_3 = ['0',dist33];
% else
%     dist_3 = dist33;
% end
% if length(rot33) == 5
%     rot_3 = ['00',rot33];
% else
%     rot_3 = ['0',rot33];
% end
% send_rot_3 = [rot_3 '00.00'];
% send_dist_3 = ['0000.00' dist_3];
% %send_rot_3 = [ '0150.00' '00.00'];
% %send_dist_3 = ['0000.00' '10.00'];
% 
% %%%% robot_4
% rk4 = rk4_T*100;
% r4 = r4_T*100;
% dist4 = sqrt((r4(1,1)-rk4(1,1))^2 + (r4(2,1)-rk4(2,1))^2);
% CoordRot4 = DataSet(counter,23); 
% CoordRot4_rad = CoordRot4*pi/180;
% RotMatrix4 = [cos(CoordRot4_rad) -sin(CoordRot4_rad);sin(CoordRot4_rad) cos(CoordRot4_rad)];
% Trasla4 = r4-rk4;
% newxy4 = RotMatrix4*Trasla4;
% RobRot4 = atan2(newxy4(1),newxy4(2))*180/pi;
% if RobRot4 <= 0
%     rot4 = RobRot4*(-1);
% else
%     rot4 = 360-RobRot4;
% end
% dist44 = sprintf('%.2f',dist4);
% rot44 = sprintf('%.2f',rot4);
% if length(dist44) == 4
%     dist_4 = ['0',dist44];
% else
%     dist_4 = dist44;
% end
% if length(rot44) == 5
%     rot_4 = ['00',rot44];
% else
%     rot_4 = ['0',rot44];
% end
% send_rot_4 = [rot_4 '00.00'];
% send_dist_4 = ['0000.00' dist_4];
% %send_rot_4 = [ '0150.00' '00.00'];
% %send_dist_4 = ['0000.00' '10.00'];

