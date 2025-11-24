function [res] = PlotAdaptingResults(res,fig_num)
% res: this is the simulation output file (SimulationOutput file type)
% fig_num: this is what number figure to create, e.g. Figure 1, or Figure 22, etc.

numSSCycles = 10;

% Find the stance portion of the data for every step of this trial
myCounter = 1;
index = [];
theData = res.gammaDesiredRight.Data;
theTime = res.gammaDesiredRight.Time;
for finalIndexer = 3:length(theData)
    if sign(theData(finalIndexer-1))<=0 && sign(theData(finalIndexer))>0
        index(myCounter)=finalIndexer-1;
        myCounter = myCounter + 1;
    end
end

% if not enough steady state stance phases were met, return
if length(index)<=numSSCycles
    return
end

% For every steady stance phase being used, grab the important results (Kg,
% GRF direction, phi desired, time)
KgAccumulator = {};
GRFDirAccumulator = {};
timePercentageAccumulator = {};
desPhiAccumulator = {};
% figure()
accumulationCounter = 1;
for finalIndexer = 1:(numSSCycles) % for every SS stance
    useThisRange = index(end-finalIndexer):index(end-(finalIndexer-1));
    timeThisLoop = theTime(useThisRange)-theTime(index(end-finalIndexer));
    GRFzThisLoop = res.GRFzRR.Data(useThisRange);
    GRFxThisLoop = res.GRFxRR.Data(:,1);
    GRFxThisLoop = GRFxThisLoop(useThisRange);
    KgThisLoop   = res.KgRR.Data(useThisRange);
    gcThisLoop   = res.groundContactRR.Data(useThisRange);
    desPhiThisLoop = res.phiDRR.Data(useThisRange);
    if sum(gcThisLoop)==0 % If the foot never made ground contact during this stance phase, continue
        continue
    end
    % Isolate only the data where ground contact occured during this
    % stance:
    myGRFz   = GRFzThisLoop(gcThisLoop==1);
    myGRFx   = GRFxThisLoop(gcThisLoop==1);
    myTime   = timeThisLoop(gcThisLoop==1);
    myKg     = KgThisLoop(gcThisLoop==1);
    myPhiD   = desPhiThisLoop(gcThisLoop==1);
    myGRFDir = atan2d(myGRFz,myGRFx);

    GRFDir = atan2d(GRFzThisLoop,GRFxThisLoop);
    timePercentage = ((myTime-myTime(1))/(myTime(end)-myTime(1)))*100; % Normalized stance time for plotting along the X-axis

    % % This plot shows the GRF dir and applied Kg for each individual stance phase 
    % sgtitle(['Desired GRF Dir=', num2str(GRFDirInput),' damping=',num2str(alphaInput)])
    % subplot(2,1,1)
    % hold on
    % plot(timePercentage,myGRFDir)
    % % plot(timeThisLoop,desPhiThisLoop)
    % % plot(timeThisLoop,atan2d(GRFzThisLoop,GRFxThisLoop))
    % title('GRF Direction')
    % hold off
    % subplot(2,1,2)
    % hold on
    % plot(timePercentage,myKg)
    % % plot(timeThisLoop,KgThisLoop)
    % title('Applied Kg')
    % xlabel('Portion of Stance (%)')
    % hold off
    % drawnow

    % Store the results from the current stance into the accumulators
    KgAccumulator{accumulationCounter} = myKg;
    GRFDirAccumulator{accumulationCounter} = myGRFDir;
    timePercentageAccumulator{accumulationCounter} = timePercentage;
    desPhiAccumulator{accumulationCounter} = myPhiD;
    accumulationCounter = accumulationCounter + 1;
end
% Observe accumulators length:
fprintf('When checking the adapting results the accumulators were length %d \n',length(KgAccumulator))

% Find the ground contact instance with the least amount of data points
smallestLength = length(timePercentageAccumulator{1});
smallestIndex = 1;
for k = 1:length(KgAccumulator)
    if(length(timePercentageAccumulator{k})<smallestLength)
        smallestLength = length(timePercentageAccumulator{k});
        smallestIndex = k;
    end
end

