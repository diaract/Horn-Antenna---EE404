clear; close all; clc;

%% File names
s11_file   = 's11.csv';
vswr_file  = 'vswr.csv';
smith_file = 'smith.csv';

Z0 = 50;   % Characteristic impedance in ohms

%% Read S11 data
s11_data = readmatrix(s11_file, 'NumHeaderLines', 2);
s11_data = s11_data(:, 1:2);   % Keep only useful columns

f_s11 = s11_data(:,1);         % Frequency in Hz
S11_dB = s11_data(:,2);        % S11 in dB

%% Read VSWR data
vswr_data = readmatrix(vswr_file, 'NumHeaderLines', 2);
vswr_data = vswr_data(:, 1:2); % Keep only useful columns

f_vswr = vswr_data(:,1);
VSWR = vswr_data(:,2);

%% Read Smith chart data
smith_data = readmatrix(smith_file, 'NumHeaderLines', 2);
smith_data = smith_data(:, 1:3); % Frequency, real, imaginary

f_smith = smith_data(:,1);
reS11 = smith_data(:,2);
imS11 = smith_data(:,3);

gamma = reS11 + 1j*imS11;      % Reflection coefficient

%% Convert frequency to GHz
f_s11_GHz   = f_s11 / 1e9;
f_vswr_GHz  = f_vswr / 1e9;
f_smith_GHz = f_smith / 1e9;

%% Find minimum S11
[minS11, idxMinS11] = min(S11_dB);
fMinS11 = f_s11_GHz(idxMinS11);

%% Find minimum VSWR
[minVSWR, idxVSWR] = min(VSWR);
fMinVSWR = f_vswr_GHz(idxVSWR);

%% Calculate impedance from gamma
Z = Z0 * (1 + gamma) ./ (1 - gamma);

% Impedance at minimum VSWR point
Z_minVSWR = Z(idxVSWR);

% Impedance at minimum S11 point
Z_minS11 = Z(idxMinS11);

%% Plot S11
figure;
plot(f_s11_GHz, S11_dB, 'LineWidth', 1.8);
grid on;
xlabel('Frequency (GHz)');
ylabel('S_{11} (dB)');
title('Measured S_{11}');
xlim([min(f_s11_GHz) max(f_s11_GHz)]);

