function [traindata, traintruth, testdata, testtruth] = xfoldshuffle(inittrain, inittraintruth, inittest, inittesttruth)
[m,~] = size(inittrain); 
[n,~] = size(inittest); 
temp = inittest;
temptruth = inittesttruth; 
testdata = inittrain(m-n+1:end,:);
testtruth = inittraintruth(m-n+1:end,:);
inittrain(m-n+1:end,:) = [];
inittraintruth(m-n+1:end,:) = [];
traindata = [temp; inittrain];
traintruth = [temptruth; inittraintruth]; 
end