function [SVM_Mdl,meas,label ] = trainsvm( folder , iter)

addpath('nmflib');
addpath('CQT_2013');
load('W');
[R,~] = size(W);
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
        [w,h,errs,vout] = nmf_base(X',R,'W0',W','W',W','niter',iter,'verb', 1,'lambda',2,'epsilon',1E-5);
        [a,b] = size(h);
        label_temp = [];
        for u=1:b
            %label_temp{u} = class_list{i};
            label_temp(u) = double(i);
        end
    	label = [label,label_temp];
        
        h(h<0.01) = 0;
        meas = [meas;h'];
        fprintf('%s','done');
        fprintf('\n');
    end
    
   
end
label = label';
meas = sparse(meas);

%SVM_Mdl = fitcecoc(meas,label);
for k=1:length(class_list)
    SVM_Mdl{k} = train(double(label==k),meas,'-s 1');
end
save('SVM_Mdl','SVM_Mdl');