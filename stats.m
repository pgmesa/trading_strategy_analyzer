function varargout = stats(varargin)
% STATS MATLAB code for stats.fig
%      STATS, by itself, creates a new STATS or raises the existing
%      singleton*.
%
%      H = STATS returns the handle to a new STATS or the handle to
%      the existing singleton*.
%
%      STATS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATS.M with the given input arguments.
%
%      STATS('Property','Value',...) creates a new STATS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stats_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stats_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stats

% Last Modified by GUIDE v2.5 15-Jan-2021 23:14:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stats_OpeningFcn, ...
                   'gui_OutputFcn',  @stats_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before stats is made visible.
function stats_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stats (see VARARGIN)

% Choose default command line output for stats
handles.output = hObject;
% Update handles structure

% Para saber el id del ultimo warning que ha saltado w = warning('query','last')
warning('off','MATLAB:hg:UIControlSliderStepValueDifference')
global ind
max = get(handles.slider,'Max');
heightInicial = 40;
heightConUnYear = 140;
diff = heightConUnYear-heightInicial;
years = ind-1;

n = heightConUnYear +(diff)*(years-1);
m = (heightInicial-n)/max;
handles.m = m;
handles.n = n;
guidata(hObject, handles);

% UIWAIT makes stats wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stats_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function infoStats_CreateFcn(hObject, eventdata, handles)
global informe ind A numMercados netoMercados
s1 = strcat(creaLineaG());
% nTradesTotales = 0;
% for i=1:numMercados
%     nTradesTotales = nTradesTotales + numTrades(netoMercados(:,i));
% end
if ind > 2
    s2 = strcat(sprintf("\n+ Años de %s a", string(A(1,1))), " ", string(A(1,1+(60+(2*numMercados*12))*(ind-2))), ":"); 
else
    s2 = strcat(sprintf("\n+ Año %s: ", string(A(1,1)))); 
end
informe = strcat(s1,s2);
handles.informes = string(ones(1,numMercados+1));
global neto ac
handles.isGlobal = true;
createDescriptionOf("INFORMACION GLOBAL DE LOS MERCADOS:",neto, ac, hObject,handles)
handles.isGlobal = false;
handles.informes(1) = informe;
global acumMercados parte
for i=1:numMercados
    createDescriptionOf(strcat("INFORMACION MERCADO ", string(i),":"),netoMercados(:,i),acumMercados(:,i), hObject,handles)
    handles.informes(1+i) = strcat(s1,s2,parte);
end
set(hObject,'String',handles.informes(1))
guidata(hObject, handles);
% hObject    handle to infoStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in fichero.
function fichero_Callback(hObject, eventdata, handles)
global A ind informe numMercados

if ind > 2
    titulo = strcat('Estadisticas_',string(A(1,1)),"-", string(A(1,1+(60+(2*numMercados*12))*(ind-2))),"_",'(',date,')');
else
    titulo = strcat('Estadisticas_',string(A(1,1)),"_",'(',date,')');
end
fileId = fopen(strcat(titulo,".txt"),'w');
lineasInforme = splitlines(informe);
try
% Cuando la informacion que se descarga es muy grande es necesario
% añadir el path absoluto de la aplicacion a las excepciones del
% antivirus para que no bloquee la escritura en el fichero que se ha creado

    for i=1:length(lineasInforme)
        %Inserta en aquellos % que quedan en el string otro procentaje para que
        %fprintf no de error y lo detecto como que tiene que poner un
        %porcentaje y no como un formato %d para una variable o algo del estilo
        newLinea = insertAfter(lineasInforme(i),"%", "%");
        fprintf(fileId,strcat(newLinea,"\n"));   
    end
    fclose(fileId);
