function [ output ] = fwdarrange( input, trainsize )
%FWDARRANGE Summary of this function goes here
%   Detailed explanation goes here
[m, p] = size(input);
n = m/trainsize; 
q = 1;
output = zeros(trainsize,p*n);
for i = 1:trainsize
    temp = input(q:n*i,:);
    temp = temp'; 
    temp = temp(:)';
    output(i,:) = temp(:); 
    q = n*i+1;   
end

end

