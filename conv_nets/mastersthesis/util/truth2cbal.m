function [desired_op] = truth2cbal(numSignals)
%% extracting groundtruth as a 2 class data
desired_op = zeros(numSignals,1);
for i = 1:numSignals
    if i <= numSignals/2
        temp = 0;
    elseif i >numSignals/2
        temp = 1;
    end
    desired_op(i,:) = temp';
end
end