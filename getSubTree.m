

function [subTree, compartmentDegree] = getSubTree(index, childs_cellarray, isBranchPoint, isTermination)
    
    % This function returns the subtree and the degree of a specified node
    % (segment) i.
    
    childs = cell2mat(childs_cellarray(index))';
    if isBranchPoint(index)
        [subTree1, compartmentDegree1] = getSubTree(childs(1), childs_cellarray, isBranchPoint, isTermination);
        [subTree2, compartmentDegree2] = getSubTree(childs(2), childs_cellarray, isBranchPoint, isTermination);
        subTree = [childs(1); subTree1; childs(2); subTree2];
        compartmentDegree = compartmentDegree1 + compartmentDegree2;
    elseif isTermination(index)
        compartmentDegree = 1;
        subTree = [];
    else
        [subTree1, compartmentDegree] = getSubTree(childs(1), childs_cellarray, isBranchPoint, isTermination);
        subTree = [childs(1); subTree1];
    end
end