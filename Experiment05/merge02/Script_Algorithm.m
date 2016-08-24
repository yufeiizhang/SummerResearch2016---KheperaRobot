%% Script_Algorithm

%% Position
r1_T=[DataSet(counter,1); DataSet(counter,3)];
r2_T=[DataSet(counter,1+6); DataSet(counter,3+6)];
r3_T=[DataSet(counter,1+12); DataSet(counter,3+12)];
r4_T=[DataSet(counter,1+18); DataSet(counter,3+18)];
r1=fun_Trac2Simulation(r1_T);
r2=fun_Trac2Simulation(r2_T);
r3=fun_Trac2Simulation(r3_T);
r4=fun_Trac2Simulation(r4_T);
rc=[((r1(1)+r2(1)+r3(1)+r4(1))/4); ((r1(2)+r2(2)+r3(2)+r4(2))/4)];
%store previous formation center position
rk1_T=[DataSet(counter-1,1); DataSet(counter-1,3)];
% rk1_S = [ rk1_S ; rk1_T ];
rk2_T=[DataSet(counter-1,1+6); DataSet(counter-1,3+6)];
rk3_T=[DataSet(counter-1,1+12); DataSet(counter-1,3+12)];
rk4_T=[DataSet(counter-1,1+18); DataSet(counter-1,3+18)];
rk1=fun_Trac2Simulation(rk1_T);
rk2=fun_Trac2Simulation(rk2_T);
rk3=fun_Trac2Simulation(rk3_T);
rk4=fun_Trac2Simulation(rk4_T);
rck1=[((rk1(1)+rk2(1)+rk3(1)+rk4(1))/4); ((rk1(2)+rk2(2)+rk3(2)+rk4(2))/4)];


%% start running
uk=u;
if counter <= 600
    u=DiscreMovie(:,:,700+counter)';
else
    u=u;
end
clear x y
if isnan(s.x)
    % initialize state estimate
    x=rc(1);
    y=rc(2);
    % px = (u(x+1,y)-u(x,y))/2;
    % px= (fun_inter(rc(1)+1,rc(2),u)-fun_inter(rc(1),rc(2),u))/2;
    px = (Values(counter,4) - Values(counter,2))/2;
    % py= (fun_inter(rc(1),rc(2)+1,u)-fun_inter(rc(1),rc(2),u))/2;
    py = (Values(counter,1) - Values(counter,3))/2;
    % py = (u(x,y+1)-u(x,y))/2;
    % R=fun_inter(rc(1),rc(2),u);
    R = mean(Values(counter,:));
    % Rk=fun_inter(rck1(1),rck1(2),u);
    Rk = mean(Values(counter-1,:));
    s.x = [R;px;py;5;Rk;px;py;];
end
if isnan(s.P) %initialise error covariance matrix
    s.P = 0;
end


% ptrue=[fun_inter(r1(1),r1(2),u) ;
%     fun_inter(r2(1),r2(2),u) ;
%     fun_inter(r3(1),r3(2),u);
%     fun_inter(r4(1),r4(2),u) ;
%     fun_inter(rk1(1),rk1(2),uk) ;
%     fun_inter(rk2(1),rk2(2),uk) ;
%     fun_inter(rk3(1),rk3(2),uk) ;
%     fun_inter(rk4(1),rk4(2),uk)] ;
%measurement vector
% noise=0;
% p=[fun_inter(r1(1),r1(2),u) + R*noise*randn;
%     fun_inter(r2(1),r2(2),u) + R*noise*randn;
%     fun_inter(r3(1),r3(2),u) + R*noise*randn;
%     fun_inter(r4(1),r4(2),u) + R*noise*randn;
%     fun_inter(rk1(1),rk1(2),uk) + R*noise*randn;
%     fun_inter(rk2(1),rk2(2),uk) + R*noise*randn;
%     fun_inter(rk3(1),rk3(2),uk) + R*noise*randn;
%     fun_inter(rk4(1),rk4(2),uk) + R*noise*randn];
p = [ Values(counter,:)' ; Values(counter-1,:)' ];

