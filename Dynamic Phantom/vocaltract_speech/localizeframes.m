% Check the range of the frame to be segment
% Decided range is 241~370
%
% ZYH, 06/15/2011

avifile = mmreader('lac08152010_06_39_06.avi');
frames = read(avifile);

for n = 241:370
    imshow(frames(:,:,:,n));
    pause(.1);
end