function varargout = nas_gui1(varargin)
% NAS_GUI1 MATLAB code for nas_gui1.fig
%      NAS_GUI1, by itself, creates a new NAS_GUI1 or raises the existing
%      singleton*.
%
%      H = NAS_GUI1 returns the handle to a new NAS_GUI1 or the handle to
%      the existing singleton*.
%
%      NAS_GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAS_GUI1.M with the given input arguments.
%
%      NAS_GUI1('Property','Value',...) creates a new NAS_GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nas_gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nas_gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nas_gui1

% Last Modified by GUIDE v2.5 23-Sep-2017 00:31:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nas_gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @nas_gui1_OutputFcn, ...
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



% --- Executes just before nas_gui1 is made visible.
function nas_gui1_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to nas_gui1 (see VARARGIN)
    
    % Process initial data
    
    global NAS;
    
    [NAS.data.properties, NAS.data.parameters] = setParameters();
    NAS.gui.selectedNeuron = 'v_e_moto1.CNG.swc';
    
    isSplitSections = 0;
    
    [numOfSegments, localData, ~] = calculateLocalProp3 (NAS.gui.selectedNeuron, NAS.data.parameters, isSplitSections);
    NAS.data.properties.('custom').('numOfSegments') = numOfSegments;
    NAS.data.properties.('custom').('data').('local') = localData;
    
%     NAS.guiData.changedValue = 0;
    
    set(handles.axes1, 'Units', 'pixels');
    set(handles.axes1, 'Position', [60, 50 504, 378]);
    imshow('firstFig2.png');

    % Choose default command line output for nas_gui1
    handles.output = hObject;
    set(handles.output,'Visible','off');
    
    NAS.gui.home = hObject;
    set(NAS.gui.home,'Visible','on');
    
    % Assign a name to appear in the window title.
    set(hObject,'Name','Neuron Analyzer and Simulator');

    % Move the window to the center of the screen.
    movegui(hObject,'center')
    
    set(groot, 'DefaultTextInterpreter', 'tex');
      
    % Update handles structure
    guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = nas_gui1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
    global NAS;
    set(handles.output,'Visible','off');
    NAS.gui.single = nas_singleNeuron1;
    set(NAS.gui.single,'Visible','on');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
%     global NAS;
    msgbox('This function is unavailable at this development stage');
%     set(handles.output,'Visible','off');
%     NAS.gui.multi = nas_multipleNeurons;
%     set(NAS.gui.multi,'Visible','on');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
%     global NAS;
    msgbox('This function is unavailable at this development stage');
%     set(handles.output,'Visible','off');
%     NAS.gui.network = nas_network;
%     set(NAS.gui.network,'Visible','on');
    