%% Estimate Laplacian
% Laplacian=(1/((r1(2)+r2(1)-r3(2)-r4(1))/4)^2)*(fun_inter(r4(1),r4(2),uk)+fun_inter(r3(1),r3(2),uk)+fun_inter(r2(1),r2(2),uk)+fun_inter(r1(1),r1(2),uk)-4*fun_inter(rc(1),rc(2),uk));
Laplacian_f=(1/((r1(2)+r2(1)-r3(2)-r4(1))/4)^2)*...
    ((sum(Values(counter-1,:)))-s.x(5,1));
%% Call cooperative Kalman filter
s=fun_kalmanf3(s,p,r1,r2,r3,r4,rc,rk1,rk2,rk3,rk4,rck1,Laplacian_f);
s.x;  %information state
s.P; %error covariance matrix

%calculate dz/dt

%
% Laplacian=(1/((r1(2)+r2(1)-r3(2)-r4(1))/4)^2)*(fun_inter(r4(1),r4(2),uk)+fun_inter(r3(1),r3(2),uk)+fun_inter(r2(1),r2(2),uk)+fun_inter(r1(1),r1(2),uk)-4*fun_inter(rc(1),rc(2),uk));
Laplacian=(1/((r1(2)+r2(1)-r3(2)-r4(1))/4)^2)*...
    ((sum(Values(counter,:)))-s.x(5,1));
%store field value at center
%z=(A1-A2)/dt;
error2=(s.x(1,1)-s.x(5,1))/dt;
errorzong2=[errorzong2;error2];
Laplacianzong=[Laplacianzong,Laplacian];
%H=(1/1^2)*(fun_inter(r4(1),r4(2),u)+fun_inter(r3(1),r3(2),u)+fun_inter(r2(1),r2(2),u)+fun_inter(r1(1),r1(2),u)-4*fun_inter(rc(1),rc(2),u));

%% Motion Control
grad=1*[s.x(2,1);s.x(3,1)]/norm([s.x(2,1);s.x(3,1)]);
set(0,'DefaultAxesFontSize',30);



rc = rc + 1.5*dt*grad;

%Formation Control
[r1,r2,r3,r4] = fun_jacobi(r1_d,r2_d,r3_d,r4_d,rc);

%% UPDATE FIGURE
plot(67,48,'kx',rc(1),rc(2),'co',r1(1),r1(2),'g*',r2(1),r2(2),'b*',r3(1),r3(2),'k*',r4(1),r4(2),'r*','MarkerSize',10,'MarkerFaceColor','b')

rm(:,counter)=rc;
for t=1:5:counter
    hold on
    plot(rm(1,t),rm(2,t),'o','MarkerSize',1.5,'MarkerFaceColor','b')
end
contour(u')
figure_FontSize=30;
set(gca,'ydir','normal')
set(gcf,'Color',[1,1,1])
axis([0 99 0 99])
xlabel('x','FontSize',FS1,'FontWeight','bold')
ylabel('y','FontSize',FS1,'FontWeight','bold')
set(gca,'FontSize',FS2,'FontWeight','bold')
set(findobj('FontSize',24),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
colorbar
pause(eps)
hold off
drawnow
MovieRecord(acounter) = getframe;

% save
r1_s = [ r1_s , r1 ];
r2_s = [ r2_s , r2 ];
r3_s = [ r3_s , r3 ];
r4_s = [ r4_s , r4 ];
r1234 = [ r1 , r2 , r3 , r4]
%
r1_T=fun_Sim2Tracking(r1);
r2_T=fun_Sim2Tracking(r2);
r3_T=fun_Sim2Tracking(r3);
r4_T=fun_Sim2Tracking(r4);

%% Interface.!
xTar = [r1_T(1),r2_T(1),r3_T(1),r4_T(1)];
zTar = [r1_T(2),r2_T(2),r3_T(2),r4_T(2)];

%% RLS

%% Initialise
if isnan(r.x)
    r.x=K;
    r.P=4;
end

r = fun_RLS1 (r,error2,Laplacian);
K=r.x;

if K<0.05
    K=0.05;
end
s.x(4,1)=K;

zongRLS=[zongRLS;K];
