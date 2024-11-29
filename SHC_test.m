% SHC_test.m
% 
% This script demonstrates the application of the SHC model for simulating the 
% dynamics of two key neuronal populations: CA1 excitatory neurons and cholinergic 
% neurons. The model is iterated over a specified time duration using a given time 
% step, and the resulting membrane potentials are plotted over time.
% 
% The state variables of the SHC model are represented in the vector `X`, which 
% contains 8 variables corresponding to the key components of the model's dynamics.
%
% Parameters:
% - Initial conditions for the state variables are randomly set, with specific 
%   values assigned to certain components to reduce the transient period and 
%   allow the system to quickly reach a steady state.
% - Simulation time is set to 10 seconds, with a time step of 0.1 ms.
% - The state evolution is computed using the SHC_iter function, which models 
%   the dynamics of the system based on the parameters loaded from 'params.mat'.
%
% Outputs:
% - Two plots are generated: 
%   1. Traces of membrane potential of CA1 excitatory neurons over time.
%   2. Traces of membrane potential of cholinergic neurons over time.
% 
% Note: The `params.mat` file must be available in the working directory, as it 
% contains the necessary model parameters.

clear

load('params.mat');

h=0.1; % ms
time = 1 * 10 * 1000; % ms
N = time / h;

X_init = 2 * (rand(8, 1) - 0.5);
X_init(3, 1) = 25;
X_init(6, 1) = 25;
X_init(8, 1) = 25;

X = SHC_iter(X_init, N, h, params);

t = (0:N-1) * h / 1000;

figure;
subplot(2, 1, 1)
plot(t, X(4, :));
xlabel('Time (s)')
ylabel('$V^{\mathrm{CA1}}_{e}$', 'Interpreter', 'latex', 'FontSize', 12);


subplot(2, 1, 2)
plot(t, X(7, :));
xlabel('Time (s)')
ylabel('$V^{\mathrm{Ch}}_{e}$', 'Interpreter', 'latex', 'FontSize', 12);