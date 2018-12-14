% Setting up a few parameters
f= 1.2e5;
f_max = 1e3;
cycles = 3;
t = [0:1/f:(cycles/f_max)-1/f];

% Plotting of Analog signal
x = 10*cos(2*pi*1000*t) + 6*cos(2*pi*2000*t) + 2*cos(2*pi*4000*t);
plot(t,x,'r');
hold on;
title('Analog Signal');
xlabel('time(sec)');
ylabel('Magnitude');

% Plotting of sampled signal 12 KHz
fs= 12000;
ts = [0:1/fs:cycles/f_max-1/fs];
xs = 10*cos(2*pi*1000*ts) + 6*cos(2*pi*2000*ts) + 2*cos(2*pi*4000*ts);
stem(ts,xs,'b');
% Sampling at 24 KHz
fs2= 24000;
ts2 = [0:1/fs2:cycles/f_max-2/fs2];
xs2 = 10*cos(2*pi*1000*ts2) + 6*cos(2*pi*2000*ts2) + 2*cos(2*pi*4000*ts2);

figure();
% Plotting of sampled signal 24 KHz
subplot(2,1,1);
stem(ts2,xs2/2,'b');
title('Sampled output at Fs=24 KHz');
xlabel('Time(sec)');
ylabel('Magnitude');
grid on;
grid minor;

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');

% Upsampling Process
xs_up = zeros(1,2*(length(ts)-1));
for i=1:length(ts)
 xs_up(2*i-1) = xs(i);
end
% Butterworth Low Pass Filtering to remove high frequency components
[b,a] = butter(10, 6000/(24000/2),'low');
Y_lpf = filter(b,a,xs_up);
subplot(2,1,2);
stem(ts2,Y_lpf,'r');
title('Upsampling followed by LPF output');
xlabel('Time(sec)');
ylabel('Magnitude');
grid on;
grid minor;

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Arial','fontsize',14,'FontWeight','bold');
set(gcf,'color','w');

% Performing Discrete Time Fourier Transform
N = 256;
y_dft1 = fft(xs_up,N);
freq = [-fs2/2:fs2/N:fs2/2-fs2/N];
y_dft_val1 = fftshift(abs(y_dft1)/N);
figure();
subplot(2,1,1);
stem(freq,y_dft_val1);
xlabel('Frequency (in hertz)');
ylabel('|X(f)|/N');
title('Spectrum of Signal Uplsampled by a Factor 2 (N=256)');
grid on;
grid minor;

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
y_dft2 = fft(Y_lpf,N);
freq = [-fs2/2:fs2/N:fs2/2-fs2/N];
y_dft_val2 = fftshift(abs(y_dft2)/N);
subplot(2,1,2);
stem(freq,y_dft_val2,'g');
xlabel('Frequency (in hertz)');
ylabel('|X(f)|/N');
title('Spectrum of Interpolated Signal with N=256');
grid on;
grid minor;

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');