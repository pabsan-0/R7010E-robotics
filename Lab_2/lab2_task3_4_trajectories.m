%% square
square = [...
    1   0   0;...
    1   1   0;...
    0   1   0;...
    0   0   0]
xx = square(:,1)
yy = square(:,2)
tt = square(:,3)
lim = length(xx)


%% letter S
letter_S = [...
    1   0   0;...
    1   1   0;...
    0   1   0;...
    0   2   0;...
    1   2   0;...
    0   0   0]
xx = letter_S(:,1)
yy = letter_S(:,2)
tt = letter_S(:,3)
lim = length(xx)


%% sinusoidal
xx = 0:0.5:2*3.14
yy = sin(0:0.5:2*3.14)
tt = zeros(size(xx))
lim = length(xx) 


%% Following line 1

a = 1
b = -1
c = 1


%% Following line 2

a = 1
b = -2
c = 4
