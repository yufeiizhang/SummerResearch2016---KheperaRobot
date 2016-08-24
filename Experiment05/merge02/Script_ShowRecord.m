% Show Data Record
sizeofvalues = size(Values);
% scatter3(r1_s(1,:),r1_s(2,:),Values(3:sizeofvalues(1),1),'.','R');
plot3(r1_s(1,:),r1_s(2,:),Values(3:sizeofvalues(1),1),'R');
hold on;
grid on;
% scatter3(r2_s(1,:),r2_s(2,:),Values(3:sizeofvalues(1),2),'.','G');
plot3(r2_s(1,:),r2_s(2,:),Values(3:sizeofvalues(1),2),'G');
% scatter3(r3_s(1,:),r3_s(2,:),Values(3:sizeofvalues(1),3),'.','B');
plot3(r3_s(1,:),r3_s(2,:),Values(3:sizeofvalues(1),3),'Y');
% scatter3(r4_s(1,:),r4_s(2,:),Values(3:sizeofvalues(1),4),'.','Y');
plot3(r4_s(1,:),r4_s(2,:),Values(3:sizeofvalues(1),4),'B');