# 画MCL示意图
`MCL_description.m` 得到论文中MCL的示意图。
Visio中调整线宽，外框和刻度1pt，内线0.5pt虚线。

# 仿真
1. `data_processing\240319_1748画三维轨迹图\plot_traj.m` 得到论文三维轨迹图。
2. `data_processing\240319_1748画三维轨迹图\plot_compare.m` 得到三种方法的x、y坐标对比图和方差图。
删除竖网格线，在figure_configuration_IEEE_standard.m设置为set(0,'defaultAxesXGrid','off');。
编辑-图窗属性-网格-取消勾选XGrid。保存为svg再导入visio，线宽3/4pt。