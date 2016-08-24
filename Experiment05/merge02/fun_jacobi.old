function [r1,r2,r3,r4] = fun_jacobi(r1,r2,r3,r4,rc)

K1=.01;
dt=.1;

q1=(1/sqrt(2))*(r1-r3);
q2=(1/sqrt(2))*(r2-r4);
q3=0.5*(r1+r3-r2-r4);

trans=[1/4 1/4 1/4 1/4;
       1/sqrt(2) 0 -1/sqrt(2) 0;
       0 1/sqrt(2) 0 -1/sqrt(2);
      1/2 -1/2 1/2 -1/2];
    
coe = 1.0;
  
q10=coe.*[1;0];
q20=coe.*[0;1];
q30=coe.*[0; 0];

u1=-K1*(q1-q10);
u2=-K1*(q2-q20);
u3=-K1*(q3-q30);

q1=q1+dt*u1;
q2=q2+dt*u2;
q3=q3+dt*u3;

 a=[rc,q1,q2,q3]*inv(transpose(trans));
 r1=a(:,1);
 r2=a(:,2);
 r3=a(:,3);
 r4=a(:,4);
end
