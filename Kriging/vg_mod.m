function[out] = vg_mod(h,option)

% Evaluate LINEAR + GAUSSIAN variogram model function to return:
%
% option = 0        gamma(h), which is discontinuous at the origin
%        = 1        gamma_c(h) + C0 (continuous at the origin)
%        = 2        the second derivative d^2(gamma_c)/dh^2 at h = 0
%
% The model function here is sum of LINEAR (with a substitution to modify behaviour near the origin) and GAUSSIAN
%       H = (h.^2+C2^2).^0.5 - C2;
%       gamma_c(h) = C1*H + C3*(1-exp(-(h/C4)^2));


global vg_params
C0 = vg_params(1); C1 = vg_params(2); C2 = vg_params(3); C3 = vg_params(4); C4 = vg_params(5); C5 = vg_params(6);
h = h+C5;% 由于平移，h要加一个值
if option == 0
    H = (h.^2+C2^2).^0.5 - C2;
    out = C0 + C1*H + C3*(1-exp(-(h/C4).^2)) - C0*eye(length(h(:,1)));    
elseif option == 1
    H = (h.^2+C2^2).^0.5 - C2;
    out = C0 + C1*H + C3*(1-exp(-(h/C4).^2));
elseif option == 2
    out = C1/C2 + 2*C3/(C4^2); 
end
     

