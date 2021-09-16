function varargout = nas_singleNeuron1_sim(varargin)
% NAS_SINGLENEURON1_SIM MATLAB code for nas_singleNeuron1_sim.fig
%      NAS_SINGLENEURON1_SIM, by itself, creates a new NAS_SINGLENEURON1_SIM or raises the existing
%      singleton*.
%
%      H = NAS_SINGLENEURON1_SIM returns the handle to a new NAS_SINGLENEURON1_SIM or the handle to
%      the existing singleton*.
%
%      NAS_SINGLENEURON1_SIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAS_SINGLENEURON1_SIM.M with the given input arguments.
%
%      NAS_SINGLENEURON1_SIM('Property','Value',...) creates a new NAS_SINGLENEURON1_SIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nas_singleNeuron1_sim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nas_singleNeuron1_sim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nas_singleNeuron1_sim

% Last Modified by GUIDE v2.5 13-Oct-2017 09:18:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nas_singleNeuron1_sim_OpeningFcn, ...
                   'gui_OutputFcn',  @nas_singleNeuron1_sim_OutputFcn, ...
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


% --- Executes just before nas_singleNeuron1_sim is made visible.
function nas_singleNeuron1_sim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nas_singleNeuron1_sim (see VARARGIN)

% Choose default command line output for nas_singleNeuron1_sim
handles.output = hObject;

global NAS;

NAS.guiData.isShowProgress = 1;
NAS.guiData.isSimProgress = 0;
NAS.guiData.isFinishedSim = 0;
NAS.guiData.isSimPause = 0;
NAS.guiData.isSimCancel = 0;
NAS.guiData.changedValue = 0;

set(handles.text15, 'String', sprintf('%.3f', NAS.data.parameters.('simulationParams').('initialTime')));
set(handles.edit2, 'String',  sprintf('%.3f', NAS.data.parameters.('simulationParams').('finalTime')));
set(handles.edit3, 'String',  sprintf('%.3f', NAS.data.parameters.('simulationParams').('timeStep')));
set(handles.checkbox4, 'Value', 1);
set(handles.checkbox5, 'Value', 1);
set(handles.axes6, 'Visible', 'off');
set(handles.axes4, 'Visible', 'off');
set(handles.text42, 'Visible', 'off');

guidata(hObject, handles);



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
        '     Number of splited segments:', numOfSegments));
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
                
set(handles.text18,'String',sprintf('Simulation of neuron: %s',NAS.guiData.selectedNeuron));
set(handles.text18,'Visible','on');

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = nas_singleNeuron1_sim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_home_Callback(hObject, eventdata, handles)
    global NAS;
    set(NAS.gui.home,'Visible','on');
%     set(NAS.gui.single_sim,'Visible','off');
    close(gcbf);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
    global NAS;
    NAS.gui.single_analyze_3DTool = nas_singleNeuron1_analyze_3DTool;
    set(NAS.gui.single_analyze_3DTool,'Visible','on');
    
    

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)

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
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


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





% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
    global NAS;
    NAS.gui.single_analyze_configParams = nas_singleNeuron1_analyze_configParams;
%     set(NAS.gui.single_analyze,'Visible','on');
    set(NAS.gui.single_analyze_configParams,'Visible','on');


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
    global NAS;
%     set(NAS.gui.single_sim,'Visible','off');
    set(NAS.gui.single,'Visible','on');
    close(gcbf);
    
% --- callback resumeSim
function resumeSim(hObject, eventdata, handles)
    NAS.guiData.isSimPause = 0;
    close(gcf);
    
% --- callback cancelSim
function cancelSim(hObject, eventdata, handles)
    global NAS;
    NAS.guiData.isSimCancel = 1;
    NAS.guiData.isSimPause = 0;
    close(gcf);    
    
% --- callback previewSim
function previewResult(hObject, eventdata, handles)
    global NAS;
    NAS.guiData.isSimPreview = 1;
    NAS.guiData.isSimPause = 0;
    close(gcf);    
    
% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)

    global NAS;
    NAS.guiData.isSimPause = 0;
    NAS.guiData.isSimCancel = 0;
    NAS.guiData.isSimPreview = 0;
    NAS.data.parameters.('simulationParams').('finalTime') = str2double(get(handles.edit2, 'String'));
    NAS.data.parameters.('simulationParams').('timeStep') = str2double(get(handles.edit3, 'String'));
    
    set(handles.uipanel6, 'Visible', 'off');
    set(handles.uipanel7, 'Visible', 'off');
    set(handles.uipanel8, 'Visible', 'off');
    set(handles.uipanel9, 'Visible', 'off');
    set(handles.pushbutton31, 'Visible', 'on');
    
    numOfSegments           = NAS.data.properties.custom.('numOfSegments');
    type                    = NAS.data.properties.custom.('data').('local').('type');
    parent                  = NAS.data.properties.custom.('data').('local').('parent');
    childs_cellarray        = NAS.data.properties.custom.('data').('local').('childs_cellarray');
    radius                  = NAS.data.properties.custom.('data').('local').('radius');
    
    area = NAS.data.properties.custom.data.local.area;
    segment_length = NAS.data.properties.custom.data.local.segment_length;
    geometryType = NAS.data.parameters.geometryType;
    
    
    % Normalized values
    Cm = NAS.data.parameters.passiveParams.Cm;  % [uF/cm^2]
    Rm_soma = NAS.data.parameters.passiveParams.Rm_soma; % [Ohm/cm^2]
    Rm_dend = NAS.data.parameters.passiveParams.Rm_dend; % [Ohm/cm^2]
    Ra = NAS.data.parameters.passiveParams.Ra;  % [Ohm.cm]   --  Axial resistance
    
    
    % Calculate passive parameters for each segment
    [cm, rm, ra_prox] = calculatePassiveParams4(Cm, Rm_soma, Rm_dend,...
                                        Ra, numOfSegments, type, parent, radius,...
                                        area, segment_length, geometryType);
    % cm in uF
    % rm in kOhm
    % ra_prox in kOhm
    
    EL = -70.0;
    
    % Parameters for active properties
    
%     gNa = 120 * area(1) * 1e-8; % mS -->testing
    gNa = 2000 * area(1) * 1e-8; % mS -->testing
%     gKdr = 36 * area(1) * 1e-8; % mS -->testing
    gKdr = 10000 * area(1) * 1e-8; % mS -->testing
    
    
    
    
    
    
    ENa = 55;
    theta_m_Na = -35;
    k_m_Na = -7.8;
    theta_h_Na = -55;
    k_h_Na = 7;
    EK = -80;
    theta_n_Kdr = -28;
    k_n_Kdr = -15;
    
    % Defining dynamic arrays
    V = ones(numOfSegments, 1);
    h_Na = ones(numOfSegments, 1);
    n_Kdr = ones(numOfSegments, 1);
    iInj = zeros(numOfSegments, 1);
    
    % subunit kinetics (HH-like)

    m_Na_inf = @(V)  1 / (1 + exp((V-theta_m_Na)/k_m_Na));
    h_Na_inf = @(V)  1 / (1 + exp((V-theta_h_Na)/k_h_Na));
    tau_h_Na = @(V)  120 / (exp((V+50)/15) + exp(-(V+50)/16));

    n_Kdr_inf = @(V)  1 / (1 + exp((V-theta_n_Kdr)/k_n_Kdr));
    tau_n_Kdr = @(V)  28 / (exp((V+40)/40) + exp(-(V+40)/50));
    
    V = EL*V;
    h_Na(1) = h_Na_inf(V(1));
    n_Kdr(1) = n_Kdr_inf(V(1));
    
    % setting matrices
    
    A = sparse(numOfSegments, numOfSegments);
    B = zeros(numOfSegments, 1);
    K = zeros(numOfSegments, numOfSegments);
    
    % setting synaptic occurences (Poisson)
    
    n = 1; % Shape parameter
    lambda = 1000; % Rate parameter [Hz]
    lambda = lambda/1000; % Converting to ms
    
    % Mean ISI: n/lambda
%     meanRate = lambda/n;

    
    
%     gSyn = @(t) gMaxSyn * (t/tau_syn) * exp(1/(t/tau_syn)); % alpha function
    
    % Synapses as in Destexhe 1994 (not alpha function) 
    
    Esyn = 75.0; % (mV)
    g_syn_max = 0.00001; % (mS)
    r = zeros(numOfSegments,1);
    Tmax = 2; % (mM) Maximum concentration of neurotransmitter on the synaptic claft
    alpha = 4; % (ms^-1 * mM^-1)
    beta = 4; % (ms^-1)
%     tau_syn = 1 / ((alpha * Tmax) + beta); % (ms)
%     w_syn_inf= (alpha * Tmax) / ((alpha * Tmax) + beta);
    pulseDuration = 0.5; % (ms)
    g0 = 0;
    g1 = 0;
    percOfSyn = 0.4;
    
    initialTime = NAS.data.parameters.('simulationParams').('initialTime');
    finalTime = NAS.data.parameters.('simulationParams').('finalTime');
    timeStep = NAS.data.parameters.('simulationParams').('timeStep');
    
    numOfSteps = (finalTime - initialTime)/timeStep;
    
    timeArray     = zeros(numOfSteps+1, 1);
    VsArray       = V(1) * ones(numOfSteps+1, 1);
    VArray       = V(1) * ones(numOfSteps+1, numOfSegments);
    IArray      = zeros(numOfSteps+1, 1); % Injected current (stimulus)
    synArray    = sparse(numOfSteps+1, numOfSegments);
    iSynArray   = sparse(numOfSteps+1, numOfSegments);
    
    hasSyn = zeros(numOfSegments,1);
    rng(13);
    k=1;
    for i=1:numOfSegments
        if rand() <= percOfSyn
            hasSyn(i) = k;
            k = k+1;
        end
