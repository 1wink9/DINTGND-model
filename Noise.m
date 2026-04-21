function output = Noise(t,x)

%W = [0;0;0];              % Noise-free.
W = [10;10;10];           % Constant noise
%W = [10*t+10;10*t+10;10*t+10]; % Linear noise
%W = [10*t^2+10*t+10; 10*t^2+10*t+10; 10*t^2+10*t+10];   % Quadratic noise
output = W;

end