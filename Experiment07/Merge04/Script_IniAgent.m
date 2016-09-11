dx=36/100; dy=36/100; dt=.05;
% x=0:dx:3.6-3.6/100; y=0:dy:3.6-3.6/100;
% lx=length(x);
% ly=length(y);

clear s
s.x = nan;
s.P = nan;
clear r
r.x=nan;
r.P=nan;

r1=[DataSet(2,3); DataSet(2,1)];
r2=[DataSet(2,3+6); DataSet(2,1+6)];
r3=[DataSet(2,3+12); DataSet(2,1+12)];
r4=[DataSet(2,3+18); DataSet(2,1+18)];
rc=[((r1(1)+r2(1)+r3(1)+r4(1))/4); ((r1(2)+r2(2)+r3(2)+r4(2))/4)];

% errorzong1=[];
errorsum2=[];
estzong=[];
estimate=[];
RLS_all=[];
Laplaciansum=[];
FS1=24;FS2=24;
max=2000;
rm=zeros(2,max);
s.H=0.01*[1 1 1 1 1 1 1 1]';
rck1=rc;
rk1=r1;
rk2=r2;
rk3=r3;
rk4=r4;
z1=0;
H=0;
% u=DiscreMovie(:,:,750)';
z=nan;
wait=1;
K=2;
ang=0;
Lapstack=[];

