function [X] =wt_lasso(D,Y,option,power,Max,gamma,iter)

% D is dictionary; 
% W is Multidimensional Arrays; 
% Y is input signals;
% iter is number of iterations;

X = zeros(size(D,2),size(Y,2));
p = zeros(size(Y,2),size(D,2));
[~,location] = max(Y);
for k = 1:1:size(Y,2)
    if strcmp(option,'nonlinear')
        L = find(Y(:,k),1,'first')-1; % lower location
        U = find(Y(:,k),1,'last') +1; % upper location
        T = location(k); % peak location
        W(:,:,k) = eye(size(Y,1));
        W(L+1:U-1,L+1:U-1,k) = diag((Max-1)*(((U-T)-abs(find(Y(:,k))-T))/(U-T)).^power+1);
    elseif strcmp(option,'exp')
        W(:,:,k) = diag(exp(power*Y(:,k)));
    else
        W(:,:,k) = diag(exp(Y(:,k)));
        W(location(k),location(k),k) = Max;
    end
    W(:,:,k) = W(:,:,k)/sum(W(:,:,k),'all');
end

for iteration = 1:1:iter
    for i = 1:1:size(Y,2)
        u(:,:,i) = D'* W(:,:,i)'* W(:,:,i)* D;
        for j = 1:1:size(D,2)
            temp = Y(:,i)'* W(:,:,i)'* W(:,:,i)* D;
            p(i,j) = temp(:,j) - 0.5 * X(:,i)'*(u(j,:,i)'+u(:,j,i)) + X(j,i) * u(j,j,i);
            if p(i,j) > gamma
                X(j,i) = (p(i,j) - gamma)/u(j,j,i);
            elseif p(i,j) < -1*gamma
                X(j,i) = (p(i,j) + gamma)/u(j,j,i);
            else
                X(j,i) = 0;
            end
        end
    end
end


return;
        