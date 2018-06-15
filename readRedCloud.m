function [clouds,srcDesp,srcSeed,srcNorm] = readRedCloud( gridStep)
% suf = '.ply';            
% files = dir([datapath '*' suf]);    
load red_room.mat;
scannum=length(opt_clouds);
clouds=opt_clouds;
id = 1:scannum

for k = 1:scannum
%     filepath = [datapath files(k).name];    
%     clouds{id(k)} = pcread(filepath);

    [srcDesp{id(k)},srcSeed{id(k)},srcNorm{id(k)}] = extractEig(clouds{id(k)},gridStep);
%     disp(files(id(k)).name);
end


