%% -------------------------------------------------------------------------
% Script to process Flowset using Kriging interpolation, Variogram Compilation, 
% Model Autofitting, and Validation.
% The following steps should be modified according to the new flowset and 
% model fit parameters.

% Author: Li Yibo (Sun yat-sen University)
% Email: liyb76@mail2.sysu.edu.cn
% Updated: 2024-11-15
%% -------------------------------------------------------------------------

% (i) DATA PREPARATION ----------------------------------------------------
% ------------------------------------------------------------------------

% *** Step 1: User prepares matrix F and saves it as "flowset.mat" ***
% F has the 5-column structure: [Lineament_ID x_start y_start x_end y_end]

% Generate flow-direction matrix F1 from F and save it to "flowset.mat"
make_flowdir_matrix;

%% ------------------------------------------------------------------------
% (ii) VARIOGRAM COMPILATION ----------------------------------------------
% ------------------------------------------------------------------------

% Step 2: Calculate the experimental variogram data using the command below
compile_variogram_example;

% Step 3: Autofit the model variogram (Equations 1) to the experimental variogram data 
% and plot the results
Model_Autofit;

% *** User can modify the choices of C0, C1, C2, C3, C4, C5 in "Model_Autofit.m" 
% to achieve a different fit or to adapt to another flowset.

pause
close all

%% ------------------------------------------------------------------------
% (iii) KRIGING INTERPOLATION ---------------------------------------------
% ------------------------------------------------------------------------

% Step 4: Kriging interpolation with user-defined parameters: kriging range (R),
% rectangular domain, and spatial resolution.
krig_fs_example;
%% ------------------------------------------------------------------------
% (iv) KRIGING RESULTS VISUALIZATION -------------------------------------
% ------------------------------------------------------------------------
% Load the Kriging results
load results/kriging_results.mat;

% Convert angle values from radians to degrees
krigDeg = rad2deg(theta);
krigDegstd = rad2deg(thetas);

% Create a figure for the visualizations
z0 = figure('Units', 'Inches', 'Position', [8.3, 4, 12.73125, 4.5], ...
            'PaperUnits', 'Inches', 'PaperSize', [6, 4]);

% Subplot 1: Flow Direction Visualization
subplot(1, 2, 1);
imagesc(gx, gy, krigDeg);
colorbar;
ax = gca;
ax.YDir = 'normal';  % Correct Y-axis direction
axis(domain);
clim([-20 150]);  % Set color limits for Flow Direction
title('Flow Direction');

% Subplot 2: Flow Direction Standard Deviation Visualization
subplot(1, 2, 2);
imagesc(gx, gy, krigDegstd);
colorbar;
ax = gca;
ax.YDir = 'normal';  % Correct Y-axis direction
clim([0 20]);  % Set color limits for Flow Direction STD
title('Flow Direction STD');
%% ------------------------------------------------------------------------
% (V) VALIDATION ---------------------------------------------------------
% ------------------------------------------------------------------------

% Step 5: Validate the kriging results by calculating residuals and other metrics.
[residuals, residuals_mean, RMSE, CR] = krig_validation;

% Load the kriging results and variogram parameters
load results/kriging_results vg_params R;

% Save the validation results
save results/validation_results vg_params R residuals residuals_mean RMSE CR;

% Step 6: Visualization and plot residuals with added annotations
C_1 = colorExchange(230, 106, 174);  % Define custom color for residuals plot

% Set figure size and properties
z1 = figure('Units', 'Inches', 'Position', [8.3, 4, 10.3, 4.5], ...
            'PaperUnits', 'Inches', 'PaperSize', [6, 4]);

% Plot residuals using different markers for readability
plot(residuals, '+', 'MarkerSize', 9, 'Color', C_1); 

% Set axis properties
set(gca, 'FontName', 'Arial', 'FontSize', 11);
xlabel('Position ID', 'FontSize', 13, 'FontWeight', 'bold'); 
ylabel('Residuals (°)', 'FontSize', 13, 'FontWeight', 'bold');

% Adjust axis limits and ticks for clarity
axis([0 length(residuals) -23 23]);

% Add a textbox with the mean and RMSE values, with a semi-transparent background
text(40, 20.3, ['Mean = ' num2str(residuals_mean, '%.3f') '; RMSE = ' num2str(RMSE, '%.3f')], ...
     'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [1 1 1 0.5]);

% Add grid lines and adjust appearance for readability
grid on;
set(gca, 'GridColor', [0.5, 0.5, 0.5]);
set(gcf, 'Color', [0.95, 0.95, 0.95]);

% Save the figure as a PNG file
print -dpng results/validation_residuals;

% Pause and clear the workspace
pause;
clear;
close all;
