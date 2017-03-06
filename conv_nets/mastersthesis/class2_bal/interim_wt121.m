function [cnni, cnno, cnnp] = interim_wt121(init)
%% Net parameters
cnnp = struct; %CNN parameters

cnnp.num_iter = 30;  % number of iterations

cnnp.numfilt_phase1 = 6; % number of 1st and 2nd phase filters
cnnp.numfilt_phase2 = 12; % number of 1st and 2nd phase filters

cnnp.convfiltwt1 = 1; cnnp.convfiltwt2 = 1; %weight of weights
cnnp.fullconnwt1 = 1;cnnp.fullconnwt2 = 1; %weight of weights

cnnp.l_ratefc1 = 0.15; cnnp.l_ratefc2 = 0.15; %learning rates
cnnp.l_ratefl1 = 0.15; cnnp.l_ratefl2 = 0.15; %learning rates 

cnnp.fcL1_interim = 200; %interim number of units in fully connected layer

%% initialize intermediate variables
cnni = struct; % CNN interim Parameters
cnno = struct; % CNN output parameters

cnno.calculated_op = zeros(init.trainsize,2); %output calculated at the end

cnni.convfilt_L1 = cnnp.convfiltwt1*rand(cnnp.numfilt_phase1,init.filtsize); %filters for conv layer 1
cnni.convfilt_L2 = cnnp.convfiltwt2*rand(cnnp.numfilt_phase2,init.filtsize); %filters for conv layer 2

cnni.convfilt_L1 = 2*cnni.convfilt_L1 -1; %making the filters from -1 to 1
cnni.convfilt_L2 = 2*cnni.convfilt_L2 -1; %making the filters from -1 to 1


cnni.numPoints_conv1 = init.numPoints - (init.filtsize -1);   % number of points in 1st convolution
cnni.numPoints_conv2 = (cnni.numPoints_conv1/2) - (init.filtsize -1); % number of points in 2nd convolution


cnni.fmap_L1 = zeros(init.trainsize*cnnp.numfilt_phase1,cnni.numPoints_conv1);
%1st phase feature map
%bias_L1 = 0;
cnni.fmap_L2 = zeros(init.trainsize*cnnp.numfilt_phase1*cnnp.numfilt_phase2,cnni.numPoints_conv2);
%2nd phase feature map
%bias_L2 = 0;

cnni.poolmap_L1 = zeros(init.trainsize*cnnp.numfilt_phase1,cnni.numPoints_conv1/2);
%1st phase pool map
cnni.poolmap_L2 = zeros(init.trainsize*cnnp.numfilt_phase1*cnnp.numfilt_phase2,cnni.numPoints_conv2/2);
%1st phase pool map

cnni.fcL1 = zeros(init.trainsize,((cnnp.numfilt_phase1*cnnp.numfilt_phase2*cnni.numPoints_conv2/2)));
cnni.fcL1W = cnnp.fullconnwt1*rand(((cnnp.numfilt_phase1*cnnp.numfilt_phase2*cnni.numPoints_conv2/2)),cnnp.fcL1_interim);

cnni.fcL2 = zeros(init.trainsize,cnnp.fcL1_interim);
cnni.fcL2W = cnnp.fullconnwt2*rand(cnnp.fcL1_interim,2);

cnno.error = zeros(init.trainsize,2);

cnno.E = zeros(cnnp.num_iter,1);
cnni.update_fconv1 = zeros(cnnp.numfilt_phase1,init.filtsize);
cnni.update_fconv2full = zeros(init.trainsize,cnnp.numfilt_phase1,cnnp.numfilt_phase2,init.filtsize);
cnni.update_fconv1full = zeros(init.trainsize,cnnp.numfilt_phase1,init.filtsize);
cnni.delta_fsub2 = zeros(init.trainsize,cnnp.numfilt_phase1,cnnp.numfilt_phase2,cnni.numPoints_conv2/2);
cnni.delta_fsub1 = zeros(init.trainsize,cnnp.numfilt_phase1,cnnp.numfilt_phase2,cnni.numPoints_conv2);

end