iter = 30;
R1 = 220;
R2 = 46;
K = 4;
beta = 0.6;

dic_folder = 'G:\School\thesis\Data\dcase 2016 task 2\dcase2016_task2_train_dev';
train_folder = 'G:\School\thesis\Data\dcase 2016 task 2\dcase2016_task2_train_dev\dcase2016_task2_train';
getdictionary(dic_folder,R1,R2,K,iter);
trainsvm(train_folder,beta,iter);
batchEventDetection(train_folder);
