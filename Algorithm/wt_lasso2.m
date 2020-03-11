%% data dependent lasso version 2
function [X] =wt_lasso2(D,Y,W,gamma,iter)

% D is dictionary; 
% W is Multidimensional Arrays; 
% Y is input signals;
% iter is number of iterations;
m = size(D,2); % number of basis
n = size(Y,2); % number of ideal filters
X = zeros(m,n);
p = zeros(n,m);
u = zeros(m,m,n);
for i = 1:1:n
    u(:,:,i) = D'*W(:,:,i)*D;
end

for iteration = 1:1:iter
    for j = 1:1:m % iterate over the order of each basis
        for i = 1:1:n % iterate over the order of each ideal filter
            p(i,j) = Y(:,i)'*W(:,:,i)*D(:,j) - X(:,i)'*u(:,j,i) + X(j,i) * u(j,j,i);
        end
        %% update procedure
        if sum(p(:,j)) > 7 * gamma
            X(j,:) = (p(:,j)-gamma)'./reshape(u(j,j,:),[1,n]);
        elseif sum(p(:,j)) < -7 * gamma
            X(j,:) = (p(:,j) + gamma)'./reshape(u(j,j,:),[1,n]);
        else
            X(j,:) = 0;
        end
    end
end
        