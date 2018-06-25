% 
% addpath('./data/');
% addpath('./data/global_frame');
% pose=importdata('/data/global_frame/Point_Cloud30.csv');

% for i=1:size(posescannerleica,1)
%     GrtR{i}=[posescannerleica(i,1:3);posescannerleica(i,5:7);posescannerleica(i,9:11)];
%     GrtT{i}=[posescannerleica(i,4);posescannerleica(i,8);posescannerleica(i,12)];
% end
filepath='./data/local_frame/Hokuyo_';
for i=0:30

current_cloud=importdata([filepath num2str(i) '.csv' ]);
data{i+1}=current_cloud.data(:,2:4);

end