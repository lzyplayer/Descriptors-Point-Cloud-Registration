function srcNorm= transform_norm(srcNorm,R)

 num= size(srcNorm,1)/3;
for i= 1:num
    j= i-1;
    srcNorm(3*j+1:3*i,:)= R*srcNorm(3*j+1:3*i,:);
end


