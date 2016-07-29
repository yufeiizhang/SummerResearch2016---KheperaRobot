function [ velocity , omega ] = fun_mov2Point( x0 , z0 , xt , zt , iniOri , nowOri , vMulti , wMulti )
% Calculate velocity and omega for agent as an unicycle model
% input x0,z0 is the original location of agents
% input xt,zt is the goal of agents
% input iniOri is the initial orientation of agents
% input nowOri is the Orientation now
% input vMulti and wMulti is the multiplier of velocity and angular
% velocity
% output velocity and omega is the velocity and angular velocity of agents
% p.s. x-axis' orientation is 0, and the coordinate system should be z-o-x
% not a normal x-o-y one.

% velocity
velocity = ( x0 - xt )^2 + ( z0 - zt )^2;
velocity = sqrt( velocity );
velocity = vMulti * velocity;

% Orientation
angle = atan2( zt - z0 , xt - x0 ) * 180 / pi;
omega = angle - ( iniOri + nowOri );
omega = wMulti * omega;

end

