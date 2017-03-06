clear ; close all; clc; 
%% load library, data and parameters
addpath('..\..\util');
load('k4rectbal2c.mat')
[interim, output, param, update]= interim_wt121(init,10);
init.traindata(:,76) = 10; 
for iter = 1:param.num_iter
%% Forward Pass
    % 1st layer of convolution
interim.fmap_L1 = cnnconv(init.traindata,interim.convfilt_L1)/5;
interim.poolmap_L1 = max_pool(interim.fmap_L1,init.poolstride)/5;
layer1 = relu(interim.poolmap_L1); 
    % 2nd layer of convolution
interim.fmap_L2 = cnnconv(layer1,interim.convfilt_L2)/5;
interim.poolmap_L2 = max_pool(interim.fmap_L2,init.poolstride)/5;
layer2 = relu(interim.poolmap_L2);
    % connection to MLFF layer
interim.fcL1 = fwdarrange(layer2,init.trainsize);
interim.fcL2 = relu((interim.fcL1*interim.fcL1W))/1152; 
    % error calculation 
output.calculated_op = relu(interim.fcL2*interim.fcL2W)/200; 
output.error = init.desired_train_op - output.calculated_op ; 
output.E(iter) = sum(loss_sqdiff(output.calculated_op,init.desired_train_op));
%% Backpropagation 
 % calculating deltas for the fully connected layer
 delta.fcl2 = -output.error.*grad_relu(output.calculated_op); 
 delta.fcl1 = delta.fcl2*interim.fcL2W'.*grad_relu(interim.fcL2); 
 % delta for 2nd convolution output layer
 delta.fcl0 = delta.fcl1*interim.fcL1W'.*grad_relu(interim.fcL1);
 
 update.fclW2 = interim.fcL2'*delta.fcl2; 
 update.fclW1 = interim.fcL1'*delta.fcl1; 
 
 delta.fsub2 = reshape(delta.fcl0,...
     [init.trainsize*param.numfilt_phase1*param.numfilt_phase2, init.mlff_inputsize]);
 delta.fconv2 = repelem(delta.fsub2,1,2);
 delta.fsub1 = cnnbackconv(delta.fconv2,interim.convfilt_L2,init.trainsize).*grad_relu(interim.poolmap_L1)/36; 
 delta.fconv1 = repelem(delta.fsub1,1,2);
 delta.fconv0 = cnnbackconv(delta.fconv1,interim.convfilt_L1,init.trainsize).*grad_relu(init.traindata)/76;
 update.fconvfilt_L2 = cnnupdateconv(interim.poolmap_L1,delta.fconv2,init.trainsize)/12;
 update.fconvfilt_L1 = cnnupdateconv(init.traindata,delta.fconv1,init.trainsize)/6;
 
 interim.fcL2W = interim.fcL2W - param.fc2rate*update.fclW2;
 interim.fcL1W = interim.fcL1W - param.fc1rate*update.fclW1;
 
 interim.convfilt_L2 = interim.convfilt_L2 - param.fconv2rate*update.fconvfilt_L2;
 interim.convfilt_L1 = interim.convfilt_L1 - param.fconv1rate*update.fconvfilt_L1;
 
 
 output.E(iter)
 
end

plot(1:iter,output.E);
