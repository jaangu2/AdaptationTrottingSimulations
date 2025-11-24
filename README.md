# AdaptingTrottingSimulations
These are the project files for running all my adaptation trials for the trotting quadruped simulation for my final thesis chapter.

## Files:
**Trotter_nonsymbolic_VarPhiD.slx**: This is the simscape multibody model of a trotting quadruped. 
**SimulationConfig.m**: This initializes all simulation and model parameters.
**RunAllVPPTrials.m**: Based on the user-input values for each state variable, runs all trotting trials, both adapting and non-adapting, and saves the data.
**PlotAllVPPTrials.m**: Uses the saved data from all the trials and plots each trial in its own figure, ready to be published.
**PlotNonAdaptingResults.m**: Supplementary file called by the PlotAllVPPTrials.m code.
**PlotAdaptingResults.m**: Supplementary file called by the PlotAllVPPTrials.m code.
**.\Libraries\**: This folder contains the ground contact model obtained from https://github.com/mathworks/Simscape-Multibody-Contact-Forces-Library
**.\vpp_data3\XXXXXXX_adapt.mat**: Resulting data from an adaptation trial based on the state vector index XXXXXXX.
**.\vpp_data3\XXXXXXX_nonadapt.mat**: Resulting data from a non-adapting trial based on the state vector index XXXXXXX.
**.\vpp_data3\states.mat**: The state variable vector used for the data in this directory.

## Overview:
This project involved building a multibody model in simscape of a quadrupedal system that trots along the ground and uses adjustable hip stiffness to redirect the ground reaction forces (GRFs) acting on the feet during locomotion to point toward a virtual pivot point (VPP) that is located somewhere above the centor of mass (COM). The process has been automated into a script that runs all the siulations and saves the data, and a file that plots all the resulting data in formatted figures ready to be published. 

## Operation:
To run this project 
1. download the files,
2. input the parameter values for the model and simulation into the SimulationConfig.m file,
3. update the save directory location in the RunAllVPPTrials.m file
4. input the values you want to test for each state variable into the state variable vectors at the beginning of the RunAllVPPTrials.m file
5. run the RunAllVPPTrials.m file
6. update the data directory in the PlotAllVPPTrials.m file
7. run the PlotAllVPPTrials.m file
8. enjoy your data plots!
