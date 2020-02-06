% arrout=zerope(arr,nkeep)
% keeps every nkeep phase encode encodes, zeroes out the rest.
%
% returns arrout complex array

function arrout=zerope(arr,nkeep)
nread=256;
npe=256;
arrout=zeros(nread,npe);
for j=1:nkeep:npe
arrout(:,j) = arr(:,j);
end
end
