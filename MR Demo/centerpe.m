% arrout=center(arr,nkeep)
% keeps every nkeep phase encode encodes from arr
% and centers them in a 256 x 256 matrix arrout.

function arrout=center(arr,nkeep)
nread=256;
npe=256;
nstart= (npe/nkeep)/2;
arrout=zeros(nread,npe);
for k=1:nkeep:npe
arrout(:,nstart+floor(k/nkeep)) = arr(:,k);
end
