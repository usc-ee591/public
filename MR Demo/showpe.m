% sig = showpe(arr,pe)
% plots real and imag part of phase encode pe from raw data array arr.
%
% returns 1D array sig

function sig=showpe(arr,pe)
len=256;
nn=1:len;
sig=arr(:,pe);
plot(nn,real(sig),nn,imag(sig));
title('Readout signal');
end
