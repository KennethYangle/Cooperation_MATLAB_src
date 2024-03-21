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
fig1 = figure(1);
fig1.Renderer = 'Painters';     % 矢量图

hold on;
% 目标真值
plot3(P.("data4")(:,1), P.("data4")(:,2), P.("data4")(:,3), "--", 'Color', colors(1));
plot3(P.("data5")(:,1), P.("data5")(:,2), P.("data5")(:,3), "--", 'Color', colors(2));
plot3(P.("data6")(:,1), P.("data6")(:,2), P.("data6")(:,3), "--", 'Color', colors(3));
% 目标估计值
plot3(P_filtered3.("data4")(:,1), P_filtered3.("data4")(:,2), P_filtered3.("data4")(:,3), ":", 'Color', colors(1), 'linewidth', 0.5);
plot3(P_filtered3.("data5")(:,1), P_filtered3.("data5")(:,2), P_filtered3.("data5")(:,3), ":", 'Color', colors(2), 'linewidth', 0.5);
plot3(P_filtered3.("data6")(:,1), P_filtered3.("data6")(:,2), P_filtered3.("data6")(:,3), ":", 'Color', colors(3), 'linewidth', 0.5);
% 拦截器
plot3(P.("data1")(:,1), P.("data1")(:,2), P.("data1")(:,3), "-", 'Color', colors(4));
plot3(P.("data2")(:,1), P.("data2")(:,2), P.("data2")(:,3), "-", 'Color', colors(5));
plot3(P.("data3")(:,1), P.("data3")(:,2), P.("data3")(:,3), "-", 'Color', colors(6));

view(-39,55.6);       % 视角
xlabel('x(m)');     % 坐标轴标签
ylabel('y(m)');
zlabel('z(m)');
ax = gca;           
ax.SortMethod = 'childorder';   % 显示虚线，否则矢量图下虚线变实线

hold off;


%% 画图，图例
fig2 = figure(2);
fig2.Renderer = 'Painters';     % 矢量图

t = 0:0.1:10;
y1 = t+1;
y2 = t+2;
y3 = t+3;
y4 = t+4;
y5 = t+5;
y6 = t+6;
y7 = t+7;
hold on;
plot(t, y1, "--", 'Color', colors(1), 'DisplayName', "H_1");
plot(t, y2, "--", 'Color', colors(2), 'DisplayName', "H_2");
plot(t, y3, "--", 'Color', colors(3), 'DisplayName', "H_3");
plot(t, y4, ":", 'Color', 'black', 'DisplayName', "MTE");
plot(t, y5, "-", 'Color', colors(4), 'DisplayName', "I_1");
plot(t, y6, "-", 'Color', colors(5), 'DisplayName', "I_2");
plot(t, y7, "-", 'Color', colors(6), 'DisplayName', "I_3");
hold off;

leg = legend('Location','northoutside', 'Orientation','horizontal');
leg.ItemTokenSize = [20,18];
legend boxoff;