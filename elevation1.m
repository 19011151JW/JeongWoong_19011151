%% ENU -> El
function el = elevation(ENU,el_mask)
% Topocnetric-horizon
Rrel = sqrt((ENU(1,1)).^2 + (ENU(2,1)).^2 + (ENU(3,1)).^2);
el_rad = asin((ENU(3,1))/Rrel(1,1));
el = el_rad*(180/pi);                     
if el >= el_mask
    el = el;
else
    el = NaN;
end
end