catch err
    msg = "\n\n Nota: Cuando la informacion que se descarga es muy grande a veces es necesario"+...
        " añadir el path absoluto de la \n aplicacion que se ejecuta a las excepciones del"+...
        " antivirus para que no bloquee la escritura en el fichero que se va ha crear."+...
        "\n El error suele ser del tipo 'Invalid file Identifier' ya que fileId = -1, que "+...
        "significa o que el nombre que se da no es valido, \n o no se permite la escritura en "+...
        "ese directorio o que el antivirus ha bloqueado la escritura por ser mucha informacion de\n "+...
        "una aplicacion en teoria desconocida";
        
    set(handles.infoStats,'String',strcat(err.identifier, sprintf("\n\n"), err.message,...
        sprintf("\n\n"),"Titulo del fichero a descargar: ",titulo,sprintf("\n\n"),...
        "fileId = ",string(fileId), sprintf(msg)));
end


function createDescriptionOf(Mercado,neto, ac, hObject,handles)

global A 
   
global ddm dia2 dLibres2 perdido2 porcentaje mesInicio2 diaMinicio2 mesFinal2 diaMfinal2 xmin yearInicio2 yearFinal2
[ddm,dia2,dLibres2] = calculaDDM(ac,neto);
[ymin,xmin] = min(ac(check(dia2-1):check(dia2-1)+ddm));
perdido2 = ac(check(dia2 - 1)) -  ymin;
porcentaje = perdido2*100/ac(check(dia2-1));
[mesInicio2, yearInicio2]= calculaMes(dia2);
diaMinicio2 = calculaDia(dia2);
[mesFinal2, yearFinal2]= calculaMes(check(dia2-1) + ddm);
diaMfinal2 = calculaDia(check(dia2-1) + ddm);
[mesInterm2, yearInterm2]= calculaMes(check(dia2-1)+xmin-1);
diaMInterm2 = calculaDia(check(dia2-1)+xmin-1);

s3 = strcat(sprintf("\n%s",creaLineaG()),...
    sprintf("\n"),string(Mercado),...
    sprintf("\n%s",creaLineaG()),...
    sprintf("\n- Maximo Drawdown: -%.2f € (duro %d dias). ", perdido2, ddm),...
    sprintf("Empezo el dia %d/%d/%s ",diaMinicio2 , mesInicio2,  string(A(1,1)+yearInicio2)),...
    sprintf(" y acabo el %d/%d/%s", diaMfinal2, mesFinal2,  string(A(1,1)+yearFinal2)),...
    sprintf("\n con %d dias entre medias en los que no se opero. ", dLibres2),...
    sprintf("El %d/%d/%s se llego al pico minimo (%.2f %% de caida)",diaMInterm2,mesInterm2,string(A(1,1)+yearInterm2),porcentaje));

global ddd dia3 dLibres3 xmin1 perdido3 porcentaje2  mesInicio3 diaMinicio3 mesFinal3 diaMfinal3 yearInicio3 yearFinal3
[ddd,dia3,dLibres3] = calculaMDDd(ac,neto);
if(dia2 == dia3)
s4 = strcat(sprintf("\n\n- Drawdown mas largo: Coincide con Drawdown maximo"), ...
    sprintf("\n%s",creaLineaG()));
else
    [ymin1,xmin1] = min(ac(check(dia3-1):check(dia3-1)+ddd));
    perdido3 = ac(check(dia3 - 1)) -  ymin1;
    porcentaje2 = perdido3*100/ac(check(dia3-1));
    [mesInicio3, yearInicio3]= calculaMes(dia3);
    diaMinicio3 = calculaDia(dia3);
    [mesFinal3, yearFinal3] = calculaMes(check(dia3-1) + ddd);
    diaMfinal3 = calculaDia(check(dia3-1) + ddd);
    [mesInterm3, yearInterm3]= calculaMes(check(dia3-1)+xmin-1);
    diaMInterm3 = calculaDia(check(dia3-1)+xmin-1);
s4 = strcat(sprintf("\n\n- Drawdown mas largo:  -%.2f € (duro %d dias). ",perdido3,ddd), ...
    sprintf("Empezo el dia %d/%d/%s ",diaMinicio3 , mesInicio3,  string(A(1,1)+yearInicio3)),...
    sprintf(" y acabo el %d/%d/%s", diaMfinal3, mesFinal3,  string(A(1,1)+yearFinal3)),...
    sprintf("\n con %d dias entre medias en los que no se opero. ", dLibres3),...
    sprintf("El %d/%d/%s se llego al pico minimo (%.2f %% de caida)",diaMInterm3,mesInterm3,string(A(1,1)+yearInterm3),porcentaje2),...
    sprintf("\n%s",creaLineaG()));     
