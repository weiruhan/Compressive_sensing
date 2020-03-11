% least square error estimation

function [X,SSE] =lr(D,Y)
% D is dictionary; 
% Y is input signals;
% WSSE is the weighted sum of square error;

%% weighted least square estimation
X = zeros(size(D,2),size(Y,2));

for i = 1:1:size(Y,2)
    X(:,i) = inv(D' * D) * D' * Y(:,i);
end
SSE = 0;
for k = 1:1:size(Y,2)
    SSE = SSE + (Y(:,k)-D*X(:,k))' * (Y(:,k)-D*X(:,k))/size(Y(:,k),1);
end