%         if i==1
%             hasSyn(i) = k;
%             k = k+1;
%         end
    end
    
    numOfSegmentsWithSyn = nnz(hasSyn);
    
    
    sinapseTimes = sparse(numOfSteps+1, numOfSegmentsWithSyn); 
    numOfSynapsesOnSegment = zeros(numOfSegmentsWithSyn,1);
    
    
    
    for i=1:numOfSegmentsWithSyn
        j=1;
        first = -log(rand())/lambda;
%         first = 0;
        if first >= finalTime; continue;
        else sinapseTimes(j,i) = first; end
        while(1)
            tau = -log(rand())/lambda;
            newTime = sinapseTimes(j,i)+tau;
            if newTime >= finalTime; break; end;
            sinapseTimes(j+1,i) = sinapseTimes(j,i) + tau;
            j = j+1;
        end
        numOfSynapsesOnSegment(i) = j;
    end
    
    
    
%     hasSyn
%     numOfSegmentsWithSyn
%     full(sinapseTimes)
%     numOfSynapsesOnSegment
    
    
%     neuroTransmitterConc_aux = cell(numOfSteps+1, numOfSegmentsWithSyn);
    
    for i=1:numOfSegmentsWithSyn
        for j=1:numOfSynapsesOnSegment(i)
            neuroTransmitterConc_aux{j} = zeros(numOfSteps+1, numOfSegmentsWithSyn);
        end
    end
    
    perc = 0.0;
    h = waitbar(perc,'Processing synapses...');
    for i=1:numOfSegmentsWithSyn
        perc = i/numOfSegmentsWithSyn;
        waitbar(perc,h);
        for j=1:numOfSynapsesOnSegment(i)
            indexOfTimeArray = 0;
            for t = initialTime:timeStep:finalTime  
                indexOfTimeArray = indexOfTimeArray + 1;
                timeArray(indexOfTimeArray)=t;

                t0 = sinapseTimes(j,i);
                t1 = t0 + pulseDuration;

                if (t >= t0  &&  t < t1)
                    neuroTransmitterConc_aux{j}(indexOfTimeArray, i) = Tmax;
                else
                    neuroTransmitterConc_aux{j}(indexOfTimeArray, i) = 0.0;
                end
            end
        end
    end
    close(h)
    
%     neuroTransmitterConc_aux{1}
%     neuroTransmitterConc_aux{2}
%     neuroTransmitterConc_aux{3}
    
    neuroTransmitterConc = sparse(numOfSteps+1, numOfSegmentsWithSyn);
    
    for i=1:numOfSegmentsWithSyn
        for j=1:numOfSynapsesOnSegment(i)
            indexOfTimeArray = 0;
            for t = initialTime:timeStep:finalTime  
                indexOfTimeArray = indexOfTimeArray + 1;
%                 timeArray(indexOfTimeArray) = t;
                if neuroTransmitterConc(indexOfTimeArray, i) ~= Tmax
                    neuroTransmitterConc(indexOfTimeArray, i) = neuroTransmitterConc(indexOfTimeArray, i) + neuroTransmitterConc_aux{j}(indexOfTimeArray, i);
                end
            end
        end
    end
    
    indexOfTimeArray = 0;
    for t = initialTime:timeStep:finalTime  
        indexOfTimeArray = indexOfTimeArray + 1;
        for i=1:numOfSegments
            if hasSyn(i) ~= 0
%                 i
%                 hasSyn(i)
        %                     alpha
        %                     beta
                r_diff = alpha * neuroTransmitterConc(indexOfTimeArray, hasSyn(i)) * (1 - r(i)) - beta * r(i);
                r(i) = r(i) + timeStep * r_diff;
            end
            
            synArray(indexOfTimeArray, i) = g_syn_max * r(i);
        end
    end
    
    NAS.data.('results').('synArray') = synArray;
    
%     hasSyn    
%     full(neuroTransmitterConc)
%     whos timeArray
%     whos neuroTransmitterConc
%     figure
%     plot(timeArray, neuroTransmitterConc)
%     
%     figure
%     plot(timeArray, synArray)
%     
%     figure
%     hist(diff(nonzeros(sinapseTimes(:,1))))
    
