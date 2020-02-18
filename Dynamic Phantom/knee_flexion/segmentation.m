% Segmentation of the frames 195:15:285 into different knee areas
%
% ZYH, 02/02/2013

% load the data except for the first segmentation
load data

readerobj = VideoReader('knee.avi');
vidFrames = read(readerobj);

[height width] = size(vidFrames(:,:,1,1));

% n is 195:15:285, {195, 210, 225} {240} {255} {270, 285} need individual segmentation
n = 230;

% segmentation, vertex in (x,y,), control the vertex number for velum to be 10
[BW,x,y] = roipoly(vidFrames(:,:,:,n)*3);
x(end) = [];
y(end) = [];

% segment counterclockwisely
% part 1: front surface
data.segmentation.fsurface{6} = (x-width/2) + 1i*(height/2-y);

% part 2: patella
% data.segmentation.patella{6} = (x-width/2) + 1i*(height/2-y);

% part 3: pad
% data.segmentation.pad{6} = (x-width/2) + 1i*(height/2-y);

% part 4: front fat
% data.segmentation.ffat{6} = (x-width/2) + 1i*(height/2-y);

% part 5: femur
% data.segmentation.femur{6} = (x-width/2) + 1i*(height/2-y);

% part 6: tibia
% data.segmentation.tibia{6} = (x-width/2) + 1i*(height/2-y);

% part 7: back meniscus
% data.segmentation.bmeniscus{6} = (x-width/2) + 1i*(height/2-y);

% part 8: back surface
% data.segmentation.bsurface{6} = (x-width/2) + 1i*(height/2-y);

save data data