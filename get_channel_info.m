function [low_freq,high_freq,channel] = get_channel_info(frequency)
% Gives the channel number of a frequency and it's respective high and low frequency
%   
    

    dif = frequency-137E6;
    N = floor(dif/0.0025E6);
    if N>=80 && N<=320
        if N>=149 && N<=170
            disp("this is not aan ORBCOMM channel but Meteor on 137.4 MHz")
        elseif N>=190 && N<=210
            disp("this is not aan ORBCOMM channel but NOAA APT on 137.5 MHz")
        elseif N>=238 && N<=238
            disp("this is not aan ORBCOMM channel but NOAA APT 137.62 MHz")
        else
            disp("This is an ORBCOMM channel")
            low_freq = 137E6 + N*0.0025E6;
            high_freq=137E6 + (N+1)*0.0025E6;
        end
    end
channel = N;
end

