%% IMPORT DATA

ideal=textread("sort_desired_r_c.txt");%ideal spectrum 7 ideal spectrums
basis=textread("sort_loaded_basis.txt");%32 basis each with 951*1
ideal = ideal(:,2:8);
basis = basis(:,2:33);

% PEAK LOCATION
[~,location] = max(ideal);% [157,223,267,325,395,493,595]

%% PART I
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

%% PART II
%% LASSO (WITHOUT WEIGHT)
%  penalty range: 1 : 1 : 50
for i = 1:1:50
    lasso_co(:,:,i) = LASSO(basis,ideal,i,100);
end

%% Apply MLR algorithm (identity weight in WLR)
ML_co = cell(50,1); % 50 groups
ML_bas_number = zeros(32,50); % basis order
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

%% PART IV

%% forward selection
%  sparsity = 16
%  Power = max = 50
[fo_50_50_16,order_50_50_16,Base_50_50_16] = forward_WLR(basis,ideal,'nonlinear',50,50,16);
%  basis order:[1,2,4,5,6,8,11,14,17,18,21,23,25,27,29,31]
fo_signal_50_50_16 = Base_50_50_16 * fo_50_50_16;
plot(fo_signal_50_50_16);
title('forward WLR with sparsity 16 M=50,P=50');
hold on
plot(ideal);
hold off
%% sparsity = 12
%  Power = max = 50
[fo_50_50_12,order_50_50_12,Base_50_50_12] = forward_WLR(basis,ideal,'nonlinear',50,50,12);
%  basis order:[1,2,4,5,8,11,14,17,21,23,27,29]
fo_signal_50_50_12 = Base_50_50_12 * fo_50_50_12;
plot(fo_signal_50_50_12);
title('forward WLR with sparsity 12 M=50,P=50');
hold on
plot(ideal);
hold off
%% sparsity = 9 
%  Power = max = 50
[fo_50_50_9,order_50_50_9,Base_50_50_9] = forward_WLR(basis,ideal,'nonlinear',50,50,9);
%  basis order:[1,2,5,8,11,14,17,21,29]
fo_signal_50_50_9 = Base_50_50_9 * fo_50_50_9;
plot(fo_signal_50_50_9);
title('forward WLR with sparsity 9 M=50,P=50');
hold on
plot(ideal);
hold off
%% sparsity = 16
%  Power = max = 10
[fo_10_10_16,order_10_10_16,Base_10_10_16] = forward_WLR(basis,ideal,'nonlinear',10,10,16);
%  basis order:[1,2,3,5,7,9,12,13,17,18,20,22,23,27,29,31]
fo_signal_10_10_16 = Base_10_10_16 * fo_10_10_16;
plot(fo_signal_10_10_16);
title('forward WLR with sparsity 16 M=10,P=10');
hold on
plot(ideal);
hold off
%% sparsity = 12
%  Power = max = 10
[fo_10_10_12,order_10_10_12,Base_10_10_12,WSSE_fo_10_10_12] = forward_WLR(basis,ideal,'nonlinear',10,10,12);
%  basis order:[1,2,3,5,7,9,12,13,18,20,22,29]
fo_signal_10_10_12 = Base_10_10_12 * fo_10_10_12;
plot(fo_signal_10_10_12);
axis([0 1000 -0.4 1]);
title('forward WLR with sparsity 12 M=10,P=10');
hold on
plot(ideal);
hold off

%% discrepancy plot
plot(fo_signal_10_10_12-ideal);
axis([0 1000 -0.4 0.4]);
title("discrepancy of forward WLR with sparsity 12");

