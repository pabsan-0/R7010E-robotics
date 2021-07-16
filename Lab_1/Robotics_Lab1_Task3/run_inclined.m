clear all
close all
clc
%% set up the enviroment
lim = [-2.0, 2.0, -2.0, 2.0, -2.0, 2.0]; % to define the limit of x,y,z
mdl_puma560     % to load the puma560 robot
p560.plot(qz,'workspace',lim)   % to draw the robot

% to define and to plot a wall 
a = cos(deg2rad(10));  % the wall is defined as ax+by+cz+d = 0 
b = 0;
c = sin(deg2rad(10));
d = -cos(deg2rad(10));
wall = Wall(a,b,c,d,lim);  % to define the wall
wall.plotwall();           % to plot the wall

%% place your trajectory generation code here
% 1) An example trajectory can be loaded from the 'q.mat' file

% load q_inclined.mat
% traj=q;

% i drew some stuff on a paper and got the angle i need to rotate along the
% Y axis to match this plane with the one in the previous section as...
theta = atan(c/a)

% so this is exactly from the previous part...
via = [...
    0 -0.1    0;...
    0 -0.1  0.1;...
    0    0  0.1;...
    0    0    0;...
    0   .1    0;...
    0   .1   .1]'
via = (via' * rotx(pi/2))'

% and now i fix the plane orientation thing
via = (via' * roty(theta))'
traj = mstraj(via(:,[2 3 4 5 6])', [0.1,0.1,0.1], [], via(:,1)', 0.2, 5);  


%% send to robot
Tp =SE3(0.6, 0, 0) *   SE3(traj) * SE3.oa( [0 1 0], [1 0 0.1]);
q = p560.ikine6s(Tp);
plot_qtraj(q, wall, p560)