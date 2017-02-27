function [] = getdictionary(folder)
% DCASE 2016 - Task 2 - Event Detection
% http://www.cs.tut.fi/sgn/arg/dcase2016/task-synthetic-sound-event-detection
%
% Training function: extracts a series of spectral templates per event class
% using the training set of isolated event sounds and saves a dictionary 
% of spectral templates for all events ('W.mat').
%
% Input: folder - path to training dataset
%
% e.g. training('dcase2016_task2_train');


% Initialize
addpath('nmflib');
addpath('CQT_2013');
% classID = {'clearthroat','cough', 'doorslam', 'drawer', 'keyboard', 'keys', 'knock', 'laughter', 'pageturn', 'phone', 'speech'};
% classID = {'test'};
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
% Compute spectral templates per event class
disp('DCASE 2016 - Task 2 - Training');
%for i=1:length(classID)
disp(['Computing spectral templates' ]);
spectralTemplates = computeSpectralTemplates(folder,4);
save([folder '/' 'spectralTemplates_' ],'spectralTemplates');
%end


% Stack event class templates and emphasize high frequencies
W = [];

%for i=1:length(1)
%    load([folder '/' 'spectralTemplates_']);
        
%    f = squeeze(spectralTemplates(:,21:end))'; % Emphasize high frequencies
%    f = f .* repmat( linspace( 1, 15, size( f, 1))', 1, size( f, 2));
%    spectralTemplates(:,21:end) = f';
    
%    W = [W; spectralTemplates];

%end


% Remove low frequency bins and normalise
%W = W(:,21:end); 
%for i=1:size(W,1) 
 %   W(i,:) = W(i,:) / sum(W(i,:)); 
%end;


%Save dictionary matrix
save('W','W');
disp('Done');



% computeSpectralTemplates:
% Function that computes a set of spectral templates for a given event class
% (one template per training recording)
function [spectralTemplates] = computeSpectralTemplates(folder,K)


% Initialize
fileList = dir([folder '/' '*.wav']);

% For each file
for i=1:length(fileList)
    
    % Compute VQT spectrogram
    [intCQT] = computeVQT([folder '/' fileList(i).name]);
    X = intCQT(:,1:10:size(intCQT,2))'; 
    
    % Perform NMF with beta-divergence for template extraction
    %changin verbosity
    %[w,h,errs,vout] = nmf_beta(X',1,'W0',mean(X)','niter', 10, 'verb', 1,'beta',0.6);
   
    [miu,w,h,errs,vout] = nmf_u_g(X',49,'niter',10,'K',K,'verb',3);
    [w_mld,h_mld,errs_mld,vout_mld] = nmf_mld(X',miu,'niter',10,'verb',3);
    % Add to dictionary
    spectralTemplates = w_mld';   
    
end;