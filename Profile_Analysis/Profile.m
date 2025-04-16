%% Read data
% Initialize cell array for data reading, set number of files to read
clc;clear;
n = 6;
Line = cell(1,n);
for i = 1:n
    filename = sprintf('Ushape%d.csv',i); % %d is a placeholder to embed i in the filename
    Line{i} = readtable(filename); % Read each table
end

%% Plot preparation
% File path
figure('Units','centimeters','Position',[48.5, -5, 43.9, 26.5])
subplot(3, 2, [1, 2]);

% Plot profile line
% First line
col1 = colorExchange(255,0,30);
Lines = Line{1};
Elevation = table2array(Lines(:,3));
Distance = table2array(Lines(:,2));
x_fill = [Distance; flip(Distance)];
y_fill = [Elevation; zeros(size(Elevation))];
h1 = plot(Distance,Elevation,'Color','k','LineWidth',0.5);
hold on;
ylims = ylim;
h2 = fill(x_fill,y_fill,col1,'FaceAlpha',0.6);
h3 = plot([211.274,211.274],ylims,'b--','LineWidth',1.5);
plot([563.834,563.834],ylims,'b--','LineWidth',1.5);
plot([754.177,754.177],ylims,'b--','LineWidth',1.5);
% Find coordinates of low slope points near two peaks
% First peak area (±50m range)
peak1_pos = 211.2741;
range1_idx = find(Distance >= (peak1_pos - 30) & Distance <= (peak1_pos + 30));
slope1_range = diff(Elevation(range1_idx)) ./ diff(Distance(range1_idx));
[~, min_slope1_idx] = min(abs(slope1_range));
min_slope1_xy = [Distance(range1_idx(min_slope1_idx)), Elevation(range1_idx(min_slope1_idx))];
disp(['First peak low slope point coordinates: (', num2str(min_slope1_xy(1)), ', ', num2str(min_slope1_xy(2)), ')']);
% Second peak area (±50m range)
peak2_pos = 754.177;
range2_idx = find(Distance >= (peak2_pos - 30) & Distance <= (peak2_pos + 30));
slope2_range = diff(Elevation(range2_idx)) ./ diff(Distance(range2_idx));
[~, min_slope2_idx] = min(abs(slope2_range));
min_slope2_xy = [Distance(range2_idx(min_slope2_idx)), Elevation(range2_idx(min_slope2_idx))];
disp(['Second peak low slope point coordinates: (', num2str(min_slope2_xy(1)), ', ', num2str(min_slope2_xy(2)), ')']);
% Use first peak's low slope point elevation as baseline to find 4 points with same elevation between peaks
baseline_elevation = min_slope1_xy(2);

% Find points matching baseline elevation between peaks
range_between_peaks_idx = find(Distance >= min_slope1_xy(1) & Distance <= 602);
elevation_between_peaks = Elevation(range_between_peaks_idx);
distance_between_peaks = Distance(range_between_peaks_idx);
% Find 4 closest points to baseline elevation
[~, closest_idxs] = mink(abs(elevation_between_peaks - baseline_elevation), 4);
closest_xy_coords = [distance_between_peaks(closest_idxs), elevation_between_peaks(closest_idxs)];
% Calculate valley bottom point coordinates
valley_range_idx = find(Distance >= closest_xy_coords(2, 1) & Distance <= closest_xy_coords(4, 1));
[valley_elevation_min, valley_min_idx] = min(Elevation(valley_range_idx));
valley_min_xy = [Distance(valley_range_idx(valley_min_idx)), valley_elevation_min];
% Calculate slope and width
point1 = [closest_xy_coords(1,1),min_slope1_xy(2)];
point2 = [closest_xy_coords(2,1),min_slope1_xy(2)];
point3 = [closest_xy_coords(4,1),min_slope1_xy(2)];
point4 = [closest_xy_coords(3,1),min_slope1_xy(2)];
% Calculate average slope from point1 to peak1 and peak1 to point2
peak1= [peak1_pos,Elevation(324)];
slope_point1_peak1 = (peak1(2) - point1(2)) / (peak1(1) - point1(1));
slope_point1_peak1_deg = atan(slope_point1_peak1) * (180 / pi);
slope_peak1_point2 = (peak1(2) - point2(2)) / (point2(1) - peak1(1));
slope_peak1_point2_deg = atan(slope_peak1_point2) * (180 / pi);
% Calculate distance between point1 and point2 (for plotting)
distance_point1_point2 = abs(point2(1) - point1(1));
disp(['Average slope from point1 to peak1: ', num2str(slope_point1_peak1), ' (', num2str(slope_point1_peak1_deg), '°)']);
disp(['Average slope from peak1 to point2: ', num2str(slope_peak1_point2), ' (', num2str(slope_peak1_point2_deg), '°)']);
disp(['Distance between point1 and point2: ', num2str(distance_point1_point2)]);
% text(mean([point1(1), peak1(1)]), mean([point1(2), peak1(2)]), ['Slope: ', num2str(slope_point1_peak1)], 'FontSize', 10, 'Color', 'b');

