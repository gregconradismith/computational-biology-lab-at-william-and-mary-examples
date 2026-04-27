% association scheme 

R = [ 0 1 2 3 2 1 ; 1 0 1 2 3 2 ; 2 1 0 1 2 3 ; 3 2 1 0 1 2 ; 2 3 2 1 0 1 ; 1 2 3 2 1 0 ]

d = max(R(:));
A = cell(d,1);
AA = cell(d,d); B = cell(d,1);
for i=1:d
   A{i}=(R==i);
end

for i=1:d
    for j=1:d

AA{i,j}=A{i}*A{j};
disp([i j])
disp(AA{i,j})
disp(' ')
    end
end

 