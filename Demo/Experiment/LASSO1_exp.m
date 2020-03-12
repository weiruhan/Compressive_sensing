%% LASSO algorithm version 1 experiment
% Import data
IMPORT

%% preallocate
gamma = linspace(1,50,50); % assign shrinkage values
step = 100; % assign number of iteration
lasso1_co = zeros(size(basis,2),size(ideal,2),length(gamma));
lasso1_time = zeros(length(gamma),1);
% Select basis and reconstruct signal using least square error estimation
co1 = cell(length(gamma),1);
bas_number1 = zeros(size(basis,2),length(gamma)); % basis order
SSE1 = zeros(length(gamma),1); % least square error
signal1 = zeros(size(ideal,1),size(ideal,2),length(gamma));

for i = 1:length(gamma)
    %% calculate runtime
    tic
    lasso1_co(:,:,i) = lasso1(basis,ideal,i,step); % first step considering sparsity
    [row,~] = find(lasso1_co(:,:,i));
    bas_number1(1:length(unique(row)),i) = unique(row);
    basis1 = basis(:,unique(row));
    [co1{i},SSE1(i)] = lr(basis1,ideal); % second step considering least square error
    lasso1_time(i) = toc;
    %% reconstruct signal
    signal1(:,:,i) = basis1*co1{i};
end

%% plot gamma vs SSE 
plot(1:length(gamma),SSE1);
str = cellstr(num2str((sum(bas_number1~=0,1))'));
text(1:length(gamma),SSE1,str);
xlabel('shrinkage value');
ylabel('least square error');
title('SSE for lasso algorithm version1');

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

