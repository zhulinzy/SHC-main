function filtered_data = bandpassFilter(data, lowcut, highcut, fs, n)
    % bandpassFilter - Applies a bandpass filter to the input data.
    %
    % Syntax: 
    %   filtered_data = bandpassFilter(data, lowcut, highcut, fs, n)
    %
    % Inputs:
    %   data   - The input signal to be filtered (1D array).
    %   lowcut - The lower cutoff frequency of the bandpass filter (Hz).
    %   highcut - The upper cutoff frequency of the bandpass filter (Hz).
    %   fs     - The sampling frequency of the input data (Hz).
    %   n      - The order of the Butterworth filter.
    %
    % Outputs:
    %   filtered_data - The filtered signal (same size as the input data).
    %
    % Description:
    %   This function applies a zero-phase bandpass Butterworth filter to the
    %   input data using the specified cutoff frequencies and filter order. 
    %   The filter is designed using the 'butter' function, and the 
    %   'filtfilt' function is used to apply the filter in both forward and
    %   reverse directions to avoid phase distortion.
    %
    % Example:
    %   filtered_data = bandpassFilter(signal, 0.5, 50, 1000, 4)
    %   % This applies a 4th-order bandpass filter with a passband from 0.5 Hz to 50 Hz,
    %   % to a signal sampled at 1000 Hz.

    % Design the Butterworth filter
    [b, a] = butter(n, [lowcut highcut] / (0.5 * fs), 'bandpass');
    
    % Apply the filter to the data using filtfilt to avoid phase distortion
    filtered_data = filtfilt(b, a, data);
end