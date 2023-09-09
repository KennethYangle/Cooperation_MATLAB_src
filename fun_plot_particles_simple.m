function fun_plot_particles_simple(mav_pos, target_pos, mav_orient, measurement_pos, weight_sphere, size_sphere)
%画二维粒子分布函数。

    mav_num = size(mav_pos, 1);
    target_num = size(target_pos, 1);
    particle_num = size(mav_pos, 2);
    
    %% 概率分布
    sigma_p = 0.005;
    xmin = -5; xmax = 5;
    ymin = -2; ymax = 12;
    step = 0.1;
    
    a = xmin:step:xmax;
    b = ymin:step:ymax;
    [x,y] = meshgrid(a,b);
    z = zeros(size(x));
    
    for ii = 1:mav_num
    for jj = ii:target_num
        if norm(measurement_pos(jj,:)) > 0.1
            p = squeeze(mav_pos(ii,1,:));
            relative_measure = measurement_pos(jj,:)-p';
            norm_measurement = relative_measure / norm(relative_measure);
            
            for i = 1:size(x,1)
                for j = 1:size(x,2)
                    % z(i,j) = sin(x(i,j)) + sin(y(i,j));
                    pt = [x(i,j); y(i,j); 0];
                    norm_p = (pt-p) / norm(pt-p);
                    z(i,j) = z(i,j) + fun_Gaussian(1.0 - norm_measurement * norm_p, 0, sigma_p) - 5;
                end
            end
        end
    end
    end

    %% 算方向
    L = 2;
    mav_orient_xy = zeros(mav_num, particle_num, 2);
    for i = 1:mav_num
        for l = 1:particle_num
            mav_orient_xy(i,l,1) = L * cos(mav_orient(i,l));
            mav_orient_xy(i,l,2) = L * sin(mav_orient(i,l));
        end
    end

    %% 画粒子
    hold on;
    for j = 1:target_num
        if norm(measurement_pos) > 0.1
            scatter(measurement_pos(j,1), measurement_pos(j,2), 60, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0.8500, 0.10, 0.0980]);
            if j == 1
                scatter(target_pos(j,:,1), target_pos(j,:,2), 150*size_sphere(j,:), 'MarkerEdgeColor',"#f47923", 'MarkerFaceColor',"#ff8d24");
            else
                scatter(target_pos(j,:,1), target_pos(j,:,2), 150*size_sphere(j,:), 'MarkerEdgeColor',"#ba8a19", 'MarkerFaceColor',"#edb120");
            end
        else
            if j == 1
                scatter(target_pos(j,:,1), target_pos(j,:,2), 15, 'MarkerEdgeColor',"#f47923", 'MarkerFaceColor',"#ff8d24");
            else
                scatter(target_pos(j,:,1), target_pos(j,:,2), 15, 'MarkerEdgeColor',"#ba8a19", 'MarkerFaceColor',"#edb120");
            end
        end
    end
    
    %% 画概率
    if norm(measurement_pos) > 0.1
        surf(x,y,z, 'FaceAlpha',0.5);
        mymap = [[1:-0.01:0.]; [1:-0.01:0.]; [1:-0.01:0.]]';
        colormap(gca, mymap);
%         mymap = [1,1,1; 0.6,0.6,0.6];
%         colorbar('SouthOutside')
        shading interp;
        view(2)
    end
    
    %% 画圆和箭头
    for i = 1:mav_num
        for l = 1:particle_num
            viscircles([mav_pos(i,l,1), mav_pos(i,l,2)], 1,'Color','#b1ceef');
            quiver(mav_pos(i,l,1), mav_pos(i,l,2), mav_orient_xy(i,l,1), mav_orient_xy(i,l,2), ...
            '-','LineWidth',3,'Color','#77AC30','AutoScale','on','AutoScaleFactor',1);
        end
    end
    
    %% 绘图配置
    axis equal;
    box on;
    xlim([xmin, xmax]);
    ylim([ymin, ymax]);
    ax = gca;
    ax.GridLineStyle = '-';
    set(gca,'ytick',[0 5 10]);
end

