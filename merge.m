function Model= merge(Model, TData, corr)

M = Model(:,corr(:,1));
S = TData(:,corr(:,2));
MS= (M+S)*0.5;
Model(:,corr(:,1))= [];
TData(:,corr(:,2))= [];
Model= [Model,TData,MS];
