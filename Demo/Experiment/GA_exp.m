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


%% Visualize relation between WSSE & weight & sparsity
i = 0;
ga_info = zeros(size(GA_signal,1),4);
for max_weight = [5,10,25,50]
    for power = [5,10,25,50]
        for sparsity = [16,12,9]
            i = i+1;
            ga_info(i,:) = [sparsity,power,max_weight,GA_WSSE{i}];
        end
    end
end
% convert array to table
ga_info = array2table(ga_info,'variablenames',{'sparsity','power','max_weight','WSSE'});

for power = [5,10,25,50]
    for sparsity = [16,12,9]
        sub_ga_info = ga_info(ga_info.power == power & ga_info.sparsity == sparsity,:);
        h = figure;
        plot(sub_ga_info.max_weight,sub_ga_info.WSSE,'k');
        grid on
        title(sprintf("%s=%d\n%d-%s",'power',power,sparsity,'sparsity'));
        xlabel('max\_weight');
        ylabel('WSSE');
        saveas(h,sprintf('%s%d_%d%s.png','power',power,sparsity,'sparse'));
        close(h);
    end
end

%% subplot
i = 0;
position = cell(12,1);
for power = [5,10,25,50]
    for sparsity = [16,12,9]
        i = i+1;
        sub_ga_info = ga_info(ga_info.power == power & ga_info.sparsity == sparsity,:);
        h = subplot(4,3,i);
        position{i} = get(h,'position');
        plot(sub_ga_info.max_weight,sub_ga_info.WSSE,'k');
        grid on
        title(sprintf("%s=%d\n%d-%s",'power',power,sparsity,'sparsity'));
        ylim([0.005,0.035]);
    end
end
height = position{1}(2)+position{1}(4)-position{12}(2);
width = position{12}(1)+position{12}(3)-position{1}(1);
h5 = axes('position',[position{10}(1) position{10}(2) width height],'visible','off');
h5.XLabel.Visible = 'on';
h5.YLabel.Visible = 'on';
axes(h5);
ylabel('WSSE');
xlabel('max\_weight');




