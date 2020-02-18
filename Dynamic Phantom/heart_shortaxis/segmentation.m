% decided use frame
% [90, 105, 120, 135, 150, 165, 180, 195, 210, 225, 240, 260(not 255), 270,
% 285, 300, 315, 330, 345, 360, 375, 390, 405, 420, 435, 450, 465, 480];
%
% the whole sequence is a cycle for breeth+heartbeat
% [90, 105, 120, 135], [150, 165, 180, 195], [210, 225, 240],
% [260, 270, 285, 300], [315, 330, 345, 360], [375, 390, 405, 420],
% [435, 450, 465, 480] are 7 heart beat cycle
%
% the result phantom sequence will be
% [90, 105, 120, 135, 150, 165, 180, 195, 210, 225, 240, 260(not 255), 270,
% 285, 300] + [90, 105, 120, 135] * 3
%
% need to do segmentation on 15 frames
%
% ZYH, 01/22/2013

% load the dataexcept for the first segmentation
load data

readerobj = VideoReader('shortaxis_ssfp.avi');
vidFrames = read(readerobj);

[height width] = size(vidFrames(:,:,1,1));

% manually change frame number
n = 300;

% segmentation, vertex in (x,y,), control the vertex number for velum to be 10
[BW,x,y] = roipoly(vidFrames(:,:,:,n));
x(end) = [];
y(end) = [];

% curve18: right lower vessle
data.segmentation.curve19{15} = (x-width/2) + 1i*(height/2-y);

% curve18: right upper vessle
% data.segmentation.curve18{15} = (x-width/2) + 1i*(height/2-y);

% curve17: inside RV
% data.segmentation.curve17{15} = (x-width/2) + 1i*(height/2-y);

% curve16: down outside RV
% data.segmentation.curve16{15} = (x-width/2) + 1i*(height/2-y);

% curve15: left outside RV (overlap with curve14 except (1)(5)(9)(12)
% data.segmentation.curve15{15} = (x-width/2) + 1i*(height/2-y);

% curve14: left background (overlap with curve15 except (1)(5)(9)(12)
% data.segmentation.curve14{15} = (x-width/2) + 1i*(height/2-y);

% curve13: up outside RV
% data.segmentation.curve13{15} = (x-width/2) + 1i*(height/2-y);

% curve12: right outside RV
% data.segmentation.curve12{15} = (x-width/2) + 1i*(height/2-y);

% curve11: up background
% data.segmentation.curve11{15} = (x-width/2) + 1i*(height/2-y);

% curve10: left outside LV
% data.segmentation.curve10{15} = (x-width/2) + 1i*(height/2-y);

% curve9: up outside LV
% data.segmentation.curve9{15} = (x-width/2) + 1i*(height/2-y);

% curve8: right outside LV
% data.segmentation.curve8{15} = (x-width/2) + 1i*(height/2-y);

% curve7: inside LV
% data.segmentation.curve7{15} = (x-width/2) + 1i*(height/2-y);

% curve6: down inside vessle
% data.segmentation.curve6{15} = (x-width/2) + 1i*(height/2-y);

% curve5: up inside vessle
% data.segmentation.curve5{15} = (x-width/2) + 1i*(height/2-y);

% curve4: right vessle
% data.segmentation.curve4{15} = (x-width/2) + 1i*(height/2-y);

% curve3: right tissue
% data.segmentation.curve3{15} = (x-width/2) + 1i*(height/2-y);

% curve2: left vessle
% data.segmentation.curve2{15} = (x-width/2) + 1i*(height/2-y);

% curve1: chest
% data.segmentation.curve1{15} = (x-width/2) + 1i*(height/2-y);

save data data