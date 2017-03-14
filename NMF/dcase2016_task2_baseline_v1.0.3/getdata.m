
X = [];
Y = [];


%% setting1
% folder = 'G:\AED\NMF\dcase2016_task2_baseline_v1.0.3\dcase';
% fileList = dir([folder '/' '*.mat']);
% 
% for k=1:length(fileList)
%     load([folder,'\',fileList(k).name]);
%     display(['processing file',num2str(k),' from ',num2str(length(fileList))])
%     X = [X;meas];
%     Y = [Y,label];
% end
%% setting2
% folder = 'G:\AED\NMF\dcase2016_task2_baseline_v1.0.3\train';
% class_list = {'acoustic_guitar','airplane','applause','bird','car','cat','child','church_bell','crowd','dog_barking','engine',...
%     'fireworks','footstep','glass_breaking','hammer','helicopter','knock','laughter','mouse_click','ocean_surf','rustle','scream',...
%     'speech_fs','squeak','tone','violin','water_tap','whistle'};
%  for k=1:length(class_list)
%     fileList = dir([folder '/' class_list{k} '*.mat']);
%     for m=1:5
%         display(['processing file',num2str(m),'from ',class_list{k}])
%         load([folder,'\',fileList(m).name]);
%         X = [X;meas];
%         Y = [Y,label];
%     end
%  end

save('training_data.mat','X','Y');