

function [stem, compartmentOrder] = findStemDendrite(index, parent, isBranchPoint, k)
    
    if isBranchPoint(parent(index))
        k = k + 1;
    end
    if parent(index) == 1
        stem = index;
        compartmentOrder = k;
    else
        [stem, compartmentOrder] = findStemDendrite(parent(index), parent, isBranchPoint, k);
    end

end