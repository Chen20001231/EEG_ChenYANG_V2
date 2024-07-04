%% add path
clc;clear;close all;
addpath functions\
addpath ..\data\processed\monopolar\
%% parameters
fs = 250;
fs_new = 250;
num_of_channels = 30;
overlapping = 0.75;

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

%%
episode_opt = 3;
reference_opt = {'median'};
flag_normalization = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input 1 options, episode: 1, 3, 4                                  %
% input 2 options, reference: 'monopolar', 'bipolar', 'LAR','median' %
% input 3 options, flag_plot_difference_with_monopolar: 1, 0         %
% 120s 2min                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





switch episode_opt
    case 1
        idx_testing_data_begin = 1;
        idx_testing_data_end = 47;
    case 3
        idx_testing_data_begin = 97;
        idx_testing_data_end = 151;
    case 4
        idx_testing_data_begin = 152;
        idx_testing_data_end = 168;
    otherwise
        disp("ERR: episode selection")
end




%% Start
counter = 1;
excel_table = readtable('0_segments.xlsx');
num_of_segments = height(excel_table);




%% Start to extract features
updateProgressBar(0);
for i = 1:num_of_segments
    % load data
    filename = ['x', num2str(i), '.mat'];
    load(filename);


    switch reference_opt{1}
    case 'monopolar'
        a=1;
    case 'bipolar'
        EEGdata = monopolar2bipolar(EEGdata);
    case 'LAR'
        EEGdata = monopolar2LAR(EEGdata);
    case 'median'
        EEGdata = monopolar2median(EEGdata);
    otherwise
        %EEGdata = 10000*monopolar2GramSchmidt(EEGdata);
        output = 'Invalid reference input. Please select a valid option.';
        EEGdata=1;
    end


    if flag_normalization == 1
        EEGdata = Zscore_normalization(EEGdata);
    end
      
    % change sampling frequency
    [P,Q] = rat(fs_new/fs);
    for j = 1:num_of_channels
        data = EEGdata(:,j); % Channel
        data = resample(data,P,Q);
        % feature extraction
        feature(:,counter) = feature_extraction(data);
        counter = counter + 1;
    end







progressPercent = (i/num_of_segments)*90;
updateProgressBar(progressPercent);
end

%% add label
x = feature';
y = string(excel_table.Category);
y = repelem(y, num_of_channels); % 将数组的每个元素重复 30 次

%% Partition data for cross-validation

% Manual selection of training and test sets
idxTrain = ones(num_of_segments, 1);
idxTrain(idx_testing_data_begin:idx_testing_data_end) = 0;
idxTrain = logical(idxTrain);
extended_idxTrain = repelem(idxTrain, num_of_channels); % 将数组的每个元素重复 30 次

x_train = x(extended_idxTrain,:);
y_train = y(extended_idxTrain,:);



%% Visualise two of the generated decision trees.

% Define Bagging Parameters
numTrees = 50; % Set number of trees
opts = statset('UseParallel',true); % Parallel computing
    
% Use decision trees
B = TreeBagger(numTrees, x_train, y_train, 'Method', 'classification', 'Options', opts,'OOBPredictorImportance', 'on');
% B = TreeBagger(numTrees, x_train, y_train, 'Method', 'classification', 'Options', opts, 'MaxNumSplits', 5);


      

savepath = '..\models\'; 

switch reference_opt{1}
case 'monopolar'
    savename = ['episode_',num2str(episode_opt),'_monopolar'];
case 'bipolar'
    savename = ['episode_',num2str(episode_opt),'_bipolar'];
case 'LAR'
    savename = ['episode_',num2str(episode_opt),'_LAR'];
case 'median'
    savename = ['episode_',num2str(episode_opt),'_median'];
otherwise
    %EEGdata = 10000*monopolar2GramSchmidt(EEGdata);
    %savename = ['episode_',num2str(1),'_GramSchmidt'];
    output = 'Invalid reference input. Please select a valid option.';
end

if flag_normalization == 1
    savename = [savename,'_ZscoreNormalized'];
end

% 将表格写入Excel文件
save(fullfile(savepath, savename), "B");

%% feature importance
featureImportance = B.OOBPermutedPredictorDeltaError;
% 可视化特征重要性
figure;
bar(featureImportance);
xlabel('Feature Index');
ylabel('Out-of-Bag Permuted Predictor Delta Error');
title('Feature Importance');

updateProgressBar(100);

