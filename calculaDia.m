
function [dia] = calculaDia(x)
    % Calcula el d�a de un mes cualquiera en el que sucedi� algo a partir 
    % de un d�a del a�o que var�a entre (1-372). Se supone que todos los 
    % meses tienen 31 d�as.
    d = mod(x,31);
    if(d == 0)
        dia = 31;
    else
        dia = d;
    end
end

