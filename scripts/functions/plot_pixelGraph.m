function [] = plot_pixelGraph(grouped_data,EEGdataplot,num_of_channels,episode_opt,reference_opt)
%PLOT_LINEGRAPH Summary of this function goes here
%   Detailed explanation goes here
figure();

partition_num = [10, 4, 8 ,8];
temp_num = [partition_num(1), partition_num(1)+partition_num(2), ...
    partition_num(1)+partition_num(2)+partition_num(3), ...
    partition_num(1)+partition_num(2)+partition_num(3)+partition_num(4)];

partition_name = {'right and left scalp', 'left and right thalamic electrode', "left frontal strip", "right frontal strip"};

[numRows, numCols] = size(grouped_data);
grouped_data_value = 5*ones(numRows, numCols);
% 遍历矩阵中的所有元素
for i = 1:numRows
    for j = 1:numCols
        if strcmp(grouped_data(i,j), 'NonSeizure') == 1
           grouped_data_value(i,j) = 0;
        elseif strcmp(grouped_data(i,j), 'PeriIctalSignals') == 1
           grouped_data_value(i,j)=1;
        else
           grouped_data_value(i,j)=2;
        end
    end
end



% 创建空白行
blankRows = 3*ones(1, numCols);
% 插入空白行
grouped_data_value = [grouped_data_value(1:temp_num(1), :); blankRows;...
                      grouped_data_value(temp_num(1)+1:temp_num(2), :); blankRows;...
                      grouped_data_value(temp_num(2)+1:temp_num(3), :); blankRows;...
                      grouped_data_value(temp_num(3)+1:temp_num(4), :) ...
                      ];



%disp (grouped_data_value(12,:));

imagesc(grouped_data_value);
% 设置颜色映射
colormap([ 0 0 0; 0.5 0 0 ; 1 0 0; 1 1 1]);
colorbar;
clim([0 3]);
colorbar('Ticks', [0, 1, 2], 'TickLabels', {'NonSeizure', 'PeriIctalSignals', 'Seizure'},'Limits',[0,2]);

axis equal;


% 添加网格线
grid on;
axis([0.5, size(grouped_data_value, 2)+0.5, 0.5, size(grouped_data_value, 1)+0.5]);

% 设置网格线的属性
ax = gca;
ax.GridColor = [1, 1, 1]; % 设置网格线颜色为白色
ax.GridAlpha = 0.25; % 设置网格线透明度

% 保证网格线与图像像素对齐
ax.XTick = 0.5:1:size(grouped_data_value, 2);
ax.YTick = 0.5:1:size(grouped_data_value, 1);
ax.XTickLabel = [];
ax.YTickLabel = [];
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridLineStyle = '-';


xlabel('Segment index');
% 设置横纵坐标轴刻度和标签



title({strcat(reference_opt, ', example. ', num2str(episode_opt));'  '});
ax.TitleHorizontalAlignment = 'right';
set(gca,'linewidth',1,'fontsize',12,'fontname','Arial');

ax.TickLength = [0.001 0.001];

end

