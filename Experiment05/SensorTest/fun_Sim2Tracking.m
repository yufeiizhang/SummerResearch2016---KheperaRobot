function output = fun_Sim2Tracking( input )
% input = | a1 |
%         | a2 |
k = 3.1161/100;
input = k .* input;
theta = 1.5973;
R_Sim2Trac = [ cos(theta) , -sin(theta); ...
    sin(theta) , cos(theta) ];
offset = [ 1.374 ; -1.455 ];
output = R_Sim2Trac * input + offset; 
output = [ 0 , 1 ; 1 , 0 ] * output;