%     r = zeros(numOfSegments,1);
%     synArray    = zeros(numOfSteps+1, numOfSegments);
    
    
%     indexOfTimeArray = 0;
%     for t = initialTime:timeStep:finalTime  
%         indexOfTimeArray = indexOfTimeArray + 1;
%         timeArray(indexOfTimeArray)=t;
%         for i=1:numOfSegmentsWithSyn
%             for j=1:numOfSynapsesOnSegment(i)
%                 t0 = sinapseTimes(i,j);
%                 t1 = t0 + pulseDuration;
%                 if (t >= t0  &&  t < t1)
%                     neuroTransmitterConc(indexOfTimeArray, i) = Tmax;
%                 else
%                     neuroTransmitterConc(indexOfTimeArray, i) = 0.0;
%                 end
%             end
%         end
%     end
    
    
    
    timeArray  = zeros(numOfSteps+1, 1);
    
    
    tolerance = 0.001; % --> initializing for implicit Euler
    numMax = 20; % --> initializing for implicit Euler
    
    simProgress = 0;
    
    indexOfTimeArray = 0;
    tic
    %% simulation loop
    for t = initialTime:timeStep:finalTime  
        
        indexOfTimeArray = indexOfTimeArray + 1;
        
        if t >= simProgress*finalTime/100
            if NAS.guiData.isShowProgress
                set(handles.text42, 'Visible', 'on');
                display(sprintf('Progress: %d%%', simProgress));
                set(handles.text42, 'String', sprintf('%3.0f %%', simProgress));
                v1 = get(handles.checkbox4, 'Value');
                if v1
                    set(handles.text36, 'String', sprintf('%d',round(toc)))
                end
                v1 = get(handles.checkbox5, 'Value');
                if v1
                    set(handles.text38, 'String', sprintf('%.3f',t))
                end
                set(handles.text42, 'String', sprintf('%3.0f %%', simProgress));
                simProgress = simProgress + 1;
            end
            drawnow % permits interruption of the loop
        end
        
        if NAS.guiData.isSimPause
            h_fig1 = figure('Units', 'normalized', 'Position',[0.3,0.3,0.2,0.2],'Toolbar','none',...
                'MenuBar','none', 'name', 'Sim. paused', 'NumberTitle','off');
                h_panel1 = uipanel(h_fig1,'Units','normalized','Position',[0.05,0.05, 0.9, 0.9]);
                
                h_text1 = uicontrol(h_panel1,'Style','text','Units','normalized',...
                                        'Position',[0.05,0.75,0.95,0.2],'String', 'Please, choose an option:',...
                                        'FontSize', 11, 'ForegroundColor', [0.2, 0.2, 0.2] );
                                    
                h_push_resume = uicontrol(h_panel1,'Style','pushbutton','Units','normalized',...
                                        'Position',[0.25,0.55,0.5,0.2],...
                                        'String','Resume',...
                                        'TooltipString','Resume simulation',...
                                        'FontSize', 10,...
                                        'Callback',@resumeSim);
                                    
                h_push_cancel = uicontrol(h_panel1,'Style','pushbutton','Units','normalized',...
                                        'Position',[0.25,0.3,0.5,0.2],...
                                        'String','Cancel',...
                                        'TooltipString','Cancel simulation',...
                                        'FontSize', 10,...
                                        'Callback',@cancelSim);
                h_push_preview = uicontrol(h_panel1,'Style','pushbutton','Units','normalized',...
                                        'Position',[0.25,0.05,0.5,0.2],...
                                        'String','Preview result',...
                                        'TooltipString','Preview simulation result','FontSize', 10,...
                                        'Callback',@previewResult);
                                    
            uiwait(h_fig1);
            NAS.guiData.isSimPause = 0;
        end

        if NAS.guiData.isSimCancel
            msgbox('Simulation canceled!');
            set(handles.text42, 'String', 'Canceled at 0.0 %');
            cla(handles.axes6, 'reset');
            set(handles.axes6, 'Visible', 'off');
            cla(handles.axes4, 'reset');
            set(handles.axes4, 'Visible', 'off');
            return;
        end
        
        localError = 100.0; % --> initializing for implicit Euler
        count = 0;
            
        while (localError > tolerance)    
%         for aux = 1:155
            
            count = count + 1;

            if count >= numMax
                display('reached max iterations');
%                 i
%                 indexOfTimeArray
%                 count
                count = 1;
                break;
            end
        
        
            %% segments loop
            for i = 1:numOfSegments

                if(type(i) == 1 && parent(i) == 1) % skiping compartments 2 and 3, used only to tell that soma is spherical
                    continue;
                end


                if i == 1

                    h_Na_diff = (h_Na_inf(V(i)) - h_Na(i)) / tau_h_Na(V(i));
                    n_Kdr_diff = (n_Kdr_inf(V(i)) - n_Kdr(i)) / tau_n_Kdr(V(i));

                    h_Na(i) = h_Na(i) + timeStep * h_Na_diff;
                    n_Kdr(i) = n_Kdr(i) + timeStep * n_Kdr_diff;

                end

