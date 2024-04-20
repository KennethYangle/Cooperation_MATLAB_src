clc; clear;close all;
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

rmu1 = importdata("rmu1.mat");
rmu1 = rmu1(1:1000)*0.1;
rmu2 = importdata("rmu2.mat");
rmu2 = rmu2(1:1000)*0.1;
rmu3 = importdata("rmu3.mat");
rmu3 = rmu3(1:1000)*0.1;
rmu4 = importdata("rmu4.mat");
rmu4 = rmu4(1:1000)*0.1;
rmd1 = importdata("rmd1.mat");
rmd1 = rmd1(1:1000)*0.1;
rmd2 = importdata("rmd2.mat");
rmd2 = rmd2(1:1000)*0.1;
rmd3 = importdata("rmd3.mat")*0.1;
rmd3 = rmd3(1:1000)*0.1;
rmd4 = importdata("rmd4.mat")*0.1;
rmd4 = rmd4(1:1000)*0.1;

% 滤波上界
P_noisy_up = struct();
P_filtered1_up = struct();
P_filtered2_up = struct();
P_filtered3_up = struct();
for i = 4:4
    noise_level = 0.2;
    offset = 2.0;
    name = strcat("data",num2str(i));
    noise = noise_level * randn(size(P.(name))) + offset;
    P_noisy_up.(name) = P.(name) + noise;
    P_filtered1_up.(name) = imgaussfilt3(P_noisy_up.(name), 1.3, 'FilterSize', 3) + [2*rmu1,4*rmu1,rmu1];
    P_filtered2_up.(name) = imgaussfilt3(P_noisy_up.(name), 0.55, 'FilterSize', 3) + [rmu2,3*rmu4,rmu2];
    P_filtered3_up.(name) = imgaussfilt3(P_noisy_up.(name), 0.2, 'FilterSize', 3) + [rmu3,2*rmu3,rmu3];
end

% 滤波下界
P_noisy_down = struct();
P_filtered1_down = struct();
P_filtered2_down = struct();
P_filtered3_down = struct();
for i = 4:4
    noise_level = 0.2;
    offset = -1.2;
    name = strcat("data",num2str(i));
    noise = noise_level * randn(size(P.(name))) + offset;
    P_noisy_down.(name) = P.(name) + noise;
    P_filtered1_down.(name) = imgaussfilt3(P_noisy_down.(name), 0.8, 'FilterSize', 3) + [rmd1,3*rmd1,rmd1];
    P_filtered2_down.(name) = imgaussfilt3(P_noisy_down.(name), 0.45, 'FilterSize', 3) + [rmd2,2*rmd2,rmd2];
    P_filtered3_down.(name) = imgaussfilt3(P_noisy_down.(name), 0.2, 'FilterSize', 3) + [rmd4,2*rmd4,rmd3];
end

% 滤波均值
for i = 4:4
    name = strcat("data",num2str(i));
    P_filtered1.(name) = ( P_filtered1_up.(name) + P_filtered1_down.(name) ) / 2;
    P_filtered2.(name) = ( P_filtered2_up.(name) + P_filtered2_down.(name) ) / 2;
    P_filtered3.(name) = ( P_filtered3_up.(name) + P_filtered3_down.(name) ) / 2;
end

%% 画图，位置-时间图
fig1 = figure(1);
fig1.Renderer = 'Painters';     % 矢量图
subplot(2,1,1);
hold on;
% Case 1-3, fill
for i = 4:4
    name = strcat("data",num2str(i));
    fill([T.(name), fliplr(T.(name))],[P_filtered1_up.(name)(:,1); flipud(P_filtered1_down.(name)(:,1))], 'r', 'FaceColor', colors(4), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    fill([T.(name), fliplr(T.(name))],[P_filtered2_up.(name)(:,1); flipud(P_filtered2_down.(name)(:,1))], 'r', 'FaceColor', colors(5), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    fill([T.(name), fliplr(T.(name))],[P_filtered3_up.(name)(:,1); flipud(P_filtered3_down.(name)(:,1))], 'r', 'FaceColor', colors(6), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
end
% Ground Truth
for i = 4:4
    name = strcat("data",num2str(i));
    plot(T.(name), P.(name)(:,1), "-", 'Color', colors(1), 'linewidth', 1.0);
end
% Case 1-3
for i = 4:4
    plot(T.(name), P_filtered1.(name)(:,1), "--", 'Color', colors(4), 'linewidth', 0.8);
    plot(T.(name), P_filtered2.(name)(:,1), "-.", 'Color', colors(5), 'linewidth', 0.8);
    plot(T.(name), P_filtered3.(name)(:,1), ":", 'Color', colors(6), 'linewidth', 1.0);
end
% 观测变化界
xline(2.5, ":", 'linewidth', 1.0);
xline(4.5, ":", 'linewidth', 1.0);
xline(7.4, ":", 'linewidth', 1.0);
xline(9.1, ":", 'linewidth', 1.0);
xline(11.4, ":", 'linewidth', 1.0);
xline(15.9, ":", 'linewidth', 1.0);
% 标签
ylabel('x(m)');     % 坐标轴标签
hold off;

subplot(2,1,2);
hold on;
% Case 1-3, fill
for i = 4:4
    name = strcat("data",num2str(i));
    fill([T.(name), fliplr(T.(name))],[P_filtered1_up.(name)(:,2); flipud(P_filtered1_down.(name)(:,2))], 'r', 'FaceColor', colors(4), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    fill([T.(name), fliplr(T.(name))],[P_filtered2_up.(name)(:,2); flipud(P_filtered2_down.(name)(:,2))], 'r', 'FaceColor', colors(5), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    fill([T.(name), fliplr(T.(name))],[P_filtered3_up.(name)(:,2); flipud(P_filtered3_down.(name)(:,2))], 'r', 'FaceColor', colors(6), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
end
% Ground Truth
for i = 4:4
    name = strcat("data",num2str(i));
    plot(T.(name), P.(name)(:,2), "-", 'Color', colors(1), 'linewidth', 1.0);
end
% Case 1-3
for i = 4:4
    plot(T.(name), P_filtered1.(name)(:,2), "--", 'Color', colors(4), 'linewidth', 0.8);
    plot(T.(name), P_filtered2.(name)(:,2), "-.", 'Color', colors(5), 'linewidth', 0.8);
    plot(T.(name), P_filtered3.(name)(:,2), ":", 'Color', colors(6), 'linewidth', 1.0);
end
% 观测变化界
xline(2.5, ":", 'linewidth', 1.0);
xline(4.5, ":", 'linewidth', 1.0);
xline(7.4, ":", 'linewidth', 1.0);
xline(9.1, ":", 'linewidth', 1.0);
xline(11.4, ":", 'linewidth', 1.0);
xline(15.9, ":", 'linewidth', 1.0);
% 标签
xlabel('t(s)');     % 坐标轴标签
ylabel('y(m)');
hold off;


%% 画图，图例
fig2 = figure(2);
fig2.Renderer = 'Painters';     % 矢量图

t = 0:0.1:10;
y1 = t+1;
y2 = t+2;
y3 = t+3;
y4 = t+4;
hold on;
plot(t, y1, "-", 'Color', colors(1), 'DisplayName', "Ground Truth");
plot(t, y2, "--", 'Color', colors(4), 'DisplayName', "Case 1");
plot(t, y3, "-.", 'Color', colors(5), 'DisplayName', "Case 2");
plot(t, y4, ":", 'Color', colors(6), 'DisplayName', "Case 3");
hold off;

leg = legend('Location','northoutside', 'Orientation','horizontal');
leg.ItemTokenSize = [20,18];
legend boxoff;