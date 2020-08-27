function us_kspace = undersample(kspace, dir, R)
% Input:   kspace 
%          dir which specify the direction of undersampling, 1 denotes x axis, 2 y axis
%          R acceleration factor
           

% This function performs undersampling in the horizontal or vertical axis
% by the accelation factor specified.
[nx ny nc] = size(kspace);
us_kspace = zeros(nx, ny, nc);
if dir == 1
    us_kspace(1:R:end, 1:1:end, 1:1:end) = kspace(1:R:end, 1:1:end, 1:1:end);
end

if dir == 2
    us_kspace(1:1:end, 1:R:end, 1:1:end) = kspace(1:1:end, 1:R:end, 1:1:end);
end
figure; imagesc(abs(us_kspace(:,:,1)));
end