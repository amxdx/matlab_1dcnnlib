function [conv_op] = cnnbackconv(input,filter,trainsize)
%% 1D convolution with kernel flipping without zero padding and no boundary
conv_stride = 1;
[i1 , i2] = size(input);
[f1 , f2] = size(filter);
jump = i1/(trainsize*f1);

filt = fliplr(filter);
conv_op = zeros(trainsize*jump,(i2+f2)*(1/conv_stride)-1);
for p = 1:f1
    for n = 1:trainsize*jump
        conv_op(n,:) = conv_op(n,:) +  conv(input((n-1)*f1+p,:),filt(p,:));
    end
end
[~, c2] = size(conv_op); 
conv_op = 2*conv_op/c2; 
end

