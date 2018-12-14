clear;
im=imread('bridge.bmp');
figure(1);
imshow(im);
[x y z]=size(im);
a=double(im);
mask=([1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9]);
for i=2:x-1
 for j=2:y-1
 q=1;
    for c=i-1:i+1
        for d=j-1:j+1
            s(q)=a(c,d);
            q=q+1;
        end
    end
 s=sum(s.*mask);
 im(i,j)=s;
 end
end
figure(2)
imshow(uint8(im)); 