function varargout = nas_singleNeuron1_analyze_configParams(varargin)
% NAS_SINGLENEURON1_ANALYZE_CONFIGPARAMS MATLAB code for nas_singleNeuron1_analyze_configParams.fig
%      NAS_SINGLENEURON1_ANALYZE_CONFIGPARAMS, by itself, creates a new NAS_SINGLENEURON1_ANALYZE_CONFIGPARAMS or raises the existing
%      singleton*.
%
%      H = NAS_SINGLENEURON1_ANALYZE_CONFIGPARAMS returns the handle to a new NAS_SINGLENEURON1_ANALYZE_CONFIGPARAMS or the handle to
%      the existing singleton*.
%
%      NAS_SINGLENEURON1_ANALYZE_CONFIGPARAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAS_SINGLENEURON1_ANALYZE_CONFIGPARAMS.M with the given input arguments.
%
%      NAS_SINGLENEURON1_ANALYZE_CONFIGPARAMS('Property','Value',...) creates a new NAS_SINGLENEURON1_ANALYZE_CONFIGPARAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nas_singleNeuron1_analyze_configParams_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nas_singleNeuron1_analyze_configParams_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nas_singleNeuron1_analyze_configParams

% Last Modified by GUIDE v2.5 05-Sep-2017 16:49:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nas_singleNeuron1_analyze_configParams_OpeningFcn, ...
                   'gui_OutputFcn',  @nas_singleNeuron1_analyze_configParams_OutputFcn, ...
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


% --- Executes just before nas_singleNeuron1_analyze_configParams is made visible.
function nas_singleNeuron1_analyze_configParams_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nas_singleNeuron1_analyze_configParams (see VARARGIN)

% Choose default command line output for nas_singleNeuron1_analyze_configParams
handles.output = hObject;

% Assign a name to appear in the window title.
set(hObject,'Name','Neuron Analyzer and Simulator');

% Move the window to the center of the screen.
movegui(hObject,'center')

global NAS;
set(handles.text6,'String',sprintf('Parameters: %s',NAS.guiData.selectedNeuron));
set(handles.text6,'Visible','on');

set(handles.edit17,'String',num2str(NAS.data.parameters.maxCompartmentLength));
set(handles.edit18,'String',num2str(NAS.data.parameters.maxNumOfSegments));
set(handles.checkbox1,'Value',NAS.data.parameters.isEliminateAxon);
set(handles.checkbox2,'Value',NAS.data.parameters.isEliminateStemDendWithNoDaugther);
set(handles.checkbox3,'Value',NAS.data.parameters.isEliminateUnbranchedTrees);




pre_labs = NAS.data.parameters.models_cellarray; % pre_labs is a cellarray
for i = 1:length(pre_labs)
    % mnFileNames_cellarray is struct of cellarrays
    % fileNames is a cellarray;
    lab = pre_labs{i};
    fileNames = NAS.data.parameters.mnFileNames_cellarray.(lab);
    aliases = NAS.data.parameters.neuronAlias_cellarray.(lab);
    for j = 1:length(fileNames)
        if(strcmp(fileNames{j}, NAS.guiData.selectedNeuron))
            NAS.guiData.isCustomPredefined = 1;
            break;
        else
            NAS.guiData.isCustomPredefined = 0;
        end
        if(NAS.guiData.isCustomPredefined)
            break;
        end
    end
    if(NAS.guiData.isCustomPredefined)
        break;
    end
end

if(NAS.guiData.isCustomPredefined)
    if NAS.guiData.changedValue
        propNeuron = NAS.data.properties.custom;
        set(handles.edit2, 'String', propNeuron.species);
        set(handles.edit3, 'String', propNeuron.name);
        set(handles.edit4, 'String', propNeuron.lab);
        set(handles.edit5, 'String', propNeuron.tertiaryCellClass);
        set(handles.edit6, 'String', propNeuron.development);
    else
        propNeuron = NAS.data.properties.(aliases{j});
        set(handles.edit2, 'String', propNeuron.species);
        set(handles.edit3, 'String', propNeuron.name);
        set(handles.edit4, 'String', propNeuron.lab);
        set(handles.edit5, 'String', propNeuron.tertiaryCellClass);
        set(handles.edit6, 'String', propNeuron.development);
    end
