function  yay = live_repulsion(curr_yaw, s, beta, ranges)
    ang = linspace(0, 2*pi, numel(ranges));
    clf
    polarplot(ang, ranges);

    d = ranges;
    theta = ang + curr_yaw;
    
    dx = - beta  * (s-d(:)) .* cos(theta(:)) .*(s>d(:));
    dy = - beta  * (s-d(:)) .* sin(theta(:)) .*(s>d(:));
    
    yay = [sum(dx) sum(dy)]
    
end
