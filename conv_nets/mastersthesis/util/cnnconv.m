function [conv_op] = cnnconv(input,filter)
%% 1D convolution with kernel flipping without zero padding and no boundary
conv_stride = 1; 
[i1 , i2] = size(input);
[f1 , f2] = size(filter);
filt = fliplr(filter);
conv_op = zeros(i1*f1,(i2-f2)*(1/conv_stride)+1); 
for i = 1:i1
    for  j = 1:f1
        conv_op((i-1)*f1+j,:) = conv(input(i,:),filt(j,:),'valid');
        
    end
end
[~, c2] = size(conv_op); 
conv_op = 2*conv_op/c2; 

end

