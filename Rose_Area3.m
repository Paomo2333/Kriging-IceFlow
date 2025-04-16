%% Data Processing and Visualization for Larsemann Hills Area M
% Author: [Yibo Li]
% Date: [20250416]
% Description: Processes slope and aspect data to create wind rose and aspect pie charts

%% Data Import and Preprocessing
clc
clear

% Load geospatial data
slope = readgeoraster("slope\slope_M.tif");
aspect = readgeoraster("Aspect\aspect_M.tif");

% Data cleaning
slope(slope == -99) = NaN;
aspect(aspect == -99) = NaN;
slope = double(slope(:));
aspect = double(aspect(:));

% Remove missing values
valid_idx = ~isnan(slope) & ~isnan(aspect);
slope = slope(valid_idx);
aspect = aspect(valid_idx);

%% Wind Rose Visualization
% Configuration for wind rose plot
plot_options = {
    'nDirections', 12, ...           % Number of directional sectors
    'AngleNorth', 0, ...             % Geographic north orientation
    'AngleEast', 90, ...             % Geographic east orientation
    'labels', {'N (0°)', 'NE (45°)', 'E (90°)', 'SE (135°)', ...
               'S (180°)', 'SW (225°)', 'W (270°)', 'NW (315°)'}, ...
    'vWinds', [0,8,16,24,32,40], ... % Slope categories (degrees)
    'MaxFrequency', 15, ...          % Maximum frequency percentage
    'FreqLabelAngle', 'auto', ...    % Automatic frequency label placement
    'LegendType', 0, ...             % Legend configuration
    'LabLegend', 'Slope (°)', ...
    'LegendVariable', 'Deg', ...
    'axesfontsize', 16, ...
    'titlestring', '', ...
    'LegendPosition', 'southeast', ...
    'legendfontsize', 14, ...
    'scalefactor', 0.8, ...
    'frequencyfontsize', 12, ...
    'gridstyle', '--', ...
    'gridalpha', 0.4, ...
    'CenteredIn0', false
};

% Generate and format wind rose
[fig, count, speeds, directions, stats] = WindRose(aspect, slope, plot_options);
set(gca, 'FontName', 'Arial');
set(gcf, 'Units', 'centimeters', 'Position', [16, 16, 16, 16]);

% Export visualization
export_fig('Fig_output\Larsemann_Area3_Rose.png', '-png', '-transparent', '-r800');

%% Aspect Distribution Pie Chart
% Calculate aspect distribution
aspect_bins = [270 360; 180 270; 90 180; 0 90];  % NW, SW, SE, NE
bin_counts = [
    sum((aspect >= aspect_bins(1,1)) & (aspect < aspect_bins(1,2)));
    sum((aspect >= aspect_bins(2,1)) & (aspect < aspect_bins(2,2)));
    sum((aspect >= aspect_bins(3,1)) & (aspect < aspect_bins(3,2)));
    sum((aspect >= aspect_bins(4,1)) & (aspect < aspect_bins(4,2)))
];

% Color scheme (RGB normalized)
color_palette = {
    [195 37 51]/255;    % NW - Red
    [237 133 34]/255;   % SW - Orange
    [252 230 206]/255;  % SE - Light yellow
    [94 158 206]/255    % NE - Blue
};

% Create and format pie chart
figure('Units', 'centimeters', 'Position', [15, 10, 10, 15]);
h_pie = pie(bin_counts, zeros(size(bin_counts)));

% Apply visual styling
h_text = findobj(h_pie, 'Type', 'text');
h_patch = findobj(h_pie, 'Type', 'patch');

for i = 1:length(bin_counts)
    % Set patch properties
    set(h_patch(i), ...
        'FaceColor', color_palette{i}, ...
        'FaceAlpha', 0.75, ...
        'EdgeColor', 'w');
    
    % Format percentage labels
    percentage = 100*bin_counts(i)/sum(bin_counts);
    h_text(i).String = sprintf('%.1f%%', percentage);
    h_text(i).FontName = 'Arial';
    h_text(i).FontSize = 16;
    h_text(i).FontWeight = 'bold';
    h_text(i).Position = h_text(i).Position * 0.38;  % Adjust label position
end

% Export visualization
export_fig('Fig_output\aspect_pie_chart3.png', '-png', '-transparent', '-r800');