%                 if hasSyn(i) ~= 0
% %                     i
% %                     hasSyn(i)
% %                     alpha
% %                     beta
%                     r_diff = alpha * neuroTransmitterConc(indexOfTimeArray, hasSyn(i)) * (1 - r(i)) - beta * r(i);
%                     r(i) = r(i) + timeStep * r_diff;
%                 end

%                 r_diff = alpha * neuroTransmitterConc(indexOfTimeArray, i) * (1 - r(i)) - beta * r(i);
%                 r(i) = r(i) + timeStep * r_diff;


                if type(i) ~= 1 %% if not soma
                    A(i, parent(i)) = -1/ra_prox(i); 
%                     A(i, i) = cm(i)/timeStep + 1/rm(i) + 1/ra_prox(i);
                    A(i, i) = cm(i)/timeStep + 1/rm(i) + 1/ra_prox(i) + synArray(indexOfTimeArray, i);
                else

                    A(i, i) = cm(i)/timeStep + 1/rm(i) + ...
                        gNa * m_Na_inf(V(i))^3 * h_Na(i) + gKdr * n_Kdr(i)^4;
%                     A(i, i) = cm(i)/timeStep + 1/rm(i) + ...
%                         gNa * m_Na_inf(V(i))^3 * h_Na(i) + gKdr * n_Kdr(i)^4 + synArray(indexOfTimeArray, i);
                end

                daughter_array = cell2mat(childs_cellarray(i));
                if ~isempty(daughter_array)
                    for j = 1:length(daughter_array)
                        daugther_index = daughter_array(j);

                        A(i, i) = A(i, i) + 1/ra_prox(daugther_index);
                        A(i, daugther_index) = -1/ra_prox(daugther_index);
                    end
                end


                if type(i) == 1 && parent(i) == -1
%                     iInj(i) = area(1) * 1e-8 * getSignal('trapezoid', 1.0, 90.0, 0, 1500, t, 10.0, 80.0); % uA
                    iInj(i) = 0;

%                     B(i) = (cm(i)/timeStep) * V(i) + EL/rm(i) + iInj(i) +...
%                     gNa * m_Na_inf(V(i))^3 * h_Na(i) * ENa + ....
%                     gKdr * n_Kdr(i)^4 * EK + synArray(indexOfTimeArray, i) * Esyn;
                    B(i) = (cm(i)/timeStep) * V(i) + EL/rm(i) + iInj(i) +...
                    gNa * m_Na_inf(V(i))^3 * h_Na(i) * ENa + ....
                    gKdr * n_Kdr(i)^4 * EK;
                else
                    iInj(i) = 0;
                    B(i) = (cm(i)/timeStep) * V(i) + EL/rm(i) + iInj(i) + synArray(indexOfTimeArray, i) * Esyn;
%                     B(i) = (cm(i)/timeStep) * V(i) + EL/rm(i) + iInj(i);
                end


            end
            
            K = inv(A);
            V_last = V;
%             V = (B\A)';
            V = K*B;
%           V-V_last
            localError = max(abs(V-V_last));
            
            
%             iSynArray(indexOfTimeArray, i) = g_syn_max * r(i) * (Esyn - V(i));
%             synArray(indexOfTimeArray, i) = g_syn_max * r(i);
%             synArray(indexOfTimeArray, i) = h_Na(i);

            if localError <= tolerance
%                 disp('tolerance satisfied');
                break;
            end

            if abs(V(i))>1000
                disp('V is to large')
                break;
            end
            
        end
        
        
        for i = 1:numOfSegments
            iSynArray(indexOfTimeArray, i) = synArray(indexOfTimeArray, i) * (Esyn - V(i));
%             iSynArray(indexOfTimeArray, i) = r(i);
        end
            
        NAS.data.('results').('iSynArray') = iSynArray;
        
%         if indexOfTimeArray == numOfSteps+1
%             Esyn
%             V
%         end

%         synArray
%         r
        
        timeArray(indexOfTimeArray) = t;
        IArray(indexOfTimeArray) = iInj(1);

        VsArray(indexOfTimeArray) = V(1);
        VArray(indexOfTimeArray,:) = V(:);
        
        if abs(V(i))>1000
            disp('V is to large')
            break;
        end
        
        if indexOfTimeArray == numOfSteps+1
            
            NAS.guiData.isFinishedSim = 1;
            NAS.data.('results').('timeArray') = timeArray;
            NAS.data.('results').('VsArray') = VsArray;
            NAS.data.('results').('VArray') = VArray;
            NAS.data.('results').('IArray') = IArray;
            
%             whos synArray
%             whos timeArray
%             
%             figure 
%             plot(timeArray, synArray);
            h1=plot(handles.axes4, timeArray, synArray);
