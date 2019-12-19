%% WEIGHTED LASSO
% Penalty range: (1e-05) * (1 : 0.1 : 5.9)
% Iterate 100 times for each penalty value
% Power = max.weight = 10
bas_number = zeros(32,50);
penalty = 1e-05 * (1 : 0.1 : 5.9);
co_WLR = cell(50,1);
for i = 1:1:50
    co(:,:,i) = wt_lasso(basis,ideal,'nonlinear',10,10,penalty(i),100);
end

%% RECONSTRUCTION USING WLR
%  Power = max.weight = 10
for i = 1:1:50
    [row,~] = find(co(:,:,i));
    bas_number(1:length(unique(row)),i) = unique(row);
    WLR_basis = basis(:,unique(row));
    [co_WLR{i},WSSE_WLR(i)] = WLR(WLR_basis,ideal,'nonlinear',10,10);
    WLR_signal(:,:,i) = WLR_basis*co_WLR{i};
end

%% plot gamma vs WSSE in WLR
%  Power = max.weight = 10
plot(penalty,WSSE_WLR);
str = cellstr(num2str((sum(bas_number~=0,1))'));
text(penalty,WSSE_WLR,str);
xlabel('gamma');1:
ylabel('WSSE using WLR');
title("WSSE with Power = max.weight =10");

%% VISUALIZE signal reconstructed by WLR
%  Power = max.weight = 10
for i = 1:1:50
    h = figure;
    plot(WLR_signal(:,:,i));
    hold on
    plot(ideal);
    hold off
    saveas(h,sprintf('WLR%d.png',i));
end
%% Wt lasso and WLR
%  Power = max.weight =10
%  Penalty = 3.5e-05
%  sparsity = 12
wt_co_10_10_12 = wt_lasso(basis,ideal,'nonlinear',10,10,0.000035,100);
% [1 3 4 5 6 8 9 12 17 18 22 23]
[wt_bas_10_10_12,~] = find(wt_co_10_10_12);
[co_WLR_10_10_12,WSSE_10_10_12] = WLR(basis(:,wt_bas_10_10_12),ideal,'nonlinear',10,10);
plot(basis(:,wt_bas_10_10_12)*co_WLR_10_10_12);
title("weighted linear regression with sparsity 12")
hold on
plot(ideal);
hold off
%% Discrepancy plot
plot(basis(:,wt_bas_10_10_12)*co_WLR_10_10_12-ideal);
axis([0 1000 -0.4 0.4]);
title("2 steps weighted lasso discrepancy with sparsity 12");

