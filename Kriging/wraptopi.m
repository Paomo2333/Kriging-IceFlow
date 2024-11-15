function[out] = wraptopi(in);

% wrap angles (in radian) to the interval [-pi,pi]

out = in - 2*pi*(in>pi) + 2*pi*(in<-pi);
