function reshape_im = reshape_Image(im)
% Input:   Multi_coil Image im

% output:  Reshaped image reshape_im

% This function takes a multicoil image 'im' and reshape it to form a 2D
% matrix which displays all coil images.

[nx ny nc] = size(im);
reshape_im = reshape(im, [],ny*nc);
end