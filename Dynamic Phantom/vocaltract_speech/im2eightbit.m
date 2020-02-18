% image 2 8-bit image
% output is uint8
% 
% Modified by ZYH, 8/11/2010

function im_8bit = im2eightbit(im_mag, maximum, minimum)

if islogical(im_mag)
   im_8bit = zeros(size(im_mag));
   im_8bit(im_mag == 1) = minimum;
   im_8bit(im_mag == 0) = maximum;
elseif max(im_mag(:))-min(im_mag(:)) == 0
    im_8bit(:) = 0; 
else
    im_8bit = uint8((im_mag-min(im_mag(:)))/(max(im_mag(:))-min(im_mag(:)))*(maximum-minimum));
end