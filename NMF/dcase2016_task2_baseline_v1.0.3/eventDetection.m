function [predicted_labels] = eventDetection(filename,iter,beta,thr,mf,maxpoly,mindur)
% DCASE 2016 - Task 2 - Event Detection
% http://www.cs.tut.fi/sgn/arg/dcase2016/task-synthetic-sound-event-detection
%
% Detects events for an audio recording and stores a list of detected events as a .txt file
% Core event detection method uses non-negative metrix factorization (NMF)
% with beta-divergence
% 
% Inputs: 
%   filename - filename for audio recording
%   iter - number of iterations for NMF algorithm (e.g. 30)
%   beta - beta-divergence parameter in NMF algorithm (should be 0-2, e.g. 0.6)
%   thr - threshold for binarizing NMF event activation (e.g. 1.0)
%   mf - median filter length (1 sample = 10ms) for event activation smoothing (e.g. 9)
%   maxpoly - maximum number of concurrent events (e.g. 5)
%   mindur - minimum duration for detected event in sec (e.g. 0.06)
%
% Output: results are stored in a 'filename.txt' file per DCASE 2016
% guidelines, in the same folder as in the audio recording
%
% e.g. eventDetection('dcase2016_task2_dev/sound/dev_1_ebr_0_nec_1_poly_0.wav',30,0.6,1.0,9,5,0.06);


% Load spectral templates and initialize
addpath('nmflib');
addpath('CQT_2013');
warning('off');
load('W');
load('SVM_Mdl');
class_list = {'clearthroat','cough', 'doorslam', 'drawer', 'keyboard', 'keys', 'knock', 'laughter', 'pageturn', 'phone', 'speech'};
[R,~] = size(W);


% Compute VQT spectrogram
disp('DCASE 2016 - Task 2 - Event Detection');
disp(['File: ' filename]);
fprintf('%s',['Preprocessing............']);
[intCQT] = computeVQT(filename);
X = intCQT(:,round(1:5.2883:size(intCQT,2)))'; % 10ms step


% Emphasize high freqs and remove low frequency bins
%f = X(:,21:end)';
%f = f .* repmat( linspace( 1, 15, size( f, 1))', 1, size( f, 2));
%X =f';


% Remove background noise from input
p1 = prctile(sum(X'),5);
p2 = prctile(sum(X'),10);
silentFrames = find(sum(X')>p1 & sum(X')<p2);
silentTemplate = mean(X(silentFrames,:));
noiseLevel = repmat(silentTemplate,[size(X,1) 1]);
Y = max(X - noiseLevel,0);
fprintf('%s','done');
fprintf('\n');


% Perform NMF with noise dictionary
fprintf('%s',['Performing NMF...........']);
[w,h,errs,vout] = nmf_noise(Y',R,'W0',W','W',W','niter',iter,'verb', 1,'lambda',2,'epsilon',1E-5);
fprintf('%s','done');
fprintf('\n');

% SVM predict
fprintf('%s',['Predicting...........']);
[a,b] = size(h);
predicted_labels = libsvmpredict(rand(b,1),h',SVM_Mdl,'');


% Create event-roll representation
%fprintf('%s',['Postprocessing...........']);
%h_reshaped = reshape(h,[20 length(class_list) size(h,2)]);
%eventRoll = squeeze(sum(h_reshaped,1))';
% 
% 
% Impose constraint on maximum number of concurrent events
% [B,IX] = sort(eventRoll,2,'descend');
% tempEventRoll = zeros(size(eventRoll,1),length(class_list));
% for j=1:size(eventRoll,1) for k=1:maxpoly tempEventRoll(j,IX(j,k)) = B(j,k); end; end;
% eventRoll = tempEventRoll;
% eventRoll = medfilt1(eventRoll,mf);

% 
% % Perform thresholding and create a list of detected events
% path = (eventRoll > thr);  
% [onset,offset,classNames] = convertEventRolltoEventList(path,mindur,0.06,class_list);
% 
% 
% % Write output to .txt file
% filename = strrep(filename,'.wav','');
% fid=fopen([filename '.txt'],'w');
% for i=1:length(onset)
%     fprintf(fid,'%.2f\t%.2f\t%s\n',onset(i),offset(i),classNames{i});
% end;
% fclose(fid);
% fprintf('%s','done');
% fprintf('\n');