function [im2,alpha]=monster_im(im,prev)
if prev==3
    im=fliplr(im);
end
im2=imresize(im,[100 100]);
g=rgb2gray(im2);
alpha=g~=255;
