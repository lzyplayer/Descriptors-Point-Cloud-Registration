function [T,MSE] = pairReg(srcCloud,tarCloud,Model,Data,s,overlap,gridStep )
    res = 1;
    T = eigReg(srcCloud,tarCloud,overlap,gridStep);
    R0= T(1:3,1:3);
    t0= T(1:3,4)*s;
    [MSE, R, t, TData] = TrICP(Model, Data, R0, t0, 100, overlap);
    T = Rt2M(R,t);
    figure;
    plot3(Model(1,1:res:end),Model(2,1:res:end),Model(3,1:res:end),'.','Color','r');
    hold on;
    plot3(TData(1,1:res:end),TData(2,1:res:end),TData(3,1:res:end),'.','Color','g');
end

