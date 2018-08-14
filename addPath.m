function addPath(~,~)
set(gcf,'windowbuttondownfcn',@mouseClick)
set(gcf,'windowbuttonupfcn',@mouseRelease)
set(gcf,'windowbuttonmotionfcn',@mouseMove)

function mouseClick(~,~)
map_info=evalin('base','map_info');
path=evalin('base','path');
C = get (gca, 'CurrentPoint');
m=floor(C(1,1)/100)*100;
n=floor(C(1,2)/100)*100;
map_info(m+1:m+100,n+1:n+100)=1;
p_fig=imagesc(m,n,path);
click=1;
assignin('base','click',click)
assignin('base','map_info',map_info)

function mouseRelease(~,~)
click=0;
assignin('base','click',click)

function mouseMove(~,~)
click=evalin('base','click');
if click==1
map_info=evalin('base','map_info');
C = get (gca, 'CurrentPoint');
m=floor(C(1,1)/100)*100;
n=floor(C(1,2)/100)*100;
path=evalin('base','path');
p_fig=imagesc(m,n,path);
map_info(m+1:m+100,n+1:n+100)=1;
assignin('base','map_info',map_info)
end