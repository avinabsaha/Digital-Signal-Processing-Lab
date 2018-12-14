clear;
fsampling = 1000;
N = 256; % DFT parameter
frequency_wave = 5;

Xmax = 1;
tsampling = [0:1/fsampling:N/frequency_wave];
xsampling = Xmax*sin(2*pi*frequency_wave*tsampling);


% 12-bit Uniform Quantisation
m1=max(xsampling);
m2=min(xsampling);
no_of_bits=12;
L= 2^no_of_bits;
delta = (m1-m2)/L;
initial_val = -(L/2)*delta;
% Building Quantization value dictionary
for i=1:L
    quant_val(i) = initial_val;
    initial_val = initial_val+delta;
end

% Building Quantization Bracket dictionary
 initial_val2 = -((L+1)/2)*delta;
 for i=1:(L+1)
     quant_bracket(i) = initial_val2;
     initial_val2 = initial_val2+delta;     
 end
 
% Quantizing Process
for i=1:length(xsampling)
    val=xsampling(i);
    if val< quant_bracket(1)
        quantized(i)=quant_val(1)
    elseif val> quant_bracket(L+1)
        quantized(i)=quant_val(L);
    else
        for j=1:L
            if (val>quant_bracket(j)) && (val<quant_bracket(j+1))
                quantized(i) = quant_val(j);             
            end
        end   
    end    
end
error1=immse(xsampling,quantized)
% Truncating to 8 bits
m1=max(quantized);
m2=min(quantized);
no_of_bits=8;
L= 2^no_of_bits;
delta = (m1-m2)/L;
initial_val = -(L/2)*delta;
% Building Quantization value dictionary
for i=1:L
    quant_val(i) = initial_val;
    initial_val = initial_val+delta;
end

% Building Quantization Bracket dictionary
 initial_val2 = -((L+1)/2)*delta;
 for i=1:(L+1)
     quant_bracket(i) = initial_val2;
     initial_val2 = initial_val2+delta;     
 end
 
% Quantizing Process
for i=1:length(quantized)
    val=quantized(i);
    if val< quant_bracket(1)
        quantized_trunc(i)=quant_val(1)
    elseif val> quant_bracket(L+1)
        quantized_trunc(i)=quant_val(L);
    else
        for j=1:L
            if (val>quant_bracket(j)) && (val<quant_bracket(j+1))
                 quantized_trunc(i) = quant_val(j);             
            end
        end   
    end    
end
error2=immse(xsampling,quantized_trunc)

% Addition of 5-bit noise

rangeOfNoise = 2/(2^12)*(2^5);
noise = -rangeOfNoise/2 + rangeOfNoise*rand(1,length(quantized));
quantized_noise = quantized + noise;

error3=immse(xsampling,quantized_noise)
error4=immse(quantized,quantized_noise)
% Truncate Noise added signal to 8 bits

m1=max(quantized_noise);
m2=min(quantized_noise );
no_of_bits=8;
L= 2^no_of_bits;
delta = (m1-m2)/L;
initial_val = -(L/2)*delta;
% Building Quantization value dictionary
for i=1:L
    quant_val(i) = initial_val;
    initial_val = initial_val+delta;
end

% Building Quantization Bracket dictionary
 initial_val2 = -((L+1)/2)*delta;
 for i=1:(L+1)
     quant_bracket(i) = initial_val2;
     initial_val2 = initial_val2+delta;     
 end
 
% Quantizing Process
for i=1:length(quantized_noise )
    val=quantized_noise (i);
    if val< quant_bracket(1)
        quantized_noise_trunc(i)=quant_val(1)
    elseif val> quant_bracket(L+1)
        quantized_noise_trunc(i)=quant_val(L);
    else
        for j=1:L
            if (val>quant_bracket(j)) && (val<quant_bracket(j+1))
                quantized_noise_trunc(i) = quant_val(j);             
            end
        end   
    end    
end
error5=immse(xsampling,quantized_noise_trunc)
% Plots
stem(tsampling(1:201),xsampling(1:201),'r');
title('Plot of Original Sampled Signal ');
xlabel('Time in seconds');
ylabel('Magnitude');
grid on;
grid minor;
legend('Original Sampled Signal');
% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');

figure();
stem(tsampling(1:201),quantized(1:201),'r');
hold on;
stem(tsampling(1:201),quantized_trunc(1:201),'b');
title('Plot of 12 bit and Truncated 8 bit Signal ');
xlabel('Time in seconds');
ylabel('Magnitude');
grid on;
grid minor;
legend('12 Bit Quantized Signal','8 Bit Quantized Signal');
% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');

figure();
stem(tsampling(1:201),quantized_noise(1:201),'r');
hold on;
stem(tsampling(1:201),quantized_noise_trunc(1:201),'b');
title('Plot of 12 bit and Truncated 8 bit Signal with noise');
xlabel('Time in seconds');
ylabel('Magnitude');
grid on;
grid minor;
legend('12 Bit Quantized Signal with noise','8 Bit Quantized Signal with noise');
% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');

% Spectrum Plots
f_range = [-fsampling/2:fsampling/N:fsampling/2-fsampling/N];
y_fft1 = fftshift(abs(fft(xsampling,N)/N));
y_fft2 = fftshift(abs(fft(quantized,N)/N));
y_fft3 = fftshift(abs(fft(quantized_trunc,N)/N));
y_fft4 = fftshift(abs(fft(quantized_noise,N)/N));
y_fft5 = fftshift(abs(fft(quantized_noise_trunc,N)/N));
figure();
subplot(3,1,1);
stem(f_range,y_fft1);
title('Spectrum Plot of Original Sampled Signal');
xlabel('Frequency in Hz');
ylabel('Magnitude');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
grid on;
grid minor;
subplot(3,1,2);
stem(f_range,y_fft2);
title('Spectrum Plot of 12 Bit Quantized Signal');
xlabel('Frequency in Hz');
ylabel('Magnitude');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
grid on;
grid minor;
subplot(3,1,3);
stem(f_range,y_fft3);
title('Spectrum Plot of 8 Bit Truncation of 12 Bit Signal');
xlabel('Frequency in Hz');
ylabel('Magnitude');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
grid on;
grid minor;
figure();
subplot(2,1,1);
stem(f_range,y_fft4);
title('Spectrum Plot of 12 Bit Quantized Signal with Noise');
xlabel('Frequency in Hz');
ylabel('Magnitude');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
grid on;
grid minor;
subplot(2,1,2);
stem(f_range,y_fft5);
title('Spectrum Plot of 8 Bit Truncation of 12 Bit Quantized Signal with Noise');
xlabel('Frequency in Hz');
ylabel('Magnitude');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
grid on;
grid minor;

