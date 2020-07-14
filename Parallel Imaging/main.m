clear all; close all;

%
% Loads fully sampled k-space of the given dataset
%
load 'cardiac_kspace.mat';
[nx ny nc] = size(kspace);
%
% kspace to image domain conversion and image display
%
im = ifft2c(kspace);
re_im = reshape_Image(im);
display_Image(re_im,[]);

%
% Undersample 
%
ver_kspace  = undersample(kspace, 1, 2);
ver_im = ifft2c(ver_kspace);
hor_kspace  = undersample(kspace, 2, 2);
hor_im = ifft2c(hor_kspace);

%
% Estimate Coil Sensitivity Maps
% 
cmaps = coilsense_maps(im, 10);
re_cmaps = reshape_Image(cmaps);
display_Image(re_cmaps,[]);

%
% Coil Combined Images
%
C_im = optimal_coilcomb(im, cmaps, eye(8));
display_Image(C_im,[]); title('Coil Combined Fully Sampled Image');


Chor_im = optimal_coilcomb(hor_im, cmaps, eye(8));
display_Image(Chor_im,[]); title('Coil Combined Undersampled Image (PE: Horizontal)');

Cver_im = optimal_coilcomb(ver_im, cmaps, eye(8));
display_Image(Cver_im,[]); title('Coil Combined Undersampled Image (PE: Vertical)');

%
% Same spacing but less acquired lines (Acquire central region only)
%
lowr_kspace = zeros(nx, ny, nc);
lowr_kspace(1:1:end, nx/2-nx/4:1:nx/2+nx/4, 1:1:end) = kspace(1:1:end, nx/2-nx/4:1:nx/2+nx/4, 1:1:end);
lowr_im = ifft2c(lowr_kspace);
Clowr_im = optimal_coilcomb(lowr_im, cmaps, eye(8));
display_Image(Clowr_im,[]); title('Coil Combined (Smaller Kymax: PE vertical)');

