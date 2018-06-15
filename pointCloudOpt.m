function [ opt_clouds ] = pointCloudOpt( in_clouds,zoom ,xfloorlim,zceillim )
%POINTCLOUDOPT 此处显示有关此函数的摘要
%   此处显示详细说明
scannum=length(in_clouds);

for i=1:scannum
    pointnum=size(in_clouds{i}.Location,1);
%     curclouds=pointCloud([0,0,0]);
%     set(curclouds.Count;
    acceptpoints=[];
    location=in_clouds{i}.Location;
    for j=1:pointnum
        if(location>xfloorlim && location<zceillim )
            acceptpoints=[acceptpoints;j];
        end
    end
    opt_clouds{i}=pcdenoise(select(in_clouds{i},acceptpoints));    %裁剪并降噪来缩小目标
    opt_clouds{i}=pointCloud( opt_clouds{i}.Location.*zoom,'color',opt_clouds{i}.Color);
%     pctransform()
%     opt_clouds{i}= pcdenoise(opt_clouds{i});
end
end

