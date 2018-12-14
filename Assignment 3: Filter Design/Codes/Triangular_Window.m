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
    
    %Triangular Window
    
    for i = 1:length(n)
        if(i<=N)
            w2(i) = 1-2*((i-1)-k)/(2*k);
        else
            w2(i)= 0;
        end
    end
    
    h2 = w2.*hd;
    %Plotting frequency response
    fvtool(h2,'Analysis','freq')
    grid on; grid minor; axis tight;
    legend('Magnitude','Phase');
    title(['Frequency Response Of Bartlett Window Of Order ' num2str(N-1) ' ']);
end


