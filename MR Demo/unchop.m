% matlab script unchop.m
% multiplies raw data by 1 -1 1 -1 to unchop the signals
% reads in file called 'raw' and saves output matrix as .mat file
% dgn may 12, 1995

xres = 256;
yres = 256;

% open raw data file and read in data into g
fid = fopen('raw','r');
g = fread(fid,[2,inf],'short');
fclose(fid);

size(g)

i = sqrt(-1);
for j=1:yres
	temp1 = (j-1)*yres;
	for k=1:xres
	temp2 = temp1 + k;
	raw(k,j)= g(1,temp2)+ i*g(2,temp2); % creates complex
% makes rows (horiz) be the readout direction
% hence raw(1:xres,j) is the jth phase encode
end
end

% unchop
for j=2:2:yres
raw(:,j)=-1*raw(:,j);
end;

save rawunchop raw;
