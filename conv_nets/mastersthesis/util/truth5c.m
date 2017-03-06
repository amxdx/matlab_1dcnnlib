function [desired_op] = truth5c(groundtruth,numSignals)
%% extracting groundtruth as a 5 class data
desired_op = zeros(numSignals,5);
for i = 1:numSignals
    
    if groundtruth(i) == 201
        temp = [1 0 0 0 0];
    elseif groundtruth(i) == 202
        temp = [0 1 0 0 0];
    elseif groundtruth(i) == 203
        temp = [0 0 1 0 0];
    elseif groundtruth(i) == 204
        temp = [0 0 0 1 0];
    else
        temp = [0 0 0 0 1];
    end
    desired_op(i,:) = temp';
end
end