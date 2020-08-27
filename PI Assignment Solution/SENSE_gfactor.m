function gfactor_map = SENSE_gfactor(cmaps, acc_factor, dir)
% INPUT:
%        cmaps: Coil Sensitivity maps
%        acc_factor: acceleration factor
%        dir: Direction of undersampling
% 
% Output:
%         gfactor_map:  gfactor map

[nvx nvy nc] = size(cmaps);
if dir == 1
   for kx = 1:1:nvx 
       for kk = 1:1:(nvy/acc_factor)
       P = [];
       S = [];  
       index = [];
       for jj = 1:1:acc_factor
           ky = mod((kk-1)+(jj-1)*nvy/acc_factor,nvy)+1;
           Sx = squeeze(cmaps(kx, ky, :));
           S = [S Sx];
           index = [index ky];
       end
       intensities = diag(pinv(S'*S));
       intensities(1) = sqrt(intensities(1)'*intensities(1));
       intensities(2) = sqrt(intensities(2)'*intensities(2));      
       gfactor_map(kx, index) = intensities(:);
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
           S = [S Sx];
           index = [index kx];
       end
       intensities = diag(pinv(S'*S));
       intensities(1) = sqrt(intensities(1)'*intensities(1));
       intensities(2) = sqrt(intensities(2)'*intensities(2));       
       gfactor_map( index, ky) = intensities(:);
       end
   end   
end
end