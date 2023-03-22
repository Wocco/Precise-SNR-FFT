function [signalpeak,signalfreq,noiselevel,SignaltoNoiseRatio] = SNR_of_FFT(FFT_result,fs,ENBW)
%SNR_of_FFT
%   Returns the signal peak and the location of that peak, noise level and
%   SNR
%           FFT_result  -- input fft of the signal

[value,index] = max(FFT_result)
signalpeak = value;
signalfreq = index;
%noisefloor 
sorted_FFT = sort(FFT_result);
noisefloor = mean(sorted_FFT(round(length(sorted_FFT)*0.15):round(length(sorted_FFT)*0.7)))
ENBW
noisefloor = noisefloor
noiselevel=noisefloor;
SignaltoNoiseRatio = signalpeak-noisefloor

end

