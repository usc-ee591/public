
function [M] = simpulse(b1,gz,dt,Morig,z,df,gamma);

% function [M] = simpulse(b1,gz,dt,Morig,z,df,gamma);
%
% Simulates an RF pulse described by
%   b1 - RF pulse (in Gauss)
%   gz - Z Gradient (in Gauss/cm)
%   dt - sampling period (in seconds)
% for a given spin described by
%   Morig - original magnetization (usually [0;0;1])
%   z - z position (in cm)
%   df - off-resonant frequency (in Hz)
% optional parameter gamma (in radians/s/Gauss)

if (exist('gamma')~=1) gamma = 26752; end;

M = Morig;
for t=1:length(b1);
  M = xrot(gamma*b1(t)*dt) * M;
  M = zrot(2*pi*df*dt) * M;
  M = zrot(gamma*gz(t)*z*dt) * M;
end;

