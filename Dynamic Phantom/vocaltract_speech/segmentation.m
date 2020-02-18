% Segmentation of the frames 241~370 into hardwall and tongue
% hardwall is static except velum, tongue is dynamic
%
% Could resegment some frames to improve the phantom quality
%
% ZYH, 06/15/2011

% load data, except for the first frame
load data

avifile = mmreader('lac08152010_06_39_06.avi');
frames = read(avifile); 
[height width] = size(frames(:,:,1,1));

% n from 241 to 370, manually change
n = 336;

% segmentation, vertex in (x,y,), control the vertex number for velum to be 10
[BW,x,y] = roipoly(frames(:,:,1,n));
x(end) = [];
y(end) = [];

% hardwall (run each part sequentially and individually)
% Part A
% data.segmentation.hardwall = (x-width/2-.5) + i*(height/2+.5-y); % once only
% Part B
% data.segmentation.nontongue{n-240} = cat(1,data.segmentation.hardwall,(x-width/2-.5) + i*(height/2+.5-y));

% tongue
data.segmentation.tongue{n-240} = (x-width/2) + i*(height/2-y);

save data data