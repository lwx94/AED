iter = 50;
R1 = 220;
R2 = 10;
K = 20;
% DCASE DATA
dic_folder = 'G:\School\thesis\Data\dcase 2016 task 2\dcase2016_task2_train_dev';
train_folder = 'G:\School\thesis\Data\dcase 2016 task 2\dcase2016_task2_train_dev\dcase2016_task2_train';
test_folder = 'G:\School\thesis\Data\dcase 2016 task 2\dcase2016_task2_train_dev\dcase2016_task2_dev\sound';

class_list = {'clearthroat','cough', 'doorslam', 'drawer', 'keyboard', 'keys', 'knock', 'laughter', 'pageturn', 'phone', 'speech'};

%Sat Lab Data

% dic_folder = 'G:\School\thesis\Data';
% train_folder = 'G:\School\thesis\Data\trainset';
% test_folder = 'G:\School\thesis\Data\testset';
% all_folder = 'G:\School\thesis\Data\Wav_original';
% 
% class_list = {'acoustic_guitar','airplane','applause','bird','car','cat','child','church_bell','crowd','dog_barking','engine',...
%     'fireworks','footstep','glass_breaking','hammer','helicopter','knock','laughter','mouse_click','ocean_surf','rustle','scream',...
%     'speech_fs','squeak','tone','violin','water_tap','whistle'};
% 
getdictionary(dic_folder,R1,R2,K,iter);
[label,meas ] = getactivations( train_folder , class_list,iter,K );
% trainsvm(train_folder,iter);
% batchEventDetection(test_folder,K);
%  test