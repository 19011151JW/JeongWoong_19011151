function v = E2v(E,e)
true_anomaly = atan2((sqrt(1-e^2)*sin(E))/(1-e*cos(E)),(cos(E)-e)/(1-e*cos(E)));
v = rad2deg(true_anomaly);
end