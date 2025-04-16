%% Read data
% Read data before georeferencing
clc;clear;

% Dome data
before = readtable("NoDome_before.xls");
lon_before = table2array(before(:, 3));
lat_before = table2array(before(:, 4));
Z_before = table2array(before(:, 5));

% Read GCP data (after georeferencing)
after = readtable("After.xls");
lon_gcp = table2array(after(:, 3));
lat_gcp = table2array(after(:, 2));
z_gcp = table2array(after(:, 4));

%%
% Set UTM projection (WGS84, Zone 43S)
utmProj = projcrs(32743, 'Authority', 'EPSG');  % EPSG:32743 -> UTM Zone 43S, WGS84

% Convert geographic coordinates to UTM43S (Before)
[x_before, y_before] = projfwd(utmProj, lat_before, lon_before);

% Convert geographic coordinates to UTM43S (GCP/After)
[x_gcp, y_gcp] = projfwd(utmProj, lat_gcp, lon_gcp);

%% Calculate residuals
num_points = min(length(lon_before), length(lon_gcp));  % Match number of points

% UTM coordinate horizontal and vertical residuals
horizontal_residual = sqrt((x_before(1:num_points) - x_gcp(1:num_points)).^2 + (y_before(1:num_points) - y_gcp(1:num_points)).^2);
vertical_residual = Z_before(1:num_points) - z_gcp(1:num_points);

% Total residual
total_residual = sqrt(horizontal_residual.^2 + vertical_residual.^2);

%% Create result table
residual_table = table((1:num_points)', horizontal_residual, vertical_residual, total_residual, ...
    'VariableNames', {'Point', 'Horizontal_Residual', 'Vertical_Residual', 'Total_Residual'});

% Display table
disp(residual_table);

%% Calculate statistics
mean_horizontal = mean(horizontal_residual);
max_horizontal = max(horizontal_residual);
mean_vertical = mean(vertical_residual);
max_vertical = max(vertical_residual);
mean_total = mean(total_residual);
max_total = max(total_residual);

%%
% Display statistics
fprintf('Mean Horizontal Residual: %.6f, Max Horizontal Residual: %.6f\n', mean_horizontal, max_horizontal);
fprintf('Mean Vertical Residual: %.4f, Max Vertical Residual: %.4f\n', mean_vertical, max_vertical);
fprintf('Mean Total Residual: %.4f, Max Total Residual: %.4f\n', mean_total, max_total);

%% Calculate horizontal and total residual statistics
% Horizontal residual (XY combined)
horizontal_rmse = sqrt(mean(horizontal_residual.^2));  % 2D plane RMSE
horizontal_std = std(horizontal_residual);

% Total residual (3D)
total_rmse = sqrt(mean(total_residual.^2));
total_std = std(total_residual);

% Display results
fprintf('Horizontal residual (XY combined): RMSE = %.4f m, Std = %.4f m\n', horizontal_rmse, horizontal_std);
fprintf('3D total residual: RMSE = %.4f m, Std = %.4f m\n', total_rmse, total_std);

%% Calculate and display error statistics before and after calibration
% -------------------------------------------------------------------------
% Calculate vertical bias and correct
vertical_bias = mean(vertical_residual);  % Systematic elevation bias
vertical_residual_corrected = vertical_residual - vertical_bias;

% Calculate corrected total residual (horizontal residual remains unchanged)
total_residual_corrected = sqrt(horizontal_residual.^2 + vertical_residual_corrected.^2);

% Calculate key metrics
horizontal_rmse = sqrt(mean(horizontal_residual.^2));         % Horizontal RMSE
total_rmse_original = sqrt(mean(total_residual.^2));          % Original total RMSE
total_rmse_corrected = sqrt(mean(total_residual_corrected.^2)); % Corrected total RMSE

% Console output
disp('===== Error Comparison Before and After Calibration =====');
fprintf('Horizontal residual (XY): RMSE = %.4f m\n', horizontal_rmse);
fprintf('Total residual - Before calibration: RMSE = %.4f m\n', total_rmse_original);
fprintf('Total residual - After calibration: RMSE = %.4f m\n', total_rmse_corrected);
fprintf('Systematic vertical bias: %.4f m\n', vertical_bias);
% -------------------------------------------------------------------------

figure('Color','w', 'Units','centimeters','Position',[20.4,11.3,30.1,12.3]);
t = tiledlayout(1,3,'TileSpacing','tight','Padding','compact');
set(gcf, 'DefaultTextFontName', 'Arial', 'DefaultAxesFontName', 'Arial'); % Set global font

% Initialize statistics storage structure (with new Std field)
stats = struct('Parameter',{}, 'Bias',{}, 'RMSE',{}, 'Std',{}, 'RMSE_corrected',{}, 'R2',{});

