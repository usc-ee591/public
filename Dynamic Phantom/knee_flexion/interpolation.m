% Interpolation in the frame, to increase the number of vertex on the
% boundary, and make the boundary smooth
% 2X interpolation on the velum and the tongue
%
% 2X interpolation is shown to be sufficient
%
% ZYH 01/21/2013

load data

for n = 1:length(data.segmentation.pad)     % 7 frames
    % fsurface interpolation
    y = data.segmentation.fsurface{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.fsurface{n} = yi.';
    
    % patella interpolation
    y = data.segmentation.patella{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.patella{n} = yi.';
    
    % pad interpolation
    y = data.segmentation.pad{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.pad{n} = yi.';
    
    % ffat interpolation
    y = data.segmentation.ffat{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.ffat{n} = yi.';
    
    % femur interpolation
    y = data.segmentation.femur{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/10:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.femur{n} = yi.';
    
    % tibia interpolation
    y = data.segmentation.tibia{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/10:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.tibia{n} = yi.';
    
    % bmeniscus interpolation
    y = data.segmentation.bmeniscus{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.bmeniscus{n} = yi.';
    
    % bsurface interpolation
    y = data.segmentation.bsurface{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.bsurface{n} = yi.';
end

save data data