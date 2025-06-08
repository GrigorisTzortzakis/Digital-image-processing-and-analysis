
% List of image filenames
filenames = {'dark_road_1.jpg', 'dark_road_2.jpg', 'dark_road_3.jpg'};

for k = 1:numel(filenames)
    % Read image
    I = imread(filenames{k});
    
 
    if ndims(I) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    
    % Compute histogram 
    counts = imhist(Igray);
    levels = 0:255;
    

    figure('Name', filenames{k}, 'NumberTitle', 'off');
    
    subplot(1,2,1);
    imshow(Igray);
    title(sprintf('Grayscale Image: %s', filenames{k}), 'Interpreter', 'none');
    
    subplot(1,2,2);
    bar(levels, counts, 'BarWidth', 1);
    xlim([0 255]);
    xlabel('Intensity Value');
    ylabel('Pixel Count');
    title('Histogram of Grayscale Intensities');
    
  
end
