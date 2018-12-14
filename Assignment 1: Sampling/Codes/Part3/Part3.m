% Setting up a few parameters
f = 1e5;
f_max = 1e3;
Ncycle = 5;
% Forming the time axis
t = [0:1/f:Ncycle/f_max];
% Defining the Analog Square Signal
squareWeb = square(2*pi*f_max*t,50);
figure();
% Plotting of sampled signal
plot(t,squareWeb);
fs = 20000;
ts = [0:1/fs:Ncycle/f_max];
% Sampled Square wave
sq_s = square(2*pi*f_max*ts,50);
hold on;
stem(ts,sq_s);

title(['Square Wave Signal and Sampling at Fs = 20 KHz']);
xlabel('Time in sec');
ylabel('Magnitude');
legend('Square Wave Signal','Sampled Signal');

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');

% DFT of square wave with 256 Samples
N = 256;
ts = [0:1/fs:N/f_max];
sq_s = square(2*pi*f_max*ts,50);
y_dft = fft(sq_s,N);
freq = [-fs/2:fs/N:fs/2-fs/N];
y_dft_val = fftshift(abs(y_dft)/N);
figure();
stem(freq,y_dft_val);
xlabel('Frequency (in hertz)');
ylabel('|X(f)|/N');
title('Spectrum of sampled signal with Fs=20 KHz and N=256');

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Arial','fontsize',14,'FontWeight','bold');
set(gcf,'color','w');
grid on;
grid minor;