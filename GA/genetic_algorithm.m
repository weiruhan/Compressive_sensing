% genetic algorithm

function [m,n,p] = genetic_algorithm(population_size,chromo_size,generation_size, cross_rate, mutate_rate,D,Y,option,power,Max,k)

global G ;              
global fitness_value;  
global best_fitness;    
global fitness_average; 
global best_individual; 
global best_generation; 


fitness_average = zeros(generation_size,1); 
disp [genetic algorithm]

fitness_value(population_size) = 0.;
best_fitness = 0.;
best_generation = 0;

init(population_size, chromo_size,k); % initialization

for G=1:generation_size   
    fitness(population_size,D,Y,option,power,Max);              
    rank(population_size, chromo_size);                 
    selection(population_size, chromo_size);   
    crossover(population_size, chromo_size, cross_rate);
    mutation(population_size, chromo_size, mutate_rate);
end

plotGA(generation_size);

m = best_individual;    
n = best_fitness;       
p = best_generation;    


