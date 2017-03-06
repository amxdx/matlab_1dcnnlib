function [desired_op] = truth2c(numSignals,length)
%% extracting groundtruth as a 2 class data
desired_op = zeros(numSignals,2);
for i = 1:numSignals
    if i <= length
        temp = [1 0];
    elseif i >length
        temp = [0 1];
    end
    desired_op(i,:) = temp';
end
end