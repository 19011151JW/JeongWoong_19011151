function E = M2E(M, e)
E0 = M;
E1 = M+e*sin(E0);
while(1)

    E_p = E1;
    E1 = M + e*sin(E1);
    if abs(E1-E_p)<=10^-9
        break
    end
end
E = E1;
end