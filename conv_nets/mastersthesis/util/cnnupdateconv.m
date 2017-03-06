function [conv_op] = cnnupdateconv(poolmap,delta,trainsize)
%% 1D convolution with kernel flipping without zero padding and no boundary
conv_stride = 1;
[i1 , i2] = size(poolmap);
[f1 , f2] = size(delta);
jump = i1/(trainsize*f1);

filt = fliplr(delta);
conv_op = zeros(f1/i1,(i2-f2)*conv_stride+1);

for p = 1:f1/i1
    for n = 1:i1
        conv_op(p,:) = conv_op(p,:) + conv(poolmap(n,:),filt((n-1)*f1/i1+p,:),'valid');
    end
end
[~, c2] = size(conv_op); 
conv_op = 2*conv_op/c2; 
end

