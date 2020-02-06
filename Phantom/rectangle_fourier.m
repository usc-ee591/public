function [tx] = rectangle_fourier(kx,ky,dx,dy,xo,yo);

% Fourier data for a dx x dy rectangle centered at (xo,yo)

if (exist('xo')~=1) xo = 0; yo = 0; end;

tx = dx*dy*sinc(dx*kx).*sinc(dy*ky).*exp(-j*2*pi*(xo*kx + yo*ky));

