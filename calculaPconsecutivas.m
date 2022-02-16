
function [y, z, k] = calculaPconsecutivas(x)
    % Recibe un vector con las ganacias/perdidas netas de cada d�a del a�o
    pc = 0;
    pcm = 0;
    diapcm = -1;
    dLibres = 0;
    dLibrespcm = 0;
    PM = false;
    for i=1:length(x)
        if(isnan(x(i)))
            continue
        end
        if(x(i) < 0)
            pc = pc + 1;
            PM = true;
        elseif (x(i) == 0 && PM)
             dLibres = dLibres + 1;   
        else
            PM = false;
            if (pc > pcm)
                pcm = pc;
                diapcm = i-pc-dLibres;
                dLibrespcm = dLibres;
            end
            pc = 0;
            dLibres = 0;
        end
    end  
    y = pcm;
    if diapcm == 0 || diapcm == -1
        z = 1;
    else
        z = diapcm;
    end
    k = dLibrespcm;
    % Delvuelve el m�ximo de perdidas consecutivas del a�o, el d�a en el que se empez� a
    % perder (numero entre 0 y 372) ya que se consideran todos los meses de 
    % 31 dias y los d�as libres que ha habido entre medias de las p�rdidas
end

