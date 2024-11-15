function[] = krig_sys(X,Y,n,option)

% Compile kriging system matrix M and vector b
% option = 0:   compile b only
%        = 1:   compile M and b

global M b


% matrix M
if option > 0
    mx = X(:,ones(1,n)); my = Y(:,ones(1,n)); 
    h = sqrt((mx-mx').^2+(my-my').^2);
    %
    M = zeros(n+1,n+1);
    M(1:n,1:n) = -vg_mod(h,0);
    M(n+1,1:n) = ones(1,n);
    M(1:n,n+1) = ones(n,1);
end

% vector b
b = [ -vg_mod(abs(X+i*Y),1) ; 1];

