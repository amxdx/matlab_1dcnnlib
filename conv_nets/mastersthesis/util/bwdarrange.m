function [ output ] = bwdarrange( input, filtmult )
%FWDARRANGE Summary of this function goes here
%   Detailed explanation goes here
[~, p] = size(input);
q = p / filtmult; 
b = input'; 
c = reshape(b,q,[]); 
output = c';

end

