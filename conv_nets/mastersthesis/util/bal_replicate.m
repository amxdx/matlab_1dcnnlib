function [ balance] = bal_replicate(maxClasslen ,classLen , classData)
%% balance class data
diff = maxClasslen - classLen;
if diff >= classLen
r=randi(classLen,diff,1);
balance = [classData; classData(r,:)];
else 
r=randperm(classLen,diff);
balance = [classData; classData(r,:)];    
end