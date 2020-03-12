%% weighted LASSO algorithm version 2 experiment
% Import data
IMPORT

%% preallocate
% Here we set max_weight and power = 10
W = weight(ideal,'nonlinear',10,10); 
for i = 1:size(W,3)
    W(:,:,i) = W(:,:,i)/sum(W(:,:,i),'all'); % normalize weight matrix
end
gamma = linspace(0.01,0.059,50); % assign shrinkage values
step = 100; % assign number of iteration
wtlasso2_co = zeros(size(basis,2),size(ideal,2),length(gamma));
wtlasso2_time = zeros(length(gamma),1);
% Select basis and reconstruct signal using weighted least square error estimation
co2 = cell(length(gamma),1);
bas_number2 = zeros(size(basis,2),length(gamma)); % basis order
WSSE2 = zeros(length(gamma),1); % least square error
signal2 = zeros(size(ideal,1),size(ideal,2),length(gamma));

for i = 1:length(gamma)
    %% calculate runtime
    tic
    wtlasso2_co(:,:,i) = wt_lasso2(basis,ideal,W,gamma(i),step); % first step considering sparsity
    [row,~] = find(wtlasso2_co(:,:,i));
    bas_number2(1:length(unique(row)),i) = unique(row);
    basis2 = basis(:,unique(row));
    [co2{i},WSSE2(i)] = wlr(basis2,ideal,W); % second step considering least square error
    wtlasso2_time(i) = toc;
    %% reconstruct signal
    signal2(:,:,i) = basis2*co2{i};
end

%% plot gamma vs SSE 
plot(gamma,WSSE2);
str = cellstr(num2str((sum(bas_number2~=0,1))'));
text(gamma,WSSE2,str);
xlabel('shrinkage value');
ylabel('weighted least square error');
title('WSSE for weighted lasso algorithm version2');

%% Visualize signal
for i = 1:length(gamma)
    h = figure;
    plot(signal2(:,:,i));
    hold on
    plot(ideal);
    txt = sprintf('%d %s',sum(logical(bas_number2(:,i))),'sparse');
    title(txt);
    hold off
    saveas(h,sprintf('%d%s_%d%s.png',i,'train',sum(logical(bas_number2(:,i))),'sparse'));
    close(h);
end
clear txt

