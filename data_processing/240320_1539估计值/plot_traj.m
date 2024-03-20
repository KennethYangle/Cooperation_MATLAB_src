clc; clear;close all;
figure_configuration_IEEE_standard;

%% 读数据
mav_num = 6;
P = struct();
T = struct();
for i = 1:mav_num
    name = strcat("data",num2str(i));
    load (name);
    P.(name) = p;
    T.(name) = t;
    if i == 1
        C = target_p(:);
    end
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
P_begin(1) = 22300;      % 根据需要修改终止时刻序号，默认Len(1)。起飞到开始降落20000-23000，逆过程21300-25000更好看
P_end(1) = 26000;

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
    T.(name) = T.(name)(P_begin(i):P_end(i));
end

% 估计数据
data4_est = zeros(P_end(1)-P_begin(1), 3);
data5_est = zeros(P_end(1)-P_begin(1), 3);
data6_est = zeros(P_end(1)-P_begin(1), 3);
C = C(P_begin(1):P_end(1));
for i = 1:P_end(1)-P_begin(1)
    cc = cell2mat(C(i));
    if size(cc, 1) < 3
        data4_est(i,:) = data4_est(i-1,:);
        data5_est(i,:) = data5_est(i-1,:);
        data6_est(i,:) = data6_est(i-1,:);
        continue
    end
    data4_est(i,:) = cc(1,:);
    data5_est(i,:) = cc(2,:);
    data6_est(i,:) = cc(3,:);
end

%% 画图
fig1 = figure(1);
fig1.Renderer = 'Painters';     % 矢量图

hold on;
for i = 4:mav_num
    name = strcat("data",num2str(i));
    if i <= 3
        plot3(P.(name)(:,1), P.(name)(:,2), P.(name)(:,3));
    else
        plot3(P.(name)(:,1), P.(name)(:,2), P.(name)(:,3), "--");
    end
end
% 估计
plot3(data4_est(:,1), data4_est(:,2), data4_est(:,3));
plot3(data5_est(:,1), data5_est(:,2), data5_est(:,3));
plot3(data6_est(:,1), data6_est(:,2), data6_est(:,3));


view(-39,52);       % 视角
legend;             % 图例
ax = gca;           
ax.SortMethod = 'childorder';   % 显示虚线，否则矢量图下虚线变实线