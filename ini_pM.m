function p = ini_pM(N)

p(1).M= eye(4);
for i=2:N
    p(i).M= zeros(4);
end

