

function [group_array, cmapBranches, mapBranchToColor, maxPathLength] = plotSomatofugalPropColorByBranch2 (mnProperties, parameters, metric, propName, sym, siz, showOnlyTree)
    
    numOfSegments = mnProperties.('numOfSegments');
    isBranchPoint = mnProperties.('data').('local').('isBranchPoint');
    isTermination = mnProperties.('data').('local').('isTermination');
    zeroOrderSegments = mnProperties.('data').('zeroOrderSegments');
    stemParent = mnProperties.('data').('local').('stemParent');
    
    branchesInTree = [];
    if showOnlyTree
        for i = 1:numOfSegments
            if zeroOrderSegments(showOnlyTree) == stemParent(i)
                if isBranchPoint(i) || isTermination(i)
                    branchesInTree = [branchesInTree; i];
                end
            end
        end
    end
    
    
    
    somatofugalProp = [];
    group_array = {};
    x = [];
    
    for i = 1:length(branchesInTree)
        somatof = getSomatofugalProperties2 (mnProperties, parameters, metric, propName, 0, branchesInTree(i));
        b = somatof.(propName);
        aux = 0;
        for j = 1:length(b)
            aux = aux + parameters.somatofugalParams.step;
            
            for k = 1:length(b{j})
                somatofugalProp = [somatofugalProp; b{j}];
                x = [x; aux];
                group_array = [group_array; num2str(aux)];
            end
        end
    end
    
    
    groupCollection_array_reduced = eliminateRepetitiveStringsFromCellarray(group_array);
    aux = str2num(char(groupCollection_array_reduced));
    [~, sortIdx] = sort(aux);
    unsorted = 1:length(aux);
    newInd(sortIdx) = unsorted;
    cmapBranches = jet(length(groupCollection_array_reduced));
    cmapBranches = cmapBranches(newInd,:);
    
    mapBranchToColor = zeros(length(branchesInTree), 3);
    for i = 1:length(groupCollection_array_reduced)
        indexes = ismember(group_array, groupCollection_array_reduced(i));
        aux = find(indexes);
        for j = 1:length(aux)
            mapBranchToColor(aux(j),:) = cmapBranches(i,:);
        end
    end
    
    maxPathLength = max(x);
        
    plot2DScatter( x, somatofugalProp, group_array, sym, siz, cmapBranches);
    
end