
function [dia] = calculaDia(x)
    % Calcula el día de un mes cualquiera en el que sucedió algo a partir 
    % de un día del año que varía entre (1-372). Se supone que todos los 
    % meses tienen 31 días.
    d = mod(x,31);
    if(d == 0)
        dia = 31;
    else
        dia = d;
    end
end

