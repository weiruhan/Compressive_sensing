% selection
function selection(population_size,chromo_size)
global population; % previous population
global population_new; % updated population
global fitness_sum; % accumulated population fitness value

for i=1:population_size
    % generate a random number between [0,fitness_sum]
    r = rand * fitness_sum(population_size); 
    first = 1;
    last = population_size;
    mid = round((last+first)/2);
    idx = -1;
    
    % binary search
    while (first <= last) && (idx == -1) 
        if r > fitness_sum(mid)
            first = mid;
        elseif r < fitness_sum(mid)
            last = mid;     
        else
            idx = mid;
            break;
        end
        mid = round((last+first)/2);
        if (last - first) == 1
            idx = last;
            break;
        end
    end
   
   % generate new population
   for j=1:chromo_size
        population_new(i,j) = population(idx,j);
   end
end

p = population_size - 1;
for i = 1:p
    for j = 1:chromo_size
        population(i,j) = population_new(i,j);
    end
end

clear i;
clear j;
clear population_new;
clear first;
clear last;
clear idx;
clear mid;
