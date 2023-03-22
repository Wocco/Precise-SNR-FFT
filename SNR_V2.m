function [noise_level_dBm, signal_level_dBm,snr,CN0] = SNR_V2(fft,fs,center_freq,low_freq,high_freq)
%SNR_V2 Summary of this function goes here
%   Detailed explanation goes here

binsizefft = fs/length(fft)
lowest_bin_freq=center_freq-fs/2


lowest_bin_to_search = floor((low_freq-lowest_bin_freq)/binsizefft);
highest_bin_to_search = ceil((high_freq-lowest_bin_freq)/binsizefft);

noise_level = sum(fft)/length(fft);



[value,index] = max(fft(lowest_bin_to_search:highest_bin_to_search));
index = index+lowest_bin_to_search;

if get_channel_info(index*binsizefft+lowest_bin_freq)==true
    totalvalue=0;
    for i=-12:12
        totalvalue=totalvalue+fft(index+i);
    end

    noise_in_box=noise_level*24;

    noise_level_dBm=10*log10(noise_in_box/50*0.001); %calculate noise in db that is present in channel
    signal_level_dBm=10*log10(totalvalue/50*0.001); %calculate total power present in channel;
    snr = signal_level_dBm-noise_level_dBm;
    CN0 = snr + 10*log10(24*binsizefft);
else
    disp("not an orbcomm channel!")
    noise_level_dBm=0;
    signal_level_dBm=0;
    snr=0;
    CN0=0;
end

end

