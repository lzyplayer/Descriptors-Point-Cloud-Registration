function  [pMj,id,MSEs,mMSEs]= Bi_est(srcCloud,tarCloud,Model,Data,s,overlap,gridStep, j, pMi, id, MSEs, mMSEs)

pMj= zeros(4);
[Mij,MSEij] = pairReg(srcCloud,tarCloud,Model,Data,s,overlap,gridStep );
if (MSEij<(2.8*mMSEs))
    [Mji,MSEji]= pairReg(tarCloud,srcCloud,Data,Model,s,overlap,gridStep );
    dM= Mij-inv(Mji);    dR= dM(1:3,1:3);
    ER= sum(abs(dR(:))); 
    Et= norm(dM(1:3,4));
    if((ER<0.1)&(Et<2.0*mMSEs))&((MSEij<1.5*mMSEs)|(MSEji<1.5*mMSEs))
        MSEs=[MSEs,min(MSEij,MSEji)];
        mMSEs= mean(MSEs);
        pMj= pMi*Mij;
        id= [id,j];
    end
end
                  