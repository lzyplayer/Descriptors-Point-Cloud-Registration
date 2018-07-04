function fullPointCloud = readCloudAsOne(filepath,prefix,readNum,mergeGridStep,s,relocoNUm,GrtM)
%READCLOUDASONE 此处显示有关此函数的摘要
%   此处显示详细说明
readNum=readNum-1;
clouds=readCloudCsv(filepath,prefix,readNum,0,s);
fullPointCloud=Local2GlobalMap(clouds,GrtM,s,mergeGridStep);

% for i=2:length(clouds)
% %     if i~=relocoNUm
%         fullPointCloud=pcmerge(fullPointCloud,clouds{i},mergeGridStep);
%         disp([ 'cloud ' num2str(i) ' merged!'] );
% %     end
% end
end

