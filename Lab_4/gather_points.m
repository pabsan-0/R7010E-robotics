function returnval = gather_points(curr_x, curr_y, current_yaw, trigger, ranges) 
    %%% use this to retrieve a point cloud for some world
    %%% REMEMBER TO CLEAR THE VARIABLE POINTS=[] before starting!!!
    global points
    figure(1); hold off
    ang = linspace(0, 2*pi, numel(ranges))
    polarplot(ang, ranges)
        
    if trigger ==1
        % Select finite range points & frame them w.r a CF square to axes
        ii_pablo = (0.2 < ranges) & (ranges < 3.4)
        ranges = ranges(ii_pablo)
        ang = ang(ii_pablo) + current_yaw

        % convert to cartesian
        [x_pablo, y_pablo] = pol2cart(ang(:), ranges(:))

        % append/create points
        points = [points; x_pablo(:)+curr_x y_pablo(:)+curr_y]

        % plot
        figure(2); hold off
        scatter(points(:,1), points(:,2))

    end

    returnval = 0
end

