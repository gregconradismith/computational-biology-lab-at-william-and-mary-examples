function [score,nmean,nvar] = calc_score(nopen,poeq)
% calculates the score from popen and U (number of open channels in each
% state) or from pnopen and nopen

N = max(nopen);

nmean = sum(nopen.*poeq);
nvar = sum((nopen-nmean).^2.*poeq);

score = nvar/nmean/N;

return