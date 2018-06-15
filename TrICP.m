function [iMSEi, R, t, TData, TCorr, Dthr] = TrICP(Model, Data, R, t, MoveStep, TrMin)


TrMax= 1.0;
% Data for two 3D data sets 
minPhi= 10^(5);
PminPhi= 10^(6);
CurrStep = 0;
TData = transform_to_global(Data, R, t);
NS = createns(Model');
while ((CurrStep <MoveStep)&(abs(PminPhi-minPhi)>10^(-6)))
    CurrStep= CurrStep+1;
    [corr,TD] = knnsearch(NS,TData');
    SortTD2 = sortrows(TD.^2); % Sort the correspongding points
    minTDIndex = floor(TrMin*length(TD)); % Get minimum index of TD
    maxTDIndex = ceil(TrMax*length(TD)); % Get maxmum index of TD
    TDIndex = [minTDIndex : maxTDIndex]';
    mTr = TDIndex./length(TD);
    mCumTD2 = cumsum(SortTD2); % Get accumulative sum of sorted TD.^2
    mMSE = mCumTD2(minTDIndex : maxTDIndex)./TDIndex; % Compute all MSE
    mPhi = ObjectiveFunction(mMSE, mTr);  
    PminPhi= minPhi;
    [minPhi, nIndex] = min(mPhi);
    iMSEi= mMSE(nIndex);
    Dthr=  sqrt(SortTD2(nIndex));
    TriKSI = mTr(nIndex); % Update Tr for next step    
    corr(:,2) = [1 : length(corr)]';
    % Sort the corresponding points
    corrTD = [corr, TD];
    SortCorrTD = sortrows(corrTD, 3);
    [R, t, TCorr, TData] = CalRtPhi(TData, SortCorrTD, TriKSI, Model, Data); 
end


%%%%%%%%%%%%%%%%%%%%Integrated Function%%%%%%%%%%%%%%%%%%%%
%% Calculate R,t,Phi based on current overlap parameter
function [R, t,TCorr,TData] = CalRtPhi(TData,SortCorrTD, Tr, Model, Data)
TrLength = floor(Tr*size(SortCorrTD,1)); % The number of corresponding points after trimming
TCorr = SortCorrTD(1:TrLength, 1:2);     % Trim the corresponding points according to overlap parameter Tr
% Register MData with TData
[R, t] = reg(TCorr, Model, Data);
% To obtain the transformation data
TData = transform_to_global(Data, R, t);

%%%%%%%%%%%%%%% Calculate the registration matrix %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% T(TData)->MData %%%%%%%%%%%%%%%%%%%%%%%%%
% SVD solution
function [R1, t1] = reg(corr, Model, Data)
n = length(corr); 
M = Model(:,corr(:,1)); 
mm = mean(M,2);
S = Data(:,corr(:,2));
ms = mean(S,2); 
Sshifted = [S(1,:)-ms(1); S(2,:)-ms(2); S(3,:)-ms(3)];
Mshifted = [M(1,:)-mm(1); M(2,:)-mm(2); M(3,:)-mm(3)];
K = Sshifted*Mshifted';
K = K/n;
[U A V] = svd(K);
R1 = V*U';
if det(R1)<0
    B = eye(3);
    B(3,3) = det(V*U');
    R1 = V*B*U';
end
t1 = mm - R1*ms;