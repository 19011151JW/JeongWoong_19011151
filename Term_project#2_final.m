clear all;
clc;

%% Loading Information
load('nav.mat')


%% INPUT (Satetllite)
disp("1)GPS 2)QZSS 3)BDS");
C = input("Choose from GPS, QZSS, or BDS which satellite information you want to receive ");

if C == 1
    a = nav.GPS.a*0.001;  % Semi-major axis(km)
    e = nav.GPS.e;  % Ecceinticity
    i = nav.GPS.i;  % Inclination(rad)
    RAAN = nav.GPS.OMEGA; % RAAN(rad)
    w = nav.GPS.omega; % Argument of perigee(rad)
    M0 = nav.GPS.M0; % Mean anomaly at toc(rad)
    toc = nav.GPS.toc; %toc
elseif C == 2
    a = nav.QZSS.a*0.001;  % Semi-major axis(km)
    e = nav.QZSS.e;  % Ecceinticity
    i = nav.QZSS.i;  % Inclination(rad)
    RAAN = nav.QZSS.OMEGA; % RAAN(rad)
    w = nav.QZSS.omega; % Argument of perigee(rad)
    M0 = nav.QZSS.M0; % Mean anomaly at toc(rad)
    toc = nav.QZSS.toc; %toc
elseif C == 3
    a = nav.BDS.a*0.001;  % Semi-major axis(km)
    e = nav.BDS.e;  % Ecceinticity
    i = nav.BDS.i;  % Inclination(rad)
    RAAN = nav.BDS.OMEGA; % RAAN(rad)
    w = nav.BDS.omega; % Argument of perigee(rad)
    M0 = nav.BDS.M0; % Mean anomaly at toc(rad)
    toc = nav.BDS.toc; %toc
end

%% INPUT (Time)
disp('Enter the date to observe')
t = input("([YYYY,MM,DD,hh,mm,ss])format:");
Initial_time = datetime(t);
Final_time = datetime(t) + hours(24); % Observation time = 24hr
% Time set
t_toc = datetime(toc); 
t_t = linspace(Initial_time, Final_time, 1440);

%% INPUT (Condition)
ground_lat = input('Enter lattitude of observation site (degree): ');
ground_lon = input('Enter longitude of observation site (degree): '); 
height = input('Enter height of observation site (km): '); 
el_mask = input('Enter elevation mask (degree): ');


%% Orbit calculate
lat_geoplot = [];
lon_geoplot = []; 
az_skyplot = [];
el_skyplot = [];
for k = 1:length(t_t)
    M = Mean(t_toc, t_t(k), a, M0);
    E = M2E(M, e);
    v = E2v(E, e);
    
    %% PQW
    R_PQW = solveRangeInPerifocalFrame(a, e, v);
    V_PQW = solveVelocityInPerifocalFrame(a, e, v);
    
    %% PQW -> ECI
    DCM_P_E = PQW2ECI(w, i, RAAN);
    R_ECI = DCM_P_E * R_PQW;
    V_ECI = DCM_P_E * V_PQW;
     
    %% ECI -> ECEF
    DCM_E_E = ECI2ECEF(t_t(k));
    R_ECEF = DCM_E_E * R_ECI;
    V_ECEF = DCM_E_E * V_ECI;

    %% ECEF -> Geodetic
    wgs84 = wgs84Ellipsoid('kilometer');
    [lat, lon, h] = ecef2geodetic(wgs84, R_ECEF(1), R_ECEF(2), R_ECEF(3), "degrees");
    lat_geoplot = [lat_geoplot, lat];
    lon_geoplot = [lon_geoplot, lon];

    %% ECEF -> ENU
    [R_ENU(1), R_ENU(2), R_ENU(3)] = ecef2enu(R_ECEF(1), R_ECEF(2), R_ECEF(3), ground_lat, ground_lon, height, wgs84);
    R_ENU = [R_ENU(1); R_ENU(2); R_ENU(3)];
   
    % Azimuth angle, Elevation angle
    az = azimuth1(R_ENU);
    el = elevation1(R_ENU, el_mask);
    az_skyplot = [az_skyplot, az];
    el_skyplot = [el_skyplot, el];
end

%% Geoplot / Skyplot
geoplot(lat_geoplot, lon_geoplot,'*');
figure;
skyplot(az_skyplot, el_skyplot);

%% Simulation(GroundTrack)
sampleTime = 60;
sc = satelliteScenario(Initial_time,Final_time,sampleTime);
simul = satellite(sc,a*1000,e,i,RAAN,w,v);
show(simul)
groundTrack(simul,LeadTime=3600)
play(sc,PlaybackSpeedMultiplier=100)

