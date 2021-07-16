close all
%%% RUN THE FILE 'house_map.m' TO IMPORT VARIABLE 'points' 

map_p = points
figure();
scatter(points(:,1), points(:,2))

% reduce map noise & weight
map_p2 = round(map_p*5) /5
figure();
scatter(map_p2(:,1), map_p2(:,2))

% build binary grid
xmin = min(map_p2(:,1))
ymin = min(map_p2(:,2))
xmax = max(map_p2(:,1))
ymax = max(map_p2(:,2))

grid = zeros([(xmax-xmin)/0.2 (ymax-ymin)/0.2])

offset = (map_p2 - [xmin ymin]) ./ 0.2 + [1 1];
offset = cast(offset, 'uint8');

for i = 1:length(offset)
    grid(offset(i,2), offset(i,1)) = 1;
end


% heal map holes
% some holes on wall
grid(27, 14) = 1   
grid(26, 13) = 1
for i = 48:52
    grid(i,37) = 1
end
% shelves
for i = 4:7
    grid(51,i) = 1
end
for i = 17:19
    grid(i,10) = 1
end


% Bug w/ animation
figure();
bug = Bug2(grid, 'inflate', 1);
bug.plot()
% 4test
%start = [8,40]; 
%goal = [30,32];

% WAY THERE
start = round(([-3    1] - [xmin ymin]) ./ 0.2 + [1 1]);
goal =  round(([-6.4    0] - [xmin ymin]) ./ 0.2 + [1 1])
waypoints_1 = bug.query(start, goal, 'animate');
bug.display

% WAY BACK
start = round(([-6.4    0] - [xmin ymin]) ./ 0.2 + [1 1]);
goal =  round(([-3    1] - [xmin ymin]) ./ 0.2 + [1 1])
waypoints_2 = bug.query(start, goal, 'animate');
bug.display

%%% POINTS -> 'waypoints'
waypoints = [waypoints_1(2:end); waypoints_2(2:end)]
waypoints = (waypoints - [1 1]).*0.2 + [xmin ymin]
xx = waypoints(:,1)
yy = waypoints(:,2)
tt = zeros(size(xx))
lim = length(xx)

