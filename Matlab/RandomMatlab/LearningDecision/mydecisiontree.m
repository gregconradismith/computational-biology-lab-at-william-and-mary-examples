% mydecisiontree.m

clc; close all; clear;

set(0,'defaultAxesFontSize',16)
% system('rm -rf Figures/*');

% X = an N-by-P matrix of predictors with one row per observation and one
% column per predictor. Y is the response and is an array of N class
% labels.

Y = [ 0 1 2 3 4 5 6 7 ]';
X = [ 0 0 0 ; 0 0 1 ; 0 1 0 ; 0 1 1 ; ...
    1 0 0 ; 1 0 1 ; 1 1 0 ; 1 1 1 ;];
for k=1:4
Y = [ Y; Y];
X = [ X; X];
end
[ X Y ]
tree = fitctree(X,Y);
view(tree)
view(tree,'mode','graph')
cvmodel = crossval(tree,'CrossVal','on');
L = kfoldLoss(cvmodel)

return
