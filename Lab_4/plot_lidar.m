function a = plot_lidar(control, ranges)
    a = 1;
    if control == 1
        clf
        ang = linspace(0, 2*pi, numel(ranges))
        polarplot(ang, ranges)
    end
end

