%
% KRON_SELF
%
% Produce a self-similar image using the Kronecker matrix product.
%

clc; clear; close all;

n=4;

% uncomment one of the following lines
X = [ 0 1 0 ; 1 1 1 ; 0 1 0 ];
% X = [ 0 1 0 ; 0 1 1 ; 1 1 1 ];
% X = [ 0 0 0 0 0 0 0 ; 0 0 1 1 1 0 0 ; 0 1 0 0 0 1 0 ; 0 1 0 0 0 0 0 ; 0 1 0 1 1 1 0 ; 0 1 0 0 0 1 0 ; 0 1 0 0 0 1 0 ; 0 0 1 1 1 0 0 ; 0 0 0 0 0 0 0 ];


X = sparse(X);
I = sparse(eye(size(X)));

figure(1)
imagesc(X)
colormap(flipud(colormap(bone)))
title(['level 1, size ' num2str(size(X)) ', nnz ' num2str(nnz(X)) ])
axis off
axis equal

max_nnz = 1e6;
for k=2:n
    if nnz(X)^2>max_nnz
        warning(['Stopping at level ' num2str(k-1) ' because ' num2str(nnz(X)^2) ' nnz(X)^2 > max_numel = ' num2str(max_nnz) '.'])
        break
    end
    X = kron(X,X);
    figure
    imagesc(X)
    colormap(flipud(colormap(bone)))
    axis off
    axis equal
    title(['level ' num2str(k) ', size ' num2str(size(X)) ', nnz ' num2str(nnz(X))  ])
end

return
