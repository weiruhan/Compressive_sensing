function [X,order,Base,WSSE] =forward_WLR(dic,Y,option,power,Max,spar)

% dic is dictionary; 
% Y is input signals;
% option is weight criteria;
% power is power value in nonlinear 0function;
% Max is the max weight value;
% spar is the sparsity

X = zeros(size(dic,2),size(Y,2));
[~,location] = max(Y);
% Set up weight criteria
for k = 1:1:size(Y,2)
    if strcmp(option,'nonlinear')
        L = find(Y(:,k),1,'first')-1; % lower location
        U = find(Y(:,k),1,'last') +1; % upper location
        T = location(k); % peak location
        W(:,:,k) = eye(size(Y,1));
        W(L+1:U-1,L+1:U-1,k) = diag((Max-1)*(((U-T)-abs(find(Y(:,k))-T))/(U-T)).^power+1);
    elseif strcmp(option,'exp')
        W(:,:,k) = diag(exp(power*Y(:,k)));
    end
end
Base = []; % matrix record selected basis
order = zeros(spar,1);
% stepwise selecting basis 
for j = 1:1:spar
    WSSE = zeros(size(dic,2),1);
    for t = 1:1:size(dic,2) % 1:32
        D = [Base,dic(:,t)];
        for i = 1:1:size(Y,2) % 1:7
            X(1:j,i) = inv(D'*W(:,:,i)'*W(:,:,i)*D)*D'*W(:,:,i)'*W(:,:,i)*Y(:,i);
            WSSE(t) = WSSE(t) + norm(W(:,:,i)*(Y(:,i)-D*X(1:j,i)),2)^2/size(Y(:,i),1);
        end
    end
    [~,pos] = min(WSSE);
    Base = [Base,dic(:,pos)];
    order(j) = pos;
    dic(:,pos) = zeros(size(dic,1),1);    
end
for i = 1:1:size(Y,2)
    X(1:spar,i) = inv(Base'*W(:,:,i)'*W(:,:,i)*Base)*Base'*W(:,:,i)'*W(:,:,i)*Y(:,i);
    end
X = X(1:spar,:);
%% weighted sum of squares
WSSE = 0;
for k = 1:1:size(Y,2)
    WSSE = WSSE + norm(W(:,:,k)*(Y(:,k)-Base*X(:,k)),2)^2/size(Y(:,k),1);
end

return;


