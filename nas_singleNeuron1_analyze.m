function varargout = nas_singleNeuron1_analyze(varargin)
% NAS_SINGLENEURON1_ANALYZE MATLAB code for nas_singleNeuron1_analyze.fig
%      NAS_SINGLENEURON1_ANALYZE, by itself, creates a new NAS_SINGLENEURON1_ANALYZE or raises the existing
%      singleton*.
%
%      H = NAS_SINGLENEURON1_ANALYZE returns the handle to a new NAS_SINGLENEURON1_ANALYZE or the handle to
%      the existing singleton*.
%
%      NAS_SINGLENEURON1_ANALYZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAS_SINGLENEURON1_ANALYZE.M with the given input arguments.
%
%      NAS_SINGLENEURON1_ANALYZE('Property','Value',...) creates a new NAS_SINGLENEURON1_ANALYZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nas_singleNeuron1_analyze_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nas_singleNeuron1_analyze_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nas_singleNeuron1_analyze

% Last Modified by GUIDE v2.5 26-Oct-2017 11:52:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nas_singleNeuron1_analyze_OpeningFcn, ...
                   'gui_OutputFcn',  @nas_singleNeuron1_analyze_OutputFcn, ...
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


% --- Executes just before nas_singleNeuron1_analyze is made visible.
function nas_singleNeuron1_analyze_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nas_singleNeuron1_analyze (see VARARGIN)

% Choose default command line output for nas_singleNeuron1_analyze
handles.output = hObject;

global NAS;


% Assign a name to appear in the window title.
set(hObject,'Name','Neuron Analyzer and Simulator');

% Move the window to the center of the screen.
movegui(hObject,'center')


[numOfSegments, localData, flagForSpliting] = calculateLocalPropSingleNeuron (NAS.guiData.selectedNeuron, NAS.data.parameters, NAS.data.parameters.geometryType, NAS.data.parameters.maxCompartmentLength);
   
NAS.data.properties.('custom').('numOfSegments') = numOfSegments;
NAS.data.properties.('custom').('data').('local') = localData;

if flagForSpliting
    h = msgbox(sprintf('%s\n%s\n\n   %s%d', 'Neuron segments were splited to improve computational accuracy',...
        'according to the value specified in the parameters...',...
        '      Number of splited segments:', numOfSegments));
    set(h, 'WindowStyle', 'modal');
    uiwait(h);
end

display('.................');
display(sprintf('Processing electrotonics: %s', NAS.guiData.selectedNeuron));
display('.................');


NAS.data.properties.custom = processElectrotonicData2 (NAS.data.properties.custom, NAS.data.parameters.passiveParams, NAS.data.parameters.geometryType);




display('.................');
display(sprintf('Processing Sholl-like analysis: %s', NAS.guiData.selectedNeuron));
display('.................');
 

NAS.data.properties.custom.('data').('somatofugal').('euclidian') = getSomatofugalProperties3 (NAS.data.properties.custom, NAS.data.parameters, 'euclidian', 0, 0);
NAS.data.properties.custom.('data').('somatofugal').('path') = getSomatofugalProperties3 (NAS.data.properties.custom, NAS.data.parameters, 'path', 0, 0);
NAS.data.properties.custom.('data').('somatofugal').('order') = getSomatofugalProperties3 (NAS.data.properties.custom, NAS.data.parameters, 'order', 0, 0);


display('.................');
display(sprintf('Processing dendritic trees: %s', NAS.guiData.selectedNeuron));
display('.................');


[NAS.data.properties.custom.('data').('branchLevel'), NAS.data.properties.custom.('data').('treeLevel'),...
    zeroOrderSegments, NAS.data.properties.custom.('data').('local').segmentsFromUnbranchedSubTrees] = getTreeProperties2 (NAS.data.properties.custom, NAS.data.parameters);

NAS.data.properties.custom.('data').('zeroOrderSegments') = zeroOrderSegments;
   
display('.................');
display(sprintf('Processing global properties: %s', NAS.guiData.selectedNeuron));
display('.................');

NAS.data.properties.custom.('data').('neuronLevel') = calculateGlobalProp (NAS.data.properties.custom, NAS.data.parameters);
                
set(handles.text6,'String',sprintf('Morphoelectronic analyses: %s',NAS.guiData.selectedNeuron));
set(handles.text6,'Visible','on');
set(handles.text7,'Visible','off');
set(handles.pushbutton8,'Visible','off');
set(handles.text8,'Visible','off');
set(handles.popupmenu2,'Visible','off');



% Update handles structure
guidata(hObject, handles);



