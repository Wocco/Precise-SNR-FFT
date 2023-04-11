clear variables;
%fill in these fields
filename="07-Apr-2023 111335.011 137.500MHz.wav";
center_freq=137.5E6; %in MHz
SearchLowFreq= 137.725E6;
SearchHighFreq= 137.765E6;
numberOfSatsInView=1;
Excelname = 'FM10 Measurement 27 march';

SDR=audioread(filename,[1,2]);
info = audioinfo(filename)
sampleRate= info.SampleRate;
RecordingTime = info.TotalSamples/sampleRate;
get_channel_info((SearchLowFreq+SearchHighFreq)/2); %give info about if this is an ORBCOMM channel


for i = 0:1:floor(RecordingTime-1)
     if i==0
         SDR=audioread(filename,[1,1*sampleRate]);
         IQData = (SDR(:,1)+1i*SDR(:,2)); %Get the IQ data from the columns and put them togheter as a complex value
         [fft_power, fft_dBm] = Precise_FFT_plot(IQData,1,sampleRate,sampleRate,center_freq);
         [noise_level_dBm(i+1),signal_level_dBm(i+1),snr(i+1), CN0(i+1)] = SNR_V2(fft_power,sampleRate,center_freq,SearchLowFreq,SearchHighFreq,numberOfSatsInView);
     else
         SDR=audioread(filename,[i*sampleRate,(i+1)*sampleRate]);
         IQData = (SDR(:,1)+1i*SDR(:,2)); %Get the IQ data from the columns and put them togheter as a complex value
         [fft_power, fft_dBm] = Precise_FFT(IQData,1,sampleRate,sampleRate,center_freq);
         [noise_level_dBm(i+1),signal_level_dBm(i+1),snr(i+1), CN0(i+1)] = SNR_V2(fft_power,sampleRate,center_freq,SearchLowFreq,SearchHighFreq,numberOfSatsInView);
     end
end


time=linspace(1,length(CN0),length(CN0));
plot(time,CN0)
figure
average5samples = ones(1,5)/5;
averaged_CN0 = filter(average5samples,1,CN0);
plot(time,averaged_CN0)

%write to excel file
OutputFile = strcat(Excelname,'.xlsx');
write_to_excel(:,1) = time';
write_to_excel(:,2) = CN0';
write_to_excel(:,3) = averaged_CN0';
writematrix(write_to_excel,OutputFile);