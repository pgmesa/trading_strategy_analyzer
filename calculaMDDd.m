
function [y,z,k] = calculaMDDd(ac,neto)
global A
    diasDd = 0;
    diasDdd = 0;
    dLibres = 0;
    diaDdd = 0;
    dLibresf = 0;
    i = 1;
    
    while(i<=length(neto))
       if(neto(i) < 0)
           dia = i;
           if(i ~= 1)
               vAcum = ac(i-1);
           else
               vAcum = A(2,13);
           end
           while(i<=length(ac) && vAcum >= ac(i))
              if(neto(i) == 0)
                  dLibres = dLibres + 1;
              end
              diasDd = diasDd + 1;
              i = i + 1;
           end
           if(diasDd > diasDdd)
               diasDdd = diasDd;
               diaDdd = dia;
               dLibresf = dLibres;
           end
            diasDd = 0;
            dLibres = 0;
       end
       i = i + 1;
    end
    y = diasDdd;
    if diaDdd == 0 || diaDdd == 1
        z = 2;
    else
        z = diaDdd;
    end
    k = dLibresf;
end

