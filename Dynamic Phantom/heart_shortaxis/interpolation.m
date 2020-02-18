% Interpolation in the frame, to increase the number of vertex on the
% boundary, and make the boundary smooth
% 2X interpolation on the velum and the tongue
%
% 2X interpolation is shown to be sufficient
%
% ZYH 01/24/2013

load data

for n = 1:length(data.segmentation.curve1)     % 315 frames
    % curve1 interpolation
    y = data.segmentation.curve1{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve1{n} = yi.';
    
    % curve2 interpolation
    y = data.segmentation.curve2{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve2{n} = yi.';
    
    % curve3 interpolation
    y = data.segmentation.curve3{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/10:ptno;       % intentionally incresed
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve3{n} = yi.';
    
    % curve4 interpolation
    y = data.segmentation.curve4{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve4{n} = yi.';
    
    % curve5 interpolation
    y = data.segmentation.curve5{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve5{n} = yi.';
    
    % curve6 interpolation
    y = data.segmentation.curve6{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve6{n} = yi.';
    
    % curve7 interpolation
    y = data.segmentation.curve7{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve7{n} = yi.';
    
    % curve8 interpolation
    y = data.segmentation.curve8{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve8{n} = yi.';
    
    % curve9 interpolation
    y = data.segmentation.curve9{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve9{n} = yi.';
    
    % curve10 interpolation
    y = data.segmentation.curve10{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve10{n} = yi.';
    
    % curve11 interpolation
    y = data.segmentation.curve11{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve11{n} = yi.';
    
    % curve12 interpolation
    y = data.segmentation.curve12{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve12{n} = yi.';
    
    % curve13 interpolation
    y = data.segmentation.curve13{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve13{n} = yi.';
    
    % curve14 interpolation
    y = data.segmentation.curve14{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve14{n} = yi.';
    
    % curve15 interpolation
    y = data.segmentation.curve15{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve15{n} = yi.';
    
    % curve16 interpolation
    y = data.segmentation.curve16{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve16{n} = yi.';
    
    % curve17 interpolation
    y = data.segmentation.curve17{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve17{n} = yi.';
    
    % curve18 interpolation
    y = data.segmentation.curve18{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve18{n} = yi.';
    
    % curve19 interpolation
    y = data.segmentation.curve19{n};
    ptno = length(y);
    x = 1:ptno;
    xi = 1:1/2:ptno;
    yi = interp1(x,y,xi,'pchip');
    data.interpolation.curve19{n} = yi.';

end

save data data