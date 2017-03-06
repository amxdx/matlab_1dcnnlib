function [trainsize, testsize, traindata, desired_train_op, testdata, desired_test_op] = ...
    xfoldsplit(normfinal,xfold,desired_output)
%% split data and groundtruth to give an x-fold matrix
[numSignals , ~] = size(normfinal); 
trainsize = round((1- 1/xfold)*numSignals);
testsize = numSignals - trainsize; 
traindata = normfinal(1:trainsize,:);
desired_train_op = desired_output(1:trainsize,:);
testdata =  normfinal(trainsize+1:end,:);
desired_test_op = desired_output(trainsize+1:end,:);
end