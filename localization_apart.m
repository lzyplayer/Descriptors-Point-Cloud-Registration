clc;clear;close all;
gridStep=0.04;
overlap=0.2;
res=1;
addpath('./flann');
addpath('./estimateRigidTransform/');
filepath='./data/global_frame_ap/';
prefix='PointCloud';
readNum=45;
N=readNum;
mergeGridStep=0.001;
s=15;
relocoNum=10;%重定位几号
fullPointCloud = readCloudAsOne(filepath,prefix,readNum,mergeGridStep,s,relocoNum);
load apartment_noupper;
load apartmentGrT;

% fullPointCloud=clouds{1};
% for i=2:N
%     if(i~=relocoNum)
%         transMatrix=p(i).M';
%         transMatrix(4,1:3)=transMatrix(4,1:3)./s;
%         transFormCloud{i}=pctransform(clouds{i},affine3d(transMatrix));
%         fullPointCloud=pcmerge(fullPointCloud,transFormCloud{i},0.002);
%     end
% end

tic
[tarDesp,tarSeed,tarNorm] = extractEig(fullPointCloud,gridStep);
[srcDesp,srcSeed,srcNorm] = extractEig(clouds{relocoNum},gridStep);
T = eigMatch(tarDesp,srcDesp,tarSeed,srcSeed,tarNorm,srcNorm,overlap,gridStep);
T = inv(T); 
R0= T(1:3,1:3);
t0= T(1:3,4);
Motion=Rt2M(R0,t0);
%icp有问题
% Model= fullPointCloud.Location(1:res:end,:)';
% Data= clouds{relocoNum}.Location(1:res:end,:)';
% % TData = transform_to_global(Data, R0, t0);
% [MSE,R,t,TData,PCorr, Dthr] = TrICP(Model, Data, R0, t0, 100, overlap); 
% Motion=Rt2M(R,t);
% MotionbackUp=Motion;
toc
% % 
% RotErr=norm((MotionbackUp(1:3,1:3)-MotionGrt{relocoNum}(1:3,1:3)),'fro')
% TranErr=norm((MotionbackUp(1:3,4)-MotionGrt{relocoNum}(1:3,4)),2)

% Motion=MotionbackUp;
pnum=clouds{relocoNum}.Count;
toshow=pointCloud(clouds{relocoNum}.Location,'Color',uint8([ zeros(pnum,1) ones(pnum,1) zeros(pnum,1)]));
Motion=Motion';
Motion(4,1:3)=Motion(4,1:3);
pcshow( pctransform(toshow, affine3d(Motion)));
hold on
pcshow(fullPointCloud);
%展示路径图

% figure;
% for i=1:N
%     if(i~=relocoNum)
%         cameraPosition(i,:)=MotionGrt{i}(1:3,4)';
%     else
%         cameraPosition(i,:)=cameraPosition(i-1,:);
%     end
% end
% plot(cameraPosition(:,1),cameraPosition(:,2),'-*')
% hold on;
% plot(MotionbackUp(1,4).*s,MotionbackUp(2,4).*s,'bo')
% xlabel('x');
% ylabel('y');

% axis([-0.5 0.5 -0.5 0.5 ]);
