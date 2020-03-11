% Weight matrix creation

function W = weight(Y,option,power,Max)
% Y is input signals;
% option is weight criteria;
% Max is the max weight value;

%% weight calculation
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
    end
end