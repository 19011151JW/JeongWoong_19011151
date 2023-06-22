%% ENU -> Az
function az = azimuth(ENU)

% Topocnetric-horizon
az_rad = acos((ENU(2,1))/sqrt((ENU(1,1))^2+(ENU(2,1))^2));
az = az_rad*(180/pi);  
if az < 0
    az = mod(az, 360);
end
if ENU(1,1) < 0
    az = 360-az; 
end
end



