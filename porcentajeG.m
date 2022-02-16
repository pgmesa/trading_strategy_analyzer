function pG = porcentajeG(neto)
    [rows,colums] = size(neto);
    nG = 0;
    for i=1:colums   
        for j=1:rows
           if neto(j,i) > 0
               nG = nG + 1;
           end
        end
    end
    pG = nG/numTrades(neto);
end