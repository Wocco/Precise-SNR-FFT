function [noise_level, signal_level,snr] = SNR_V2(fft,fs)
%SNR_V2 Summary of this function goes here
%   Detailed explanation goes here

noise_level = sum(fft)/length(fft)
10*log10(noise_level/50*0.001) %dBm

noise_in_box=0;
[value,index] = max(fft)
totalvalue=0;
for i=-10:10
    totalvalue=totalvalue+fft(index+i)
    
end
noise_in_box=noise_level*20;
n=10*log10(noise_in_box/50*0.001) %dBm
pow=10*log10(totalvalue/50*0.001) %dBm
signal_level = 0;
snr = 0;
end

