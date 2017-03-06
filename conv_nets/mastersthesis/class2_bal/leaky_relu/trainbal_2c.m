clear ; close all; clc;
%% load library, data and parameters
addpath('..\..\util');
load('k4rectbal2c.mat')
[interim, output, param, update, filt]= interim_wt121(init,25);
grad = 0.01;
filt.relu_grad = grad;
filt.poolstride = init.poolstride;
interval = 0.1; 
p = length(-1:interval:1); 

[init.traindata, init.desired_train_op, init.testdata, init.desired_test_op] = ...
    xfoldshuffle(init.traindata, init.desired_train_op, init.testdata, init.desired_test_op);
init.traindata(:,76) = 1;
    for iter = 1:param.num_iter
        %% Forward Pass
        % 1st layer of convolution
        interim.fmap_L1 = cnnconv(init.traindata,filt.convfilt_L1);
        interim.poolmap_L1 = max_pool(interim.fmap_L1,init.poolstride);
        layer1 = relu_leaky(interim.poolmap_L1,grad);
        % 2nd layer of convolution
        interim.fmap_L2 = cnnconv(layer1,filt.convfilt_L2);
        interim.poolmap_L2 = max_pool(interim.fmap_L2,init.poolstride);
        layer2 = relu_leaky(interim.poolmap_L2,grad);
        % connection to MLFF layer
        interim.fcL1 = fwdarrange(layer2,init.trainsize);
        interim.fcL2 = relu_leaky((interim.fcL1*filt.fcL1W),grad);
        % error calculation
        output.calculated_op = relu_leaky(interim.fcL2*filt.fcL2W,grad);
        output.error = init.desired_train_op - output.calculated_op ;
        output.E(iter) = loss_sqdiff(output.calculated_op,init.desired_train_op);
        %% Backpropagation
        % calculating deltas for the fully connected layer
        delta.fcl2 = -output.error.*grad_reluleaky(output.calculated_op,grad);
        delta.fcl1 = delta.fcl2*filt.fcL2W'.*grad_reluleaky(interim.fcL2,grad);
        % delta for 2nd convolution output layer
        delta.fcl0 = delta.fcl1*filt.fcL1W'.*grad_reluleaky(interim.fcL1,grad);
        
        update.fclW2 = interim.fcL2'*delta.fcl2;
        update.fclW1 = interim.fcL1'*delta.fcl1;
        
        delta.fsub2 = bwdarrange(delta.fcl0,param.numfilt_phase1*param.numfilt_phase2);
        delta.fconv2 = repelem(delta.fsub2,1,2);
        delta.fsub1 = cnnbackconv(delta.fconv2,filt.convfilt_L2,init.trainsize).*grad_reluleaky(interim.poolmap_L1,grad);
        delta.fconv1 = repelem(delta.fsub1,1,2);
        delta.fconv0 = cnnbackconv(delta.fconv1,filt.convfilt_L1,init.trainsize).*grad_reluleaky(init.traindata,grad);
        update.fconvfilt_L2 = cnnupdateconv(interim.poolmap_L1,delta.fconv2,init.trainsize)/12;
        update.fconvfilt_L1 = cnnupdateconv(init.traindata,delta.fconv1,init.trainsize)/6;
        
        filt.fcL2W = filt.fcL2W - param.fc2rate*update.fclW2;
        filt.fcL1W = filt.fcL1W - param.fc1rate*update.fclW1;
        
        filt.convfilt_L2 = filt.convfilt_L2 - param.fconv2rate*update.fconvfilt_L2;
        filt.convfilt_L1 = filt.convfilt_L1 - param.fconv1rate*update.fconvfilt_L1;
        
        
        output.E(iter)
    end
    
    plot(1:iter,output.E);
    
    train_results = test_net(filt, init.traindata, interval, init.desired_train_op);
    test_results = test_net(filt, init.testdata, interval, init.desired_test_op);
    
