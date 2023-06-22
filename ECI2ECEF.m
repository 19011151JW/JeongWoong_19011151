function DCM_E_E=ECI2ECEF(time)
jd = juliandate(time);
thGMST = siderealTime(jd);
DCM_E_E = [cosd(thGMST), sind(thGMST), 0; -sind(thGMST), cosd(thGMST), 0; 0, 0, 1];
end