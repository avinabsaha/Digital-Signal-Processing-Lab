% Setting up a few parameters
f= 1.2e5;
f_max = 1e3;
cycles = 3;
t = [0:1/f:(cycles/f_max)-1/f];
% Defining the analog signal
x = 10*cos(2*pi*1000*t) + 6*cos(2*pi*2000*t) + 2*cos(2*pi*4000*t);
% Plotting of Main signal
plot(t,x,'r');
hold on;
title('Analog Signal and Zero Order Hold Signal');
xlabel('Time(sec)');
ylabel('Magnitude');
grid on;
grid minor;
% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');

% Sampled signal
fs= 12000;
ts = [0:1/fs:cycles/f_max-1/fs];
% Sampled Signal Created
xs = 10*cos(2*pi*1000*ts) + 6*cos(2*pi*2000*ts) + 2*cos(2*pi*4000*ts);
% Sample and hold operation
j=1;
t_new=upsample(ts,10);
for i=1:length(t_new)

 xs_hold(i)=xs(j);

 for k=2:length(ts)
     if t_new(i)==ts(k)
        j=j+1;
     end
 end
end

% Low pass filtering using butterworth filter
stem(ts,xs);
hold on;
plot(t,xs_hold);
legend('Analog Signal','Sampled Signal','Zero Order Hold Signal');
[b,a] = butter(10, 0.1,'low');
Y_lpf = filter(b,a,xs_hold);
figure();
plot(t,x,'b');
hold on;
plot(t,Y_lpf,'r');
title('Signal Reconstruction');
xlabel('Time(sec)');
ylabel('Magnitude');
grid on;
grid minor;
% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
legend('Original Signal','Reconstructed Signal');

% Discrete Fourier Transform
N = 256;
y_dft1 = fft(xs_hold,N);
freq = [-fs/2:fs/N:fs/2-fs/N];
y_dft_val1 = fftshift(abs(y_dft1)/N);
figure();
subplot(2,1,1);
stem(freq,y_dft_val1);
xlabel('Frequency (in hertz)');
ylabel('|X(f)|/N');
title('Spectrum of Zero Order Hold Signal (N=256)');
grid on;
grid minor;
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
y_dft2 = fft(Y_lpf,N);
freq = [-fs/2:fs/N:fs/2-fs/N];
y_dft_val2 = fftshift(abs(y_dft2)/N);
subplot(2,1,2);
stem(freq,y_dft_val2);
xlabel('Frequency (in hertz)');
ylabel('|X(f)|/N');
title('Spectrum of Reconstructed Signal with N=256');
grid on;
grid minor;
% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w')