function [ pointClouds ] = readCloudCsv(filepath,filePrefix,readnum ,zlimit,s )
%REACLOUDCSV 此处显示有关此函数的摘要
%   此处显示详细说明
if(readnum>length(dir(filepath))-2) 
    error('OutOfRange!');
end
 for i=0:readnum

    filename=[filepath filePrefix num2str(i) '.csv'];
    % Load data
    cloud = importdata(filename);
    sky=0.14;
    %% 去除自身点与地面
    if i==41
        sky=0.12;
    end
    pointupper= cloud.data(:,4)>sky*s ;   %天花板
    pointGroud= cloud.data(:,4)<zlimit*s ;% 地面
    pointrobat= cloud.data(:,4)>zlimit*s & cloud.data(:,4)<0.05*s & cloud.data(:,2)<0.06*s & cloud.data(:,3)<0.025*s & cloud.data(:,3)>-0.025*s;
    pointBad=  pointrobat |pointGroud |pointupper;  % 
    pointSelect=~pointBad;           

    pointLocation=cloud.data(pointSelect,2:4)./s;

    %% 不修剪
%     pointLocation=cloud.data(:,2:4)./s;
   
    %%
    pointClouds{(i+1)}= pointCloud(pointLocation);
    

    
end
end

