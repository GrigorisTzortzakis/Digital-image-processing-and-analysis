
% Specify data folder and HOG cell sizes to try
dataFolder = 'D:/ceid/Psifiakh epeksergasia eikonas/AskHsh 2'; 
cellSizes = { [8 8], [7 7], [14 14] };

%Load the TEST set 
testImagesFile = fullfile(dataFolder, 't10k-images-idx3-ubyte');
fid = fopen(testImagesFile, 'r', 'b');
assert(fid~=-1, 'Cannot open %s', testImagesFile);

fread(fid, 1, 'int32');            
numTestImages = fread(fid, 1, 'int32');  
fread(fid, 1, 'int32');            
fread(fid, 1, 'int32');           
pixelDataTest = fread(fid, inf, 'uint8'); 
fclose(fid);

imagesTest = reshape(pixelDataTest, 28, 28, numTestImages);
XTest = permute(imagesTest, [2 1 3]);   

testLabelsFile = fullfile(dataFolder, 't10k-labels-idx1-ubyte');
fid = fopen(testLabelsFile, 'r', 'b');
assert(fid~=-1, 'Cannot open %s', testLabelsFile);

fread(fid, 1, 'int32');           
fread(fid, 1, 'int32');            
YTest = fread(fid, inf, 'uint8');  
fclose(fid);

fprintf('Loaded %d test images of size 28×28.\n', numTestImages);

% Loop over each HOG cell size
results = struct();

for idxCS = 1:numel(cellSizes)
    cellSize = cellSizes{idxCS};
    csName = sprintf('cell%dx%d', cellSize(1), cellSize(2));
    fprintf('\n===== HOG cell size = [%d %d] =====\n', cellSize(1), cellSize(2));
    
    modelFilename = fullfile(dataFolder, sprintf('SVMModel_HOG_%s.mat', csName));
    
    %  Load TRAIN set, compute HOGs, and train SVM 
    if isfile(modelFilename)
        fprintf('Loading pre-trained model from "%s"...\n', modelFilename);
        load(modelFilename, 'SVMModel', 'hogLength');  
    else
        fprintf('Training new SVMModel for cellSize = [%d %d]...\n', cellSize(1), cellSize(2));
        
        % Load TRAIN images and labels
        trainImagesFile = fullfile(dataFolder, 'train-images-idx3-ubyte');
        fid = fopen(trainImagesFile, 'r', 'b');
        fread(fid, 1, 'int32');          
        numTrainImages = fread(fid, 1, 'int32');  
        fread(fid, 1, 'int32');           
        fread(fid, 1, 'int32');           
        pixelDataTrain = fread(fid, inf, 'uint8');
        fclose(fid);
        imgsTrain = reshape(pixelDataTrain, 28, 28, numTrainImages);
        XTrain = permute(imgsTrain, [2 1 3]);  
        
        trainLabelsFile = fullfile(dataFolder, 'train-labels-idx1-ubyte');
        fid = fopen(trainLabelsFile, 'r', 'b');
        fread(fid, 1, 'int32');          
        fread(fid, 1, 'int32');          
        YTrain = fread(fid, inf, 'uint8');  
        fclose(fid);
        
        % Compute HOG features on training set 
        numTrain = size(XTrain, 3);
        sampleHog = extractHOGFeatures(im2single(XTrain(:,:,1)), 'CellSize', cellSize);
        hogLength = numel(sampleHog);
        HOGTrain = zeros(numTrain, hogLength);
        
        fprintf('  Computing HOG for %d training images...\n', numTrain);
        for i = 1:numTrain
            HOGTrain(i, :) = extractHOGFeatures(im2single(XTrain(:,:,i)), 'CellSize', cellSize);
            if mod(i, 20000)==0
                fprintf('    Processed %d / %d train images\n', i, numTrain);
            end
        end
        
        % Train multiclass SVM 
        fprintf('  Training fitcecoc SVM on HOG features...\n');
        SVMModel = fitcecoc(HOGTrain, YTrain);
        
        save(modelFilename, 'SVMModel', 'hogLength');
        fprintf('  Saved SVMModel to "%s".\n', modelFilename);
    end
    
    %  Compute HOG features for the TEST set
    numTest = size(XTest, 3);
    HOGTest = zeros(numTest, hogLength);
    fprintf('Computing HOG for %d test images...\n', numTest);
    for j = 1:numTest
        HOGTest(j, :) = extractHOGFeatures(im2single(XTest(:,:,j)), 'CellSize', cellSize);
        if mod(j, 2000)==0
            fprintf('  Processed %d / %d test images\n', j, numTest);
        end
    end
    
    %  Predict labels for TEST set
    fprintf('Predicting test labels...\n');
    predLabels = predict(SVMModel, HOGTest);
    accuracy = mean(predLabels == YTest);
    fprintf('  Test accuracy for cellSize [%d %d]: %.2f%%\n', cellSize(1), cellSize(2), accuracy*100);
    
 
    rng(0);  
    sampleIdx = randperm(numTest, 20);  
    figure('Name', sprintf('Examples: HOG cell [%d %d]', cellSize(1), cellSize(2)));
    for k = 1:20
        iImg = sampleIdx(k);
        subplot(4,5,k);
        imshow(XTest(:,:,iImg), []);
        title(sprintf('GT=%d, Pred=%d', YTest(iImg), predLabels(iImg)));
    end
    
    % Store results in struct
    results(idxCS).cellSize     = cellSize;
    results(idxCS).accuracy     = accuracy;
    results(idxCS).predLabels   = predLabels;
    results(idxCS).YTest        = YTest;
end

% Summarize all accuracies
fprintf('\n===== Summary of Test Accuracies =====\n');
for idxCS = 1:numel(cellSizes)
    cs = results(idxCS).cellSize;
    acc = results(idxCS).accuracy * 100;
    fprintf('  cellSize = [%2d %2d]  →  %.2f%%\n', cs(1), cs(2), acc);
end
