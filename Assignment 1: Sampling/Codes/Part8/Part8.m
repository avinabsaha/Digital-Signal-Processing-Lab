% Setting up a few parameters
f_max= 1.2e8;
f_min = 1000*10702.5;
N=4096;
t = [0:1/f_max:(N/f_min)];
% Defining the bandpass analog signal
x = 10*cos(2*pi*1000*10702.5*t)+6*cos(2*pi*10717*1000*t)+2*cos(2* pi*10727.5*1000*t);
% List for two frequencies
fs = [50000 65000];
for i=1:length(fs)
    ts = [0:1/fs(i):(N-1)/fs(i)];
    xs = 10*cos(2*pi*1000*10702.5*ts)+6*cos(2*pi*10717*1000*ts)+2*cos(2*pi*10727.5*1000*ts);
    f_range = [-fs(i)/2:fs(i)/N:fs(i)/2-fs(i)/N];
    y_fft = fftshift(abs(fft(xs)/N));
    figure();
    stem(f_range,y_fft,'r');
    xlabel('Frequency');
    ylabel('|X(f)|/N');
    title(['DFT of the signal with Fs = ' num2str(fs(i)) ' Hz N = 4096']);
    % Setting Font Size, Font Name, Font weight and Background color
    set(gca, 'FontName','Arial','fontsize',14,'FontWeight','bold');
    set(gcf,'color','w');
    grid on;
    grid minor;
end