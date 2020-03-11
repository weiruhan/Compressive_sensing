% initialize population
% k is sparsity

function init(population_size, chromo_size,k)
global population;

population = zeros(population_size,chromo_size); % preallocate
for i = 1:population_size
    population(i,randperm(chromo_size,k)) = 1;
end
clear i;