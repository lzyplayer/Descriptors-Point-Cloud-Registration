function [srcDesp,srcSeed,srcNorm] = extractEig(srcCloud,gridStep)
%This code is the Matlab implimentation of the paper, 
%"Fast Descriptors and Correspondence Propagation for Robust Global Point Cloud Registration,"
%IEEE transactions on Image Processing, 2017.
%This code should be used only for academic research.
%any other useage of this code should not be allowed without Author agreement.
% If you have any problem or improvement idea about this code, please
% contact with Guang JIANG, Xidian University. gjiang@mail.xidian.edu.cn.

srcData = srcCloud.Location';
radii = (0.5:0.5:2)*gridStep;

srcCloudDown = pcdownsample(srcCloud, 'gridAverage', gridStep);
srcSeed = srcCloudDown.Location';

%% compute descriptors for seed points in the source point cloud
K = length(radii);
srcIdx = rangesearch(srcData',srcSeed',radii(1));
idxSz = cellfun(@length,srcIdx,'uni',true);
srcIdx = srcIdx(idxSz>10);
srcSeed = srcSeed(:,idxSz>10);
M = sum(idxSz>10);
idx = num2cell((1:M)');
[s,n] = cellfun(@(x,y)svdCov(x,y,srcData,srcSeed),srcIdx,idx,'uni',false);
s = cell2mat(s);
n = cell2mat(n);
for k = 2:K
    srcIdx = rangesearch(srcData',srcSeed',radii(k));
    [sk,nk] = cellfun(@(x,y)svdCov(x,y,srcData,srcSeed),srcIdx,idx,'uni',false);
    s = [s cell2mat(sk)];
    n = [n cell2mat(nk)];
end
s = s';
ds = diff(s);
srcDesp = reshape(ds,3*(K-1),[]);
n = mat2cell(n,3*ones(M,1),K);
srcNorm = cellfun(@(x)reshape(x,[],1),n','uni',false);
srcNorm = cell2mat(srcNorm);

end

