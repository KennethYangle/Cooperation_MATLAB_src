function fun_plot_particles_allocation_simple(mav_pos_mean, mav_orient_mean, target_pos_mean, allo_pair)
%画二维粒子分布函数。
    xmin = -5; xmax = 5;
    ymin = -2; ymax = 12;

    mav_num = size(mav_pos_mean, 1);
    target_num = size(mav_orient_mean, 1);
    pair_num = size(allo_pair, 1);
    
    %% 算方向
    L = 2;
    mav_orient_xy = zeros(mav_num, 2);
    for i = 1:mav_num
        mav_orient_xy(i,1) = L * cos(mav_orient_mean(i,1));
        mav_orient_xy(i,2) = L * sin(mav_orient_mean(i,1));
    end

    %% 画粒子
    hold on;
    for j = 1:target_num
        if j == 1
            scatter(target_pos_mean(j,1), target_pos_mean(j,2), 15, 'MarkerEdgeColor',"#f47923", 'MarkerFaceColor',"#ff8d24");
        else
            scatter(target_pos_mean(j,1), target_pos_mean(j,2), 15, 'MarkerEdgeColor',"#ba8a19", 'MarkerFaceColor',"#edb120");
        end
    end

    %% 画圆和箭头
    for i = 1:mav_num
        viscircles([mav_pos_mean(i,1), mav_pos_mean(i,2)], 1,'Color','#b1ceef');
        quiver(mav_pos_mean(i,1), mav_pos_mean(i,2), mav_orient_xy(i,1), mav_orient_xy(i,2), ...
        '-','LineWidth',3,'Color','#77AC30','AutoScale','on','AutoScaleFactor',1);
    end
    
    %% 画配对
    for pp = 1:pair_num
        plot([mav_pos_mean(allo_pair(pp,1), 1), target_pos_mean(allo_pair(pp,2), 1)], [mav_pos_mean(allo_pair(pp,1), 2), target_pos_mean(allo_pair(pp,2), 2)], ...
            'Color', "#0072BD");
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

