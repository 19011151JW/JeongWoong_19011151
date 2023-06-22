function M = Mean(t1,t2,a,M0)
mu = 3.986*10^5;       %(km^3/s^2)
s = seconds(t2-t1);    %(s)
M = M0 + sqrt(mu/a^3)*s; 
if abs(M) > pi*2
    M = rem(M,pi*2);
end
end