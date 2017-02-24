function [intCQT] = computeVQT(filename)
% Settings for computing VQT (60 bins/octave, gamma = 30)


% PARAMETERS
fs = 44100;
fmin = 27.5;
B = 60;
gamma = 30; 
fmax = fs/2;


% Load .wav file
% wavread removed
% [x,fs,bits] = wavread(filename);
[x,fs] = audioread(filename);
if (size(x,2) == 2) y = mean(x')'; else y=x; end;
if (fs ~= 44100) y = resample(y,44100,fs); end;
y = 0.5*y/max(y); % normalize!
fs = 44100;


% Compute VQT
Xcq = cqt(y, B, fs, fmin, fmax, 'rasterize', 'full','gamma', gamma);
intCQT = Xcq.c;
intCQT = abs(intCQT(1:545,:));