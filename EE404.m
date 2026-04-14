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