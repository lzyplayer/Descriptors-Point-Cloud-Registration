function [clouds,srcDesp,srcSeed,srcNorm] = readAllCloud( datapath,scannum,gridStep)
suf = '.ply';            
files = dir([datapath '*' suf]);    
id = 1:scannum
for k = 1:length(files)
    filepath = [datapath files(k).name];    
    clouds{id(k)} = pcread(filepath);
    [srcDesp{id(k)},srcSeed{id(k)},srcNorm{id(k)}] = extractEig(clouds{id(k)},gridStep);
    disp(files(id(k)).name);
end


