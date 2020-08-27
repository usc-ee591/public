function [g, nc]  = gfactor(C,RX,RY)
%
% [g, nc]  = gfactor(C,Rx,Ry)
%
% Compute the g-factor map for a set of coil sensitities and accelerations
%
%    C  -- array of coil sensitivities, Nx x Ny X Nc

%    Ry -- x acceleration
%    Ry -- y acceleration
%
%    g  -- g-factor map
%    nc -- number of coils contributing
%
%
% written by John Pauly
% (c) Board of Trustees, Leland Stanford Jr University, 2011
%
[NX NY L] = size(C);
NRX = NX/RX;
NRY = NY/RY;
g = zeros(NX,NY);
nc = zeros(NX,NY);
for ii=1:NX
    for jj=1:NY
        if abs(C(ii,jj,1)) < 1e-6
            g(ii,jj) = 0;
        else
            for LX=0:RX-1
                for LY=0:RY-1
                    ndx = mod((ii-1)+LX*NRX,NX)+1;
                    ndy = mod((jj-1)+LY*NRY,NY)+1;
                    CT = C(ndx, ndy, :);
                    CT = CT(:);
                    if ((LX==0) & (LY==0))
                            s = CT;
                    else if abs(CT(1)) > 1e-6
                            s = [s CT];
                        end
                    end                   
                    nc(ii,jj) = nc(ii,jj)+1;
                end
            end
            scs = s'*s;
            scsi = inv(scs);
            g(ii,jj) = sqrt(scs(1,1)*scsi(1,1));
        end
    end
end
