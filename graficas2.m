function varargout = graficas2(varargin)
% GRAFICAS2 MATLAB code for graficas2.fig
%      GRAFICAS2, by itself, creates a new GRAFICAS2 or raises the existing
%      singleton*.
%
%      H = GRAFICAS2 returns the handle to a new GRAFICAS2 or the handle to
%      the existing singleton*.
%
%      GRAFICAS2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAFICAS2.M with the given input arguments.
%
%      GRAFICAS2('Property','Value',...) creates a new GRAFICAS2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before graficas2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to graficas2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help graficas2

% Last Modified by GUIDE v2.5 13-Jan-2021 00:07:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @graficas2_OpeningFcn, ...
                   'gui_OutputFcn',  @graficas2_OutputFcn, ...
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


% --- Executes just before graficas2 is made visible.
function graficas2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to graficas2 (see VARARGIN)

% Choose default command line output for graficas2
handles.output = hObject;

global A gr ind columNeto columAcum acumInicial
global neto ac numMercados acumMercados netoMercados
gr = 1;
neto = [];
ac = [];
mercados = [];
handles.plotMercados = [];

for i=1:12*(ind-1)
   neto(1+(31*(i-1)):31+(31*(i-1))) = (A(3:33,columNeto + columAcum*(i-1)))';
   ac(1+(31*(i-1)):31+(31*(i-1))) = (A(3:33,columAcum*i))';
   for j=1:numMercados
       mercados(1+(31*(i-1)):31+(31*(i-1)),j) = (A(3:33, 4+2*(j-1) + columAcum*(i-1)));
   end
end 
% Se cambian los NaN por 0
[rows,colum] = size(mercados);
for i=1:rows
    for j=1:colum
        if isnan(mercados(i,j))
            mercados(i,j) = 0;
        end
    end
end
netoMercados = mercados;
% Se crea el acumulado de los diferentes mercados
for i=1:colum
    for j=1:rows
        if j==1 
            mercados(j,i) = mercados(j,i) + acumInicial;
        else
            mercados(j,i) = mercados(j,i) + mercados(j-1,i);
        end
    end
end
acumMercados = mercados;
    global t
%     axes(handles.neto);
%     t = 1:length(neto);
%     plot(t,neto,'k.-')
%     hold on
%     y = zeros(1,length(t));
%     plot(t,y,'k-')
%     xlabel('Dias')
%     ylabel('Ganancia neta por dia (€)')
%     hold off
    
    axes(handles.acum);
    t = 1:length(ac);
    plot(t,ac,'b-','DisplayName','Acumulado Total')
    hold on
    xlabel('Dias')
    ylabel('Acumulado (€)')
    legend('Location','NorthWest')    
%     % Prueba para verificar que la suma de los mercados por separados crean
%     % el acumulado global
%     prueba = -acumInicial*(numMercados-1)*ones(length(acumMercados(:,1)),1);
%     for i=1:numMercados
%        prueba = prueba + acumMercados(:,i);
%     end
%     plot(t,prueba)
    hold off
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes graficas2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = graficas2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in perdidasConsecutivas.
function perdidasConsecutivas_Callback(hObject, eventdata, handles)
global neto ac acumMercados netoMercados
[pcm,dia,dLibres] = calculaPconsecutivas(neto);
diasEnPc = dLibres + pcm; 
if(get(hObject,'Value'))
        axes(handles.acum);
        hold on
        
        t = [check(dia-1) check(dia-1)+diasEnPc];
        val = [ac(check(dia-1)) ac(check(dia-1)+diasEnPc)];
        
        if ~isempty(handles.plotMercados)
            for i=1:length(handles.plotMercados)
                if handles.plotMercados(i) == 0
                    continue;
                else
                    [pcm,dia,dLibres] = calculaPconsecutivas(netoMercados(:,i));
                    diasEnPc = dLibres + pcm; 
                    
                    t = [t check(dia-1) check(dia-1)+diasEnPc];
                    val = [val acumMercados(check(dia-1),i) acumMercados(check(dia-1)+diasEnPc,i)];
                end
            end
        end
        
        handles.pConsecutivas = plot(t, val,'ro','DisplayName','Maximo periodo de perdidas consecutivas');
        set(handles.pConsecutivas,'tag','pConsecutivas')
        hold off   
else        
    delete(findobj('tag','pConsecutivas'));
end 
guidata(hObject, handles)  

% --- Executes on button press in max_min.
% function max_min_Callback(hObject, eventdata, handles)
% global neto
% [maxNeto, diaNmax] = max(neto);
% [minNeto, diaNmin] = min(neto);
%         axes(handles.neto);
%         hold on
%         handles.PmaxN = plot(diaNmax,maxNeto,'go');
%         handles.arrow1 = text(diaNmax,maxNeto,'\leftarrow Máxima Ganancia','Color','green');
%         handles.PminN = plot(diaNmin,minNeto,'ro');
%         handles.arrow2 = text(diaNmin,minNeto,'\leftarrow Máxima Pérdida','Color','red');
%         set(handles.PmaxN,'tag','maximoNeto')
%         set(handles.arrow1,'tag','flechaMax')
%         set(handles.PminN,'tag','minimoNeto')
%         set(handles.arrow2,'tag','flechaMin')
%         if(~get(hObject,'Value'))
%             delete(findobj('tag','maximoNeto'));
%             delete(findobj('tag','flechaMax'));
%             delete(findobj('tag','minimoNeto'));
%             delete(findobj('tag','flechaMin'));
%         end
%         hold off
% guidata(hObject, handles) 


