%% Exercise 7 
% For a tpoly trajectory from 0 to 1 in 50 steps explore the effects of different initial and
% final velocities, both positive and negative. Under what circumstances does the quintic polynomial
% overshoot and why?
fprintf('$ Running exercise 7')

figure(); sgtitle('A bunch of different configurations') 
[s, sd, sdd] = tpoly(0, 1, 50, 0, 0); 
subplot(6, 2, 1); plot(s); title('Position')
subplot(6, 2, 2); plot(sd); ylabel('v=[0,0]'); title('Speed')

[s, sd, sdd] = tpoly(0, 1, 50, 0, 1); 
subplot(6, 2, 3); plot(s)
subplot(6, 2, 4); plot(sd); ylabel('v=[0,1]')

[s, sd, sdd] = tpoly(0, 1, 50, 1, 0); 
subplot(6, 2, 5); plot(s)
subplot(6, 2, 6); plot(sd); ylabel('v=[1,0]')

[s, sd, sdd] = tpoly(0, 1, 50, 0, -1); 
subplot(6, 2, 7); plot(s)
subplot(6, 2, 8); plot(sd); ylabel('v=[0,-1]')

[s, sd, sdd] = tpoly(0, 1, 50, -1, 0); 
subplot(6, 2, 9); plot(s) 
subplot(6, 2, 10); plot(sd);ylabel('v=[-1,0]')

[s, sd, sdd] = tpoly(0, 1, 50, -1, -1); 
subplot(6, 2, 11); plot(s)
subplot(6, 2, 12); plot(sd); ylabel('v=[-1,-1]')


figure(); sgtitle('Testing for overshooting speed limit')
[s, sd, sdd] = tpoly(0, 1, 50, 0, 1); 
subplot(3, 2, 1); plot(s);  title('Position')
subplot(3, 2, 2); plot(sd); ylabel('v=[0,1]'); title('Speed')

[s, sd, sdd] = tpoly(0, 1, 50, 0, 0.1); 
subplot(3, 2, 3); plot(s)
subplot(3, 2, 4); plot(sd); ylabel('v=[0,0.1]')

[s, sd, sdd] = tpoly(0, 1, 50, 0, 0.01); 
subplot(3, 2, 5); plot(s)
subplot(3, 2, 6); plot(sd); ylabel('v=[0,0.01]')


% Position overshooting happens when:
%
% - When either initial or final speeds are negative: because the robot
% starts/finishes its trajectory going backwards. 
%
% - When either inital or final speeds are too high: if the initial speed
% is to high the robot will overpass the destiny and will have to come
% back. If the final speed is too high the robot may need to "take a step"
% back at the beggining so it has enough space to gain the required speeed.


%% Exercise 8 
% For a lspb trajectory from 0 to 1 in 50 steps explore the effects of specifying the velocity
% for the constant velocity segment. What are the minimum and maximum bounds possible?
fprintf('\n$ Running exercise 8\n')

% THIS BOUNDS ONLY WORK FOR THIS SPECIFIC TRAJECTORY 0 1 50
for i = 0.02:0.00001:0.5
    try
        [s,sd,sdd] = lspb(0, 1, 50, i);
        fprintf('lspb starts working at topspeed %d \n', i)
        break
    catch
    end
end

% THIS BOUNDS ONLY WORK FOR THIS SPECIFIC TRAJECTORY 0 1 50
for i = 0.03:0.00001:0.5
    try
        [s,sd,sdd] = lspb(0, 1, 50, i);
    catch
        fprintf('lspb stops working at topspeed %d \n', i-0.00001)
        break
    end
end

% Speed limit configurations. Hardcoded for readability + code economy
[s_low,sd_low,sdd] = lspb(0, 1, 50, 2.041000e-02);
[s_top,sd_top,sdd] = lspb(0, 1, 50, 4.081000e-02);

% some intermediate configuration
[s_avg,sd_avg,sdd] = lspb(0, 1, 50, 3e-02);

figure()
subplot(1,2,1); hold on ; title('Positions')
plot(s_low); plot(s_avg); plot(s_top)
legend('Min speed','Avg speed','Top speed')

subplot(1,2,2); hold on; title('Speeds')
plot(sd_low); plot(sd_avg); plot(sd_top)
legend('Min speed','Avg speed','Top speed')


% The specified velocity sets how high the acceleration is allowed to be:
%
% - Going at the same speed the whole time sets the minimum possible speed
% for the algorithm (~infinite acceleration at start and finish).
%
% - Reaching top speed just for a moment then having to decrease sets the
% maximum possible speed for the algorithm (~minimum possible acceleration).


%% Exercise 9 
% For a trajectory from 0 to 1 and given a maximum possible velocity of 0.025 compare
% how many time steps are required for each of the tpoly and lspb trajectories?
speed = 0.025


