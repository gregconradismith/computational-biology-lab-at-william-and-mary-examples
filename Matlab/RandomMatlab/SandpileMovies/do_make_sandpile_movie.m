function do_make_sandpile_movie

set(0,'defaultaxesfontsize',15);
set(0,'defaulttextfontsize',15);
set(0,'defaultlinelinewidth',1);
set(0,'defaultlinemarkersize',6);

! rm *gif

HEX=1;
if HEX, MAX=6; else MAX=4; end

h1=figure(1); movegui(h1,'north');

n=501;
x=n;
y=n;
A=2*ones(x,y);
kfinal=1e6;
kdraw=ceil(logspace(0,6,500)); k=1;
for j=1:1e6
    xj=ceil(n/2);
    yj=ceil(n/2);
    A(xj,yj)=A(xj,yj)+1;
    while length(find(A>=MAX))
        for xi=2:n-1
            for yi=2:n-1
                if A(xi,yi) >= MAX
                    A(xi,yi)= A(xi,yi) - MAX;
                    A(xi+1,yi)=A(xi+1,yi) + 1; 
                    A(xi,yi+1)=A(xi,yi+1) + 1;
                    A(xi-1,yi)=A(xi-1,yi) + 1;
                    A(xi,yi-1)=A(xi,yi-1) + 1;
                    if HEX
                    A(xi+1,yi+1)=A(xi+1,yi+1) + 1;
                    A(xi-1,yi-1)=A(xi-1,yi-1) + 1;
                    end
                end
            end
        end
    end
    if rem(j,kdraw(k))==0
        imagesc(A)
        colormap(spring); % colorbar
        caxis([0 3])
        title(num2str(j))
        axis off
        axis square 
        drawnow
        write_gif(figure(1),'-1')
        k=k+1;
    end
end

return

function write_gif(fig,extstr)
basename = [ 'animate' ];
filename = [ basename extstr '.gif'];
frame = getframe(fig);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
if ~exist(filename,'file')
    imwrite(imind,cm,filename,'gif','Loopcount',inf,'DelayTime',0);
else
    imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0);
end

return


