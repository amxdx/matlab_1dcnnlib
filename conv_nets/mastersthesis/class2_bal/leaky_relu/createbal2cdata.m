%% loading paths and specifying network architecture
load('..\..\..\..\Data\database_v2.mat');
addpath('..\..\util');
init = struct; 
init.filtsize = 5;
init.numconvs =2;
init.poolstride = 2;
init.mlff_inputsize = 16;
init.xfold = 4;
init.numPoints = calpoints(init.numconvs,init.filtsize,init.poolstride,init.mlff_inputsize); %works for all numPoint sizes

%% extracting signal from database and replicating to balance it
nonaep_pos = find(overall_db.inferred_groundtruth(:,1) < 203);
aep_pos = find(overall_db.inferred_groundtruth(:,1) > 203);

max_len = max(length(nonaep_pos), length(aep_pos));

nonaep_signal = cell(length(nonaep_pos),3);
aep_signal = cell(length(aep_pos),3);

nonaep_signal(1:length(nonaep_pos),1) = overall_db.FNprespike(1,nonaep_pos);
nonaep_signal(1:length(nonaep_pos),2) = overall_db.FNspike(1,nonaep_pos);
nonaep_signal(1:length(nonaep_pos),3) = overall_db.FNpostspike(1,nonaep_pos);

aep_signal(1:length(aep_pos),1) = overall_db.FNprespike(1,aep_pos);
aep_signal(1:length(aep_pos),2) = overall_db.FNspike(1,aep_pos);
aep_signal(1:length(aep_pos),3) = overall_db.FNpostspike(1,aep_pos);

aep_signal = bal_replicate(max_len,length(aep_pos),aep_signal);

% diff = length(nonaep_pos) - length(aep_pos);
%
% r=randperm(length(aep_pos),diff);
%
% aep_signal(length(aep_pos)+1:length(nonaep_pos),:) = aep_signal(r,:);
signals = [nonaep_signal; aep_signal];

init.numSignals = length(signals);
desired_op = truth2cbal(init.numSignals);

signal = zeros(init.numSignals,init.numPoints);

%signal extraction to 'numPoints' samples each
for i = 1 : init.numSignals
    len = max(length(signals{i,2}));
    temp =  signals{i,2};
    if len >= init.numPoints
        signal(i,:) = ext_higher(init.numPoints,temp);
    else
        pre_t = signals{i,1};
        post_t = signals{i,3};
        signal(i,:)= ext_lower(len,init.numPoints,temp,pre_t,post_t);
    end
end

%% Normalizing
normsig = feat_scale(normalize(signal),0,1) ; %scale the contents of the signal to fmin and fmax

%% shuffling and splitting to training and testing data
[normfinal, desired_output] = randomize(normsig,desired_op,init.numSignals);

[init.trainsize, init.testsize, init.traindata, init.desired_train_op, init.testdata, init.desired_test_op] = ...
    xfoldsplit(normfinal,init.xfold,desired_output);
% ---------------------------------------------------------------------------------
%clearning unwanted variables
keepvars = { 'init'};
clearvars('-except', keepvars{:});
% ---------------------------------------------------------------------------------
save('k4rectbal2c.mat');