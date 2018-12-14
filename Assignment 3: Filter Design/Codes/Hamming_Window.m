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
    
    %Hamming Window
    
    for i = 1:length(n)
        if(i<=N)
            w4(i) = 0.54 - 0.46*cos((2*pi*(i-1))/(2*k));
        else
            w4(i)= 0;
        end
    end
    
    h4 = w4.*hd;
   
    %Plotting frequency response
    fvtool(h4,'Analysis','freq')
    grid on; grid minor; axis tight;
    legend('Magnitude','Phase');
    title(['Frequency Response Of Hamming Window Of Order ' num2str(N-1) ' ']); 
  
end

