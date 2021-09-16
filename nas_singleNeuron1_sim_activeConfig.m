function varargout = nas_singleNeuron1_sim_activeConfig(varargin)
% NAS_SINGLENEURON1_SIM_ACTIVECONFIG MATLAB code for nas_singleNeuron1_sim_activeConfig.fig
%      NAS_SINGLENEURON1_SIM_ACTIVECONFIG, by itself, creates a new NAS_SINGLENEURON1_SIM_ACTIVECONFIG or raises the existing
%      singleton*.
%
%      H = NAS_SINGLENEURON1_SIM_ACTIVECONFIG returns the handle to a new NAS_SINGLENEURON1_SIM_ACTIVECONFIG or the handle to
%      the existing singleton*.
%
%      NAS_SINGLENEURON1_SIM_ACTIVECONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAS_SINGLENEURON1_SIM_ACTIVECONFIG.M with the given input arguments.
%
%      NAS_SINGLENEURON1_SIM_ACTIVECONFIG('Property','Value',...) creates a new NAS_SINGLENEURON1_SIM_ACTIVECONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nas_singleNeuron1_sim_activeConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nas_singleNeuron1_sim_activeConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nas_singleNeuron1_sim_activeConfig

% Last Modified by GUIDE v2.5 29-Sep-2017 13:34:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nas_singleNeuron1_sim_activeConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @nas_singleNeuron1_sim_activeConfig_OutputFcn, ...
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


% --- Executes just before nas_singleNeuron1_sim_activeConfig is made visible.
function nas_singleNeuron1_sim_activeConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nas_singleNeuron1_sim_activeConfig (see VARARGIN)

% Choose default command line output for nas_singleNeuron1_sim_activeConfig
handles.output = hObject;

global NAS;

set(handles.edit2, 'String',  NAS.data.parameters.('simulationParams').('input').('nameChosen'));
set(handles.popupmenu7, 'String',  NAS.data.parameters.('simulationParams').('input').('inputTypes'));
set(handles.popupmenu8, 'String',  NAS.data.parameters.('simulationParams').('input').('waveForms'));
set(handles.popupmenu9, 'String',  NAS.data.parameters.('simulationParams').('input').('targets'));


set(handles.edit3, 'String',  sprintf('%.1f', NAS.data.parameters.('simulationParams').('input').('trapezoid').('t1')));
set(handles.edit11, 'String',  sprintf('%.1f', NAS.data.parameters.('simulationParams').('input').('trapezoid').('t2')));
set(handles.edit12, 'String',  sprintf('%.1f', NAS.data.parameters.('simulationParams').('input').('trapezoid').('t3')));
set(handles.edit13, 'String',  sprintf('%.1f', NAS.data.parameters.('simulationParams').('input').('trapezoid').('t4')));
set(handles.edit14, 'String',  sprintf('%.1f', NAS.data.parameters.('simulationParams').('input').('trapezoid').('i1')));
set(handles.edit15, 'String',  sprintf('%.1f', NAS.data.parameters.('simulationParams').('input').('trapezoid').('i2')));


% Assign a name to appear in the window title.
set(hObject,'Name','Neuron Analyzer and Simulator');

% Move the window to the center of the screen.
movegui(hObject,'center')


[numOfSegments, localData, flagForSpliting] = calculateLocalPropSingleNeuron (NAS.guiData.selectedNeuron, NAS.data.parameters, NAS.data.parameters.geometryType, NAS.data.parameters.maxCompartmentLength);
    
NAS.data.properties.('custom').('data').('local') = localData;


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


set(handles.text18,'String',sprintf('Setting input to neuron: %s',NAS.guiData.selectedNeuron));
set(handles.text18,'Visible','on');

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes nas_singleNeuron1_sim_activeConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nas_singleNeuron1_sim_activeConfig_OutputFcn(hObject, eventdata, handles) 
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
%     set(NAS.gui.single_sim,'Visible','off');
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
    set(handles.text9,'Visible','off');
    set(handles.axes2,'Visible','off');
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
    
