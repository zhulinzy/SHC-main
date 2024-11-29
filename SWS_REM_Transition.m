% ----------------------------------------------------------
% SWS-REM Transition
%
% The analysis for the transition dynamics of sleep states 
% through the driving effects of the cholinergic inputs to
% hippocampal oscillations
%
% This code simulates and visualizes cholinergic-driven sleep transitions 
% (SWS-REM) in the SHC model. It focuses on the dynamics of sleep state 
% transitions driven by cholinergic inputs to hippocampal oscillations.
%
% Key components of the simulation:
%   - CA1 pyramidal neuron membrane potential traces
%   - Cholinergic neuron membrane potential traces
%   - Ripple oscillation traces (100-250 Hz)
%   - Theta oscillation traces(4-12 Hz)
%
% Sharp Wave Ripples (SWRs) are detected and visualized within the ripple 
% oscillations. The transitions between different sleep states are 
% highlighted with shaded regions on the plots.
%
% ----------------------------------------------------------

addpath('./utils'); 

% ----------------------------------------------------------
% Load Data
% ----------------------------------------------------------

load('SWS_REM_Transition.mat')  % Load the dataset

% ----------------------------------------------------------
% Signal Processing Parameters Initialization
% ----------------------------------------------------------

h = 0.1;  % Step size (ms)

% Duration of each phase (in seconds)
SWS_duration = 12;  % SWS duration
REM_duration = 12;  % REM duration
STP_duration = 2;   % STP duration

% Calculate the number of samples for each phase (based on step size and sampling rate)
SWS_duration_samples = (1 * 12 * 1000) / h; 
REM_duration_samples = (1 * 12 * 1000) / h;  
STP_duration_samples = 2000 / h;  % STP duration in samples

% Calculate the sampling frequency
fs = 1000 / h;  % Sampling frequency (Hz)
window_size = 2;  % Window size in seconds

% ----------------------------------------------------------
% Signal Extraction and Filtering
% ----------------------------------------------------------

% Extract LFP (local field potential) and V_ch (cholinergic neuron firing) signals
lfp = X(4, :);      % LFP signal (from the 4th row of X)
V_ch = X(7, :);     % Cholinergic neuron firing signal (from the 7th row of X)

% Apply bandpass filtering to LFP to extract ripple (100-250 Hz) and theta (4-12 Hz) oscillations
ripple = bandpassFilter(lfp, 100, 250, fs, 4);       
filtered_theta = bandpassFilter(lfp, 4, 12, fs, 3);  

% ----------------------------------------------------------
% Signal Segmentation and Alignment
% ----------------------------------------------------------

% Compute the number of samples corresponding to the window size
window_samples = window_size * fs;  % Convert to samples

% Determine the number of valid samples, excluding the last window to reduce edge effects
num_samples = length(lfp) - window_samples; 

% Segment the signals to ensure consistent signal length by removing the last window
lfp1 = lfp(1:num_samples);         
V_ch = V_ch(1:num_samples);        
ripple = ripple(1:num_samples);     
filtered_theta = filtered_theta(1:num_samples); 

% Create time vector (in seconds)
t = (0:num_samples-1) / fs; 

% ----------------------------------------------------------
% Set up Figure and Subplot Parameters
% ----------------------------------------------------------

FontSize = 12;  % Font size for plots
figure; 
set(gcf, 'Position', [84.2, 197.8, 934.4, 343.2]);  % Set figure size

plot_height = 0.15;  % Height of each subplot
bottom = 0.1;        % Vertical start position of the first subplot
gap = 0.03;          % Vertical gap between adjacent subplots

% ----------------------------------------------------------
% Subplot 1：CA1 Pyramidal Neuron Membrane Potential Traces
% ----------------------------------------------------------

ax1 = axes('Position', [0.1, bottom + 3*plot_height + 3*gap, 0.7, plot_height]); 
hold(ax1, 'on');
h1 = plot(ax1, t, lfp1, 'Color', '#1f77b4', 'LineWidth', 1);
set(ax1, 'Box', 'off', 'XColor', 'none', 'YColor', 'none', 'Color', 'none');
set(ax1, 'YTick', []); 
set(ax1, 'YTickLabel', []); 
yticks(ax1, []);
y_lim1 = get(ax1, 'YLim'); 
line([-0.5 -0.5], [(y_lim1(1) + 2) (y_lim1(1) + 12)], 'Color', 'k', 'LineWidth', 1.5, 'Parent', ax1);
text(-0.6, ((y_lim1(1)+2) + (y_lim1(1)+12)) / 2, '10 mV', 'HorizontalAlignment', ...
    'right', 'VerticalAlignment', 'middle', 'FontSize', FontSize, 'FontName', 'Arial', 'Parent', ax1);