% --- Executes on button press in analisis.
function analisis_Callback(hObject, eventdata, handles)
stats

% --- Executes during object creation, after setting all properties.
function acum_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function neto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate neto


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
global gr
gr = 0;
delete(hObject);


% --- Executes on button press in maxDrawdown.
function maxDrawdown_Callback(hObject, eventdata, handles)
global ac neto acumMercados netoMercados
[ddm,dia,dLibres] = calculaDDM(ac,neto);
[ymin,xmin] = min(ac(check(dia-1):check(dia-1)+ddm));
     if get(hObject,'Value')
        axes(handles.acum);
        hold on
        
        t = [check(dia-1), check(dia-1)+ddm, xmin+check(dia-1)];
        val = [ac(check(dia-1)), ac(check(dia-1)+ddm), ymin];
        
        if ~isempty(handles.plotMercados)
            for i=1:length(handles.plotMercados)
                if handles.plotMercados(i) == 0
                    continue;
                else
                    [ddm,dia,dLibres] = calculaDDM(acumMercados(:,i),netoMercados(:,i));
                    [ymin,xmin] = min(squeeze(acumMercados(check(dia-1):check(dia-1)+ddm,i)'));
                   
                    t = [t check(dia-1), check(dia-1)+ddm, xmin+check(dia-1)];
                    val = [val acumMercados(check(dia-1),i), acumMercados(check(dia-1)+ddm,i), ymin];
                end
            end
        end
        handles.maxDD = plot(t,val,'ko', 'DisplayName','MaxDrawdown');
        set(handles.maxDD, 'tag', 'maxDD')
        hold off
      else
         delete(findobj('tag','maxDD'));
      end
        
guidata(hObject, handles)  

% Hint: get(hObject,'Value') returns toggle state of maxDrawdown


% --- Executes on button press in maxDrawdownDuration.
function maxDrawdownDuration_Callback(hObject, eventdata, handles)
global ac neto acumMercados netoMercados
[ddm,dia,dLibres] = calculaDDM(ac,neto);
[ymin,xmin] = min(ac(check(dia-1):check(dia-1)+ddm));
     if get(hObject,'Value')
        axes(handles.acum);
        hold on
        
        t = [dia-1, dia-1+ddm, xmin+dia-1];
        val = [ac(dia-1), ac(dia-1+ddm), ymin];
        
        if ~isempty(handles.plotMercados)
            for i=1:length(handles.plotMercados)
                if handles.plotMercados(i) == 0
                    continue;
                else
                    [ddm,dia,dLibres] = calculaMDDd(acumMercados(:,i),netoMercados(:,i));
                    [ymin,xmin] = min(squeeze(acumMercados(dia-1:dia+ddm-1,i)'));
                    t = [t dia-1, dia-1+ddm, xmin+dia-1];
                    val = [val acumMercados(dia-1,i), acumMercados(dia-1+ddm,i), ymin];
                end
            end
        end
        handles.maxDD = plot(t,val,'mo', 'DisplayName','Drawdown mas largo');
        set(handles.maxDD, 'tag', 'maxDDd')
        hold off
      else
         delete(findobj('tag','maxDDd'));
      end
       
guidata(hObject, handles)  


% --- Executes on selection change in mercados.
function mercados_Callback(hObject, eventdata, handles)
% hObject    handle to mercados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mercados contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mercados

global acumMercados t

Mselected = get(hObject, 'Value');
axes(handles.acum);
hold on
try
    if handles.plotMercados(Mselected) == 0
        handles.plotMercados(Mselected) = plot(t,acumMercados(:,Mselected),'DisplayName', strcat("Mercado ", string(Mselected)));
    end
catch
    handles.plotMercados(Mselected) = plot(t,acumMercados(:,Mselected),'DisplayName', strcat("Mercado ", string(Mselected)));
end
hold off
set(handles.plotMercados,'tag', 'plotMercados')
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function mercados_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mercados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global numMercados
global mercOptions
mercOptions = "";
for i=1:numMercados
    if(i == numMercados)
        mercOptions = strcat(mercOptions,"Mercado ", string(i));
    else
        mercOptions = strcat(mercOptions,"Mercado ", string(i), sprintf("\n"));
    end
    
end
set(hObject, 'String', mercOptions)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resetMercados.
function resetMercados_Callback(hObject, eventdata, handles)
% hObject    handle to resetMercados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    delete(findobj('tag','plotMercados'));
catch
end
handles.plotMercados = [];
if get(handles.maxDrawdown,'Value')
    delete(findobj('tag','maxDD'));
    maxDrawdown_Callback(hObject, eventdata, handles)
end
if get(handles.maxDrawdownDuration,'Value')
    delete(findobj('tag','maxDDd'));
    maxDrawdownDuration_Callback(hObject, eventdata, handles)
end
if get(handles.perdidasConsecutivas,'Value')
    delete(findobj('tag','pConsecutivas'));
    perdidasConsecutivas_Callback(hObject, eventdata, handles)
end

guidata(hObject, handles)

% function printLegend(handles)
% handles.plots =[];
% handles.plots()
% 
% function addPlot(handles)
% [rows,colums] = size(handles.plot);
% handles.plot(rows+1,:) = [plot() "hola Buenas"];
