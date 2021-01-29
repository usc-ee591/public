function mask = generate_sampling_pattern(im_size, R, Acs, dir)


% Input
%       im_size:    Image Size [nx ny] 
%       R:   Acceleration Factor outside ACS regions
%       Acs: Number of ACS lines 
%       Dir: direction of Phase Encode/Undersampling
%            1 : Left to Right
%            2 : Top to Bottom
nx = im_size(1);
ny = im_size(2);

if dir == 1
    mask = zeros(nx, ny);
    mask(:, 1:R:end) = 1;
    mask(:, (ny/2)-round(Acs/2)+1:1:(ny/2)+round(Acs/2)-1) = 1;
    size((ny/2)-round(Acs/2)+1:1:(ny/2)+round(Acs/2)-1)
%    imshow(mask);
else
    mask = zeros(nx, ny);
    mask(1:R:end, :) = 1;
    mask((ny/2)-round(Acs/2)+1:1:(ny/2)+round(Acs/2)-1, :) = 1;
    size((ny/2)-round(Acs/2)+1:1:(ny/2)+round(Acs/2)-1)
%    imshow(mask);
end
end