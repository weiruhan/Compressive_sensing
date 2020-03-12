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

%% Visualize relation between WSSE & weight & sparsity
i = 0;
fwd_info = zeros(size(fwd_signal,1),4);
for max_weight = [5,10,25,50]
    for power = [5,10,25,50]
        for sparsity = [16,12,9]
            i = i+1;
            fwd_info(i,:) = [sparsity,power,max_weight,fwd_WSSE{i}];
        end
    end
end
% convert array to table
fwd_info = array2table(fwd_info,'variablenames',{'sparsity','power','max_weight','WSSE'});

for power = [5,10,25,50]
    for sparsity = [16,12,9]
        sub_fwd_info = fwd_info(fwd_info.power == power & fwd_info.sparsity == sparsity,:);
        h = figure;
        plot(sub_fwd_info.max_weight,sub_fwd_info.WSSE,'k');
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
        sub_fwd_info = fwd_info(fwd_info.power == power & fwd_info.sparsity == sparsity,:);
        h = subplot(4,3,i);
        position{i} = get(h,'position');
        plot(sub_fwd_info.max_weight,sub_fwd_info.WSSE,'k');
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

