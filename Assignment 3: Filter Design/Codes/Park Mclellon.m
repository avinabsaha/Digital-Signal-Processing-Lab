clear;

% The desired Filter has a pass band at (0-0.5) and
% (0.5+Delta(w)-0.7+(Delta(w)
% Delta(w) is varied between 0.1 and 0.3 times pi rads/sample
% Hamming window
b1 = fir1(54,0.5);
b2 = fir1(54,[0.8 0.9999999]);

b=b1+b2;
freqz(b,1,512);
title('FIR Filter Characteristics');


% Park-Mccllenan
f = [0.0 0.5 0.55 0.6 0.65 0.7 0.8 0.9 0.95 1.0];
a = [1.0 1.0 0.00 0.0 0.00 0.0 1.0 1.0 1.00 1.0];
b3 = firpm(54,f,a);

figure();
freqz(b3,1,512);
title('Park McClellan Characteristics');

