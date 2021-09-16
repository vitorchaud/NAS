

function pathLength = calculatePathLength(index, parent, compartment_length)
    
    if index == 1
        pathLength = 0;
    else
        pathLength = compartment_length(index) + calculatePathLength(parent(index), parent, compartment_length);
    end

end