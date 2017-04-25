function [infected, recovered] = AgentBasedGraph(country, numPeople, numInfected, numConnections, numTimeSteps, infectiousConst, recoveryConst) 

%%initialize variables
people = zeros(numPeople, numConnections + 2); %% adjacency list of graph
% first column is status, 1 if infected, 2 if recovered
% second column is location
% all other columns are the actual adjacency list (index based)
infected = zeros(numTimeSteps, 1); % preallocate array to hold infected quantities of individuals over time
recovered = zeros(numTimeSteps, 1); % preallocate array to hold recovered quantities of individuals over time

%% assign numOfCountry variable
numOfCountry = 0;
if (strcmp(country, 'Guinea') == 0)
    numOfCountry = 1;
else
    if (strcmp(country, 'Sierra Leone') == 0)
        numOfCountry = 2;
    else
        if (strcmp(country, 'Liberia') == 0)
            numOfCountry = 3;
        end
    end
end

districts = getDistrictInfo(numOfCountry);
% districtThresh = zeros(length(fieldnames(districts)),1);
% 
% 
% for i = 1:length(fieldnames(districts))
%     fields = fieldnames(districts);
%     d = districts.(genvarname(fields{i}));
%     a = districts.(genvarname(fields{i})).population;
%     if (i == 1)
%         districtThresh = a;
%     else
%         districtThresh = districtThresh(i - 1) + a;
%     end
% end
% 
% districtThresh = districtThresh ./ districtThresh(end);


%%assign people as infected
chosenInfected = randperm(numPeople, numInfected);
people(chosenInfected, 1) = 1;

% 0 is uninfected
% 1 is infected
% 2 is recovered
%%

%%instantiate random connections
for i = 1:numPeople
    for j = 1:numConnections
        people(i,j + 2) = randi(numPeople);
    end
end

for t = 1:numTimeSteps
    for j = 1:numPeople
        isInfected = (people(j, 1) == 1);
        for e = 1:numConnections
            edge = people(j, e + 2);
            if isInfected
                if people(edge, 1) ~= 2
                    if rand < infectiousConst
                        % when contacting person is infectious, other person isn't recovered, and probability
                        people(edge, 1) = 1;
                    end
                end
            end
        end
        % should person recover now?
        if rand < recoveryConst && isInfected
            people(j, 1) = 2;
        end
    end
    % go measure people list
    for j = 1:numPeople
        if (people(j, 1) == 1)
            infected(t) = infected(t) + 1;
        end
        if (people(j, 1) == 2)
            recovered(t) = recovered(t) + 1;
        end
    end
end




end