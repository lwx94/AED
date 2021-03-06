function  []  = batchEventDetection(folder,K)
% DbatchCASE 2016 - Task 2 - Event Detection
% http://www.cs.tut.fi/sgn/arg/dcase2016/task-synthetic-sound-event-detection
%
% Performs event detection to a collection of audio recordings
% using pre-defined parameters
%
% Input: folder - path to audio recordings
% 
% e.g. batchEventDetection('dcase2016_task2_dev/sound');

fileList = dir([folder '/*.wav']);
for i=1:length(fileList)
    pred = eventDetection([folder '/' fileList(i).name],K,30,0.6,1.0,9,5,0.06);
    a = 0;
end;