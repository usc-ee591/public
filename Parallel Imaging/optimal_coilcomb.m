function output = optimal_coilcomb(input, smap, psi)

%   Function performs SENSE recon with R = 1 for a single slice
% Input:
%       input image (nx, ny, nc)
%       sensitivity map (nx, ny, nc)
%       psi: (nc, nc)
%  
% Output: 
%       output = coil combined image (nx, ny)
%% SENSE RECONSTRUCTION FOR R=1
[nx, ny, nc] = size(input);
output = zeros(nx,ny);

for x = 1:nx
   for y = 1:ny
      % Assemble S matrix (Nc X 1)
      S = squeeze(smap(x,y,:));
      % Assemble A matrix (Nc X 1)
      alias = squeeze(input(x,y,:));    
      output(x,y) = pinv(S'/psi*S)*S'/psi * alias; % where did this come from?

   end
end
end




