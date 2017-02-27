function [meas,label ] = trainsvm( folder ,beta, iter)

addpath('nmflib');
addpath('CQT_2013');
load('W');

class_list = {'clearthroat','cough', 'doorslam', 'drawer', 'keyboard', 'keys', 'knock', 'laughter', 'pageturn', 'phone', 'speech'};
fileList = dir([folder '/*.wav']);

meas = [];
label = [];
% Perform NMF with beta-divergence
for i=1:length(class_list)
    fileList = dir([folder '/' class_list{i} '*.wav']);
    for k=1:length(fileList)
        fprintf('%s',['Performing NMF on ' fileList(k).name  '............ ']);
        [intCQT] = computeVQT([folder '/' fileList(k).name]);
        X = intCQT(:,1:10:size(intCQT,2))';
        [w,h,errs,vout] = nmf_beta(X',4,'W0',W','W',W','niter',iter,'verb', 1,'beta',beta);
        [a,b] = size(h);
        label_temp = [];
        for u=1:b
            label_temp{u} = class_list{i};
        end
    	label = [label,label_temp];
        
        meas = [meas;h'];
        fprintf('%s','done');
        fprintf('\n');
    end
    
   
end
label = label';

SVM_Mdl = fitcecoc(meas,label);