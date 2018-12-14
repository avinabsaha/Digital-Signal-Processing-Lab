% Setting up a few parameters
% List for storing different values of frequency
fs = [8e3 10e3 20e3 40e3 60e3];
for z=1:length(fs)
    f = fs(z)*10;
    f_max = 1e3;
    Ncycle = 5;
    t = [0:1/f:Ncycle/f_max-1/f];
    % Analog Square wave generation
    sq = square(2*pi*f_max*t,50);
    fs1 = fs(z);
    % Forming the time axis
    ts = [0:1/fs1:Ncycle/f_max-1/fs1];
    xs = square(2*pi*f_max*ts,50);
    % Sample and Hold Signal
    j=1;
    % Upsampling
    t_new=upsample(ts,10);
    for i=1:length(t_new)

     xs_hold(i)=xs(j);

     for k=2:length(ts)
     if t_new(i)==ts(k)
     j=j+1;
     end
     end
    end

    % Using a Low Pass Filter to move out higher frequency spectrum
    figure();
    subplot(2,1,1);
    plot(t,sq,'r');
    hold on;
    stem(ts,xs,'b');
    grid on;
    grid minor;
    title(['Square Wave Signal and Sampling at Fs = ' num2str(fs(z)) ' Hz']);
    xlabel('Time in sec');
    ylabel('Magnitude');
    legend('Square Wave Signal','Sampled Signal');
    set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
    set(gcf,'color','w');
    
    %Using a Butterworth fitler
    [b,a] = butter(10, 0.1,'low');
    
    % Reconstructed Signal
    Y_lpf = filter(b,a,xs_hold);
    subplot(2,1,2);
    plot(t,Y_lpf,'r');
    title('Reconstructed Signal');
    xlabel('Time(sec)');
    ylabel('Magnitude');
    
    % Setting Font Size, Font Name, Font weight and Background color
    set(gca, 'FontName', 'Arial','fontsize',14,'FontWeight','bold');
    set(gcf,'color','w');
    grid on;
    grid minor;
    
    % Calculating overshoot percentage
    over = max(Y_lpf);
    overshoot_percent = (over-1)*100;
    fprintf('Overshoot percentage for fs: %d Hz = %f\n',fs(z),overshoot_percent);
    % Using 2 percent settling time
    t_index_all = find(abs(Y_lpf)<=0.02);
    q = t_index_all(end-2);
    t_index=q;
    while(1)
     if(Y_lpf(q)>Y_lpf(q+1) && Y_lpf(q+2)<Y_lpf(q+1))
     if (Y_lpf(q+1)<=1.02)
     qnew = q+1;
     break;
     end
     end
     q=q+1;
    end
    settle_time= t(qnew)-t(t_index);
    % Printing the settling time
    fprintf('Settling time(2 percent) for fs: %d Hz = %.8f\n',fs(z),settle_time);
end
