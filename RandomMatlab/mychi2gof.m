% mychi2gof.m

% An example of using the chi-squared gooodness-of-fit test

% the columns are G and L (or two different experimental conditions)
T = randn(10000,1)
hist(T)
  
[h,p,stats] = chi2gof(T(:));

if h==0, 
    % does not reject null hypothesis
    display('Chi2gof: Does not reject normality')
else
    % does reject null hypothesis
    display('Chi2gof: Does reject normality')
end
p
stats
