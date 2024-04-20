clc; clear;close all;
figure_configuration_IEEE_standard;
colors = ["#0072BD", "#D95319", "#EDB120", "#4DBEEE", "#77AC30", "#7E2F8E", "#A2142F"];     % 色卡

%% 读数据
load("P.mat");
load("P_filtered3.mat");

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