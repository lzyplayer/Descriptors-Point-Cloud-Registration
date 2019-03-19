
clc;clear;close all;
gridStep=0.025;
load  Clear_OutSide;
load outside_regis_motion_result;
load outside_GRT;
addpath('./flann');
addpath('./estimateRigidTransform/');
mergeGrid=0.002;
% fullPointCloud=clouds{1};
overlap=0.4;
res=10;
fullPointCloud=Local2GlobalMap(clouds,GrtM,s,mergeGrid); 
[tarDesp,tarSeed,tarNorm] = extractEig(fullPointCloud,gridStep);
for tar= 12
    
    
%     for i=2:N
%         if(i~=tar)
%             transMatrix=p(i).M';
%             transMatrix(4,1:3)=transMatrix(4,1:3)./s;
%             transFormCloud{i}=pctransform(clouds{i},affine3d(transMatrix));
%             fullPointCloud=pcmerge(fullPointCloud,transFormCloud{i},0.002);
%         end
%     end
    
    tic
    [srcDesp,srcSeed,srcNorm] = extractEig(clouds{tar},gridStep);
    T = eigMatch(tarDesp,srcDesp,tarSeed,srcSeed,tarNorm,srcNorm,overlap,gridStep);
    T = inv(T);
    R0= T(1:3,1:3);
    t0= T(1:3,4)*s;
    
%     
    Model= fullPointCloud.Location(1:res:end,:)'*s;
    Data= clouds{tar}.Location(1:res:end,:)'*s;
%     TData = transform_to_global(Data, R0, t0);
    [MSE,R,t,TData,PCorr, Dthr] = TrICP(Model, Data, R0, t0, 100, overlap);
    Motion=Rt2M(R,t);
    MotionbackUp=Motion;
    toc
    disp(['cloud ' num2str(tar) ' tested']);
    RotErr=norm((MotionbackUp(1:3,1:3)-GrtM{tar}(1:3,1:3)),'fro')
    
    TranErr=norm((MotionbackUp(1:3,4)-GrtM{tar}(1:3,4)),2)
    if(RotErr>0.1||TranErr>0.1)
        disp(['cannot relocate cloud '  num2str(tar)]);
    end
end
%
Motion=MotionbackUp;
pnum=clouds{tar}.Count;
toshow=pointCloud(clouds{tar}.Location,'Color',[ 225*ones(pnum,1) zeros(pnum,1) zeros(pnum,1)]);
Motion=Motion';
Motion(4,1:3)=Motion(4,1:3)./s;
pcshow(fullPointCloud);
hold on
pcshow( pctransform(toshow, affine3d(Motion)));

xlabel('x');
ylabel('y');
zlabel('z');
axis([-1 1 -1 1 -0.2 0.6 ]);
%չʾ·��ͼ
% figure;
for i=1:N
    if(i~=tar)
        cameraPosition(i,:)=GrtM{i}(1:3,4)'./s;
    else
        cameraPosition(i,:)=cameraPosition(i-1,:);
    end

end
plot3(cameraPosition(:,1),cameraPosition(:,2),cameraPosition(:,3),'r-*');
hold on;
plot3(MotionbackUp(1,4)/s,MotionbackUp(2,4)/s,MotionbackUp(3,4)/s,'bo');
% xlabel('x');
% ylabel('y');
%
% % axis([-0.5 0.5 -0.5 0.5 ]);
