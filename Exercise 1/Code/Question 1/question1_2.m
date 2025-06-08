
%  make sure I_mod is in workspace
if ~exist('I_mod','var')
    error(['Variable I_mod not found. ', ...
           'Please run your preprocessing script first to produce I_mod.']);
end

[M, N] = size(I_mod);

%  Row column 2D DFT using 1D fft
%   First along rows  then along columns 
F_row = fft(I_mod, [], 2);
F2    = fft(F_row, [], 1);

%  Amplitude
amp = abs(F2);

figure('Position',[100 100 900 350]);

subplot(1,2,1);
imshow(amp, []);
title('Linear Amplitude |F(u,v)|','FontSize',12);
xlabel('u'); ylabel('v');

subplot(1,2,2);
imshow(log(1 + amp), []);
title('Log Amplitude log(1+|F(u,v)|)','FontSize',12);
xlabel('u'); ylabel('v');
