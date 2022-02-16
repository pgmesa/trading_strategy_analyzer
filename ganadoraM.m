function gm = ganadoraM(neto)
gm = 0;
nG = 0;
    for i=1:length(neto)
        if(neto(i) > 0)
            nG = nG + 1;
            gm = gm + neto(i);
        end
    end
    try
        gm = gm/nG;
    catch
        gm = 0;
    end
end