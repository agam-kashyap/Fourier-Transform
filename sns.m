clc;
close all;
clear all;
 
[y,Fs] = audioread('sns1.wav');
bits = audioinfo('sns1.wav').BitsPerSample;

x = y(:,1);

clear y;
N = length(x);

time = [1:N].*(1/Fs);

plot(time,x);
title('Original Audio Signal Channel 1- Time Domain');
xlabel('Samples');
ylabel('Amplitude');
grid on;
saveas(gcf,'original-time.png');

[X,f] = centeredFFT(x,Fs);

figure;
plot(f,abs(X));
title('Application of FFT to obtain Frequency Domain Plot(Magnitude)');
grid on;
xlabel('Frequency(Hz)');
ylabel('|X[k]|');
saveas(gcf,'original-freq.png');

fc = 4000;
fN = fc / ( Fs/2);
[b,a] = butter(10, fN, 'low');
x_Low = filtfilt(b, a, x);

figure;
freqz(b,a,bits,Fs/2);
grid on;

figure;
impz(b,a);
saveas(gcf,'impulselow.png');

[X_LOW,f_fft] = centeredFFT(x_Low,Fs);

figure;
plot(f_fft,abs(X_LOW));
title('FFT on Low-pass filtered Signal');
grid on;
xlabel('Frequency(Hz)');
ylabel('|X[k]|)');
saveas(gcf,'lowpass.png');

Y_LOW = ifft(X_LOW);
figure;
plot(time,Y_LOW);
grid on;
xlabel('samples');
ylabel('Amplitude');
saveas(gcf,'lowpassifft.png');
audiowrite('X_LOW.wav',Y_LOW,Fs);

[b,a] = butter(10, fN, 'high');
x_High = filtfilt(b, a, x);

figure;
freqz(b,a,bits,Fs/2);
grid on;

figure;
impz(b,a);
saveas(gcf,'impulsehigh.png');

[X_Hi,f_fft] = centeredFFT(x_High,Fs);

figure;
plot(f_fft,abs(X_Hi));
title('FFT on High-pass filtered Signal');
grid on;
xlabel('Frequency(Hz)');
ylabel('|X[k]|)');
saveas(gcf,'highpass.png');

Y_HI = ifft(X_Hi);
figure;
plot(time,Y_HI);
grid on;
xlabel('samples');
ylabel('Amplitude');
saveas(gcf,'highpassifft.png');
audiowrite('X_Hi.wav',Y_HI,Fs);

function [X,freq]=centeredFFT(x,Fs)
 N=length(x);
if mod(N,2)==0
    k=-N/2:N/2-1;
else
    k=-(N-1)/2:(N-1)/2;
end
T=N/Fs;
freq=k/T;
 X=fft(x)/N;
 X=fftshift(X);
end
