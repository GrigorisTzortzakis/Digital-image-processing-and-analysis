
% Compute manual HOG for all training images (as before)
cellSize = [8 8];  
numBins  = 9;       
numTrain = size(XTrain, 3);

% Determine HOG length by computing on one image
hogSample = computeHOGManual(im2single(XTrain(:,:,1)), cellSize, numBins);
hogLength = numel(hogSample);

% Preallocate HOGTrain
HOGTrain = zeros(numTrain, hogLength);

fprintf('Computing manual HOG for %d training images...\n', numTrain);
for i = 1:numTrain
    imgSingle      = im2single(XTrain(:,:,i));
    HOGTrain(i, :) = computeHOGManual(imgSingle, cellSize, numBins);
    if mod(i, 10000) == 0
        fprintf('  Processed %d / %d\n', i, numTrain);
    end
end
fprintf('Finished computing manual HOG features.\n');


% Visualize one HOG descriptor as a bar chart

sampleHOGVec = HOGTrain(1, :);

figure('Name', 'HOG Descriptor for Sample Image', 'NumberTitle', 'off');
bar(sampleHOGVec, 'FaceColor', [0.2 0.6 0.8]);
xlim([1 hogLength]);
xlabel('HOG Feature Index');
ylabel('Normalized Magnitude');
title('Manual HOG Descriptor (Image #1, cellSize = [8 8], numBins = 9)');

blockSize = 4 * numBins;   % = 36
hold on;
for b = 1:(hogLength / blockSize - 1)
    xline(b * blockSize + 0.5, 'k--', 'LineWidth', 1);
end
hold off;

% Function: computeHOGManual 
function hogVector = computeHOGManual(img, cellSize, numBins)

    [H, W] = size(img);
    nRowsCell = cellSize(1);
    nColsCell = cellSize(2);
    nCellsY = floor(H / nRowsCell);
    nCellsX = floor(W / nColsCell);
    cropH = nCellsY * nRowsCell;
    cropW = nCellsX * nColsCell;
    imgC = img(1:cropH, 1:cropW);

    % Gradients Gx, Gy via [-1 0 1] filters
    fx = [-1 0 1];
    fy = fx';
    Gx = imfilter(imgC, fx, 'replicate');
    Gy = imfilter(imgC, fy, 'replicate');

    % Magnitude and orientation (0°–180°)
    [thetaRad, mag] = cart2pol(Gx, Gy);
    thetaDeg = rad2deg(thetaRad);
    thetaDeg(thetaDeg < 0) = thetaDeg(thetaDeg < 0) + 180;

    % Build per-cell histograms
    cellHist = zeros(nCellsY, nCellsX, numBins);
    binSize = 180 / numBins;

    for cy = 1:nCellsY
        rStart = (cy-1)*nRowsCell + 1;
        rEnd   = cy*nRowsCell;
        for cx = 1:nCellsX
            cStart = (cx-1)*nColsCell + 1;
            cEnd   = cx*nColsCell;

            patchOri = thetaDeg(rStart:rEnd, cStart:cEnd);
            patchMag = mag(rStart:rEnd, cStart:cEnd);

            patchOri = patchOri(:);
            patchMag = patchMag(:);

            binIdx = floor(patchOri / binSize) + 1;
            binIdx(binIdx > numBins) = numBins;

            for p = 1:numel(binIdx)
                b = binIdx(p);
                cellHist(cy, cx, b) = cellHist(cy, cx, b) + patchMag(p);
            end
        end
    end

    % Block normalization (2×2 cells)
    nBlocksY = nCellsY - 1;
    nBlocksX = nCellsX - 1;
    hogVector = [];

    for by = 1:nBlocksY
        for bx = 1:nBlocksX
            h1 = cellHist(by    , bx    , :);
            h2 = cellHist(by    , bx + 1, :);
            h3 = cellHist(by + 1, bx    , :);
            h4 = cellHist(by + 1, bx + 1, :);
            blockHist = [h1(:); h2(:); h3(:); h4(:)];

            epsil = 1e-6;
            normFactor = sqrt(sum(blockHist.^2) + epsil^2);
            blockHist = blockHist / normFactor;

            hogVector = [hogVector; blockHist];
        end
    end

    hogVector = hogVector(:).';
end
