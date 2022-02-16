function varargout = InterfazUsuario(varargin)
% INTERFAZUSUARIO MATLAB code for InterfazUsuario.fig
%      INTERFAZUSUARIO, by itself, creates a new INTERFAZUSUARIO or raises the existing
%      singleton*.
%
%      H = INTERFAZUSUARIO returns the handle to a new INTERFAZUSUARIO or the handle to
%      the existing singleton*.
%
%      INTERFAZUSUAR    IO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFAZUSUARIO.M with the given input arguments.
%
%      INTERFAZUSUARIO('Property','Value',...) creates a new INTERFAZUSUARIO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InterfazUsuario_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InterfazUsuario_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InterfazUsuario

% Last Modified by GUIDE v2.5 17-Jan-2021 17:54:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InterfazUsuario_OpeningFcn, ...
                   'gui_OutputFcn',  @InterfazUsuario_OutputFcn, ...
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


% --- Executes just before InterfazUsuario is made visible.
function InterfazUsuario_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InterfazUsuario (see VARARGIN)

% Choose default command line output for InterfazUsuario
handles.output = hObject;

global gr
gr = 0;
% Update handles structure

% Guarda los nuevos atributos de handles creados en la funcion en la que se
% llama, si no solo serian visibles en esta funcion. hObject hace
% referencia al handles del objeto en el que estamos (deslplegable, boton
% de buscar...). Si el tag del deslplegable es desp, entonces hacer
% handles.desp seria lo mismo que usar hObject. handles es el objeto padre
% que contiene al resto de objetos hijos (botones, textos, desplegables,
% datos guardados por el usuario al programar (tambien son objetos, 
% aunque no visibles en la parte gráfica de la interfaz...). Por tanto, 
% solo es necesario usar guidata(hObject, handles) [(le pasamos el objeto en
% el que estamos (donde se han creado los atributos/datos/variables que
% queremos guardar) y la estructura del handles entera donde se va a
% guardar)] cuando hemos creado una variable/datos que queremos almacenar
% paraque sean accesibles por otros objetos.

guidata(hObject, handles); 



% UIWAIT makes InterfazUsuario wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InterfazUsuario_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in busca.
function busca_Callback(hObject, eventdata, handles)
set(handles.static, 'String', "Cargar el archivo puede llevar varios segundos")
set(handles.static, 'Enable', "on")
busqueda = uigetfile('.xlsx');

global hElegida ind 
if (busqueda ~= 0)
    hElegida = string(zeros(1,20)); % Se pueden analizar un maximo de 20 años seguidos
    ind = 1;
    set(handles.analiza, 'Enable',"off")
    handles.file = busqueda;
    
    [puedeLeer, hojas] = xlsfinfo(handles.file);
    set(handles.desplegable, 'String' , hojas)
    set(handles.desplegable, 'Enable', "on")
    set(handles.desplegable, 'Value', 1.0)
    resetObjectStatic(handles)
    guidata(hObject,handles) 
else
    try
        set(handles.static, 'String', strcat("Archivo Cargado: ", handles.file))
        set(handles.static, 'Enable', "on")
    catch
        set(handles.static, 'String', "No se han buscado ficheros")
        set(handles.static, 'Enable', "off")
    end
    
end

% hObject    handle to busca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) º


% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in analiza.
function analiza_Callback(hObject, eventdata, handles)
global gr
if(gr > 0)
    msg = "ERROR: Cierra primero la ventana del análisis anterior";
    errorMsg(handles,msg);
    return;
end
global A ind hElegida numMercados columAcum columNeto acumInicial

    B = xlsread(handles.file,hElegida(1));
    A = zeros(41,length(B)*(ind-1));
    numMercados = ((length(B)/12)-5)/2;
    columAcum = (length(B)/12);
    columNeto = columAcum -1;
    for i=1:ind-1
        try
            C = xlsread(handles.file,hElegida(i));
            if(B(1,1) > C(1,1)) 
                msg = strcat("ERROR: Hay al menos 2 hojas sin coherencia en el tiempo (H-", string(i-1)," | H-",string(i),")");
                errorMsg(handles,msg);
                return;
            elseif length(B)~=length(C)
                msg = strcat("ERROR: Al menos dos hojas no tienen el mismo nº de columnas (H-", string(i-1)," | H-",string(i),")");
                errorMsg(handles,msg); 
                return;
            elseif (B(1,1) == C(1,1)) && (i > 1)
                msg = strcat("ERROR: Al menos dos hojas contienen el mismo año (H-", string(i-1)," | H-",string(i),")");
                errorMsg(handles,msg);
                return;
            
            elseif (floor(B(33,length(B))) ~= floor(C(2,columAcum))) && (i > 1)
                msg = strcat("ERROR: Los acumulados de algunos años no coinciden (H-", string(i-1)," | H-",string(i),")");
                errorMsg(handles,msg);
                return;
            end
            A(1:41,1+length(B)*(i-1):length(B)*i) = C;
            B = C;
            A = [A xlsread(handles.file,hElegida(i))];
            if i == 1
                acumInicial = B(2,columAcum);
            end
        catch
            msg = strcat("ERROR: El formato de alguna hoja es incorrecto (H-",string(i),")");
            errorMsg(handles,msg); 
            return;
        end 
    end
 
