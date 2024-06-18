% G-test 

clc
format short

% T = contigency table (Observed values)
% rows are possible outcomes (set of features of data)
% for us this could be binned expression levels, that is, 
% the number of times RPKM falls into various ranges.
% Say low, medium, high.

% the columns are G and L (the two subgenomes, analogous to 
% there being two different experimental conditions)

T = [ 100  100 
      120  120 
      130  130 ]

% E is expected value of bins in each row under null hypothesis H0
% assuming condition (column) has no effect 
% allowing for different total number of observations in each column to be


% Here I calculate relative fraction over rows (for each row sum, G_i + L_i)
% where i is the row.  I take the sum over rows, divide by total number of observations
% (the sum of all cells), then redistribute the three rows to the G and L columsn
% according to this relative fraction (the "expected value" under H0)
% E_L(i) = L*(L_i+G_i)/(L+G) and E_G(i) = G*(L_i+G_i)/(L+G)

% E = expected values
E = sum(T,2)./sum(sum(T))*sum(T) % note: the * is an outer product

% This is the calculation of the G-statistic
G = 2*sum(T(:).*log(T(:)./E(:)))

% Number of degrees of freedom is the number of bins 
V = length(T(:))

% One possible comparison:
if G > V 
    disp('G-test: YES significant difference')
else
    disp('G-test: NO significant difference')
end

% P-value 
p = chi2cdf(G,V,'upper')

% Here is the analogous test using a two-way chi-squared test
Tsum = sum(T);

X2 = sum((sqrt(Tsum(1)/Tsum(2))*T(:,1)-sqrt(Tsum(2)/Tsum(1))*T(:,2)).^2./sum(T,2))

p = chi2cdf(X2,V,'upper')