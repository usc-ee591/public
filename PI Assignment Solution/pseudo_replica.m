function [signal, snr,g] = pseudo_replica_GRAPPA(in, reps, psi, cmaps, mask, cal_data)
%
%  [snr,g] = ismrm_pseudo_replica(in, image_formation_func, reps)
%
%  Performs multiple reconstructions with the supplied image formation
%  function while adding noise with stdev=1.0 to each replica.
%
%  The function 'image_formation_func' can be used to generate an image
%  with:
%      image = image_formation_func(in)
%
%  This function assumes:
%    a) The noise in the original input data is white (after decorrelation)
%    b) The image_formation_function does has overall scale factor of 1.0
%       (Any additional scaling with scale the g-map).
%
%
%  INPUT:
%    - in        : Input data, any format that the image formation function
%                  expects.
%  OUTPUT:
%    - snr       : An image in SNR units.
%    - g         : A g-map (assuming image_formation_func doesn't scale)
%    - noise_psf : Point spread function of the noise
%
%   Code made available for the ISMRM 2013 Sunrise Educational Course
% 
%   Michael S. Hansen (michael.hansen@nih.gov)
%
    [nvx nvy nc] = size(in);
%     kspace = fft2c(in);
%     acc_factor = 2;
%     mask = generate_sampling_pattern([nvx nvy], acc_factor, 25, 1);
% 
%     internal_cal_size = 25;
%     fprintf('Calibrating - Creating Calibration Data\n');
%     cal_shape = [internal_cal_size internal_cal_size];
%     cal_data = crop(kspace, [cal_shape nc]);

for r=1:reps
 
    fprintf('Running pseudo replica %d/%d\n',r,reps);
%    n = complex(randn(size(in)),randn(size(in)));
    n = ismrm_generate_correlated_noise([nvx nvy], transpose(psi));
    s = in + n;
%     imagesc(abs(in(:,:,1)))
%     kspace = fft2c(s);
    undersampled_kspace = s .* mask;

    %% GRAPPA Reconstruction
    reskGRAPPA = GRAPPA(undersampled_kspace, cal_data, [3 3], 0.00);
    tmp = ifft2c(reskGRAPPA);
%    img_noise_rep(:,r) = tmp(:);
    comb_tmp = optimal_coilcomb(tmp, cmaps, eye(8));
%    figure; imagesc(abs(comb_tmp));
    img_noise_rep(:, :, r) = comb_tmp;
end
%g = std(abs(img_noise_rep),[],3); %Measure variation, but add offset to create "high snr condition"
g = std(abs(img_noise_rep + max(abs(img_noise_rep(:)))),[],3); %Measure variation, but add offset to create "high snr condition"
%g(g < eps) = 1;
% comb_g = optimal_coilcomb(g, cmaps, eye(8));
% ismrm_imshow(abs(comb_g),[], [1 1]);
signal = mean(img_noise_rep,3);
snr = mean(img_noise_rep,3)./g;
return