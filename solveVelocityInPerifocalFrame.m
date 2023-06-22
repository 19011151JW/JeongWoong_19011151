%% Solve v in perifocal frame from orbit parameters
function [V_PQW] = solveRangeInPerifocalFrame(a, e, v)

mu = 3.986004418*10^5;                                      % [km^3*s^−2]
p = a*(1-e^2);                                              % 0<e<1
V_PQW = sqrt(mu/p)*[-sind(v); e+cosd(v); 0]; 
end