clc, clearvars, close all, format compact
% 创建视频文件输入流并打开
writerObj = VideoWriter('CosineVideo','Uncompressed AVI');
open(writerObj);
% 绘图数据
t = 0:.2:50;
x = 0:.1:20;
% 创建画布
fig1 = figure(1);
% 逐步绘制
for i = 1:length(t)
    y = cos(x*2*pi/8 + t(i));
    plot(x,y)
    title('Moving Cosine'), xlabel('X'), ylabel('cos(x)')
    % 获取画布信息并写入视频
    F = getframe(fig1);
    writeVideo(writerObj, F)
end
% 关闭文件流
close(writerObj);
disp('Successful!');
