% population_size: size of population
% chromo_size: length of chromosome
% D is input dictionary
% Y is input signals
% option is weight criteria
% power is weight power
% Max is maximum weight

function fitness(population_size,D,Y,W)
global fitness_value;
global population_new;

% initialize population fitness values
fitness_value(1:2.5*population_size)=0;


for i = 1:(2.5*population_size)
    D_new = D * diag(population_new(i,:));
    if unique(D_new)==0
        fitness_value(i) = Inf;
        continue
    end
    D_new = D_new(:,any(D_new,1)); % sparse dictionary
    [~,fitness_value(i)] = wlr(D_new,Y,W); 
end

clear i;
clear D_new;