%     sym = '.';
%     siz = 22;
%     xlabelSize = 8;
%     ylabelSize = 5;
%     titleSize = 9;
%     axisFontSize = 5;
%     legendFontSize = 9;
%     
%     
%     featureNames = MNS.analysis.scenario7.data.neuronLevel.featureNamesMatrix.morphological;
%     X = MNS.analysis.scenario7.data.neuronLevel.dataMatrix.morphological;
%     labels = MNS.analysis.scenario7.data.neuronLevel.labelsMatrix.morphological;
%     featureNamesShort = MNS.analysis.scenario7.data.neuronLevel.featureNamesShortMatrix.morphological;
%     
%     numOfLines =4;
%     numOfColumns = 8;
%     
%     
%     handles = [];
%     
%     for i = 1:length(featureNames)
%         handles(i) = subplot(numOfLines, numOfColumns, i);
%         
%         boxplot(X(:,i),labels.partition, 'notch', 'on', ...
%             'orientation','horizontal', 'colorgroup', labels.lab, 'plotstyle', 'compact')
%         hnl = findobj(gca, 'Tag', 'NotchLo');
%         set(hnl, 'Marker', '+', 'MarkerSize', 9)
%         hnh = findobj(gca, 'Tag', 'NotchHi');
%         set(hnh, 'Marker', '+', 'MarkerSize', 9)
%         
%         xlabel(featureNamesShort(i), 'FontSize', xlabelSize)
%         xlimit = get(gca, 'xlim');
%         xlim([max([xlimit(1), 0]), xlimit(2)]);
%         
%         if strcmp(featureNames(i), 'Diameter (um)')
%             xlim([0, 13]);
%         elseif strcmp(featureNames(i), 'Radial distance (um)')
%             xlim([-100, 1950]);
%         elseif strcmp(featureNames(i), 'Fractal dimension')
%             xlim([0.75, 1.3]);
%         elseif strcmp(featureNames(i), 'Contraction')
%             xlim([0.9, 2.25]);
%         elseif strcmp(featureNames(i), 'Degree')
%             xlim([0, 26]);
%         elseif strcmp(featureNames(i), 'Partition asymmetry')
%             xlim([-0.3, 1.3]);
%         elseif strcmp(featureNames(i), 'Horton-Strahler index')
%             xlim([0, 15.5]);
%         elseif strcmp(featureNames(i), 'Branch-point Rall ratio')
%             xlim([-0.1, 4]);
%         elseif strcmp(featureNames(i), 'Euclidian length (um)')
%             xlim([0, 970]);
%         elseif strcmp(featureNames(i), 'Branch path length (um)')
%             xlim([0, 1050]);
%         elseif strcmp(featureNames(i), 'Area (um^2)')
%             xlim([-50, 9005]);
%         end
%     end
%     
%     for i = 1:length(featureNames)
%         line = floor((i-1)/numOfColumns) + 1;
%         column = rem(i, numOfColumns);
%         if column==0; column=numOfColumns; end
%         
%         
%         if column==1
%             set(handles(i),'ytickmode','auto','yticklabelmode','auto')
%             ylimits = get(handles(i), 'ylim');
%             minimum = ylimits(1) + 0.5;
%             maximum = ylimits(2) - 0.5;
%             set(handles(i),'ytick', linspace(minimum,maximum,12)); 
%             set(handles(i),'yticklabel', {'p1'; 'p2'; 'p3'; 'p4'; 'p5'; 'p6'; 'p7'; 'p8'; 'p9'; 'p10'; 'p11'; 'p12'});
%             set(handles(i), 'Position', [0.05 + 0.9*((column-1)/numOfColumns),   1.06 - line/numOfLines,    0.11,    0.18]);
%             
%         else
%             set(handles(i),'ytickmode','auto','yticklabelmode','auto')
%             set(handles(i),'ytick', [0]); 
%             set(handles(i),'yticklabel', {'.'});
%             set(handles(i), 'Position', [0.05 + 0.9*((column-1)/numOfColumns),   1.06 - line/numOfLines,    0.11,    0.18]);
%         end
%         
%         
%         
%         set(handles(i), 'FontSize', axisFontSize);
%         set(findobj(handles(i),'Type','text'),'FontSize',axisFontSize)
%         
%     end


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
    contents = cellstr(get(hObject,'String'));
    chosenProp = contents{get(hObject,'Value')};
    prop = NAS.data.properties.custom.data.branchLevel.(chosenProp);
