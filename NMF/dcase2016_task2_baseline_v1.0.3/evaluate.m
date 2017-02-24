function  [sb_results,eb_results]  = evaluate(resultsFolder,GTFolder)
% DCASE 2016 - Task 2 - Event Detection
% http://www.cs.tut.fi/sgn/arg/dcase2016/task-synthetic-sound-event-detection
%
% Event detection evaluation (segment-based and event-based metrics)
% Note: scores are computed per dataset and not averaged across recordings
%
% Inputs:
%   resultsFolder - path to system .txt outputs
%   GTFolder - path to reference annotations
%
% Outputs:
%   sb_results - structure with segment-based results (see e.g. sb_results.overall)
%   eb_results - structure with onset-only event-based results (see e.g. eb_results.overall)
%
% e.g. [sb_results,eb_results] = evaluate('dcase2016_task2_dev/sound','dcase2016_task2_dev/annotation');


% Initialize
addpath('metrics');
class_list = {'clearthroat','cough', 'doorslam', 'drawer', 'keyboard', 'keys', 'knock', 'laughter', 'pageturn', 'phone', 'speech'};
disp('DCASE 2016 - Task 2 - Evaluation');
fileList = dir([resultsFolder '/*.txt']);
sb = DCASE2016_EventDetection_SegmentBasedMetrics(class_list);
eb = DCASE2016_EventDetection_EventBasedMetrics(class_list);


for i=1:length(fileList)

    % Load system output
    [onset,offset,classNames] = loadEventsList([resultsFolder '/' fileList(i).name]);
    system_output = [];
    for k=1:length(onset)
        system_output(k).event_onset = onset(k);
        system_output(k).event_offset = offset(k);
        system_output(k).event_label = classNames{k};
    end;
    system_output = system_output';
    
    % Load ground truth
    [onsetGT,offsetGT,classNamesGT] = loadEventsList([GTFolder '/' fileList(i).name]);
    annotated_event = [];
    for k=1:length(onsetGT)
        annotated_event(k).event_onset = onsetGT(k);
        annotated_event(k).event_offset = offsetGT(k);
        annotated_event(k).event_label = classNamesGT{k};
    end;
    annotated_event = annotated_event';
    
    % Compute scores for recording    
    sb.evaluate(system_output,annotated_event);
    eb.evaluate(system_output,annotated_event);
        
end;

% Compute overall results
sb_results = sb.results();
eb_results = eb.results();

% Display some results
sb_results_overall = sb_results.overall
eb_results_overall = eb_results.overall
