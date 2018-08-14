function [f_im,alpha]=fire_im(fire,t_ang)
f_im=imresize(fire,[60,60]);
f_im=imrotate(f_im,t_ang,'loose');
g=rgb2gray(f_im);
alpha=(g<230 & g~=0);