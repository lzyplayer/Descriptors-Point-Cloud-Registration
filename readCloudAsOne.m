function fullPointCloud = readCloudAsOne(filepath,prefix,readNum,mergeGridStep,s,relocoNUm)
%READCLOUDASONE 此处显示有关此函数的摘要
%   此处显示详细说明
readNum=readNum-1;
clouds=readCloudCsv(filepath,prefix,readNum,0,s);
fullPointCloud=clouds{1};
for i=2:length(clouds)
%     if i~=relocoNUm
        fullPointCloud=pcmerge(fullPointCloud,clouds{i},mergeGridStep);
        disp([ 'cloud ' num2str(i) ' merged!'] );
%     end
end
end

