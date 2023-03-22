function [Result_FFT] = Corrected_FFT(x,n0,nf,fs,f0)
%
%  plot_FFT_IQ(x,n0,nf)
%
%  Plots the FFT of sampled IQ data
%
%                x  -- input signal
%                n0 -- first sample (start time = n0/fs)
%                nf -- block size for transform (signal duration = nf/fs)
%                fs -- sampling frequency [MHz] 
%                f0 -- center frequency [MHz]
%
%-This extracts a segment of x starting at n0, of length nf, and plots the FFT.
% Source: Scholl, S. (2016) Exact Signal Measurements using FFT Analysis, Microelectronic Systems Design Research Group, p. 10. Available at: http://nbn-resolving.de/urn:nbn:de:hbz:386-kluedo-42930.
% Source: https://www.aaronscher.com/wireless_com_SDR/RTL_SDR_AM_spectrum_demod.html
% Vrms of IQ samples https://www.tek.com/en/blog/calculating-rf-power-iq-samples

x_segment=x(n0:(n0+nf-1));                                   %extracts a small segment of data from signal
NumberOfBins=length(x_segment);                              %find the number of bins
NumberOfBins = 4096;
fprintf("The number of bins used in the fft is: %f \n This results in the following resolution: %f\n",NumberOfBins,fs/NumberOfBins);
x_segment_windowed=x_segment.*flattopwin(length(x_segment)); % apply windowing & convert to Vrms

p=(1/NumberOfBins)*fftshift(fft(x_segment_windowed/2,NumberOfBins)) %find FFT of IQ data
%p_dBm=abs(p)
p_dBm = 10*log10((abs(p)/2).^2/50*0.001);                           %Circuit is matched to 50 ohms

Processing_Gain= 10*log10(NumberOfBins/2);
fprintf("The processing gain is %f dB\n",Processing_Gain);


Low_freq=(f0-fs/2);                                          %lowest frequency to plot
High_freq=(f0+fs/2);                                         %highest frequency to plot
N=length(p_dBm);
freq=[0:1:N-1]*(fs)/N+Low_freq;

[signalpeak,signalfreq,noiselevel,SignaltoNoiseRatio] = SNR_of_FFT(p_dBm,fs,enbw(flattopwin(length(x_segment)),fs)); %calculate the snr to plot

plot(freq,p_dBm);
axis tight
xlabel('Freqency [Hz]','FontSize', 14)
ylabel('dBm','FontSize', 14)
grid on
set(gcf,'color','white');
hold on
%Add noise line
yline(noiselevel)
plot(signalfreq*(fs)/N+Low_freq,signalpeak,'r*')

hold off
Result_FFT = p_dBm;


end

