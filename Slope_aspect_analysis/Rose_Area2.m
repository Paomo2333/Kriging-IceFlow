%% Data Import and Preprocessing
clc; clear;

% Read slope and aspect rasters for Eastern region
slope = readgeoraster("slope\slope_E.tif");
aspect = readgeoraster("Aspect\aspect_E.tif");

% Handle missing values (-99 -> NaN)
slope(slope == -99) = NaN;
aspect(aspect == -99) = NaN;

% Convert to double and vectorize
slope = double(slope(:));
aspect = double(aspect(:));

% Remove NaN values
valid_mask = ~isnan(slope) & ~isnan(aspect);
slope = slope(valid_mask);
aspect = aspect(valid_mask);

%% Wind Rose Plot (Zhongshan Station, Eastern Region)
% Configure wind rose options
options = {
    'nDirections', 12, ...          % Number of sectors
    'AngleNorth', 0, ...            % North direction (0°)
    'AngleEast', 90, ...            % East direction (90°)
    'labels', {'N (0°)', 'NE (45°)', 'E (90°)', 'SE (135°)', ...
               'S (180°)', 'SW (225°)', 'W (270°)', 'NW (315°)'}, ...
    'vWinds', [0,8,16,24,32,40], ... % Slope ranges
    'MaxFrequency', 15, ...          % Maximum frequency
    'FreqLabelAngle', 'auto', ...    % Automatic frequency circle division
    'LegendType', 0, ...             % No legend
    'LabLegend', 'Slope (°)', ...    % Legend label
    'LegendVariable', 'Deg', ...     % Legend variable
    'axesfontsize', 16, ...
    'titlestring', '', ...
    'LegendPosition', 'southeast', ...
    'legendfontsize', 14, ...
    'scalefactor', 0.8, ...          % Scaling factor
    'frequencyfontsize', 12, ...
    'gridstyle', '--', ...           % Grid line style
    'gridalpha', 0.4, ...            % Grid transparency
    'CenteredIn0', false
};

% Generate wind rose plot
[fig, count, speeds, directions, Table] = WindRose(aspect, slope, options);

% Format axes
ax = gca;
ax.FontName = 'Arial';
set(gcf, 'Units', 'centimeters', 'Position', [16, 16, 16, 16]);

% Export figure
export_fig('Fig_output\Larsemann_Area2_Rose.png', '-png', '-transparent', '-r800');

%% Aspect Pie Chart
% Calculate directional proportions
dir_bins = [270 360; 180 270; 90 180; 0 90];  % [NW; SW; SE; NE]
counts = [
    sum((aspect >= dir_bins(1,1)) & (aspect < dir_bins(1,2))),  % NW
    sum((aspect >= dir_bins(2,1)) & (aspect < dir_bins(2,2))),  % SW
    sum((aspect >= dir_bins(3,1)) & (aspect < dir_bins(3,2))),  % SE
    sum((aspect >= dir_bins(4,1)) & (aspect < dir_bins(4,2)))   % NE
];

% Define colors (RGB normalized)
colors = {
    [195 37 51]/255,    % NW - Red
    [237 133 34]/255,   % SW - Orange
    [252 230 206]/255,  % SE - Light yellow
    [94 158 206]/255    % NE - Blue
};

% Create and format pie chart
figure('Units', 'centimeters', 'Position', [15, 10, 10, 15]);
h = pie(counts, zeros(1,4));  % No sector explosion

% Apply styling
hPatch = findobj(h, 'Type', 'Patch');
for i = 1:length(hPatch)
    set(hPatch(i), 'FaceColor', colors{i}, 'FaceAlpha', 0.75, 'EdgeColor', 'w');
end

% Format percentage labels
percentages = counts/sum(counts)*100;
hText = findobj(h, 'Type', 'text');
for i = 1:length(hText)
    hText(i).String = sprintf('%.1f%%', percentages(i));
    hText(i).FontName = 'Arial';
    hText(i).FontSize = 16;
    hText(i).FontWeight = 'bold';
    hText(i).Position = hText(i).Position * 0.38;  % Adjust label position
end

% Export figure
export_fig('Fig_output\aspect_pie_chart2.png', '-png', '-transparent', '-r800');