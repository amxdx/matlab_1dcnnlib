function cal = calpoints(numconvs, filtsize, poolsize, mlff_inputsize)
%% function to calculate the feature vector size given the above param
for i = 1:numconvs
    temp = mlff_inputsize*poolsize + (filtsize-1);
    mlff_inputsize = temp;
end
cal = temp;
end