function varargout = nas_singleNeuron1_analyze_3DTool(varargin)
% NAS_SINGLENEURON1_ANALYZE_3DTOOL MATLAB code for nas_singleNeuron1_analyze_3DTool.fig
%      NAS_SINGLENEURON1_ANALYZE_3DTOOL, by itself, creates a new NAS_SINGLENEURON1_ANALYZE_3DTOOL or raises the existing
%      singleton*.
%
%      H = NAS_SINGLENEURON1_ANALYZE_3DTOOL returns the handle to a new NAS_SINGLENEURON1_ANALYZE_3DTOOL or the handle to
%      the existing singleton*.
%
%      NAS_SINGLENEURON1_ANALYZE_3DTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAS_SINGLENEURON1_ANALYZE_3DTOOL.M with the given input arguments.
%
%      NAS_SINGLENEURON1_ANALYZE_3DTOOL('Property','Value',...) creates a new NAS_SINGLENEURON1_ANALYZE_3DTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nas_singleNeuron1_analyze_3DTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nas_singleNeuron1_analyze_3DTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nas_singleNeuron1_analyze_3DTool

% Last Modified by GUIDE v2.5 04-Sep-2017 22:08:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nas_singleNeuron1_analyze_3DTool_OpeningFcn, ...
                   'gui_OutputFcn',  @nas_singleNeuron1_analyze_3DTool_OutputFcn, ...
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


% --- Executes just before nas_singleNeuron1_analyze_3DTool is made visible.
function nas_singleNeuron1_analyze_3DTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nas_singleNeuron1_analyze_3DTool (see VARARGIN)

% Choose default command line output for nas_singleNeuron1_analyze_3DTool
handles.output = hObject;

global NAS;

% Assign a name to appear in the window title.
set(hObject,'Name','Neuron Analyzer and Simulator');

% Move the window to the center of the screen.
movegui(hObject,'center')
    

    
    
    numOfTrees = length(NAS.data.properties.custom.data.zeroOrderSegments);
    set(handles.text12, 'String', numOfTrees);
    
    
    NAS.guiData.single.('azimuth') = 0;
    NAS.guiData.single.('elevation') = 0;
    NAS.guiData.single.('d_min') = 300;
    NAS.guiData.single.('d_max') = 1000;
    NAS.guiData.single.('cmap_general') = jet(numOfTrees);
    NAS.guiData.single.('baseColor') = NAS.guiData.single.cmap_general(1, :);
    NAS.guiData.single.('sectionColor') = NAS.guiData.single.cmap_general(numOfTrees, :);
    NAS.guiData.single.('metric') = 'path';
    NAS.guiData.single.('isShowSingleTree') = 0;
    NAS.guiData.single.('showOnlyTree') = '1';
    NAS.guiData.single.('isShowColoredTrees') = 0;
    NAS.guiData.single.('isShowSectionOnly') = 0;
    NAS.guiData.single.('isShowSection') = 0;
    
    
    str = zeros(numOfTrees,1);
    if numOfTrees == 0
        set(handles.text12, 'String', {'0'});
    else
        for i=1:numOfTrees
            str(i) = i;
        end
    end  
    set(handles.popupmenu3, 'String', str);
    
    set(handles.checkbox1, 'Value', NAS.guiData.single.isShowColoredTrees);
    set(handles.checkbox6, 'Value', NAS.guiData.single.isShowSection);
    set(handles.checkbox5, 'Value', NAS.guiData.single.isShowSectionOnly);
    set(handles.checkbox3, 'Value', NAS.guiData.single.isShowSingleTree);
    set(handles.edit4, 'String', num2str(NAS.guiData.single.d_min));
    set(handles.edit5, 'String', num2str(NAS.guiData.single.d_max));
    
    

    [upperAxes, NAS.guiData.single.surface_handle] = plotStaticMNMorphology3 ( NAS.data.properties.('custom'),...
        NAS.guiData.single.d_min, NAS.guiData.single.d_max, NAS.guiData.single.azimuth, NAS.guiData.single.elevation,...
        NAS.guiData.single.baseColor, NAS.guiData.single.sectionColor, 'figure.png',...
        NAS.data.parameters.geometryType, NAS.guiData.single.metric, NAS.guiData.single.isShowSectionOnly,...
        NAS.guiData.single.isShowColoredTrees, NAS.guiData.single.isShowSingleTree);
    
    axis off
    grid off
    hold off 
    
    
    
