clear all;
close all;

load brain_data.mat

[nvx nvy nc] = size(kspace);
image = ifft2c(kspace);
index1 = 1;
index2 = 1;

%% Undersample Brain Data
acc_factor = 2;
mask = generate_sampling_pattern([nvx nvy], acc_factor, 40, 1);
undersampled_kspace = kspace .* mask;
imagesc(abs(mask(:,:,1)));
%% Estimate Coil Sensitivty Maps
cmaps = coilsense_maps(image);

%% Create calibration data
internal_cal_size = 40;     % ACS region
fprintf('Calibrating - Creating Calibration Data\n');
cal_shape = [internal_cal_size internal_cal_size];
cal_data = crop(kspace, [cal_shape nc]);

%% GRAPPA Reconstruction
fprintf('Performing GRAPPA reconstruction\n');
reskGRAPPA = GRAPPA(undersampled_kspace, cal_data, [3 3], 0.00);
resGRAPPA = ifft2c(reskGRAPPA);
NRMSE = (norm(resGRAPPA(:)-image(:))/norm(image(:)))

%% Coil Combination
comb_im = optimal_coilcomb(resGRAPPA, cmaps, eye(8));
comb_gim = optimal_coilcomb(image, cmaps, eye(8));
figure; imagesc(abs(comb_im(:,:))); title('Recon Image'); colormap gray; axis off;
figure; imagesc(abs(comb_gim(:,:))); title('Reference Image'); colormap gray; axis off;
%% Varying Kernel Sizes
for kk = 3:2:9
    for jj = 1:1:1
%         %% Undersample Brain Data
%         acc_factor = 2;
%         mask = generate_sampling_pattern([nvx nvy], acc_factor, 40, 1);
%         undersampled_kspace = kspace .* mask;

        %% GRAPPA Reconstruction
        fprintf('Performing GRAPPA reconstruction\n');
        reskGRAPPA = GRAPPA(undersampled_kspace, cal_data, [kk kk], 0.00);
        resGRAPPA = ifft2c(reskGRAPPA);       
        NRMSE(jj) = (norm(resGRAPPA(:)- image(:))/norm(image(:)))
    end
        NRMSE1(index1) = mean(NRMSE);
        index1 = index1 + 1;
end
figure; plot(3:2:9, NRMSE1, '-*','LineWidth', 3); xlabel('Kernel Size'); ylabel('NRMSE');


%% Varying Acceleration Factors
for R = 2:1:5
    for jj = 1:1:1
        %% Undersample Brain Data
        acc_factor = R;
        mask = generate_sampling_pattern([nvx nvy], acc_factor, 40, 1);
        undersampled_kspace = kspace .* mask;

        %% GRAPPA Reconstruction
        fprintf('Performing GRAPPA reconstruction\n');
        reskGRAPPA = GRAPPA(undersampled_kspace, cal_data, [5 5], 0.00);
        resGRAPPA = ifft2c(reskGRAPPA);
        
        NRMSE(jj) = (norm(resGRAPPA(:) - image(:))/norm(image(:)));
    end
        NRMSE2(index2) = mean(NRMSE);
        index2 = index2 + 1;
end
figure; plot(2:1:5, NRMSE2, '-*','LineWidth', 3); xlabel('Acceleration Factor (Outside ACS region)'); ylabel('NRMSE');