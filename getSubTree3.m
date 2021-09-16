

function [subTree, compartmentDegree, partitionAsymmetry, sumOfAsymmetries, hortonStrahler, branchIdx] = getSubTree3(index, childs_cellarray, isBranchPoint, isTermination)
    
    % This function returns the subtree and the degree of a specified node
    % (segment) i.
    
    childs = cell2mat(childs_cellarray(index))';
    if isBranchPoint(index)
        [subTree1, compartmentDegree1, ~, sumOfAsymmetries1, hortonStrahler1] = getSubTree3(childs(1), childs_cellarray, isBranchPoint, isTermination);
        [subTree2, compartmentDegree2, ~, sumOfAsymmetries2, hortonStrahler2] = getSubTree3(childs(2), childs_cellarray, isBranchPoint, isTermination);
        subTree = [childs(1); subTree1; childs(2); subTree2];
        compartmentDegree = compartmentDegree1 + compartmentDegree2;
        if compartmentDegree1 + compartmentDegree2 > 2
            partitionAsymmetry = abs(compartmentDegree1 - compartmentDegree2) / (compartmentDegree1 + compartmentDegree2 - 2);
            sumOfAsymmetries = sumOfAsymmetries1 + sumOfAsymmetries2 + partitionAsymmetry;
        else % 
            partitionAsymmetry = 0;
            sumOfAsymmetries = sumOfAsymmetries1 + sumOfAsymmetries2;
        end
        if hortonStrahler1 == hortonStrahler2
            hortonStrahler = compartmentDegree1 + 1;
        else
            hortonStrahler = max(hortonStrahler1, hortonStrahler2);
        end
        branchIdx = index;
    elseif isTermination(index)
        compartmentDegree = 1;
        subTree = [];
        partitionAsymmetry = NaN;
        sumOfAsymmetries = 0;
        hortonStrahler = 0;
        branchIdx = index;
    else
        [subTree1, compartmentDegree, partitionAsymmetry, sumOfAsymmetries, hortonStrahler, branchIdx] = getSubTree3(childs(1), childs_cellarray, isBranchPoint, isTermination);
        subTree = [childs(1); subTree1];
    end
end