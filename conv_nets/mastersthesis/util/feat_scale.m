function [ X_out ] = feat_scale( input, fmin, fmax)
%% function to scale data between fmin and fmax

[m, n] = size(input); % m data points with n feature dimension
X_out = zeros(m,n);
for i = 1 : m
    X_std = mat2gray(input(i,:));
    X_scaled = X_std .* (fmax - fmin) + fmin;
    X_out(i,:) = X_scaled;
end
end