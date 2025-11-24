% This file sets the parameters of the simulation.

clear
addpath(genpath('Libraries')); % This folder has the ground contact model in it

shouldIAdaptKp = 1;
VPP_Offset = 1; % meters above the COM in the torso frame

desiredGRFAngle = 75*pi/180; % rad

alpha0      = 100*pi/180; % rad, knee home angle
alpha0Elbow = -alpha0;
   
hipFreq     = 2; % Hz, Trotting speed
strideAngle = 40; % (deg)
omega       = (strideAngle*pi/180)*(2*hipFreq); % rad/s

grav = -9.80665; % m/s/s

maxKgLimit = 40000; % N/m
startupTime = 0; % sec
startingHipStiffness = 1000; % N/m
hipSwingStiffness = 1000; % N/m, hip stiffness during swing phase
hipKd = 1; % Nms/rad, hip joint damping
Ka = 500; % stiffness of the knee/elbow joints
kneeDamping = 20; % Nms/rad

L1 = 1; % (m) upper leg length
L2 = 1; % (m) lower leg length
mHip = 10; % (kg) hip mass
legCylindarRadius = 0.02; % (m) for visualization purposes
hipSphereRadius = 0.1; % (m) for visualization purposes
torsoLength = 2.5; % m
torsoHeight = 0.2; % m
torsoWidth = 0.2; % m
rf = 0.05; % foot sphere radius in meters
m1 = 0.001; % kg, upper leg mass
m2 = 0.001; % kg, lower leg mass
mf = 0.001; % kg, foot mass
groundLx = 1000; % (m) ground length param
groundLy = 1000; % (m) ground length param
Kground = 1e5; % N/m, ground contact model stiffness
Bground = 5e3; % Ns/m, ground contact model damping
groundThickness = 0.1; % m


alphaHome = alpha0;
alphaHomeElbow = -alphaHome;
f2h0 = sqrt(L1^2+L2^2-2*L1*L2*cos(pi-alpha0)); % m, initial length from the foot to the hip
beta0 = (strideAngle/2)*pi/180; % rad, intermediate angle for leg geometry
phi0 = acos((L1^2-L2^2-f2h0^2)/-(2*L2*f2h0)); % this will always be positive
% gamma0Elbow = beta0 - phi0;
x0=f2h0*cos(beta0+pi/2); % m, Initial hip x-position
y0=f2h0*sin(beta0+pi/2); % m, Initial hip y-position
yOffset = 0.1; % height off the ground the leg starts (m)

Vx0 = omega*f2h0*cosd(strideAngle/2); % m/s, initial velocity overall in the forward horizontal direction
Vy0 = 0; % -3; % m/s, initial velocity in the vertical direction


gammaRR0 = phi0 + (strideAngle/2)*pi/180; % rad, initial hip/shoulder angle
gammaRL0 = phi0 - (strideAngle/2)*pi/180; % rad, initial hip/shoulder angle
gammaFR0 = -phi0 + (strideAngle/2)*pi/180; % rad, initial hip/shoulder angle
gammaFL0 = -phi0 - (strideAngle/2)*pi/180; % rad, initial hip/shoulder angle

