% Spatially warping on the vertex of polygons
%
% ZYH, 01/21/2013

load data

num = length(data.interpolation.pad); % number of frames

% fsurface
fsurfacetable = zeros(length(data.interpolation.fsurface{1}), num);
fsurfacetable(:,1) = data.interpolation.fsurface{1};
for n = 2:num
    fsurfacetable(:,n) = DTW(fsurfacetable(:,n-1), data.interpolation.fsurface{n});
end
data.warping.fsurface = fsurfacetable;

% patella
patellatable = zeros(length(data.interpolation.patella{1}), num);
patellatable(:,1) = data.interpolation.patella{1};
for n = 2:num
    patellatable(:,n) = DTW(patellatable(:,n-1), data.interpolation.patella{n});
end
data.warping.patella = patellatable;

% pad
padtable = zeros(length(data.interpolation.pad{1}), num);
padtable(:,1) = data.interpolation.pad{1};
for n = 2:num
    padtable(:,n) = DTW(padtable(:,n-1), data.interpolation.pad{n});
end
data.warping.pad = padtable;

% ffat
ffattable = zeros(length(data.interpolation.ffat{1}), num);
ffattable(:,1) = data.interpolation.ffat{1};
for n = 2:num
    ffattable(:,n) = DTW(ffattable(:,n-1), data.interpolation.ffat{n});
end
data.warping.ffat = ffattable;

% femur
femurtable = zeros(length(data.interpolation.femur{1}), num);
femurtable(:,1) = data.interpolation.femur{1};
for n = 2:num
    femurtable(:,n) = DTW(femurtable(:,n-1), data.interpolation.femur{n});
end
data.warping.femur = femurtable;

% tibia
tibiatable = zeros(length(data.interpolation.tibia{1}), num);
tibiatable(:,1) = data.interpolation.tibia{1};
for n = 2:num
    tibiatable(:,n) = DTW(tibiatable(:,n-1), data.interpolation.tibia{n});
end
data.warping.tibia = tibiatable;

% bmeniscus
bmeniscustable = zeros(length(data.interpolation.bmeniscus{1}), num);
bmeniscustable(:,1) = data.interpolation.bmeniscus{1};
for n = 2:num
    bmeniscustable(:,n) = DTW(bmeniscustable(:,n-1), data.interpolation.bmeniscus{n});
end
data.warping.bmeniscus = bmeniscustable;

% bsurface
bsurfacetable = zeros(length(data.interpolation.bsurface{1}), num);
bsurfacetable(:,1) = data.interpolation.bsurface{1};
for n = 2:num
    bsurfacetable(:,n) = DTW(bsurfacetable(:,n-1), data.interpolation.bsurface{n});
end
data.warping.bsurface = bsurfacetable;

save data data