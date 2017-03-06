function [signal, groundtruth] = randomize(totaldata, truth, numSignals)
%% function to randomize signals
shuffle = randperm(numSignals);
signal = totaldata(shuffle,:);
groundtruth = truth(shuffle,:);
end