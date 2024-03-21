% 设置随机游走的步数
nSteps = 1233;

% 生成随机步长，这里使用标准正态分布（均值为0，标准差为1）的随机数
% randn函数生成的是正态分布的随机数，rand函数生成的是均匀分布的随机数
stepSize = randn(nSteps, 1);

% 计算随机游走序列，使用cumsum函数累积步长
randomWalk = cumsum(stepSize);

% 绘制随机游走序列
figure;
plot(randomWalk);
xlabel('Step');
ylabel('Position');
title('1D Random Walk');
grid on;
