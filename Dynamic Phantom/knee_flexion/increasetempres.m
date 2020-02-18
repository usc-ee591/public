% Change the temporation from 250ms to 3ms
% 
% ZYH, 01/30/2013

load data

% interplote by (3/250)
fsurfacetable = data.warping.fsurface;
[ptnum framenum] = size(fsurfacetable);
x = 1:framenum;
xi = 1:(3/250):framenum;

% fsurface
fsurfacetable = data.warping.fsurface;
[ptnum framenum] = size(fsurfacetable);
hightempfsurface = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = fsurfacetable(n,:);
    hightempfsurface(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.fsurface =  hightempfsurface;

% patella
patellatable = data.warping.patella;
[ptnum framenum] = size(patellatable);
hightemppatella = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = patellatable(n,:);
    hightemppatella(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.patella =  hightemppatella;

% pad
padtable = data.warping.pad;
[ptnum framenum] = size(padtable);
hightemppad = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = padtable(n,:);
    hightemppad(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.pad =  hightemppad;

% ffat
ffattable = data.warping.ffat;
[ptnum framenum] = size(ffattable);
hightempffat = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = ffattable(n,:);
    hightempffat(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.ffat =  hightempffat;

% femur
femurtable = data.warping.femur;
[ptnum framenum] = size(femurtable);
hightempfemur = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = femurtable(n,:);
    hightempfemur(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.femur =  hightempfemur;

% tibia
tibiatable = data.warping.tibia;
[ptnum framenum] = size(tibiatable);
hightemptibia = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = tibiatable(n,:);
    hightemptibia(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.tibia =  hightemptibia;

% bmeniscus
bmeniscustable = data.warping.bmeniscus;
[ptnum framenum] = size(bmeniscustable);
hightempbmeniscus = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = bmeniscustable(n,:);
    hightempbmeniscus(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.bmeniscus =  hightempbmeniscus;

% bsurface
bsurfacetable = data.warping.bsurface;
[ptnum framenum] = size(bsurfacetable);
hightempbsurface = zeros(ptnum, length(xi));
for n = 1:ptnum
    y = bsurfacetable(n,:);
    hightempbsurface(n,:) = interp1(x,y,xi,'linear');
end
data.increasetempres.bsurface =  hightempbsurface;

save data data