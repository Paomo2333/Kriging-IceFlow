function[residuals,residuals_mean,RMSE,CR] = krig_validation

% perform cross-validation on the kriging of flow directions for a flowset


global vg_params


% (1) load the kriging results for the flowset, and the kriging range and variogram parameters used to produce them
load results/kriging_results F1 R vg_params
% load('C:\matlab_process\克里金\Flow_larsemann_0320平移法\results\kriging_results.mat')

% (2) cross-validation, by computing the residuals at the observed positions 
L = length(F1(:,1));
for i = 1:L
    % the i-th observation
    x0 = F1(i,1);
    y0 = F1(i,2);
    theta0 = F1(i,3);
    % excluding the i-th observation, krige to estimate theta at its position
    dum = ones(L,1); dum(i) = 0;
    rows = find(dum);
    theta0k = krig_pos(F1(rows,1),F1(rows,2),F1(rows,3),R,x0,y0);
    % residual (as an angle in degrees)
    residuals(i,1) = 180*wraptopi(theta0k-theta0)/pi;
end


% (3) residual statistics
residuals_mean = mean(residuals);
RMSE = sqrt(mean(residuals.^2));

% Are residuals uncorrelated?
% standard error SE
SE = residuals/RMSE;
MAT1 = SE(:,ones(1,L));
MAT2 = MAT1 .* MAT1' .* eye(L);
CR = sum(sum(MAT2)) / (L*(L-1));


