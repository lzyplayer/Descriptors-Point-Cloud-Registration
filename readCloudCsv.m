function [ pointClouds ] = readCloudCsv(filepath,readnum )
%REACLOUDCSV 此处显示有关此函数的摘要
%   此处显示详细说明
if(readnum>30) 
    error('OutOfRange!');
end
for i=0:readnum
    filename=[filepath 'PointCloud' num2str(i) '.csv'];
    % Load data
    cloud = importdata(filename);

    % Extract coordinates
%     x = cloud.data(:, strcmp('x', cloud.colheaders));
%     y = cloud.data(:, strcmp('y', cloud.colheaders));
%     z = cloud.data(:, strcmp('z', cloud.colheaders));
    %更换为快捷但不健壮的表达 Extract coordinates
    pointSelect= cloud.data(:,4)>0.63 ;
%     pointSelect= cloud.data(:,4)>-11 ;
    pointLocation=cloud.data(pointSelect,2:4)./60;
    pointClouds{(i+1)}= pointCloud(pointLocation);
end
end

