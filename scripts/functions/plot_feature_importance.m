function [] = plot_feature_importance(OOBPermutedPredictorDeltaError)
%PLOT_FEATURE_IMPORTANCE Summary of this function goes here
%   Detailed explanation goes here

%% feature importance
featureImportance = OOBPermutedPredictorDeltaError;
% 可视化特征重要性
figure;
bar(featureImportance);
xlabel('Feature Index');
ylabel('Out-of-Bag Permuted Predictor Delta Error');
title('Feature Importance');

end

