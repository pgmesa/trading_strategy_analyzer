function y = check(x)
    % Funcion creada para checkear si es el dia 1 el que se produce en
    % drawdown para que al restarle 1 no de error el array de acumulado
    if x<=0
        y = 1;
    else
        y = x;
    end

end

