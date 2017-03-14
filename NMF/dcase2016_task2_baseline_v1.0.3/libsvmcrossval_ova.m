function [conf,acc] = libsvmcrossval_ova(y, X, opts, nfold, indices)
    if nargin < 3, opts = ''; end
    if nargin < 4, nfold = 10; end
    if nargin < 5, indices = crossvalidation(y, nfold); end

    %# N-fold cross-validation testing
    acc = zeros(nfold,1);
    conf = zeros(max(y));
    for i=1:nfold
        display([num2str(i),' fold processing']);
        testIdx = (indices == i); trainIdx = ~testIdx;
        mdl = libsvmtrain_ova(y(trainIdx), X(trainIdx,:), opts);
        [pred,acc(i)] = libsvmpredict_ova(y(testIdx), X(testIdx,:), mdl);
        yy = y(testIdx);
        for m=1:length(pred)
            p = pred(m);
            t = yy(m);
            conf(t,p) = conf(t,p)+1;
        end
    end
    a = sum(conf,2);
    for i=1:max(y)
        conf(i,:) = conf(i,:)/a(i);
    end
    acc = mean(acc);    %# average accuracy
end

function indices = crossvalidation(y, nfold)
    %# stratified n-fold cros-validation
    %#indices = crossvalind('Kfold', y, nfold);  %# Bioinformatics toolbox
    cv = cvpartition(y, 'kfold',nfold);          %# Statistics toolbox
    indices = zeros(size(y));
    for i=1:nfold
        indices(cv.test(i)) = i;
    end
end