% Find the mean and standard deviation of the GRF direction, Kg, and phiD
% for every timestep across all the trials.
GRFDirAvePerTimestep = [];
GRFDirStdPerTimestep = [];
KgAvePerTimestep = [];
KgStdPerTimestep = [];
phiDAvePerTimestep = [];
for l = 1:smallestLength % for every time step
    GRFPerTimeStepVector = [];
    KgPerTimeStepVector = [];
    phiDPerTimeStepVector = [];
    for k = 1:length(KgAccumulator) % for every stance phase
        GRFPerTimeStepVector(k)=GRFDirAccumulator{k}(l);
        KgPerTimeStepVector(k)=KgAccumulator{k}(l);
        phiDPerTimeStepVector(k) = desPhiAccumulator{k}(l);
    end
    GRFDirAvePerTimestep(l) = mean(GRFPerTimeStepVector);
    GRFDirStdPerTimestep(l) = std(GRFPerTimeStepVector);
    KgAvePerTimestep(l) = mean(KgPerTimeStepVector);
    KgStdPerTimestep(l) = std(KgPerTimeStepVector);
    phiDAvePerTimestep(l) = mean(phiDPerTimeStepVector);
end

% Save these values back into the data structure
res.GRFDirAvePerTimestep = GRFDirAvePerTimestep;
res.GRFDirStdPerTimestep = GRFDirStdPerTimestep;
res.KgAvePerTimestep = KgAvePerTimestep;
res.KgStdPerTimestep = KgStdPerTimestep;
res.phiDAvePerTimestep = phiDAvePerTimestep;
res.smallestIndex = smallestIndex;


%% Plotter
% Plot the average GRF and phi desired as thick lines. Surround the average
% GRF direction with a border that is the width of the standard deviation
% at every timestep. Use the normalized X-axis.
figure(fig_num)
subplot(2,1,1)
x = timePercentageAccumulator{smallestIndex}';
hold on
plot(x, GRFDirAvePerTimestep,'r--','LineWidth',3,'DisplayName','$\phi$ Adapting')
fill([x, flip(x)], [(GRFDirAvePerTimestep+GRFDirStdPerTimestep), flip((GRFDirAvePerTimestep-GRFDirStdPerTimestep))], 'r-','FaceAlpha',0.2,'LineWidth',1,'HandleVisibility','off')
% title(['$\phi_d=$' num2str(GRFDirInput) ' deg, $B_K=$10 Nms/rad, Stride Angle$=\pm$' num2str(alphaInput) ' deg'],'Interpreter','latex') 
plot(x, phiDAvePerTimestep*180/pi, 'g-','LineWidth',2,'DisplayName','$\phi_d$')

ylabel('GRF Dir, $\phi$, (deg)', 'Interpreter','latex')
legend('Interpreter','latex','Location','northwest')
set(gca,'LineWidth',3)
set(gca,'FontSize',15)

% Plot the average Kg with a similar border that is the width of the std.
subplot(2,1,2)
fill([x, flip(x)], [KgAvePerTimestep+KgStdPerTimestep, flip(KgAvePerTimestep-KgStdPerTimestep)], 'r-','FaceAlpha',0.2,'LineWidth',1,'LineStyle','-')
hold on
plot(x, KgAvePerTimestep, 'r--','LineWidth',3)
ylabel('$K_p$', 'Interpreter','latex')
xlabel('Portion of Stance (\%)', 'Interpreter','latex')
set(gca,'LineWidth',3)
set(gca,'FontSize',15)

%% Calculating Percentage of Time Kp was Saturated
% Quantifiable performance metric #1
satAmount = res.KgAvePerTimestep == 100 | res.KgAvePerTimestep == 40000;
satPerc = (sum(satAmount)/length(satAmount))*100;
fprintf('Kp was saturated for %0.1f %%. \n',satPerc)
res.percentageOfTimeKpWasSaturated = satPerc; % Save this value
%% Calculating Ave phi_error
% Quantifiable performance metric #2
phi_d = phiDAvePerTimestep*180/pi;
phi = GRFDirAvePerTimestep;
phi_e = phi_d - phi;
rmsd = sqrt(mean(phi_e.^2));
res.RMSDphi = rmsd; % Save this value
fprintf('RMSD     adapt was %0.4f \n',rmsd)

end