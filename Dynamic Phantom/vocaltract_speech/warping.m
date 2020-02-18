% Spatially warping on the vertex of contours
%
% ZYH, 06/16/2011

load data

num = length(data.interpolation.nontongue); % number of frames

% nontongue
nontonguetable = zeros(length(data.interpolation.nontongue{1}), num);

nontonguetable(:,1) = data.interpolation.nontongue{1};

for n = 2:num
    nontonguetable(:,n) = DTW(nontonguetable(:,n-1), data.interpolation.nontongue{n});
end

data.warping.nontongue = nontonguetable;

% tongue
tonguetable = zeros(length(data.interpolation.tongue{1}), num);

tonguetable(:,1) = data.interpolation.tongue{1};

for n = 2:num
    tonguetable(:,n) = DTW(tonguetable(:,n-1), data.interpolation.tongue{n});
end

data.warping.tongue = tonguetable;

save data data