datasets = {
    struct(... % UTM X
        'x', x_before, 'y', x_gcp, 'name','UTM X',...
        'title','UTM X Comparison', 'xlabel','X map (m)',...
        'ylabel','X source (m)', 'color',[0 0.4470 0.7410]),...
    struct(... % UTM Y
        'x', y_before, 'y', y_gcp, 'name','UTM Y',...
        'title','UTM Y Comparison', 'xlabel','Y map (m)',...
        'ylabel','Y source (m)', 'color',[0.8500 0.3250 0.0980]),...
    struct(... % Elevation
        'x', Z_before, 'y', z_gcp, 'name','Elevation',...
        'title','Elevation Comparison', 'xlabel','Z map (m)',...
        'ylabel','Z source (m)', 'color',[0.4660 0.6740 0.1880])...
};

for i = 1:3
    nexttile;
    data = datasets{i};
    ax = gca;
    ax.FontSize = 12; % Set main tick label size
    ax.FontName = 'Arial'; % Ensure font is Arial
    
    % Plotting (capture handles)
    hScatter = scatter(data.x, data.y, 60, data.color, 'filled');
    hold on;
    
    % Regression analysis
    [p, S] = polyfit(data.x, data.y, 1);
    x_fit = linspace(min(data.x), max(data.x), 100);
    [y_fit, delta] = polyval(p, x_fit, S);
    hFit = plot(x_fit, y_fit, 'k-', 'LineWidth',1.5);
    hCI = fill([x_fit fliplr(x_fit)], [y_fit+delta fliplr(y_fit-delta)],...
        [0.5 0.5 0.5], 'FaceAlpha',0.3, 'EdgeColor','none');
    
    % Calculate statistics
    errors = data.y - data.x;
    y_pred = polyval(p, data.x);
    R2 = 1 - sum((data.y - y_pred).^2)/sum((data.y - mean(data.y)).^2);
    bias = mean(errors);
    RMSE = sqrt(mean(errors.^2));
    Std = std(errors); % New standard deviation calculation
    
    % Calculate RMSE-corrected only for elevation data
    if i == 3
        errors_corrected = errors - bias;
        RMSE_corrected = sqrt(mean(errors_corrected.^2));
        Std_corrected = std(errors_corrected);
    else
        RMSE_corrected = NaN;
        Std_corrected = NaN;
    end
    
    % Store statistical results
    stats(i).Parameter = data.name;
    stats(i).Bias = round(bias, 5);
    stats(i).RMSE = round(RMSE,5);
    stats(i).Std = round(Std,5); % New Std field
    stats(i).RMSE_corrected = round(RMSE_corrected,5);
    stats(i).R2 = round(R2,5);
    
    % Dynamically generate annotation text
    if i == 3
        textStr = {sprintf('y = %.4fx + %.1f', p(1), p(2)),...
            sprintf('R² = %.3f', R2),...
            sprintf('Bias = %.2f m', bias),...
            sprintf('RMSE = %.2f m', RMSE),...
            sprintf('Std = %.2f m', Std),...
            sprintf('RMSE-c = %.2f m', RMSE_corrected)};
        textYpos = 0.95; % Adjust position for six lines of text
    else
        textStr = {sprintf('y = %.4fx + %.1f', p(1), p(2)),...
            sprintf('R² = %.3f', R2),...
            sprintf('Bias = %.2f m', bias),...
            sprintf('RMSE = %.2f m', RMSE),...
            sprintf('Std = %.2f m', Std)};
        textYpos = 0.95; % Adjust position for five lines of text
    end
    
    % Add statistical annotation
    text(0.05, textYpos, textStr,...
        'Units','normalized', 'FontSize',12,...
        'VerticalAlignment','top',...
        'BackgroundColor',[1 1 1 0.7],...
        'Margin',2);
    
    % Add legend
    legend([hScatter, hFit, hCI],...
        {'Points', 'Regression', '95% CI'},...
        'Location','southeast',...
        'FontSize',12,...
        'Box','on');
    
    % Axis settings
    grid on; axis tight;
    xlabel(data.xlabel, 'FontSize',14);
    ylabel(data.ylabel, 'FontSize',14);
    title(data.title, 'FontSize',14, 'FontWeight','normal');
end

% Convert structure to table and adjust column order
resultTable = struct2table(stats);
resultTable = resultTable(:, {'Parameter','Bias','RMSE','Std','RMSE_corrected','R2'});

% Display table
disp('Georeferencing Accuracy Metrics:');
disp(resultTable);

% Save as Excel file
writetable(resultTable, 'Nodome_accuracy_metrics_with_std.xlsx',...
    'WriteMode','overwrite',...
    'WriteRowNames',false);