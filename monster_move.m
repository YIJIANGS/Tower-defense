function [mpos,prev]=monster_move(map_info,mpos,prev)
m=mpos(1)+1; mend=m+99;
n=mpos(2)+1; nend=n+99;
spd=7;
if mend+spd<1000 && mean(mean(map_info(n:nend,m+spd:mend+spd)))>.9 %向右
%     mpos(1)=mpos(1)+spd;
    valid(1)=1;
else
    valid(1)=0;
end
if nend+spd<1000 && mean(mean(map_info(n+spd:nend+spd,m:mend)))>.9 %向下
%     mpos(2)=mpos(2)+spd;
    valid(2)=1;
else
    valid(2)=0;
end
if m-spd>0 && mean(mean(map_info(n:nend,m-spd:mend-spd)))>.9 %向左
    valid(3)=1;
else
    valid(3)=0;
end
if n-spd>0 && mean(mean(map_info(n-spd:nend-spd,m:mend)))>.9 %向上
    valid(4)=1;
else
    valid(4)=0;
end
switch prev
    case 1
        if valid(1)==1
            prev=1;
            mpos(1)=mpos(1)+spd;
        elseif valid(2)==1
            prev=2;
            mpos(2)=mpos(2)+spd;
        elseif valid(4)==1
            prev=4;
            mpos(2)=mpos(2)-spd;
        end
    case 2
        if valid(2)==1
            prev=2;
            mpos(2)=mpos(2)+spd;
        elseif valid(1)==1
            prev=1;
            mpos(1)=mpos(1)+spd;
        elseif valid(3)==1
            prev=3;
            mpos(1)=mpos(1)-spd;
        end
    case 3
        if valid(3)==1
            prev=3;
            mpos(1)=mpos(1)-spd;
        elseif valid(4)==1
            prev=4;
            mpos(2)=mpos(2)-spd;
        elseif valid(2)==1
            prev=2;
            mpos(2)=mpos(2)+spd;
        end
    case 4
        if valid(4)==1
            prev=4;
            mpos(2)=mpos(2)-spd;
        elseif valid(1)==1
            prev=1;
            mpos(1)=mpos(1)+spd;
        elseif valid(3)==1
            prev=3;
            mpos(1)=mpos(1)-spd;
        end
            
        
end