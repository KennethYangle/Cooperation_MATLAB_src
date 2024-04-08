%% 读入数据
% 耗时长，1个小时 谨慎运行此部分
clc;clear;
bag = rosbag("E:/filtered_drone6-fly_coop_2024-01-24-15-47-14.bag");
topic_drone1_pos = select(bag,'Topic','/mavros/local_position/pose');
ts_drone1 = timeseries(topic_drone1_pos, 'Pose.Position.X', 'Pose.Position.Y', 'Pose.Position.Z');
p = ts_drone1.Data;
t = ts_drone1.Time;
save("data1.mat", "p", "t");

bag = rosbag("E:/filtered_drone7-fly_coop_2024-01-24-15-49-16.bag");
topic_drone2_pos = select(bag,'Topic','/mavros/local_position/pose');
ts_drone2 = timeseries(topic_drone2_pos, 'Pose.Position.X', 'Pose.Position.Y', 'Pose.Position.Z');
p = ts_drone2.Data;
t = ts_drone2.Time;
save("data2.mat", "p", "t");