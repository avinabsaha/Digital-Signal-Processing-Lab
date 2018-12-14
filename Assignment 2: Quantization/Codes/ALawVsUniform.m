clear;
fsampling = 1000;
N = 256; % DFT parameter
frequency_wave = 5;

Xmax = 1;
tsampling = [0:1/fsampling:N/frequency_wave];
xsampling = Xmax*sin(2*pi*frequency_wave*tsampling);


% A-law Companding Process

A = 10; % Change values for different A values
for i=1:length(xsampling)
    if (abs(xsampling(i)) < 1/A)
        y_companding(i) = sign(xsampling(i))*A*abs(xsampling(i))/(1+log(A));
    else
        y_companding(i) = sign(xsampling(i))*(1+log(A*abs(xsampling(i))))/(1+log(A));
    end
end

% 8 Bit Quantization Process
m1=max(y_companding);
m2=min(y_companding);
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
for i=1:length(y_companding)
    val=y_companding(i);
    if val< quant_bracket(1)
        y_quantized(i)=quant_val(1)
    elseif val> quant_bracket(L+1)
        y_quantized(i)=quant_val(L);
    else
        for j=1:L
            if (val>quant_bracket(j)) && (val<quant_bracket(j+1))
                y_quantized(i) = quant_val(j);             
            end
        end   
    end    
end

% A-law expansion Process

for i=1:length(y_quantized)
    if (abs(y_quantized(i)) < 1/(1 + log(A)))
        x_quantized(i) = sign(y_quantized(i))*(abs(y_quantized(i))*(1+log(A)))/A;
    else
        x_quantized(i) = sign(y_quantized(i))*(exp(abs(y_quantized(i))*log(A)-1)/A);
    end
end

% Error computation of original signal and processed signal
error_Alaw = sum((xsampling-x_quantized).^2)/length(xsampling);
disp(error_Alaw);

% Direct 8-bit uniform quantisation of xsampling
% 8 Bit Quantization Process
m1=max(xsampling);
m2=min(xsampling);
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
for i=1:length(xsampling)
    val=xsampling(i);
    if val< quant_bracket(1)
        xs_uniform_quantized(i)=quant_val(1)
    elseif val> quant_bracket(L+1)
        xs_uniform_quantized(i)=quant_val(L);
    else
        for j=1:L
            if (val>quant_bracket(j)) && (val<quant_bracket(j+1))
                xs_uniform_quantized(i) = quant_val(j);             
            end
        end   
    end    
end

% Error compuatation of xs and uniform quantised xs_uni_q
error_uniform = immse(xsampling,xs_uniform_quantized);
disp(error_uniform)

% Plotting Original Sampled Signal and Alaw Quantized Signal
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
stem(tsampling(1:201),x_quantized(1:201),'b');
hold on;
stem(tsampling(1:201),xs_uniform_quantized(1:201),'g');
title('Plot of A Law Quantized Signal and Uniform Quantized Version');
xlabel('Time in seconds');
ylabel('Magnitude');
grid on;
grid minor;
legend('A law Quantized Signal','Uniform Quantized Signal');
% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');

% Spectrum Plots
frequency_range = [-fsampling/2:fsampling/N:fsampling/2-fsampling/N];
y_fft1 = fftshift(abs(fft(xsampling,N)/N));
y_fft2 = fftshift(abs(fft(x_quantized,N)/N));
y_fft3 = fftshift(abs(fft(xs_uniform_quantized,N)/N));
figure();
subplot(3,1,1);
stem(frequency_range,y_fft1,'r');
title('Spectrum Plot of Original Sampled Signal');
xlabel('Frequency in Hz');
ylabel('Magnitude');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
grid on;
grid minor;
subplot(3,1,2);
stem(frequency_range,y_fft2,'g');
title('Spectrum Plot of A Law Quantized Signal');
xlabel('Frequency in Hz');
ylabel('Magnitude');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
grid on;
grid minor;
subplot(3,1,3);
stem(frequency_range,y_fft3,'b');
title('Spectrum Plot of Uniform Quantized Signal');
xlabel('Frequency in Hz');
ylabel('Magnitude');
grid on;
grid minor;
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');