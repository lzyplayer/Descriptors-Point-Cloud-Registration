% 本算法特征结合应用到环境重建
clc;clear;close all;

addpath('./flann/');
addpath('./estimateRigidTransform');
% load room;
gridStep = 0.01;
% filepath='./data/global_frame/';
% filePrefix='PointCloud';
filepath='./data/local_frame/';
filePrefix='Hokuyo_';
readnum=5;
% datapath = './data/red_room/';
% pre = 'bun';
% scannum=length(dir(datapath))-2;
% scannum=length(room);
overlap = 0.4;
res= 1;
s=30;
% data=room;
% [clouds,Desp,Seed,Norm] = readAllCloud(datapath,scannum,gridStep);
% [clouds,Desp,Seed,Norm] = readRoom(data,gridStep);
% [clouds,Desp,Seed,Norm] = readRedCloud(gridStep);
tic;
[clouds,Desp,Seed,Norm] = readRawOutside(filepath,filePrefix,readnum,gridStep,s);
% [clouds,Desp,Seed,Norm] = readOutside(filepath,filePrefix,readnum,gridStep,s);
N = length(clouds);
p(1).M = eye(4);   
tarCloud = clouds{1};
tarDesp = Desp{1};
tarSeed = Seed{1};
tarNorm = Norm{1};
Model= tarCloud.Location(1:res:end,:)'*s;
id = 2:N;
idmatch = [];
num= 0;
% tic;
MSEs= 0.8*cal_mMSEs(Model);
while(~isempty(id))
    size = length(id);
    for i = id 
        srcCloud = clouds{i};
        srcDesp = Desp{i};
        srcSeed = Seed{i};
        srcNorm = Norm{i};
        Data= srcCloud.Location(1:res:end,:)'*s;
%       T = eigMatch(srcDesp,tarDesp,srcSeed,tarSeed,srcNorm,tarNorm,overlap,gridStep);
        T = eigMatch(tarDesp,srcDesp,tarSeed,srcSeed,tarNorm,srcNorm,overlap,gridStep);
        T = inv(T); %为了提高运行效率，所以换过来算
        R0= T(1:3,1:3);
        t0= T(1:3,4)*s;
        TData = transform_to_global(Data, R0, t0);
%         dM= cal_mMSEs(Model);
        [MSE,R,t,TData,PCorr, Dthr] = TrICP(Model, Data, R0, t0, 100, overlap); %这个操作特别费时间
        num= num+1
        if (MSE > 2.0*mean(MSEs))
            continue;
        end
        MSEs= [MSEs, MSE];      
        p(i).M = Rt2M(R,t);
        srcSeed = transform_to_global(srcSeed,R,t/s);
        FCorr= Fcorr(tarSeed,srcSeed,Dthr/s);
        tarSeed= merge(tarSeed, srcSeed, FCorr);
        tarDesp= merge(tarDesp, srcDesp, FCorr);
        srcNorm= transform_norm(srcNorm,R);
        tarNorm= merge(tarNorm, srcNorm, FCorr);
        Model= merge(Model, TData, PCorr);
%         figure;
%         plot3(Model(1,1:res:end),Model(2,1:res:end),Model(3,1:res:end),'.','Color','r');
%         hold on;
%         plot3(TData(1,1:res:end),TData(2,1:res:end),TData(3,1:res:end),'.','Color','g');
        id = setdiff(id,i);
        idmatch = [idmatch i]
    end
    if(size == length(id))
        disp('the mutil-View process fails!')
        break;
    end
end
Time = toc/60
% shape=cell(N,1);
% for i = 1:N 
%     shape{i,1}= clouds{i}.Location;
% end
% for i = 1:N
%     colorInfo{i}=clouds{i}.Color;
% %     colorInfo{i}=data{i}(:,4:6);
% end
figure;

Model=obtain_room_colorful(clouds, p, N, s);