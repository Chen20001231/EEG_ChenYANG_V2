function [EEG_norm_zscore] = Zscore_normalization(EEG)
%ZSCORE_NORMALIZATION Summary of this function goes here
%   Detailed explanation goes here

% Standardization Z-score Normalization

% 均值-标准差归一化
EEG_mean = mean(EEG);
EEG_std = std(EEG);
EEG_norm_zscore = (EEG - EEG_mean) ./ EEG_std;

end

