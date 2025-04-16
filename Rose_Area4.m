%% Data Processing and Visualization for Larsemann Hills (Southern Region)
% Author: Yibo Li
% Date: 2024-04-16
% Description: Processes slope and aspect data to create wind rose and aspect distribution charts

%% Initialize Environment
clc; 
clear;
close all;

%% Data Import and Preprocessing
% Load geospatial rasters
slope = readgeoraster("slope\slope_south.tif");
aspect = readgeoraster("Aspect\aspect_south.tif");

% Clean and prepare data
[slope, aspect] = cleanGeodata(slope, aspect);

%% Wind Rose Visualization
% Configure plot options
windRoseOptions = configureWindRose();

% Generate wind rose plot
generateWindRose(aspect, slope, windRoseOptions, ...
                'Fig_output\Larsemann_Area4_Rose.png');

%% Aspect Distribution Analysis
% Create and format aspect pie chart
createAspectPieChart(aspect, 'Fig_output\aspect_pie_chart4.png');

%% Helper Functions
function [slope, aspect] = cleanGeodata(slope, aspect)
    % Clean and prepare geospatial data
    slope(slope == -99) = NaN;
    aspect(aspect == -99) = NaN;
    
    % Convert to vectors and remove NaNs
    slope = double(slope(:));
    aspect = double(aspect(:));
    validIdx = ~isnan(slope) & ~isnan(aspect);
    slope = slope(validIdx);
    aspect = aspect(validIdx);
end

function options = configureWindRose()
    % Configuration for wind rose plot
    options = {
        'nDirections', 12, ...           % Number of directional sectors
        'AngleNorth', 0, ...             % Geographic north orientation
        'AngleEast', 90, ...             % Geographic east orientation
        'labels', {'N (0°)', 'NE (45°)', 'E (90°)', 'SE (135°)', ...
                  'S (180°)', 'SW (225°)', 'W (270°)', 'NW (315°)'}, ...
        'vWinds', [0,8,16,24,32,40], ... % Slope categories (degrees)
        'MaxFrequency', 20, ...          % Maximum frequency percentage
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
end

function generateWindRose(aspect, slope, options, outputPath)
    % Generate and format wind rose plot
    [~, ~, ~, ~, ~] = WindRose(aspect, slope, options);
    
    % Format axes
    set(gca, 'FontName', 'Arial');
    set(gcf, 'Units', 'centimeters', 'Position', [16, 16, 16, 16]);
    
    % Export visualization
    export_fig(outputPath, '-png', '-transparent', '-r800');
end

function createAspectPieChart(aspect, outputPath)
    % Calculate aspect distribution
    aspectBins = [270 360; 180 270; 90 180; 0 90];  % NW, SW, SE, NE
    binCounts = [
        sum((aspect >= aspectBins(1,1)) & (aspect < aspectBins(1,2)));
        sum((aspect >= aspectBins(2,1)) & (aspect < aspectBins(2,2)));
        sum((aspect >= aspectBins(3,1)) & (aspect < aspectBins(3,2)));
        sum((aspect >= aspectBins(4,1)) & (aspect < aspectBins(4,2)))
    ];
    
    % Color scheme (RGB normalized)
    colorPalette = {
        [195 37 51]/255;    % NW - Red
        [237 133 34]/255;   % SW - Orange
        [252 230 206]/255;  % SE - Light yellow
        [94 158 206]/255    % NE - Blue
    };
    
    % Create figure
    figure('Units', 'centimeters', 'Position', [15, 10, 10, 15]);
    
    % Generate pie chart
    h = pie(binCounts, zeros(size(binCounts)));
    
    % Format pie chart
    hPatch = findobj(h, 'Type', 'Patch');
    hText = findobj(h, 'Type', 'text');
    
    percentages = 100 * binCounts / sum(binCounts);
    for i = 1:length(hPatch)
        % Set patch properties
        set(hPatch(i), ...
            'FaceColor', colorPalette{i}, ...
            'FaceAlpha', 0.75, ...
            'EdgeColor', 'w');
        
        % Format percentage labels
        hText(i).String = sprintf('%.1f%%', percentages(i));
        hText(i).FontName = 'Arial';
        hText(i).FontSize = 16;
        hText(i).FontWeight = 'bold';
        hText(i).Position = hText(i).Position * 0.38;
    end
    
    % Export visualization
    export_fig(outputPath, '-png', '-transparent', '-r800');
end