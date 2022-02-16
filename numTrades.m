function nT = numTrades(neto)
nT = 0;
[rows,colums] = size(neto);
    for i=1:colums
        for j=1:rows
            if isnan(neto(j,i)) || neto(j,i) == 0
                continue;
            end
            nT = nT + 1;
        end
    end  
end

