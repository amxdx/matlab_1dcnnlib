function [mpool] = max_pool(input,stride) 
%% take input parameters
[len, num] = size(input); 
mpool = zeros(len,floor(num/stride));
for i = 1:len
iter = 1; 
while iter < floor(num/stride)
    mpool(i,iter) = max(input(i,( stride*iter - ceil(stride/2)):(stride*iter + ceil(stride/2))));
    iter = iter + 1;
end
mpool(i,iter) = max(input(i,( stride*iter - ceil(stride/2) + 1):end));
end
end

