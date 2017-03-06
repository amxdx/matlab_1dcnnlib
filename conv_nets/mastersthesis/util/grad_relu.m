function [ output_args ] = grad_relu( input )
%% RELUDROP gradient for ReLU activation
%  is 1 if input is positive and is zero if input is negative
l  = input > 0  ;  
output_args = l; 
            


end

