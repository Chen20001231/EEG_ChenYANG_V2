function [EEGdata_out] = monopolar2bipolar(EEGdata_in)
%MONOPOLAR2BIPOLAR Summary of this function goes here
%   Detailed explanation goes here
groups = [10, 4, 8, 8];

temp = 0;
for a = temp+1:temp+groups(1)
    if a == groups(1)
        RS_LS(:,a) = EEGdata_in(:,1)-EEGdata_in(:,a);
    else
        RS_LS(:,a) = EEGdata_in(:,a+1)-EEGdata_in(:,a);
    end
end
temp = groups(1);

for b = temp+1 : temp+groups(2)
    if b == (temp+groups(2))
        LTh_RTh(:,b) = EEGdata_in(:,temp+1)-EEGdata_in(:,b);
    else
        LTh_RTh(:,b) = EEGdata_in(:,b+1)-EEGdata_in(:,b);
    end
end
temp = groups(1)+groups(2);

for c = temp+1 : temp+groups(3)
    if c == (temp+groups(3))
        LFS(:,c) = EEGdata_in(:,temp+1)-EEGdata_in(:,c);
    else
        LFS(:,c) = EEGdata_in(:,c+1)-EEGdata_in(:,c);
    end
end
temp = groups(1)+groups(2)+groups(3);

for d = temp+1 : temp+groups(4)
    if d == (temp+groups(4))
        RFS(:,d) = EEGdata_in(:,temp+1)-EEGdata_in(:,d);
    else
        RFS(:,d) = EEGdata_in(:,d+1)-EEGdata_in(:,d);
    end
end


EEGdata_out = [RS_LS(:,1:groups(1)), LTh_RTh(:,groups(1)+1:groups(1)+groups(2)),...
    LFS(:,groups(1)+groups(2)+1:groups(1)+groups(2)+groups(3)),...
    RFS(:,groups(1)+groups(2)+groups(3)+1:groups(1)+groups(2)+groups(3)+groups(4))];

end

