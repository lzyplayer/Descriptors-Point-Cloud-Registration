function [clouds,srcDesp,srcSeed,srcNorm ] = readRawOutside( filepath,filePrefix,scannum ,gridstep,s )
%READROOM 此处显示有关此函数的摘要
%   此处显示详细说明
    count=scannum-1; %从0开始
%% 读取点云
    clouds=readCloudCsv(filepath,filePrefix,count,-10,s); %去除地面点
%     count=count+1；
% transmatrix=[-1 0 0 0
%              0 0 -1 0
%              0 -1 0 0
%              0 0 0 1];   %%尝试大旋转
%     clouds{2}=pctransform(clouds{2},affine3d(transmatrix'));
    
    for j=1:scannum
%%  读取数据
%         clouds{j}=pointCloud(data{j}(:,1:3)./1000);
        [srcDesp{j},srcSeed{j},srcNorm{j}] = extractEig(clouds{j},gridstep);
    end
end

