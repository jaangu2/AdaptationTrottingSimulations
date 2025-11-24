clear
SimulationConfig
load(".\vpp_data3\states.mat");

numStates = length(states);
indexVector = repmat({1},1,numStates); % this makes a cell array of ones that is the length of the number of states, so it can be used as an indexing vector
ready = false;
figureCounter = 1;
while ~ready
    
    fprintf('[')
    for i = 1:numStates
        fprintf('%d,',indexVector{i})
    end
    fprintf(']\n')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fileDir = '.\vpp_data3\';
    filenameNumbers = [];
    for i = 1:numStates
        filenameNumbers = [filenameNumbers num2str(indexVector{i})];
    end
    load([fileDir filenameNumbers '_nonAdapt'])
    load([fileDir filenameNumbers '_adapt'])

    PlotAdaptingResults(adaptResults,figureCounter)
    PlotNonAdaptingResults(nonAdaptResults,figureCounter)
    figureCounter = figureCounter+1;
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
