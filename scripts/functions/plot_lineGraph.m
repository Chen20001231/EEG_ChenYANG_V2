function [] = plot_lineGraph(grouped_data,EEGdataplot,num_of_channels,episode_opt,reference_opt)
%PLOT_LINEGRAPH Summary of this function goes here
%   Detailed explanation goes here

counts = sum(strcmp(grouped_data, 'Seizure'));  % 统计每个组中 1 出现的次数
counts = [counts; sum(strcmp(grouped_data, 'NonSeizure'))];  % 统计每个组中 2 出现的次数
counts = [counts; sum(strcmp(grouped_data, 'PeriIctalSignals'))];  % 统计每个组中 3 出现的次数

%y_test_segNo = find(~idxTrain == 1);
y_test_segNo = (1:size(counts,2))';



%% 画图
% 创建图形窗口
figure;
% 绘制第一个变量
subplot(2,1,1);
plot(y_test_segNo, counts(1,:), 'r', 'LineWidth', 1);  % 红色实线
hold on;  % 保持当前图形
plot(y_test_segNo, counts(2,:), 'b', 'LineWidth', 1); % 绿色虚线
plot(y_test_segNo, counts(3,:), 'm', 'LineWidth', 1);  % 蓝色点线
xlim([min(y_test_segNo) max(y_test_segNo)]);
% 添加图例
legend('Seizure', 'NonSeizure', 'PeriIctalSignals');
% 添加坐标轴标签和标题
xlabel('Segment index');
ylabel('Number of channels');

title({strcat(reference_opt, ', example. ', num2str(episode_opt));'  ';'  '});
ax = gca;
ax.TitleHorizontalAlignment = 'right';
set(gca,'linewidth',1,'fontsize',12,'fontname','Arial');
grid on;
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




subplot(2,1,2);
% 定义偏移量，避免信号重叠
offset = 500;
% 遍历每个通道并绘制
hold on;
%for i = 24
for i = 1:num_of_channels
    plot(EEGdataplot(:, i) + (num_of_channels-i) * offset);
end
hold off;

% 添加标签和标题
xlabel('Samples');
ylabel('Amplitude');
title(' ');
grid on;

xlim([1,length(EEGdataplot)]);
ylim([-offset, (num_of_channels-1) * offset + offset]);
set(gca,'linewidth',1,'fontsize',12,'fontname','Arial');

end

