function [ left , right ] = fun_revolution( velocity , omega , length )
% Calculate the revolution of agent

left = velocity + omega * ( pi / 180 ) * ( length / 2 );
right = velocity - omega * ( pi / 180 ) * ( length / 2 );

end

