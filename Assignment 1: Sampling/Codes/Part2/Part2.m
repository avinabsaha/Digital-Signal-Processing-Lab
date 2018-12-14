% Setting up a few parameters
f_max= 1.2e5;
f_min = 1e3;
cycles = 3;
% Forming the time axis
t = [0:1/f_max:(cycles/f_min)];
% Defining the Analog Signal
x = 10*cos(2*pi*1000*t) + 6*cos(2*pi*2000*t) + 2*cos(2*pi*4000*t);

% List to store different sampling frequencies
fs = [4000 5000 8000];

% Plotting of sampled signal
for i=1:length(fs)
    ts = [0:1/fs(i):cycles/f_min];
    xs = 10*cos(2*pi*1000*ts) + 6*cos(2*pi*2000*ts) + 2*cos(2*pi*4000*ts);
    figure();
    plot(t,x,'r');
    hold on;
    title(['Plot of the Analog Signal and Sampled Version with Fs = ' num2str(fs(i)) ' Hz']);
    xlabel('time(sec)');
    ylabel('Magnitude');
    stem(ts,xs,'b');
    legend('Analog Signal','Sampled Signal');

    % Setting Font Size, Font Name, Font weight and Background color
    set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
    set(gcf,'color','w');
    grid on;
    grid minor;

    % DFT for different values of N
    % List for different values of N

    N = [64 128 256];
    figure();
    for j=1:length(N)
        ts = [0:1/fs(i):(N(j)-1)/fs(i)];
        xs = 10*cos(2*pi*1000*ts) + 6*cos(2*pi*2000*ts) + 2*cos(2*pi*4000*ts);
        f_range = [-fs(i)/2:fs(i)/N(j):fs(i)/2-fs/N(j)];
        y_fft = fftshift(abs(fft(xs)/N(j)));
        % Subplot created
        subplot(3,1,j);
        stem(f_range,y_fft);
        xlabel('Frequency');
        ylabel('|X(f)|/N');
        title(['DFT of the signal Fs = ' num2str(fs(i)) ' Hz N = ' num2str(N(j)) ' ']);
        
        % Setting Font Size, Font Name, Font weight and Background color
        set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
        set(gcf,'color','w');
        grid on;
        grid minor;
    end
 end