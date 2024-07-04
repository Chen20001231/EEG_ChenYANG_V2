function [] = plot_difference_pixelGraph(grouped_data,EEGdataplot,num_of_channels,episode_opt,reference_opt)
%PLOT_LINEGRAPH Summary of this function goes here
%   Detailed explanation goes here

[num_of_grouped_data, numRows, numCols] = size(grouped_data);
figure();


partition_num = [10, 4, 8 ,8];
partition_name = {'right and left scalp', 'left and right thalamic electrode', "left frontal strip", "right frontal strip"};


partition_num_cum = [partition_num(1),...
            partition_num(1)+partition_num(2), ...
            partition_num(1)+partition_num(2)+partition_num(3), ...
            partition_num(1)+partition_num(2)+partition_num(3)+partition_num(4)];
blankRows = 3*ones(1, numCols); % 创建空白行


if num_of_grouped_data == 1
    temp = 1; % 1 graph, re-ref or monopolar
else
    temp = 3; % 3 graphs, re-ref, monopolar, difference
end

tiledlayout(temp,1);

for m = 1:temp
    if m <= 2
        grouped_data_value = zeros(numRows, numCols);
        % 遍历矩阵中的所有元素
        for i = 1:numRows
            for j = 1:numCols
                if strcmp(grouped_data(m,i,j), 'NonSeizure') == 1
                   grouped_data_value(i,j) = 0;
                elseif strcmp(grouped_data(m,i,j), 'PeriIctalSignals') == 1
                   grouped_data_value(i,j)=1;
                else
                   grouped_data_value(i,j)=2;
                end
            end
        end

        if (num_of_grouped_data == 2) && (m == 1)
            grouped_data_value_temp = grouped_data_value;
        end


    else % calculate difference
        grouped_data_value = grouped_data_value-grouped_data_value_temp;
    end



    % 插入空白行
    grouped_data_value_plot = [grouped_data_value(1:partition_num_cum(1), :); blankRows;...
                               grouped_data_value(partition_num_cum(1)+1:partition_num_cum(2), :); blankRows;...
                               grouped_data_value(partition_num_cum(2)+1:partition_num_cum(3), :); blankRows;...
                               grouped_data_value(partition_num_cum(3)+1:partition_num_cum(4), :)];
    

    if m<=2
        nexttile;
        %subplot(temp+1,1,m);
        imagesc(grouped_data_value_plot);
        % 设置颜色映射
        colormap([ 0 0 0; 0.5 0 0 ; 1 0 0; 1 1 1]);
        colorbar;
        clim([0 3]);
        colorbar('Ticks', [0, 1, 2], 'TickLabels', {'diff = 0', 'diff = 1', 'diff = 2'},'Limits',[0,2]);
        axis equal;
        title({strcat(reference_opt{m}, ', example. ', num2str(episode_opt))});
    else
        ax1 = nexttile;
        %ax = subplot(temp+1,1,m);
        imagesc(grouped_data_value_plot);
        % 设置颜色映射
        colormap(ax1, [0 0 0;0.25 0.25 0.25;0.5 0.5 0.5; 0.75 0.75 0.75 ; 1 1 1; 0.5 0.35 0.35]);
        %colormap(ax1, [0 0 1;0.25 0 0.75;1 1 1; 0.75 0 0.25 ; 1 0 0; 0 0 0]);
        colorbar;
        clim([-2 3]);
        colorbar(ax1, 'Ticks', [-2, -1, 0, 1, 2], 'TickLabels', {'-2', '-1', '0', '1', '2'},'Limits',[-2,2]);
        axis equal;
        title({strcat('Difference:',reference_opt{1}, '&monopolar, example. ', num2str(episode_opt))});
    end
        
    % 添加网格线
    grid on;
    axis([0.5, size(grouped_data_value_plot, 2)+0.5, 0.5, size(grouped_data_value_plot, 1)+0.5]);
    
    % 设置网格线的属性
    ax = gca;
    ax.GridColor = [1, 1, 1]; % 设置网格线颜色为白色
    ax.GridAlpha = 0.25; % 设置网格线透明度
    ax1.GridColor = [0, 0, 0]; % 设置网格线颜色为白色
    ax1.GridAlpha = 0.1; % 设置网格线透明度
    
    % 保证网格线与图像像素对齐
    ax.XTick = 0.5:1:size(grouped_data_value_plot, 2);
    ax.YTick = 0.5:1:size(grouped_data_value_plot, 1);
    ax.XTickLabel = [];
    ax.YTickLabel = [];
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    ax.GridLineStyle = '-';
    
    xlabel('Segment index');
    % 设置横纵坐标轴刻度和标签
       
    ax.TitleHorizontalAlignment = 'right';
    set(gca,'linewidth',1,'fontsize',12,'fontname','Arial');
    ax.TickLength = [0.001 0.001];
    
    
end


%% plot eeg signal

figure;
%nexttile;
%subplot(temp+1,1,temp+1);
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


