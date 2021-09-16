function varargout = nas_singleNeuron1(varargin)
% NAS_SINGLENEURON1 MATLAB code for nas_singleNeuron1.fig
%      NAS_SINGLENEURON1, by itself, creates a new NAS_SINGLENEURON1 or raises the existing
%      singleton*.
%
%      H = NAS_SINGLENEURON1 returns the handle to a new NAS_SINGLENEURON1 or the handle to
%      the existing singleton*.
%
%      NAS_SINGLENEURON1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAS_SINGLENEURON1.M with the given input arguments.
%
%      NAS_SINGLENEURON1('Property','Value',...) creates a new NAS_SINGLENEURON1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nas_singleNeuron1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nas_singleNeuron1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nas_singleNeuron1

% Last Modified by GUIDE v2.5 06-Oct-2017 07:45:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nas_singleNeuron1_OpeningFcn, ...
                   'gui_OutputFcn',  @nas_singleNeuron1_OutputFcn, ...
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


% --- Executes just before nas_singleNeuron1 is made visible.
function nas_singleNeuron1_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to nas_singleNeuron1 (see VARARGIN)

    % Choose default command line output for nas_singleNeuron1
    handles.output = hObject;
    
    global NAS;
    
    NAS.guiData.changedValue = 0;

    % Assign a name to appear in the window title.
    set(hObject,'Name','Neuron Analyzer and Simulator');

    % Move the window to the center of the screen.
    movegui(hObject,'center')

    
    set(handles.popupmenu1,'String', NAS.data.parameters.models_cellarray);
    set(handles.listbox1,'String', NAS.data.parameters.mnFileNames_cellarray.('burke'));
    NAS.guiData.selectedNeuron = 'v_e_moto1.CNG.swc';
    set(handles.text5,'String',sprintf('Selected neuron: %s  (%d segments)',NAS.guiData.selectedNeuron, NAS.data.properties.('custom').('numOfSegments')));
    set(handles.text5,'Visible','on');
%     set(handles.text7,'Visible', 'off');
    
    % Update handles structure
    guidata(hObject, handles);


% UIWAIT makes nas_singleNeuron1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nas_singleNeuron1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
    global NAS;
    contents = cellstr(get(hObject,'String'));
    NAS.guiData.selectedNeuronPop = contents{get(hObject,'Value')};
    set(handles.listbox1,'String', NAS.data.parameters.mnFileNames_cellarray.(NAS.guiData.selectedNeuronPop));
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
    global NAS;
    contents = cellstr(get(hObject,'String'));
    NAS.guiData.selectedNeuron = contents{get(hObject,'Value')};
    
    
    [numOfSegments, prop] = calculateNumOfSegmentsSingleNeuron(NAS.guiData.selectedNeuron,...
                                                        NAS.data.parameters,...
                                                        NAS.data.parameters.geometryType,...
                                                        NAS.data.parameters.maxCompartmentLength);
    
                                                    
    NAS.data.properties.('custom').('numOfSegments') = numOfSegments;
    
    
    az = 0;
    el = 0;
    d_min = 0;
    d_max = 2200;
    cmap_general = jet(11);
    metric = 'path';
    
    cla(handles.axes1);
    
    [~, ~] = plotStaticMNMorphology3 ( prop, d_min, d_max, az, el,...
                                            cmap_general(1, :), cmap_general(1, :), 'figure.png', 'lines', metric, 0, 0, 0);

    axis off
    grid off
    hold off 
    
    
    set(handles.text5,'String',sprintf('Selected neuron: %s  (%d segments)',NAS.guiData.selectedNeuron, NAS.data.properties.('custom').('numOfSegments')));
    set(handles.text5,'Visible','on');
    
    



% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    global NAS;
    [filename,~] = uigetfile({'*.SWC','SWC Files'}, 'Select Data File 1');
    if ~filename
        msgbox('You did not select a neuron');
        return;
    else
        NAS.guiData.selectedNeuron = filename;
    end
    
    [numOfSegments, prop] = calculateNumOfSegmentsSingleNeuron(NAS.guiData.selectedNeuron,...
                                                        NAS.data.parameters,...
                                                        NAS.data.parameters.geometryType,...
                                                        NAS.data.parameters.maxCompartmentLength);
    
                                                    
    NAS.data.properties.('custom').('numOfSegments') = numOfSegments;
    
    set(handles.text5,'String',sprintf('Selected neuron: %s  (%d segments)',NAS.guiData.selectedNeuron, NAS.data.properties.('custom').('numOfSegments')));
    set(handles.text5,'Visible','on');
    
    
    az = 0;
    el = 0;
    d_min = 0;
    d_max = 2200;
    cmap_general = jet(11);
    metric = 'path';
    
    cla(handles.axes1);
    
    [~, ~] = plotStaticMNMorphology3 ( prop, d_min, d_max, az, el,...
                                            cmap_general(1, :), cmap_general(1, :), 'figure.png', 'lines', metric, 0, 0, 0);

    axis off
    grid off
    hold off 
    
%     set(handles.pushbutton6,'Visible', 'on');
%     set(handles.text6,'Visible', 'on');
    
    guidata(hObject, handles);
    
    
    
    
    



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global NAS;
    NAS.gui.single_analyze = nas_singleNeuron1_analyze;
    set(NAS.gui.single_analyze,'Visible','on');
    set(NAS.gui.single,'Visible','off');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
    global NAS;
    NAS.gui.single_sim = nas_singleNeuron1_sim;
    set(NAS.gui.single_sim,'Visible','on');
    set(NAS.gui.single,'Visible','off');



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)

    global NAS;
    
    az = 0;
    el = 0;
    d_min = 0;
    d_max = 2200;
    cmap_general = jet(11);
    metric = 'path';
    
    cla(handles.axes1);
    
    set(handles.pushbutton6,'Visible', 'off');
    set(handles.text6,'Visible', 'off');
    drawnow update
    
    [~, prop] = calculateNumOfSegmentsSingleNeuron(NAS.guiData.selectedNeuron,...
                                                        NAS.data.parameters,...
                                                        NAS.data.parameters.geometryType,...
                                                        NAS.data.parameters.maxCompartmentLength);
    
                                                    
    [~, ~] = plotStaticMNMorphology3 ( prop, d_min, d_max, az, el,...
                                            cmap_general(1, :), cmap_general(1, :), 'figure.png', 'lines', metric, 0, 0, 0);

    axis off
    grid off
    hold off 


function menu_home_Callback(hObject, eventdata, handles)
    global NAS;
    set(NAS.gui.home,'Visible','on');
    close(gcbf);
%     set(NAS.gui.single,'Visible','off');


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
    global NAS;
    set(NAS.gui.home,'Visible','on');
    close(gcbf);
%     set(NAS.gui.single,'Visible','off');


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function loadScenario_Callback(hObject, eventdata, handles)
% hObject    handle to loadScenario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global NAS;
[filename,pathname] = uigetfile({'*.mat','mat Files'}, 'Select a scenario');
if ~filename
    msgbox('You did not select a scenario');
    return;
else
    uiopen(fullfile(pathname, filename));
end
