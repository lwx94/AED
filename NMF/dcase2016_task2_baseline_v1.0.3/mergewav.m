function [] = mergewav(folder)
fileList = dir([folder '/' '*.wav']);
X = [];
for i=1:length(fileList)
    disp(['reading file ' fileList(i).name 'file' num2str(i) 'from' num2str(length(fileList))]);
    [x,fs] = audioread([folder '/' fileList(i).name]);
    X = [X;x];
end
audiowrite([folder '/train.wav'],X,fs);