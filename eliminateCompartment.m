
function [numOfSegments, id, type, x, y, z, radius, parent] = eliminateCompartment(numOfSegments, id, type, x, y, z, radius, parent, compartmentID)
    

    numOfSegments = numOfSegments - 1;
    id(end) = [];
    type(compartmentID) = [];
    x(compartmentID) = [];
    y(compartmentID) = [];
    z(compartmentID) = [];
    radius(compartmentID) = [];
    parent(compartmentID) = [];

    for j = compartmentID:length(parent)
        if parent(j) < compartmentID
            continue;
        end
        parent(j) = parent(j) - 1;
    end
    parent(parent==0) = 1;


end