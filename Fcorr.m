function corr= Fcorr(Model, Data, Dthr)        

NS = createns(Model');
[corr,TD] = knnsearch(NS,Data');
id= find(TD>Dthr);
corr(:,2) = [1 : length(corr)]';
corr(id,:)= [];