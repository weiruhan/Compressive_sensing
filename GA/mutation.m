% single point mutation operation
% mutate_rate: probability of mutation operation

function mutation(population_size,chromo_size,mutate_rate)
global population;

for i=1:population_size
    if rand < mutate_rate
        mutate_position = round(rand*chromo_size);  % mutation position
        if mutate_position == 0
            % abandon mutation if mutate_position == 0
            continue;
        end
        population(i,mutate_position) = 1 - population(i, mutate_position);
    end
end

clear i;
clear mutate_position;
