function pm = perdedoraM(neto)
pm = 0;
nP = 0;
    for i=1:length(neto)
        if(neto(i) < 0)
            nP = nP + 1;
            pm = pm + neto(i);
        end
    end
    try
        pm = pm/nP;
    catch
        pm = 0;
    end
end