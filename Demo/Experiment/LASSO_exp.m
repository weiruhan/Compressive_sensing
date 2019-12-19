%% LASSO
%  penalty value: 1 : 1 : 50
lasso_co = zeros(32,7,50);
for i = 1:1:50
    lasso_co(:,:,i) = LASSO(basis,ideal,i,100);
end

%% MLR
ML_co = cell(50,1); % 50 groups
ML_bas_number = zeros(32,50); % basis order
ML_SSE = zeros(1,50);
MLR_signal = zeros(951,7,50);
for i = 1:1:50 
    [row,~] = find(lasso_co(:,:,i));
    ML_bas_number(1:length(unique(row)),i) = unique(row);
    ML_basis = basis(:,unique(row));
    [ML_co{i},ML_SSE(i)] = WLR(ML_basis,ideal,'nonlinear',1,1);
    MLR_signal(:,:,i) = ML_basis*ML_co{i};
end

%% plot gamma vs SSE in MLR
plot(1:1:50,ML_SSE);
str = cellstr(num2str((sum(ML_bas_number~=0,1))'));
text(1:1:50,ML_SSE,str);
xlabel('gamma');
ylabel('least square error');
title('SSE');

%% Visualize signal reconstructed by MLR (Identity weight in WLR)
for i = 1:1:50
    h = figure;
    plot(MLR_signal(:,:,i));
    hold on
    plot(ideal);
    hold off
    saveas(h,sprintf('MLR%d.png',i));
end

%% PART III

%% LASSO
%  penalty = 11.12
%  16 basis
co_11_12 = LASSO(basis,ideal,11.12,100);
%  [1,3,4,5,6,8,9,12,13,16,17,18,20,23,24,25]
plot(basis*co_11_12);
title("lasso with sparsity 16");
hold on
plot(ideal);
hold off
%% 2-steps Lasso
%  penalty = 12.8
%  12 basis 
co_12_8 = LASSO(basis,ideal,12.8,100);
%  [1 3 4 5 6 8 9 12 17 18 20 23]
[ML_bas_12_8,~]=find(co_12_8);
[ML_co_12_8,SSE_12_8] =WLR(basis(:,ML_bas_12_8),ideal,'nonlinear',1,1);
plot(basis(:,ML_bas_12_8)*ML_co_12_8);
axis([0 1000 -0.4 1]);
title("Multiple linear regression with sparsity 12")
hold on
plot(ideal);
hold off

%% discrepancy plot
plot(basis(:,ML_bas_12_8)*ML_co_12_8-ideal);
axis([0 1000 -0.4 0.4]);
title("discrepancy of 2 step lasso with sparsity 12");
