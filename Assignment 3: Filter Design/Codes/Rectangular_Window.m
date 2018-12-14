clear;
L = 1000;
for i=1:3
    N = (2^(3*i))+1; % taking N = 9 , 65, 513;
    k = (N-1)/2;
    wc = pi/5;
    n = 0:L;
    for i= 1:length(n)
        if(i-1==k)
            hd(i) = wc/pi;
        else
            hd(i) = sin(wc*(i-1-k))/(pi*(i-1-k));
        end
        
    end
    
    %Rectangular window
    
    for i = 1:length(n)
        if(i<=N)
            w1(i) = 1;
        else
            w1(i)= 0;
        end
    end
    
    h1 = w1.*hd;
  
    %Plotting frequency response
    fvtool(h1,'Analysis','freq')
    grid on; grid minor; axis tight;
    legend('Magnitude','Phase');
    title(['Frequency Response Of Rectangular Window Of Order ' num2str(N-1) ' ']);
    
end



