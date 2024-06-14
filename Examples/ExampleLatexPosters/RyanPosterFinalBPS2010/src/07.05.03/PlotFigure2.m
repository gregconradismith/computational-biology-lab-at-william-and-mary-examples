function [W, S, H, RS, RM] = PlotFigure2(Np, ptype, filename, verbose)

method = 1;

if nargin < 3
    filename = 'figure2.mat';
    if nargin < 2
        ptype = 'loglog';
        if nargin < 1
            Np = 50;
        end
    end
end

load(['Output/Results/', filename]);
NSsimu = simu;

score = NSsimu{method}.scoreMat(end);
maxhist = NSsimu{method}.histMat(3, end);
NSdat = load('Output/Results/extracted.txt');
NSsimu{1}.WallClockMat = NSdat(:, 3)';
NSsimu{1}.Resids_SumMat = NSdat(:, 5)';
NSsimu{1}.Resids_MaxMat = NSdat(:, 4)';

load(['/Users/mdlama/Work/Papers/CMSB/CMSB_Drafts/07.04.10/MarkovSANForNSolveProject/', filename]);

wallclock_list = [];
score_list = [];

Nsimu = length(simu);

for j=1:Nsimu
    wallclock_list = [wallclock_list; cumsum(simu{j}.wtime')];
    score_list = [score_list; simu{j}.score'];
end
score_list = abs(score_list - score)/score;

% Plot histogram data
N = size(simu{j}.nhist, 1);
hist_max = zeros(Nsimu, N);
for j=1:Nsimu
    for i=1:N
        hist_max(j, i) = max(simu{j}.nhist(i, 3, :));
    end
end
hist_max = abs(hist_max - maxhist)/maxhist;

msize = 10;
fsize = 24;

figure(1);
set(gcf,'color','white');
[W, S] = ebarplot(wallclock_list, score_list, Np, ptype, 'k-^', 'MarkerFaceColor', [1 1 1], 'MarkerSize', msize);
hold on;
[W, H] = ebarplot(wallclock_list, hist_max, Np, ptype, 'k-v', 'MarkerFaceColor', [1 1 1], 'MarkerSize', msize);
hold on;

% Xmin = 1;
% Xmax = 1000;
% Ymin = 1e-5;
% Ymax = 1;
% axis([Xmin Xmax Ymin Ymax]);
% axis off;
% title('Coarse measures', 'fontsize', fsize);
% Xtick = [1 1e1 1e2 1e3];
% Ytick = [1e-5 1e-4 1e-3 1e-2 1e-1 1];
% a = get(gca,'position');
% xs = get(gca,'xscale');
% ys = get(gca,'yscale');
% set(gca,'position',a);
% h = axes('position',[a(1) a(2)-0.02 a(3) 0.000001]);
% set(gca,'TickDir','out','box','off','fontsize', fsize, 'xscale',xs,'ticklength',[0.01 0],'xlim',[Xmin Xmax],'XTick',Xtick,'XMinorTick','off');
% xlabel('Wall Clock Time (seconds)');
% h = axes('position',[a(1)-0.02 a(2) 0.000001 a(4)]);
% set(gca,'TickDir','out','box','off','fontsize', fsize,'yscale',ys,'ticklength',[0.01 0],'ylim',[Ymin Ymax],'YTick',Ytick);
% ylabel('Relative error in score and closed probability');

% Plot residual information
res_sum = [];
res_max = [];
for j=1:Nsimu
    res_sum = [res_sum; simu{j}.res(:, 1)'];
    res_max = [res_max; simu{j}.res(:, 2)'];
end

%figure(2);
set(gcf,'color','white');
[W, RS] = ebarplot(wallclock_list, res_sum, Np, ptype, 'k-o', 'MarkerFaceColor', [1 1 1], 'MarkerSize', msize);
hold on;

% Fit line
[tmp, ind] = min(abs(W(:,1)-1));
m = log10(RS(end,1)/RS(ind+1,1))/log10(W(end,1)/W(ind+1,1));
fprintf('RS m = %g\n', m);
x0 = W(ind+1,1);
y0 = RS(ind+1,1);
x = logspace(log10(W(ind+1,1)), log10(W(end, 1)), 1000);
y = y0*(x/x0).^m;
%loglog(x, y, 'r');
fprintf('RS convergence time = %g\n', 10^((-9 - log10(y0) + m*log10(x0))/m));

[W, RM] = ebarplot(wallclock_list, res_max, Np, ptype, 'k-s', 'MarkerFaceColor', [1 1 1], 'MarkerSize', msize);
hold on;

% Fit line
[tmp, ind] = min(abs(W(:,1)-1));
m = log10(RM(end,1)/RM(ind+1,1))/log10(W(end,1)/W(ind+1,1));
fprintf('RM m = %g\n', m);
x0 = W(ind+1,1);
y0 = RM(ind+1,1);
x = logspace(log10(W(ind+1,1)), log10(W(end, 1)), 1000);
y = y0*(x/x0).^m;
%loglog(x, y, 'r');
fprintf('RM convergence time = %g\n', 10^((-12 - log10(y0) + m*log10(x0))/m));

NSsimu{method}.WallClockMat(find(NSsimu{method}.WallClockMat == 0)) = 1;
[tmp, ind] = sample(NSsimu{method}.WallClockMat, Np, 'log');
[tmp, ind2] = sort(NSsimu{method}.WallClockMat(ind));
ind = ind(ind2);
loglog(NSsimu{method}.WallClockMat(ind), NSsimu{method}.Resids_SumMat(ind), 'k-o', 'MarkerFaceColor', [0 0 0], 'MarkerSize', msize);
loglog(NSsimu{method}.WallClockMat(ind), NSsimu{method}.Resids_MaxMat(ind), 'k-s', 'MarkerFaceColor', [0 0 0], 'MarkerSize', msize);

Xmin = 1;
Xmax = 1000;
Ymin = 1e-14;
Ymax = 1e2;
axis([Xmin Xmax Ymin Ymax]);
axis off;
%title('Fine measures', 'fontsize', fsize);
Xtick = [1 1e1 1e2 1e3];
%Ytick = [1e-14 1e-12 1e-10 1e-8 1e-6 1e-4 1e-2 1 1e2];
Ytick = [1e-14 1e-10 1e-6 1e-2 1e2];
a = get(gca,'position');
xs = get(gca,'xscale');
ys = get(gca,'yscale');
set(gca,'position',a);
h = axes('position',[a(1) a(2)-0.02 a(3) 0.000001]);
set(gca,'TickDir','out','box','off','fontsize', fsize, 'xscale',xs,'ticklength',[0.01 0],'xlim',[Xmin Xmax],'XTick',Xtick,'XMinorTick','off');
%xlabel('Wall Clock Time (seconds)');
h = axes('position',[a(1)-0.02 a(2) 0.000001 a(4)]);
set(gca,'TickDir','out','box','off','fontsize', fsize,'yscale',ys,'ticklength',[0.01 0],'ylim',[Ymin Ymax],'YTick',Ytick);
%ylabel('Error');

saveas(1,'Figure2_mat.eps','epsc')

%!pstopdf Figure2.eps
%!open Figure2.pdf

return