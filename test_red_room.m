% clc;
% close all;
% clear;
% 
% datapath='./data/red_room/map2.ply';
% clouds=pcread(datapath);
% 
% pcshow(clouds);
for i=1:10
    pcshow(clouds{i});
    hold on;
end