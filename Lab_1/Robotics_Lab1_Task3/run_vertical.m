clear all; close all; clc
%% set up the enviroment
lim = [-2.0, 2.0, -2.0, 2.0, -2.0, 2.0]; % to define the limit of x,y,z
mdl_puma560     % to load the puma560 robot
p560.plot(qz,'workspace',lim)   % to draw the robot

% to define and to plot a wall 
a = 1;  % the wall is defined as ax+by+cz+d = 0 
b = 0;
c = 0;
d = -1;
wall = Wall(a,b,c,d,lim);  % to define the wall
wall.plotwall();           % to plot the wall

%% place your trajectory generation code here
% 1) An example trajectory can be loaded from the 'q.mat' file

% load q_vertical.mat
% traj=q;

% Letter S
via = [...
  -.05 -0.1    0;...
    0 -0.1    0;...
    0 -0.1  0.1;...
    0    0  0.1;...
    0    0    0;...
    0   .1    0;...
    0   .1   .1]'

% i drew the coordinates referred to a bad axis so i changed it...
via = (via' * rotx(pi/2))'
traj_s = mstraj(via(:,:)', [0.1,0.1,0.1], [], via(:,1)', 0.2, 5);  

% Letter P
via = [...
    0   .25    -0.1;...
    0   .25      0;...
    0   .25   0.1;...
    0   .15    .07;...
    0   .15    .03;...
    0   .25      0;...
    -.05  .25    0;...  
    -.05  0    0.1]' % match end-start points to avoid errors

traj_p = mstraj(via(:,:)', [0.5,0.5,0.5], [], via(:,1)', 0.2, 2);  

% Combine & run
traj = [traj_p; traj_s]

% IF THIS IS NOT COMMENTED THE ROBOT ANIMATION WILL CRASH
% check where i messed up and find how to rotate the figure rather than
% rethinking the coordinates...
% figure(); hold on
% plot3(traj(:,1), traj(:,2), traj(:,3))
% xlabel('this is the x axis')
% ylabel('this is the y axis')
% zlabel('this is the z axis')


%% send to robot
Tp = SE3(0.6, 0, 0) * SE3(traj) * SE3.oa([0 1 0], [1 0 0.1]);
q = p560.ikine6s(Tp);
plot_qtraj(q, wall, p560)