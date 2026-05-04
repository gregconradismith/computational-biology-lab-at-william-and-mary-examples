clc;clear;

IterationsMat = [];
TimeCPUMat = [];
WallClockMat = [];
Resids_MaxMat = [];
Resids_SumMat = [];
scoreMat = [];

model = 3; %user can choose between a few models 1 = three state, 2 = FPD, 3 = six state
method_num = 222; %111 = Power Method; 112 = JOR;

if model == 1
    %threestate with sequential Ca binding
    M = 3;
    Nmax = 18;
    Radius_Mat = [0 0.1000 0.3728 0.5179 0.7197 1.0000 1.0000 1.0000 1.3895 1.9307 1.9307 1.9307 1.9307 2.6827 2.6827 2.6827 2.6827 2.6827 ];
elseif model == 2
    %FraimanPonceDawson Model
    M = 14;
    Nmax = 7;
    Radius_Mat = [0    0.5179    1.9307    2.6827    2.6827    3.7276    5.1795];
else
    % six state model with sequential Ca binding (from traditional 3 state)
    M = 6;
    Nmax = 11;
    Radius_Mat = [0    0.1000    0.2683    0.3728    0.5179    0.7197 0.7197 1.0000 1.0000 1.3895 1.3895];
end

max_its = 500000;
jj = 1; jj_max = 6;

while jj < jj_max

    for N = 4:8

        R = Radius_Mat(N);


        [Iterations,TimeCPU,WallClock,Resids_Max,Resids_Sum] = do_KronNsolveReduced(model,N,R,max_its,method_num)
        
        IterationsMat(jj,N) = Iterations;
        TimeCPUMat(jj,N) = TimeCPU;
        WallClockMat(jj,N) = WallClock;
        Resids_MaxMat(jj,N) = Resids_Max;
        Resids_SumMat(jj,N) = Resids_Sum;


    end
    jj = jj + 1;


end
Day = date;
save(['MethodNum=',num2str(method_num),'RangeIterationsDataM=',num2str(M),'Date',num2str(Day),'.mat']);






