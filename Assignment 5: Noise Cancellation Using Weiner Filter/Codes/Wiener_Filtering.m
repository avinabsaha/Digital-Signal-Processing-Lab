%Avinab Saha 15EC10071
clear;
close all;

% Given wave characteristics

theta = 2*pi*rand-pi; %varying theta from -pi to pi
w0 = 0.04*pi;
N = 100000;
n = 1:N;

dn=sin(n*w0+theta);

vn=0.4*randn(1,N);

v1(1)=vn(1);
v2(1)=vn(1);
for i=2:N
    v1(i)=0.8*v1(i-1)+vn(i);    %primary sensor noise
    v2(i)=-0.6*v2(i-1)+vn(i);   %secondary sensor noise
    %both noises are correlated
end

xn=dn+v1;       % Recieved Signal

figure()
plot(1:200,xn(1:200));
hold on;
plot(1:200,dn(1:200),'r');
xlabel('Time'); ylabel('Amplitude'); grid on; axis tight;
legend('Signal with Primary Sensor Noise','Desired Signal');

figure();
plot(1:200,v2(1:200));
title('Plot of Secondary Sensor Noise');

rv2=AutoCorr(v2(1:200));

stem(rv2(20:39),'xr');
xlabel('Index');ylabel('Amplhitude');grid on; axis tight;
title('Autocorrelation of Secondary Sensor Noise Signal');

rxv2=CrossCorr(xn(1:200),v2(1:200));

figure();
stem(rxv2);
xlabel('Index');
title('Cross-correlation between Received Signal and Secondary Noise');grid on; axis tight;

% Order 8 Wiener Filter

order = 8;
Rv2 = zeros(order,order);
for i = 1: order
    count = i;
    for j = 1 : order
        Rv2(i,j) = rv2(count);
        if (j<i)
            count = count -1;
        else
            count = count +1;
        end
        
    end
end

wiener2 = Rv2\rxv2(1:order);

v1_est = conv(wiener2,v2);

d_est = xn - v1_est(1:N);

figure();
plot(d_est(1:200));
hold on
plot(dn(1:200),'r');
hold off;
title('Estimated Signal and Desired Signal for Order = 8');
xlabel('Time'); ylabel('Amplitude'); grid on; axis tight;
legend('Estimated Signal', 'Original Signal');
MSE_d_8 = mse(d_est,dn);
MSE_v1_8 = mse(v1_est,v1);
display(MSE_d_8);
display(MSE_v1_8);

% Order 64 Wiener Filter

order = 64;
Rv2 = zeros(order,order);
for i = 1: order
    count = i;
    for j = 1 : order
        Rv2(i,j) = rv2(count);
        if (j<i)
            count = count -1;
        else
            count = count +1;
        end
        
    end
end

wiener2 = Rv2\rxv2(1:order);

v1_est = conv(wiener2,v2);

d_est = xn - v1_est(1:N);

figure();
plot(d_est(1:200));
hold on
plot(dn(1:200),'r');
hold off;
title('Estimated Signal and Desired Signal for order 64');
xlabel('Time'); ylabel('Amplitude'); grid on; axis tight;
legend('Estimated Signal', 'Original Signal');
MSE_d_64 = mse(d_est,dn);
MSE_v1_64 = mse(v1_est,v1);
display(MSE_d_64);
display(MSE_v1_64);

