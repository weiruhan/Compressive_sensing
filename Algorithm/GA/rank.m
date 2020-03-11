% Rank population fitness value and store best individuals

function rank(population_size)
global fitness_value;   
global fitness_sum;     
global fitness_average;
global best_fitness;
global best_individual;
global best_generation;
global G;
global population_new;
global optimal_fitness;


for i=1:(2.5*population_size)
    max_index = i;
    for j = i+1:(2.5*population_size)
        if fitness_value(j) > fitness_value(max_index)
            max_index = j;
        end
    end
    
    if max_index ~= i
        % exchange fitness_value(i) and fitness_value(max_index)
        temp = fitness_value(i);
        fitness_value(i) = fitness_value(max_index);
        fitness_value(max_index) = temp;
        
        % exchange population_new(i) and population_new(max_index)
        temp_chromosome = population_new(i,:);
        population_new(i,:) = population_new(max_index,:);
        population_new(max_index,:) = temp_chromosome;
    end
end

% fitness_sum
fitness_sum = cumsum(fitness_value);

% fitness_average(G) = average fitness at G's generation
fitness_average(G) = fitness_sum(2.5*population_size)/(2.5*population_size);

% best population and best fitness
if fitness_value(2.5*population_size) < best_fitness
    best_fitness = fitness_value(2.5*population_size);
    best_generation = G;
    best_individual = population_new(2.5*population_size,:);
end

optimal_fitness(G) = fitness_value(2.5*population_size);


clear i
clear j
clear k
clear max_index
clear temp
clear temp_chromosome



