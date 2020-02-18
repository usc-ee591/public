% Interpolation in the frame, to increase the number of vertex on the
% boundary, and make the boundary smooth
% 2X interpolation on the velum and the tongue
%
% 2X interpolation is shown to be sufficient
%
% ZYH 06/16/2011

load data

for n = 1:130
    % nontongue interpolation
    y = data.segmentation.nontongue{n};
    ptno = length(y);
    x = 1:10;   % only 10 samples on the velum
    xi = 1:1/2:10;
    yi = interp1(x,y(ptno-9:ptno),xi,'pchip');
    data.interpolation.nontongue{n} = [y(1:ptno-10); yi.'];
    
    % tongue interpolation
    y = data.segmentation.tongue{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.tongue{n} = yi.';
end

save data data