% UIWAIT makes nas_singleNeuron1_analyze wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nas_singleNeuron1_analyze_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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
%     set(NAS.gui.single_analyze,'Visible','off');
    close(gcbf);


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

    str = sprintf(strcat('Measured values:\n\nNumber of segments: %d\nTotal area of stem dendrites: %.2f um\n',...
        'Soma area: %.2f um^2\nTotal area: %.2f um^2\nTotal path length: %.2f um\nMaximum Euclidian distance: %.2f um\n',...
        'Maximum path distance: %.2f um\nNumber of bifurcations: %d\nNumber of terminations: %d\nNumber of  branches: %d\n',...
        'Maximum branch order: %d \nSomatic input impedance: %.2f kOhm'),...
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
    set(handles.text9,'Visible','off');
    set(handles.axes2,'Visible','off');
    set(handles.axes3,'Visible','off');
    set(handles.popupmenu2,'Visible','on');

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global NAS;
    
    diameter = NAS.data.properties.custom.data.branchLevel.diameter;
    [groupName{1:length(diameter)}] = deal('diameter');
    boxplot(diameter, groupName', 'notch', 'on', ...
    'orientation','horizontal', 'plotstyle', 'compact')
    hnl = findobj(gca, 'Tag', 'NotchLo');
    set(hnl, 'Marker', '+', 'MarkerSize', 9)
    hnh = findobj(gca, 'Tag', 'NotchHi');
    set(hnh, 'Marker', '+', 'MarkerSize', 9)
    
    

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
    global NAS;
    NAS.gui.single_analyze_configParams = nas_singleNeuron1_analyze_configParams;
%     set(NAS.gui.single_analyze,'Visible','on');
    set(NAS.gui.single_analyze_configParams,'Visible','on');


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
    % hObject    handle to popupmenu3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popupmenu3

    global NAS;
    axes(handles.axes2);
    cla(handles.axes2, 'reset');
    contents = cellstr(get(hObject,'String'));
    chosenProp = contents{get(hObject,'Value')};
    prop = NAS.data.properties.custom.data.branchLevel.(chosenProp);
%     [groupName{1:length(prop)}] = deal(chosenProp);
    boxplot(prop, 'notch', 'on', ...
    'orientation','horizontal', 'plotstyle', 'compact')
    title(chosenProp)
    if(strcmp(chosenProp, 'diameter'))
        title('Diameter (um)');
    end
    set(gca,'yticklabel',{[]}) 
    hnl = findobj(gca, 'Tag', 'NotchLo');
    set(hnl, 'Marker', '+', 'MarkerSize', 9)
    hnh = findobj(gca, 'Tag', 'NotchHi');
    set(hnh, 'Marker', '+', 'MarkerSize', 9)

    str = sprintf(strcat('Statistical parameters:\nMinimum: %.2f\nLower quartile: %.2f\n',...
        'Median: %.2f\nUpper quartile: %.2f\nMaximum: %.2f\nMean: %.2f\n',...
        'Standard deviation: %.2f\nTotal (sum): %d'),...
        min(prop),...
        quantile(prop, 0.25),...
        quantile(prop, 0.5),... 
        quantile(prop, 0.75),...
        max(prop),... 
        mean(prop),...
        std(prop),...
        sum(prop));

    set(handles.text9,'String', str);
    set(handles.text9,'Visible','on');
    set(handles.pushbutton8,'Visible','on');
    
    
    set(handles.text8,'Visible','on');
    set(handles.popupmenu2,'Visible','on');
    set(handles.text7,'Visible','off');
    set(handles.text9,'Visible','on');
    set(handles.axes2,'Visible','on');
    set(handles.axes3,'Visible','off');

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


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
    global NAS;
    axes(handles.axes2);
    cla(handles.axes2, 'reset');
    contents = cellstr(get(hObject,'String'));
    chosenProp = contents{get(hObject,'Value')};
    prop = NAS.data.properties.custom.data.branchLevel.(chosenProp);
%     [groupName{1:length(prop)}] = deal(chosenProp);
    boxplot(prop, 'notch', 'on', ...
    'orientation','horizontal', 'plotstyle', 'compact')
    title(chosenProp)
    if(strcmp(chosenProp, 'diameter'))
        title('Diameter um');
    end
    set(gca,'yticklabel',{[]}) 
    hnl = findobj(gca, 'Tag', 'NotchLo');
    set(hnl, 'Marker', '+', 'MarkerSize', 9)
    hnh = findobj(gca, 'Tag', 'NotchHi');
    set(hnh, 'Marker', '+', 'MarkerSize', 9)

    str = sprintf(strcat('Statistical parameters:\nMinimum: %.2f\nLower quartile: %.2f\n',...
        'Median: %.2f\nUpper quartile: %.2f\nMaximum: %.2f\nMean: %.2f\n',...
        'Standard deviation: %.2f\nTotal (sum): %d'),...
        min(prop),...
        quantile(prop, 0.25),...
        quantile(prop, 0.5),... 
        quantile(prop, 0.75),...
        max(prop),... 
        mean(prop),...
        std(prop),...
        sum(prop));

    set(handles.text9,'String', str);
    set(handles.text9,'Visible','on');
    set(handles.pushbutton8,'Visible','on');
    
    set(handles.text8,'Visible','on');
    set(handles.popupmenu2,'Visible','on');
    set(handles.text7,'Visible','off');
    set(handles.axes2,'Visible','on');
    set(handles.axes3,'Visible','off');

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
    global NAS;
    cla(handles.axes2, 'reset');
    set(handles.axes2,'Visible','off')
    axes(handles.axes3)
    set(handles.text9,'Visible','off')
    set(handles.text8,'Visible','off');
    set(handles.text7,'Visible','off');
    set(handles.popupmenu2,'Visible','off');
    set(handles.pushbutton8,'Visible','off');
    
    contents = cellstr(get(hObject,'String'));
    metric = contents{get(hObject,'Value')};
    
    contents2 = cellstr(get(handles.popupmenu6,'String'));
    chosenProp = contents2{get(handles.popupmenu6,'Value')};
    
    axes(handles.axes3);
    cla(handles.axes3, 'reset');
    
    set(handles.axes3,'XTickMode','auto')
    set(handles.axes3,'YTickMode','auto')
    
    somatofugalParams = NAS.data.parameters.somatofugalParams;
    somatofugalParams.('metric') = metric;
    
    axisFontSize = 4;
    xLabelFontSize = 6;
    yLabelFontSize = 6;
    cmap = winter(length(NAS.data.properties.('custom').data.zeroOrderSegments));
    sym = '.';
    siz = 6;
    
    YScale = 'linear';
    XScale = 'linear';
    
    
    
    plotSomatofugalPropColorByTree (NAS.data.properties.('custom'), NAS.data.parameters, metric, chosenProp, sym, siz, cmap, 0);
    set(gca, 'XScale', XScale, 'YScale', YScale);
    xlabel(metric);
    ylabel(chosenProp);
    ylimit = get(gca, 'ylim');
    ylim([0, ylimit(2)]);
    
    
    



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


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6
    global NAS;
    cla(handles.axes2, 'reset');
    set(handles.axes2,'Visible','off')
    axes(handles.axes3)
    set(handles.text8,'Visible','off');
    set(handles.text8,'Visible','off');
    set(handles.popupmenu2,'Visible','off');
    set(handles.pushbutton8,'Visible','off');
    
    contents = cellstr(get(hObject,'String'));
    chosenProp = contents{get(hObject,'Value')};
    
    contents2 = cellstr(get(handles.popupmenu5,'String'));
    metric = contents2{get(handles.popupmenu5,'Value')};
    
    axes(handles.axes3);
    cla(handles.axes3, 'reset');
    
    set(handles.axes3,'XTickMode','auto')
    set(handles.axes3,'YTickMode','auto')
    
    somatofugalParams = NAS.data.parameters.somatofugalParams;
    somatofugalParams.('metric') = metric;
    
    axisFontSize = 4;
    xLabelFontSize = 6;
    yLabelFontSize = 6;
    cmap = winter(length(NAS.data.properties.('custom').data.zeroOrderSegments));
    sym = '.';
    siz = 6;
    
    YScale = 'linear';
    XScale = 'linear';
    
    
    
    plotSomatofugalPropColorByTree (NAS.data.properties.('custom'), NAS.data.parameters, metric, chosenProp, sym, siz, cmap, 0);
    set(gca, 'XScale', XScale, 'YScale', YScale);
    xlabel(metric);
    ylabel(chosenProp);
    ylimit = get(gca, 'ylim');
    ylim([0, ylimit(2)]);

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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
    NAS.gui.single = nas_singleNeuron1;
    set(NAS.gui.single,'Visible','on');
    close(gcbf);


% --------------------------------------------------------------------
function saveScenario_Callback(hObject, eventdata, handles)
% hObject    handle to saveScenario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global NAS;
    [filename,pathname,FilterIndex] = uiputfile('exported_scenario1.mat');
    if FilterIndex
        save(fullfile(pathname, filename), 'NAS');
    end


% --------------------------------------------------------------------
function loadScenario_Callback(hObject, eventdata, handles)
% hObject    handle to loadScenario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile({'*.mat','mat Files'}, 'Select a scenario');
if ~filename
    msgbox('You did not select a scenario');
    return;
else
    uiopen(fullfile(pathname, filename));
end

% --- Executes when uipanel1 is resized.
function uipanel1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NAS;
set(NAS.gui.single,'Visible','on');
close(gcbf);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
