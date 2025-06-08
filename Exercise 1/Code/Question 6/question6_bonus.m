
%  Read & preprocess
Iorig = imread('hallway.png');
if size(Iorig,3)==3
    Igray = rgb2gray(Iorig);
else
    Igray = Iorig;
end
Igray = im2double(Igray);

%  Edge detection 
BW = edge(Igray,'Sobel');

%  Compute Hough transform
[H, theta, rho] = hough(BW);

%  Find peaks in the Hough accumulator
numPeaks = 10;                      
peaks = houghpeaks(H, numPeaks, 'Threshold', ceil(0.3*max(H(:))));

%  Extract line segments around those peaks
fillGap   = 20;  
minLength = 40;  
lines = houghlines(BW, theta, rho, peaks, ...
                   'FillGap', fillGap, ...
                   'MinLength', minLength);


figure('Name','Detected Line Segments','NumberTitle','off');
imshow(Iorig), hold on

for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth',2, 'Color','r');

    plot(xy(1,1), xy(1,2), 'go', 'MarkerSize',6, 'LineWidth',1.5);
    plot(xy(2,1), xy(2,2), 'ro', 'MarkerSize',6, 'LineWidth',1.5);
end
title('Hough‐detected line segments (in red)')
hold off
