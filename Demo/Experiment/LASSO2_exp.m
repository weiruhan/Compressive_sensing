%% LASSO algorithm version 2 experiment
% Import data
IMPORT

%% preallocate
gamma = linspace(1,50,50); % assign shrinkage values
step = 100; % assign number of iteration
lasso2_co = zeros(size(basis,2),size(ideal,2),length(gamma));
lasso2_time = zeros(length(gamma),1);
% Select basis and reconstruct signal using least square error estimation
co2 = cell(length(gamma),1);
bas_number2 = zeros(size(basis,2),length(gamma)); % basis order
SSE2 = zeros(length(gamma),1); % least square error
signal2 = zeros(size(ideal,1),size(ideal,2),length(gamma));

for i = 1:length(gamma)
    %% calculate runtime
    tic
    lasso2_co(:,:,i) = lasso2(basis,ideal,i,step); % first step considering sparsity
    [row,~] = find(lasso2_co(:,:,i));
    bas_number2(1:length(unique(row)),i) = unique(row);
    basis2 = basis(:,unique(row));
    [co2{i},SSE2(i)] = lr(basis2,ideal); % second step considering least square error
    lasso2_time(i) = toc;
    %% reconstruct signal
    signal2(:,:,i) = basis2*co2{i};
end

%% plot gamma vs SSE
plot(1:length(gamma),SSE2);
str = cellstr(num2str((sum(bas_number2~=0,1))'));
text(1:length(gamma),SSE2,str);
xlabel('shrinkage value');
ylabel('least square error');
title('SSE for lasso algorithm version2');

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

