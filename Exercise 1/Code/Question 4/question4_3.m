
% List of image filenames
filenames = {'dark_road_1.jpg', 'dark_road_2.jpg', 'dark_road_3.jpg'};

% Choose tile grid size for local histogram equalization.
numTiles = [8 8];
clipLimit = 0.01;  

fprintf('Using local histogram equalization with tile grid %d×%d and clip limit %0.3f\n', ...
        numTiles(1), numTiles(2), clipLimit);

for k = 1:numel(filenames)
    % Read image
    I = imread(filenames{k});
    

    if ndims(I) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    
    % Apply local histogram equalization (CLAHE)
    Iadapteq = adapthisteq(Igray, ...
        'NumTiles', numTiles, ...
        'ClipLimit', clipLimit, ...
        'Distribution', 'uniform');
    
    % Compute histogram of adapted image
    counts_adapt = imhist(Iadapteq);
    levels = 0:255;
    
 
    figure('Name', ['Adaptive Equalization: ' filenames{k}], 'NumberTitle', 'off');
    
    subplot(2,2,1);
    imshow(Igray);
    title('Original Grayscale');
    
    subplot(2,2,2);
    imshow(Iadapteq);
    title(sprintf('CLAHE (%dx%d tiles)', numTiles(1), numTiles(2)));
    
    subplot(2,2,[3 4]);
    bar(levels, counts_adapt, 'BarWidth', 1);
    xlim([0 255]);
    xlabel('Intensity Value');
    ylabel('Pixel Count');
    title('Histogram After CLAHE');
    
   
end