set(handles.static3, 'BackgroundColor', [1 1 1])
set(handles.static3, 'String', "DATOS COHERENTES")
set(handles.static3, 'ForegroundColor', [0 1 0])
set(handles.flag, 'Backgroundcolor', [0 1 0])
guidata(hObject,handles)
graficas2


% --- Executes on selection change in desplegable.
function desplegable_Callback(hObject, eventdata, handles)
global hElegida ind
opciones = get(hObject, 'String');
hoja = get(hObject, 'Value');
handles.hElegida = opciones(hoja);
handles.opciones = opciones;

hElegida(ind) = cell2mat(opciones(hoja));
ind = ind + 1;
showSelectedSheets(hObject, handles)


set(handles.static2, 'Enable', "on")
set(handles.static, 'Backgroundcolor', [0 1 0])
set(handles.analiza,'Enable', 'on')
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function desplegable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desplegable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function hoja_Callback(hObject, eventdata, handles)
% hObject    handle to hoja (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hoja as text
%        str2double(get(hObject,'String')) returns contents of hoja as a double
set(handles.static2, 'String',get(handles.hoja,'String'))

% --- Executes during object creation, after setting all properties.
function hoja_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hoja (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
TradingStrategyAnalizer_(TSA)
Inicio_(TSA)

% --- Executes during object creation, after setting all properties.
function static_CreateFcn(hObject, eventdata, handles)
% hObject    handle to static (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function static2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to static2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.initFont = get(hObject,'FontSize');
guidata(hObject,handles)

% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
Ayuda


% --- Executes on button press in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in resetSheets.
function resetSheets_Callback(hObject, eventdata, handles)
global hElegida ind
    hElegida = string(zeros(1,20));
    ind = 1;
    resetObjectStatic(handles)
    

% --- Executes on button press in deleteLast.
function deleteLast_Callback(hObject, eventdata, handles)
global hElegida ind
    sheetSelected = ind-1 >= 1;
    if sheetSelected
        hElegida(ind-1) = "0";
        ind = ind - 1;
        if ind <= 1
            resetObjectStatic(handles)
        else
            showSelectedSheets(hObject,handles)
        end
    end
    
function resetObjectStatic(handles)
    try
    set(handles.static, 'String', strcat("Archivo Cargado: ", handles.file))
    catch
        return
    end
    set(handles.static, 'Enable', "on")
    set(handles.static, 'BackgroundColor', [1 1 1])
    set(handles.static2, 'Enable', "off")
    set(handles.static2, 'String', "Ninguna")
    set(handles.static2,'FontSize', handles.initFont)
    set(handles.analiza, 'Enable',"off")
    set(handles.static3, 'BackgroundColor', [0 0.447 0.741])
    set(handles.flag, 'BackgroundColor', [0 0.447 0.741])
    set(handles.static3, 'String', "")
  

function showSelectedSheets(hObject,handles)
global hElegida ind
    handles.infoHojas = hElegida(1);
    if 2<=ind
        for i=2:ind-1
            handles.infoHojas = strcat(handles.infoHojas, ", ", hElegida(i));
        end
    end
set(handles.static2, 'String', handles.infoHojas)
setFontSheets(handles)
guidata(hObject,handles)

function setFontSheets(handles)
decremento = floor((length(split(handles.infoHojas, ","))-1)/2);
set(handles.static2,'FontSize',handles.initFont-decremento);


% --- Executes during object creation, after setting all properties.
function flag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function errorMsg (handles, msg)
    set(handles.static3, 'String', msg)
    set(handles.static3, 'Backgroundcolor', [1 1 1])
    set(handles.static3, 'ForegroundColor', [1 0 0])
    set(handles.flag, 'Backgroundcolor', [1 0 0])
