function load_params(params)
    % load_params - Loads parameters from a structure into the base workspace.
    %
    % Inputs:
    %   params - A structure with fields representing parameter names 
    %            and corresponding values (e.g., 't_e' : 20).
    %
    % Description:
    %   This function loads each field of the input structure 'params' 
    %   into the base workspace as a variable with the same name as the field.

    fields = fieldnames(params); 
    
    for j = 1:numel(fields)
        assignin('base', fields{j}, params.(fields{j}));
    end
end