function[hc,gam,Mh] = find_vg(x,y,theta,dh,hmax)

% Compile vectorial semivariogram for a spatial dataset of flow directions
% contained in the vectors x, y, and theta (in radian)
%
% Other inputs define the edges of histogram bins: 
%   dh      distance intervals
%   hmax    maximum distance
%
% Outputs:   hc = centre of the bins in h
%            gam = semivariance in each bin
%            Mh = number of samples in each bin


% (1) set up
h = [0:dh:hmax];
% total number of bins
B = length(h)-1;
hc = h(1:B) + 0.5*dh;
Mh = zeros(1,B); gam = zeros(1,B);

% (2) convert theta into complex number
Z = sin(theta) + i*cos(theta);

% (3) compile vectorial semivariogram
for j = 1:length(Z)
    sv = 0.5 * (abs(Z-Z(j))).^2;
    r = ( (x-x(j)).^2 + (y-y(j)).^2 ).^0.5; 
    binnum = 1 + floor(r/dh);    
    % compile counts and contributions for each (the k-th) bin
    for k = 1:B
        rows = (binnum==k);
        Mh(k) = Mh(k) + sum(rows) - (k==1);  % here, (k==1) avoids counting of the j-th member differenced with itself
        gam(k) = gam(k) + sum(sv(find(rows)));
    end
    %
    if rem(j,10) == 0
        disp([ num2str(j) ' rows have been processed'])
    end
end
disp([ num2str(j) ' rows have been processed'])

gam = sign(Mh) .* gam ./ max(1,Mh);

