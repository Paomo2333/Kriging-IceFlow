function[] = make_flowdir_matrix

% Load matrix F in the datafile "flowset.mat" and make matrix F1 with the column
% structure [ x-midpoint y-midpoint theta ] and append F1 to "flowset.mat".

load flowset F

F1(:,1) = 0.5*(F(:,2)+F(:,4));
F1(:,2) = 0.5*(F(:,3)+F(:,5));
F1(:,3) = atan2(F(:,4)-F(:,2),F(:,5)-F(:,3));

save flowset F1 -append


