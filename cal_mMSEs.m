function mMSEs= cal_mMSEs(scan)

Model= scan;
NS = createns(Model');
[corr,TD] = knnsearch(NS,Model','k',2);
mMSEs=(mean(TD(:,2)));
