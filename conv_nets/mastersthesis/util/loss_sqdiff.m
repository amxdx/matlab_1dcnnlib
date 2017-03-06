function loss = loss_sqdiff(calculated_op, desired_op) 
%% Cost function defined as the square of difference of outputs. 
loss = sqrt(sum(0.5*(desired_op - calculated_op).^2 )); 
end