% TPOLY: run for multiple steps and check which ones broke max speed


% skiping 1&2 because i found singularities
i0 = 3 
godspeed = [99 99]  
for i = i0:1:200
    [~, sd, ~] = tpoly(0, 1, i, 0, 0);
    godspeed = [godspeed max(sd)];
end

working_steps = godspeed <= speed;
a = find(working_steps)
fprintf('1: Poly works for more than %d\n', a(1))

figure(); plot(working_steps)
title('Poly timesteps that will not surpass the max speed')
xlabel('timesteps')


% LSPB: try at which numbers it starts and stops working
for i = 1:1:100
    try
        [~,sd_low,~] = lspb(0, 1, i, speed);
        fprintf('2: lspb starts working at %d steps \n', i)
        break
    catch
    end
end

for i = i:1:100
    try
        [~,sd_top,~] = lspb(0, 1, i, speed);
    catch
        fprintf('3: lspb stops working at %d steps \n', i-1)
        break
    end
end

figure(); hold on
plot(sd_low); plot(sd_top);
legend('min timesteps','max timesteps')
title('lspb speeds for max and min allowed timesteps')
xlabel('timesteps')


% Poly trajectory needs a minimum of 2 points or a warning will pop. A
% trajectory of 1 point only doesnt make sense anyway. To reach the
% destination withot surpassing max speed it also needs a minimum of time
% steps. The higher the max speed the less timesteps it allows, because
% higher speeds require less time to reach the target.
% 
% Lspb has both upper and lower bounds for timesteps. The minimum
% allowed number of timesteps matches the required time for reaching the
% destination at constant max speed. The maximum allowed number of
% timesteps happens when there is so much time available the robot cannot
% (doesnt need to) reach the maximum speed at all.



%% Exercise 13 
% For the mstraj example
% a) Repeat with different initial and final velocity. 
% b) Investigate the effect of increasing the acceleration time. Plot total time as a function of acceleration time

% q0 = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 0);  
%      mstraj(vector with points,
%           max axis speed, 
%           duration of segment,
%           initial configuration (pos),
%           sample time step, 
%           acceleration time) % smoothen with this - harder to compute

via = SO2(30, 'deg') * [-1 1; 1 1; 1 -1; -1 -1]';
q0 = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 0); 

figure();
% XY plot for different speeds & different accel. times 
q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 0.5, [1 0], [0 1]); 
subplot(3,2,1); plot(q(:,1), q(:,2)); title('Accel time 0.5'); ylabel('speeds 10 01')
q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 4, [1 0], [0 1]); 
subplot(3,2,2); plot(q(:,1), q(:,2)); title('Accel time 4')

q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 0.5, [0 -1], [0 -1]); 
subplot(3,2,3); plot(q(:,1), q(:,2)); ylabel('speeds 0-1 0-1')
q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 4, [0 -1], [0 -1]); 
subplot(3,2,4); plot(q(:,1), q(:,2))

q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 0.5, [-1 -1], [1 -1]); 
subplot(3,2,5); plot(q(:,1), q(:,2)); ylabel('speeds -1-1 1-1')
q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 4, [-1 -1], [1 -1]); 
subplot(3,2,6); plot(q(:,1), q(:,2))


% tX plot for different speeds & different accel. times 
figure(); hold on
q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 0.5, [1 0], [0 1]); 
subplot(3,2,1); plot(q); title('Accel time 0.5'); ylabel('speeds 10 01')
q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 4, [1 0], [0 1]); 
subplot(3,2,2); plot(q); title('Accel time 4')

q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 0.5, [0 -1], [0 -1]); 
subplot(3,2,3); plot(q); ylabel('speeds 0-1 0-1')
q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 4, [0 -1], [0 -1]); 
subplot(3,2,4); plot(q)

q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 0.5, [-1 -1], [1 -1]); 
subplot(3,2,5); plot(q); ylabel('speeds -1-1 1-1')
q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 4, [-1 -1], [1 -1]); 
subplot(3,2,6); plot(q)

% total time vs acceleration time
times = []
timestep = 0.2
for i = 0:0.5:20
    q = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', timestep, i); 
    times = [times numrows(q)*timestep];
end
figure();
stem(0:0.5:20, times)
xlabel('Acceleration time')
ylabel('Elapsed time')



% Changing the initial speeds may force the robot to start moving in a
% incorrect direction, thus creating the need for a path correction and
% consuming extra time. Same for final speed if its direction doesnt match.
% If it does, the trajectory may be faster because the robot does not have
% to slow down.
%
% Increasing the acceleration time the robot makes use of more time for
% drifting smoothly from one trajectory to the other, thus taking more
% time to reach its destination. The elapsed time grows linearly with the 
% acceleration time.


