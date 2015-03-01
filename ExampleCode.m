%      ExampleCode.m

%  UCD   Advanced Signal Processing

% Example Matlab code illustrating some techniques that can be used in
% Assignment 1  2015

nfreq = 1024;  % No. of frequency points for plotting and analysing magnitude repsponse
nbit = 9;  % coefficient wordlength including sign bit
maxval = 2^(nbit-1) - 1; %Maximum integer value possible using sign magnitude representation


% Example Filter Specifications (a bandstop filter)
Fs = 2;  % Sampling Frequency
N      = 42;    % Order
Fpass1 = 0.35;  % First Passband Frequency
Fstop1 = 0.45;  % First Stopband Frequency
Fstop2 = 0.65;  % Second Stopband Frequency
Fpass2 = 0.75;  % Second Passband Frequency
Wpass1 = 1;     % First Passband Weight
Wstop  = 5;     % Stopband Weight
Wpass2 = 1;     % Second Passband Weight
dens   = 20;    % Density Factor

% Calculate the coefficients using the FIRPM function:
b  = firpm(N, [0 Fpass1 Fstop1 Fstop2 Fpass2 Fs/2]/(Fs/2), [1 1 0 0 1 1], [Wpass1 Wstop Wpass2], {dens});

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

%Quantise the coefficients:
bqI = round(bs);  %Rounded scaled coefficients  (all are now integers)

bq = bqI/bscale;  %Scaling removed (coeffs are no longer integers but are still quantised)

% Plot the magnitude response of the filter with quantised coefficients
zf = abs(fft(bq,nfreq));  
plot(f,20*log10(zf(1:513)),'r')
grid on
xlabel('Normalised Frequency')
ylabel('Gain dB')
title('Magnitude of a Bandstop Filter before and after Coeficient Rounding')
legend('Before Coefficient Quantisation','After Coefficient Quantisation','Location','SouthWest')

figure
stem(bqI)
xlabel('Sample No.')
ylabel('Sample Value')
title('Impulse Respose of filter with Integer (quantised) Coefficients')

grid on



