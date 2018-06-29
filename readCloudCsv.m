function [ pointClouds ] = readCloudCsv(filepath,filePrefix,readnum ,zlimit,s )
%REACLOUDCSV 此处显示有关此函数的摘要
%   此处显示详细说明
if(readnum>length(dir(filepath))-2) 
    error('OutOfRange!');
end
for i=0:readnum
%     filename=[filepath 'PointCloud' num2str(i) '.csv'];
    filename=[filepath filePrefix num2str(i) '.csv'];
    % Load data
    cloud = importdata(filename);

    
    %% 仅用于临时转换,应删除
%     load apartmentGrT;
%     localcloud= pctransform( pointCloud(cloud.data(:,2:4)),affine3d(MotionGrt{i+1}'));
    
    %% 去除自身点与地面
%     pointupper= localcloud.Location(:,3)>1.4*s ;   %天花板
%     pointGroud= localcloud.Location(:,3)<zlimit*s ;% 会拍到机器人自身的部分形成大干扰
%     pointrobat= localcloud.Location(:,3)>zlimit*s & localcloud.Location(:,3)<0.023*s & localcloud.Location(:,1)<0.06*s & localcloud.Location(:,2)<0.025*s & localcloud.Location(:,2)>-0.025*s;
%     pointBad=pointGroud | pointrobat | pointupper;
%     pointSelect=~pointBad;
%     pointLocation=cloud.data(pointSelect,2:4)./s;
%     
    pointupper= cloud.data(:,4)>0.14*s ;   %天花板
%     pointGroud= cloud.data(:,4)<zlimit*s ;% 地面
%     pointrobat= cloud.data(:,4)>zlimit*s & localcloud.data(:,4)<0.023*s & localcloud.data(:,2)<0.06*s & localcloud.data(:,3)<0.025*s & localcloud.data(:,3)>-0.025*s;
    pointBad=  pointupper;  % pointrobat |pointGroud |
    pointSelect=~pointBad;           


    % Extract coordinates
%     x = cloud.data(:, strcmp('x', cloud.colheaders));
%     y = cloud.data(:, strcmp('y', cloud.colheaders));
%     z = cloud.data(:, strcmp('z', cloud.colheaders));
    %更换为快捷但不健壮的表达 Extract coordinates
    
    pointGroud= cloud.data(:,4)<zlimit*s ;% 会拍到机器人自身的部分形成大干扰
    pointrobat= cloud.data(:,4)>zlimit*s & cloud.data(:,4)<0.023*s & cloud.data(:,2)<0.06*s & cloud.data(:,3)<0.025*s & cloud.data(:,3)>-0.025*s;
    pointBad=pointGroud | pointrobat;
    pointSelect=~pointBad;
%     
%     pointSelect= cloud.data(:,4)>-11 ;
%     pointSelect=xor(pointSelectLoud,pointrobat);
%     pointLocation=cloud.data(:,2:4)./s;

    pointLocation=cloud.data(pointSelect,2:4)./s;

    %% 不修剪
%     pointLocation=cloud.data(:,2:4)./s;
   
    %%
    pointClouds{(i+1)}= pointCloud(pointLocation);
end
end

