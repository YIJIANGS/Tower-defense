clear;clc;close;

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

%--自定义道路的代码--%
% main_fig=figure;
% click=0; %check mouse click
% uicontrol('Parent',main_fig,'Style','pushbutton','String','add path','Callback',@addPath);

imshow(map); %display map
alpha(.5)
hold on

clearvars map map3 path floor_im A color_map %清理变量

mpos=[0 0; 200 0;400 0;600 0;800 0]; %monster position
mnum=5; %怪物数
tpos=[300 100; 700 100; 500 300; 800 300]; %turret position  
tnum=4; %炮台数
fpos=tpos; %fire position
f_hit=ones(1,tnum); %to check if fire has hit target
hp=[100 250 250 100 200]; %initial monster hp
prev=ones(1,mnum); %monster previous move
fprev=zeros(1,tnum); %check each turret previous target
win=0; %check winning state
t=0; %timing
while win==0
    t=t+1;
    if t>1
        delete(m_fig)
        delete(t_fig)
        delete(hp_fig)
        delete(hp_fig2)
        if exist('f_fig','var')
        delete(f_fig)
        end
    end
    
    %--绘制怪物图--%
    for i=1:mnum
    [mpos(i,:),prev(i)]=monster_move(map_info,mpos(i,:),prev(i));
    [m_im,m_alpha]=monster_im(mov(mod(t-1,30)+1).cdata,prev(i)); %monster image information
    m_fig(i)=imagesc(mpos(i,1),mpos(i,2),m_im);
    set(m_fig(i),'AlphaData',m_alpha)
    hp_fig(i)=rectangle('Position',[mpos(i,1) mpos(i,2) 100 10]); %monster hp bar
    hp_fig2(i)=rectangle('Position',[mpos(i,1) mpos(i,2) hp(i)/2.5 10],'FaceColor','r'); %monster hp
    end
    
    for i=1:tnum
    
    if win==0
    tm_dist=pdist([tpos(i,:);mpos]); %turret to monster distance
%     [tm_dist,mindex]=min(tm_dist(1:mnum)); %get monster index
%     fm_dist=pdist([fpos(i,:);mpos(mindex,:)]); %fire to monster distance
    

    %--绘制炮台--%
    if t>1 && f_hit(i)==0
        mindex=fprev(i);
        tm_dist=tm_dist(fprev(i));
    else
        [tm_dist,mindex]=min(tm_dist(1:mnum)); %get monster index
    end
    fm_dist=pdist([fpos(i,:);mpos(mindex,:)]); %fire to monster distance
    
    [t_im,t_alpha,t_ang]=turret_im(turret,mpos(mindex,:),tpos(i,:)); %turret image information
    t_fig(i)=imagesc(tpos(i,1),tpos(i,2),t_im);
    set(t_fig(i),'AlphaData',t_alpha)
    
    fprev(i)=mindex;
    
    if tm_dist<250 || f_hit(i)==0
        if  fm_dist>45
            if fpos(i,1)~=tpos(i,1)
            f_hit(i)=0;
            end
            fpos(i,1)=fpos(i,1)-(tpos(i,1)-mpos(mindex,1))/9;
            fpos(i,2)=fpos(i,2)-(tpos(i,2)-mpos(mindex,2))/9;
            [f_im,f_alpha]=fire_im(fire,t_ang); %fire image info
            f_fig(i)=imagesc(fpos(i,1),fpos(i,2),f_im);
            set(f_fig(i),'AlphaData',f_alpha)
        elseif fm_dist<45
            f_hit(i)=1;
            hp(mindex)=hp(mindex)-10;
            fpos(i,:)=tpos(i,:); %导弹归位
            if hp(mindex)<=0 %如果有怪物空血
                mnum=mnum-1;
                mpos(mindex,:)=[];
                hp(mindex)=[];
                prev(mindex)=[];
                i2=find(fprev==mindex); %其他瞄准的导弹回位
                f_hit(i2)=1;
                fpos(i2,:)=tpos(i2,:); %导弹归位
                fprev(i2)=0;
                if mnum==0
                    win=1;
                    title('You WIN')
                end
            end
        end
    end
    end
    end
    pause(.01)
end
