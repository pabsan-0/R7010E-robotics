% Defining frames
TA = SE3(0, 0, 0)
TB = SE3(0, 0, 1) * SE3.Ry(pi/2)
TC = SE3(1, 0, 1) * SE3.Ry(-pi)
TD = SE3(1,0,-0.5) * SE3.Ry(pi/2)

% Check everything was properly defined
plotvol([-5 4 -1 5])
trplot(TA, 'framelabel', 'TA')
trplot(TB, 'framelabel', 'TB')
trplot(TC, 'framelabel', 'TC')
trplot(TD, 'framelabel', 'TD')

% Compute subtrajectories
Tab = ctraj(TA, TB, 50);
Tbc = ctraj(TB, TC, 50);
Tcd = ctraj(TC, TD, 50);

% Concatenate trajectories
TT = [Tab Tbc Tcd]

% Plot animation
TT.animate

% Extract & plot trajectory
traj = TT.transl
plot3(traj(:,1), traj(:,2), traj(:,3))





