% 这个算法是利用生成树的思想来做的，这个算法没有点云顺序的限制，因为只涉及到点云的两两之间的拼接，不涉及到特征的结合
% 当然，调整顺序之后是可以提高算法运行效率的
clc;clear;close all;

addpath('./flann/');
addpath('./estimateRigidTransform');

gridStep = 0.01;
datapath = './data/';
pre = 'bun';

overlap = 0.4;
res= 10;
s= 1000;

clouds = readAllCloud(datapath,pre);
N = length(clouds);
% save bunny;
% load bunny;
for i = 1:N 
    shape{i,1}= clouds{i}.Location;
end
mMSEs= cal_mMSEs(shape,s);
MSEs= [];
tic;
p= ini_pM(N);
id = [1];
for k = 1:N
    if (length(id) >=k)
        id
        i = id(k);
        tarCloud = clouds{i};
        Model= tarCloud.Location(1:res:end,:)'*s;
%         ns=createns(Model','nsmethod','kdtree');
    else
        break;
    end
    for j = 1:N
        if(sum(abs(p(j).M(:)))>10^(-6))
            continue;
        else
            srcCloud = clouds{j};
            Data= srcCloud.Location(1:res:end,:)'*s;
            [p(j).M,id,MSEs,mMSEs]= Bi_est(srcCloud,tarCloud,Model,Data,s,overlap,gridStep, j, p(i).M, id, MSEs, mMSEs);
        end
    end
end
Time = toc
figure;
Model=obtain_model(shape, p, N, s);
