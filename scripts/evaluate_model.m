clc;clear;close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data sampling rate of 32 kHz, down-sampled to 5 kHz
% In this project, down-sampled from 5 kHz to 128 Hz

% Wavelet
% cd1 2-4
% cd2 4-8
% cd3 8-16
% cd4 16-32
% cd5 32-64
% cd6 64-128
% cd7 128-256
% cd8 256-512

% ca8 512-1024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% add path and parametre setting
addpath ..\data\raw\'PD patient Frontal'\
addpath ..\models\
addpath functions\


%{
% episode 1, 80 seconds
load('episode_1_monopolar.mat');
edf_filename = 'DP14.edf';
idx_start = 1;
idx_end = 90000;
%idx_start = 70001;
%idx_end = 90000;
dataRead = edfread(edf_filename);
dataMat = cell2mat(dataRead{:,:});
%dataMat = monopolar2LAR(dataMat);
%}


% episode 3, 80 seconds
load('episode_3_LAR.mat');
edf_filename = 'DP141.edf';
idx_start = 100001;
idx_end = 120000;
dataRead = edfread(edf_filename);
dataMat = cell2mat(dataRead{:,:});
dataMat = monopolar2LAR(dataMat);



%{
% episode 4, 80 seconds
load('episode_4_LAR.mat');
edf_filename = 'DP142.edf';
idx_start = 204501;
idx_end = 224500;
dataRead = edfread(edf_filename);
dataMat = cell2mat(dataRead{:,:});
dataMat = monopolar2LAR(dataMat);
%}






%dataMat = monopolar2bipolar(dataMat);


fs = 250;
fs_new = 250;
num_of_channels = 30;
overlapping = 0.75;

%%

num_of_segments_testing = floor((idx_end-idx_start+1)/fs_new);


counter = 1;
data=[];
feature=[];
for i = idx_start:fs_new:idx_end
    [P,Q] = rat(fs_new/fs);
    for j = 1:num_of_channels
        EEGdata_temp = dataMat( i : 1000+i,:);
        data = EEGdata_temp(:,j); % Channel
        data = resample(data,P,Q);
        feature(:,counter) = feature_extraction(data);
        counter = counter + 1;
    end
progressPercent = ((counter-30)/(30*num_of_segments_testing))*99;
updateProgressBar(progressPercent);
end

x_test = feature';

%% %%%%%%%%%%%%%%%%
% Predicted data
y_pred = predict(B, x_test);

%% feature importance
featureImportance = B.OOBPermutedPredictorDeltaError;
% 可视化特征重要性
figure;
bar(featureImportance);
xlabel('Feature Index');
ylabel('Out-of-Bag Permuted Predictor Delta Error');
title('Feature Importance');

%% 分segment统计

grouped_data = reshape(y_pred, num_of_channels, []);  % 每一列代表一个组，共 30 列
counts = sum(strcmp(grouped_data, 'Seizure'));  % 统计每个组中 1 出现的次数
counts = [counts; sum(strcmp(grouped_data, 'NonSeizure'))];  % 统计每个组中 2 出现的次数
counts = [counts; sum(strcmp(grouped_data, 'PeriIctalSignals'))];  % 统计每个组中 3 出现的次数

%y_test_segNo = find(~idxTrain == 1);
y_test_segNo = (1:num_of_segments_testing)';



%% 画图
% 创建图形窗口
figure;
% 绘制第一个变量
subplot(2,1,1);
plot(y_test_segNo, counts(1,:), 'r:', 'LineWidth', 2);  % 红色实线
hold on;  % 保持当前图形
plot(y_test_segNo, counts(2,:), 'b:', 'LineWidth', 2); % 绿色虚线
plot(y_test_segNo, counts(3,:), 'm:', 'LineWidth', 2);  % 蓝色点线
xlim([min(y_test_segNo) max(y_test_segNo)]);
% 添加图例
legend('Seizure', 'NonSeizure', 'PeriIctalSignals');
% 添加坐标轴标签和标题
xlabel('Segment index');
ylabel('Number of channels');
title(' ');

grid on;
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx_segment_plot_start = min(y_test_segNo);
idx_segment_plot_end = max(y_test_segNo);

EEGdataplot = [];
EEGdataplot = dataMat(idx_start:idx_end,:);


set(gca,'linewidth',1,'fontsize',12,'fontname','Arial');

subplot(2,1,2);
% 定义偏移量，避免信号重叠
offset = 100;
% 遍历每个通道并绘制
hold on;
%for i = 24
for i = 1:num_of_channels
    plot(EEGdataplot(:, i) + (i-1) * offset);
end
hold off;

% 添加标签和标题
xlabel('Samples');
ylabel('Amplitude');
title([' ']);
grid on;

xlim([1,length(EEGdataplot)]);
ylim([-offset, (num_of_channels-1) * offset + offset]);
set(gca,'linewidth',1,'fontsize',12,'fontname','Arial');

updateProgressBar(100);





