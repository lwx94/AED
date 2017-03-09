iter = 100;
R1 = 220;
R2 = 10;
K = 22;

dic_folder = 'G:\School\thesis\Data\dcase 2016 task 2\dcase2016_task2_train_dev';
train_folder = 'G:\School\thesis\Data\dcase 2016 task 2\dcase2016_task2_train_dev\dcase2016_task2_train';
test_folder = 'G:\School\thesis\Data\dcase 2016 task 2\dcase2016_task2_train_dev\dcase2016_task2_dev\sound';
getdictionary(dic_folder,R1,R2,K,iter);
trainsvm(train_folder,iter);
batchEventDetection(test_folder);
 