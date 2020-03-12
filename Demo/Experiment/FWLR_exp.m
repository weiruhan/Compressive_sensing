%% Forward selection experiment 
i = 0;
fwd_coeff = cell(48,1); % coefficient
fwd_order = cell(48,1); % basis index
fwd_Base = cell(48,1); % selected basis
fwd_WSSE = cell(48,1); % weighted sum of square error
fwd_time = cell(48,1); % function runtime
fwd_signal = cell(48,1); % reconstructed signal
for max_weight = [5,10,25,50]
    for power = [5,10,25,50]
        for sparsity = [16,12,9]
            i = i+1;
            W = weight(ideal,'nonlinear',power,max_weight);
            tic;
            [fwd_coeff{i},fwd_order{i},fwd_Base{i},fwd_WSSE{i}]=...
                fwd_wlr(basis,ideal,W,sparsity);
            fwd_time{i} = toc;
            fwd_signal{i} = fwd_Base{i} * fwd_coeff{i};
        end
    end
end

fwd_average_time = mean([fwd_time{:}]); % average runtime

%% peak residual and peak location residual
fwd_peak_res = cell(48,1);
fwd_location_deviation = cell(48,1);

for i = 1:48
    res = 0;
    [~,index] = max(fwd_signal{i});
    for idx = 1:7
        res = abs(fwd_signal{i}(location(idx),idx)-1)+res;
    end
    fwd_peak_res{i} = res/7;
    fwd_location_deviation{i} = mean(abs(index-location));
end


clear i;
clear res;
clear idx;
clear index;



%% scatter plot base index
fwd_base_comp = [];
for i = 1:48
    nrow = size(fwd_order{i},1);
    temp = [repmat(i,nrow,1),fwd_order{i}];
    fwd_base_comp = [fwd_base_comp; temp]; % concatenation
end
scatter(fwd_base_comp(:,1),fwd_base_comp(:,2));
title("basis index scatter plot")
xlabel("group")
ylabel("basis index")

clear nrow

%% Visualize signal
i = 0;
for max_weight = [5,10,25,50]
    for power = [5,10,25,50]
        for sparsity = [16,12,9]
            i = i+1;
            h = figure;
            plot(fwd_signal{i});
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


