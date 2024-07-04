%% add path
clc;clear;close all;
addpath ..\data\raw\'PD patient Frontal'\
addpath ..\models\
addpath functions\

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
flag_plot_difference_with_monopolar = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input 1 options, episode: 1, 3, 4                                  %
% input 2 options, reference: 'monopolar', 'bipolar', 'LAR','median' %
% input 3 options, flag_plot_difference_with_monopolar: 1, 0         %
% 120s 2min                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
if flag_plot_difference_with_monopolar == 1
    reference_opt{end+1} = 'monopolar';
end

%%
progressPercent = 0;

for m = 1:length(reference_opt)
    [idx_start,idx_end,dataMat,B] = distinguishInput(episode_opt, reference_opt{m});
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

        progressPercent = 95*(m-1+(counter-30)/(30*num_of_segments_testing))/length(reference_opt);
        updateProgressBar(progressPercent);

    end
    
    x_test = feature';
    
    %% Predicted data
    y_pred = predict(B, x_test);

    %% feature importance
    % plot_feature_importance(B.OOBPermutedPredictorDeltaError);

    grouped_data(m,:,:) = reshape(y_pred, num_of_channels, []);  % 每一列代表一个组，共 30 列
end


%%
plot_difference_pixelGraph(grouped_data,dataMat(idx_start:idx_end,:),num_of_channels,episode_opt,reference_opt);

updateProgressBar(100);



