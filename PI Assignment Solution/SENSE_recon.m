function image = SENSE_recon(im, cmaps, acc_factor, dir)
% INPUT:
%        im : undersampled images
%        cmaps: Coil Sensitivity maps
%        acc_factor: acceleration factor (make sure acc_factor is a 
%        multiple of nvx or nvy depending on the direction of undersampling)
%        dir: Direction of undersampling
% 
% Output:
%         Image:  Reconstructed Image

[nvx nvy nc] = size(im);
if dir == 1
   for kx = 1:1:nvx 
       for kk = 1:1:nvy/acc_factor
       P = [];
       S = [];  
       index = [];
       for jj = 1:1:acc_factor
           ky = mod((kk-1)+(jj-1)*nvy/acc_factor,nvy)+1;
           Sx = squeeze(cmaps(kx, ky, :));
           I = squeeze(im(kx, ky, :));
           P = [P I];
           S = [S Sx];
           index = [index ky];
       end
       intensities = pinv(S'*S)*S'*P;
       image(kx, index) = intensities(:,1);
       end
   end
else
   for ky = 1:1:nvy 
       for kk = 1:1:nvx/acc_factor
       P = [];
       S = [];  
       index = [];
       for jj = 1:1:acc_factor
           kx = mod((kk-1)+(jj-1)*nvx/acc_factor,nvx)+1;
           Sx = squeeze(cmaps(kx, ky, :));
           I = squeeze(im(kx, ky, :));
           P = [P I];
           S = [S Sx];
           index = [index kx];
       end
       intensities = pinv(S'*S)*S'*P;
       image(index, ky) = intensities(:,1);
       end
   end   
end
end