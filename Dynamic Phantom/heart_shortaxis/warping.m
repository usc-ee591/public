% Spatially warping on the vertex of contours
%
% ZYH, 01/24/2013

load data

num = length(data.extending.curve1); % number of frames

% curve1
curve1table = zeros(length(data.extending.curve1{1}), num);
curve1table(:,1) = data.extending.curve1{1};
for n = 2:num
    curve1table(:,n) = DTW(curve1table(:,n-1), data.extending.curve1{n});
end
data.warping.curve1 = curve1table;

% curve2
curve2table = zeros(length(data.extending.curve2{1}), num);
curve2table(:,1) = data.extending.curve2{1};
for n = 2:num
    curve2table(:,n) = DTW(curve2table(:,n-1), data.extending.curve2{n});
end
data.warping.curve2 = curve2table;

% curve3
curve3table = zeros(length(data.extending.curve3{1}), num);
curve3table(:,1) = data.extending.curve3{1};
for n = 2:num
    curve3table(:,n) = DTW(curve3table(:,n-1), data.extending.curve3{n});
end
data.warping.curve3 = curve3table;

% curve4
curve4table = zeros(length(data.extending.curve4{1}), num);
curve4table(:,1) = data.extending.curve4{1};
for n = 2:num
    curve4table(:,n) = DTW(curve4table(:,n-1), data.extending.curve4{n});
end
data.warping.curve4 = curve4table;

% curve5
curve5table = zeros(length(data.extending.curve5{1}), num);
curve5table(:,1) = data.extending.curve5{1};
for n = 2:num
    curve5table(:,n) = DTW(curve5table(:,n-1), data.extending.curve5{n});
end
data.warping.curve5 = curve5table;

% curve6
curve6table = zeros(length(data.extending.curve6{1}), num);
curve6table(:,1) = data.extending.curve6{1};
for n = 2:num
    curve6table(:,n) = DTW(curve6table(:,n-1), data.extending.curve6{n});
end
data.warping.curve6 = curve6table;

% curve7
curve7table = zeros(length(data.extending.curve7{1}), num);
curve7table(:,1) = data.extending.curve7{1};
for n = 2:num
    curve7table(:,n) = DTW(curve7table(:,n-1), data.extending.curve7{n});
end
data.warping.curve7 = curve7table;

% curve8
curve8table = zeros(length(data.extending.curve8{1}), num);
curve8table(:,1) = data.extending.curve8{1};
for n = 2:num
    curve8table(:,n) = DTW(curve8table(:,n-1), data.extending.curve8{n});
end
data.warping.curve8 = curve8table;

% curve9
curve9table = zeros(length(data.extending.curve9{1}), num);
curve9table(:,1) = data.extending.curve9{1};
for n = 2:num
    curve9table(:,n) = DTW(curve9table(:,n-1), data.extending.curve9{n});
end
data.warping.curve9 = curve9table;

% curve10
curve10table = zeros(length(data.extending.curve10{1}), num);
curve10table(:,1) = data.extending.curve10{1};
for n = 2:num
    curve10table(:,n) = DTW(curve10table(:,n-1), data.extending.curve10{n});
end
data.warping.curve10 = curve10table;

% curve11
curve11table = zeros(length(data.extending.curve11{1}), num);
curve11table(:,1) = data.extending.curve11{1};
for n = 2:num
    curve11table(:,n) = DTW(curve11table(:,n-1), data.extending.curve11{n});
end
data.warping.curve11 = curve11table;

% curve12
curve12table = zeros(length(data.extending.curve12{1}), num);
curve12table(:,1) = data.extending.curve12{1};
for n = 2:num
    curve12table(:,n) = DTW(curve12table(:,n-1), data.extending.curve12{n});
end
data.warping.curve12 = curve12table;

% curve13
curve13table = zeros(length(data.extending.curve13{1}), num);
curve13table(:,1) = data.extending.curve13{1};
for n = 2:num
    curve13table(:,n) = DTW(curve13table(:,n-1), data.extending.curve13{n});
end
data.warping.curve13 = curve13table;

% curve14
curve14table = zeros(length(data.extending.curve14{1}), num);
curve14table(:,1) = data.extending.curve14{1};
for n = 2:num
    curve14table(:,n) = DTW(curve14table(:,n-1), data.extending.curve14{n});
end
data.warping.curve14 = curve14table;

% curve15
curve15table = zeros(length(data.extending.curve15{1}), num);
curve15table(:,1) = data.extending.curve15{1};
for n = 2:num
    curve15table(:,n) = DTW(curve15table(:,n-1), data.extending.curve15{n});
end
data.warping.curve15 = curve15table;

% curve16
curve16table = zeros(length(data.extending.curve16{1}), num);
curve16table(:,1) = data.extending.curve16{1};
for n = 2:num
    curve16table(:,n) = DTW(curve16table(:,n-1), data.extending.curve16{n});
end
data.warping.curve16 = curve16table;

% curve17
curve17table = zeros(length(data.extending.curve17{1}), num);
curve17table(:,1) = data.extending.curve17{1};
for n = 2:num
    curve17table(:,n) = DTW(curve17table(:,n-1), data.extending.curve17{n});
end
data.warping.curve17 = curve17table;

% curve18
curve18table = zeros(length(data.extending.curve18{1}), num);
curve18table(:,1) = data.extending.curve18{1};
for n = 2:num
    curve18table(:,n) = DTW(curve18table(:,n-1), data.extending.curve18{n});
end
data.warping.curve18 = curve18table;

% curve19
curve19table = zeros(length(data.extending.curve19{1}), num);
curve19table(:,1) = data.extending.curve19{1};
for n = 2:num
    curve19table(:,n) = DTW(curve19table(:,n-1), data.extending.curve19{n});
end
data.warping.curve19 = curve19table;

save data data