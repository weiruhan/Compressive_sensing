% single point mutation operation
% mutate_rate: probability of mutation operation

function mutation(population_size)

global population;
global population_new;

for i=1:population_size
    [~,zero_idx] = find(~population(i,:)); % zero index
    [~,nonzero_idx] = find(population(i,:));% nonzero index
    population_new(0.5*population_size+i,:) = population(i,:);
    % randomly swap 0/1 to 1/0 
    population_new(0.5*population_size+i,randsample(zero_idx,1))=1;
    population_new(0.5*population_size+i,randsample(nonzero_idx,1))=0;
     
end

clear i;
clear zero_idx;
clear nonzero_idx
