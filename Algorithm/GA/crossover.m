% crossover

function crossover(population_size,chromo_size,k)
global population;
global population_new;
global fitness_value;

% rank of fitness_value
[~,idx] = sort(fitness_value((1.5*population_size+1):(2.5*population_size)),'ascend');
prob = 1./idx;% inverse probability of rank
for i=1:(0.5*population_size)
    
    % cross-over chromosome index
    index = [];
    while length(unique(index)) ~=2 % iterater as to do sampling without replacement
        index = randsample(1:population_size,2,true,prob);% sampling with replacement
    end
    
    for j = 1:chromo_size
        % parent 1/2
        parent_index = randsample(1:2,1,true,[1/2,1/2]);
        population_new(i,j) = population(index(parent_index),j); % cross-over
    end
    
    if sum(population_new(i,:)) < k % zeros terms are more than required
        [~,zero_index] = find(~population_new(i,:)); % zero index
        replace_index = randsample(zero_index,k-sum(population_new(i,:))); % replace index
        population_new(i,replace_index) = 1-population_new(i,replace_index);% replacement
    elseif sum(population_new(i,:)) > k % nonzero terms are more than required
        [~,nonzero_index] = find(population_new(i,:)); % nonzero index
        replace_index = randsample(nonzero_index,sum(population_new(i,:))-k); % replace index
        population_new(i,replace_index) = 1-population_new(i,replace_index); % replacement
    end   
end

clear i;
clear j;
clear temp;
clear cross_position;
clear idx;
clear index;
clear zero_index;
clear nonzero_index;
clear replace_index;
clear prob;
clear parent_index;