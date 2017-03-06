function [loss] = loss_tanhmod(calculated_op, desired_op) 
%% Cost function defined as the square of difference of outputs. 
p = (desired_op+1)/2;
q = (calculated_op+1)/2;
loss = -p.*log(q) - (1 - p).*log(1-q);
end