leg1 = legend(ax1, h1, 'E CA1', 'Location', 'northeastoutside');
set(leg1, 'FontSize', FontSize, 'FontName', 'Arial', 'Box', 'off', ...
    'Position', [0.842, 0.662, 0.104, 0.065]);

% ----------------------------------------------------------
% Subplot 2：Cholinergic Neuron Membrane Potential Traces
% ----------------------------------------------------------

ax2 = axes('Position', [0.1, bottom + 2*plot_height + 2*gap, 0.7, plot_height]);
hold(ax2, 'on');
h2 = plot(ax2, t, V_ch, 'Color', '#ff7f0e', 'LineWidth', 1);
set(ax2, 'Box', 'off', 'XColor', 'none', 'YColor', 'none', 'Color', 'none');
set(ax2, 'YTick', []); 
set(ax2, 'YTickLabel', []);
yticks(ax2, []); 
y_lim2 = get(ax2, 'YLim'); 
line([-0.5 -0.5], [(y_lim2(1) + 2) (y_lim2(1) + 37)], 'Color', 'k', 'LineWidth', 1.5, 'Parent', ax2);
text(-0.6, ((y_lim1(1) + 2) + (y_lim1(1) + 37)) / 2, '35 mV', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'middle', 'FontSize', FontSize, 'FontName', 'Arial', 'Parent', ax2);
leg2 = legend(ax2, h2, 'MS-Ch', 'Location', 'northeastoutside');
set(leg2, 'FontSize', FontSize, 'FontName', 'Arial', 'Box', 'off', ...
    'Position', [0.842, 0.501, 0.109, 0.065]);

% ----------------------------------------------------------
% Subplot 3：Ripple Oscillation Traces (100-250 Hz) & SWRs
% ----------------------------------------------------------

% Detect SWRs for SWS and REM
% Note that no SWRs are detected during REM, so it is omitted in the analysis.
SWRs_1 = detectSWRs(ripple(1:(SWS_duration_samples + STP_duration_samples)), h);
SWRs_2 = detectSWRs(ripple((SWS_duration_samples + STP_duration_samples + REM_duration_samples)... 
    :(2*SWS_duration_samples + 2*STP_duration_samples + REM_duration_samples)), h);

% Adjust SWRs index for the second period
SWRs_2(1, :) = SWRs_2(1, :) - 1 + (SWS_duration_samples + STP_duration_samples + REM_duration_samples);

% Calculate the middle points of detected SWRs for both periods
SWRs_time1 = floor((SWRs_1(1,:) + SWRs_1(2,:) + SWRs_1(1,:)) / 2); 
SWRs_time2 = floor((SWRs_2(1,:) + SWRs_2(2,:) + SWRs_2(1,:)) / 2); 

% Combine the times for both periods and convert to seconds
SWRs_time = [SWRs_time1, SWRs_time2] / fs;

% Label SWRs
SWRs_time_label = 4 * ones(1,length(SWRs_time)); 

ax3 = axes('Position', [0.1, bottom + plot_height + gap, 0.7, plot_height]);
hold(ax3, 'on');
h3 = plot(ax3, t, ripple, 'Color', '#2ca02c', 'LineWidth', 1);
h3_ = plot(ax3, SWRs_time, SWRs_time_label, 'r*', 'MarkerSize', 5);
set(ax3, 'Box', 'off', 'XColor', 'none', 'YColor', 'none', 'Color', 'none');
set(ax3, 'YTick', []); 
set(ax3, 'YTickLabel', []); 
yticks(ax3, []);
y_lim3 = get(ax3, 'YLim');
line([-0.5 -0.5], [-2 2], 'Color', 'k', 'LineWidth', 1.5, 'Parent', ax3); % 竖线表示刻度
text(-0.6, 0, '4 mV', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'middle', 'FontSize', FontSize, 'FontName', 'Arial', 'Parent', ax3);
legend([h3 h3_], {'(100-250 Hz)', 'SWR'}, 'Location', 'northeastoutside', ...
    'FontSize', FontSize, 'FontName', 'Arial', 'Box', 'off', 'EdgeColor', 'none', ...
    'Position', [0.842, 0.299, 0.155, 0.120]);

% ----------------------------------------------------------
% Subplot 4：Theta Oscillation Traces(4-12 Hz)
% ----------------------------------------------------------

