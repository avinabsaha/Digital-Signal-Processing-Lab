clear;
image=imread('salt_pepper.bmp');
figure(1);
imshow(image);
image_out = medfilt2(image);
figure();
imshow(image_out)