else
    if NAS.guiData.changedValue
        propNeuron = NAS.data.properties.custom;
        set(handles.edit2, 'String', propNeuron.species);
        set(handles.edit3, 'String', propNeuron.name);
        set(handles.edit4, 'String', propNeuron.lab);
        set(handles.edit5, 'String', propNeuron.tertiaryCellClass);
        set(handles.edit6, 'String', propNeuron.development);
    else
        set(handles.edit2, 'String', '...');
        set(handles.edit3, 'String', '...');
        set(handles.edit4, 'String', '...');
        set(handles.edit5, 'String', '...');
        set(handles.edit6, 'String', '...');
    end
end


set(handles.edit22,'String',num2str(NAS.data.parameters.passiveParams.('Cm')));
set(handles.edit23,'String',num2str(NAS.data.parameters.passiveParams.('Rm_soma')));
set(handles.edit24,'String',num2str(NAS.data.parameters.passiveParams.('Rm_dend')));
set(handles.edit25,'String',num2str(NAS.data.parameters.passiveParams.('Ra')));
set(handles.edit26,'String',num2str(NAS.data.parameters.sampleFreq));


% Update handles structure
guidata(hObject, handles);



% UIWAIT makes nas_singleNeuron1_analyze_configParams wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nas_singleNeuron1_analyze_configParams_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_home_Callback(hObject, eventdata, handles)
    % hObject    handle to menu_home (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global NAS;
    set(NAS.gui.home,'Visible','on');
    set(NAS.gui.single_analyze,'Visible','off');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global NAS;
    NAS.gui.single_analyze_3DTool = nas_singleNeuron1_analyze_3DTool;
    set(NAS.gui.single_analyze_3DTool,'Visible','on');
    
    

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    global NAS;

    str = sprintf(strcat('Measure values:\nNumber of segments: %d\nTotal area of stem dendrites: %.2f um\n',...
        'Soma area: %.2f um^2\nTotal area: %.2f um^2\nTotal path length: %.2f um\nMaximum Euclidian distance: %.2f um\n',...
        'Maximum path distance: %.2f um\nNumber of bifurcations: %d\nNumber of terminations: %d\nNumber of  branches: %d\n',...
        'Maximum branch order: %d \nSomatic input impedance: %.2f MOhm'),...
        NAS.data.properties.custom.numOfSegments,...
        NAS.data.properties.custom.data.neuronLevel.areaTotalStemDendrites,...
        NAS.data.properties.custom.data.neuronLevel.areaSoma,...
        NAS.data.properties.custom.data.neuronLevel.areaTotal,... 
        NAS.data.properties.custom.data.neuronLevel.totalPathLength,...
        NAS.data.properties.custom.data.neuronLevel.maxEuclidianDistance,... 
        NAS.data.properties.custom.data.neuronLevel.maxPathDistance,...
        NAS.data.properties.custom.data.neuronLevel.numOfBifurcations,...
        NAS.data.properties.custom.data.neuronLevel.numOfTerminations,...
        NAS.data.properties.custom.data.neuronLevel.numOfBranches,...
        NAS.data.properties.custom.data.neuronLevel.maxBranchOrder,...
        NAS.data.properties.custom.data.neuronLevel.somaticInputImpedance);

    set(handles.text7,'String', str);
    set(handles.text7,'Visible','on');
    set(handles.pushbutton8,'Visible','on');
    set(handles.text8,'Visible','on');
    set(handles.popupmenu2,'Visible','on');

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global NAS;
h = handles.popupmenu2;
contents = cellstr(get(h,'String'));
str = contents{get(h,'Value')};

if strcmp(str, 'ASCII text file (*.txt)')
    disp('ASCII text file (*.txt)')
    [FileName,PathName,FilterIndex] = uiputfile('exported_data.txt');
    if FilterIndex
        fid = fopen(FileName, 'wt+');
        a=get(handles.text7, 'String');
        for i = 1:size(a, 1)
            fprintf(fid, '%s\n',a(i,:));
        end
        fclose(fid);
    end
end

if strcmp(str, 'Matlab data (*.mat)')
    disp('Matlab data (*.mat)')
    [FileName,PathName,FilterIndex] = uiputfile('exported_data.mat');
    if FilterIndex
%         a=get(handles.text7, 'String');
        a=NAS.data.properties.custom.data.neuronLevel;
        save(FileName, 'a');
    end
end

% [FileName,PathName] = uiputfile;
% a = handles.text7;
% save(FileName, 'a');

% firstColumn = ['numOfSegments'; NAS.data.properties.custom.data.neuronLevel.names; 'somaticInputImpedance']'
% save('absoluteData.txt','firstColumn','-ascii')
% type('absoluteData.txt')


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

% Update handles structure

% contents = cellstr(get(hObject,'String'));
% contents{get(hObject,'Value')}
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global NAS;
NAS.data.parameters.maxCompartmentLength            = str2double(get(handles.edit17,'String'));
NAS.data.parameters.maxNumOfSegments                = str2double(get(handles.edit18,'String'));
NAS.data.parameters.isEliminateAxon                 = get(handles.checkbox1,'Value');
NAS.data.parameters.isEliminateStemDendWithNoDaugther = get(handles.checkbox2,'Value');
NAS.data.parameters.isEliminateUnbranchedTrees      = get(handles.checkbox3,'Value');

NAS.data.properties.custom.species          = get(handles.edit2, 'String');
NAS.data.properties.custom.name            = get(handles.edit3, 'String');
NAS.data.properties.custom.lab              = get(handles.edit4, 'String');
NAS.data.properties.custom.tertiaryCellClass = get(handles.edit5, 'String');
NAS.data.properties.custom.development      = get(handles.edit6, 'String');

NAS.guiData.changedValue = 1;

NAS.data.parameters.passiveParams.('Cm')    = str2double(get(handles.edit22,'String'));
NAS.data.parameters.passiveParams.('Rm_soma')= str2double(get(handles.edit23,'String'));
NAS.data.parameters.passiveParams.('Rm_dend')= str2double(get(handles.edit24,'String'));
NAS.data.parameters.passiveParams.('Ra')    = str2double(get(handles.edit25,'String'));
NAS.data.parameters.sampleFreq              = str2double(get(handles.edit26,'String'));



    

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
    close(gcbf);

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
    global NAS;
    NAS.data.parameters.maxCompartmentLength            = str2double(get(handles.edit17,'String'));
    NAS.data.parameters.maxNumOfSegments                = str2double(get(handles.edit18,'String'));
    NAS.data.parameters.isEliminateAxon                 = get(handles.checkbox1,'Value');
    NAS.data.parameters.isEliminateStemDendWithNoDaugther = get(handles.checkbox2,'Value');
    NAS.data.parameters.isEliminateUnbranchedTrees      = get(handles.checkbox3,'Value');

    NAS.data.properties.custom.species          = get(handles.edit2, 'String');
    NAS.data.properties.custom.name            = get(handles.edit3, 'String');
    NAS.data.properties.custom.lab              = get(handles.edit4, 'String');
    NAS.data.properties.custom.tertiaryCellClass = get(handles.edit5, 'String');
    NAS.data.properties.custom.development      = get(handles.edit6, 'String');

    NAS.guiData.changedValue = 1;

    NAS.data.parameters.passiveParams.('Cm')    = str2double(get(handles.edit22,'String'));
    NAS.data.parameters.passiveParams.('Rm_soma')= str2double(get(handles.edit23,'String'));
    NAS.data.parameters.passiveParams.('Rm_dend')= str2double(get(handles.edit24,'String'));
    NAS.data.parameters.passiveParams.('Ra')    = str2double(get(handles.edit25,'String'));
    NAS.data.parameters.sampleFreq              = str2double(get(handles.edit26,'String'));
    
    close(gcbf);
%     set(NAS.gui.single_analyze_configParams,'Visible','off');
    
    
