%% Terrain Slope and Aspect Analysis for Larsemann Hills
% Author: [Yibo Li]
% Date: [2025-04-16]
% Description: 
%   Processes slope and aspect data to generate wind rose visualizations
%   and aspect distribution statistics for the Larsemann Hills region.

%% Initialize Environment
clc;
clear;
close all;

%% Data Import and Preprocessing
% Load terrain data
[slope, aspect] = loadTerrainData("Tiff/Slope.tif", "Tiff/Aspect.tif");

%% Aspect Distribution Analysis
% Calculate and display aspect distribution in 90° bins
[aspectPercentages, aspectCounts] = calculateAspectDistribution(aspect);
displayAspectStatistics(aspectPercentages);

%% Wind Rose Visualization
% Configure and generate wind rose plot
outputPath = 'Fig_output';
generateWindRose(aspect, slope, fullfile(outputPath, 'Larsemann.png'));

%% Helper Functions
function [slope, aspect] = loadTerrainData(slopePath, aspectPath)
    % Load and preprocess terrain data
    slope = readgeoraster(slopePath);
    aspect = readgeoraster(aspectPath);
    
    % Clean data (replace -99 with NaN)
    missingValue = -99;
    slope(slope == missingValue) = NaN;
    aspect(aspect == missingValue) = NaN;
    
    % Convert to vectors and remove missing values
    slope = double(slope(:));
    aspect = double(aspect(:));
    validIdx = ~isnan(slope) & ~isnan(aspect);
    slope = slope(validIdx);
    aspect = aspect(validIdx);
end

function [percentages, counts] = calculateAspectDistribution(aspect)
    % Calculate aspect distribution in 90° bins
    aspectBins = discretize(aspect, [0, 90, 180, 270, 360]);
    counts = histcounts(aspectBins, 1:5);
    percentages = counts / sum(counts) * 100;
end

function displayAspectStatistics(percentages)
    % Display aspect distribution statistics
    fprintf('Aspect Distribution (90° bins):\n');
    directions = {'N (0-90°)', 'E (90-180°)', 'S (180-270°)', 'W (270-360°)'};
    for i = 1:4
        fprintf('%s: %.2f%%\n', directions{i}, percentages(i));
    end
end

function generateWindRose(aspect, slope, outputPath)
    % Configure wind rose plot
    options = {
        'nDirections', 12, ...           % Number of directional sectors
        'AngleNorth', 0, ...             % Geographic north orientation
        'AngleEast', 90, ...             % Geographic east orientation
        'labels', {'N (0°)', 'NE (45°)', 'E (90°)', 'SE (135°)', ...
                  'S (180°)', 'SW (225°)', 'W (270°)', 'NW (315°)'}, ...
        'vWinds', [0, 8, 16, 24, 32, 40], ... % Slope categories (degrees)
        'MaxFrequency', 15, ...          % Maximum frequency percentage
        'FreqLabelAngle', 'auto', ...   % Automatic frequency label placement
        'LegendType', 2, ...            % Legend type (2 = detailed)
        'LabLegend', 'Slope (°)', ...   % Legend label
        'LegendVariable', 'Deg', ...
        'axesfontsize', 16, ...         % Axis font size
        'titlestring', '', ...          % Plot title
        'LegendPosition', 'southeast', ...
        'legendfontsize', 14, ...
        'scalefactor', 0.8, ...         % Scaling factor
        'frequencyfontsize', 12, ...
        'gridstyle', '--', ...          % Grid line style
        'gridalpha', 0.4, ...           % Grid transparency
        'CenteredIn0', false
    };
    
    % Generate wind rose plot
    [~, ~, ~, ~, ~] = WindRose(aspect, slope, options);
    
    % Format figure
    set(gca, 'FontName', 'Arial');
    set(gcf, 'Units', 'centimeters', 'Position', [23.9, 5.13, 28.83, 17.3]);
    
    % Export visualization
    export_fig(outputPath, '-png', '-transparent', '-r800');
end