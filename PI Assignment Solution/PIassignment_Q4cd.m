clear all;
close all;

% %% Formulating Brain Data
% load brain_8ch.mat;
% kspace = fft2c(im);
% image  = ifft2c(kspace);
% 
% brainmask = generate_sampling_pattern([160 220], 2, 40, 1);
% clear map; clear im; clear image;
% save brain_data.mat;

clear all;
load Cardiac_data.mat

[nvx nvy nc] = size(kspace);
image = ifft2c(kspace);
index1 = 1;
index2 = 1;

noise = Noise;
%% Estimate a noise covariance matrix from noise samples
n = reshape(noise, [], nc);
n = permute(n,[2 1]);
N = size(n,2);
psi = (1/(N-1))*(n*n');
%% Undersample Cardiac Data
acc_factor = 2;
mask = generate_sampling_pattern([nvx nvy], acc_factor, 24, 2);
undersampled_kspace = kspace .* mask;
imagesc(abs(mask(:,:,1)));
%% Estimate Coil Sensitivty Maps
sfilt = [1];
for index=1:1
    sfilt=filter2(sfilt,ones(2),'full'); 
end 
% Smooth numerator of coil map
for index=1:size(image, 3)
    imagee(:, :, index) = filter2(sfilt, image(:,:,index), 'same');
end
cmaps = coilsense_maps(imagee);

%% Create calibration data
internal_cal_size = 25;     % ACS region
fprintf('Calibrating - Creating Calibration Data\n');
cal_shape = [internal_cal_size internal_cal_size];
cal_data = crop(kspace, [cal_shape nc]);

%% GRAPPA Reconstruction
fprintf('Performing GRAPPA reconstruction\n');
reskGRAPPA = GRAPPA(undersampled_kspace, cal_data, [3 3], 0.00);
resGRAPPA = ifft2c(reskGRAPPA);
NRMSE = (norm(resGRAPPA(:)-image(:))/norm(image(:)))

comb_reconimage = optimal_coilcomb(resGRAPPA, cmaps, eye(8));
comb_groundimage = optimal_coilcomb(image, cmaps, eye(8));
comb_usimage = optimal_coilcomb(ifft2c(undersampled_kspace), cmaps, eye(8));
figure; imagesc(abs(comb_reconimage)); title('Recon Image'); axis off; colormap gray;
figure; imagesc(abs(comb_groundimage)); title('Ground Truth Image'); axis off; colormap gray;
figure; imagesc(abs(comb_usimage)); title('Undersampled Image'); axis off; colormap gray;

%% gmap
gmap = GRAPPA_pseudoreplica(undersampled_kspace, 256, psi, cmaps, mask, cal_data);
figure; imagesc(abs(gmap)); title('g factor map'); axis off; colormap gray;
