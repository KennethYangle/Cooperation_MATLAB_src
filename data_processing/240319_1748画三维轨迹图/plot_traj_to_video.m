clc; clear; close all;
figure_configuration_IEEE_standard;
colors = ["#0072BD", "#D95319", "#EDB120", "#4DBEEE", "#77AC30", "#7E2F8E", "#A2142F"];     % 色卡

%% 读数据
mav_num = 6;
P = struct();
T = struct();
for i = 1:mav_num
    name = strcat("data",num2str(i));
    load (name);
    P.(name) = p;
    T.(name) = t;
end
t1 = T.("data1");

%% 长度
Len = zeros(mav_num,1);
P_begin = ones(mav_num,1);
P_end = ones(mav_num,1);
for i = 1:mav_num
    name = strcat("data",num2str(i));
    Len(i) = size(P.(name), 1);
end
P_begin(1) = 20000;      % 根据需要修改终止时刻序号，默认Len(1)。起飞到开始降落20000-23000，逆过程21300-25000更好看
P_end(1) = 23000;

%% 确定绘图数据区间
for i = 2:mav_num
    name = strcat("data",num2str(i));
    for j = 1:Len(i)
        if T.(name)(j) > t1(P_begin(1))
            P_begin(i) = j;
            break
        end
    end
end
for i = 2:mav_num
    name = strcat("data",num2str(i));
    for j = Len(i):-1:1
        if T.(name)(j) < t1(P_end(1))
            P_end(i) = j;
            break
        end
    end
end

for i = 1:mav_num
    name = strcat("data",num2str(i));
    P.(name) = P.(name)(P_begin(i):P_end(i), :);
    T.(name) = T.(name)(P_begin(i):P_end(i)) - T.(name)(P_begin(i));
end

%% 滤波
% Adding noise and offset
rng(0); % For reproducibility
% 滤波
P_noisy = struct();
P_filtered1 = struct();
P_filtered2 = struct();
P_filtered3 = struct();
for i = 4:mav_num
    noise_level = 0.1;
    offset = 0.5;
    name = strcat("data",num2str(i));
    noise = noise_level * randn(size(P.(name))) + offset;
    P_noisy.(name) = P.(name) + noise;
    P_filtered1.(name) = imgaussfilt3(P_noisy.(name), 1, 'FilterSize', 3);     % 第2个参数重要
    P_filtered2.(name) = imgaussfilt3(P_noisy.(name), 0.5, 'FilterSize', 3);     % 第2个参数重要
    P_filtered3.(name) = imgaussfilt3(P_noisy.(name), 0.1, 'FilterSize', 3);     % 第2个参数重要
end


%% 画图，三维轨迹
% 创建视频文件输入流并打开
writerObj = VideoWriter('TrajVideo','Motion JPEG AVI');
writerObj.Quality = 95;
open(writerObj);

fig1 = figure(1);
% fig1.Renderer = 'Painters';     % 矢量图

idx_ratio = 3;
for tt = 1:1000
    hold on;
    % 目标真值
    plot3(P.("data4")(1:tt,1), P.("data4")(1:tt,2), P.("data4")(1:tt,3), "--", 'Color', colors(1));
    plot3(P.("data5")(1:tt,1), P.("data5")(1:tt,2), P.("data5")(1:tt,3), "--", 'Color', colors(2));
    plot3(P.("data6")(1:tt,1), P.("data6")(1:tt,2), P.("data6")(1:tt,3), "--", 'Color', colors(3));
    % 目标估计值
    plot3(P_filtered3.("data4")(1:tt,1), P_filtered3.("data4")(1:tt,2), P_filtered3.("data4")(1:tt,3), ":", 'Color', colors(1), 'linewidth', 0.5);
    plot3(P_filtered3.("data5")(1:tt,1), P_filtered3.("data5")(1:tt,2), P_filtered3.("data5")(1:tt,3), ":", 'Color', colors(2), 'linewidth', 0.5);
    plot3(P_filtered3.("data6")(1:tt,1), P_filtered3.("data6")(1:tt,2), P_filtered3.("data6")(1:tt,3), ":", 'Color', colors(3), 'linewidth', 0.5);
    % 拦截器
    plot3(P.("data1")(1:tt*idx_ratio,1), P.("data1")(1:tt*idx_ratio,2), P.("data1")(1:tt*idx_ratio,3), "-", 'Color', colors(4));
    plot3(P.("data2")(1:tt*idx_ratio,1), P.("data2")(1:tt*idx_ratio,2), P.("data2")(1:tt*idx_ratio,3), "-", 'Color', colors(5));
    plot3(P.("data3")(1:tt*idx_ratio,1), P.("data3")(1:tt*idx_ratio,2), P.("data3")(1:tt*idx_ratio,3), "-", 'Color', colors(6));

    view(-39,55.6);       % 视角
    xlim([-15,15]);       % 坐标轴范围
    ylim([-0.16,45]);
    zlim([9.85,15]);
    xlabel('x(m)');     % 坐标轴标签
    ylabel('y(m)');
    zlabel('z(m)');
    ax = gca;           
    ax.SortMethod = 'childorder';   % 显示虚线，否则矢量图下虚线变实线

    hold off;
    % 获取画布信息并写入视频
    F = getframe(fig1);
    writeVideo(writerObj, F)
    disp(tt);
end
% 关闭文件流
close(writerObj);
disp('Successful!');
