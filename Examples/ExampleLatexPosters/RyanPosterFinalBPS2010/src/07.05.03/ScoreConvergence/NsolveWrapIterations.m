function [statdist,statdistpermute,projectionsN,pnstate,score,histVec] = NsolveWrapIterations(N,M,cinf,C,Kp,Km,u,NAME,max_its,method_num,sim_num)



Kp = full(Kp); Km = full(Km); u = full(u);
u = u(:);
Io = diag(u);

for n = 1:1:N %N different automaton

    fid = fopen([NAME,num2str(n),'.mat'],'w');
    fprintf(fid,'#Num of matrices in file\n');
    fprintf(fid,'%3.0f\n', N^2-(N-1)^2 + 1);
    fprintf(fid,'#partition groups\n');
    fprintf(fid,'%3.0f\n', 1);
    fprintf(fid,'#Size: first element always 0, 2nd element num rows + 1\n');
    fprintf(fid,'%3.0f\n', 0);
    fprintf(fid,'%3.0f\n', M);


    MatrixID = 0;
    X = Km+cinf*Kp;
    fprintf(fid,'#Matrix ID:\n');
    fprintf(fid,'%3.0f\n', MatrixID);
    for ii =1:M
        fprintf(fid,['#Number of non-zero entries in row ',num2str(ii-1),':\n']);
        N_nonzero_ii = sum(X(ii,:)~=0);
        fprintf(fid,'%3.0f\n', N_nonzero_ii);
        for jj = find(X(ii,:) ~= 0)
            fprintf(fid,'#Col jj has entry X(ii,jj)\n');
            fprintf(fid,'%3.0f ',jj-1); %column entries run 0:N-1
            fprintf(fid,'%3.20f\n',X(ii,jj));
        end
    end


    %generate individual matrices for kron prod


    MatrixID = 1; %since we only have kron_prod
    for j = 1:N
        for i = 1:N

            if i==j
                if i==n
                    X = C(i,i)*Io*Kp; %Ad
                else
                    X = eye(M,M);
                end
            else
                if i==n
                    X = Io;
                elseif j==n
                    X = C(i,j)*Kp; %Astar
                else
                    X = eye(M,M);
                end
            end

            if sum(sum(X == eye(M,M))) ~= M^2

                fprintf(fid,'#Matrix ID:\n');
                fprintf(fid,'%3.0f\n', MatrixID);

                for ii =1:M
                    fprintf(fid,['#Number of non-zero entries in row ',num2str(ii-1),':\n']);
                    N_nonzero_ii = sum(X(ii,:)~=0);
                    fprintf(fid,'%3.0f\n', N_nonzero_ii);
                    for jj = find(X(ii,:) ~= 0)
                        fprintf(fid,'#Col jj has entry X(ii,jj)\n');
                        fprintf(fid,'%3.0f ',jj-1); %column entries run 0:N-1
                        fprintf(fid,'%3.20f\n',X(ii,jj));
                    end
                end

            end
            MatrixID = MatrixID + 1;

        end


    end
end

fclose(fid);

%make Name0.mat

fid = fopen([NAME '0.mat'],'w');
fprintf(fid,'# Number of matrices in file\n');
fprintf(fid,'%g\n', 1);
fprintf(fid,'# Number of parts\n');
fprintf(fid,'%g\n', 1);
fprintf(fid,'# Partition\n');
fprintf(fid,'%g\n', 0);
fprintf(fid,'%g\n', 1);
fprintf(fid,'#State transitions due to synchronized transitions\n');
fprintf(fid,'%g\n', N^2);

fprintf(fid,['# Reached state, identifier, rate of transition\n']);
for n = 1:N^2
    fprintf(fid,'%g',0);
    fprintf(fid,' %g',n);
    fprintf(fid,' %10e\n',1);
end

fclose(fid);

%make Name.comp

fid = fopen([NAME '.comp'],'w');
fprintf(fid,'#Number of components\n');
fprintf(fid,'%g\n',N);

fprintf(fid,'#correlation between component ID and component name:\n');
fprintf(fid,'#(<id> <name>)*\n');

fprintf(fid,'%g',0 );
fprintf(fid,' Highlevel_defaultnet\n');

for n = 1:N
    fprintf(fid,'%g',n);
    fprintf(fid,' ch%g\n',n);
end

fprintf(fid,'#Number of transitions: local + synchronized\n');
fprintf(fid,'%g\n',N^2);

fprintf(fid,'#correlation between transition ID and transition name for synchronized transitions:\n');
fprintf(fid,'#(<id> <name>)*\n');
for n = 1:N^2
    fprintf(fid,'%g',n);
    fprintf(fid,' t%g',n);
    fprintf(fid,' %g\n',0);
end

fclose(fid);


%make Name.conf
relax_param = 9.500e-01;HPQN=-2;
%eps1 = 1.0e-12;eps2 = 1.0e-04;eps3=eps2;comptime = 10.8e03
eps1 = 1.0e-12;eps2 = 500;eps3=eps2;comptime = 10.8e03;

