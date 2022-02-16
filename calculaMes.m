
function [mes, year] = calculaMes(x)
    % Calcula el mes del a�o en el que sucedi� algo a partir de un d�a del
    % a�o que var�a entre (1-372). Se suponen todos los meses de 31 d�as.
    year = floor((x-1)/372);
    
    m = mod(x,31);
    
    if(m == 0)
        mes = (x/31);
    else
        mes = floor((x/31)+1);
    end
    mes = mes - (12*year);
end

