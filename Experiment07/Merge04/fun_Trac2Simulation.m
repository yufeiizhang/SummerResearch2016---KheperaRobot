function output = fun_Trac2Simulation( input )
% There should be something ... 
% 
offset = [ -2.0589 ; 0.5485 ];
input = input + offset;
theta = -0.4342;
R_Trac2Sim = [ cos(theta) , -sin(theta); ...
    sin(theta) , cos(theta) ];
output = R_Trac2Sim * input;
k = 3.371920/100;
output = output ./ k;
output = [ -1 , 0 ; 0 , 1 ] * output;
