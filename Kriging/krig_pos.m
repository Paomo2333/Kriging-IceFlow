function[theta0k,theta0s,C0k,C0s,Chi0k,Chi0s,N] = krig_pos(x,y,theta,R,x0,y0)

% Use Continuous-Part Kriging (CPK) interpolation to estimate 
% flow direction (theta), convergence (C) and curvature (Chi) at position (x0, y0)
%
% Inputs:
% x, y, theta   observed flow-direction point data of the flowset 
% R             kriging range
% x0, y0        position of interest
%
% Outputs (for position (x0, y0)):
% theta0k       kriged theta estimate 
% theta0s       kriging standard deviation error estimate for theta
% C0k           kriged convergence estimate
% C0s           kriging standard deviation error estimate for C
% Chi0k         kriged curvature estimate
% Chi0s         kriging standard deviation error estimate for Chi
% N             number of observations used (i.e. those inside kriging range)


% (1) set up
global M b vg_params

% variogram nugget
C0 = vg_params(1);
% centre the coordinate system on (x0, y0)
X = x-x0; Y = y-y0;
% incremental distance (1 metre) for computing derivatives
DEL = 0.001;


% (2) kriging

% row numbers of observations within kriging range
rows = find( (X.^2+Y.^2) <= R^2 );
N = length(rows);
if N == 0 
    theta0k = -9999; theta0s = -9999; C0k = -9999; C0s = -9999; Chi0k = -9999; Chi0s = -9999;
    return
end

% (2a) estimate theta at position of interest
krig_sys(X(rows),Y(rows),N,1);
lam0 = M \ b;
% store b in b0 for later use
b0 = b;
% find kriging estimate by Fisher vectorial sum
vx = (lam0(1:N))' * sin(theta(rows));
vy = (lam0(1:N))' * cos(theta(rows));
vL = (vx^2 + vy^2).^0.5;
theta0k = atan2(vx,vy);
% kriging variance on the kriged vector
zv = -lam0(N+1) + (lam0(1:N))' * -(C0 + b(1:N));
% (normalised) standard deviation in the theta estimate
theta0s = atan((zv^0.5)/vL);

% (2b) estimate convergence, using theta at nearby position [x0 y0] + DEL*[-cos(theta0k) sin(theta0k)]
% (Only b is altered; M is unaltered)
krig_sys(X(rows)+DEL*cos(theta0k),Y(rows)-DEL*sin(theta0k),N,0);
lam1 = M \ b;
vx = (lam1(1:N))' * sin(theta(rows));
vy = (lam1(1:N))' * cos(theta(rows));
theta1k = atan2(vx,vy);
% find gradient C = dtheta/dn, taking care of the pi/-pi problem when subtracting angles
C0k = wraptopi(theta1k-theta0k) / DEL;
% kriging variance and (normalised) standard deviation in C estimate
Cv = vg_mod(0,2) - ((lam1(1:N))'-(lam0(1:N))') * (b(1:N)-b0(1:N)) / DEL^2;
C0s = (Cv^0.5)/vL;

% (2b) estimate curvature, using theta at nearby position [x0 y0] + DEL*[sin(theta0k) cos(theta0k)]
% (Only b is altered; M is unaltered)
krig_sys(X(rows)-DEL*sin(theta0k),Y(rows)-DEL*cos(theta0k),N,0);
lam1 = M \ b;
vx = (lam1(1:N))' * sin(theta(rows));
vy = (lam1(1:N))' * cos(theta(rows));
theta1k = atan2(vx,vy);
% find gradient Chi = dtheta/ds, taking care of the pi/-pi problem when subtracting angles
Chi0k = wraptopi(theta1k-theta0k) / DEL;
% kriging variance and (normalised) standard deviation in Chi estimate
Chiv = vg_mod(0,2) - ((lam1(1:N))'-(lam0(1:N))') * (b(1:N)-b0(1:N)) / DEL^2;
Chi0s = (Chiv^0.5)/vL;

