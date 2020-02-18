% combine curves -> areas
% ZYH, 01/24/2013

load data

data.stitching.area1 = data.warping.curve1;
data.stitching.area2 = data.warping.curve2;
data.stitching.area3 = data.warping.curve3;
data.stitching.area4 = data.warping.curve4;
data.stitching.area5 = data.warping.curve5;
data.stitching.area6 = data.warping.curve6;
data.stitching.area7 = data.warping.curve7;
data.stitching.area8 = [data.warping.curve8(1:end-1,:); data.warping.curve9(1:end-1,:); data.warping.curve10(1:end-1,:)];
data.stitching.area9 = [data.warping.curve11(1:end-1,:); flipud(data.warping.curve12(2:end,:)); flipud(data.warping.curve9(2:end,:))];
data.stitching.area10 = [data.warping.curve12(1:end-1,:); data.warping.curve13(1:end-1,:); data.warping.curve15(1:end-1,:); data.warping.curve16(1:end-1,:); flipud(data.warping.curve10(2:end,:))];
data.stitching.area11 = [data.warping.curve14(1:end-1,:); flipud(data.warping.curve15(2:end,:))];
data.stitching.area12 = [data.warping.curve17(1:end-1,:); flipud(data.warping.curve10(2:end,:))];
data.stitching.area13 = data.warping.curve18;
data.stitching.area14 = data.warping.curve19;

% test
% allareas = [data.stitching.area1; data.stitching.area2; data.stitching.area3; data.stitching.area4; data.stitching.area5; data.stitching.area6; ...
%     data.stitching.area7; data.stitching.area8; data.stitching.area9; data.stitching.area10; data.stitching.area11; data.stitching.area12];
% 
% figure, hold on; axis([-64 63 -64 63]);
% for n = 1:size(allareas,1)
%     plot(allareas(n, 1), 'r*');
%     pause(.1);
% end
% hold off;

save data data