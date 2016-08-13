function output = fun_Trac2Simulation( input )
% There should be something ... 
% 
offset = [ 1.374 ; -1.455 ];
input = [0,1;1,0]*input - offset;
theta = -1.5973;
R_Trac2Sim = [ cos(theta) , -sin(theta); ...
    sin(theta) , cos(theta) ];
output = R_Trac2Sim * input;
k = 3.1161/100;
output = output ./ k;
