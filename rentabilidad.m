function rent = rentabilidad(acum,neto)
    rent = ((acum(length(acum))/(acum(1)-neto(1)))-1)*100;
end