% Export generation process

function plotGA(generation_size)
global optimal_fitness;
x = 1:1:generation_size;
y = optimal_fitness;
plot(x,y)
title("best fitness tendency")
xlabel("generation")
ylabel("weighted SSE")