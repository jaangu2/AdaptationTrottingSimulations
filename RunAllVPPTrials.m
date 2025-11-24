clear
SimulationConfig
% Insert all the values for each array for each state variable that I want
% to test
states{1} = 1; %[1 2]; % vppAry, m above COM
states{2} = 7.5; %[7.5 10 12.5]; % kneeBAry, Nms/rad
states{3} = 100*pi/180; %[80 100 120]*pi/180; % alpha0Ary, rad
states{4} = 30; % strideAngleAry (deg)
states{5} = 2; % freqAry, Hz
states{6} = 750; % [500 750 1000 1500]; % hipswingstiffness, Nm/rad
states{7} = 750; % [250 500 750]; % knee stiffness, Nm/rad

numStates = length(states);
indexVector = repmat({1},1,numStates); % this makes a cell array of ones that is the length of the number of states, so it can be used as an indexing vector
ready = false;
figureCounter = 1;
while ~ready

    % This part grabs the current state variable values
    fprintf('[%d,%d,%d,%d,%d,%d,%d] \n',indexVector{1},indexVector{2},indexVector{3},indexVector{4},indexVector{5},indexVector{6},indexVector{7})
    VPP_Offset = states{1}(indexVector{1});
    kneeDamping = states{2}(indexVector{2});
    alpha0 = states{3}(indexVector{3});
    strideAngle = states{4}(indexVector{4});
    hipFreq = states{5}(indexVector{5});
    hipSwingStiffness = states{6}(indexVector{6});
    Ka = states{7}(indexVector{7});

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This part sets all the configuration parameters
    alpha0Elbow = -alpha0;
    omega       = (strideAngle*pi/180)*(2*hipFreq); % rad/s
    alphaHome = alpha0;
    alphaHomeElbow = -alphaHome;
    f2h0 = sqrt(L1^2+L2^2-2*L1*L2*cos(pi-alpha0));
    beta0 = (strideAngle/2)*pi/180;
    phi0 = acos((L1^2-L2^2-f2h0^2)/-(2*L2*f2h0)); % this will always be positive
    x0=f2h0*cos(beta0+pi/2); % Initial hip x-position
    y0=f2h0*sin(beta0+pi/2); % Initial hip y-position

    Vx0 = omega*f2h0*cosd(strideAngle/2);
    Vy0 = 0; % -3;

    gammaRR0 = phi0 + (strideAngle/2)*pi/180;
    gammaRL0 = phi0 - (strideAngle/2)*pi/180;
    gammaFR0 = -phi0 + (strideAngle/2)*pi/180;
    gammaFL0 = -phi0 - (strideAngle/2)*pi/180;
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This is the part that runs the simulation and saves it into a struct
    shouldIAdaptKp = 0;
    nonAdaptResults=sim('Trotter_nonsymbolic_VarPhiD.slx',1);
    shouldIAdaptKp = 1;
    adaptResults=sim('Trotter_nonsymbolic_VarPhiD.slx',1);
    fileDir = '.\vpp_data3\';
    filenameNumbers = [num2str(indexVector{1}) num2str(indexVector{2}) num2str(indexVector{3}) num2str(indexVector{4}) num2str(indexVector{5}) num2str(indexVector{6}) num2str(indexVector{7})];
    save([fileDir filenameNumbers '_nonAdapt'],"nonAdaptResults",'-v7.3')
    save([fileDir filenameNumbers '_adapt'],"adaptResults",'-v7.3')

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This for/if loop updates the index vector to get every permutation of
    % index values, like (1,1,1) (2,1,1) (1,2,1) (2,2,1) (1,1,2) etc.
    ready = true;
    for k = 1:numStates
        indexVector{k} = indexVector{k}+1;
        if indexVector{k}<=length(states{k})
            ready = false;
            break
        end
        indexVector{k}=1;
    end
end