ax4 = axes('Position', [0.1, bottom, 0.7, plot_height]);
hold(ax4, 'on');
h4 = plot(ax4, t, filtered_theta, 'Color', '#9467bd', 'LineWidth', 1);
set(ax4, 'Box', 'off', 'XColor', 'k', 'YColor', 'none','Color', 'none');
set(ax4, 'YTick', []); 
set(ax4, 'YTickLabel', []); 
yticks(ax4, []); 
y_lim4 = get(ax4, 'YLim');
line([0.6 1.6], [-6 -6], 'Color', 'k', 'LineWidth', 1.5, 'Parent', ax4); 
text(1.6, -9, '1s', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'middle', 'FontSize', FontSize, 'FontName', 'Arial', 'Parent', ax4);
line([-0.5 -0.5], [-3 3], 'Color', 'k', 'LineWidth', 1.5, 'Parent', ax4); 
text(-0.6, 0, '6 mV', 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'middle', 'FontSize', FontSize, 'FontName', 'Arial', 'Parent', ax4);
leg4 = legend(ax4, h4, '(4-12 Hz)', 'Location', 'northeastoutside');
set(leg4, 'FontSize', FontSize, 'FontName', 'Arial', 'Box', 'off', ...
    'Position', [0.842, 0.139, 0.126, 0.065]); 

% ----------------------------------------------------------
% Label Different Phases (SWS, REM, STP)
% ----------------------------------------------------------

ax5 = axes('Position', [0.1, bottom + 4*plot_height + 4*gap + 0.02, 0.7, 0.05]); 
hold(ax5, 'on');

% SWS period (before transition, 0-12 s)
fi1 = fill([0 SWS_duration SWS_duration 0], [0 0 3 3], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% REM period (14-26 s)
fi2 = fill([(SWS_duration + STP_duration) (SWS_duration + STP_duration + REM_duration)...
    (SWS_duration + STP_duration + REM_duration) (SWS_duration + STP_duration)], [0 0 3 3],...
    'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% SWS period (after transition, 28-40 s)
fi3 = fill([(SWS_duration + 2*STP_duration + REM_duration) (SWS_duration + 2*STP_duration + 2*REM_duration)...
    (SWS_duration + 2*STP_duration + 2*REM_duration) (SWS_duration + 2*STP_duration + REM_duration)], [0 0 3 3],...
    'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% STP period (12-14s; 26-28s)
fi4 = fill([SWS_duration (SWS_duration + STP_duration) (SWS_duration + STP_duration) SWS_duration], [0 0 3 3],...
    'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fi5 = fill([(SWS_duration + STP_duration + REM_duration) (SWS_duration + 2*STP_duration + REM_duration)...
    (SWS_duration + 2*STP_duration + REM_duration) (SWS_duration + STP_duration + REM_duration)], [0 0 3 3],...
    'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

set(ax5, 'Box', 'off', 'XColor', 'none', 'YColor', 'none', 'Color', 'none'); 
set(ax5, 'YTick', []); 
set(ax5, 'YTickLabel', []);
yticks(ax5, []); 
legend([fi1 fi2 fi5], {'SWS', 'REM', 'STP'}, ...
       'FontSize', FontSize, 'FontName', 'Arial', ...
       'Box', 'off', 'EdgeColor', 'none', ...
       'Position', [0.842, 0.777, 0.094, 0.175]);

% ----------------------------------------------------------
% Plot Background Regions
% ----------------------------------------------------------

ax1_ylim = get(ax1, 'YLim');
ax2_ylim = get(ax2, 'YLim');
ax3_ylim = get(ax3, 'YLim');
ax4_ylim = get(ax4, 'YLim');
y_all = [min([ax1_ylim(1), ax2_ylim(1), ax3_ylim(1), ax4_ylim(1)]), ...
         max([ax1_ylim(1), ax2_ylim(1), ax3_ylim(1), ax4_ylim(1)])];

background_axes = axes('Position', [0.1, bottom, 0.7, 4*plot_height + 4*gap],...
    'Color', 'none', 'XColor', 'none', 'YColor', 'none');
hold(background_axes, 'on');
fill(background_axes, [(SWS_duration + STP_duration) (SWS_duration + STP_duration + REM_duration)...
    (SWS_duration + STP_duration + REM_duration) (SWS_duration + STP_duration)],... 
    [y_all(1) y_all(1) y_all(2) y_all(2)], [240/255, 128/255, 128/255], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill(background_axes, [SWS_duration (SWS_duration + STP_duration) (SWS_duration + STP_duration) SWS_duration],...
    [y_all(1) y_all(1) y_all(2) y_all(2)], 'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill(background_axes, [(SWS_duration + STP_duration + REM_duration) (SWS_duration + 2*STP_duration + REM_duration)...
    (SWS_duration + 2*STP_duration + REM_duration) (SWS_duration + STP_duration + REM_duration)],...
    [y_all(1) y_all(1) y_all(2) y_all(2)], 'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
set(background_axes, 'Box', 'off', 'Visible', 'off');
uistack(background_axes, 'bottom');

linkaxes([ax1, ax2, ax3, ax4, background_axes, ax5], 'x');
xlim([-2 40])
ax4.XAxis.Visible = 'off';