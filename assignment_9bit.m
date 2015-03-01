close all;
%ASSIGNMENT_9BIT Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.3 and the DSP System Toolbox 8.6.
% Generated on: 28-Feb-2015 21:56:16

nfreq = 1024;  % No. of frequency points for plotting and analysing magnitude repsponse
nbit = 9;  % coefficient wordlength including sign bit
maxval = 2^(nbit-1) - 1; %Maximum integer value possible using sign magnitude representation
berr = zeros(1,64);
% Equiripple Bandpass filter designed using the FIRPM function.

% All frequency values are in Hz.
Fs = 2;  % Sampling Frequency

Fstop1 = 0.212890625;     % First Stopband Frequency
Fpass1 = 0.271484375;     % First Passband Frequency
Fpass2 = 0.505859375;     % Second Passband Frequency
Fstop2 = 0.564453125;     % Second Stopband Frequency
Dstop1 = 0.00177827941;   % First Stopband Attenuation
Dpass  = 0.057501127785;  % Passband Ripple
Dstop2 = 0.0177827941;    % Second Stopband Attenuation
dens   = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 ...
                          0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});

% Plot magnitude response when high precision coefiicients are used:
zf = abs(fft(b,nfreq));  %Samples of the DTFT
f = [0:512]/512;
plot(f,20*log10(zf(1:513))) 
hold on

% Scale coefficients so that magnitude of coefficient with largest
% magnitude equals maxval:
maxb = max(abs(b));
bscale = maxval/maxb;   % Scaling factor
bs = b*bscale;  %Scaled coefficients

for i = 1:512
    
    for i = 1:139
    if(zf < 0.002)
        count1 += 0;
    else
        count1 += 1;
    end
    
    for i = 239:359
        if(zf < 0.9)
            count2 += 0;
        else
            count2 += 1;
        end
     
        for i = 389:512
            if(zf < 0.032)
                count3 += 0;
            else
                count3 += 1;
            end
        end

% Hello%
% %Quantise the coefficients:
bqI = round(bs);  %Rounded scaled coefficients  (all are now integers)

bq = bqI/bscale;  %Scaling removed (coeffs are no longer integers but are still quantised)

% Plot the magnitude response of the filter with quantised coefficients
zf = abs(fft(bq,nfreq));  
plot(f,20*log10(zf(1:513)),'r')
grid on
xlabel('Normalised Frequency')
ylabel('Gain dB')
title('Magnitude of a Bandpass Filter before and after Coeficient Rounding')
legend('Before Coefficient Quantisation','After Coefficient Quantisation','Location','SouthWest')

figure
stem(bqI)
xlabel('Sample No.')
ylabel('Sample Value')
title('Impulse Respose of filter with Integer (quantised) Coefficients')

grid on

% [EOF]
