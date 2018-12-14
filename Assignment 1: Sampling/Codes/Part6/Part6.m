% Setting up a few parameters
f= 1.2e5;
f_max = 1e3;
cycles = 3;
% Defining time axis
t = [0:1/f:(cycles/f_max)-1/f];
% Defining the analog signal
x = 10*cos(2*pi*1000*t) + 6*cos(2*pi*2000*t) + 2*cos(2*pi*4000*t);
% Sampling at 12 kHz
fs= 12000;
ts = [0:1/fs:cycles/f_max-1/fs];
% Forming the sampled signal
xs = 10*cos(2*pi*1000*ts) + 6*cos(2*pi*2000*ts) + 2*cos(2*pi*4000*ts);
% Anti-aliasing filter
[b,a] = butter(6,3000/(12000/2),'low');
x_alias = filter(b,a,xs);
% Downsampling by a factor 2
xs_down = downsample(x_alias,2);
ts_down = downsample(ts,2);
% Downsampling without anti-aliasing filter
xs_down_wa = downsample(xs,2);
% Sample and hold of Downsampled Signal
j=1;
ts_hold = upsample(ts_down,20);
for i=1:length(t)

 xs_hold(i)=xs_down(j);

 for k=2:length(ts_down)
     if ts_hold(i)==ts_down(k)
        j=j+1;
     end
 end
end

% Low Pass Filtering with Butterworth filter
[b,a] = butter(10, 0.1,'low');
Y_lpf = filter(b,a,xs_hold);
figure();
plot(t,x,'r');
hold on;
plot(t,Y_lpf,'g');
title('Reconstructed Signal from the downsampled version');
xlabel('Time(sec)');
ylabel('Magnitude');
legend('Original Signal','Reconstruction from downsampled signal');
grid on;
grid minor;

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Arial','fontsize',14,'FontWeight','bold');
set(gcf,'color','w');


% Discrete Time Fourier Transform
N = 256;
y_dft1 = fft(x_alias,N);
freq = [-0.5*fs/2:0.5*fs/N:0.5*fs/2-0.5*fs/N];
y_dft_val1 = fftshift(abs(y_dft1)/N);
figure();
subplot(2,1,1);
stem(freq,y_dft_val1,'r');
xlabel('Frequency (in hertz)');
ylabel('|X(f)|/N');
title('Spectrum of output of anti-aliasing filter (Fc = 3 Khz)(N=256)');
grid on;
grid minor;

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
y_dft2 = fft(xs_down,N);
freq = [-0.5*fs/2:0.5*fs/N:0.5*fs/2-0.5*fs/N];
y_dft_val2 = fftshift(abs(y_dft2)/N);
subplot(2,1,2);
stem(freq,y_dft_val2,'g');
xlabel('Frequency (in hertz)');
ylabel('|X(f)|/N');
title('Spectrum of Decimated Signal downsampled by a factor 2 with N=256');
grid on;
grid minor;

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');