
function [mes, year] = calculaMes(x)
    % Calcula el mes del año en el que sucedió algo a partir de un día del
    % año que varía entre (1-372). Se suponen todos los meses de 31 días.
    year = floor((x-1)/372);
    
    m = mod(x,31);
    
    if(m == 0)
        mes = (x/31);
    else
        mes = floor((x/31)+1);
    end
    mes = mes - (12*year);
end

