clc;clear;close all;

%% add path and parametre setting
addpath ..\data\processed\monopolar\
addpath functions\

% EEGdata 1000x30

a = [1 4 7  ;
     2 8 8  ;
     3 12 9  ;
     4 19 10 ];


b=Zscore_normalization (a);