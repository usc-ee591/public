function im = ifft2c(d)
% Function performs a centered ifft
im = ifftshift(ifft2(ifftshift(d)));
%im = (ifft2(ifftshift(d)));