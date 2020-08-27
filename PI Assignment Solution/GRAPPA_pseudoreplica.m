function [g] = GRAPPA_pseudoreplica(in, reps, psi, cmaps, mask, cal_data)

%  INPUT:
%      - in        : Undersampled k space
%      - rep       : Number of reps required
%      - psi       : Noise Covariance Matrix
%      - cmaps     : Coil sensitivity maps
%      - mask      : Undersampling mask
%      - cal_data  : calibration data
%  OUTPUT:
%    - g         : A gfactor-map 
%

[nvx nvy nc] = size(in);
for r= 1: reps
 
    fprintf('Running pseudo replica %d/%d\n',r,reps);
    n = ismrm_generate_correlated_noise([nvx nvy], transpose(psi));
    s = in + n;
    undersampled_kspace = s .* mask;
    %% GRAPPA Reconstruction
    reskGRAPPA = GRAPPA(undersampled_kspace, cal_data, [3 3], 0.00);
    tmp = ifft2c(reskGRAPPA);
    comb_tmp = optimal_coilcomb(tmp, cmaps, eye(8));
    img_noise_rep(:, :, r) = comb_tmp;
end
%g = std(abs(img_noise_rep,[], 3); 
g = std(abs(img_noise_rep + max(abs(img_noise_rep(:)))),[], 3); 
return