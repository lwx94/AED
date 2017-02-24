function [onset,offset,classNames] = convertEventRolltoEventList(eventRoll,minDur,shift,class_list)


% Initialize
onset = []; offset = []; classNames = [];


% Find note events on expandedEventRoll
auxEventRoll = diff([zeros(1,length(class_list)); eventRoll; zeros(1,length(class_list));],1); k=0;

for i=1:length(class_list)
    onsets = find(auxEventRoll(:,i)==1);
    offsets = find(auxEventRoll(:,i)==-1);
    for j=1:length(onsets)
        if((offsets(j)/100-0.01) - (onsets(j)/100) > minDur) % Minimum duration pruning!
            k=k+1;
            onset(k) = max(onsets(j)/100-shift,0);
            offset(k) = offsets(j)/100-0.01;
            classNames{k} = class_list{i};
        end;
    end;
end;