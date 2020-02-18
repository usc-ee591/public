% Copy data for second half of the cycle
%
% ZYH 01/21/2013

load data
frameno = 7;    % 7 frames => 13 frames
for n = 1:frameno-1
    data.interpolation.fsurface{ frameno*2 - n} = data.interpolation.fsurface{n};
    data.interpolation.patella{ frameno*2 - n} = data.interpolation.patella{n};
    data.interpolation.pad{ frameno*2 - n} = data.interpolation.pad{n};
    data.interpolation.ffat{ frameno*2 - n} = data.interpolation.ffat{n};
    data.interpolation.femur{ frameno*2 - n} = data.interpolation.femur{n};
    data.interpolation.tibia{ frameno*2 - n} = data.interpolation.tibia{n};
    data.interpolation.bmeniscus{ frameno*2 - n} = data.interpolation.bmeniscus{n};
    data.interpolation.bsurface{ frameno*2 - n} = data.interpolation.bsurface{n};
end

save data data