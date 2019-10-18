% rank population fitness value and store best individuals

function rank(population_size, chromo_size)
global fitness_value;   
global fitness_sum;     % accumulated fitness value
global fitness_average;
global best_fitness;
global best_individual;
global best_generation;
global population;
global G;

for i=1:population_size    
    fitness_sum(i) = 0.;
end

max_index = 1;
temp = 1;
temp_chromosome(chromo_size)=0;


for i=1:population_size
    max_index = i;
    for j = i+1:population_size
        if fitness_value(j) > fitness_value(max_index)
            max_index = j;
        end
    end
    
    if max_index ~= i
        % exchange fitness_value(i) and fitness_value(min_index)
        temp = fitness_value(i);
        fitness_value(i) = fitness_value(max_index);
        fitness_value(max_index) = temp;
        
        
        % exchange population(i) and population(min_index) ?chromosome
        for k = 1:chromosome_size
            temp_chromosome(k) = population(i,k);
            population(i,k) = population(max_index,k);
            population(max_index,k) = temp_chromosome(k);
        end
    end
end

% fitness_sum
for i=1:population_size
    if i==1
        fitness_sum(i) = fitness_sum(i) + fitness_value(i);    
    else
        fitness_sum(i) = fitness_sum(i-1) + fitness_value(i);
    end
end

% fitness_average(G) = average fitness at G's generation
fitness_average(G) = fitness_sum(population_size)/population_size;

%
if fitness_value(population_size) > best_fitness
    best_fitness = fitness_value(population_size);
    best_generation = G;
    for j=1:chromo_size
        best_individual(j) = population(population_size,j);
    end
end


clear i;
clear j;
clear k;
clear max_index;
clear temp;
clear temp_chromosome;