function [im2,alpha,t_ang]=turret_im(turret,mpos,tpos)
im=imresize(turret,[100 100]);
ang=atand((tpos(1)-mpos(1))/(tpos(2)-mpos(2)));
if tpos(2)>mpos(2)
im2=imrotate(im,ang-90,'crop');
t_ang=ang+180;
else
im2=imrotate(im,ang+90,'crop');
t_ang=ang;
end
g=rgb2gray(im2);
alpha=(g<250 & g~=0);
