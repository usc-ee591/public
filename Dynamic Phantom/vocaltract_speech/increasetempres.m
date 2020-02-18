% Increase the temporation from 7TR to 1TR
% 
% used downsampling and interpolation to smooth the movement
%
% ZYH, 06/16/2011

load data

factor = 3;     % Skip every 3 TRs, make to motion smooth

% nontongue
nontonguetable = data.warping.nontongue;
nontonguetable = nontonguetable(:, 1:factor:end);

[ptnum framenum] = size(nontonguetable);

% interplote by 6, since shift is 7TR

x = 1:framenum;
xi = 1:1/(7*factor*2):framenum;     % xi is 3ms temp

hightempnontongue = zeros(ptnum, length(xi));

for n = 1:ptnum
    y = nontonguetable(n,:);
    hightempnontongue(n,:) = interp1(x,y,xi,'linear');
end

data.increasetempres.nontongue =  hightempnontongue;

% tongue
tonguetable = data.warping.tongue;
tonguetable = tonguetable(:, 1:factor:end);

[ptnum framenum] = size(tonguetable);

hightemptongue = zeros(ptnum, length(xi));

for n = 1:ptnum
    y = tonguetable(n,:);
    hightemptongue(n,:) = interp1(x,y,xi,'linear');
end

data.increasetempres.tongue =  hightemptongue;

save data data