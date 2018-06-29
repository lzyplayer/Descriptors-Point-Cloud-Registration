
clc;clear;close all;
gridStep=0.04;
load  Clear_OutSide;
load outside_regis_motion_result;
load outside_GRT;
addpath('./flann');
addpath('./estimateRigidTransform/');

fullPointCloud=clouds{1};
overlap=0.4;
res=10;

for i=2:N
    if(i~=22)
        transMatrix=p(i).M';
        transMatrix(4,1:3)=transMatrix(4,1:3)./s;
        transFormCloud{i}=pctransform(clouds{i},affine3d(transMatrix));
        fullPointCloud=pcmerge(fullPointCloud,transFormCloud{i},0.002);
    end
end

tic
[tarDesp,tarSeed,tarNorm] = extractEig(fullPointCloud,gridStep);
[srcDesp,srcSeed,srcNorm] = extractEig(clouds{22},gridStep);
T = eigMatch(tarDesp,srcDesp,tarSeed,srcSeed,tarNorm,srcNorm,overlap,gridStep);
T = inv(T); 
R0= T(1:3,1:3);
t0= T(1:3,4)*s;


Model= fullPointCloud.Location(1:res:end,:)'*s;
Data= clouds{22}.Location(1:res:end,:)'*s;
% TData = transform_to_global(Data, R0, t0);
[MSE,R,t,TData,PCorr, Dthr] = TrICP(Model, Data, R0, t0, 100, overlap); 
Motion=Rt2M(R,t);
MotionbackUp=Motion;
toc

RotErr=norm((MotionbackUp(1:3,1:3)-GrtM{22}(1:3,1:3)),'fro')

TranErr=norm((MotionbackUp(1:3,4)./s-GrtM{22}(1:3,4)),2)


Motion=MotionbackUp;
pnum=clouds{22}.Count;
toshow=pointCloud(clouds{22}.Location,'Color',uint8([ zeros(pnum,1) ones(pnum,1) zeros(pnum,1)]));
Motion=Motion';
Motion(4,1:3)=Motion(4,1:3)./s;
pcshow( pctransform(toshow, affine3d(Motion)));
hold on

pcshow(fullPointCloud);
%չʾ·��ͼ
figure;
for i=1:N
    if(i~=22)
        cameraPosition(i,:)=p(i).M(1:3,4)';
    else
        cameraPosition(i,:)=cameraPosition(i-1,:);
    end

end
plot(cameraPosition(:,1),cameraPosition(:,2),'-*')
hold on;
plot(MotionbackUp(1,4),MotionbackUp(2,4),'bo')
xlabel('x');
ylabel('y');

% axis([-0.5 0.5 -0.5 0.5 ]);