% Update handles structure
guidata(hObject, handles);



% UIWAIT makes nas_singleNeuron1_analyze_3DTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nas_singleNeuron1_analyze_3DTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global NAS;
az = NAS.guiData.single.azimuth;
NAS.guiData.single.elevation = get(hObject,'Value');
el = NAS.guiData.single.elevation;

view(az, el);
set(handles.text11, 'String', sprintf('az: %3.1f\nel:%3.1f', az, el));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global NAS;
NAS.guiData.single.azimuth = get(hObject,'Value');
az = NAS.guiData.single.azimuth;
el = NAS.guiData.single.elevation;

view(az, el);
set(handles.text11, 'String', sprintf('az: %3.1f\nel:%3.1f', az, el));

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function save3D_Callback(hObject, eventdata, handles)
% hObject    handle to save3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig = figure;
copyobj(handles.axes2, fig);
% print(fig, 'nas_fig5','-painters','-dpng','-r600');
% printpreview(fig)
exportsetupdlg(fig);


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


    global NAS;

    contents = cellstr(get(hObject,'String'));
    NAS.guiData.single.showOnlyTree = contents{get(hObject,'Value')};
    NAS.guiData.single.isAnimation = 0;
    atualizeSingleNeuron3D();






% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
    
    
    global NAS;
    
    NAS.guiData.single.isShowColoredTrees = get(hObject,'Value');
    NAS.guiData.single.isShowSingleTree = 0;
    NAS.guiData.single.isAnimation = 0;
    set(handles.checkbox3, 'Value', 0);
    
    atualizeSingleNeuron3D();
    
    
    




% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global NAS;
NAS.guiData.single.d_mix = str2double(get(hObject,'String'));
set(handles.edit2, 'String', num2str(NAS.guiData.single.d_mix));

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
global NAS;
NAS.guiData.single.d_max = str2double(get(hObject,'String'));
set(handles.edit3, 'String', num2str(NAS.guiData.single.d_max));

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of checkbox3
    global NAS;
    NAS.guiData.single.isShowSingleTree = get(hObject,'Value');
    NAS.guiData.single.isShowColoredTrees = 0;
    NAS.guiData.single.isAnimation = 0;
    set(handles.checkbox1, 'Value', 0);

    atualizeSingleNeuron3D();



% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global NAS;
    NAS.guiData.single.baseColor = uisetcolor;
    NAS.guiData.single.isAnimation = 0;
    atualizeSingleNeuron3D();

    
    
% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
    % hObject    handle to popupmenu5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popupmenu5
    global NAS;
    contents = cellstr(get(hObject,'String'));
    cmap_str = contents{get(hObject,'Value')};
    cmap = str2func(cmap_str);
    NAS.guiData.single.isAnimation = 0;
    NAS.guiData.single.cmap_general = cmap(length(NAS.data.properties.custom.data.zeroOrderSegments));
    atualizeSingleNeuron3D();


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
global NAS;
NAS.guiData.single.isShowSectionOnly = get(hObject,'Value');

NAS.guiData.single.isShowSingleTree = 0;
set(handles.checkbox3, 'Value', 0);

NAS.guiData.single.isShowSection = 0;
set(handles.checkbox6, 'Value', 0);

NAS.guiData.single.isAnimation = 0;
atualizeSingleNeuron3D();


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
global NAS;

NAS.guiData.single.d_min = str2double(get(hObject,'String'));

atualizeSingleNeuron3D();

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
global NAS;

NAS.guiData.single.d_max = str2double(get(hObject,'String'));

atualizeSingleNeuron3D();

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
global NAS;
NAS.guiData.single.isShowSection = get(hObject,'Value');

NAS.guiData.single.isShowSingleTree = 0;
set(handles.checkbox3, 'Value', 0);

NAS.guiData.single.isShowSectionOnly = 0;
set(handles.checkbox5, 'Value', 0);

NAS.guiData.single.isAnimation = 0;
atualizeSingleNeuron3D();

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NAS;
NAS.guiData.single.sectionColor = uisetcolor;
NAS.guiData.single.isAnimation = 0;
atualizeSingleNeuron3D();
