clear ; close all; clc; 
%% load library, data and parameters
addpath('..\util');
load('k4validbal2c.mat')
[cnni, cnno, cnnp]= interim_wt021(init);
%% Start convolution
    % 1st layer of convolution
cnni.fmap_L1 = cnnconv(init.traindata,cnni.convfilt_L1);
cnni.poolmap_L1 = max_pool(cnni.fmap_L1,init.poolstride);
layer1 = tanh_mod(cnni.poolmap_L1); 
    % 2nd layer of convolution
cnni.fmap_L2 = cnnconv(layer1,cnni.convfilt_L2);
cnni.poolmap_L2 = max_pool(cnni.fmap_L2,init.poolstride);
layer2 = tanh_mod(cnni.poolmap_L2);
    % connection to MLFF layer
cnni.fcL1 = reshape(layer2,[init.trainsize, numel(layer2)/init.trainsize]);
cnni.fcL2 = tanh_mod((cnni.fcL1*cnni.fcL1W)); 
    % error calculation 
cnno.calculated_op = tanh_mod(cnni.fcL2*cnni.fcL2W); 
cnno.error = loss_tanhmod(cnno.calculated_op,init.desired_train_op);




