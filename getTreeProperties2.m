
function [propsBranchLevels, propsDendTrees, zeroOrderSegments, segmentsFromUnbranchedSubTrees] = getTreeProperties2 (properties, parameters)
    
    childs_cellarray = properties.('data').('local').('childs_cellarray');
    isBranchPoint = properties.('data').('local').('isBranchPoint');
    isTermination = properties.('data').('local').('isTermination');
    parent = properties.('data').('local').('parent');
    id = properties.('data').('local').('id');
    
    zeroOrderSegments = find(parent==1);
    
    treeHasBranchPoint = ones(length(zeroOrderSegments), 1);
    
    min_array = [];
    lowerQuartile_array = [];
    median_array = [];
    upperQuartile_array = [];
    max_array = [];
    mean_array = [];
    std_array = [];
    total_array = [];
    

    segmentsFromUnbranchedSubTrees = zeros(length(id), 1);
    
    % Eliminate unbranched trees from analysis
    if parameters.isEliminateUnbranchedTrees
        
        for i = 1:length(zeroOrderSegments)
            [subTree, ~] = getSubTree(zeroOrderSegments(i), childs_cellarray, isBranchPoint, isTermination);
            indexes = and(isBranchPoint, ismember(id,subTree));
            if nnz(indexes) == 0
                treeHasBranchPoint(i) = 0;
                segmentsFromUnbranchedSubTrees = or(segmentsFromUnbranchedSubTrees, ismember(id,subTree));
                str = sprintf('MNS: Dendritic tree %d has no branch point!\nThis tree will not be considered in analysis', i);
                display(str);
            end
        end
        zeroOrderSegments(not(treeHasBranchPoint)) = [];
        treeHasBranchPoint(not(treeHasBranchPoint)) = [];
    end
    
    
    [propsBranchLevels, indexesBranches] = getBranchProperties (properties, parameters, segmentsFromUnbranchedSubTrees);

    propsBranchLevels.('branchIndexes') = indexesBranches;
    
    
    % This aditional code is necessary due to elimination
    % of branches with NaN value at getBranchProperties()
    for i = 1:length(zeroOrderSegments)
        [subTree, ~] = getSubTree(zeroOrderSegments(i), childs_cellarray, isBranchPoint, isTermination);
        indexes = ismember(indexesBranches, subTree);
        if nnz(indexes) == 0
            treeHasBranchPoint(i) = 0;
            str = sprintf('MNS: Dendritic tree %d has no branch point!\nThis tree will not be considered in analysis', i);
            display(str);
        end
    end
    zeroOrderSegments(not(treeHasBranchPoint)) = [];
    treeHasBranchPoint(not(treeHasBranchPoint)) = [];
    
    
    
    
    
    
%     propNames = parameters.featureNames.branchLevel.mixed;
    propNames = [parameters.('featureNames').('treeLevel').('morphological'); parameters.('featureNames').('treeLevel').('electronic')];
    
    for j = 1:length(propNames)
        name = char(propNames(j));
        
        prop = propsBranchLevels.(name);
        
        for i = 1:length(zeroOrderSegments)
            if treeHasBranchPoint(i)
                [subTree, ~] = getSubTree(zeroOrderSegments(i), childs_cellarray, isBranchPoint, isTermination);
                
                indexes = ismember(indexesBranches, subTree);
                
                prop_subTree = prop(indexes,:);
                prop_subTree(isnan(prop_subTree))=[]; % eliminate NaN values
                
                aux = size(prop_subTree);
                if aux(1)==1 % only one line
                    min_array =             [min_array;             prop_subTree];
                    lowerQuartile_array =   [lowerQuartile_array;   prop_subTree];
                    median_array =          [median_array;          prop_subTree];
                    upperQuartile_array =   [upperQuartile_array;   prop_subTree];
                    max_array =             [max_array;             prop_subTree];
                    mean_array =            [mean_array;            prop_subTree];
                    std_array =             [std_array;             prop_subTree];
                    total_array =           [total_array;           prop_subTree];
                else
                    min_array =             [min_array;             min(prop_subTree)];
                    lowerQuartile_array =   [lowerQuartile_array;   quantile(prop_subTree, 0.25)];
                    median_array =          [median_array;          quantile(prop_subTree, 0.5)];
                    upperQuartile_array =   [upperQuartile_array;   quantile(prop_subTree, 0.75)];
                    max_array =             [max_array;             max(prop_subTree)];
                    mean_array =            [mean_array;            mean(prop_subTree)];
                    std_array =             [std_array;             std(prop_subTree)];
                    total_array =           [total_array;           sum(prop_subTree)];
                end
            end
        end
        
        propsDendTrees.(name).('min') = min_array;
        propsDendTrees.(name).('lowerQuartile') = lowerQuartile_array;
        propsDendTrees.(name).('median') = median_array;
        propsDendTrees.(name).('upperQuartile') = upperQuartile_array;
        propsDendTrees.(name).('max') = max_array;
        propsDendTrees.(name).('mean') = mean_array;
        propsDendTrees.(name).('std') = std_array;
        propsDendTrees.(name).('total') = total_array;
        
        min_array = [];
        lowerQuartile_array = [];
        median_array = [];
        upperQuartile_array = [];
        max_array = [];
        mean_array = [];
        std_array = [];
        total_array = [];
    end
    
    
end
    
    
    
    