

function [properties, parameters] = setParameters()
    

    %% Control parameters
    
    
    parameters.maxCompartmentLength = 200;
    parameters.maxNumOfSegments = 11111;
    parameters.isEliminateAxon = 1; 
    parameters.isEliminateStemDendWithNoDaugther = 0; % when processing morphology (before electronic calculations)
    parameters.isEliminateUnbranchedTrees = 0;      % when calculating tree properties (after electronic calculations)
    
    parameters.('simulationParams').('initialTime') = 0.0;
    parameters.('simulationParams').('finalTime') = 10.0;
    parameters.('simulationParams').('timeStep') = 0.01;
    
    parameters.('simulationParams').('input').('inputTypes') = {'Injected current', 'Synapse'};
    
    parameters.('simulationParams').('input').('nameChosen') = 'Trapezoidal injected current on soma';
    parameters.('simulationParams').('input').('inputTypeChosen') = 'Injected current';
    parameters.('simulationParams').('input').('waveFormChosen') = 'Trapezoid';
    parameters.('simulationParams').('input').('targetChosen') = 'Soma only';
    
    parameters.('simulationParams').('input').('numOfInputs') = 2;
    parameters.('simulationParams').('input').('inputChosenStr') = 'Trapezoidal injected current on soma';
    parameters.('simulationParams').('input').('inputChosenNum') = 1;
    
    inputs{1}.name = 'Trapezoidal injected current on soma';
    inputs{1}.inputType = 'Injected current';
    inputs{1}.waveForm = 'Trapezoid';
    inputs{1}.target = 'Soma only';
    inputs{1}.('waveForms') = {'Trapezoid', 'Triangular', 'Ramp-and-Hold', 'Noise'};
    inputs{1}.('targets') = {'Soma only', 'Whole neuron', 'All dendrites', 'Radial section'};
    inputs{1}.('trapezoid').('t1') = 0.0;
    inputs{1}.('trapezoid').('t2') = 10.0;
    inputs{1}.('trapezoid').('t3') = 90.0;
    inputs{1}.('trapezoid').('t4') = 100.0;
    inputs{1}.('trapezoid').('i1') = 1.0;
    inputs{1}.('trapezoid').('i2') = 11.0;
    
    inputs{2}.name = 'Synapses on the whole neuron except the soma';
    inputs{2}.inputType = 'Synapse';
    inputs{2}.waveForm = 'First order kinetic';
    inputs{2}.target = 'All dendrites';
    inputs{2}.('waveForms') = {'First order kinetic', 'Single exponential decay', 'Alpha', 'Dual exp. function'};
    inputs{2}.('targets') = {'Soma only', 'Whole neuron', 'All dendrites', 'Radial section'};
    inputs{2}.('maximumConductance') = 0.000001;
    inputs{2}.('connectivity') = 90.0;
    inputs{2}.('reversalPotential') = 0;
    inputs{2}.('meanFiringRate') = 1000;
    
    
    parameters.('simulationParams').inputs = inputs;
    
%     parameters.geometryType = 'lines';
    parameters.geometryType = 'frustum';
%     parameters.geometryType = 'cylinder';

    parameters.somatofugalParams.('step') = 100;
    parameters.somatofugalParams.('finalDistance') = 3000;

    % Parameters as in Zador 1995

    parameters.passiveParams.('Cm') = 1;  % [uF/cm^2]
    parameters.passiveParams.('Rm') = 20000; % [ohm.cm^2]
    parameters.passiveParams.('Ra') = 100;   % [ohm.cm]
    parameters.passiveParams.('w') = 0;   % [Hz] or [rad/s]?

    % Parameters as in ElBasiouny 2005

    parameters.passiveParams.('Cm') = 1;  % [uF/cm^2]
    parameters.passiveParams.('Rm_soma') = 225; % [ohm.cm^2]
    parameters.passiveParams.('Rm_dend') = 11000; % [ohm.cm^2]
    parameters.passiveParams.('Ra') = 70;   % [ohm.cm]
    
    
    % Testing
    
    parameters.passiveParams.('Cm') = 1.0;  % [uF/cm^2]
    parameters.passiveParams.('Rm_soma') = 11000; % [ohm.cm^2]
    parameters.passiveParams.('Rm_dend') = 11000; % [ohm.cm^2]
    parameters.passiveParams.('Ra') = 70;   % [ohm.cm]
    
    
    
