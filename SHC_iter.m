function X_iter = SHC_iter(X, N, h, params)
    % SHC_iter - Numerically solves the SHC model using the 4th-order Runge-Kutta method
    %
    % Inputs:
    %   X        - Initial state vector, containing the starting values of the system
    %   N        - Number of iterations, controls the number of steps in the solution process
    %   h        - Time step, determines the precision of each iteration
    %   params   - A structure containing model parameters that define the dynamic properties of the SHC model
    %
    % Output:
    %   X_iter   - A matrix representing the system's state at each time step. The first column is the initial state,
    %              and the subsequent columns are the states computed through iteration.
    %
    % Description:
    %   - The 4th-order Runge-Kutta method is used to update the state vector at each time step.
    %   - The function `f` defines the system's dynamic equations, with parameters passed through the `params` structure.
    %   - The output `X_iter` matrix stores the system's state at each time step, with each column representing the state.
    
    % Initialize the state matrix to store the state at each time step
    X_iter = zeros(length(X), N);
    X_iter(:, 1) = X;  % Set the initial state as the first column

    % Use the 4th-order Runge-Kutta method to iteratively solve the system
    for i = 1:N-1
        k1 = h * f(X_iter(:, i), params);                 % Compute k1
        k2 = h * f(X_iter(:, i) + k1/2, params);          % Compute k2
        k3 = h * f(X_iter(:, i) + k2/2, params);          % Compute k3
        k4 = h * f(X_iter(:, i) + k3, params);            % Compute k4
    
        % Update the state vector to the next time step
        X_iter(:, i+1) = X_iter(:, i) + (k1 + 2*k2 + 2*k3 + k4) / 6;
    end
end

function dX = f(X, params)
    % f - Defines the system dynamics (derivatives of state variables) for the SHC model
    %
    % This function defines the differential equations of the SHC model, calculating the rate of change
    % (derivatives) of each state variable at the current time step. The equations include nonlinear terms,
    % which are controlled by the parameters in the `params` structure to simulate the system's complex dynamics.
    %
    % Inputs:
    %   X        - The current state vector at the time step
    %   params   - A structure containing model parameters that define the system's dynamics
    %
    % Output:
    %   dX       - A column vector containing the derivatives of each state variable
    
    % firing rate function
    function value = r_f(r_0, r_1, V_n_m, V_n__m, g_n_m)
        value = r_0 + r_1 / (1 + exp((V_n__m - V_n_m) / g_n_m));
    end
    
    % DFSA Mechanism Among Excitatory Synapses 
    function value = J_f(J0_ee_km, c, c_, g_c)
        value = J0_ee_km / (1 + exp((c - c_) / g_c));
    end

    dX(1) = (-X(1) ...
    + params.N_e_CA3 * params.P_ee_CA3 * J_f(params.J0_ee_CA3, X(3), params.c_, params.g_c) * r_f(params.r_0, params.r_1, X(1), params.V_e__CA3, params.g_e_CA3) ...
    - params.N_i_CA3 * params.P_ie_CA3 * params.J_ie_CA3 * r_f(params.r_0, params.r_1, X(1), params.V_i__CA3, params.g_i_CA3)) / params.t_e;

    dX(2) = (-X(2) ...
    + params.N_e_CA3 * params.P_ei_CA3 * params.J_ei_CA3 * r_f(params.r_0, params.r_1, X(1), params.V_e__CA3, params.g_e_CA3)) / params.t_i;

    dX(3) = (-X(3) ...
    + params.N_e_CA3 * params.P_ee_CA3 * params.dc_CA3 * r_f(params.r_0, params.r_1, X(1), params.V_e__CA3, params.g_e_CA3)) / params.t_c;

    dX(4) = (-X(4) ...
    - params.N_i_CA1 * params.P_ie_CA1 * params.J_ie_CA1 * r_f(params.r_0, params.r_1, X(5), params.V_i__CA1, params.g_i_CA1) ... 
    + params.N_e_CA3 * params.P_ee_CA31 * J_f(params.J0_ee_CA31, X(6), params.c_, params.g_c) * r_f(params.r_0, params.r_1, X(1), params.V_e__CA3, params.g_e_CA3)) / params.t_e;
    
    dX(5) = (-X(5) ...
    + params.N_e_CA1 * params.P_ei_CA1 * params.J_ei_CA1 * r_f(params.r_0, params.r_1, X(4), params.V_e__CA1, params.g_e_CA1) ... 
    + params.N_e_CA3 * params.P_ei_CA31 * params.J_ei_CA31 * r_f(params.r_0, params.r_1, X(1), params.V_e__CA3, params.g_e_CA3) ...
    - params.N_i_CA1 * params.P_ii_CA1 * params.J_ii_CA1 * r_f(params.r_0, params.r_1, X(5), params.V_i__CA1, params.g_i_CA1)) / params.t_i;
    
    dX(6) = (-X(6) ...
    + params.N_e_CA3 * params.P_ee_CA31 * params.dc_CA1 * r_f(params.r_0, params.r_1, X(1), params.V_e__CA3, params.g_e_CA3) ...
    + params.N_e_Ch * params.P_ee_Ch2CA1 * params.dc_Ch2CA1 * r_f(params.r_0, params.r_1, X(7), params.V_e__Ch, params.g_e_Ch)) / params.t_c;

    dX(7) = (-X(7) ... 
    + params.N_e_Ch * params.P_ee_Ch * J_f(params.J0_ee_Ch, X(8), params.c_Ch, params.g_c_Ch) * r_f(params.r_0, params.r_1, X(7), params.V_e__Ch, params.g_e_Ch)) / params.t_e;

    dX(8) = (-X(8) ... 
    + params.N_e_Ch * params.P_ee_Ch * params.dc_Ch * r_f(params.r_0, params.r_1, X(7), params.V_e__Ch, params.g_e_Ch)) / params.t_c_Ch;

    dX = dX';
end
