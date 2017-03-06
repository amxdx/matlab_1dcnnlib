function g = normalize(X)
%% function to normalize data
mu = mean(X); 
sigma = std(X); 
g = ((X - mu)./sigma );
end