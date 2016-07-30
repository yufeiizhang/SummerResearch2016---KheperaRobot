function [ left , right ] = fun_revolution( velocity , omega , length )
% Calculate the revolution of agent

left = velocity + omega * 1 * ( length / 2 );
right = velocity - omega * 1 * ( length / 2 );

end

