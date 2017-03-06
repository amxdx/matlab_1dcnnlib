function [ output_args ] = grad_reluleaky( input,alpha )
%% RELUDROP gradient for ReLU activation
%  is 1 if input is positive and is zero if input is negative

l  = input > 0  ;
m = alpha*(input <= 0 );
output_args = l+m; 

end

