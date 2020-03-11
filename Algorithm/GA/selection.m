% selection
function selection(population_size)
global population; % previous population
global population_new; % updated population

% generate new population
% exchange population and population_new
population(1:population_size,:) = population_new((1.5*population_size+1):(2.5*population_size),:);
population_new((1.5*population_size+1):(2.5*population_size),:) = population(1:population_size,:);