%     [groupName{1:length(prop)}] = deal(chosenProp);
    boxplot(prop, 'notch', 'on', ...
    'orientation','horizontal', 'plotstyle', 'compact')
    title(chosenProp)
    set(gca,'yticklabel',{[]}) 
    hnl = findobj(gca, 'Tag', 'NotchLo');
    set(hnl, 'Marker', '+', 'MarkerSize', 9)
    hnh = findobj(gca, 'Tag', 'NotchHi');
    set(hnh, 'Marker', '+', 'MarkerSize', 9)

%     str = sprintf(strcat('Measure values:\nNumber of segments: %d\nTotal area of stem dendrites: %.2f um\n',...
%         'Soma area: %.2f um^2\nTotal area: %.2f um^2\nTotal path length: %.2f um\nMaximum Euclidian distance: %.2f um\n',...
%         'Maximum path distance: %.2f um\nNumber of bifurcations: %d\nNumber of terminations: %d\nNumber of  branches: %d\n',...
%         'Maximum branch order: %d \nSomatic input impedance: %.2f MOhm'),...
%         NAS.data.properties.custom.numOfSegments,...
%         NAS.data.properties.custom.data.neuronLevel.areaTotalStemDendrites,...
%         NAS.data.properties.custom.data.neuronLevel.areaSoma,...
%         NAS.data.properties.custom.data.neuronLevel.areaTotal,... 
%         NAS.data.properties.custom.data.neuronLevel.totalPathLength,...
%         NAS.data.properties.custom.data.neuronLevel.maxEuclidianDistance,... 
%         NAS.data.properties.custom.data.neuronLevel.maxPathDistance,...
%         NAS.data.properties.custom.data.neuronLevel.numOfBifurcations,...
%         NAS.data.properties.custom.data.neuronLevel.numOfTerminations,...
%         NAS.data.properties.custom.data.neuronLevel.numOfBranches,...
%         NAS.data.properties.custom.data.neuronLevel.maxBranchOrder,...
%         NAS.data.properties.custom.data.neuronLevel.somaticInputImpedance);
% 
%     set(handles.text9,'String', str);
%     set(handles.text9,'Visible','on');
%     set(handles.pushbutton8,'Visible','on');
    set(handles.text7,'Visible','off');
    set(handles.text9,'Visible','on');
    set(handles.axes2,'Visible','on');

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
    set(NAS.gui.single_sim,'Visible','off');
    set(NAS.gui.single,'Visible','on');

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton12 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global NAS;
    NAS.gui.single_analyze_configParams = nas_singleNeuron1_analyze_configParams;
%     set(NAS.gui.single_analyze,'Visible','on');
    set(NAS.gui.single_analyze_configParams,'Visible','on');

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.uipanel6,'Visible','on');
    set(handles.uipanel7,'Visible','off');
    set(handles.uipanel9,'Visible','off');
    set(handles.uipanel8,'Visible','off');




% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
    global NAS;
    axes(handles.axes4);
    cla(gca, 'reset');
    
    set(gca,'XTickMode','auto')
    set(gca,'YTickMode','auto')
    
    initialTime = NAS.data.parameters.('simulationParams').('initialTime');
    finalTime = NAS.data.parameters.('simulationParams').('finalTime');
    
    contents = cellstr(get(handles.popupmenu7,'String'));
    value = get(handles.popupmenu7,'Value');
    if strcmp(contents{value}, 'Injected current')

        contents = cellstr(get(handles.popupmenu8,'String'));
        value = get(handles.popupmenu8,'Value');
        if strcmp(contents{value}, 'Trapezoid')

            t1 = str2double(get(handles.edit3, 'String'));
            t2 = str2double(get(handles.edit11, 'String'));
            t3 = str2double(get(handles.edit12, 'String'));
            t4 = str2double(get(handles.edit13, 'String'));
            i1 = str2double(get(handles.edit14, 'String'));
            i2 = str2double(get(handles.edit15, 'String'));

            timeStep = 1;
            numOfPoints = (finalTime - initialTime)/timeStep + 1;
            x = zeros(numOfPoints, 1);
            y = zeros(numOfPoints, 1);
            idx = 0;
            for t = initialTime:timeStep:finalTime
                idx = idx + 1;
                x(idx) = t;
                y(idx) = getSignal('trapezoid', t1, t4, i1, i2, t, t2, t3);
            end

            h = plot(x, y);
            set(h, 'LineStyle','none','Marker', 'o',...
                    'MarkerEdgeColor',[0.509, 0.309, 0.490],...
                    'MarkerFaceColor',[0.509, 0.309, 0.490],...
                    'MarkerSize',2)
            xlabel('Time (ms)');
            ylabel('Injected current (\muA/cm^2)');
            set(gca,'xlim',[initialTime finalTime]);   
            clear 'idx'  'x'  'y';
        else
            msgbox('This function is unavailable at this development stage');
        end
    end
    if strcmp(contents{value}, 'Synapse')
        
    end
    
    
function edit2_Callback(hObject, eventdata, handles)

    global NAS;
    NAS.data.parameters.('simulationParams').('input').name = get(handles.edit2, 'String');

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


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(handles.listbox5,'String'));
value = get(handles.listbox5,'Value');
str = contents{value};
contents2 = cellstr(get(handles.listbox4,'String'));

if strcmp(contents2{1}, 'none')
    contents2{1} = [str];
else
    contents2{end+1} = [str];
end
set(handles.listbox4, 'String', contents2);


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.uipanel9,'Visible','on');

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton23 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    contents = cellstr(get(handles.listbox4,'String'));
    
    idx = get(handles.listbox4,'Value');
    if strcmp(contents{1}, 'none')
        errordlg('There is no input yet');
    else
        contents(idx) = [];
    end
    if length(contents) == 0
        contents{1} = 'none';
    end
    newValue = get(handles.listbox4, 'Value') - 1;
    if newValue<=0
        newValue=1;
    end
    set(handles.listbox4, 'String', contents, 'Value', newValue);
    

% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton18 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    contents = cellstr(get(handles.listbox3,'String'));
    str = contents{get(handles.listbox3,'Value')};
    contents2 = cellstr(get(handles.listbox2,'String'));
    if strcmp(contents2{1}, 'none')
        contents2{1} = [str];
    else
        contents2{end+1} = [str];
    end
    set(handles.listbox2, 'String', contents2);

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.uipanel7,'Visible','on');

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
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



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
    global NAS;
    
    NAS.guiData.parameters.('simulationParams').('input').('nameChosen') = get(handles.edit2,'String');
    
    contents = cellstr(get(handles.popupmenu7,'String'));
    value = get(handles.popupmenu7,'Value');
    NAS.guiData.parameters.('simulationParams').('input').('inputTypeChosen') = contents{value};
    
    contents = cellstr(get(handles.popupmenu8,'String'));
    value = get(handles.popupmenu8,'Value');
    NAS.guiData.parameters.('simulationParams').('input').('waveFormChosen') = contents{value};
    
    contents = cellstr(get(handles.popupmenu9,'String'));
    value = get(handles.popupmenu9,'Value');
    NAS.guiData.parameters.('simulationParams').('input').('targetChosen') = contents{value};
    
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('t1') = str2double(get(handles.edit3, 'String'));
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('t2') = str2double(get(handles.edit11, 'String'));
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('t3') = str2double(get(handles.edit12, 'String'));
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('t4') = str2double(get(handles.edit13, 'String'));
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('i1') = str2double(get(handles.edit14, 'String'));
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('i2') = str2double(get(handles.edit15, 'String'));
    

% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
    close(gcbf);


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
    global NAS;
    
    NAS.data.parameters.('simulationParams').('input').('nameChosen') = get(handles.edit2,'String');
    
    contents = cellstr(get(handles.popupmenu7,'String'));
    value = get(handles.popupmenu7,'Value');
    NAS.data.parameters.('simulationParams').('input').('inputTypeChosen') = contents{value};
    
    contents = cellstr(get(handles.popupmenu8,'String'));
    value = get(handles.popupmenu8,'Value');
    NAS.data.parameters.('simulationParams').('input').('waveFormChosen') = contents{value};
    
    contents = cellstr(get(handles.popupmenu9,'String'));
    value = get(handles.popupmenu9,'Value');
    NAS.data.parameters.('simulationParams').('input').('targetChosen') = contents{value};
    
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('t1') = str2double(get(handles.edit3, 'String'));
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('t2') = str2double(get(handles.edit11, 'String'));
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('t3') = str2double(get(handles.edit12, 'String'));
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('t4') = str2double(get(handles.edit13, 'String'));
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('i1') = str2double(get(handles.edit14, 'String'));
    NAS.data.parameters.('simulationParams').('input').('trapezoid').('i2') = str2double(get(handles.edit15, 'String'));
    
    close(gcbf);


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
    contents = cellstr(get(handles.popupmenu7,'String'));
    value = get(handles.popupmenu7,'Value');
    if strcmp(contents{value}, 'Injected current')
        set(handles.text33, 'Visible', 'on');
        set(handles.text44, 'Visible', 'on');
        set(handles.text46, 'Visible', 'on');
        set(handles.text48, 'Visible', 'on');
        set(handles.text45, 'Visible', 'on');
        set(handles.text47, 'Visible', 'on');
        set(handles.edit3, 'Visible', 'on');
        set(handles.edit11, 'Visible', 'on');
        set(handles.edit12, 'Visible', 'on');
        set(handles.edit13, 'Visible', 'on');
        set(handles.edit14, 'Visible', 'on');
        set(handles.edit15, 'Visible', 'on');
        set(handles.pushbutton14, 'Visible', 'on');
    end
    
    
% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)

    set(handles.text33, 'Visible', 'off');
    set(handles.text44, 'Visible', 'off');
    set(handles.text46, 'Visible', 'off');
    set(handles.text48, 'Visible', 'off');
    set(handles.text45, 'Visible', 'off');
    set(handles.text47, 'Visible', 'off');
    set(handles.edit3, 'Visible', 'off');
    set(handles.edit11, 'Visible', 'off');
    set(handles.edit12, 'Visible', 'off');
    set(handles.edit13, 'Visible', 'off');
    set(handles.edit14, 'Visible', 'off');
    set(handles.edit15, 'Visible', 'off');
    set(handles.pushbutton14, 'Visible', 'off');
    
    contents = cellstr(get(handles.popupmenu8,'String'));
    value = get(handles.popupmenu8,'Value');
    if ~strcmp(contents{value}, 'Trapezoid')
        msgbox('This function is unavailable at this development stage');
    else
        set(handles.text33, 'Visible', 'on');
        set(handles.text44, 'Visible', 'on');
        set(handles.text46, 'Visible', 'on');
        set(handles.text48, 'Visible', 'on');
        set(handles.text45, 'Visible', 'on');
        set(handles.text47, 'Visible', 'on');
        set(handles.edit3, 'Visible', 'on');
        set(handles.edit11, 'Visible', 'on');
        set(handles.edit12, 'Visible', 'on');
        set(handles.edit13, 'Visible', 'on');
        set(handles.edit14, 'Visible', 'on');
        set(handles.edit15, 'Visible', 'on');
        set(handles.pushbutton14, 'Visible', 'on');
    end
    
% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
    contents = cellstr(get(handles.popupmenu9,'String'));
    value = get(handles.popupmenu9,'Value');
    if ~strcmp(contents{value}, 'Whole neuron') &&...
       ~strcmp(contents{value}, 'Soma only') &&...
       ~strcmp(contents{value}, 'All dendrites')
        msgbox('This function is unavailable at this development stage');
    end
    


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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

% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox6


% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
