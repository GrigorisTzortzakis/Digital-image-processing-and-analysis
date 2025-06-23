
dataFolder = 'D:/ceid/Psifiakh epeksergasia eikonas/AskHsh 2'; 

% Load training images
trainImagesFile = fullfile(dataFolder, 'train-images-idx3-ubyte');
fid = fopen(trainImagesFile, 'r', 'b');   
assert(fid~=-1, 'Cannot open %s', trainImagesFile);

fread(fid, 1, 'int32');         
numImages  = fread(fid, 1, 'int32');   
numRows    = fread(fid, 1, 'int32');  
numCols    = fread(fid, 1, 'int32');   
pixelData  = fread(fid, inf, 'uint8');
fclose(fid);

% Reshape into 
images = reshape(pixelData, numCols, numRows, numImages);
XTrain = permute(images, [2 1 3]);   % size = [28 × 28 × numImages]

%  Load training labels
trainLabelsFile = fullfile(dataFolder, 'train-labels-idx1-ubyte');
fid = fopen(trainLabelsFile, 'r', 'b');
assert(fid~=-1, 'Cannot open %s', trainLabelsFile);

fread(fid, 1, 'int32');      
fread(fid, 1, 'int32');      
YTrain = fread(fid, inf, 'uint8'); 
fclose(fid);

% Compute HOG features for all training images
cellSize = [8 8];
numTrain = size(XTrain, 3);

% Determine HOG length using one sample
sampleHog   = extractHOGFeatures(im2single(XTrain(:,:,1)), 'CellSize', cellSize);
hogLength   = numel(sampleHog);           
HOGTrain    = zeros(numTrain, hogLength);  

for i = 1:numTrain
    imgSingle         = im2single(XTrain(:,:,i)); 
    HOGTrain(i, :)    = extractHOGFeatures(imgSingle, 'CellSize', cellSize);
    if mod(i, 10000) == 0
        fprintf('Computed HOG for %d / %d images\n', i, numTrain);
    end
end

% Train multiclass SVM on HOG features

SVMModel = fitcecoc(HOGTrain, YTrain);

% Save the SVM model and HOG parameters
save(fullfile(dataFolder, 'mnistHOG_SVMModel.mat'), 'SVMModel', 'cellSize');
fprintf('Training complete. SVM model saved.\n');
