function [] = plot_lineGraph_withPartition(grouped_data,EEGdataplot,num_of_channels,episode_opt,reference_opt)
%PLOT_LINEGRAPH Summary of this function goes here
%   Detailed explanation goes here
figure();

partition_num = [10, 4, 8 ,8];
partition_name = {'right and left scalp', 'left and right thalamic electrode', "left frontal strip", "right frontal strip"};
y_test_segNo = (1:size(grouped_data,2))';
temp = 0;
for i = 1:length(partition_num)
    subplot(length(partition_num)+1,1,i);

    label = grouped_data(1+temp:partition_num(i)+temp,:);
    temp = temp+partition_num(i);
    counts = [];
    counts = sum(strcmp(label, 'Seizure'));  % 统计每个组中 1 出现的次数
    counts = [counts; sum(strcmp(label, 'NonSeizure'))];  % 统计每个组中 2 出现的次数
    counts = [counts; sum(strcmp(label, 'PeriIctalSignals'))];  % 统计每个组中 3 出现的次数

    plot(y_test_segNo, counts(1,:), 'r', 'LineWidth', 1);  % 红色实线
    hold on;  % 保持当前图形
    plot(y_test_segNo, counts(2,:), 'b', 'LineWidth', 1); % 绿色虚线
    plot(y_test_segNo, counts(3,:), 'm', 'LineWidth', 1);  % 蓝色点线
    xlim([min(y_test_segNo) max(y_test_segNo)]);
    % 添加图例
    legend('Seizure', 'NonSeizure', 'PeriIctalSignals');
    % 添加坐标轴标签和标题
    xlabel('Segment index');
    ylabel('No. of ch.');
    ylim([0, 10]);
    if i == 1
    title({strcat(reference_opt, ', example. ', num2str(episode_opt));'  ';partition_name{i}});
    else
    title(partition_name{i});
    end
    grid on;
    hold off;
    set(gca,'linewidth',1,'fontsize',12,'fontname','Arial');

end

subplot(length(partition_num)+1,1,length(partition_num)+1);
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
grid on;

xlim([1,length(EEGdataplot)]);
ylim([-offset, (num_of_channels-1) * offset + offset]);
set(gca,'linewidth',1,'fontsize',12,'fontname','Arial');

end

