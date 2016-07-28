function output = fun_Sim2Tracking( input )
% input = | a1 |
%         | a2 |
input=[0 1;1 0]*input;
dx = 3.5673/100;
dz = 3.4834/100;
input(1) = input(1) * dx;
input(2) = input(2) * dz;
R_Sim2Trac = [ 0.5933 , -0.8004; ...
    0.8050 , 0.5995 ];
r01 = [ 0.1960 ; -2.7514 ];
output = r01 + R_Sim2Trac * input;
