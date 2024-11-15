function[] = krig_domain(F1,F,R,domain,dx,dy)


% Given a flowset, krig-estimate its flow-direction field, convergence field and curvature field across a specified rectangular domain
%
% Inputs:
% F1            input flowset (matrix of lineament mid-point positions and flow direction)
% R             kriging range
% domain        grid-axis ranges of rectangular domain: [xmin xmax ymin ymax]
% dx, dy        grid spacing in x and y directions
%
% Outputs:
% gx, gy        vectors containing the grid-x and grid-y axes
% theta         kriged flow direction field
% thetas        kriging standard deviation error estimate for theta
% C             kriged convergence field
% Cs            kriging standard deviation error estimate for C 
% Chi           kriged curvature field
% Chis          kriging standard deviation error estimate for Chi 
% N             matrix of no. of observations used in the kriging



% (1) define grid axes
gx = [domain(1) : dx : domain(2)];
gy = [domain(3) : dy : domain(4)];
% pre-allocate empty output matrices
Z = zeros(length(gy),length(gx)); theta = Z; thetas = Z; C = Z; Cs = Z; Chi = Z; Chis = Z; N = Z;


% (2) load variogram model parameters
global vg_params
load results/model_variogram_parameters vg_params


% (3) find kriged estimates at each grid position
for j = 1:length(gx)
    for i = 1:length(gy)
        [theta0k,theta0s,C0k,C0s,Chi0k,Chi0s,N0] = krig_pos(F1(:,1),F1(:,2),F1(:,3),R,gx(j),gy(i));
        %
        theta(i,j) = theta0k;
        thetas(i,j) = theta0s;
        C(i,j) = C0k;
        Cs(i,j) = C0s;        
        Chi(i,j) = Chi0k;
        Chis(i,j) = Chi0s;
        N(i,j) = N0;
    end
    % display number of columns that have been processed
    disp([ num2str(j) ' columns of the domain grid have been processed'])
    pause(0.001)
    dlmwrite('results/krig_domain_progress.txt',j);
end


% (4) saving the results
save results/kriging_results gx gy theta thetas C Cs Chi Chis N vg_params F1 F R domain dx dy


