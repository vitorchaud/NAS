


function [branchProperties, branchIndexes] = getBranchProperties (properties, parameters, segmentsFromUnbranchedSubTrees)
    
    id = properties.('data').('local').('id');
    isBranchPoint = properties.('data').('local').('isBranchPoint');
    isTermination = properties.('data').('local').('isTermination');
    stemParent = properties.('data').('local').('stemParent');
    
    % Eliminating segments from unbranched trees and NaN values
    % (considering only morphological props to eliminate, for now)
    localPropNames = parameters.('featureNames').('local').('morphological');
    
    segmentsWithNaNorInf = zeros(length(id), 1);
    
    for j = 1:length(localPropNames)
        name = char(localPropNames(j));
        
        if strcmp(name, 'id') || strcmp(name, 'parent') || strcmp(name, 'type') ||...
                 strcmp(name, 'radius') || strcmp(name, 'proximal_position_x') || strcmp(name, 'proximal_position_y') || strcmp(name, 'proximal_position_z') ||...
                 strcmp(name, 'segment_length') || strcmp(name, 'area') || strcmp(name, 'isBranchPoint') || strcmp(name, 'isTermination')
            continue;
        end

        prop = properties.('data').('local').(name);
        
%         segmentsWithNaNorInf = or(segmentsWithNaNorInf, isnan(prop));
        segmentsWithNaNorInf = or(segmentsWithNaNorInf, isinf(prop));
        
    end
    
    
    localIndexesOfBranches = and ( or(isBranchPoint, isTermination) , not(segmentsFromUnbranchedSubTrees));
    localIndexesOfBranches = and ( localIndexesOfBranches , not(segmentsWithNaNorInf));
    branchIndexes = id(localIndexesOfBranches);
    
    
    branchProperties.('isBranchPoint') = isBranchPoint(branchIndexes);
    branchProperties.('isTermination') = isTermination(branchIndexes);
    branchProperties.('stemParent') = stemParent(branchIndexes);
    
    
    localPropNames = parameters.('featureNames').('local').('mixed');
    
    for j = 1:length(localPropNames)
        name = char(localPropNames(j));
        
        if strcmp(name, 'id') || strcmp(name, 'parent') || strcmp(name, 'type')||...
                 strcmp(name, 'radius') || strcmp(name, 'proximal_position_x') || strcmp(name, 'proximal_position_y') || strcmp(name, 'proximal_position_z') ||...
                 strcmp(name, 'segment_length') || strcmp(name, 'area') || strcmp(name, 'isBranchPoint') || strcmp(name, 'isTermination')
            continue;
        end

        prop = properties.('data').('local').(name);
       
        branchProperties.(name) = prop(branchIndexes,:);
        
    end
    
end
    
    
    
    
    
    
    
    
    
    
    