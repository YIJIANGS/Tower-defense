function addTurret(~,~)
global tpos turret map_info t_valid tnum fpos f_hit
set(gcf,'WindowButtonDownFcn',@mouseClick)
set(gcf,'WindowButtonMotionFcn',@mouseMove)
tpos=evalin('base','tpos');
turret=evalin('base','turret');
map_info=evalin('base','map_info');
tnum=evalin('base','tnum');
fpos=evalin('base','fpos');
f_hit=evalin('base','f_hit');
t_valid=0;

function mouseClick(~,~)
global turret t_valid tpos tnum fpos f_hit
if t_valid==1
    C = get (gca, 'CurrentPoint');
    m=floor(C(1,1)/100)*100;
    n=floor(C(1,2)/100)*100;
%     im=imresize(turret,[100 100]);
%     g=rgb2gray(im);
%     alpha=(g<250 & g~=0);
%     t_fig2=imagesc(m,n,im);
%     set(t_fig2,'alphaData',alpha)
    tnum=tnum+1;
    tpos(tnum,:)=[m n];
    fpos(tnum,:)=[m n];
    f_hit(tnum)=1;
    assignin('base','tnum',tnum)
    assignin('base','tpos',tpos)
    assignin('base','fpos',fpos)
    assignin('base','f_hit',f_hit)
    assignin('base','t_fig2',t_fig2)
end


function mouseMove(~,~)
global turret map_info t_valid
try
fig_newt=evalin('base','fig_newt');
catch
fig_newt=[];
end
delete(fig_newt)
C = get (gca, 'CurrentPoint');
m=floor(C(1,1)/100)*100;
n=floor(C(1,2)/100)*100;
if m>=0 && m<=900 && n>=0 && n<=900
    im=imresize(turret,[100 100]);
    g=rgb2gray(im);
    alpha=(g<250 & g~=0);
    if mean(mean(map_info(n+1:n+100,m+1:m+100)))>.5
        t_valid=0;
        im(:,:,1)=255;
        fig_newt=imagesc(m,n,im);
        set(fig_newt,'alphaData',alpha)
        assignin('base','fig_newt',fig_newt)
    else
        t_valid=1;
        im(:,:,2)=255;
        fig_newt=imagesc(m,n,im);
        set(fig_newt,'alphaData',alpha)
        assignin('base','fig_newt',fig_newt)
    end
end
