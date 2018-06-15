function [clouds,srcDesp,srcSeed,srcNorm ] = readRoom( data ,gridstep )
%READROOM 此处显示有关此函数的摘要
%   此处显示详细说明
    scannum=length(data);
%%  预分配
    clouds=cell(scannum,1);
    srcDesp=cell(scannum,1);
    srcSeed=cell(scannum,1);
    srcNorm=cell(scannum,1);
    for j=1:scannum
%%  读取数据
        clouds{j}=pointCloud(data{j}(:,1:3)./1000);
        [srcDesp{j},srcSeed{j},srcNorm{j}] = extractEig(clouds{j},gridstep);
    end
end

