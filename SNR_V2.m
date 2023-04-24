function [noise_level_dBm, signal_level_dBm,snr,CN0, PeakFreqBin] = SNR_V2(fft,fs,center_freq,low_freq,high_freq,Nofsat)
%SNR_V2 Calculates the SNR of an orbcomm channel, Searches the energy peak
%in between two given ranges and sums the neighboring bins afterwards it
%calculates CN0 & SNR
%   Input:
%   fft -> the fft data of the to be calculated snr
%   fs -> Sampling frequency
%   Center_freq -> The center frequency of the SDR
%   low_freq -> The lower bound in which the program searches
%   for a maxima
%   high_freq -> The upper bound in which the program searches for a maxima
%   Nofsat -> The amounth of satellites in view
%   Output:
%   noise_level_dBm -> The noise floor in dBm
%   signal_level_dBm -> The signal level in dBm
%   snr -> Signal To Noise ratio in dB,calculated for a 2.5KHz BW
%   ORBCOMM Channel
%   CN0 -> Carrier to noise density in dBHz, calculated for a 2.5KHz BW
%   ORBCOMM Channel

binsizefft = fs/length(fft);
lowest_bin_freq=center_freq-fs/2;


lowest_bin_to_search = floor((low_freq-lowest_bin_freq)/binsizefft);
highest_bin_to_search = ceil((high_freq-lowest_bin_freq)/binsizefft);

sorted_fft=sort(fft);
relevant_bins_for_noise = sorted_fft(1:floor(length(sorted_fft)-length(sorted_fft)*2*Nofsat*0.025));
noise_level= mean(relevant_bins_for_noise);

n0 = noise_level/100;

[~,index] = max(fft(lowest_bin_to_search:highest_bin_to_search));
index = index+lowest_bin_to_search;

totalvalue=0;
for i=-35:35
    totalvalue=totalvalue+fft(index+i);
end
noise_in_box = noise_level*71;

noise_level_dBm = 10*log10(noise_in_box/50/0.001); %calculate noise in db that is present in channel
signal_level_dBm = 10*log10(totalvalue/50/0.001); %calculate total power present in channel;

snr = signal_level_dBm-noise_level_dBm;
%snr2 = 10*log10((totalvalue/noise_in_box)/50/0.001);
%CN0 = (totalvalue/noise_in_box)*2500;
%CN0 = 10*log10(CN0/50);
CN0 = snr + 10*log10(250*binsizefft);
PeakFreqBin = index*100;
PeakFreqBin = lowest_bin_freq +PeakFreqBin;
end

