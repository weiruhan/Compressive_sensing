% single point cross-over operation
% cross_rate: probability of cross-over operation

function crossover(population_size,chromo_size, cross_rate)
global population;
% step = 2
for i=1:2:population_size
    % if rand < cross_rate, implement cross-over operation between 2
    % individuals
    if(rand < cross_rate)
        cross_position = round(rand * chromo_size);
        if (cross_position == 0 || cross_position == 1)
            continue;
        end
        % implement cross-over operation for position after cross_position
        % including cross_position
        for j=cross_position:chromo_size
            temp = population(i,j);
            population(i,j) = population(i+1,j);
            population(i+1,j) = temp;
        end
    end
end

clear i;
clear j;
clear temp;
clear cross_position;
