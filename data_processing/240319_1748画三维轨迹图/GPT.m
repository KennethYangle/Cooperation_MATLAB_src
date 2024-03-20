% Load the data
data = load('data1.mat');
p = data.p; % Assuming p is your data matrix with dimensions [N, 3] for x, y, z

% Adding noise and offset
noise_level = 0.1;
offset = 0.5;
rng(0); % For reproducibility
noise = noise_level * randn(size(p)) + offset;
p_noisy = p + noise;

% Filtering (Gaussian smoothing)
% MATLAB might not have a direct equivalent to scipy's gaussian_filter, 
% so we use imgaussfilt3 for 3D data, or alternatively, smooth data manually.
% Adjust 'FilterSize' as needed to simulate the desired filter effect.
p_filtered = imgaussfilt3(p_noisy, 1, 'FilterSize', 3);

% Plotting
figure;
hold on;
plot3(p(:,1), p(:,2), p(:,3), 'o-', 'DisplayName', 'Original Trajectory');
plot3(p_noisy(:,1), p_noisy(:,2), p_noisy(:,3), '--', 'DisplayName', 'Noisy Trajectory');
plot3(p_filtered(:,1), p_filtered(:,2), p_filtered(:,3), '-.', 'DisplayName', 'Filtered Trajectory');
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
title('3D Trajectory: Original, Noisy, and Filtered');
legend;
grid on;
hold off;
