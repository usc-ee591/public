% find out the frames of interested..
%
% ZYH, 02/02/2013

readerobj = VideoReader('shortaxis_ssfp.avi');
vidFrames = read(readerobj);
numFrames = get(readerobj, 'NumberOfFrames');

step  = 15;
start = 90;
figure(1);
for n_loop = 0:26
    subplot(3,9,n_loop+1), imshow(vidFrames(:,:,:,start+step*n_loop));
    title(['frame: ' num2str(start+step*n_loop)]);
end

% show movie
step  = 15;
start = 90;
figure(2);
% for n_loop = [0 4 8 11 15 19 23 27]
for n_loop = [0:3 4:14 0:3 0:3 0:3]
    imshow(vidFrames(:,:,:,start+step*n_loop));
    title(['frame: ' num2str(start+step*n_loop)]);
    pause(1);
end

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