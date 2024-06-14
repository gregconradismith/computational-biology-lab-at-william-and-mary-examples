% zonotope

clc
close all

A = [ 1 0 1 0 0 1; 0 1 1 0 0 1 ; 0 0 0 1 0 1 ; 0 0 0 0 1 1 ];
A = [ 1 -1 1 1 0; 0 1  0 1 0; 0 0  1 0 1 ];

[ r, n ] = size(A);

X = [ -1 1 ];
for i=2:n
    lenx = size(X,2);
    X = [ X X ; -ones(1,lenx) ones(1,lenx) ];
end

B = unique((A*X)','rows');
K = convhulln(B);

labelscale = 1.1;
for i=1:size(K,1)
    %W = [ x(i,:) ; y(i,:) ; z(i,:) ];
    if r==3 
    W = [ B(K(i,1),:); B(K(i,2),:); B(K(i,3),:) ];
    patch(W(:,1),W(:,2),W(:,3),[ 0 0.5 1 ])
    for j=1:1
    text(labelscale*B(K(i,j),1),labelscale*B(K(i,j),2),labelscale*B(K(i,j),3),num2str(B(K(i,1),:)),'Fontsize',12)
    text(-labelscale*B(K(i,j),1),-labelscale*B(K(i,j),2),-labelscale*B(K(i,j),3),num2str(-B(K(i,1),:)),'Fontsize',12)
    end 
    
    %disp([ x(i,:) ; y(i,:); z(i,:)])
    view(3)
    axis equal
    xlabel('dim1')
    ylabel('dim2')
    zlabel('dim3')
    drawnow
    end
    
end



