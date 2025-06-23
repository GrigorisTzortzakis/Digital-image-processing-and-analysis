
%  Specify number of classes
numClasses = 10;  

%  Compute confusion matrix via local function
CM = myConfusionMatrix(YTest, predLabels, numClasses);

%  Display CM in command window
disp('Confusion Matrix (rows = true label, columns = predicted label):');
disp(CM);

%  Plot CM as an image and overlay numeric counts
figure;
imagesc(CM);
colormap(flipud(gray));
colorbar;
xlabel('Predicted Label');
ylabel('True Label');
title('Confusion Matrix (HOG cellSize = [8 8])');
axis square;
set(gca, 'XTick', 1:numClasses, 'XTickLabel', 0:(numClasses-1));
set(gca, 'YTick', 1:numClasses, 'YTickLabel', 0:(numClasses-1));

% Overlay numeric counts on each cell
maxCount = max(CM(:));
for row = 1:numClasses
    for col = 1:numClasses
        count = CM(row, col);
        if count > 0
      
            if count > maxCount/2
                txtColor = [1 1 1];
            else
                txtColor = [0 0 0];
            end
            text(col, row, num2str(count), ...
                 'HorizontalAlignment', 'center', ...
                 'Color', txtColor, 'FontWeight', 'bold');
        end
    end
end


% Local function
function CM = myConfusionMatrix(trueLabels, predLabels, numClasses)
  

    CM = zeros(numClasses, numClasses);
    N = numel(trueLabels);
    for k = 1:N
        t = trueLabels(k) + 1;  
        p = predLabels(k) + 1;
        CM(t, p) = CM(t, p) + 1;
    end
end
