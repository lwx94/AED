function [pred,acc,prob] = libsvmpredict_ova(y, X, mdl)
    %# classes
    labels = mdl.labels;
    numLabels = numel(labels);

    %# get probability estimates of test instances using each 1-vs-all model
    prob = zeros(size(X,1), numLabels);
    for k=1:numLabels
        [~,~,p] = predict(double(y==labels(k)), X, mdl.models{k}, '-b 1 -q');
        prob(:,k) = p(:, mdl.models{k}.Label==1);
    end

    %# predict the class with the highest probability
    [~,pred] = max(prob, [], 2);
    %# compute classification accuracy
    acc = mean(pred == y);
end