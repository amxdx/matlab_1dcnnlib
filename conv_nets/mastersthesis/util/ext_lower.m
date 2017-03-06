function f = ext_lower(length,numPoints,signal,pre_t,post_t)
%% function to extract signal from lower lengths appending from pre and post spikes

if (mod(length-numPoints,2) == 0 )
    res = (numPoints-length)/2;
    point = 50 - res + 1;
    f = [ pre_t(point:50) signal post_t(1:res) ];
else
    res = ceil((numPoints-length)/2);
    point = 50 - res+1;
    f= [ pre_t(point:50) signal post_t(1:res-1) ];
end

end