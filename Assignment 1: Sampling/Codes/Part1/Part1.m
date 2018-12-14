% Sampling frequency of 12KHz
f_max= 1.2e5; 
f_min = 1e3;
cycles = 3;
% Forming the time axis
t = [0:1/f_max:(cycles/f_min)];
% Defining the Analog Signal
x = 10*cos(2*pi*1000*t) + 6*cos(2*pi*2000*t) + 2*cos(2*pi*4000*t);

% Plot Of Analog Signal
plot(t,x,'r');
hold on;
title('Plot of Analog Domain Signal and corresponding Sampled Version');
xlabel('Time in seconds');
ylabel('Magnitude');
grid on;
grid minor;

% Plotting of sampled signal
fs= 12000;
ts = [0:1/fs:cycles/f_min];
xs = 10*cos(2*pi*1000*ts) + 6*cos(2*pi*2000*ts) + 2*cos(2*pi*4000*ts);
stem(ts,xs,'b');
legend('Analog Signal','Sampled Signal');

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');


% DFT for different values of N
% List for different values of N
N = [12 64 128 256];

for i=1:length(N)
ts = [0:1/fs:N(i)/f_min];
xs = 10*cos(2*pi*1000*ts) + 6*cos(2*pi*2000*ts) + 2*cos(2*pi*4000*ts);
f_range = [-fs/2:fs/N(i):fs/2-fs/N(i)];
y_fft = fftshift(abs(fft(xs,N(i))/N(i)));
% Plotting on a new figure for each value of N. 
figure();
stem(f_range,y_fft);
xlabel('Frequency');
ylabel('|X(f)|/N');
title(['DFT of the signal with Fs = 12 KHz N = ' num2str(N(i)) ' ']);

% Setting Font Size, Font Name, Font weight and Background color
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
set(gcf,'color','w');
grid on;
grid minor;
end