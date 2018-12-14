L = 1000;

N = 97;
for i=1:length(N)
    
    k = (N-1)/2;
    wc = 0.55*pi;
    n = 0:L;
    w = -pi:2*pi/1000:pi;
    for j= 1:length(n)
        if(j-1==k)
            hd(j) = wc/pi;
        else 
            hd(j) = sin(wc*(j-1-k))/(pi*(j-1-k));
        end

    end
   
       %Blackmnan Window

    for p = 1:length(n)
          if(p<=N)
            w5(p) = 0.42 - 0.5*cos((2*pi*(p-1))/(2*k))+0.08*cos((4*pi*(p-1))/(2*k));
        else
            w5(p)= 0;
        end
    end

    h5 = w5.*hd;
    % plot(n, h5);
    %Plotting frequency response
   
    fvtool(h5,'Analysis','freq');
    title(['Blackman window of Order ' num2str(N-1) '']);
end
    

