
clear; close all; clc;

%%PARAMETERS
blockSize = 32;
r_list    = linspace(0.05,0.50,10);   
examples  = [0.10, 0.30, 0.50];       
imgFile   = 'board.png';


I0 = im2double(imread(imgFile));
if size(I0,3)==3
    I = rgb2gray(I0);
else
    I = I0;
end
[H,W] = size(I);
Hc = floor(H/blockSize)*blockSize;
Wc = floor(W/blockSize)*blockSize;
I  = I(1:Hc,1:Wc);

% COMPUTE MSEs FOR ALL r 
MSE_thr = zeros(size(r_list));
for idx = 1:numel(r_list)
    r = r_list(idx);
    K = round(r * blockSize^2);    
    recon = zeros(size(I));
    
    for i = 1:blockSize:Hc
        for j = 1:blockSize:Wc
            blk = I(i:i+blockSize-1, j:j+blockSize-1);
            C   = dct2(blk);
            
            % threshold
            cvec = abs(C(:));
            if K < numel(cvec)
                T = sort(cvec,'descend');
                T = T(K);
            else
                T = 0;
            end
            C(abs(C)<T) = 0;
            
            recon(i:i+blockSize-1,j:j+blockSize-1) = idct2(C);
        end
    end
    
    e = I - recon;
    MSE_thr(idx) = mean(e(:).^2);
end


fprintf('\n  r (%%)\tMSE (threshold)\n-------------------------\n');
for k = 1:numel(r_list)
    fprintf('  %6.1f\t%.4e\n', r_list(k)*100, MSE_thr(k));
end

% Figure 1: MSE vs. r
figure(1);
plot(r_list*100, MSE_thr, '-s','LineWidth',1.5);
xlabel('Percentage of Coefficients Kept r (%)');
ylabel('Mean Squared Error (MSE)');
title('MSE vs. Compression Ratio (Threshold Method)');
grid on;

% Figure 2: Full-image reconstructions 
figure(2);
subplot(2,2,1);
imshow(I);
title('Original');
axis off;

for m = 1:numel(examples)
    r = examples(m);
    K = round(r * blockSize^2);
    recon = zeros(size(I));
    for i = 1:blockSize:Hc
        for j = 1:blockSize:Wc
            blk = I(i:i+blockSize-1, j:j+blockSize-1);
            C   = dct2(blk);
            cvec = abs(C(:));
            if K < numel(cvec)
                T = sort(cvec,'descend');
                T = T(K);
            else
                T = 0;
            end
            C(abs(C)<T) = 0;
            recon(i:i+blockSize-1,j:j+blockSize-1) = idct2(C);
        end
    end
    
    subplot(2,2,m+1);
    imshow(recon);
    title(sprintf('r = %.0f%%', r*100));
    axis off;
end

% Figure 3: Zoomed patch 

r1 = 200; r2 = 300;
c1 = 400; c2 = 500;


recons = cell(size(examples));
for m = 1:numel(examples)
    r = examples(m);
    K = round(r * blockSize^2);
    R = zeros(size(I));
    for i = 1:blockSize:Hc
        for j = 1:blockSize:Wc
            blk = I(i:i+blockSize-1, j:j+blockSize-1);
            C   = dct2(blk);
            cvec = abs(C(:));
            if K < numel(cvec)
                T = sort(cvec,'descend');
                T = T(K);
            else
                T = 0;
            end
            C(abs(C)<T) = 0;
            R(i:i+blockSize-1,j:j+blockSize-1) = idct2(C);
        end
    end
    recons{m} = R;
end

figure(3);
subplot(1,4,1);
imshow(I(r1:r2,c1:c2));
title('Original patch');
axis off;

for m = 1:numel(examples)
    subplot(1,4,m+1);
    imshow(recons{m}(r1:r2,c1:c2));
    title(sprintf('r = %.0f%%', examples(m)*100));
    axis off;
end
