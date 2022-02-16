function varargout = Ayuda(varargin)
% AYUDA MATLAB code for Ayuda.fig
%      AYUDA, by itself, creates a new AYUDA or raises the existing
%      singleton*.
%
%      H = AYUDA returns the handle to a new AYUDA or the handle to
%      the existing singleton*.
%
%      AYUDA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AYUDA.M with the given input arguments.
%
%      AYUDA('Property','Value',...) creates a new AYUDA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Ayuda_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Ayuda_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Ayuda

% Last Modified by GUIDE v2.5 28-Oct-2020 12:17:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Ayuda_OpeningFcn, ...
                   'gui_OutputFcn',  @Ayuda_OutputFcn, ...
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


% --- Executes just before Ayuda is made visible.
function Ayuda_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Ayuda (see VARARGIN)

% Choose default command line output for Ayuda
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Ayuda wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Ayuda_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
