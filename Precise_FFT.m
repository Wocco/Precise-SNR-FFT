function [Result_FFT] = Precise_FFT(x,n0,nf,fs,f0)
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

%firstly calculate resolution, number of bins to provide the user with
%information about what the FFT is processing
x_segment = x(n0:(n0+nf-1));                                   %extracts a small segment of data from signal
N = length(x_segment);                                         %find the number of bins
NumberOfBins = 10000;
resolution = fs/NumberOfBins;
fprintf("The number of bins used in the fft is: %f \n This results in the following resolution: %f\n",NumberOfBins,resolution);



%Compute the FFT

Result_FFT = (1/N) * abs(fftshift(fft(x_segment,NumberOfBins)));
 
%go to RMS

Result_FFT = Result_FFT / sqrt(2);

%go to power (not in db yet)

Result_FFT = Result_FFT.^2;
SNR_V2(Result_FFT,fs)

%plot
Low_freq=(f0-fs/2);                                          %lowest frequency to plot
High_freq=(f0+fs/2);                                         %highest frequency to plot
freq=[0:1:NumberOfBins-1]*(fs)/NumberOfBins+Low_freq;
plot(freq,Result_FFT);
axis tight
xlabel('Freqency [Hz]','FontSize', 14)
ylabel('Vrms)','FontSize', 14)
grid on
set(gcf,'color','white');

end

