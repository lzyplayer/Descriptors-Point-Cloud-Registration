function [Model]=obtain_room_colorful(dataN, pM, N, s )

% res= 1;
Model= [];

for i=1:N
     transMatrix=pM(i).M';
     transMatrix(4,1:3)=transMatrix(4,1:3)./s;
     pcshow( pctransform(dataN{i}, affine3d(transMatrix)));
     hold on
%           R0= pM(i).M(1:3,1:3);    t0= pM(i).M(1:3,4);
%     TData= transform_to_global(dataN{i}.Location'*s, R0, t0);
%     pointCloud(TData','Color',dataN{i}.Color)
%     Model= [Model,TData];
%     id= find(TData(1,:)<-100);
%     TData(:,id)= [];
%     Acolordata=colordata{i};
%     for j=1:res:size(Acolordata,1)
%         plot3(TData(1,j),TData(2,j),TData(3,j),'.','Color',Acolordata(j,:)./255);
%         hold on;
%     end
end