%     aux1 = linspace(-5, log(10000), 20);
%     w = exp(aux1');
%     aux1 = linspace(2*pi*20, 2*pi*2000, 10);
%     w = aux1';
    w = [0];
    parameters.passiveParams.('w') = w;   % [rad/s]
    
    parameters.indexOfSampleFreq = 1;
    parameters.sampleFreq = w(parameters.indexOfSampleFreq);

    
    %% mnFileNames_cellarray is in fact an struct of cellarrays
    
    parameters.mnFileNames_cellarray.('burke') = {'v_e_moto1.CNG.swc', 'v_e_moto2.CNG.swc', 'v_e_moto3.CNG.swc', 'v_e_moto4.CNG.swc', 'v_e_moto5.CNG.swc', 'v_e_moto6.CNG.swc'};

    parameters.mnFileNames_cellarray.('fyffe') = {'alphaMN1.CNG.swc', 'alphaMN2.CNG.swc', 'alphaMN3.CNG.swc', 'alphaMN4.CNG.swc', 'alphaMN5.CNG.swc', 'alphaMN6.CNG.swc', 'alphaMN8.CNG.swc',...
                                        'alphaMN9.CNG.swc', 'gammaMN1.CNG.swc', 'gammaMN2.CNG.swc', 'gammaMN3.CNG.swc', 'gammaMN4.CNG.swc'};

    parameters.mnFileNames_cellarray.('rose') = {'BCCM-LVN41.CNG.swc', 'SPLENIUS-DVS14-1.CNG.swc', 'SPLENIUS-DVS22-2.CNG.swc', 'SPLENIUS-DVS22-3.CNG.swc', ...
                                                'SPLENIUS-DVS23-4.CNG.swc', 'SPLENIUS-DVS25-2.CNG.swc', 'SPLENIUS-DVS25-3.CNG.swc', 'SPLENIUS-DVS25-5.CNG.swc', ...
                                                'SPLENIUS-DVS31-1.CNG.swc', 'SPLENIUS-DVS31-2.CNG.swc', 'SPLENIUS-LVN12.swc'};

    parameters.mnFileNames_cellarray.('chmykhova_frog') = {'13moton.CNG.swc', '27moton.CNG.swc'};

    parameters.mnFileNames_cellarray.('chmykhova_turtle') = {'5Tmn1.CNG.swc', '5Tmn2.CNG.swc'};

    parameters.mnFileNames_cellarray.('cameron') = {'AK10N2.CNG.swc', 'AK11N1.CNG.swc', 'AK11N5.CNG.swc', 'AK12N1.CNG.swc', 'AK14N4.CNG.swc', ...
                                                    'AK15N3.CNG.swc', 'AK15N4.CNG.swc', 'AK16N4.CNG.swc', 'AK18N3HZ.CNG.swc', 'AK19N1SG.CNG.swc', ...
                                                    'AK1N4.CNG.swc', 'AK1N6.CNG.swc', 'AK3N3.CNG.swc', 'AK5N3.CNG.swc', 'AK5N4.CNG.swc', 'AK5N5.CNG.swc', ...
                                                    'ICP25N4H.CNG.swc', 'J18N1.CNG.swc', 'J18N2.CNG.swc', 'J21N1.CNG.swc', 'J26N2.CNG.swc', 'J26N5.CNG.swc'};


    parameters.mnFileNames_cellarray.('ascoli') = {'ok_m207amod.CNG.swc', 'ok_m79_diana.CNG.swc', 'ok_m191mod.CNG.swc', 'ok_m116mod.CNG.swc', ...
                                                    'ok_m187mod.CNG.swc', 'ok_m207b.CNG.swc', 'ok_m88mod.CNG.swc', 'ok_m97mod2.CNG.swc', ...
                                                    'ok_m139.CNG.swc', 'ok_m140mod.CNG.swc', 'ok_m211mod.CNG.swc', 'ok_m215.CNG.swc',...
                                                    'ok_m85mod.CNG.swc', 'ok_m208mod.CNG.swc', 'ok_m135mod.CNG.swc', 'ok_m210mod.CNG.swc', 'ok_m216L.CNG.swc'};

    
    parameters.mnFileNames_cellarray.('toyModel') = {'toyModel3.swc'};
    
    
    parameters.models_cellarray = {'burke', 'fyffe', 'rose', 'chmykhova_frog', 'chmykhova_turtle', 'cameron', 'ascoli', 'toyModel'};

    addpath(strcat(pwd,'/burke/CNG version'))
    addpath(strcat(pwd,'/fyffe/CNG version'))
    addpath(strcat(pwd,'/rose/CNG version'))
    addpath(strcat(pwd,'/chmykhova/CNG version'))
    addpath(strcat(pwd,'/cameron/CNG version'))
    addpath(strcat(pwd,'/ascoli/CNG version'))
    addpath(strcat(pwd,'/toyModel/CNG version'))
    
    %% Setting up sample neurons aliases
    
    % neuronAlias_cellarray is a struct of cellarrays
    
    parameters.('numOfNeuronsInPop') = struct;
    parameters.('neuronAlias_cellarray') = struct;
    
    
    for i = 1:length(parameters.models_cellarray)
        modelName = parameters.models_cellarray{i};
        parameters.numOfNeuronsInPop.(modelName) = length(parameters.mnFileNames_cellarray.(modelName));

        for j = 1:parameters.numOfNeuronsInPop.(modelName)
            str = sprintf('%s%d', modelName, j);
            
            parameters.('neuronAlias_cellarray').(modelName)(j) = cellstr(str);
        end
    end
    
                
    
    %% Setting up sample neurons metadata
    
    for i = 1:length(parameters.models_cellarray)
        modelName = parameters.('models_cellarray'){i};

            for j = 1:parameters.numOfNeuronsInPop.(modelName)
                
                str = parameters.('neuronAlias_cellarray').(modelName){j};
                
                display('.................');
                display(sprintf('Processing: %s', str));
                display('.................');
                fileName = char(parameters.mnFileNames_cellarray.(modelName)(j));   
                
                properties.(str).('fileName') = fileName;
                properties.(str).('name') = str;
                properties.(str).('lab') = modelName;

                if strcmp (modelName, 'toyModel')
                    properties.(str).('species') = 'none';
                    properties.(str).('name') = 'toyModel';
                    properties.(str).('lab') = 'none';
                    properties.(str).('tertiaryCellClass') = 'none';
                    properties.(str).('development') = 'none';
                end

                if strcmp(modelName, 'burke') || strcmp(modelName, 'fyffe')  || strcmp(modelName, 'rose')  || strcmp(modelName, 'cameron')
                    properties.(str).('species') = 'cat';
                elseif strcmp(modelName, 'chmykhova_frog')
                    properties.(str).('species') = 'frog';
                elseif strcmp(modelName, 'chmykhova_turtle')
                    properties.(str).('species') = 'turtle';
                elseif strcmp(modelName, 'ascoli')
                    properties.(str).('species') = 'mouse';
                end

                if strcmp(modelName, 'burke') || strcmp(modelName, 'fyffe')  || strcmp(modelName, 'rose')  || strcmp(modelName, 'cameron')  ||...
                        strcmp(modelName, 'chmykhova_frog')  ||  strcmp(modelName, 'chmykhova_turtle')  ||  strcmp(modelName, 'ascoli')
                    properties.(str).('region') = 'spinalCord';
                    properties.(str).('tertiaryCellClass') = 'alpha';
                    properties.(str).('development') = 'older';
                end

                if strcmp(modelName, 'fyffe') &&...
                        (strcmp(fileName, 'gammaMN1.CNG.swc') || strcmp(fileName, 'gammaMN2.CNG.swc') || strcmp(fileName, 'gammaMN3.CNG.swc') || strcmp(fileName, 'gammaMN4.CNG.swc'))
                    properties.(str).('tertiaryCellClass') = 'gamma';
                end

                if strcmp(modelName, 'cameron') &&...
                        not(strcmp(fileName, 'J26N5.CNG.swc') || strcmp(fileName, 'J26N2.CNG.swc') || strcmp(fileName, 'J21N1.CNG.swc') ||...
                        strcmp(fileName, 'J18N2.CNG.swc') || strcmp(fileName, 'J18N1.CNG.swc') || strcmp(fileName, 'ICP25N4H.CNG.swc'))
                    properties.(str).('development') = 'younger';
                end


                if strcmp(modelName, 'ascoli') &&...
                        (strcmp(fileName, 'ok_m207amod.CNG.swc') || strcmp(fileName, 'ok_m207b.CNG.swc') || strcmp(fileName, 'ok_m97mod2.CNG.swc'))
                    properties.(str).('age') = 13;
                end
                if strcmp(modelName, 'ascoli') &&...
                        (strcmp(fileName, 'ok_m191mod.CNG.swc'))
                    properties.(str).('age') = 12;
                end
                if strcmp(modelName, 'ascoli') &&...
                        (strcmp(fileName, 'ok_m79_diana.CNG.swc') || strcmp(fileName, 'ok_m116mod.CNG.swc') || strcmp(fileName, 'ok_m187mod.CNG.swc') || strcmp(fileName, 'ok_m88mod.CNG.swc'))
                    properties.(str).('age') = 10;
                end
                if strcmp(modelName, 'ascoli') &&...
                        (strcmp(fileName, 'ok_m139.CNG.swc'))
                    properties.(str).('age') = 4;
                end
                if strcmp(modelName, 'ascoli') &&...
                        (strcmp(fileName, 'ok_m140mod.CNG.swc') || strcmp(fileName, 'ok_m211mod.CNG.swc') || strcmp(fileName, 'ok_m135mod.CNG.swc') || strcmp(fileName, 'ok_m216L.CNG.swc'))
                    properties.(str).('age') = 2;
                end
                if strcmp(modelName, 'ascoli') &&...
                        (strcmp(fileName, 'ok_m215.CNG.swc') || strcmp(fileName, 'ok_m85mod.CNG.swc') || strcmp(fileName, 'ok_m208mod.CNG.swc') || strcmp(fileName, 'ok_m210mod.CNG.swc'))
                    properties.(str).('age') = 3;
                end

                if strcmp(modelName, 'ascoli')
                    if properties.(str).('age') < 8
                        properties.(str).('development') = '1stWeek';
                    else
                        properties.(str).('development') = '2ndWeek';
                    end
                end

                if strcmp(modelName, 'burke')
                    if strcmp(fileName, 'v_e_moto1.CNG.swc') || strcmp(fileName, 'v_e_moto5.CNG.swc')
                        properties.(str).('muType') = 'S';
                    elseif strcmp(fileName, 'v_e_moto4.CNG.swc') || strcmp(fileName, 'v_e_moto6.CNG.swc')
                        properties.(str).('muType') = 'FR';
                    elseif strcmp(fileName, 'v_e_moto2.CNG.swc') || strcmp(fileName, 'v_e_moto3.CNG.swc')
                        properties.(str).('muType') = 'FF';
                    end
                else
                    properties.(str).('muType') = 'n.r.';
                end
            end

    end
    

    % Equal processings because corr and scenario analyses uses the same
    % data matrices
    parameters.('listOfProcessingTypesInCorrelations') = {'median'};
    parameters.('listOfProcessingTypesInScenarioData') = parameters.('listOfProcessingTypesInCorrelations');
    
    parameters.('listOfProcessingTypesDataMatrices') = {'min'; 'lowerQuartile'; 'median'; 'upperQuartile'; 'max'; 'mean'; 'std'; 'total'};
    parameters.('listOfProcessingTypesKSAnalysis') = {'min'; 'lowerQuartile'; 'median'; 'upperQuartile'; 'max'; 'mean'; 'std'};


    
    parameters.('featureNames').('somatofugal').('geometrical') = { 'x'; 'y'; 'z';...
                                                            'radius'; 'diameter'; 'angleWithParent';...
                                                            'radial_distance'; 'somatofugalTropism';'areaInPath'; ...
                                                            'path_length'; 'contraction'; 'fractalDimension'; 'cumArea'; 'branchingAngle'; 'branchPointRallRatio'};

    parameters.('featureNames').('somatofugal').('topological') = { 'order'; 'degree'; 'numOfBranchPoints';  'numOfBranchesInShell'; 'numOfTerminations';...
                                                'cumNumOfBranchPoints'; 'cumNumOfDendSegments'; 'cumNumOfTerminations'; ...
                                                'partitionAsymmetry'; 'hortonStrahler'};
                                            
                                            
    parameters.('featureNames').('branchLevel').('geometrical') = {'diameter'; 'angleWithParent'; 'radial_distance'; 'somatofugalTropism';...
                                                                    'contraction'; 'fractalDimension'; 'branchingAngle'; 'branchPointRallRatio'};

    parameters.('featureNames').('branchLevel').('topological') = { 'order'; 'degree'; 'partitionAsymmetry'; 'hortonStrahler'};
                                            
    parameters.('featureNames').('branchLevel').('structural') = { 'numOfBranchPoints';  'numOfBranchesInShell'; 'numOfTerminations'; 'areaInPath';...
                                                                    'cumNumOfBranchPoints'; 'cumNumOfDendSegments'; 'cumNumOfTerminations'; 'cumArea'};
                                
                                
    parameters.('featureNames').('local').('morphological') = { 'type';     'parent';     'x';     'y';     'z';     'radius'; 'diameter';...
                                        'proximal_position_x';     'proximal_position_y';     'proximal_position_z';     'id';     'radial_distance';     'segment_length';...
                                        'path_length'; 'area'; 'order'; 'degree'; 'angleWithParent'; 'contraction';  'fractalDimension';  'somatofugalTropism';...
                                        'isBranchPoint'; 'isTermination'; 'partitionAsymmetry'; 'hortonStrahler'; 'branchPointRallRatio'; 'branchingAngle';...
                                        'branchEuclidianLength'; 'branchPathLength' ; 'branchArea'};
    






    parameters.('featureNames').('branchLevel').('morphological') = { 'diameter';     'radial_distance';     'path_length';     'order';     'degree';     'angleWithParent'; 'contraction';...
                                    'fractalDimension'; 'somatofugalTropism';   'partitionAsymmetry';     'hortonStrahler';     'branchPointRallRatio'; ...
                                    'branchingAngle'; 'branchEuclidianLength'; 'branchPathLength'; 'branchArea'};
                                 
    parameters.('featureNames').('branchLevel').('electronic') = {'inputImpedance_mod'; 'centripetalVoltageTransfer_mod'; 'transferImpedanceToSoma_mod'};

    parameters.('featureNames').('branchLevel').('mixed') = { 'diameter';     'radial_distance';     'path_length';     'order';     'degree';     'angleWithParent'; 'contraction';...
                                    'fractalDimension'; 'somatofugalTropism';   'partitionAsymmetry';     'hortonStrahler';     'branchPointRallRatio'; ...
                                    'branchingAngle'; 'branchEuclidianLength'; 'branchPathLength'; 'branchArea';...
                                    'inputImpedance_mod'; 'centripetalVoltageTransfer_mod'; 'transferImpedanceToSoma_mod'};


    parameters.('featureNames').('treeLevel').('morphological') = parameters.('featureNames').('branchLevel').('morphological');
    parameters.('featureNames').('treeLevel').('electronic') = {'inputImpedance_mod'; 'centripetalVoltageTransfer_mod'; 'transferImpedanceToSoma_mod'};

    parameters.('featureNames').('treeLevel').('mixed') = { 'diameter';     'radial_distance';     'path_length';     'order';     'degree';     'angleWithParent'; 'contraction';...
                                    'fractalDimension'; 'somatofugalTropism';   'partitionAsymmetry';     'hortonStrahler';     'branchPointRallRatio'; ...
                                    'branchingAngle'; 'branchEuclidianLength'; 'branchPathLength'; 'branchArea';...
                                    'inputImpedance_mod'; 'centripetalVoltageTransfer_mod'; 'transferImpedanceToSoma_mod'; 'TI_range_max'; 'numOfBranchPoints'; 'numOfBranches'};

    parameters.('featureNames').('neuronLevel').('morphological') = parameters.('featureNames').('branchLevel').('morphological');
    parameters.('featureNames').('neuronLevel').('electronic') = {'inputImpedance_mod'; 'centripetalVoltageTransfer_mod'; 'transferImpedanceToSoma_mod'};
    parameters.('featureNames').('neuronLevel').('mixed') = { 'diameter';     'radial_distance';     'path_length';     'order';     'degree';     'angleWithParent'; 'contraction';...
                                    'fractalDimension'; 'somatofugalTropism';   'partitionAsymmetry';     'hortonStrahler';     'branchPointRallRatio'; ...
                                    'branchingAngle'; 'branchEuclidianLength'; 'branchPathLength'; 'branchArea';...
                                    'inputImpedance_mod'; 'centripetalVoltageTransfer_mod'; 'transferImpedanceToSoma_mod'; 'TI_range_max'; 'numOfBranchPoints'; 'numOfBranches';...
                                    'numOfTrees'; 'somaticInputImpedance'};
                                


    parameters.('featureNamesToShow').('branchLevel').('geometrical') = {'diameter (\mum)'; 'angle_{parent} (deg)'; 'radial distance (\mum)'; 'somatof. tropism';...
                                                                    'contraction'; 'fractal dim.'; 'angle_{branching}'; 'Rall ratio'};
    parameters.('featureNamesToShow').('branchLevel').('topological') = { 'order'; 'degree'; 'partition asymmetry'; 'Horton-Strahler idx'};
    parameters.('featureNamesToShow').('branchLevel').('structural') = { '# branch points';  '# branches'; '# terminations'; 'area in path (\mum^2)';...
                                                                    'sum of branch poins'; 'sum of branches'; 'sum of terminations'; 'sum of area (\mum^2)'};

    parameters.('featureNamesToShow').('branchLevel').('morphological') = { 'Diameter (um)';     'Radial distance (um)';     'Path length from soma (um)';     'Order';     'Degree';     'Angle with parent (deg)'; 'Contraction';...
                                    'Fractal dimension'; 'Somatofugal tropism';   'Partition asymmetry';     'Horton-Strahler index';     'Branch-point Rall ratio';...
                                    'Branching angle (deg)'; 'Euclidian length (um)'; 'Branch path length (um)'; 'Area (um^2)'};
    parameters.('featureNamesToShow').('branchLevel').('electronic') = {'Input impedance (k\Omega)'; 'Centrip. voltage tranf.'; 'Tranf. impedance (k\Omega)'};
    parameters.('featureNamesToShow').('branchLevel').('mixed') = { 'Diameter (um)';     'Radial distance (um)';     'Path length from soma (um)';     'Order';     'Degree';     'Angle with parent (deg)'; 'Contraction';...
                                    'Fractal dimension'; 'Somatofugal tropism';   'Partition asymmetry';     'Horton-Strahler index';     'Branch-point Rall ratio';...
                                    'Branching angle (deg)'; 'Euclidian length (um)'; 'Branch path length (um)'; 'Area (um^2)';...
                                    'Input impedance (k\Omega)'; 'Centrip. voltage tranf.'; 'Tranf. impedance (k\Omega)'};
                                
    parameters.('featureNamesToShow').('treeLevel').('morphological') = parameters.('featureNamesToShow').('branchLevel').('morphological');
    parameters.('featureNamesToShow').('treeLevel').('electronic') = parameters.('featureNamesToShow').('branchLevel').('electronic');
    parameters.('featureNamesToShow').('treeLevel').('mixed') = { 'Diameter (um)';     'Radial distance (um)';     'Path length from soma (um)';     'Order';     'Degree';     'Angle with parent (deg)'; 'Contraction';...
                                    'Fractal dimension'; 'Somatofugal tropism';   'Partition asymmetry';     'Horton-Strahler index';     'Branch-point Rall ratio';...
                                    'Branching angle (deg)'; 'Euclidian length (um)'; 'Branch path length (um)'; 'Area (um^2)';...
                                    'Input impedance (k\Omega)'; 'Centrip. voltage tranf.'; 'Tranf. impedance (k\Omega)';...
                                    'Transf. impedance range'; 'Num. of branch points';  'Num. of branches'};

    parameters.('featureNamesToShow').('neuronLevel').('morphological') = parameters.('featureNamesToShow').('branchLevel').('morphological');
    parameters.('featureNamesToShow').('neuronLevel').('electronic') = parameters.('featureNamesToShow').('branchLevel').('electronic');
    parameters.('featureNamesToShow').('neuronLevel').('mixed') = { 'Diameter (um)';     'Radial distance (um)';     'Path length from soma (um)';     'Order';     'Degree';     'Angle with parent (deg)'; 'Contraction';...
                                    'Fractal dimension'; 'Somatofugal tropism';   'Partition asymmetry';     'Horton-Strahler index';     'Branch-point Rall ratio';...
                                    'Branching angle (deg)'; 'Euclidian length (um)'; 'Branch path length (um)'; 'Area (um^2)';...
                                    'Input impedance (k\Omega)'; 'Centrip. voltage tranf.'; 'Tranf. impedance (k\Omega)';...
                                    'Transf. impedance range'; 'Num. of branch points';  'Num. of branches'; 'Num. of Trees'; 'Somatic input imp. (k\Omega)'};


        
    parameters.('featureNamesToShowShort').('branchLevel').('morphological') = { 'DI';     'RD';     'PL';     'O';     'DE';     'AP'; 'C';...
                                    'FD'; 'ST';   'PA';     'HS';     'RR';...
                                    'BA'; 'EL'; 'BL'; 'A'};

    parameters.('featureNamesToShowShort').('branchLevel').('electronic') = {'II_{mod}'; 'VT_{in_{mod}}'; 'TI_{mod}'};
    parameters.('featureNamesToShowShort').('branchLevel').('mixed') = { 'DI';     'RD';     'PL';     'O';     'DE';     'AP'; 'C';...
                                    'FD'; 'ST';   'PA';     'HS';     'RR';...
                                    'BA'; 'EL'; 'BL'; 'A'; 'II'; 'VT'; 'TI'};

    parameters.('featureNamesToShowShort').('treeLevel').('morphological') = parameters.('featureNamesToShowShort').('branchLevel').('morphological');
    parameters.('featureNamesToShowShort').('treeLevel').('electronic') = parameters.('featureNamesToShowShort').('branchLevel').('electronic');
    parameters.('featureNamesToShowShort').('treeLevel').('mixed') = { 'DI';     'RD';     'PL';     'O';     'DE';     'AP'; 'C';...
                                    'FD'; 'ST';   'PA';     'HS';     'RR';...
                                    'BA'; 'EL'; 'BL'; 'A'; 'II'; 'VT'; 'TI'; 'TI_r'; 'nBP'; 'nB'};

    parameters.('featureNamesToShowShort').('neuronLevel').('morphological') = parameters.('featureNamesToShowShort').('branchLevel').('morphological');
    parameters.('featureNamesToShowShort').('neuronLevel').('electronic') = parameters.('featureNamesToShowShort').('branchLevel').('electronic');
    parameters.('featureNamesToShowShort').('neuronLevel').('mixed') = { 'DI';     'RD';     'PL';     'O';     'DE';     'AP'; 'C';...
                                    'FD'; 'ST';   'PA';     'HS';     'RR';...
                                    'BA'; 'EL'; 'BL'; 'A'; 'II'; 'VT'; 'TI'; 'TI_r'; 'nBP';  'nB'; 'nT'; 'sII'};
    
    
    parameters.('featureNames').('local').('electronic') = {'centrifugalVoltageAttenuation_mod'; 'centripetalVoltageAttenuation_mod'; 'centrifugalVoltageTransfer_mod';...
                                                                    'centripetalVoltageTransfer_mod'; 'transferImpedanceToSoma_mod'; 'transferImpedanceToSoma_phase';...
                                                                    'centripetalVoltageTransfer_phase';  'inputImpedance_mod'; 'inputImpedance_phase'; 'transferImpedanceToSoma_mod_norm'};
    
                                                                
                                                                
                                                                
                     
    parameters.('featureNames').('somatofugal').('electronic') = {'centrifugalVoltageAttenuation_mod'; 'centripetalVoltageAttenuation_mod'; 'centrifugalVoltageTransfer_mod';...
                                                                    'centripetalVoltageTransfer_mod'; 'transferImpedanceToSoma_mod'; 'transferImpedanceToSoma_phase';...
                                                                    'centripetalVoltageTransfer_phase';  'inputImpedance_mod'; 'inputImpedance_phase'; 'transferImpedanceToSoma_mod_norm'};

                                                                
    parameters.('featureNames').('local').('mixed') = [parameters.('featureNames').('local').('morphological'); parameters.('featureNames').('local').('electronic')];
    
end




        

