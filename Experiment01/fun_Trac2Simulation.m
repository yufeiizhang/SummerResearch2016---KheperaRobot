function output = fun_Trac2Simulation( input )
% There should be something ... 
% 
dx = 3.5673/100;
dz = 3.4834/100;
R_Trac2Sim = [ 0.5995 , 0.8004; ...
    -0.8050 , 0.5933 ];
r01 = [ 0.1960 ; -2.7514 ];
output = R_Trac2Sim * input - R_Trac2Sim * r01;
output(1) = output(1)/dx;
output(2) = output(2)/dz;
output=[0 1;1 0]*output;
