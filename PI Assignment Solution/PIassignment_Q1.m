clear all;
close all;

load brain_data.mat

[nvx nvy nc] = size(kspace);
image = ifft2c(kspace);
ismrm_imshow(abs(image),[],[2 4]);

cmaps = coilsense_maps(image);
ismrm_imshow(abs(cmaps),[],[2 4]);

sfilt = [1];
for index=1:10 
    sfilt=filter2(sfilt,ones(2),'full'); 
end 
% Smooth numerator of coil map
for index=1:size(image, 3)
    image(:, :, index) = filter2(sfilt, image(:,:,index), 'same');
end
ccmaps = coilsense_maps(image);
ismrm_imshow(abs(ccmaps),[],[2 4]);
