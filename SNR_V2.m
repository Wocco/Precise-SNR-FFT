function [noise_level_dBm, signal_level_dBm,snr,CN0] = SNR_V2(fft,fs,center_freq,low_freq,high_freq,Nofsat)
%SNR_V2 Calculates the SNR of a signal
%   Detailed explanation goes here

binsizefft = fs/length(fft);
lowest_bin_freq=center_freq-fs/2;


lowest_bin_to_search = floor((low_freq-lowest_bin_freq)/binsizefft);
highest_bin_to_search = ceil((high_freq-lowest_bin_freq)/binsizefft);

sorted_fft=sort(fft);
relevant_bins_for_noise = sorted_fft(1:floor(length(sorted_fft)-length(sorted_fft)*2*Nofsat*0.0025));

noise_level = mean(relevant_bins_for_noise);



[value,index] = max(fft(lowest_bin_to_search:highest_bin_to_search));
index = index+lowest_bin_to_search;

totalvalue=0;
for i=-13:12
    totalvalue=totalvalue+fft(index+i);
end

noise_in_box=noise_level*25;

noise_level_dBm=10*log10(noise_in_box/50*0.001); %calculate noise in db that is present in channel
signal_level_dBm=10*log10(totalvalue/50*0.001); %calculate total power present in channel;
snr = signal_level_dBm-noise_level_dBm;
CN0 = snr + 10*log10(25*binsizefft);

end

