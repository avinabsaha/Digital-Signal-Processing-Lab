clear;
% Load Image
I = imread('lena_gray.bmp');
% Display Image
imshow(I);
title('Original Image');

% Reshaping to a long vector
Image_vector = I(:);
% Converting to double data type
Image_vector_valfloat = im2double(Image_vector)';
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
    probability(i) = counter(i)/length(Image_vector);
end

% 2-Bit Max Lloyd quantization

m = [64 127 191];
index = [0 m(1) m(2) m(3) 255];


while(1)
    for i=1:4
        x_val(i)=0;
        p(i)=0;
        
        for j=floor(index(i))+1:floor(index(i+1))
            x_val(i) = x_val(i) + j*probability(j);
            p(i) = p(i)+probability(j);
        end
        v(i) = x_val(i)/p(i);
    end
    
    temp=index;
    
    index(1) = 0;
    index(5) = 255;
    for k=1:3
        index(k+1) = (v(k)+v(k+1))/2;
    end
    
    err = max(abs(temp-index));
    
    if (err<=0.01)
        break;
    end
    
end
% Quantizing the image vactor
for i=1:length(Image_vector)
    if Image_vector(i) <= index(2)
        I_vec_2Bit_maxlloyd(i) = v(1);
    else if Image_vector(i) <= index(3)
        I_vec_2Bit_maxlloyd(i) = v(2);
    else if Image_vector(i) <= index(4)
        I_vec_2Bit_maxlloyd(i) = v(3);
    else
        I_vec_2Bit_maxlloyd(i) = v(4);
    end
    end
    end
end

% Reshaping Image
I_two_bit_maxlloyd = uint8(reshape(I_vec_2Bit_maxlloyd,512,512));
error_2Bit_maxlloyd = immse(I,I_two_bit_maxlloyd)/255;
figure();
imshow(I_two_bit_maxlloyd);
title('2 Bit Max-Lloyd Quantized Image');