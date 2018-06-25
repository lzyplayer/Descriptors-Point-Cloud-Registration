function [ pointClouds ] = readCloudCsv(filepath,filePrefix,readnum ,zlimit,s )
%REACLOUDCSV 此处显示有关此函数的摘要
%   此处显示详细说明
if(readnum>30) 
    error('OutOfRange!');
end
for i=0:readnum
%     filename=[filepath 'PointCloud' num2str(i) '.csv'];
    filename=[filepath filePrefix num2str(i) '.csv'];
    % Load data
    cloud = importdata(filename);

    % Extract coordinates
%     x = cloud.data(:, strcmp('x', cloud.colheaders));
%     y = cloud.data(:, strcmp('y', cloud.colheaders));
%     z = cloud.data(:, strcmp('z', cloud.colheaders));
    %更换为快捷但不健壮的表达 Extract coordinates
    
%     pointGroud= cloud.data(:,4)<zlimit*s ;% 会拍到机器人自身的部分形成大干扰
%     pointrobat= cloud.data(:,4)>zlimit*s & cloud.data(:,4)<0.023*s & cloud.data(:,2)<0.06*s & cloud.data(:,3)<0.025*s & cloud.data(:,3)>-0.025*s;
%     pointBad=pointGroud | pointrobat;
%     pointSelect=~pointBad;
    
    %     pointSelect= cloud.data(:,4)>-11 ;
%     pointSelect=xor(pointSelectLoud,pointrobat);
    pointLocation=cloud.data(:,2:4)./s;
%     pointLocation=cloud.data(pointSelect,2:4)./s;
    pointClouds{(i+1)}= pointCloud(pointLocation);
end
end

