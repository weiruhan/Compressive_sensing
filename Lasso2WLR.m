% Reconstruct signal by WLR from selected basis in lasso 
co_L2W = cell(50,1);
for i = 1:1:50 
    [row,~] = find(lasso_co(:,:,i));
    ML_bas_number(1:length(unique(row)),i) = unique(row);
    ML_basis = basis(:,unique(row)+1);
    [co_L2W{i},SSE_L2W(i),WSSE_L2W(i)] = WLR(ML_basis,ideal(:,2:8),'nonlinear',10,10);
    L2W_signal(:,:,i) = ML_basis*co_L2W{i};
end

for i = 1:1:50
    h = figure;
    plot(L2W_signal(:,:,i));
    hold on
    plot(ideal(:,2:8));
    hold off
    saveas(h,sprintf('L2W%d.png',i));
end
% plot SSE and WSSE
stem(1:50,SSE_L2W);
xlabel('signal order');
ylabel('least square error');


% take 16 subsets
[~,location] = max(ideal(:,2:8));
basis_16 = basis(:,[1 3 4 5 6 8 9 12 16 17 18 20 23 24 25 30]+1);
co_16 = WLR(basis_16,ideal(:,2:8),'nonlinear',1000,10000);
[~,location_new] = max(basis_16*co_16);
res = basis_16*co_16 - ideal(:,2:8);
for i = 1:size(ideal(:,2:8),2)
    subplot(4,2,i);
    plot(res(:,i));
    line([location_new(i),location_new(i)],[-0.2 res(location_new(i),i)],'LineStyle',':','Color','r');
    text(location_new(i),-0.1,'\leftarrow peak location');
    line([location(i),location(i)],[-0.2 res(location(i),i)],'LineStyle','-','Color','g');
    text(location(i),0,'\leftarrow target location');
    xlabel('frequency');
    ylabel('discrepancy');
    title('discrepancy plot with weight from 1 to 10000');
end
subplot(4,2,8);
plot(basis_16*co_16);
hold on
plot(ideal(:,2:8));
xlabel('frequency');
title('reconstruction vs ideal');
hold off

for i = 1:size(ideal(:,2:8),2)
    stem(location(i),res(location(i),i));
    xlabel('target location');
    ylabel('discrepancy');
    title('discrepancy in target location');
    hold on
end
hold off



