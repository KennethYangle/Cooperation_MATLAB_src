clc; clear;

load 240318_1734test\data_2024-03-18_17-28-34.mat;
p1 = p;
t1 = t;
load 240318_1734test\data_2024-03-18_17-29-47.mat
p2 = p;
t2 = t;
load 240318_1734test\data_2024-03-18_17-29-56.mat
p3 = p;
t3 = t;

plot3(p1(:,1), p1(:,2), p1(:,3));
hold on;
plot3(p2(:,1), p2(:,2), p2(:,3));
plot3(p3(:,1), p3(:,2), p3(:,3));

