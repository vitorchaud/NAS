

function [parentBranchPoint, totalPathLength, totalPathArea, pathLengths, euclidianLengths] = findParentBranchPoint(index, parent, isBranchPoint, compartmentLength, compartmentArea,...
                                                                                            pathLength, branchArea, pathLengthsInsideBranch, euclidianLengthsInsideBranch, branchIdx, ...
                                                                                            x, y, z)
    % Must initialize pathLength and branchArea with 0
    % arrays pathLengthsInsideBranch and euclidianLengthsInsideBranch are
    % initialized as [].
    
    
    
    if isBranchPoint(parent(index)) || parent(index) == 1
        parentBranchPoint = parent(index);
        totalPathLength = pathLength + compartmentLength(index);
        totalPathArea = branchArea + compartmentArea(index);
        pathLengths = [pathLengthsInsideBranch; pathLength + compartmentLength(index)];
        distance = getEuclidianDistance (branchIdx, parent(index), x, y, z);
        euclidianLengths = [euclidianLengthsInsideBranch; distance];
    else
        pathLengths = [pathLengthsInsideBranch; pathLength + compartmentLength(index)];
        distance = getEuclidianDistance (branchIdx, parent(index), x, y, z);
        euclidianLengths = [euclidianLengthsInsideBranch; distance];
        [parentBranchPoint, totalPathLength, totalPathArea, pathLengths, euclidianLengths] = findParentBranchPoint(parent(index), parent, isBranchPoint, compartmentLength, compartmentArea,...
                                                                pathLength + compartmentLength(index), branchArea + compartmentArea(index), pathLengths, euclidianLengths, branchIdx, ...
                                                                x, y, z);
    end

end