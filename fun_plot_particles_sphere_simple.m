function [weight_sphere, size_sphere] = fun_plot_particles_sphere_simple(sphere_pos, measurement_sphere)
%画单位球面三维粒子分布函数。

    %% 算权重
    sigma_p = 0.02;
    target_num = size(sphere_pos, 1);
    particle_num = size(sphere_pos, 2);
    
    weight_sphere = zeros(target_num, particle_num, 1);
    size_sphere = zeros(target_num, particle_num, 1);
    for j = 1:target_num
        for l = 1:particle_num
            weight_sphere(j,l) = fun_Gaussian(1.0 - measurement_sphere(j,:) * squeeze(sphere_pos(j,l,:)), 0, sigma_p);

            if norm(measurement_sphere(j,:)) < 0.1
                weight_sphere(j,l) = 1e-100;
            end

            size_sphere(j,l) = max(weight_sphere(j,l)/20, 0.1);
        end
    end
end
