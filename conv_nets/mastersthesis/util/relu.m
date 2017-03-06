function [r] = relu(input)
l= input>0 ;
r = input.*l;
end