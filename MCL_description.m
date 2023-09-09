clc;clear;close all;
figure_configuration_IEEE_standard;

%% 数据初始化
mav_pos_all = zeros(5, 2, 4, 3);    % （时间，飞机id，粒子id，坐标）
target_pos_all = zeros(5, 2, 4, 3);	% （时间，目标id，粒子id，坐标）
mav_orient_all = zeros(5, 2, 4, 1);	% 偏航角
sphere_pos_all = zeros(5, 2, 4, 3);
measurement_pos_all = zeros(5, 2, 1, 3);
measurement_pos_sphere = zeros(5, 2, 1, 3);

times = size(target_pos_all, 1);
mav_num = size(mav_pos_all,2);
target_num = size(target_pos_all, 2);
particle_num = size(target_pos_all, 3);

%% 数据赋值
mav_pos_all(1,1,:,:) = [-2, 0, 0; -2.2, 0.1, 0; -2.1, 0.2, 0; -1.8, -0.1, 0];
mav_pos_all(1,2,:,:) = [3, 0, 0; 3.2, 0.2, 0; 3.1, 0.3, 0; 2.8, -0.2, 0];
target_pos_all(1,1,:,:) = [-3.3, 5, 0; -2.5, 5.6, 0; -1.2, 6.5, 0; -2.4, 6.9, 0];
target_pos_all(1,2,:,:) = [3.3, 5, 0; 3.5, 5.6, 0; 2.2, 4.5, 0; 2.4, 4.9, 0];
mav_orient_all(1,1,:,:) = deg2rad([86; 88; 90; 92]);
mav_orient_all(1,2,:,:) = deg2rad([86; 88; 90; 92]);

mav_pos_all(2,1,:,:) = [-2, 0.5, 0; -2.2, 0.6, 0; -2.1, 0.7, 0; -1.8, 0.4, 0];
mav_pos_all(2,2,:,:) = [3, 0.5, 0; 3.2, 0.7, 0; 3.1, 0.8, 0; 2.8, 0.4, 0];
target_pos_all(2,1,:,:) = [-3.9, 5.0, 0; -2.9, 6.0, 0; -1.3, 6.8, 0; -2.4, 8.5, 0];
target_pos_all(2,2,:,:) = [3.3, 4.5, 0; 2.9, 5.8, 0; 2.3, 6.8, 0; 2.4, 8.5, 0];
mav_orient_all(2,1,:,:) = deg2rad([82; 86; 90; 94]);
mav_orient_all(2,2,:,:) = deg2rad([82; 86; 90; 94]);

mav_pos_all(3,1,:,:) = [-2, 0.5, 0; -2.2, 0.6, 0; -2.1, 0.7, 0; -1.8, 0.4, 0];
mav_pos_all(3,2,:,:) = [3, 0.5, 0; 3.2, 0.7, 0; 3.1, 0.8, 0; 2.8, 0.4, 0];
target_pos_all(3,1,:,:) = [-3.9, 5.0, 0; -2.9, 6.0, 0; -1.3, 6.8, 0; -2.4, 8.5, 0];
target_pos_all(3,2,:,:) = [3.3, 4.5, 0; 2.9, 5.8, 0; 2.3, 6.8, 0; 2.4, 8.5, 0];
mav_orient_all(3,1,:,:) = deg2rad([82; 86; 90; 94]);
mav_orient_all(3,2,:,:) = deg2rad([82; 86; 90; 94]);
measurement_pos_all(3,1,1,:) = [-3.7, 7, 0];  % 观测
measurement_pos_all(3,2,1,:) = [1.2, 8, 0];

mav_pos_all(4,1,:,:) = [-2, 0.5, 0; -2.2, 0.6, 0; -2.1, 0.7, 0; -1.8, 0.4, 0];
mav_pos_all(4,2,:,:) = [3, 0.5, 0; 3.2, 0.7, 0; 3.1, 0.8, 0; 2.8, 0.4, 0];
target_pos_all(4,1,:,:) = [-3.9, 5.2, 0; -3.6, 5.4, 0; -2.9, 6.1, 0; -3.1, 6.2, 0];
target_pos_all(4,2,:,:) = [2.4, 8.5, 0; 2.2, 8.2, 0; 2.3, 7.2, 0; 2.1, 9.0, 0];
mav_orient_all(4,1,:,:) = deg2rad([86; 88; 90; 98]);
mav_orient_all(4,2,:,:) = deg2rad([86; 88; 90; 98]);

