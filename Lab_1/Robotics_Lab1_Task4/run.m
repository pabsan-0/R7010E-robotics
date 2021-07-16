clear all
clc
close all
addpath(genpath('./'));

% map1.txt and map2.txt are the complex enviroments
map = load_map('maps/map2.txt', 0.1, 2, 0.25);
plot_path(map);
grid on
box on
hold on 

%% map1
start  = [-5, 2, 0]
via = [...
    0 2 -1;...
    20 2 -1;...
    22, 2, 0]'
q = mstraj(via(:,[1 2 3])', [2,2,2], [], start, 0.2, 1);  
plot3(q(:,1), q(:,2), q(:,3))


%% map2
start = [5, 1, 0]
% finish = [5, 20, 2]
via = [...
    5 2 2;...
    5 15 4;...
    5 20 2]'    
q = mstraj(via(:,[1 2 3])', [2,2,2], [], start, 0.2, 1);  
plot3(q(:,1), q(:,2), q(:,3))        






