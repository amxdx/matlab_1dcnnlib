function [desired_op] = truth4c(numSignals,lenclass1,lenclass2,lenclass3,lenclass4)
%% extracting groundtruth as a 5 class data
desired_op = zeros(numSignals,4);
for i = 1:numSignals
    
    if i <= lenclass1
        temp = [1 0 0 0];
    elseif i <= lenclass1+lenclass2
        temp = [0 1 0 0];
    elseif i <= lenclass1+lenclass2+lenclass3
        temp = [0 0 1 0];
    elseif i <= lenclass1+lenclass2+lenclass3+lenclass4
        temp = [0 0 0 1];
    end
    desired_op(i,:) = temp';
end
end