fid = fopen([NAME '.conf'],'w');
fprintf(fid,'#Number of components\n');
fprintf(fid,'%g\n',N);

fprintf(fid,'# Method: 111=Str_Power, 112 = Str_JOR, 113 = Str_BSOR\n');
fprintf(fid,'%g\n',method_num);
fprintf(fid,'# Number of iterations\n');
fprintf(fid,'%g\n',max_its);
fprintf(fid,'# Epsilon 1\n');
fprintf(fid,'%3.3e\n',eps1);
fprintf(fid,'# Epsilon 2\n');
fprintf(fid,'%3.3e\n',eps2);
fprintf(fid,'# Epsilon 3\n');
fprintf(fid,'%3.3e\n',eps3);
fprintf(fid,'# CPU time limit\n');
fprintf(fid,'%3.3e\n',comptime);
fprintf(fid,'# Relaxation Parameter\n');
fprintf(fid,'%3.3e\n',relax_param);

fprintf(fid,'# Ausgabe Loesungsvektor\n');
fprintf(fid,'%g\n',1);

fprintf(fid,'# Ausgabe HQPN Lsg. Vektor\n');
fprintf(fid,'%g\n',0);


for n = 1:N
    fprintf(fid,['# Ausgabe LQPN',num2str(n),' Lsg. Vektor\n']);
    fprintf(fid,'%g\n',1);
end

fprintf(fid,'#Initialzustand HQPN oder -2 bei Gleichverteilung oder -1 zum Einlesen\n');
fprintf(fid,'%g\n',HPQN);

for n = 1:N
    fprintf(fid,['# Initialzustand LQPN',num2str(n),'\n']);
    fprintf(fid,'%g\n',0);
end

fclose(fid);

%make Name.spa

spa = zeros(1,M);
fid = fopen([NAME '.spa'],'w');
fprintf(fid,' %g',spa);
fclose(fid);

%call executable
%command = ['!./Nsolve ', NAME]
%command = ['!./IntelNsolve ', NAME]
%command = ['!./PowerPCNsolve ', NAME]
command = ['!rm -rf Results/N', num2str(sim_num)];
fprintf('%s\n', command);
eval(command);
command = ['!mkdir Results/N', num2str(sim_num)];
fprintf('%s\n', command);
eval(command);
command = ['!./IntelMlsolveDynamic ', NAME, ' > Results/N', num2str(sim_num),'/stdout.log'];
fprintf('%s\n', command);
eval(command);

% pi is an M^N row vector: stationary probaility dist.
poeq = load ([NAME '_overall.vec']);
statdist = poeq(2:M^N+1)';

% permuted pi
siz = [M*ones(1,N)];
x = 1:M^N;
string = [];
for i = 1:N-1
    string = [ string 'I' num2str(i) ', ' ];
end
string = ['[' string 'I' num2str(N) ']' ' = ind2sub(siz,x);'];
eval([string]);
string2 = [];
for j = N:-1:2
    string2 = [string2 'I' num2str(j) ','];
end
string3 = ['sub2ind(siz,' string2 'I' num2str(1) ');'];
indsperm =eval([string3]);
fprintf('** Permuting entries...\n');
tic;
for k = 1:M^N
    statdistpermute(k) = statdist(indsperm(k));
end
fprintf('** Permuting done (%g seconds)\n', toc);

% marginal projections  of stationary dist onto each automata
piN = [];
for i = 1:N
poeqvec = load ([NAME num2str(i) '.vec']);
projectionsN(i,:) = poeqvec(2:M+1)';
end

%hists for each state (in matrix that is M by N+1)
fprintf('** Computing histograms...\n');
tic;
hists = zeros(M,N+1);
for ii = 0:M^N-1 %loop over configuration
    v = dec2base(ii,M,N);
    for kk=1:N
       %S(kk) = str2num(v(kk))+1;
       S(kk) = hex2dec(v(kk))+1;
    end
       S = fliplr(S);
    for jj = 1:M           
        index = sum(S == jj);
        hists(jj,index+1) = hists(jj,index+1)  + statdist(ii+1);
        
    end
    
end
fprintf('** Computing done (%g seconds)\n', toc);
pnstate = hists;

for jj = 1:M
        histVec(jj,:) = max(pnstate(jj,:));
end

pnopen = u'*pnstate;
[score,nmean,nvar] = calc_score(0:N,pnopen);
score;

% load intermediate_status_IterationsCputimeUsertimeMaxresidualSumresidual.txt
% format long
% RawData = intermediate_status_IterationsCputimeUsertimeMaxresidualSumresi;
% 
% Iterations = RawData(end,1);
% TimeCPU = RawData(end,2);
% WallClock = RawData(end,3);
% Resids_Max = RawData(end,4);
% Resids_Sum = RawData(end,5);

%Day = date;
%save(['Nsolve',num2str(M),'N=',num2str(N),'Date',num2str(Day),'.mat'])
%save(['NsolveData.mat'])

return