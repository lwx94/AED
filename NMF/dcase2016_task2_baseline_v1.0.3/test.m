
load('training_data.mat');
% load('SVM_Mdl.mat');
nfold = 10;
%# cross-validate using one-vs-all approach
opts = '-s 6 -c 2 -e 0.01';    %# libsvm training options
mode = '-s 0 ';
cost = ' -c';
tol = ' -e';
X = sparse(X);
for k = 1:1
    for m=1:1
%         opts = [mode,cost,' ',num2str(k+12),tol,' ',num2str(0.02*m)];
        [conf,acc(k,m)] = libsvmcrossval_ova(Y', X, opts, nfold);
%         [conf,acc(k,m)] = libsvmcrossval_ova(label, meas, opts, nfold);
        fprintf('Cross Validation Accuracy = %.4f%%\n', 100*mean(acc(k,m)));
        draw_cm(conf,class_list,length(class_list));
%         [pred,acc,prob] = libsvmpredict_ova(label, meas, SVM_Mdl);

    end
end
%# compute final model over the entire dataset
%mdl = libsvmtrain_ova(labels, data, opts);
