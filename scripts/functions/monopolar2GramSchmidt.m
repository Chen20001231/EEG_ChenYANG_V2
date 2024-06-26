function [EEGdata_out] = monopolar2GramSchmidt(EEGdata_in)
%MONOPOLAR2GRAMSCHMIDT Summary of this function goes here
%   Detailed explanation goes here

RS_LS = GramSchmidt(EEGdata_in(:,1:10));
LTh_RTh = GramSchmidt(EEGdata_in(:,11:14));
LFS = GramSchmidt(EEGdata_in(:,15:22));
RFS = GramSchmidt(EEGdata_in(:,23:30));
    
EEGdata_out = [RS_LS, LTh_RTh, LFS, RFS];


end

