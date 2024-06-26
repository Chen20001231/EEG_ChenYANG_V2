function [EEGdata_out] = monopolar2median(EEGdata_in)
%MONOPOLAR2LAR Summary of this function goes here
%   Detailed explanation goes here



RS_LS = EEGdata_in(:,1:10)-median(EEGdata_in(:,1:10),2);
LTh_RTh = EEGdata_in(:,11:14)-median(EEGdata_in(:,11:14),2);
LFS = EEGdata_in(:,15:22)-median(EEGdata_in(:,15:22),2);
RFS = EEGdata_in(:,23:30)-median(EEGdata_in(:,23:30),2);
    
EEGdata_out = [RS_LS, LTh_RTh, LFS, RFS];
end

