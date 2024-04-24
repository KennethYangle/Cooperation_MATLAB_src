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
P.("data3") = P.("data3")(1800:2800, :);
P.("data3")(:,1) = P.("data3")(:,1) - 1.0;
% P.("data3")(:,3) = P.("data3")(:,3) - 1.5;
T.("data3") = T.("data3")(1800:2800);
P.("data4") = P.("data4")(1400:2500, :);
P.("data4")(:,1) = P.("data4")(:,1) + 3.0;
P.("data4")(:,3) = P.("data4")(:,3) + 8.0;
T.("data4") = T.("data4")(1400:2500);

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

idx_ratio2 = 573/569;
idx_ratio3 = 1001/569;
idx_ratio4 = 1101/569;
for tt = 1:569
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

    view(-190.7,53.2);       % 视角
    xlim([-5,20]);       % 坐标轴范围
    ylim([-60,1.33]);
    zlim([0,20]);
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
