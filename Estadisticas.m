clear;clc;
% Crear una pantalla inicial con un boton de browse que abra el explorador
% de archivos y organizar los ficheros y ver como distribuyo el codigo
% Tambien poner opci�n de que cargue los archivos ya leidos por si no ha
% realizado ningun cambio que no tarde tanto en ejecutar. Guardar una
% version de backup y en caso de que la quiera actualizar que vuelva a
% cargar en excel.

file = uigetfile('.xlsx');
hoja = inputdlg('Hoja','Introduce hoja del excel que quieres leer');
h = char(hoja);
A = xlsread(file,h);


% Se obtienen matrices de acumulado y neto. Cada fila es un a�o. Suponemos
% todos los meses del a�o con 31 d�as, ya que aunque el mes realmente no
% tenga por que tener 31 d�as, aquellos que no existan se marcar�n con un
% NaN ya que no se habr� operado en esos d�as y por tanto no se tendr�n en 
% cuenta en las funciones que realizan c�lculos estad�sticos. 
Neto = zeros(12,31);
Ac = zeros(12,31);
for i=1:12
   Neto(i,:) = (A(3:33,12+13*(i-1)))';
   Ac(i,:) = (A(3:33,13*i))';
end
% Se linealizan las matriz anteriores a un solo vector de longitud
% filas*columnas de la matriz anterior. Se ponen los d�as de seguido
     neto = []; 
    for i=1:12
     neto(1+(31*(i-1)):31+(31*(i-1))) = Neto(i,:);
    end
     ac = [];
    for i=1:12
     ac(1+(31*(i-1)):31+(31*(i-1))) = Ac(i,:);
    end
    

% Se calcula el Drow-Down m�ximo (d�as seguidos en p�rdidas (ddm)), el  
% tiempo que hemos estado en ese Drow-Down (d�as seguidos en p�rdidas +  
% dias en los que no se ha operado, entre medias) y las p�rdidas 
% econ�micas  producidas en este periodo. La funcion calcula
[ddm,dia,dLibres] = calculaPconsecutivas(neto);
diasEnDD = dLibres + ddm;
perdido = ac(dia - 1) - ac(dia - 1 + diasEnDD);
    % Se calcula el mes y el d�a del calendario en el que este Drow-Drown
    % comienza y acaba
    mesInicio = calculaMes(dia);
    diaMinicio = calculaDia(dia);
    mesFinal = calculaMes(dia + diasEnDD);
    diaMfinal = calculaDia(dia + diasEnDD);
%Se calculan otros par�metros de interes a partir de la info obtenida
[maxNeto, diaNmax] = max(neto);
[minNeto, diaNmin] = min(neto);
diaMNmax = calculaDia(diaNmax);
mesNmax = calculaMes(diaNmax);
diaMNmin = calculaDia(diaNmin);
mesNmin = calculaMes(diaNmin);

% Aclaracion de la asignaci�n de variables: - > Siempre que la variable se
% llame dia... hace referencia al dia del a�o (un n�mero entre 0-372), pero
% cuando esta tiene una M detr�s hace referencia al d�a del mes en el que
% sucedi� (0-31)


% Se imprimen los archivos con la informaci�n obtenida
fileId = fopen(strcat('Estad�sticas_',A(1,1)),'w');
fprintf(fileId,'--------------------------------------------------------\n'); 
fprintf(fileId,'+ A�o %s :\n', A(1,1)); 
fprintf(fileId,'--------------------------------------------------------\n'); 
fprintf(fileId,'- M�ximo Drow-Down:\n'); 
fprintf(fileId,'D�as de p�rdidas consecutivas -> %d\n', ddm);  
fprintf(fileId,'Empezando el d�a %d/%d/%s ',diaMinicio , mesInicio, A(1,1));
fprintf(fileId,'y acabando el %d/%d/%s\n', diaMfinal, mesFinal, A(1,1));
fprintf(fileId, 'Hubo %d d�as entre medias en los que no se oper�', dLibres);
fprintf (fileId, '\nDinero perdido en ese Drow-Down: -%.2f �',perdido);
fprintf(fileId,'\n--------------------------------------------------------');
fprintf(fileId, '\n- Maxima Ganancia en un d�a: %.2f � (%d/%d/%s)', maxNeto,diaMNmax,mesNmax,A(1,1));
fprintf(fileId, '\n- Maxima P�rdida en un d�a: %.2f � (%d/%d/%s)', minNeto,diaMNmin,mesNmin,A(1,1));


% Se pintan las gr�ficas de las ganacias netas por d�a y el acumulado a
% partir de un vector de referencia temporal con longitud 12(mese)*31(dias)
% = length(ac)= length(neto)
t = 1:length(ac);
    % Gr�fica de ganancias acumuladas
    subplot(1,2,1)
    plot(t,ac,'b-')
    xlabel('D�as')
    ylabel('Acumulado (�)')
    hold on
        %Se marca el inicio y fin del Drow-Down m�ximo
        g = plot(dia-1, ac(dia-1),'ro');
        plot(dia-1+diasEnDD, ac(dia-1+diasEnDD),'ro')
        legend(g,'M�ximo Drow-Down','Location','northwest')
        hold off
    % Gr�fica de ganancias netas por d�a
    subplot(1,2,2)
    plot(t,neto,'k.-')
    xlabel('D�as')
    ylabel('Ganancia neta por d�a (�)')
    hold on
        % Se marcan los d�as de mayor ganacia y mayor p�rdida del a�o y se
        % marca la l�nea del 0
        y = zeros(1,length(t));
        plot(t,y,'k-')
        plot(diaNmax,maxNeto,'go')
        text(diaNmax,maxNeto,'\leftarrow M�xima Ganancia','Color','green')
        plot(diaNmin,minNeto,'ro')
        text(diaNmin,minNeto,'\leftarrow M�xima P�rdida','Color','red')
        hold off