end
global mesInicio diaMinicio mesFinal diaMfinal diaMNmax mesNmax diaMNmin mesNmin yearInicio yearFinal yearNmax yearNmin
global pcm dLibres perdido
[pcm,dia,dLibres] = calculaPconsecutivas(neto);
diasEnPc = dLibres + pcm;
perdido = ac(check(dia - 1)) - ac(check(dia - 1) + diasEnPc);

[mesInicio, yearInicio]= calculaMes(dia);
diaMinicio = calculaDia(dia);
[mesFinal, yearFinal] = calculaMes(check(dia-1)+ diasEnPc);
diaMfinal = calculaDia(check(dia-1) + diasEnPc);

global maxNeto minNeto
[maxNeto, diaNmax] = max(neto);
[minNeto, diaNmin] = min(neto);
diaMNmax = calculaDia(diaNmax);
[mesNmax, yearNmax] = calculaMes(diaNmax);
diaMNmin = calculaDia(diaNmin);
[mesNmin, yearNmin] = calculaMes(diaNmin);

s5 = strcat(sprintf("\n- Dias de perdidas consecutivas -> %d. ", pcm),...
    sprintf("Empezando el dia %d/%d/%s ",diaMinicio , mesInicio,  string(A(1,1)+yearInicio)),...
    sprintf(" y acabando el %d/%d/%s", diaMfinal, mesFinal,  string(A(1,1)+yearFinal)),...
    sprintf("\n Hubo %d dias entre medias en los que no se opero. ", dLibres),...
    sprintf("Dinero perdido en ese periodo: -%.2f €",perdido),...
    sprintf("\n%s",creaLineaG()),...
    sprintf("\n- Maxima Ganancia en un dia: %.2f € (%d/%d/%s) || ", maxNeto,diaMNmax,mesNmax, string(A(1,1)+yearNmax)),...
    sprintf("- Maxima Perdida en un dia: %.2f € (%d/%d/%s)", minNeto,diaMNmin,mesNmin, string(A(1,1)+yearNmin)));
global netoMercados
if handles.isGlobal
    porcG = porcentajeG(netoMercados);
    nT = numTrades(netoMercados);
else
    porcG =  porcentajeG(neto);
    nT = numTrades(neto);  
end
EM = porcG*ganadoraM(neto)+((1-porcG)*perdedoraM(neto));

s6 = strcat(sprintf("\n%s",creaLineaG()),...
    sprintf("\n- Estadisticas TOTALES:"),...
    sprintf("\n\n     Ganadora Media = %.2f €", ganadoraM(neto)),sprintf(" || Perdedora Media = %.2f €", perdedoraM(neto)),...
    sprintf(" || nº de Trades = %d", nT),sprintf(" || Porcentaje Ganador = %.2f %%",100*porcG),...
    sprintf("  \n     Ratio P/L = %.2f", abs(ganadoraM(neto)/perdedoraM(neto))),sprintf(" || Rentabilidad = %.2f %%", rentabilidad(ac,neto)),...
    sprintf(" || Esperanza Matematica = %.2f €", EM),...
    sprintf("\n%s",creaLineaG()));
