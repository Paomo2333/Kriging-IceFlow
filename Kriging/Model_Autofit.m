% Load Data
% Load the experimental variogram data from a experimental variogram
load('results/experimental_variogram_data.mat');

% Plot Experimental Variogram at Two Scales
% First plot for data near the origin
figure(1);
plot(hc1, gam1, '.r'); hold on; % Plot Fine Example (red)
plot(hc2, gam2, 'xb'); % Plot Coarse Example (blue)
xlabel('h (m)', 'FontSize', 12, 'FontWeight', 'bold'); % x-axis label
ylabel('gam', 'FontSize', 12, 'FontWeight', 'bold'); % y-axis label
axis([0 800 0 0.11]); % Set axis limits for the first plot

% Second plot for the entire scale
figure(2);
plot(hc1, gam1, '.r'); hold on; % Plot Fine Example (red)
plot(hc2, gam2, 'xb'); % Plot Coarse Example (blue)
xlabel('h (m)', 'FontSize', 12, 'FontWeight', 'bold'); % x-axis label
ylabel('gam', 'FontSize', 12, 'FontWeight', 'bold'); % y-axis label
axis([0 2000 0 0.12]); % Set axis limits for the second plot

% Define the Target Function (Variogram Model)
% Define the target function for variogram fitting
targetFunction = @(p, x) p(1) + p(2) * (((x + p(6)).^2 + p(3)^2).^0.5 - p(3)) + p(4) * (1 - exp(-((x + p(6)) / p(5)).^2));

% Initial guess for the model parameters
initialParams = [0.0012, 0.0000063, 0.4, 0.0454, 600, 290];

% Combine the experimental data for fitting
xdata = [hc1 hc2]; % Distance data
ydata = [gam1 gam2]; % Corresponding variogram values

% Fit the Model Using lsqcurvefit
% Set options for the curve fitting algorithm
options = optimoptions('lsqcurvefit', 'Display', 'iter', 'Algorithm', 'trust-region-reflective');

% Perform the curve fitting to estimate model parameters
params = lsqcurvefit(targetFunction, initialParams, xdata, ydata, [], [], options);

% Display the fitted parameters
disp('Fitted parameters:');
disp(params);

% Extract the fitted parameters into individual variables
C0 = params(1); 
C1 = params(2); 
C2 = params(3); 
C3 = params(4); 
C4 = params(5); 
C5 = params(6);
vg_params = [C0 C1 C2 C3 C4 C5];
% Generate model variogram using the fitted parameters
xModel = linspace(0, max(hc2), 1000); % Generate a range of distances
yModel = targetFunction(params, xModel); % Evaluate the model at these distances

% Plot the Fitting Results
% Plot the fitted model for the first figure (near the origin)
figure(1);
plot(xModel, yModel, 'k', 'LineWidth', 2); % Plot the model in black
text(20, 0.10, 'Model curve:');
text(20, 0.09, 'gam = C0 + C1*(((h+C5)^2 + C2^2)^{0.5} - C2) + C3*(1 - exp(-((h+C5)/C4)^2))');
text(20, 0.08, ['C0 = ' num2str(C0) '; C1 = ' num2str(C1) '; C2 = ' num2str(C2) '; C3 = ' num2str(C3) '; C4 = ' num2str(C4) '; C5 = ' num2str(C5)]);
title('VARIOGRAM MANUAL-FITTING RESULTS (Near Origin)');
grid on;

% Plot the fitted model for the second figure (entire scale)
figure(2);
plot(xModel, yModel, 'k', 'LineWidth', 2); % Plot the model in black
text(50, 0.11, 'Model curve:');
text(50, 0.10, 'gam = C0 + C1*(((h+C5)^2 + C2^2)^{0.5} - C2) + C3*(1 - exp(-((h+C5)/C4)^2))');
text(50, 0.09, ['C0 = ' num2str(C0) '; C1 = ' num2str(C1) '; C2 = ' num2str(C2) '; C3 = ' num2str(C3) '; C4 = ' num2str(C4) '; C5 = ' num2str(C5)]);
title('VARIOGRAM MANUAL-FITTING RESULTS (For Entire h-Scale)');
grid on;
save results/model_variogram_parameters C0 C1 C2 C3 C4 C5 vg_params
