function [ r ] = relu_leaky( input, alpha )
%RELU_LEAKY Summary of this function goes here
%   Detailed explanation goes here
r = (input<=0)*alpha.*input + (input>0).*input;

end

