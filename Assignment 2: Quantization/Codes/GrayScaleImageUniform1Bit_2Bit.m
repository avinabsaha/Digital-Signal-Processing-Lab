clear;
% Load Image
I = imread('lena_gray.bmp');
% Display Image
imshow(I);
title('Original Image');

% Reshaping to a long vector
Image_vector = I(:);
% Converting to double data type
Image_vector_value_float = im2double(Image_vector)';

% 1-bit uniform quantizer
for i=1:length(Image_vector)
    if (Image_vector(i) <= 127)
        I_vec_one_bit_uniform(i) = 64;
    else
        I_vec_one_bit_uniform(i) = 192;
    end
end



% Reshape into original image shape
Image_one_bit_uniform = uint8(reshape(I_vec_one_bit_uniform,512,512));
figure();
imshow(Image_one_bit_uniform);
title('1 Bit Quantized Image');
% Calculating Error for 1 bit quantization
Error_1bit_uniform_quantization = immse(I,Image_one_bit_uniform)/255;

% 2-bit uniform quantizer

for i=1:length(Image_vector)
    if Image_vector(i) <= 63
        I_vec_two_bit_uniform(i) = 32;
    else if Image_vector(i) <= 127
        I_vec_two_bit_uniform(i) = 96;
    else if Image_vector(i) <= 191
        I_vec_two_bit_uniform(i) = 160;
    else
        I_vec_two_bit_uniform(i) = 224;
        end
        end
    end     
end
% Reshaping Image
I_two_bit_uniform = uint8(reshape(I_vec_two_bit_uniform,512,512));
figure();
imshow(I_two_bit_uniform);
title('2 Bit Quantized Image');
% Calculating Error for 2 bit quantization
Error_2bit_uniformquantization = immse(I,I_two_bit_uniform )/255;
