function S = Poly2Fourier(x,y,kx,ky)
%function S = Poly2Fourier(x,y,kx,ky)
% Computes the 2D-FT of the polygonal shape defined by the corner points 
% (x,y) at the k-space locations (kx,ky) defined by the kx and ky matrices.
%
% Input arguments:
%   x  - real-valued vector of x-coordinates of the polygon vertices;
%        must have same length as y
%   y  - real-valued vector of y-coordinates of the polygon vertices;
%        must have same length as x
%   kx - real-valued matrix of kx locations; must have same size as ky
%   ky - real-valued matrix of ky locations; must have same size as kx
% 
% Output arguments:
%   S  - value of the 2-d FT of the polygonal shape at the (kx,ky) 
%        locations specified in the kx and ky matrices;
%        S has the same size as kx and ky
% 
% The algorithm is from:
% K.McInturff and P.S.Simon, "The Fourier Transform of Linearly Varying
% Functions with Polygonal Support", IEEE Transactions on Antennas and
% Propagation, 39(9), 1991.
%
% Erik Bresch, USC SPAN Group, 2007

gammaN        = [real(x(:)') ; real(y(:)')];
gammaNplusOne = circshift(gammaN,[0,-1]);
alphaN        = gammaNplusOne - gammaN;
betaN         = gammaNplusOne + gammaN;
K             = [real(kx(:)) real(ky(:))];

KxAndKyAreZero = (K(:,1)==0) & (K(:,2)==0);

Kbar = (sum(K.^2,2) + KxAndKyAreZero);
Kbar = [real(ky(:))./Kbar -real(kx(:))./Kbar];

S = sum(((Kbar * alphaN) .* exp(-j*pi*K*betaN) .* sinc(K*alphaN)),2)/(2*j*pi);
S(KxAndKyAreZero==1) = polyarea(x,y);
S = reshape(S,size(kx));
return
