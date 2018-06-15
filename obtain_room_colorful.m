function [Model]=obtain_room_colorful(dataN, pM, N, s,colordata,res)

% res= 1;
Model= [];

for i=1:N
     R0= pM(i).M(1:3,1:3);    t0= pM(i).M(1:3,4);
    TData= transform_to_global(dataN{i,1}'*s, R0, t0);
%     Model= [Model,TData];
%     id= find(TData(1,:)<-100);
%     TData(:,id)= [];
    Acolordata=colordata{i};
    for j=1:res:size(Acolordata,1)
        plot3(TData(1,j),TData(2,j),TData(3,j),'.','Color',Acolordata(j,:)./255);
        hold on;
    end
end