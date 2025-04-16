%% Aspect Pie Chart Visualization
% This script draws a pie chart showing aspect (slope direction) distribution.
% Author: [Yibo Li]
% Date: [2025-04-16]
% License: MIT
% Description: Generates a transparent, high-resolution pie chart for use in publications or online sharing.

clear; clc;

%% Data Preparation
% Define count for each aspect quadrant
NW = 25;
NE = 25;
SE = 25;
SW = 25;
total = NW + NE + SE + SW;

% Define colors (converted RGB to [0-1] scale using a custom function)
c1 = colorExchange(195, 37, 51);    % NW
c2 = colorExchange(237, 133, 34);   % SW
c3 = colorExchange(252, 230, 206);  % SE
c4 = colorExchange(94, 158, 206);   % NE
col = {c1, c2, c3, c4};

% Labels and percentages (order matches pie input)
data = [NW, SW, SE, NE];
labels = {'NW', 'SW', 'SE', 'NE'};
percentages = data / total * 100;

%% Plot Pie Chart
figure('Units', 'centimeters', 'Position', [15, 10, 10, 15]);

% Optional explode for emphasis (e.g., [1 0 1 0] to emphasize NW and SE)
explode = [0 0 0 0];
h = pie(data, explode);

% Apply custom colors and transparency to pie patches
hPatch = findobj(h, 'Type', 'Patch');
for i = 1:length(hPatch)
    set(hPatch(i), 'FaceColor', col{i}, 'FaceAlpha', 0.75);
end

% Customize pie chart labels
hText = findobj(h, 'Type', 'text');
for i = 1:length(hText)
    hText(i).String = labels{i};
    hText(i).FontName = 'Arial';
    hText(i).FontSize = 18;
    hText(i).FontWeight = 'bold';
end

% Move labels inside the pie slices
for i = 1:length(hText)
    pos = get(hText(i), 'Position');
    set(hText(i), 'Position', pos * 0.38);
end

%% Export the Figure
export_fig('Fig_output/aspect_pie_legend.png', '-png', '-transparent', '-r800');

