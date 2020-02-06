% arrout=truncraw(arr,npe)
% keeps only center npe phase encodes, zeroes out the rest.
% npe should be an even number
% returns arrout complex array

function arrout=truncraw(arr,npe)
nread=256;
nzero=256-npe;

a = [zeros(nzero/2,nread); ones(npe,nread); zeros(nzero/2,nread)];
arrout = arr.*a';
end
