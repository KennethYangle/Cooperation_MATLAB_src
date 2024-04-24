clc; clear; close all;
figure_configuration_IEEE_standard;
colors = ["#0072BD", "#D95319", "#EDB120", "#4DBEEE", "#77AC30", "#7E2F8E", "#A2142F"];     % 色卡

%% 读数据
mav_num = 4;
P = struct();
T = struct();
for i = 1:mav_num
    name = strcat("data",num2str(i));
    load (name);
    P.(name) = p;
    T.(name) = t;
end
t1 = T.("data1");
% P.("data2") = imgaussfilt3(P.("data2"), 0.1, 'FilterSize', 3);

%% 长度
P.("data3") = P.("data3")(2400:3850, :);
P.("data3")(:,1) = P.("data3")(:,1) - 3;
P.("data3")(:,2) = P.("data3")(:,2) + 7.4;
P.("data3")(:,3) = P.("data3")(:,3) + 3;
P.("data4") = P.("data4")(2200:3200, :);
P.("data4")(:,2) = P.("data4")(:,2) + 3.0;
P.("data4")(:,3) = P.("data4")(:,3) + 10.0;

%% 滤波
% Adding noise and offset
rng(0); % For reproducibility
% 滤波
P_noisy = struct();
P_filtered1 = struct();
P_filtered2 = struct();
P_filtered3 = struct();
for i = 3:mav_num
    noise_level = 0.1;
    offset = 0;
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

idx_ratio2 = 956/902;
idx_ratio3 = 1451/902;
idx_ratio4 = 1001/902;
for tt = 1:752
    hold on;
    % % 目标真值
    % plot3(P.("data3")(:,1), P.("data3")(:,2), P.("data3")(:,3), "--", 'Color', colors(1));
    % plot3(P.("data4")(:,1), P.("data4")(:,2), P.("data4")(:,3), "--", 'Color', colors(2));
    % 目标估计值
    plot3(P_filtered3.("data3")(1:round(tt*idx_ratio3),1), P_filtered3.("data3")(1:round(tt*idx_ratio3),2), P_filtered3.("data3")(1:round(tt*idx_ratio3),3), ":", 'Color', colors(1), 'linewidth', 0.5);
    plot3(P_filtered3.("data4")(1:round(tt*idx_ratio4),1), P_filtered3.("data4")(1:round(tt*idx_ratio4),2), P_filtered3.("data4")(1:round(tt*idx_ratio4),3), ":", 'Color', colors(2), 'linewidth', 0.5);
    % 拦截器
    plot3(P.("data1")(1:tt,1), P.("data1")(1:tt,2), P.("data1")(1:tt,3), "-", 'Color', colors(4));
    plot3(P.("data2")(1:round(tt*idx_ratio2),1), P.("data2")(1:round(tt*idx_ratio2),2), P.("data2")(1:round(tt*idx_ratio2),3), "-", 'Color', colors(5));

    view(137.8,28.9);       % 视角
    xlim([-40.86,0.92]);       % 坐标轴范围
    ylim([-5.23,10]);
    zlim([5,20]);
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
