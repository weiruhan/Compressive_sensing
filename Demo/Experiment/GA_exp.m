%% Genetic algorithm experiment
i = 0;
D = basis;
Y = ideal;
option = "nonlinear";
population_size = 10; % population size
chromo_size = 32; % chromosome size
generation_size = 20; % generation size

GA_coeff = cell(48,1); % coefficient
GA_order = cell(48,1); % basis index
GA_Base = cell(48,1); % selected basis
GA_WSSE = cell(48,1); % weighted sum of square errors
GA_time = cell(48,1); % function runtime
GA_signal = cell(48,1); % reconstructed signal

for max_weight = [5,10,25,50]
    for power = [5,10,25,50]
        for sparsity = [16,12,9]
            i = i+1;
            % preallocate weight
            W =weight(ideal,'nonlinear',power,max_weight);
            %% calculate time
            tic;
            [best_individual,GA_WSSE{i},~] = ...
                genetic_algorithm(population_size, chromo_size, ...
                generation_size,D,Y,W,sparsity);
            GA_time{i} = toc;
            %% reconstruct signal
            GA_order{i} = find(best_individual);
            GA_Base{i} = D * diag(best_individual);
            GA_Base{i} = GA_Base{i}(:,GA_order{i});
            [GA_coeff{i},~] = wlr(GA_Base{i},Y,W);
            GA_signal{i} = GA_Base{i} * GA_coeff{i};
        end
    end
end

%% average runtime
GA_average_time = mean([GA_time{:}]);

%% peak residual and peak location residual
GA_peak_res = cell(48,1);
GA_location_deviation = cell(48,1);

for i = 1:48
    res = 0;
    [~,index] = max(GA_signal{i});
    for idx = 1:7
        res = abs(GA_signal{i}(location(idx),idx)-1)+res;
    end
    GA_peak_res{i} = res/7;
    GA_location_deviation{i} = mean(abs(index-location));
end

clear i;
clear res;
clear idx;
clear index;

%% scatter plot base index
GA_base_comp = [];
for i = 1:48
    nrow = size(GA_order{i},2);
    temp = [repmat(i,nrow,1),GA_order{i}'];
    GA_base_comp = [GA_base_comp; temp]; % concatenation
end
scatter(GA_base_comp(:,1),GA_base_comp(:,2));
title("basis index scatter plot"); 
xlabel("group");
ylabel("basis index");

clear nrow;

%% Visualize signal
i = 0;
for max_weight = [5,10,25,50]
    for power = [5,10,25,50]
        for sparsity = [16,12,9]
            i = i+1;
            h = figure;
            plot(GA_signal{i});
            hold on
            plot(ideal);
            txt = sprintf("%s=%d\n%s=%d\n%d-%s",'max\_weight',max_weight,...
                'power',power,sparsity,'sparse');
            title(txt);
            hold off
            saveas(h,sprintf('%d%s_%d%s.png',i,'train',sparsity,'sparse'));
            close(h);
        end
    end
end
clear txt