% Calculate distance between point2 and point3, average slope from point2 to valley, and valley to peak2
distance_point2_point3 = abs(point3(1) - point2(1));
slope_point2_valley = abs((valley_min_xy(2) - point2(2)) / (valley_min_xy(1) - point2(1)));
slope_point2_valley_deg = atan(slope_point2_valley) * (180 / pi);
slope_valley_peak2 = abs((valley_min_xy(2) - point3(2)) / (point3(1) - valley_min_xy(1)));
slope_valley_peak2_deg = atan(slope_valley_peak2) * (180 / pi);

disp(['Distance between point2 and point3: ', num2str(distance_point2_point3)]);
disp(['Average slope from point2 to valley: ', num2str(slope_point2_valley), ' (', num2str(slope_point2_valley_deg), '°)']);
disp(['Average slope from valley to peak2: ', num2str(slope_valley_peak2), ' (', num2str(slope_valley_peak2_deg), '°)']);

% Calculate average slope from point3 to peak2 and peak2 to point4
peak2= [Distance(863),Elevation(863)];
distance_point3_point4 = abs(point4(1) - point3(1));
slope_point3_peak2 = (peak2(2) - point3(2)) / (peak2(1) - point3(1));
slope_point3_peak2_deg = atan(slope_point3_peak2) * (180 / pi);
slope_peak2_point4 = abs((point4(2) - peak2(2)) / (point4(1) - peak2(1)));
slope_peak2_point4_deg = atan(slope_peak2_point4) * (180 / pi);

disp(['Average slope from point3 to peak2: ', num2str(slope_point3_peak2), ' (', num2str(slope_point3_peak2_deg), '°)']);
disp(['Average slope from peak2 to point4: ', num2str(slope_peak2_point4), ' (', num2str(slope_peak2_point4_deg), '°)']);
disp(['Distance between point3 and point4: ', num2str(distance_point3_point4)]);
% Plot peak1 range
plot([closest_xy_coords(1, 1), closest_xy_coords(2, 1)], [min_slope1_xy(2), min_slope1_xy(2)], 'y-.','LineWidth', 1.8);
plot([closest_xy_coords(3, 1), closest_xy_coords(4, 1)], [min_slope1_xy(2), min_slope1_xy(2)], 'y-.','LineWidth', 1.8);
plot([closest_xy_coords(2, 1), closest_xy_coords(4, 1)], [min_slope1_xy(2), min_slope1_xy(2)], 'g-.','LineWidth', 1.8);


% Set axes properties
a1 = gca;
a1.XLim = [0,max(Distance)];
a1.FontSize = 12;
xlabel('Distance (m)','FontSize',14,'FontWeight','bold');
ylabel('Elevation (m)','FontSize',14,'FontWeight','bold');
title('Line 1','FontSize',16,'FontWeight','bold');
a1.FontName = 'Arial';
grid on;
a1.GridAlpha = 0.2;
a1.TickLength = [0.008 0.008];

% export_fig(path,'Profile1', '-png', '-transparent','-r800');
%%
% Second line

subplot(3, 2, 3);
% Plot profile line
% Second line
col2 = colorExchange(70,169,230);
Lines = Line{2};
Elevation = table2array(Lines(:,3));
Distance = table2array(Lines(:,2));
x_fill = [Distance; flip(Distance)];
y_fill = [Elevation; zeros(size(Elevation))];
h1 = plot(Distance,Elevation,'Color','k','LineWidth',0.5);
hold on;
ylim([20,120]);
ylims = [0,120];
h2 = fill(x_fill,y_fill,col2,'FaceAlpha',0.6);
h3 = plot([183.275,183.275],ylims,'b--','LineWidth',1.5);
plot([580.236,580.236],ylims,'b--','LineWidth',1.5);
plot([748.305,748.305],ylims,'b--','LineWidth',1.5);
plot([917.173,917.173],ylims,'b--','LineWidth',1.5);

