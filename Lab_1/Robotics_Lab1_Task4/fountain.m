close all
clear all
clc
%%
ptCloud = pcread('fountain.ply');
pointscolor = uint8(zeros(ptCloud.Count,3));
pointscolor(:,1) = 100;
pointscolor(:,2) = 100;
pointscolor(:,3) = 255;
ptCloud.Color = pointscolor;
pcshow(ptCloud);

hold on
xlabel('X'); ylabel('Y'); zlabel('Z')

% stage 1 constant height
t1 = hor_spiral(21, 10, 2, 5, 20)

% stage 2 upwards inspection
t2 = helix(10, 2, 18, 8, 20)

% stage 3 inspect the top
t3 = hor_spiral(10, 1, 18, 2, 20)

% smoothing & plotting
t = [t1; t2; t3]'
t = mstraj(t(:,2:end)', [5,5,5], [], t(:,1)', 0.2, 0.5);  
plot3(t(:,1), t(:,2), t(:,3))




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