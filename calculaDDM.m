
function [y,z,k] = calculaDDM(ac,neto)
global A
    diasDd = 0;
    diasDdm = 0;
    dLibres = 0;
    dLibresf = 0;
    diaDdm = 0;
    diffDdm = 0;
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
           [ymin,xmin] = min(ac(dia-1:dia-1+diasDd));
           diffDd = vAcum - ymin;
           if(diffDd > diffDdm)
               diasDdm = diasDd;
               diaDdm = dia;
               diffDdm = diffDd;
               dLibresf = dLibres;
           end
            diasDd = 0;
            dLibres = 0;
       end
       i = i + 1;
    end
    y = diasDdm;
    if diaDdm == 0 || diaDdm == 1
       z = 2;
    else
       z = diaDdm;
    end
    k = dLibresf;
end