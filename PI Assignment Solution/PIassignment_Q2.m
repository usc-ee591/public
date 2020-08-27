clear all;
close all;

load brain_data.mat

[nvx nvy nc] = size(kspace);
image = ifft2c(kspace);

sfilt = [1];
for index=1:1
    sfilt=filter2(sfilt,ones(2),'full'); 
end 
% Smooth numerator of coil map
for index=1:size(image, 3)
    image(:, :, index) = filter2(sfilt, image(:,:,index), 'same');
end



ccmaps = coilsense_maps(image);
comb_im = optimal_coilcomb(image, ccmaps, eye(8));
figure; imagesc(abs(comb_im)); axis off; colormap gray; title('SENSE R1 coil combination');


comb_rmsim = sqrt(sum(image.*conj(image),3));
figure; imagesc(abs(comb_rmsim)); axis off; colormap gray; title('RMS coil combination');


%% Amplify Noise
for kk = 1:1:8
  noise = 2*(randn(160,220)+1i*rand(160,220));
    noisy_image(:,:,kk) = image(:,:,kk)+ noise;
end 

comb_im = optimal_coilcomb(noisy_image, ccmaps, eye(8));
figure; imagesc(abs(comb_im)); axis off; colormap gray; title('SENSE R1 coil combination');


comb_rmsim = sqrt(sum(noisy_image.*conj(noisy_image),3));
figure; imagesc(abs(comb_rmsim)); axis off; colormap gray; title('RMS coil combination');