% Set axes properties
a1 = gca;
a1.XLim = [0,max(Distance)];
a1.FontSize = 12;
% xlabel('Distance (m)','FontSize',14,'FontWeight','bold');
ylabel('Elevation (m)','FontSize',14,'FontWeight','bold');
title('Line 2','FontSize',16,'FontWeight','bold');
a1.FontName = 'Arial';
grid on;
a1.GridAlpha = 0.2;
a1.TickLength = [0.008 0.008];
%%
% Third line
subplot(3, 2, 4);
% Plot profile line
% Third line
col3 = colorExchange(202,0,101);
Lines = Line{3};
Elevation = table2array(Lines(:,3));
Distance = table2array(Lines(:,2));
x_fill = [Distance; flip(Distance)];
y_fill = [Elevation; zeros(size(Elevation))];
h1 = plot(Distance,Elevation,'Color','k','LineWidth',0.5);
hold on;
xlim([70,max(Distance)]);
ylim([70,140]);
ylims = [70,150];
h2 = fill(x_fill,y_fill,col3,'FaceAlpha',0.5);
h3 = plot([169.369,169.369],ylims,'b--','LineWidth',1.5);
plot([484.625,484.625],ylims,'b--','LineWidth',1.5);
plot([575.555,575.555],ylims,'b--','LineWidth',1.5);
plot([653.495,653.495],ylims,'b--','LineWidth',1.5);
% Set axes properties
a1 = gca;
a1.XLim = [70,max(Distance)];
a1.FontSize = 12;
% xlabel('Distance (m)','FontSize',13,'FontWeight','bold');
% ylabel('Elevation (m)','FontSize',13,'FontWeight','bold');
title('Line 3','FontSize',16,'FontWeight','bold');

a1.FontName = 'Arial';
grid on;
a1.GridAlpha = 0.2;
a1.TickLength = [0.008 0.008];

%%
% Fourth line

subplot(3, 2, 5);
% Plot profile line
% Fourth line
col6 = colorExchange(10,150,0);
Lines = Line{4};
Elevation = table2array(Lines(:,3));
Distance = table2array(Lines(:,2));
x_fill = [Distance; flip(Distance)];
y_fill = [Elevation; zeros(size(Elevation))];
h1 = plot(Distance,Elevation,'Color','k','LineWidth',0.5);
hold on;
ylim([20,120]);
ylims = [0,120];
h2 = fill(x_fill,y_fill,col6,'FaceAlpha',0.5);
h3 = plot([179.843,179.843],ylims,'b--','LineWidth',1.5);
plot([430.017,430.017],ylims,'b--','LineWidth',1.5);
plot([592.867,592.867],ylims,'b--','LineWidth',1.5);
plot([635.35,635.35],ylims,'b--','LineWidth',1.5);

% Set axes properties
a1 = gca;
a1.XLim = [0,max(Distance)];
a1.FontSize = 12;
xlabel('Distance (m)','FontSize',14,'FontWeight','bold');
ylabel('Elevation (m)','FontSize',14,'FontWeight','bold');
title('Line 4','FontSize',16,'FontWeight','bold');
% legend(h1,'Line4');
a1.FontName = 'Arial';
grid on;
a1.GridAlpha = 0.2;
a1.TickLength = [0.008 0.008];

%%
subplot(3, 2, 6);

% Plot profile line
% Fifth line
col6 = colorExchange(197,0,255);
Lines = Line{5};
Elevation = table2array(Lines(:,3));
Distance = table2array(Lines(:,2));
x_fill = [Distance; flip(Distance)];
y_fill = [Elevation; zeros(size(Elevation))];
h1 = plot(Distance,Elevation,'Color','k','LineWidth',0.5);
hold on;
ylim([0,120]);
ylims = [0,120];
h2 = fill(x_fill,y_fill,col6,'FaceAlpha',0.5);
plot([65.2087,65.2087],ylims,'b--','LineWidth',1.5);
plot([518.636,518.636],ylims,'b--','LineWidth',1.5);
plot([856.053,856.053],ylims,'b--','LineWidth',1.5);

% Set axes properties
a1 = gca;
a1.XLim = [0,max(Distance)];
a1.FontSize = 12;
xlabel('Distance (m)','FontSize',14,'FontWeight','bold');
% ylabel('Elevation (m)','FontSize',13,'FontWeight','bold');
title('Line 5','FontSize',16,'FontWeight','bold');
% legend(h1,'Line4');
a1.FontName = 'Arial';
grid on;
a1.GridAlpha = 0.2;
a1.TickLength = [0.008 0.008];
export_fig('Profile', '-png', '-transparent','-r800');