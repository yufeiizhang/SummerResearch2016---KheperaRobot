function output = fun_Sim2Tracking( input )
k = 3.371920/100;
offset = [ -48.5511 ; -40.4443 ];
theta = -0.4342;
R_Sim2Trac = [ cos(theta) , -sin(theta); ...
    sin(theta) , cos(theta) ];
input = input + offset;
output = R_Sim2Trac * input;
output = output * k;
output = [ -1 , 0 ; 0 , 1 ] * output;
