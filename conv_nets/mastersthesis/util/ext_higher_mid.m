function f = ext_higher_mid (length,numPoints,signal)
%% function to extract signal from higher lengths from midpoint
mid = ceil(length/2);
low = ceil(mid - numPoints/2)+1;
high = ceil((mid + numPoints/2));
f = signal(low:high);
end