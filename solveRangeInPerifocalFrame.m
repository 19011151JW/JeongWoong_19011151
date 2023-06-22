%% Solve r in perifocal frame from orbit parameters
function [R_PQW] = solveRangeInPerifocalFrame(a, e, v)
p = a*(1-e^2);                                            
r = p/(1+e*cosd(v));
R_PQW = [r*cosd(v); r*sind(v); 0];  
end
