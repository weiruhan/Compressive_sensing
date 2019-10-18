% initialize population
% k is sparsity

function init(population_size, chromo_size,k)
global population;
for i = 1:population_size
    population(i,:) = zeros(1,chromo_size);
    population(i,randperm(chromo_size,k)) = 1;
end
clear i;