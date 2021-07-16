close all; clear all; clc
load('Points10.mat') %All
X=X/10; Y=Y/10; Z=Z/10; xyz=[X Y Z]; plot3(X,Y,Z); ylim([-20 20])
grid on; box on; axis equal; hold on

% A few new frames to help with the task..
TH = SE3(0, -5.4, 41); trplot(TH)                               % at the hub
TLB = SE3(-25, -5.4, 27) * SE3.Ry(deg2rad(60)); trplot(TLB)     % left blade tip

% inspecting the tower
ttw = helix(7, 1, 36, 14, 20)   % straightforward with helix motion

% inspecting top blade
ttb = helix(5, 2, 30, 11, 20)   % start from base geometry function
ttb = TH * SE3(ttb)             % move trajectory to desired position
ttb = ttb.transl                % get just the path set of points
ttb = ttb(3:end,:)              % remove risky start/finish

% inspect left blade
tlb = helix(5, 0, 28, 11, 20)
tlb = TLB * SE3(tlb) 
tlb = tlb.transl
tlb = tlb(10:end-7,:) 

% return to safe point to avoid the hub
tsf1 = TH * SE3(-1, -4, 1)
tsf2 = tsf1 * SE3(2, 0, -2)
tsf = [tsf1.transl; tsf2.transl]

% inspect right blade
trb = helix(5, 0, 30, 11, 20)
trb = TH * SE3.Ry(deg2rad(120)) * SE3(trb)
trb = trb.transl
trb = trb(20:end,:)

% assemble and interpolate
t = [ttw; ttb; tlb; tsf; trb]'
t = mstraj(t(:,2:end)', [5,5,5], [], t(:,1)', 0.2, 0.5);  
plot3(t(:,1), t(:,2), t(:,3),'r')



%% me-defined funcs
function coords = hor_circular(diameter, height, npoints)
    %%% Draws a horizontal 3d circle centered at the origin
    
    theta = linspace(0, 2*pi, npoints)
    
    coords = []
    coords(:,1) = diameter/2 * cos(theta)
    coords(:,2) = diameter/2 * sin(theta)
    coords(:,3) = height .* ones(length(theta),1)
end


function coords = helix(diameter, min_height, max_height, nloops, points_per_loop)
    %%% Draws a vertical 3d helix centered at the origin
    
    theta = []
    for i = 1:nloops
        theta = [theta linspace(0, 2*pi, points_per_loop)]
    end
    
    height = linspace(min_height, max_height, points_per_loop*nloops)
    
    coords = []
    coords(:,1) = diameter/2 * cos(theta)
    coords(:,2) = diameter/2 * sin(theta)
    coords(:,3) = height
end


function coords = hor_spiral(diam_start, diam_finish, height, nloops, points_per_loop)
    %%% Draws a horizontal 3d spiral centered at the origin
    
    theta = []
    for i = 1:nloops
        theta = [theta linspace(0, 2*pi, points_per_loop)]
    end
    
    diameter = linspace(diam_start, diam_finish,  points_per_loop*nloops)
    
    coords = []
    coords(:,1) = diameter/2 .* cos(theta)
    coords(:,2) = diameter/2 .* sin(theta)
    coords(:,3) = height .* ones(size(theta))
end