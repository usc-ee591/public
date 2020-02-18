% find out the frames of interested..
%
% ZYH, 02/02/2013

readerobj = VideoReader('knee.avi');
vidFrames = read(readerobj);
numFrames = get(readerobj, 'NumberOfFrames');

step  = 15;
start = 180;
for n_loop = 0:14
    subplot(3,5,n_loop+1), imshow(vidFrames(:,:,:,start+step*n_loop));
    title(['frame: ' num2str(start+step*n_loop)]);
end