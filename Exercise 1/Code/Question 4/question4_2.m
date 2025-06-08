
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
    
    % Apply global histogram equalization
    Ieq = histeq(Igray);
    
    % Compute histogram of equalized image
    counts_eq = imhist(Ieq);
    levels = 0:255;
    

    figure('Name', ['Equalization Results: ' filenames{k}], 'NumberTitle', 'off');
    
  
    subplot(1,3,1);
    imshow(Igray);
    title('Original Grayscale');
    
  
    subplot(1,3,2);
    imshow(Ieq);
    title('Equalized Image');
    

    subplot(1,3,3);
    bar(levels, counts_eq, 'BarWidth', 1);
    xlim([0 255]);
    xlabel('Intensity Value');
    ylabel('Pixel Count');
    title('Histogram After Equalization');
    
 
end
