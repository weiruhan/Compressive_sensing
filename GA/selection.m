% selection
function selection(population_size,chromo_size)
global population; % previous population
global population_new; % updated population

for i=1:population_size
   % generate new population
   % exchange population and population_new
   for j=1:chromo_size
        population(i,j) = population_new(1.5*population_size+i,j);
        population_new(1.5*population_size+i,j) = population(i,j);
   end
end

