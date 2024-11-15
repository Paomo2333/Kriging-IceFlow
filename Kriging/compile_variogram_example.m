% Example to compile experimental variogram for flowset 

load flowset F1

dh = 50; 
hmax = 800;
[hc1,gam1,n1] = find_vg(F1(:,1),F1(:,2),F1(:,3),dh,hmax);

dh = 100;
hmax = 2000;
[hc2,gam2,n2] = find_vg(F1(:,1),F1(:,2),F1(:,3),dh,hmax);

save results/experimental_variogram_data hc1 gam1 n1 hc2 gam2 n2


