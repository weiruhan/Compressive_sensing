% weighted least square error estimation

function [X,WSSE] =wlr(D,Y,W)
% D is dictionary; 
% Y is input signals;
% WSSE is the weighted sum of square error;

%% weighted least square estimation
X = zeros(size(D,2),size(Y,2));

for i = 1:1:size(Y,2)
    X(:,i) = inv(D'* W(:,:,i)*D)*D' * W(:,:,i)*Y(:,i);
end
WSSE = 0;
for k = 1:1:size(Y,2)
    WSSE = WSSE + (Y(:,k)-D*X(:,k))' * W(:,:,k) * (Y(:,k)-D*X(:,k))/size(Y(:,k),1);
end




