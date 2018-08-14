clear;clc;close;

% map_info=zeros(1000);
load('map_info.mat'); %path info
[A,color_map]=imread('1.gif','frames','all'); %load monster image
mov=immovie(A,color_map);
turret=imread('turret.jpg'); %load turret image
fire=imread('fire.jpg'); %load fire image 
fire=[fire(:,100:210,:) fire(:,100:190,:)];
floor_im=imread('floor.jpg'); %load floor image
floor_im=imresize(floor_im,[200 200]);
path=imread('path.jpg'); %load path image
path=imresize(path,[100 100]);
path=path+50;

map=repmat(floor_im,[5,5,1]); %map size
%--画道路--%
path=repmat(path,[10,10,1]);
map_info=logical(map_info');
map3=repmat(map_info,[1 1 3]);
map(map3)=path(map3);

%--自定义炮台--%
main_fig=figure('Position',[20 20 1000 660]);
click=0; %check mouse click
uicontrol('Parent',main_fig,'Style','pushbutton','String','创建新炮台',...
    'Position',[100 500 100 40],'fontSize',12,'Callback',@addTurret);

imshow(map); %display map
alpha(.5)
hold on

mpos=[0 0]; %monster position
tpos=[300 100]; %turret position
fpos=tpos; %fire position
tnum=1; %炮台数
f_hit=0; %to check if fire has hit target
hp=200; %initial monster hp
prev=1; %monster previous move
for t=1:900
    if t>1
        delete(m_fig)
        delete(t_fig)
        delete(hp_fig)
        delete(hp_fig2)
        if exist('f_fig','var')
        delete(f_fig)
        end
    end
    
    [mpos,prev]=monster_move(map_info,mpos,prev);
    [m_im,alpha]=monster_im(mov(mod(t-1,30)+1).cdata,prev); %monster image information
    m_fig=imagesc(mpos(1),mpos(2),m_im);
    set(m_fig,'AlphaData',alpha)
    hp_fig=rectangle('Position',[mpos(1) mpos(2) 100 10]); %monster hp bar
    hp_fig2=rectangle('Position',[mpos(1) mpos(2) hp/2 10],'FaceColor','r'); %monster hp
    
    for i=1:tnum
    [t_im,alpha,t_ang(i)]=turret_im(turret,mpos,tpos(i,:)); %turret image information
    t_fig(i)=imagesc(tpos(i,1),tpos(i,2),t_im);
    set(t_fig(i),'AlphaData',alpha)
    
    tm_dist=pdist([mpos;tpos(i,:)]); %turret to monster distance
    fm_dist=pdist([mpos;fpos]); %fire to monster distance
    if tm_dist<250 || f_hit(i)==0
        if  fm_dist>40
            if fpos(i,1)~=tpos(i,1)
            f_hit(i)=0;
            end
            fpos(i,1)=fpos(i,1)-(tpos(i,1)-mpos(1))/9;
            fpos(i,2)=fpos(i,2)-(tpos(i,2)-mpos(2))/9;
            [f_im,alpha]=fire_im(fire,t_ang(i)); %fire image info
            f_fig(i)=imagesc(fpos(i,1),fpos(i,2),f_im);
            set(f_fig(i),'AlphaData',alpha)
        elseif fm_dist<40
            f_hit=1;
            hp=hp-10;
            fpos(i,:)=tpos(i,:); %导弹归位
        end
    end
    end
    pause(.01)
end