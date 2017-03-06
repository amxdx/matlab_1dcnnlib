function [test] = gausscreate(data, point, len, variance) 
test = data; 
test(point:point+len) = data(point:point+len) + gausswin(length(point:point+len),variance)'; 
end