mav_pos_all(5,1,:,:) = [-2, 0.5, 0; -2.2, 0.6, 0; -2.1, 0.7, 0; -1.8, 0.4, 0];
mav_pos_all(5,2,:,:) = [3, 0.5, 0; 3.2, 0.7, 0; 3.1, 0.8, 0; 2.8, 0.4, 0];
target_pos_all(5,1,:,:) = [-3.9, 5.5, 0; -3.6, 5.9, 0; -2.9, 6.1, 0; -3.1, 6.3, 0];
target_pos_all(5,2,:,:) = [2.2, 8.5, 0; 2.0, 8.2, 0; 2.1, 7.4, 0; 1.9, 8.8, 0];
mav_orient_all(5,1,:,:) = deg2rad([86; 88; 92; 96]);
mav_orient_all(5,2,:,:) = deg2rad([86; 88; 92; 96]);

for t = 1:times
    for j = 1:target_num
        for l = 1:particle_num
            p = squeeze(mav_pos_all(t,1,l,:));
            pt = squeeze(target_pos_all(t,j,l,:));
            sphere_pos_all(t,j,l,:) = (pt-p) / norm(pt-p);
            q = squeeze(measurement_pos_all(t,j,1,:));
            if norm(q) > 0.1
                measurement_pos_sphere(t,j,1,:) = (q-p) / norm(q-p);
            end
        end
    end
end


%% 第一列第一行
t = 1;
subplot(1,5,1);
[weight_sphere, size_sphere] = fun_plot_particles_sphere_simple(squeeze(sphere_pos_all(t,:,:,:)), squeeze(measurement_pos_sphere(t,:,:,:)));
fun_plot_particles_simple(squeeze(mav_pos_all(t,:,:,:)), squeeze(target_pos_all(t,:,:,:)), squeeze(mav_orient_all(t,:,:,:)), squeeze(measurement_pos_all(t,:,:,:)), weight_sphere, size_sphere );


%% 第二列第一行
t = 2;
subplot(1,5,2);
[weight_sphere, size_sphere] = fun_plot_particles_sphere_simple(squeeze(sphere_pos_all(t,:,:,:)), squeeze(measurement_pos_sphere(t,:,:,:)));
fun_plot_particles_simple(squeeze(mav_pos_all(t,:,:,:)), squeeze(target_pos_all(t,:,:,:)), squeeze(mav_orient_all(t,:,:,:)), squeeze(measurement_pos_all(t,:,:,:)), weight_sphere, size_sphere );


%% 第三列第一行
t = 3;
subplot(1,5,3);
[weight_sphere, size_sphere] = fun_plot_particles_sphere_simple(squeeze(sphere_pos_all(t,:,:,:)), squeeze(measurement_pos_sphere(t,:,:,:)));
fun_plot_particles_simple(squeeze(mav_pos_all(t,:,:,:)), squeeze(target_pos_all(t,:,:,:)), squeeze(mav_orient_all(t,:,:,:)), squeeze(measurement_pos_all(t,:,:,:)), weight_sphere, size_sphere );


%% 第四列第一行
t = 4;
subplot(1,5,4);
[weight_sphere, size_sphere] = fun_plot_particles_sphere_simple(squeeze(sphere_pos_all(t,:,:,:)), squeeze(measurement_pos_sphere(t,:,:,:)));
fun_plot_particles_simple(squeeze(mav_pos_all(t,:,:,:)), squeeze(target_pos_all(t,:,:,:)), squeeze(mav_orient_all(t,:,:,:)), squeeze(measurement_pos_all(t,:,:,:)), weight_sphere, size_sphere );


%% 第五列第一行
t = 5;
subplot(1,5,5);
[weight_sphere, size_sphere] = fun_plot_particles_sphere_simple(squeeze(sphere_pos_all(t,:,:,:)), squeeze(measurement_pos_sphere(t,:,:,:)));
fun_plot_particles_simple(squeeze(mav_pos_all(t,:,:,:)), squeeze(target_pos_all(t,:,:,:)), squeeze(mav_orient_all(t,:,:,:)), squeeze(measurement_pos_all(t,:,:,:)), weight_sphere, size_sphere );

