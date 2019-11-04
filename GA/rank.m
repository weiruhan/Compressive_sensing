% rank population fitness value and store best individuals

function rank(population_size, chromo_size)
global fitness_value;   
global fitness_sum;     
global fitness_average;
global best_fitness;
global best_individual;
global best_generation;
global G;
global population_new;

for i=1:(2.5*population_size)
    fitness_sum(i) = 0;
end


temp_chromosome(chromo_size)=0;

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
        for k = 1:chromo_size
            temp_chromosome(k) = population_new(i,k);
            population_new(i,k) = population_new(max_index,k);
            population_new(max_index,k) = temp_chromosome(k);
        end
    end
end

% fitness_sum
for i=1:(2.5*population_size)
    if i==1
        fitness_sum(i) = fitness_sum(i) + fitness_value(i);    
    else
        fitness_sum(i) = fitness_sum(i-1) + fitness_value(i);
    end
end

% fitness_average(G) = average fitness at G's generation
fitness_average(G) = fitness_sum(2.5*population_size)/(2.5*population_size);

%
if fitness_value(2.5*population_size) < best_fitness
    best_fitness = fitness_value(2.5*population_size);
    best_generation = G;
    for j=1:chromo_size
        best_individual(j) = population_new(2.5*population_size,j);
    end
end


clear i;
clear j;
clear k;
clear max_index;
clear temp;
clear temp_chromosome;