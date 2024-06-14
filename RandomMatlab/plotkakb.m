
syms k ka kb real positive

A = 0.5*[ 0 0 0 -1 -1 0; 0 0 0 ka ka 0; 0 0 0 0 ka 0; -1 ka 0 0 0 -1; -1 ka ka 0 0 0; 0 0 0 -1 0 0 ]
rank(A)
Arref = rref(A)

B = 0.5*[ 0 0 -1 kb kb 0; 0 0 0 0 0 -1; -1 0 0 0 0 -1; kb 0 0 0 0 kb; kb 0 0 0 0 0; 0 -1 -1 kb 0 0 ]
rank(B)
Brref = rref(B)

syms a abar b bbar c cbar real

x = [ a abar b bbar c cbar ]'

xAx = collect(x'*A*x,[ka a b c abar bbar cbar])

[VA,DA] = eig(A)

if 0 

AA = double(subs(A,ka,5))
[VV,DD] = eigs(AA)
norm(VV*DD*VV'-AA)
end


[VB,DB]=eig(B)


%xBx = collect(x'*B*x,[kb a b c abar bbar cbar])


%%%%%

A = 0.5*[ 0 0 -(ka^2+2) -(ka^2+1); 0 0 -1/ka ka; -(ka^2+2) -1/ka 0 0; -(ka^2+1) ka 0 0 ]
rank(A)
Arref = rref(A)


x = [ a b bbar c ]'

xAx = collect(x'*A*x,[ka a b c bbar])

[VA,DA] = eig(A)


[V,D]=eig(subs(A,ka,1))

if 0
    ka=1;
    kb=2;
    abar=1;
    bbar=1;
    cbar=1;
    
    tol=0.02;
    
    x=logspace(-3,3,500);
    x=linspace(0,50,500);
    
    [a,b,c]=ndgrid(x);
    
    f=ka*(b.*c+abar*c+abar*bbar)-(bbar*cbar+a.*c+a*bbar);
    g=kb*(bbar*cbar+a.*c+a*bbar)-(b*cbar+abar*cbar+a.*b);
    
    aa=find(abs(f)+abs(g)<tol);
    
    %plot3(log10(a(aa)),log10(b(aa)),log10(c(aa)),'o')
    plot3(a(aa),b(aa),c(aa),'o')
    
end

% Combined A and B 

C = 0.5*[ 0 0 -1 0 0 0; 0 0 0 k k -1; -1 0 0 0 k -1; 0 k 0 0 0 0; 0 k k 0 0 0; 0 -1 -1 0 0 0 ]
rank(C)
Crref = rref(C)
x = [ a abar b bbar c cbar ]'

xCx = collect(x'*C*x,[ka a b c abar bbar cbar])

[VC,DC] = eig(C)


if 1
    clear
    close all
    lambda=0.5;
    
    tol=0.01;
    
 
    x=linspace(-2,2,100);
    
    [x,y,z]=ndgrid(x);
    
    w=1;
    
    f=lambda*(x.^2-y.^2)-(z.^2-w.^2); 
   
    aa=find(abs(f)<tol);
    

    plot3(x(aa),y(aa),z(aa),'o')
 
    
    
end
