function [idx_start,idx_end,dataMat,B] = distinguishInput(episode, reference)
%DISTINGUISHINPUT Summary of this function goes here
%   Detailed explanation goes here

episode_num = 3;

switch episode
    case 1
        disp("Case 1: Using DP14.edf as a test dataset"); episode_idx = 1;
        edf_filename = 'DP14.edf';
        idx_start = 60001;
        idx_end = 90000;
        dataRead = edfread(edf_filename);
        dataMat = cell2mat(dataRead{:,:});
    case 3
        disp("Case 2: Using DP141.edf as a test dataset"); episode_idx = 2;
        edf_filename = 'DP141.edf';
        idx_start = 85001;
        idx_end = 115000;
        dataRead = edfread(edf_filename);
        dataMat = cell2mat(dataRead{:,:});
    case 4
        disp("Case 3: Using DP142.edf as a test dataset"); episode_idx = 3;
        edf_filename = 'DP142.edf';
        idx_start = 194501;
        idx_end = 224500;
        dataRead = edfread(edf_filename);
        dataMat = cell2mat(dataRead{:,:});
    otherwise
        output = 'Invalid case number input. Please select a valid option.';
end


switch reference
    case 'monopolar'
        disp("You have selected monopolar reference"); reference_idx = 1;
    case 'bipolar'
        disp("You have selected bipolar reference"); reference_idx = 2;
        dataMat = monopolar2bipolar(dataMat);
    case 'LAR'
        disp("You have selected LAR reference"); reference_idx = 3;
        dataMat = monopolar2LAR(dataMat);
    case 'median'
        disp("You have selected median reference"); reference_idx = 4;
        dataMat = monopolar2median(dataMat);
    otherwise
        output = 'Invalid reference input. Please select a valid option.';
end


filename = {'episode_1_monopolar.mat', 'episode_1_bipolar.mat', 'episode_1_LAR.mat', 'episode_1_median.mat', ...
            'episode_3_monopolar.mat', 'episode_3_bipolar.mat', 'episode_3_LAR.mat', 'episode_3_median.mat', ...
            'episode_4_monopolar.mat', 'episode_4_bipolar.mat', 'episode_4_LAR.mat', 'episode_4_median.mat'};

load(filename{episode_idx*(episode_num-1)+reference_idx});

end

