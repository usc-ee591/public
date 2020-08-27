clear all; close all;

load Cardiac_data.mat
%load brain_data.mat;

[nvx nvy nc] = size(kspace);
image = ifft2c(kspace);
acc_factor = 2;
cmaps = coilsense_maps(image);
% % %% mask
% % mask = zeros(nvx, nvy); 
% % %mask(:,1:acc_factor:end) = 1;
% % 
% % %mask(1:acc_factor:end, :) = 1;
% % %imagesc(mask);
% % 
% % % ver_kspace  = undersample(kspace, 1, 4);
% % undersampled_kspace = kspace .* mask;
% % %ismrm_imshow(abs(undersampled_kspace),[], [2 4]);
% % undersampled_images = ifft2c(undersampled_kspace);
% % %ismrm_imshow(abs(undersampled_images),[], [2 4]);
% % 
% % 
% % %% SENSE Recon
% % recon_image = SENSE_recon(undersampled_images, cmaps, acc_factor, 2);
% % figure; imagesc(abs(recon_image)); colormap gray; axis off;
% % 
% % comb_im = optimal_coilcomb(image, cmaps, eye(8));
% % figure; imagesc(abs(comb_im)); colormap gray; axis off;

% %% SENSE Recon g factor
% gfactor = SENSE_gfactor(cmaps, acc_factor, 2);
% figure; imagesc(abs(gfactor)); colormap gray; axis off;



%% mask
mask = zeros(nvx, nvy); 
%mask(:,1:acc_factor:end) = 1;

mask(:, 1:acc_factor:end) = 1;
%imagesc(mask);

% ver_kspace  = undersample(kspace, 1, 4);
undersampled_kspace = kspace .* mask;
%ismrm_imshow(abs(undersampled_kspace),[], [2 4]);
undersampled_images = ifft2c(undersampled_kspace);
%ismrm_imshow(abs(undersampled_images),[], [2 4]);


%% SENSE Recon
recon_image = SENSE_recon(undersampled_images, cmaps, acc_factor, 1);
figure; imagesc(abs(recon_image)); colormap gray; axis off;

comb_im = optimal_coilcomb(image, cmaps, eye(8));
figure; imagesc(abs(comb_im)); colormap gray; axis off;

%NRMSE = (norm(recon_image(:) - comb_im(:))/norm(comb_im(:)));
% %% SENSE Recon g factor
% gfactor = SENSE_gfactor(cmaps, acc_factor, 1);
% figure; imagesc(abs(gfactor)); colormap gray; 