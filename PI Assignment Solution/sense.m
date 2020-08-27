function im = sense( ima, map, RX, RY )
%
% im = sense( ima, map, RX, RY )
%
%  ima -- aliased images, undersampled at Rx and Ry, at full FOV
%  map -- maps of the coil sensitivities
%  Rx  -- x acceleration factor
%  Ry  -- y acceleration factor
%
%  im  -- SENSE reconstruction of ima
%
%  this assumes that the noise correlation matrix is I
%
%
% written by John Pauly
% (c) Board of Trustees, Leland Stanford Jr University, 2011
%
[NX NY L] = size(map);
 NRX = NX/RX;
 NRY = NY/RY;
 im = zeros(NX,NY);
 for ii=1:NX
    for jj=1:NY
        if abs(map(ii,jj,1)) < 1e-6
            im(ii,jj) = 0;
        else
            for LX=0:RX-1
                for LY=0:RY-1
                ndx = mod((ii-1)+LX*NRX,NX)+1;
                ndy = mod((jj-1)+LY*NRY,NY)+1;
                CT = map(ndx, ndy, :);
                CT = CT(:);
                    if ((LX==0) & (LY==0))
                            s = CT;
                    else if abs(CT(1)) > 1e-6
                            s = [s CT];
                        end
                    end
                end
            end
            scs = s'*s;
            scsi = inv(scs);
            m = ima(ii,jj,:);
            m = m(:);
            mr = scsi*s'*m;
            im(ii,jj) = mr(1);
        end 
    end
 end
end