%             set(h1, 'LineStyle','none','Marker', 'o',...
%                     'MarkerEdgeColor',[0.509, 0.309, 0.490],...
%                     'MarkerFaceColor',[0.509, 0.309, 0.490],...
%                     'MarkerSize',2);
            set(h1, 'LineStyle','-','Marker', 'o',...
                'MarkerSize',2);
            xlabel(handles.axes4, 'Time (ms)');
            ylabel(handles.axes4, 'Syn. conductance (mS)');
%             ylabel(handles.axes4, 'Current (uA)');
            
            h2=plot(handles.axes6, timeArray, VsArray);
            set(h2, 'LineStyle','none','Marker', 'o',...
                    'MarkerEdgeColor',[0.509, 0.309, 0.490],...
                    'MarkerFaceColor',[0.509, 0.309, 0.490],...
                    'MarkerSize',2);
            
%             set(handles.axes6,'xtick',[])
            ylabel(handles.axes6, 'Membrane potential (mV)');
            
            set(handles.popupmenu7, 'Visible', 'on');
            set(handles.pushbutton28, 'Visible', 'on');
            set(handles.pushbutton32, 'Visible', 'on');
            set(handles.text41, 'Visible', 'on');
            set(handles.axes6, 'Visible', 'on');
            set(handles.axes4, 'Visible', 'on');
            set(handles.text42, 'Visible', 'off');
            set(handles.uipanel6, 'Visible', 'off');
            set(handles.uipanel7, 'Visible', 'off');
            set(handles.uipanel8, 'Visible', 'off');
            set(handles.uipanel9, 'Visible', 'off');
            
            drawnow;
            guidata(hObject, handles);
        end
        
        
        if  NAS.guiData.isSimPreview
            
           h1=plot(handles.axes4, timeArray, synArray);
%             set(h1, 'LineStyle','none','Marker', 'o',...
%                     'MarkerEdgeColor',[0.509, 0.309, 0.490],...
%                     'MarkerFaceColor',[0.509, 0.309, 0.490],...
%                     'MarkerSize',2);
            set(h1, 'LineStyle','-','Marker', 'o',...
                'MarkerSize',2);
            xlabel(handles.axes4, 'Time (ms)');
            ylabel(handles.axes4, 'Syn. conductance (mS)');
%             ylabel(handles.axes4, 'Current (uA)');
            
            h2=plot(handles.axes6, timeArray, VsArray);
            set(h2, 'LineStyle','none','Marker', 'o',...
                    'MarkerEdgeColor',[0.509, 0.309, 0.490],...
                    'MarkerFaceColor',[0.509, 0.309, 0.490],...
                    'MarkerSize',2);
            
%             set(handles.axes6,'xtick',[])
            ylabel(handles.axes6, 'Membrane potential (mV)');
            drawnow;
        end
    end
    
    
    

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
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
    set(handles.axes4,'Visible','off');
    set(handles.axes6,'Visible','off');
    cla(handles.axes4);
    cla(handles.axes6);



% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
    set(handles.uipanel8,'Visible','on');
    set(handles.uipanel9,'Visible','off');
    set(handles.uipanel6,'Visible','off');
    set(handles.uipanel7,'Visible','off');
    set(handles.axes4,'Visible','off');
    set(handles.axes6,'Visible','off');
    cla(handles.axes4);
    cla(handles.axes6);
    set(handles.pushbutton22,'Visible','on');
    set(handles.pushbutton23,'Visible','on');
    set(handles.listbox4,'Visible','on');
    set(handles.text32,'Visible','on');
    
    
    
    
    
    

function edit2_Callback(hObject, eventdata, handles)
global NAS
NAS.data.parameters.('simulationParams').('finalTime') = str2double(get(handles.edit2, 'String'));

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
global NAS;
NAS.data.parameters.('simulationParams').('timeStep') = str2double(get(handles.edit3, 'String'));

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
    global NAS;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    inputs = NAS.data.parameters.('simulationParams').inputs;
    for i = 1:length(inputs)
        str{i} = inputs{i}.name;
    end
    
    set(hObject,'String', str);
    guidata(hObject, handles);


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
    global NAS;
    contents = cellstr(get(handles.listbox5,'String'));
    value = get(handles.listbox5,'Value');
    str = contents{value};
    NAS.data.parameters.('simulationParams').('input').name = str;
    contents2 = cellstr(get(handles.listbox4,'String'));

    if strcmp(contents2{1}, 'none')
        contents2{1} = [str];
    else
        contents2{end+1} = [str];
    end
    set(handles.listbox4, 'String', contents2);
    guidata(hObject, handles);

% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
    global NAS;
    NAS.gui.single_sim_inputConfig = nas_singleNeuron1_sim_inputConfig;
    contents = cellstr(get(handles.listbox5,'String'));
    value = get(handles.listbox5,'Value');
    
    NAS.data.parameters.('simulationParams').('input').('inputChosenStr') = contents{value};
    NAS.data.parameters.('simulationParams').('input').('inputChosenNum') = value;
    set(NAS.gui.single_sim_inputConfig,'Visible','on');

% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
    global NAS;
    NAS.data.parameters.simulationParams.('input').('nameChosen') = '---';
    NAS.gui.single_sim_inputConfig = nas_singleNeuron1_sim_inputConfig;
    set(NAS.gui.single_sim_inputConfig,'Visible','on');



% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
    set(handles.uipanel9,'Visible','on');
    set(handles.listbox5,'Visible','on');
    set(handles.pushbutton24,'Visible','on');
    set(handles.pushbutton25,'Visible','on');
    set(handles.pushbutton26,'Visible','on');
    set(handles.pushbutton27,'Visible','on');
    
    
    
    
    
    

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
    contents = cellstr(get(handles.listbox4,'String'));
    
    idx = get(handles.listbox4,'Value');
    if strcmp(contents{1}, 'none')
        errordlg('There is no input!');
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
    


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
    contents = cellstr(get(handles.listbox3,'String'));
    str = contents{get(handles.listbox3,'Value')};
    contents2 = cellstr(get(handles.listbox2,'String'));
    if strcmp(contents2{1}, 'none')
        contents2{1} = [str];
    else
        contents2{end+1} = [str];
    end
    set(handles.listbox2, 'String', contents2);



% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
    set(handles.uipanel7,'Visible','on');



% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
set(handles.text36, 'String', '---');
drawnow update

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
set(handles.text38, 'String', '---');
drawnow update





% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
global NAS;
str = get(handles.pushbutton31, 'String');
if strcmp(str, 'Pause')
    NAS.guiData.isSimPause = 1;
end


% --------------------------------------------------------------------
function saveScenario_Callback(hObject, eventdata, handles)
    global NAS;
    [filename,pathname,FilterIndex] = uiputfile('exported_scenario1.mat');
    if FilterIndex
        save(fullfile(pathname, filename), 'NAS');
    end



% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)

    contents = cellstr(get(handles.listbox2,'String'));
    
    idx = get(handles.listbox2,'Value');
    if strcmp(contents{1}, 'none')
        errordlg('There is no input!');
    else
        contents(idx) = [];
    end
    if length(contents) == 0
        contents{1} = 'none';
    end
    newValue = get(handles.listbox2, 'Value') - 1;
    if newValue<=0
        newValue=1;
    end
    set(handles.listbox2, 'String', contents, 'Value', newValue);


% --- Executes during object creation, after setting all properties.
function text42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5
    global NAS;
    contents = cellstr(get(hObject,'String'));
    value = get(hObject,'Value');
    
    NAS.data.parameters.('simulationParams').('input').('inputChosenStr') = contents{value};
    NAS.data.parameters.('simulationParams').('input').('inputChosenNum') = value;






% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
    set(handles.uipanel9, 'Visible', 'off');
    


% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


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


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global NAS;

    NAS.guiData.single.isAnimation = 1;
    
    numOfTrees = length(NAS.data.properties.custom.data.zeroOrderSegments);
%     set(handles.text12, 'String', numOfTrees);
    
    
    NAS.guiData.single.('azimuth') = 0;
    NAS.guiData.single.('elevation') = 30;
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
    NAS.guiData.single.isAnimation = 1;
    
    
    azimuth = NAS.guiData.single.('azimuth');
    elevation = NAS.guiData.single.('elevation');
    initialTime = NAS.data.parameters.('simulationParams').('initialTime');
    finalTime = NAS.data.parameters.('simulationParams').('finalTime');
    timeStep = NAS.data.parameters.('simulationParams').('timeStep');
    synArray = NAS.data.('results').('synArray');
    iSynArray = NAS.data.('results').('iSynArray');
    timeArray = NAS.data.('results').('timeArray');
    VsArray = NAS.data.('results').('VsArray');
    VArray = NAS.data.('results').('VArray');
    IArray = NAS.data.('results').('IArray');
    numOfSegments = NAS.data.properties.custom.('numOfSegments');
    
    
    fig1 = figure(1);
    figWidth = 600;
    figHeight = 600;
    set(fig1, 'OuterPosition', [50, 20, figWidth, figHeight])
    set(gcf,'paperunits','centimeters')
    set(gcf,'papersize',[6,6])
    set(gcf,'paperposition',[0,0,6,6])
    
    whitebg(fig1, 'w')
%     sH = subplot(5,1,[1 3]);
%     set(sH, 'Units', 'normalized');
%     set(sH, 'Position', [0.13, 0.5, 0.8, 0.5]);
    
    [upperAxes, NAS.guiData.single.surface_handle, visualizationBoxLength] = plotStaticMNMorphology3 ( NAS.data.properties.('custom'),...
        NAS.guiData.single.d_min, NAS.guiData.single.d_max, NAS.guiData.single.azimuth, NAS.guiData.single.elevation,...
        NAS.guiData.single.baseColor, NAS.guiData.single.sectionColor, 'figure.png',...
        NAS.data.parameters.geometryType, NAS.guiData.single.metric, NAS.guiData.single.isShowSectionOnly,...
        NAS.guiData.single.isShowColoredTrees, NAS.guiData.single.isShowSingleTree);
    
