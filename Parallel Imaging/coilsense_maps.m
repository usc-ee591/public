function [cmaps] = coilsense_maps(im, smoothing_factor)
% Input:
%       im: full resolution + fullly sampled image (nx, ny, nc)
%       smoothing factor: # of pixels of binomial smoothing, 0 = no smoothing)

% Output:
%       cmaps: estimated coil sensitivity map (nx, ny, nc)


if (isempty(smoothing_factor)~=1) 
    smoothing_factor = 0; 
end

% low-pass filtering (smoothing) onto coil map and and images from all channels 
if (smoothing_factor > 0)
  % Generate filter
  sfilt = [1];

  for index=1:smoothing_factor  
        sfilt=filter2(sfilt,ones(2),'full'); 
  end

  % Smooth numerator of coil map
  for index=1:size(im, 3)
        im(:, :, index) = filter2(sfilt, im(:,:,index), 'same');
  end

end

rsos = sqrt( sum( abs(im).^2,3 ) );

for index = 1:size(im,3)
  cmaps(:,:,index) = im(:,:,index) ./ rsos;
end