global ind netoMercados
years = ind-1;
s7 = "";
for i=1:years
    y = neto(1+372*(i-1):i*372);
    if handles.isGlobal
        y2 = netoMercados(1+372*(i-1):i*372,:);
        porcG = porcentajeG(y2);
        nT = numTrades(y2);
    else
        porcG =  porcentajeG(y);
        nT = numTrades(y);  
    end
    EM = porcG*ganadoraM(y)+((1-porcG)*perdedoraM(y));
 s = strcat(sprintf("\n%s",creaLineaG()),...
    sprintf("\n- Estadisticas AÑO %d:",i),...
    sprintf("\n\n     Ganadora Media = %.2f €", ganadoraM(y)),sprintf(" || Perdedora Media = %.2f €", perdedoraM(y)),...
    sprintf(" || nº de Trades = %d", nT),sprintf(" || Porcentaje Ganador = %.2f %%", 100*porcG),...
    sprintf("  \n     Ratio P/L = %.2f", abs(ganadoraM(y)/perdedoraM(y))),sprintf(" || Rentabilidad = %.2f %%", rentabilidad(ac(1+372*(i-1):i*372),y)),...
    sprintf(" || Esperanza Matematica = %.2f €", EM));
    s = strcat(s,sprintf("\n%s",creaLineaG()));
    for j=1:12
        m = neto(1+31*(j-1)+372*(i-1):j*31+372*(i-1));
        if handles.isGlobal
            m2 = netoMercados(1+31*(j-1)+372*(i-1):j*31+372*(i-1),:);
            porcG = porcentajeG(m2);
            nT = numTrades(m2);
        else
            porcG =  porcentajeG(m);
            nT = numTrades(m);  
        end
    EM = porcG*ganadoraM(m)+((1-porcG)*perdedoraM(m));
    %meses = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"];
    meses = ["ENERO", "FEBRERO", "MARZO", "ABRIL","MAYO", "JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"];
    ss = strcat(sprintf("\n\n   -%s - Año %d:",meses(j),i),...
        sprintf("\n\n       Ganadora Media = %.2f €", ganadoraM(m)),sprintf(" || Perdedora Media = %.2f €", perdedoraM(m)),...
        sprintf(" || nº de Trades = %d", nT),sprintf(" || Porcentaje Ganador = %.2f %%", 100*porcG),...
        sprintf("  \n       Ratio P/L = %.2f", abs(ganadoraM(m)/perdedoraM(m))),sprintf(" || Rentabilidad = %.2f %%", rentabilidad(ac(1+31*(j-1)+372*(i-1):j*31+372*(i-1)),m)),...
        sprintf(" || Esperanza Matematica = %.2f €", EM));
        s = strcat(s,ss);
    end
    s = strcat(s,sprintf("\n%s",creaLineaG()));
    s7 = strcat(s7,s);
end

global informe parte
parte = strcat(s3,s4,s5,s6,s7);
informe = strcat(informe,parte);
set(hObject, 'String', informe);
guidata(hObject,handles);


% --- Executes on selection change in infoMercados.
function infoMercados_Callback(hObject, eventdata, handles)
% hObject    handle to infoMercados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns infoMercados contents as cell array
%        contents{get(hObject,'Value')} returns selected item from infoMercados
option = get(hObject,'Value');
set(handles.infoStats, 'String', handles.informes(option))
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function infoMercados_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infoMercados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global mercOptions
set(hObject,'String', strcat(sprintf("Global\n"),mercOptions)) 


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(hObject,'Value');
y = handles.n+val*handles.m;
pos = get(handles.infoStats,'Position');
set(handles.infoStats,'Position',[pos(1) pos(2) pos(3) y]);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on key press with focus on slider and none of its controls.
function slider_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
pos = get(handles.infoStats,'Position');
max = get(handles.slider,'Max');
min = get(handles.slider,'Min');

if eventdata.VerticalScrollCount == 1
    newPos = (round(pos(4),0) - mod(round(pos(4),0),10)) + 10;
    val = (newPos-handles.n)/handles.m;
    if(val<= max && val >= min)
        set(handles.slider,'Value', val);
        set(handles.infoStats,'Position',[pos(1) pos(2) pos(3) newPos]);
    end
else
    newPos = (round(pos(4),0)- mod(round(pos(4),0),10)) - 10;
    val = (newPos-handles.n)/handles.m;
    if(val<= max && val >= min)
        set(handles.slider,'Value', val);
        set(handles.infoStats,'Position',[pos(1) pos(2) pos(3) newPos]);
    end
end
guidata(hObject,handles);
