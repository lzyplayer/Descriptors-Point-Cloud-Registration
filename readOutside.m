function [merClouds,srcDesp,srcSeed,srcNorm ] = readOutside( filepath,filePrefix,scannum ,gridstep ,s)
%READROOM 此处显示有关此函数的摘要
%   此处显示详细说明
    count=scannum*4-1;
%%  预分配

    srcDesp=cell(scannum,1);
    srcSeed=cell(scannum,1);
    srcNorm=cell(scannum,1);
    clouds=readCloudCsv(filepath,filePrefix,count,0.64,s); %0.64为摄像机头高度
    count=count+1;
    for i =1:scannum
        merClouds{i}=pcmerge(pcmerge(pcmerge(clouds{4*i-3},clouds{4*i-2},0.001),clouds{4*i-1},0.001),clouds{4*i},0.001);
    end
    for j=1:scannum
%%  读取数据
%         clouds{j}=pointCloud(data{j}(:,1:3)./1000);
        [srcDesp{j},srcSeed{j},srcNorm{j}] = extractEig(merClouds{j},gridstep);
    end
end