%% sparsity = 9
%  Power = max = 10
[fo_10_10_9,order_10_10_9,Base_10_10_9] = forward_WLR(basis,ideal,'nonlinear',10,10,9);
%  basis order:[1,2,3,7,9,12,18,20,22]
fo_signal_10_10_9 = Base_10_10_9 * fo_10_10_9;
plot(fo_signal_10_10_9);
title('forward WLR with sparsity 9 M=10,P=10');
hold on
plot(ideal);
hold off
%% sparsity = 16
%  Power = 5; Max = 10
[fo_5_10_16,order_5_10_16,Base_5_10_16] = forward_WLR(basis,ideal,'nonlinear',5,10,16);
%  basis order:[1,2,3,5,7,10,12,15,18,19,21,22,23,27,30,31]
fo_signal_5_10_16 = Base_5_10_16 * fo_5_10_16;
plot(fo_signal_5_10_16);
title('forward WLR with sparsity 16 M=10,P=5');
hold on
plot(ideal);
hold off
%% sparsity = 12
%  Power = 5; Max = 10
[fo_5_10_12,order_5_10_12,Base_5_10_12] = forward_WLR(basis,ideal,'nonlinear',5,10,12);
%  basis order:[1,2,3,5,7,10,12,18,19,21,22,30]
fo_signal_5_10_12 = Base_5_10_12 * fo_5_10_12;
plot(fo_signal_5_10_12);
title('forward WLR with sparsity 12 M=10,P=5');
hold on
plot(ideal);
hold off
%% sparsity = 9
%  Power = 5; Max = 10
[fo_5_10_9,order_5_10_9,Base_5_10_9] = forward_WLR(basis,ideal,'nonlinear',5,10,9);
%  basis order:[1,2,5,7,10,12,19,21,30]
fo_signal_5_10_9 = Base_5_10_9 * fo_5_10_9;
plot(fo_signal_5_10_9);
title('forward WLR with sparsity 9 M=10,P=5');
hold on
plot(ideal);
hold off
%% sparsity = 16
%  Power = 10; Max = 5
[fo_10_5_16,order_10_5_16,Base_10_5_16] = forward_WLR(basis,ideal,'nonlinear',10,5,16);
%  basis order:[1,2,4,5,6,8,11,13,17,19,21,23,25,27,29,31]
fo_signal_10_5_16 = Base_10_5_16 * fo_10_5_16;
plot(fo_signal_10_5_16);
title('forward WLR with sparsity 16 M=5,P=10');
hold on
plot(ideal);
hold off
%% sparsity = 12
%  Power = 10; Max = 5
[fo_10_5_12,order_10_5_12,Base_10_5_12] = forward_WLR(basis,ideal,'nonlinear',10,5,12);
%  basis order:[1,2,4,6,8,11,13,17,19,21,23,29]
fo_signal_10_5_12 = Base_10_5_12 * fo_10_5_12;
plot(fo_signal_10_5_12);
title('forward WLR with sparsity 12 M=5,P=10');
hold on
plot(ideal);
hold off
%% sparsity = 9
%  Power = 10; Max = 5
[fo_10_5_9,order_10_5_9,Base_10_5_9] = forward_WLR(basis,ideal,'nonlinear',10,5,9);
%  basis order:[1,2,6,8,11,13,19,21,29]
fo_signal_10_5_9 = Base_10_5_9 * fo_10_5_9;
plot(fo_signal_10_5_9);
title('forward WLR with sparsity 9 M=5,P=10');
hold on
plot(ideal);
hold off
%% sparsity = 16
%  Power = max = 1 =>forward MLR
[fo_1_1_16,order_1_1_16,Base_1_1_16] = forward_WLR(basis,ideal,'nonlinear',1,1,16);
%  basis order:[1,2,3,5,6,8,10,12,14,17,19,21,23,27,29,32]
fo_signal_1_1_16 = Base_1_1_16 * fo_1_1_16;
plot(fo_signal_1_1_16);
title('forward MLR with sparsity 16');
hold on
plot(ideal);
hold off
%% sparsity = 12
%  Power = max = 1 =>forward MLR
[fo_1_1_12,order_1_1_12,Base_1_1_12,SSE_fo_1_1_12] = forward_WLR(basis,ideal,'nonlinear',1,1,12);
%  basis order:[1,3,5,8,10,12,14,17,19,21,23,29]
fo_signal_1_1_12 = Base_1_1_12 * fo_1_1_12;
plot(fo_signal_1_1_12);
axis([0 1000 -0.4 1]);
title('forward MLR with sparsity 12');
hold on
plot(ideal);
hold off

%%  Discrepancy plot
plot(fo_signal_1_1_12-ideal);
axis([0 1000 -0.4 0.4]);
title("discrepancy of forward MLR with sparsity 12");


%% sparsity = 9
%  Power = max = 1 =>forward MLR
[fo_1_1_9,order_1_1_9,Base_1_1_9] = forward_WLR(basis,ideal,'nonlinear',1,1,9);
%  basis order:[1,3,5,8,12,19,21,23,29]
fo_signal_1_1_9 = Base_1_1_9 * fo_1_1_9;
plot(fo_signal_1_1_9);
title('forward MLR with sparsity 9');
hold on
plot(ideal);
hold off


  



    




