clear;
Image = imread('lena_gray.bmp');
ImageCopy=Image;
imshow(Image);
title('Original Image');


Image_vector = Image(:);
Image_vector_valuefloat = im2double(Image_vector)';

% 1-bit uniform quantizer

for i=1:length(Image_vector)
    if Image_vector(i) <= 127
        I_vec_one_bit_uniform(i) = 63;
    else
        I_vec_one_bit_uniform(i) = 191;
    end
end

I_quantized  = reshape(I_vec_one_bit_uniform,512,512);
I_one_bit_uniform = uint8(reshape(I_vec_one_bit_uniform,512,512));
figure();
imshow(I_one_bit_uniform);
title('1 Bit Uniform Quantized Image');

% Calculatin error
error_one_bit_uniform = immse(ImageCopy,I_one_bit_uniform)/255

%Dithering Process Diffusion of Noise
a=3/16;
b=5/16;
c=1/16;
d=7/16;


% Dithering Process
for i=1:511
    for j=2:511
        e = I_quantized(i,j) - Image(i,j);
        Image(i,j+1)=Image(i,j+1)+a*e;
        Image(i+1,j-1)=Image(i+1,j-1)+b*e;
        Image(i+1,j)= Image(i+1,j)+c*e;
        Image(i+1,j+1)= Image(i+1,j+1)+d*e;
    end
end
I_ditherred = uint8(Image);
figure();
imshow(I_ditherred)
title('Dithered Image')
error_dithered = immse(ImageCopy,I_ditherred)/255

