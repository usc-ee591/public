function [tx] = ellipse_fourier(kx,ky,dx,dy,xo,yo);

% Fourier data for a dx x dy ellipse centered at (xo,yo)

if (exist('xo')~=1) xo = 0; yo = 0; end;

kr_norm = sqrt((dx*kx).^2 + (dy*ky).^2);
tx = dx*dy*jinc(kr_norm).*exp(-j*2*pi*(xo*kx + yo*ky));

