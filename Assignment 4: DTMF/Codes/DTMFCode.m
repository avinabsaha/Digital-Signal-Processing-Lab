% Avinab Saha 15EC10071
% DSP Lab Assignment Code
% DTMF Encoder-Decoder

clear;
% Duration 250 ms
t = 0:1/4000:0.25-(1/4000);   
y = zeros(128,length(t));

% Symbols
tab = ['1','2','3','a','4','5','6','b','7','8','9','c','*','0','#','d']; 
% Frequencies associated
F1 = [697,770,852,941];
F2 = [1209,1336,1447,1633];

% Design 8 Bandpass filters
% Length of window is fixed to be 101
order = 100;  
L = order+1;
h1 = 0.02*cos(2*pi*697*t);
h2 = 0.02*cos(2*pi*770*t);
h3 = 0.02*cos(2*pi*852*t);
h4 = 0.02*cos(2*pi*941*t);

H1 = 0.02*cos(2*pi*1209*t);
H2 = 0.02*cos(2*pi*1336*t);
H3 = 0.02*cos(2*pi*1477*t);
H4 = 0.02*cos(2*pi*1633*t);

% Limiting to 101 length or 100th order
h1((t*4000) >= L) = 0;
h2((t*4000) >= L) = 0;
h3((t*4000) >= L) = 0;
h4((t*4000) >= L) = 0;

H1((t*4000) >= L) = 0;
H2((t*4000) >= L) = 0;
H3((t*4000) >= L) = 0;
H4((t*4000) >= L) = 0;


% Plotting Frequency Response Of the FIR Filters
fvtool(h1,'Analysis','freq')
grid on; grid minor; axis tight;
title('Bandpass filter at 697 Hz or 0.3485\pi (Normalized)');
legend('Magnitude','Phase');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');

fvtool(h2,'Analysis','freq')
grid on; grid minor; axis tight;
title('Bandpass filter at 770 Hz or 0.3850\pi (Normalized)');
legend('Magnitude','Phase');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');

fvtool(h3,'Analysis','freq')
grid on; grid minor; axis tight;
title('Bandpass filter at 852 Hz or 0.4260\pi (Normalized)');
legend('Magnitude','Phase');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');

fvtool(h4,'Analysis','freq')
grid on; grid minor; axis tight;
title('Bandpass filter at 941 Hz or 0.4705\pi (Normalized)');
legend('Magnitude','Phase');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');

fvtool(H1,'Analysis','freq')
grid on; grid minor; axis tight;
title('Bandpass filter at 1209 or 0.6045\pi (Normalized) Hz');
legend('Magnitude','Phase');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');

fvtool(H2,'Analysis','freq')
grid on; grid minor; axis tight;
title('Bandpass filter at 1336 or 0.6680\pi (Normalized) Hz');
legend('Magnitude','Phase');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');

fvtool(H3,'Analysis','freq')
grid on; grid minor; axis tight;
title('Bandpass filter at 1477 Hz or 0.7385\pi (Normalized)');
legend('Magnitude','Phase');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');

fvtool(H4,'Analysis','freq')
grid on; grid minor; axis tight;
title('Bandpass filter at 1633 Hz or 0.8165\pi (Normalized)');
legend('Magnitude','Phase');
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');


% Input SNR Values
SNR = input('Value of SNR in dB = ');   

noOfErrors = 0;
for loop = 1:100
    % Generate a random number between 1 and 16
    val = rand(1,128)*16;
    inputsymbol = zeros(1,128);
    receivedsymbol = zeros(1,128);
    inputsymbol(val>=0 & val<1)='1';
    inputsymbol(val>=1 & val<2)='2';
    inputsymbol(val>=2 & val<3)='3';
    inputsymbol(val>=3 & val<4)='4';
    inputsymbol(val>=4 & val<5)='5';
    inputsymbol(val>=5 & val<6)='6';
    inputsymbol(val>=6 & val<7)='7';
    inputsymbol(val>=7 & val<8)='8';
    inputsymbol(val>=8 & val<9)='9';
    inputsymbol(val>=9 & val<10)='*';
    inputsymbol(val>=10 & val<11)='0';
    inputsymbol(val>=11 & val<12)='#';
    inputsymbol(val>=12 & val<13)='a';
    inputsymbol(val>=13 & val<14)='b';
    inputsymbol(val>=14 & val<15)='c';
    inputsymbol(val>=15 & val<=16)='d';
    
    
    signal = zeros(128,length(t));
    transmitted = zeros(128,length(t));
    for i =1:128
        pos = find(tab==inputsymbol(i))-1;
        f1 = F1(floor(pos/4)+1);
        f2 = F2(mod(pos,4)+1);
        signal(i,:) = cos(2*pi*f1*t)+cos(2*pi*f2*t);
        transmitted(i,:) = awgn(signal(i,:),SNR,'measured');
    end
    
    % Passing the symbols through the filter banks
    for i =1:128
        p1 = filter(h1,1,transmitted(i,:));
        p2 = filter(h2,1,transmitted(i,:));    
        p3 = filter(h3,1,transmitted(i,:));
        p4 = filter(h4,1,transmitted(i,:));    
        P1 = filter(H1,1,transmitted(i,:));
        P2 = filter(H2,1,transmitted(i,:));    
        P3 = filter(H3,1,transmitted(i,:));
        P4 = filter(H4,1,transmitted(i,:)); 

        e=[mean(p1.*p1),mean(p2.*p2),mean(p3.*p3),mean(p4.*p4)];
        E=[mean(P1.*P1),mean(P2.*P2),mean(P3.*P3),mean(P4.*P4)];
        m = find(e==max(e));
        n = find(E==max(E));
        receivedsymbol(i)=tab((4*(m-1))+n);
        if(inputsymbol(i)~=receivedsymbol(i))
            noOfErrors=noOfErrors+1;
        end
    end
end
fprintf('Average No of errors for SNR = %f dB is %f\n',SNR,noOfErrors/100);


% Plotting transmitted and received signal
figure();
plot(t*1000,signal(5,:),t*1000,transmitted(5,:));
legend('Transmitted','Received');
xlabel({'Time','(ms)'});
ylabel ('Amplitude');
title(['Transmitted and Received signal SNR = ',num2str(SNR),' dB']);
set(gca, 'FontName', 'Consolas','fontsize',12,'FontWeight','bold');
grid on; grid minor;




