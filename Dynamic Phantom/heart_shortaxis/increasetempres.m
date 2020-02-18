% Change the temporation from 250ms to 3ms
%
% ZYH, 01/24/2013

load data

% interplote by (3/250)
area1table = data.stitching.area1;
[ptnum framenum] = size(area1table);
x = 1:framenum;
xi = 1:(3/250):framenum;

% area1
area1table = data.stitching.area1;
[ptnum framenum] = size(area1table);
hightemparea1 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area1table(n,:);
    hightemparea1(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area1 =  hightemparea1;

% area2
area2table = data.stitching.area2;
[ptnum framenum] = size(area2table);
hightemparea2 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area2table(n,:);
    hightemparea2(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area2 =  hightemparea2;

% area3
area3table = data.stitching.area3;
[ptnum framenum] = size(area3table);
hightemparea3 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area3table(n,:);
    hightemparea3(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area3 =  hightemparea3;

% area4
area4table = data.stitching.area4;
[ptnum framenum] = size(area4table);
hightemparea4 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area4table(n,:);
    hightemparea4(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area4 =  hightemparea4;

% area5
area5table = data.stitching.area5;
[ptnum framenum] = size(area5table);
hightemparea5 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area5table(n,:);
    hightemparea5(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area5 =  hightemparea5;

% area6
area6table = data.stitching.area6;
[ptnum framenum] = size(area6table);
hightemparea6 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area6table(n,:);
    hightemparea6(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area6 =  hightemparea6;

% area7
area7table = data.stitching.area7;
[ptnum framenum] = size(area7table);
hightemparea7 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area7table(n,:);
    hightemparea7(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area7 =  hightemparea7;

% area8
area8table = data.stitching.area8;
[ptnum framenum] = size(area8table);
hightemparea8 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area8table(n,:);
    hightemparea8(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area8 =  hightemparea8;

% area9
area9table = data.stitching.area9;
[ptnum framenum] = size(area9table);
hightemparea9 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area9table(n,:);
    hightemparea9(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area9 =  hightemparea9;

% area10
area10table = data.stitching.area10;
[ptnum framenum] = size(area10table);
hightemparea10 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area10table(n,:);
    hightemparea10(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area10 =  hightemparea10;

% area11
area11table = data.stitching.area11;
[ptnum framenum] = size(area11table);
hightemparea11 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area11table(n,:);
    hightemparea11(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area11 =  hightemparea11;

% area12
area12table = data.stitching.area12;
[ptnum framenum] = size(area12table);
hightemparea12 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area12table(n,:);
    hightemparea12(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area12 =  hightemparea12;

% area13
area13table = data.stitching.area13;
[ptnum framenum] = size(area13table);
hightemparea13 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area13table(n,:);
    hightemparea13(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area13 =  hightemparea13;

% area14
area14table = data.stitching.area14;
[ptnum framenum] = size(area14table);
hightemparea14 = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = area14table(n,:);
    hightemparea14(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.area14 =  hightemparea14;

save data data