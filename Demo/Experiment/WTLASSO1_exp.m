%% weighted LASSO algorithm version 1 experiment
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
wtlasso1_co = zeros(size(basis,2),size(ideal,2),length(gamma));
wtlasso1_time = zeros(length(gamma),1);
% Select basis and reconstruct signal using weighted least square error estimation
co1 = cell(length(gamma),1);
bas_number1 = zeros(size(basis,2),length(gamma)); % basis order
WSSE1 = zeros(length(gamma),1); % least square error
signal1 = zeros(size(ideal,1),size(ideal,2),length(gamma));

for i = 1:length(gamma)
    %% calculate runtime
    tic
    wtlasso1_co(:,:,i) = wt_lasso1(basis,ideal,W,gamma(i),step); % first step considering sparsity
    [row,~] = find(wtlasso1_co(:,:,i));
    bas_number1(1:length(unique(row)),i) = unique(row);
    basis1 = basis(:,unique(row));
    [co1{i},WSSE1(i)] = wlr(basis1,ideal,W); % second step considering least square error
    wtlasso1_time(i) = toc;
    %% reconstruct signal
    signal1(:,:,i) = basis1*co1{i};
end

%% plot gamma vs SSE 
plot(gamma,WSSE1);
str = cellstr(num2str((sum(bas_number1~=0,1))'));
text(gamma,WSSE1,str);
xlabel('shrinkage value');
ylabel('weighted least square error');
title('WSSE for weighted lasso algorithm version1');

%% Visualize signal
for i = 1:length(gamma)
    h = figure;
    plot(signal1(:,:,i));
    hold on
    plot(ideal);
    txt = sprintf('%d %s',sum(logical(bas_number1(:,i))),'sparse');
    title(txt);
    hold off
    saveas(h,sprintf('%d%s_%d%s.png',i,'train',sum(logical(bas_number1(:,i))),'sparse'));
    close(h);
end
clear txt

