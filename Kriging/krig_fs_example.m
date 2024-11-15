% Example: Kriging across the domain of flowset , using the input data matrix F1 in "flowset.mat", 
%       the model variogram in "vg_mod.m" (after its fitting was done in "variogram_model_manualfit_example.m)
%       and the kriging range R, across a rectangular domain and at horizontal resolution dx and dy.
%       R, domain, dx and dy are specified by the user.


% load flowset data
load flowset

% SET KRIGING RANGE HERE:
R = 2000;   % chosen based on the approximate location of the "sill" of the experimental variogram 

% DEFINE THE x-y RANGES AND RESOLUTION OF THE GRIDDED DOMAIN HERE:
domain = [549500 556500 2298640 2304300];
dx = 20;
dy = 20;

% kriging interpolation across the domain (including saving the results)
krig_domain(F1,F,R,domain,dx,dy);