%     zoom on
%     zoom(1.1)
    
    axis square
    xlim([-visualizationBoxLength visualizationBoxLength]);
    ylim([-visualizationBoxLength visualizationBoxLength]);
    zlim([-visualizationBoxLength visualizationBoxLength]);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    textH = uicontrol(fig1,'Style','text',...
                'String','Frame:', 'Units', 'normalized',...
                'Position',[0.1 0.9 0.1 0.05]);
    
    
    
    
%     % Defining RGB colors
%     darkOrange = [0.87, 0.49, 0.0];
%     darkGreen = [0.17, 0.51, 0.34];
%     darkBlue = [0.08, 0.17, 0.55];
%     darkRed = [0.85, 0.16, 0.0];
%     darkPurple = [0.48, 0.06, 0.89];
%     gray = [0.5, 0.5, 0.5];
% 
%     
%     totalNumOfFrames     = 30;
    frameCount = 0;
    indexOfTimeArray = 0;
    
    
    
%     sH2 = subplot(5,1,4);
%     hold(sH2,'on');
%     set(sH2, 'Units', 'normalized');
%     set(sH2, 'Position', [0.13, 0.3, 0.8, 0.15]);
%     h = ylabel(sH2, 'V_{S} (mV)');
%     set(h, 'FontSize', 11);
%         
%     sH3 = subplot(5,1,5);
%     set(sH3, 'Units', 'normalized');
%     set(sH3, 'Position', [0.13, 0.08, 0.8, 0.15]);
%     hold(sH3,'on');
%     h = xlabel(sH3, 'Time (ms)');
%     set(h, 'FontSize', 11);
%     h = ylabel(sH3, 'i_{syn} (\muA)');
%     set(h, 'FontSize', 11);
    
    
    sH4 = colorbar();
    set(sH4, 'Units', 'normalized');
    set(sH4, 'Position', [0.88, 0.48, 0.05, 0.5]);
    hT = get(sH4, 'Title');
    set(hT, 'String', 'Membrane potential (mV)');
    set(hT, 'Rotation', 90);
    set(hT, 'Units', 'normalized');
    set(hT, 'Position', [0.0, 0.5]);
    Vmin = -70;
    Vmax = 70;
    cmap('hot')
    caxis([Vmin,Vmax]);
        
    simProgress = 0;
    for t = initialTime:timeStep:finalTime
        indexOfTimeArray = indexOfTimeArray + 1;
        simProgress = finalTime/t;
        
        frameCount = frameCount + 1;
        azimuth = azimuth + 1;

        str = sprintf('frame = %d', frameCount);
        set(textH, 'String', str);
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);


        if indexOfTimeArray~=1
            vDiff = VArray(indexOfTimeArray, :) - (VArray(indexOfTimeArray-1, :));
        else
            vDiff = 100;
        end
        maxDiff = max(abs(vDiff));
        
        aux = 100/range(VArray(indexOfTimeArray, :)); % custom formulae
        if aux > 2 % probably there is AP
            if maxDiff > 2
                atualizeSingleNeuron3D(VArray(indexOfTimeArray, :));
            end
        else
            
            if maxDiff > 5 || isInteger(simProgress)
                atualizeSingleNeuron3D(VArray(indexOfTimeArray, :));
            end
        end
        view(upperAxes, azimuth, elevation);

        
        
        
%         p2 = plot(sH2, timeArray(indexOfTimeArray), VsArray(indexOfTimeArray));
% %         set(p2, 'LineWidth', 3, 'Color', darkPurple);
%         set(p2, 'Marker', 'o');
%         set(p2, 'MarkerFaceColor', darkPurple);
%         set(p2, 'MarkerSize', 5);
%         
%         p3 = plot(sH3, timeArray(indexOfTimeArray), iSynArray(indexOfTimeArray,:));
%         set(p3, 'Marker', '.');
%         set(p3, 'MarkerSize', 6);
% %         set(p3, 'LineStyle', '-');
% %         set(p3, 'LineWidth', 3);

        if frameCount == 1 
            imwrite(imind,cm,'testingGIF.gif','gif', 'Loopcount',inf,'DelayTime',0.1);
        else
            imwrite(imind,cm,'testingGIF.gif','gif','WriteMode','append','DelayTime',0.1);
        end
%         drawnow;
            
            
            
        
        
        
    end
    
%     
%     
%     
%     
%     print('fig1','-painters','-dpng','-r600')
