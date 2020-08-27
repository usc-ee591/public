function [cmaps] = coilsense_maps(im)
% Input:
%       im: full resolution + fullly sampled image (nx, ny, nc)
%       smoothing factor: # of pixels of binomial smoothing, 0 = no smoothing)

% Output:
%       cmaps: estimated coil sensitivity map (nx, ny, nc)


rsos = sqrt( sum( abs(im).^2,3 ) );

for index = 1:size(im,3)
  cmaps(:,:,index) = im(:,:,index) ./ rsos;
end
end