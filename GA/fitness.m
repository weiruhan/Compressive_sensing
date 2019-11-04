% population_size: size of population
% chromo_size: length of chromosome
% D is input dictionary
% Y is input signals
% option is weight criteria
% power is weight power
% Max is maximum weight

function fitness(population_size,D,Y,option,power,Max)
global fitness_value;
global population_new;

% initialize population fitness values
for i = 1:(2.5*population_size)
    fitness_value(i)=0;
end

for i = 1:(2.5*population_size)
    D_new = D * diag(population_new(i,:));
    if unique(D_new)==0
        fitness_value(i) = Inf;
        continue
    end
    [~,idx] = find(D_new);
    D_new = D_new(:,unique(idx)); % sparse dictionary
    [~,fitness_value(i)] = WLR(D_new,Y,option,power,Max); 
end

clear i;
clear D_new;
clear idx;

