function main()
D = basis;
Y = ideal;
option = "nonlinear";
power = 10;
Max = 10;
k = 9;
population_size = 10;      
chromo_size = 32;       
generation_size = 20;      
     

[best_individual,best_fitness,iterations] = genetic_algorithm(population_size, chromo_size, generation_size,D,Y,option,power,Max,k);

best_basis = basis*diag(best_individual);
[~,best_basis_idx] = find(best_basis);
best_basis = best_basis(:,unique(best_basis_idx));
[best_co,best_WSSE]=WLR(best_basis,ideal,"nonlinear",10,10);
best_signal = best_basis*best_co;
plot(best_signal);
hold on
plot(ideal);

clear;