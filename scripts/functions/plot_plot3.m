function [] = plot_plot3(grouped_data,EEGdataplot,num_of_channels)
%PLOT_LINEGRAPH Summary of this function goes here
%   Detailed explanation goes here
figure();

partition_num = [10, 4, 8 ,8];
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


for i = 1:numRows
    x = 1:numCols;
    y = i * ones(1,numCols);
    z = grouped_data_value(i,:);
    
    plot3(x, y, z, 'LineWidth',1.5);
    grid on;
    hold on
end


%{
temp = 0;
for j = 1:length(partition_num)
    subplot(length(partition_num)+1,1,j);
    for i = 1+temp:partition_num(j)+temp
        x = 1:numCols;
        y = i * ones(1,numCols);
        z = grouped_data_value(i,:);
        
        plot3(x, y, z, 'LineWidth',1.5);
        grid on;
        hold on
    end
end
%}



hold off
end

