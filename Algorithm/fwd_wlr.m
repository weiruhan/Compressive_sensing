% forward selection algorithm

function [X,order,Base,WSSE] =fwd_wlr(dic,Y,W,spar)

% dic is dictionary; 
% Y is input signals;
% option is weight criteria;
% power is power value in nonlinear function;
% Max is the max weight value;
% spar is the sparsity

X = zeros(size(dic,2),size(Y,2));

Base = []; % matrix record selected basis
order = zeros(spar,1);
% stepwise selecting basis 
for j = 1:1:spar
    WSSE = zeros(size(dic,2),1);
    for t = 1:1:size(dic,2) % 1:32
        D = [Base,dic(:,t)];
        for i = 1:1:size(Y,2) % 1:7
            X(1:j,i) = inv(D'*W(:,:,i)*D)*D'*W(:,:,i)*Y(:,i);
            WSSE(t) = WSSE(t) + (Y(:,i)-D*X(1:j,i))' * W(:,:,i)*(Y(:,i)-D*X(1:j,i))/size(Y(:,i),1);
        end
    end
    [~,pos] = min(WSSE);
    Base = [Base,dic(:,pos)];
    order(j) = pos;
    dic(:,pos) = zeros(size(dic,1),1);    
end
for i = 1:1:size(Y,2)
    X(1:spar,i) = inv(Base'*W(:,:,i)*Base)*Base'*W(:,:,i)*Y(:,i);
    end
X = X(1:spar,:);

%% weighted sum of square errors
WSSE = 0;
for k = 1:1:size(Y,2)
    WSSE = WSSE + (Y(:,k)-Base*X(:,k))' * W(:,:,k)*(Y(:,k)-Base*X(:,k))/size(Y(:,k),1);
end

