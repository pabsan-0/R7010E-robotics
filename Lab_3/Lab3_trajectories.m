
%% horizontal square fixed dir
via = [...
    0       0       0.5     0;...
    0.5     0       0.5     0;...
    0.5     0.5     0.5     0;...
    0       0.5     0.5     0;...
    ];

xx = via(:,1)
yy = via(:,2)
zz = via(:,3)
yawyaw = via(:,4)


%% horizontal square looking next waypoint

% Strat: (loop) arrive, stop, adjust orientation, start...
via = [...
    0       0       0.5     0;...
    0.5     0       0.5     0;...    
    0.5     0       0.5     pi/2;...
    0.5     0.5     0.5     pi/2;...
    0.5     0.5     0.5     pi;...
    0       0.5     0.5     pi;...
    0       0.5     0.5     -pi/2;...  
    0       0       0.5     -pi/2;...
    ];

xx = via(:,1)
yy = via(:,2)
zz = via(:,3)
yawyaw = via(:,4)


%% circular reference 1m diameter yaw pointing to center

via = hor_circular(1, 0.5, 20)

xx = via(:,1)
yy = via(:,2)
zz = via(:,3)
yawyaw = pi + atan2(yy, xx)     % by drafting in a paper


%% circular reference 1m diameter tilted

% draw the trajectory, tilt it and then get only the points
via = hor_circular(1, 0, 20)
via = SE3.Rz(deg2rad(45)) * SE3.Rx(deg2rad(45)) * SE3(via)
via = via.transl

% extract each coordinate and fix orientation
xx = via(:,1)
yy = via(:,2)
zz = via(:,3) + 1
yawyaw =  0 .* via(:,1)     
% plot3(xx, yy, zz)             % check if shape is correct



%% me-defined funcs
function coords = hor_circular(diameter, height, npoints)
 %%% Draws a horizontal 3d circle centered at the origin

 theta = linspace(0, 2*pi, npoints)

 coords = []
 coords(:,1) = diameter/2 * cos(theta)
 coords(:,2) = diameter/2 * sin(theta)
 coords(:,3) = height .* ones(length(theta),1)
end

