function SWRs = detectSWRs(signal, dt)
    % detectSWRs - Detects sharp wave ripple (SWR) events in a given signal.
    %
    % Syntax:
    %   SWRs = detectSWRs(signal, dt)
    %
    % Inputs:
    %   signal - The input signal, typically a neural signal to be processed.
    %   dt     - The time step (sampling period) of the signal in milliseconds.
    %
    % Outputs:
    %   SWRs   - A 2xN matrix, where N is the number of detected SWR events.
    %            The first row contains the start times (in samples) of the events,
    %            and the second row contains the durations (in samples) 
    %            of the corresponding events.
    %
    % Description:
    %   This function detects sharp wave ripple (SWR) events in the input signal 
    %   by computing the root mean square (RMS) of the signal and applying a Gaussian 
    %   window to smooth the RMS signal. The function identifies SWR events based on 
    %   a threshold derived from the mean and standard deviation of the smoothed signal.
    %   Each SWR event is defined as a sequence of signal values exceeding the threshold
    %   for a specified duration.
    %
    %   The threshold for SWR detection is set to the median of the smoothed signal 
    %   plus 1.2 times the standard deviation. The function returns the start times and
    %   durations of the detected SWR events in terms of sample indices.
    %
    % Notes:
    %   - The Gaussian window applied to the RMS signal has a default window size of 50 ms.
    %   - The minimum duration of an SWR event is set to 30 ms.
    
    % Compute the squared signal for RMS calculation
    signal = signal.^2;

    % Set the window size for moving average (10 ms)
    window_size = 10 / dt;  % 10 ms window size
    window = ones(1, window_size) / window_size;

    % Compute the moving average (RMS of the signal)
    moving_average = conv(signal, window, 'same');
    RMS_signal = sqrt(moving_average);

    % Apply a 50 ms Gaussian window to smooth the RMS signal
    w_ripple = gausswin(50 / dt, 0.65);
    ripple = conv(RMS_signal, w_ripple, 'same');

    % Compute the standard deviation and median of the ripple signal
    std_ripple = std(ripple);
    mean_ripple = median(ripple);

    % Define the detection threshold
    th = mean_ripple + 1.2 * std_ripple;

    % Initialize variables to store the event start times and durations
    SWRs_event = [];
    SWRs_durations = [];

    % Start iterating through the signal to detect SWR events
    i = 1;
    con_time = int32(30 / dt);  % Duration threshold for event (30 ms)

    % Loop through the signal to detect events
    while i <= (length(signal) - con_time)
        if ripple(i) >= th  % If the ripple exceeds the threshold
            tag = 0;
            temp = ripple(i + 1 : i + con_time);
            if min(temp) >= th  % Check if the event continues for the required duration
                tag = 1;
            end
            n = i + con_time + 1;

            if n < length(ripple)
                if tag == 1
                    % Find the end of the event
                    while true
                        if (ripple(n) < th) || (n == length(ripple))
                            break
                        else
                            n = n + 1;
                        end
                    end
                end
                if n == (i + con_time + 1)
                    i = i + 1;
                else
                    % Store the start time and duration of the detected event
                    SWRs_event(end + 1) = i;
                    SWRs_durations(end + 1) = n - i;
                    i = n;
                end
            else
                i = i + 1;
            end
        else
            i = i + 1;
        end
    end

    % Return the SWR event start times and durations as a 2xN matrix
    SWRs = zeros(2, length(SWRs_event));
    SWRs(1, :) = SWRs_event;  % Event start times (in samples)
    SWRs(2, :) = SWRs_durations;  % Event durations (in samples)
end