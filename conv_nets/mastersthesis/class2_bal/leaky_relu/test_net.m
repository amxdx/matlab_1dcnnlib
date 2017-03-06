function [stats] = test_net(filt, data,boundary, truth)
[m,~] = size(data);
fmap_L1 = cnnconv(data,filt.convfilt_L1);
poolmap_L1 = max_pool(fmap_L1,filt.poolstride);
layer1 = relu_leaky(poolmap_L1,filt.relu_grad);
% 2nd layer of convolution
fmap_L2 = cnnconv(layer1,filt.convfilt_L2);
poolmap_L2 = max_pool(fmap_L2,filt.poolstride);
layer2 = relu_leaky(poolmap_L2,filt.relu_grad);
% connection to MLFF layer
fcL1 = fwdarrange(layer2,m);
fcL2 = relu_leaky((fcL1*filt.fcL1W),filt.relu_grad);
% error calculation
calculated_op = relu_leaky(fcL2*filt.fcL2W,filt.relu_grad);
p = -1:boundary:1;
stats = zeros(length(p), 9);
for i = 1:length(p)
    l = calculated_op >= p(i) ;
    tp = 0; tn = 0; fn = 0; fp = 0;
    for j = 1: m
        if (l(j) == 1 && truth(j) == 1)
            tp = tp+1;
        elseif (l(j)==0 && truth(j) == 0)
            tn = tn+1;
        elseif (l(j) == 0 && truth(j) == 1)
            fn = fn+1;
        elseif (l(j)==1 && truth(j) == 0)
            fp = fp+1;
        else
            
        end
        Spec  = 100*tn /(tn +fp );
        Sen  = 100*tp /(tp +fn );
        Selc  = 100*tp /(tp +fp );
        total  = tp  +tn +fp +fn ;
        Percentage  = 100*(tp +tn )/total ;
        stats(i,:) = [p(i) tp tn fp fn Spec Sen Selc Percentage];
        
    end
       
end
