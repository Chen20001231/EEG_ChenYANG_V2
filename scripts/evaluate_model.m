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


episode_opt = 3;
reference_opt = 'median';
% input 1 options, episode: 1, 3, 4
% input 2 options, reference: 'monopolar', 'bipolar', 'LAR','median'
% 120s 2min
[idx_start,idx_end,dataMat,B] = distinguishInput(episode_opt, reference_opt);


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

%%
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

plot_lineGraph(grouped_data,dataMat(idx_start:idx_end,:),num_of_channels,episode_opt,reference_opt);
plot_lineGraph_withPartition(grouped_data,dataMat(idx_start:idx_end,:),num_of_channels,episode_opt,reference_opt);
plot_pixelGraph(grouped_data,dataMat(idx_start:idx_end,:),num_of_channels,episode_opt,reference_opt);
% plot_plot3(grouped_data,dataMat(idx_start:idx_end,:),num_of_channels);

updateProgressBar(100);



