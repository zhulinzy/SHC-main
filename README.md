# SHC Model Numerical Simulation (**The analysis for the transition dynamics of sleep states through the driving effects of the cholinergic inputs to hippocampal oscillations**)


# System requirements
This script was tested using MATLAB(R2022b). It requires no additional software packages.

# Installation and usage
Download and unzip the directory, open MATLAB, and then navigate to wherever you downloaded the files. You can run the script from within that directory.


# Date

- **`SWS_REM_Transition.mat`**: Numerical experimental data of cholinergic inputs driving sleep transition.

- **`params.mat`**: Structure with a set of parameters required for the SHC model.


# Code

- **`SHC_iter.m`**: Function for numerically integrating the SHC model using the 4th-order Runge-Kutta method.

- **`SHC_test.m`**: Example script to simulate and plot the dynamics of CA1 excitatory and cholinergic neurons using the SHC model.

- **`SWS_REM_Transition.m`**: Example script to simulate and visualize cholinergic-driven sleep state transitions (SWS-REM) in the SHC Model.

# Utility functions (./utils)

- **`bandpassFilter.m`**: Function to apply a bandpass filter to a signal, used for filtering specific frequency ranges from the data.

- **`detectSWRs.m`**: Function to detect sharp-wave ripples (SWRs) in hippocampal data, useful for identifying key events during simulations.

- **`load_params.m`**: Function to load parameters of the SHC model from a structure into the base workspace.
