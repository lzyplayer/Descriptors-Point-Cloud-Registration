clc;clear;close all;

addpath('./flann/');
addpath('./estimateRigidTransform');

gridStep = 0.02;
datapath = './data';

srcFileName = 'data/bun000.ply';
tarFileName = 'data/bun090.ply';
srcCloud = pcread(srcFileName);
tarCloud = pcread(tarFileName);
overlap = 0.4;
res= 1;
s= 1000;
tic;
T = eigReg(srcCloud,tarCloud,overlap,gridStep);
Data= srcCloud.Location(1:res:end,:)'*s;
Model= tarCloud.Location(1:res:end,:)'*s;
ns=createns(Model','nsmethod','kdtree');
R0= T(1:3,1:3);
t0= T(1:3,4)*s;
[R, t TData] = TrICP(Model, Data, R0, t0, 100, overlap);
Time = toc
figure,pcshow(Model','r'),hold on
pcshow(TData','g')