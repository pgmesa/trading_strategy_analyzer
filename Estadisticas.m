clear;clc;
% Crear una pantalla inicial con un boton de browse que abra el explorador
% de archivos y organizar los ficheros y ver como distribuyo el codigo
% Tambien poner opción de que cargue los archivos ya leidos por si no ha
% realizado ningun cambio que no tarde tanto en ejecutar. Guardar una
% version de backup y en caso de que la quiera actualizar que vuelva a
% cargar en excel.

file = uigetfile('.xlsx');
hoja = inputdlg('Hoja','Introduce hoja del excel que quieres leer');
h = char(hoja);
A = xlsread(file,h);


% Se obtienen matrices de acumulado y neto. Cada fila es un año. Suponemos
% todos los meses del año con 31 días, ya que aunque el mes realmente no
% tenga por que tener 31 días, aquellos que no existan se marcarán con un
% NaN ya que no se habrá operado en esos días y por tanto no se tendrán en 
% cuenta en las funciones que realizan cálculos estadísticos. 
Neto = zeros(12,31);
Ac = zeros(12,31);
for i=1:12
   Neto(i,:) = (A(3:33,12+13*(i-1)))';
   Ac(i,:) = (A(3:33,13*i))';
end
% Se linealizan las matriz anteriores a un solo vector de longitud
% filas*columnas de la matriz anterior. Se ponen los días de seguido
     neto = []; 
    for i=1:12
     neto(1+(31*(i-1)):31+(31*(i-1))) = Neto(i,:);
    end
     ac = [];
    for i=1:12
     ac(1+(31*(i-1)):31+(31*(i-1))) = Ac(i,:);
    end
    

% Se calcula el Drow-Down máximo (días seguidos en pérdidas (ddm)), el  
% tiempo que hemos estado en ese Drow-Down (días seguidos en pérdidas +  
% dias en los que no se ha operado, entre medias) y las pérdidas 
% económicas  producidas en este periodo. La funcion calcula
[ddm,dia,dLibres] = calculaPconsecutivas(neto);
diasEnDD = dLibres + ddm;
perdido = ac(dia - 1) - ac(dia - 1 + diasEnDD);
    % Se calcula el mes y el día del calendario en el que este Drow-Drown
    % comienza y acaba
    mesInicio = calculaMes(dia);
    diaMinicio = calculaDia(dia);
    mesFinal = calculaMes(dia + diasEnDD);
    diaMfinal = calculaDia(dia + diasEnDD);
%Se calculan otros parámetros de interes a partir de la info obtenida
[maxNeto, diaNmax] = max(neto);
[minNeto, diaNmin] = min(neto);
diaMNmax = calculaDia(diaNmax);
mesNmax = calculaMes(diaNmax);
diaMNmin = calculaDia(diaNmin);
mesNmin = calculaMes(diaNmin);

% Aclaracion de la asignación de variables: - > Siempre que la variable se
% llame dia... hace referencia al dia del año (un número entre 0-372), pero
% cuando esta tiene una M detrás hace referencia al día del mes en el que
% sucedió (0-31)


% Se imprimen los archivos con la información obtenida
fileId = fopen(strcat('Estadísticas_',A(1,1)),'w');
fprintf(fileId,'--------------------------------------------------------\n'); 
fprintf(fileId,'+ Año %s :\n', A(1,1)); 
fprintf(fileId,'--------------------------------------------------------\n'); 
fprintf(fileId,'- Máximo Drow-Down:\n'); 
fprintf(fileId,'Días de pérdidas consecutivas -> %d\n', ddm);  
fprintf(fileId,'Empezando el día %d/%d/%s ',diaMinicio , mesInicio, A(1,1));
fprintf(fileId,'y acabando el %d/%d/%s\n', diaMfinal, mesFinal, A(1,1));
fprintf(fileId, 'Hubo %d días entre medias en los que no se operó', dLibres);
fprintf (fileId, '\nDinero perdido en ese Drow-Down: -%.2f €',perdido);
fprintf(fileId,'\n--------------------------------------------------------');
fprintf(fileId, '\n- Maxima Ganancia en un día: %.2f € (%d/%d/%s)', maxNeto,diaMNmax,mesNmax,A(1,1));
fprintf(fileId, '\n- Maxima Pérdida en un día: %.2f € (%d/%d/%s)', minNeto,diaMNmin,mesNmin,A(1,1));


% Se pintan las gráficas de las ganacias netas por día y el acumulado a
% partir de un vector de referencia temporal con longitud 12(mese)*31(dias)
% = length(ac)= length(neto)
t = 1:length(ac);
    % Gráfica de ganancias acumuladas
    subplot(1,2,1)
    plot(t,ac,'b-')
    xlabel('Días')
    ylabel('Acumulado (€)')
    hold on
        %Se marca el inicio y fin del Drow-Down máximo
        g = plot(dia-1, ac(dia-1),'ro');
        plot(dia-1+diasEnDD, ac(dia-1+diasEnDD),'ro')
        legend(g,'Máximo Drow-Down','Location','northwest')
        hold off
    % Gráfica de ganancias netas por día
    subplot(1,2,2)
    plot(t,neto,'k.-')
    xlabel('Días')
    ylabel('Ganancia neta por día (€)')
    hold on
        % Se marcan los días de mayor ganacia y mayor pérdida del año y se
        % marca la línea del 0
        y = zeros(1,length(t));
        plot(t,y,'k-')
        plot(diaNmax,maxNeto,'go')
        text(diaNmax,maxNeto,'\leftarrow Máxima Ganancia','Color','green')
        plot(diaNmin,minNeto,'ro')
        text(diaNmin,minNeto,'\leftarrow Máxima Pérdida','Color','red')
        hold off

