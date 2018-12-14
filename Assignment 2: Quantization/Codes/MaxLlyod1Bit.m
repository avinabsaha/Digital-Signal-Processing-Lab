clear;
% Load Image
I = imread('lena_gray.bmp');
% Display Image
imshow(I);
title('Original Image');

% Reshaping to a long vector
Image_vector = I(:);
% Converting to double data type
Image_vector_valuefloat = im2double(Image_vector)';

figure();
histogram(Image_vector,'Normalization','Probability')
title('Histogram of pixel values');

for i=1:256
    counter(i) = 0;
    for j=1:length(Image_vector)
        if Image_vector(j)==(i-1)
            counter(i) = counter(i)+1;
        end
    end
    probabilityvector(i) = counter(i)/length(Image_vector);
end


% 1-bit Max-LLyod Quantization
m = 127;

% Calculation of Quantized Value Based on Max Lloyd Quantization
while(1)
    x1_val=0;
    x2_val=0;
    p1=0;
    p2=0;
    for i=1:floor(m)
        x1_val = x1_val + i*probabilityvector(i);
        p1 = p1+probabilityvector(i);
    end
    for j=floor(m)+1:256
        x2_val = x2_val + j*probabilityvector(j);
        p2 = p2+probabilityvector(j);
    end
    
    v1 = x1_val/p1;
    v2 = x2_val/p2;
    
    temp=m;
    m =(v1+v2)/2;
    
    err = abs(temp-m);
    if (err<=0.01)
        break;
    end
end

% Quantizing the image vactor
for i=1:length(Image_vector)
    if (Image_vector(i) <= m)
        I_vec_1bit_maxlloyd(i)=v1;
    else
        I_vec_1bit_maxlloyd(i)=v2;
    end
end


% Reshaping Image
I_one_bit_maxlloyd = uint8(reshape(I_vec_1bit_maxlloyd,512,512));
Error_1bit_maxlloyd = immse(I,I_one_bit_maxlloyd)/255;
figure();
imshow(I_one_bit_maxlloyd);  
title('1 Bit Max-Lloyd Quantized Image');
    
    


