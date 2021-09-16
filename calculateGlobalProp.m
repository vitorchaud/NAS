

function [mn_global_prop] = calculateGlobalProp (mn_struct, parameters)
    
    mn_global_prop.('names') = { 'areaTotalStemDendrites';     'areaSoma';     'areaTotal';     'totalPathLength';     'radial_distance';     'path_length';
                                        'maxEuclidianDistance';     'maxPathDistance';     'averageDiameter';   'numOfBifurcations';     'numOfTerminations';
                                        'numOfBranches';     'numOfStems';     'maxBranchOrder';};
    
                                    
    numOfSegments = mn_struct.('numOfSegments');
    type = mn_struct.('data').('local').('type');
    parent = mn_struct.('data').('local').('parent');
    area = mn_struct.('data').('local').('area');
    segment_length = mn_struct.('data').('local').('segment_length');
    radius = mn_struct.('data').('local').('radius');
    order = mn_struct.('data').('local').('order');
    isBranchPoint = mn_struct.('data').('local').('isBranchPoint');
    isTermination = mn_struct.('data').('local').('isTermination');
    inputImpedance_mod = mn_struct.('data').('local').('inputImpedance_mod');
    
    
%     branchPropNames = [parameters.featureNames.branchLevel.morphological; parameters.featureNames.branchLevel.electronic];
%     propsBranchLevels = mn_struct.('data').('branchLevel');
    
    propNames = [parameters.('featureNames').('treeLevel').('morphological'); parameters.('featureNames').('treeLevel').('electronic')];
    
    min_array = [];
    lowerQuartile_array = [];
    median_array = [];
    upperQuartile_array = [];
    max_array = [];
    mean_array = [];
    std_array = [];
    total_array = [];
    

    for j = 1:length(propNames)
        name = char(propNames(j));
        
        prop = mn_struct.('data').('branchLevel').(name);
        prop(isnan(prop)) = []; %eliminate NaN values
        
        min_array =             [min_array;             min(prop)];
        lowerQuartile_array =   [lowerQuartile_array;   quantile(prop, 0.25)];
        median_array =          [median_array;          quantile(prop, 0.5)];
        upperQuartile_array =   [upperQuartile_array;   quantile(prop, 0.75)];
        max_array =             [max_array;             max(prop)];
        mean_array =            [mean_array;            mean(prop)];
        std_array =             [std_array;             std(prop)];
        total_array =           [total_array;           sum(prop)];
        
        mn_global_prop.(name).('min') = min_array;
        mn_global_prop.(name).('lowerQuartile') = lowerQuartile_array;
        mn_global_prop.(name).('median') = median_array;
        mn_global_prop.(name).('upperQuartile') = upperQuartile_array;
        mn_global_prop.(name).('max') = max_array;
        mn_global_prop.(name).('mean') = mean_array;
        mn_global_prop.(name).('std') = std_array;
        mn_global_prop.(name).('total') = total_array;
        
        min_array = [];
        lowerQuartile_array = [];
        median_array = [];
        upperQuartile_array = [];
        max_array = [];
        mean_array = [];
        std_array = [];
        total_array = [];
    end
    
    
    
    % Obtaining soma area
    
    if(type(1)==1 && parent(1)==-1)
        areaSoma = area(1);
    else
        error('MNS: I dont know soma index...');
    end
    
    % Obtaining zero order stem dendrite total area (sum for all zero order compartments)
    
    areaTotalStemDendrites = 0;
    
    for i = 1:numOfSegments
        if parent(i)==1 && type(i)~=1
            areaTotalStemDendrites = areaTotalStemDendrites + area(i);
        end
    end
    
    % Obtaining total area
    
    areaTotal = sum(area);
    
    mn_global_prop.('areaTotalStemDendrites') = areaTotalStemDendrites;
    mn_global_prop.('areaSoma') = areaSoma;
    mn_global_prop.('areaTotal') = areaTotal;
    
    mn_global_prop.('totalPathLength') = sum(segment_length);
    
    maxEuclidianDistance = max(mn_struct.('data').('local').('radial_distance'));
    maxPathDistance = max(mn_struct.('data').('local').('path_length'));
    
    
    segmentDiameters = 2 * radius(type~=1);
        
    averageDiameter = mean(segmentDiameters);
    
    mn_global_prop.('maxEuclidianDistance') = maxEuclidianDistance;
    mn_global_prop.('maxPathDistance') = maxPathDistance;
    mn_global_prop.('averageDiameter') = averageDiameter;
    
%     numOfBifurcations = mn_struct.('data').('somatofugal').('cumNumOfBranchPoints')(end);
%     numOfTerminations = mn_struct.('data').('somatofugal').('cumNumOfTerminations')(end);
%     numOfBranches = mn_struct.('data').('somatofugal').('cumNumOfDendSegments')(end);
    
    numOfBifurcations = nnz(isBranchPoint);
    numOfTerminations = nnz(isTermination);
    numOfBranches = numOfBifurcations + numOfTerminations;
    
    mn_global_prop.('numOfBifurcations') = numOfBifurcations;
    mn_global_prop.('numOfTerminations') = numOfTerminations;
    mn_global_prop.('numOfBranches') = numOfBranches;
    
    mn_global_prop.('maxBranchOrder') = max(order);
    checkingSize = size(inputImpedance_mod);
    if checkingSize(1)==1
        mn_global_prop.('somaticInputImpedance') = inputImpedance_mod(1);
    else
        mn_global_prop.('somaticInputImpedance') = inputImpedance_mod(1,parameters.indexOfSampleFreq);
    end
end