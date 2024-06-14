function permuton2
close all
n=8;
Perm = perm132(n);

P = zeros(n);
for k=1:length(Perm)
    a = 0:n:n*(n-1); 
    a=a+Perm(k,:);
    P(a)=P(a)+1;
end
P=P/sum(P,'all');
figure
imagesc(P)
colorbar
colormap jet
caxis([0 Inf])

end

function result = perm132(n)
% Generates all permutations of n elements avoiding the pattern 132.

% Define a helper function to check if a permutation contains the pattern 132.
    function res = has132(p)
        for i = 1:length(p)-2
            if p(i) < p(i+2) && p(i+2) < p(i+1)
                res = true;
                return;
            end
        end
        res = false;
    end

% Define the recursive function to generate all permutations avoiding 132.
    function generate(current, remaining)
        if isempty(remaining)
            result(end+1,:) = current;
        else
            for i = 1:length(remaining)
                if ~has132([current remaining(i)])
                    generate([current remaining(i)], remaining([1:i-1 i+1:end]))
                end
            end
        end
    end

% Initialize the result matrix and start the recursion.
    result = [];
    generate([], 1:n)
end




% 
% if 1
%     kmax = 1e4;
%     Perms = perms(1:n);
%     W0 = zeros(n);
%     Ulist = [];
%     for k=1:kmax
%         [perm,P,U] = copula_perm(rho,n,0);
%         [~, a]=ismember(perm,Perms,'rows');
%         Z(k)=a;
%         W0=W0+P;
%         Ulist = [ Ulist; U ];
%     end
%     figure
%     histogram(Z,'BinMethod','integers')
%     W=W0/kmax
%     figure
%     imagesc(W)
%     colormap jet
%     colorbar
%     figure
%     plot(Ulist(:,1),Ulist(:,2),'o')
% end
% edges = 0:1/n:1
% histogram2(Ulist(:,1),Ulist(:,2),edges,edges,'DisplayStyle','tile')
% colormap jet
% colorbar
% shading flat
% return
% 
% function [ perm, P, U ] = copula_perm(rho,n,fig)
% U = copularnd('Gaussian',[1 rho; rho 1],n); 
% %U = copularnd('t',[1 rho; rho 1],4,n); 
% X = sortrows(U,'ascend');
% [~,ay] = sort(X(:,2),'descend');
% [~,aw] = sort(ay,'ascend');
% perm=aw';
% P = zeros(n);
% a = 0:n:n*(n-1); a=a+perm;
% P(a)=1;
% if fig
%     plot(U(:,1),U(:,2),'*','MarkerSize',20)
%     axis([0 1 0 1])
%     title(num2str(perm))
%     axis square
% end
% end