hold on;
plot(fMinS11, minS11, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
text(fMinS11, minS11, sprintf('  Min = %.2f dB at %.3f GHz', minS11, fMinS11));

%% Plot VSWR (full view)
figure;
plot(f_vswr_GHz, VSWR, 'LineWidth', 1.8);
grid on;
xlabel('Frequency (GHz)');
ylabel('VSWR');
title('Measured VSWR');
xlim([min(f_vswr_GHz) max(f_vswr_GHz)]);

hold on;
plot(fMinVSWR, minVSWR, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
text(fMinVSWR, minVSWR, sprintf('  Min = %.2f at %.3f GHz', minVSWR, fMinVSWR));

%% Plot VSWR (zoomed view)
figure;
plot(f_vswr_GHz, VSWR, 'LineWidth', 1.8);
grid on;
xlabel('Frequency (GHz)');
ylabel('VSWR');
title('Measured VSWR (Zoomed View)');
xlim([1.6 2.8]);
ylim([1 4]);

hold on;
plot(fMinVSWR, minVSWR, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
text(fMinVSWR, minVSWR, sprintf('  Min = %.2f at %.3f GHz', minVSWR, fMinVSWR));

%% Plot Smith Chart
figure;
smithplot(gamma, 'LineWidth', 1.5);
title('Measured S_{11} on Smith Chart');

%% Display results in command window
fprintf('==================== RESULTS ====================\n');

fprintf('Minimum S11   = %.2f dB at %.6f GHz\n', minS11, fMinS11);
fprintf('Minimum VSWR  = %.2f at %.6f GHz\n\n', minVSWR, fMinVSWR);

fprintf('Impedance at minimum VSWR point:\n');
fprintf('   Z = %.2f + j%.2f Ohm\n', real(Z_minVSWR), imag(Z_minVSWR));
fprintf('   |Z| = %.2f Ohm\n\n', abs(Z_minVSWR));

fprintf('Impedance at minimum S11 point:\n');
fprintf('   Z = %.2f + j%.2f Ohm\n', real(Z_minS11), imag(Z_minS11));
fprintf('   |Z| = %.2f Ohm\n', abs(Z_minS11));

fprintf('=================================================\n');

%% Plot the simulated and measured S-parameter values


%% File names
sim_file  = 'HornS11.txt';
meas_file = 's11.csv';

%% Read simulation data
sim_data = readmatrix(sim_file, 'FileType', 'text', 'CommentStyle', '#');
sim_data = sim_data(:,1:2);   % Frequency, |S11|

f_sim = sim_data(:,1);        % GHz
S11_sim_mag = sim_data(:,2);  % linear magnitude
S11_sim_dB = 20*log10(S11_sim_mag);

%% Read measured data
meas_data = readmatrix(meas_file, 'NumHeaderLines', 2);
meas_data = meas_data(:,1:2); % Frequency, S11(dB)

f_meas = meas_data(:,1);      
S11_meas_dB = meas_data(:,2);

%% Convert measured frequency to GHz
f_meas_GHz = f_meas / 1e9;

%% Limit both datasets to the comparison region
f_low  = 1.6;
f_high = 2.8;

sim_mask  = (f_sim >= f_low) & (f_sim <= f_high);
meas_mask = (f_meas_GHz >= f_low) & (f_meas_GHz <= f_high);

f_sim_plot       = f_sim(sim_mask);
S11_sim_dB_plot  = S11_sim_dB(sim_mask);

f_meas_plot      = f_meas_GHz(meas_mask);
S11_meas_dB_plot = S11_meas_dB(meas_mask);

%% Find minima in the plotted region
[minSim, idxSim]   = min(S11_sim_dB_plot);
[minMeas, idxMeas] = min(S11_meas_dB_plot);

fMinSim  = f_sim_plot(idxSim);
fMinMeas = f_meas_plot(idxMeas);

%% Plot
figure('Color','w');
hold on;

hSim  = plot(f_sim_plot,  S11_sim_dB_plot,  'LineWidth', 2.2);
hMeas = plot(f_meas_plot, S11_meas_dB_plot, 'LineWidth', 2.2);

% Mark minima
plot(fMinSim,  minSim,  'o', 'MarkerSize', 9, 'LineWidth', 1.6, ...
    'MarkerFaceColor', 'w');
plot(fMinMeas, minMeas, 'o', 'MarkerSize', 9, 'LineWidth', 1.6, ...
    'MarkerFaceColor', 'w');

grid on;
box on;
set(gca, 'FontSize', 12, 'LineWidth', 1);

xlabel('Frequency (GHz)', 'FontSize', 12);
ylabel('S_{11} (dB)', 'FontSize', 12);
title('Comparison of Simulated and Measured S_{11}', 'FontSize', 13);

xlim([f_low f_high]);
ylim([-40 0]);

legend([hSim, hMeas], {'Simulated S_{11}', 'Measured S_{11}'}, ...
    'Location', 'southeast');

%% Annotation text
text(fMinSim + 0.015, minSim - 2.0, ...
    sprintf('Sim: %.2f dB @ %.3f GHz', minSim, fMinSim), ...
    'FontSize', 11, 'HorizontalAlignment', 'left');

text(fMinMeas + 0.015, minMeas + 0.8, ...
    sprintf('Meas: %.2f dB @ %.3f GHz', minMeas, fMinMeas), ...
    'FontSize', 11, 'HorizontalAlignment', 'left');

%% Optional: print results in command window
fprintf('Simulated minimum S11  = %.2f dB at %.3f GHz\n', minSim, fMinSim);
fprintf('Measured minimum S11   = %.2f dB at %.3f GHz\n', minMeas, fMinMeas);
fprintf('Frequency difference   = %.3f GHz (%.1f MHz)\n', ...
    abs(fMinMeas - fMinSim), abs(fMinMeas - fMinSim)*1000);

%% Plot the simulated and measured VSWR


%% File names
sim_file  = 'Horn VSWR.txt';
meas_file = 'vswr.csv';

%% Read simulation data
sim_data = readmatrix(sim_file, 'FileType', 'text', 'CommentStyle', '#');
sim_data = sim_data(:,1:2);   % Frequency (GHz), VSWR

f_sim = sim_data(:,1);
VSWR_sim = sim_data(:,2);

%% Read measured data
meas_data = readmatrix(meas_file, 'NumHeaderLines', 2);
meas_data = meas_data(:,1:2); % Frequency (Hz), VSWR

f_meas = meas_data(:,1) / 1e9; % Convert Hz → GHz
VSWR_meas = meas_data(:,2);

%% Define frequency range
f_low  = 1.6;
f_high = 2.8;

%% Apply mask 
sim_mask  = (f_sim >= f_low) & (f_sim <= f_high);
meas_mask = (f_meas >= f_low) & (f_meas <= f_high);

f_sim_plot  = f_sim(sim_mask);
VSWR_sim_plot = VSWR_sim(sim_mask);

f_meas_plot  = f_meas(meas_mask);
VSWR_meas_plot = VSWR_meas(meas_mask);

%% Find minimum values in the plotted region
[minSim, idxSim] = min(VSWR_sim_plot);
[minMeas, idxMeas] = min(VSWR_meas_plot);

fMinSim  = f_sim_plot(idxSim);
fMinMeas = f_meas_plot(idxMeas);

%% Plot
figure('Color','w');
hold on;

hSim  = plot(f_sim_plot,  VSWR_sim_plot,  'LineWidth', 2.2);
hMeas = plot(f_meas_plot, VSWR_meas_plot, 'LineWidth', 2.2);

%% Mark minima
plot(fMinSim,  minSim,  'ro', 'MarkerSize', 8, 'LineWidth', 1.5, 'MarkerFaceColor','w');
plot(fMinMeas, minMeas, 'ko', 'MarkerSize', 8, 'LineWidth', 1.5, 'MarkerFaceColor','w');

%% Formatting
grid on;
box on;
set(gca, 'FontSize', 12, 'LineWidth', 1);

xlabel('Frequency (GHz)', 'FontSize', 12);
ylabel('VSWR', 'FontSize', 12);
title('Comparison of Simulated and Measured VSWR', 'FontSize', 13);

xlim([f_low f_high]);
ylim([1 4]);

legend([hSim, hMeas], {'Simulated VSWR', 'Measured VSWR'}, ...
    'Location', 'northeast');

%% Annotations
text(fMinSim + 0.02, minSim + 0.05, ...
    sprintf('Sim: %.2f @ %.3f GHz', minSim, fMinSim), ...
    'FontSize', 11);

text(fMinMeas + 0.02, minMeas + 0.1, ...
    sprintf('Meas: %.2f @ %.3f GHz', minMeas, fMinMeas), ...
    'FontSize', 11);

%% Print results
fprintf('Simulated minimum VSWR = %.2f at %.3f GHz\n', minSim, fMinSim);
fprintf('Measured minimum VSWR  = %.2f at %.3f GHz\n', minMeas, fMinMeas);
fprintf('Frequency difference   = %.3f GHz (%.1f MHz)\n', ...
    abs(fMinMeas - fMinSim), abs(fMinMeas - fMinSim)*1000);

%% Convert frequency to GHz
f_s11 = f_s11 / 1e9;

%% Bandwidth calculation
threshold = -10;

idx = find(S11_dB < threshold);

f_low  = f_s11(idx(1));
f_high = f_s11(idx(end));

BW = f_high - f_low;

fprintf('\n========== BANDWIDTH ==========\n');
fprintf('Lower frequency  = %.3f GHz\n', f_low);
fprintf('Upper frequency  = %.3f GHz\n', f_high);
fprintf('Bandwidth        = %.3f GHz\n', BW);
fprintf('================================\n');
