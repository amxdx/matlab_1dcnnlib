function [mpool] = mean_pool(input,stride) 
%% take input parameters to do mean pooling
len = length(input); 
mpool = zeros(floor(len/stride),1);
iter = 1; 
while iter < floor(len/stride)
    mpool(iter) = mean(input(( stride*iter - ceil(stride/2)):(stride*iter + ceil(stride/2))));
    iter = iter + 1;
end
mpool(iter) = mean(input(( stride*iter - ceil(stride/2) + 1):end));

end

