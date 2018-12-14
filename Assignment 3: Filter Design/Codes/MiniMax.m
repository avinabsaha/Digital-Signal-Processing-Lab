N = 60;             % Filter order
F = [0 0.5 0.6 1];  % Frequency vector
A = [1 1 0 0];      % Magnitude vector

b = firpm(N,F,A);

fvtool(b,'Analysis','freq');
title(['MiniMax Window of order ' num2str(N-1) '']);