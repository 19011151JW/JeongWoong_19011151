%% Perifocal frame -> ECI frame
function [DCM_P_E] = PQW2ECI(w, i, RAAN)

R_arg_prg_3 = [cos(w), sin(w), 0; -sin(w), cos(w), 0; 0, 0, 1];         % R(arg_prg,3)
R_inc_angle_1 = [1, 0, 0; 0, cos(i), sin(i); 0, -sin(i),cos(i)];        % R(inc_angle,1)
R_RAAN_3 = [cos(RAAN), sin(RAAN), 0; -sin(RAAN), cos(RAAN), 0; 0, 0, 1];            % R(RAAN,3)

DCM_P_E = (R_arg_prg_3 * R_inc_angle_1 * R_RAAN_3)';
end
