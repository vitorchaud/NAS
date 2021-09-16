

function [numOfSegments, mn_local_prop, flag] = calculateLocalPropSingleNeuron (fileName, parameters, geometryType, maxSegmentLength)
    
    
    

    %% loading file data
    
    display('loading file data');
    
    fileID = fopen(fileName, 'r');
    loadedData = textscan(fileID,'%d %d %f %f %f %f %d ','CommentStyle','#');
    id = cell2mat(loadedData(:,1));
    type = cell2mat(loadedData(:,2));
    x = cell2mat(loadedData(:,3));
    y = cell2mat(loadedData(:,4));
    z = cell2mat(loadedData(:,5));
    radius = cell2mat(loadedData(:,6));
    parent = cell2mat(loadedData(:,7));
    
    
    %% Performing some file format verifications..
    display('Performing some file format verifications..');
    % Checking if  soma is spheric
    
    if (nnz(type==1) == 3) % Soma is spheric.
        somaGeometry = 'sphere';
        
        % Eliminating false compartments (index 2 and 3)
        id(end-1:end) = [];
        type(2:3) = [];
        x(2:3) = [];
        y(2:3) = [];
        z(2:3) = [];
        radius(2:3) = [];
        parent(2:3) = []; 
        parent(2:end) = parent(2:end) - 2;
        parent(parent==-1) = 1;
        parent(1) = -1;
        
    elseif (nnz(type==1) == 1) % Soma is a point.. Treating as sphere
        somaGeometry = 'point';
    else
        error('MNS: Cant recognize soma geometry!!');
    end
    
    
    % Checking if there is 1 to 1 correspondence between arrray index and id
    %  This means that it is possible to use ids as indexes

    aux1 = 1:length(id);
    if nnz(int32(aux1') - id) > 0
        error('MNS: The SWC file does not have 1 to 1 correspondence between arrray index and id');
    end
    
    

    %% Calculating local properties
    display('Calculating local properties...');
    
    numOfSegments = length(id);
    
    if numOfSegments > parameters.maxNumOfSegments
        numOfSegments = parameters.maxNumOfSegments;
        id = id(1:numOfSegments);
        type = type(1:numOfSegments);
        x = x(1:numOfSegments);
        y = y(1:numOfSegments);
        z = z(1:numOfSegments);
        radius = radius(1:numOfSegments);
        parent = parent(1:numOfSegments);
    end
    
    
    [radial_distance, segment_length, area,...
         proximal_position_x, proximal_position_y, proximal_position_z] = calculateCompartmentLengthAndArea3(numOfSegments, type, x, y, z, radius, parent, somaGeometry, geometryType);
    
    

    % Checking if compartment sizes are larger than the maximum. If so, they are splited..
    
    flag = 0;
    numOfPieces_array = ones(numOfSegments,1);
    for i = 1:numOfSegments
        if type(i) == 1
            continue;
        end
        d = segment_length(i);
        if d > maxSegmentLength
            numOfPieces_array(i) = floor(d/maxSegmentLength) + 1;
            
            if ~flag
                flag = 1;
            end
        end
    end
    
    
    
    if(flag)
        
        newnumOfSegments = sum(numOfPieces_array);
        id_new = (1:newnumOfSegments)';
        type_new = zeros(newnumOfSegments, 1);
        x_new = zeros(newnumOfSegments, 1);
        y_new = zeros(newnumOfSegments, 1);
        z_new = zeros(newnumOfSegments, 1);
        radius_new = zeros(newnumOfSegments, 1);
        parent_new = zeros(newnumOfSegments, 1);
        
        cumPath = zeros(numOfSegments,1);
        index_displacement = 0;
        for i = 1:numOfSegments
            p = numOfPieces_array(i);
            index_displacement = index_displacement + p;
            cumPath(i) = index_displacement;
            isNewBranch = 0;
            if id(i) - parent(i) > 1  && parent(i) ~= 1  % excluding stem dendrites
                isNewBranch = 1;
            end
            if p == 1
                index = index_displacement;
                type_new(index) = type(i);
                x_new(index) = x(i);
                y_new(index) = y(i);
                z_new(index) = z(i);
                radius_new(index) = radius(i);
                
                if type(i) == 1 || parent(i) == 1
                    parent_new(index) = parent(i);
                elseif isNewBranch
                    index_diff = cumPath(i-1) - cumPath(parent(i));
                    parent_new(index) = index-index_diff-1;
                else
                    parent_new(index) = id_new(index-1);
                end
            elseif p > 1
                for k = 1:p 
                    index = index_displacement+k-p;
                    type_new(index) = type(i);
                    radius_new(index) = radius(i);
                    
                    if k==1 && parent(i)==1
                        parent_new(index) = 1;
                    elseif k==1 && isNewBranch
                        index_diff = cumPath(i-1) - cumPath(parent(i));
                        parent_new(index) = index-index_diff-1;
                    else
                        parent_new(index) = id_new(index-1);
                    end
                    
                    x_new(index) = proximal_position_x(i)  +   k * (x(i) - proximal_position_x(i))/p;
                    y_new(index) = proximal_position_y(i)   +   k * (y(i) - proximal_position_y(i))/p;
                    z_new(index) = proximal_position_z(i)   +   k * (z(i) - proximal_position_z(i))/p;
                    
                end
            end
        end
        
        
        numOfSegments = newnumOfSegments;
        id = id_new;
        type = type_new;
        x = x_new;
        y = y_new;
        z = z_new;
        radius = radius_new;
        
        parent = parent_new;

        [radial_distance, segment_length, area,...
         proximal_position_x, proximal_position_y, proximal_position_z] = calculateCompartmentLengthAndArea3(numOfSegments, type, x, y, z, radius, parent, somaGeometry, geometryType);
        
    end
    
    
    
    % Obtaining cellarray of childrens

    childs_cellarray = cell(numOfSegments, 1);

    for i = 1:numOfSegments
        if type(i) == 1
            continue;
        else
            childs_cellarray{parent(i)} = [childs_cellarray{parent(i)}, i];
        end
    end
    
    
    
    % Eliminate stem dendrite with no daughter
    
    if parameters.isEliminateStemDendWithNoDaugther  ||  parameters.isEliminateAxon
        i = 1;
        flagIsEliminating = 0;
        flagIsEliminating2 = 0;
        while i <= numOfSegments
            if parameters.isEliminateStemDendWithNoDaugther  &&  parent(i)==1  &&  isempty(cell2mat(childs_cellarray(i)))
                flagIsEliminating = 1;
                str = sprintf('MNS: Eliminating stem %d of %s\n with no daughter', i, fileName);
                msgbox(str);

                [numOfSegments, id, type, x, y, z, radius, parent] = eliminateCompartment(numOfSegments, id, type, x, y, z, radius, parent, i);
                i = i-1;
            end
            if parameters.isEliminateAxon  &&  type(i)==2
                flagIsEliminating2 = 1;
                [numOfSegments, id, type, x, y, z, radius, parent] = eliminateCompartment(numOfSegments, id, type, x, y, z, radius, parent, i);
                i = i-1;
            end
            i = i + 1;
        end
        if flagIsEliminating2
            str = sprintf('MNS: Eliminating axon: %s', fileName);
            msgbox(str);
        end
        if flagIsEliminating || flagIsEliminating2
            clear childs_cellarray;
            childs_cellarray = cell(numOfSegments, 1);
            for j = 1:numOfSegments
                if type(j) == 1
                    continue;
                else
                    childs_cellarray{parent(j)} = [childs_cellarray{parent(j)}, j];
                end
            end
            [radial_distance, segment_length, area,...
                    proximal_position_x, proximal_position_y, proximal_position_z] = calculateCompartmentLengthAndArea3(numOfSegments, type, x, y, z, radius, parent, somaGeometry, geometryType);
        end
    end
    
    
    
    
    % Obtaining compartment diameter
    
    diameter = 2*radius;
    
    
    
    path_length = zeros(numOfSegments, 1);
    isBranchPoint = zeros(numOfSegments, 1);
    isTermination = zeros(numOfSegments, 1);
    
    for i = 1:numOfSegments
        if type(i) == 1
            continue;
        else
            % Obtaining segment path distance from soma
            path_length(i) = calculatePathLength(i, parent, segment_length);
            
            % Determining if compartment is branch point
            if length(cell2mat(childs_cellarray(i))) > 1
                isBranchPoint(i) = 1;
            end
            
            % Determining if compartment is termination
            if isempty(cell2mat(childs_cellarray(i)))
                isTermination(i) = 1;
            end
        end
    end
    
    
    
    set(0,'RecursionLimit',10000)
    order = zeros(numOfSegments, 1);
    stemParent_array = zeros(numOfSegments, 1);
    contraction = NaN(numOfSegments, 1);  % Defined only for branch points and terminals
    fractalDimension = NaN(numOfSegments, 1);  % Defined only for branch points and terminals
    branch = zeros(numOfSegments, 1);
    branchEuclidianLength = zeros(numOfSegments, 1);
    branchPathLength = zeros(numOfSegments, 1);
    branchArea = zeros(numOfSegments, 1);
    degree = zeros(numOfSegments, 1);
    partitionAsymmetry = NaN(numOfSegments, 1); % Defined only for branch points
    sumOfAsymmetries = zeros(numOfSegments, 1);
    asymmetryIndex = zeros(numOfSegments, 1); % see Pelt 2004; not defined for soma! (it considers only binary trees)
    hortonStrahler = zeros(numOfSegments, 1);
    branchPointRallRatio = NaN(numOfSegments, 1); % Defined only for branch points
    angleWithParent = NaN(numOfSegments, 1);     % Defined only for branch points
    branchingAngle = NaN(numOfSegments, 1); % Defined only for branch points
    somatofugalTropism = zeros(numOfSegments, 1);
    pathLengthsInsideBranch = {};
    euclidianLengthsInsideBranch = {};
    
    perc = 0.0;
    h = waitbar(perc,'Calculating local properties...');
    
    for i = 1:numOfSegments
        perc = i/numOfSegments;
        waitbar(perc,h);
        if type(i) == 1
            continue;
        else
            % Obtaining compartment order of ramification and array of stem parent indexes 
            [stemParent_array(i), order(i)] = findStemDendrite(i, parent, isBranchPoint, 0);
            
            % Obtaining branch euclidian length and path length and contraction and fractal dimension; defined only for
            % branch points and terminations (branch direction to soma)
            if isBranchPoint(i) || isTermination(i)
                [parentBranchPoint, branchPathLength(i), branchArea(i), pathLengthsInsideBranch{i}, euclidianLengthsInsideBranch{i}] =...
                                                            findParentBranchPoint(i, parent, isBranchPoint, segment_length, area, 0, 0, [], [], i, x, y, z);
                branchEuclidianLength(i) = getEuclidianDistance (i, parentBranchPoint, x, y, z);
                contraction(i) = branchPathLength(i) / branchEuclidianLength(i);
                
                if length(euclidianLengthsInsideBranch{i}) >= 2 % fractal dimension is calculated only if branch has more than one segment
                    aux1 = euclidianLengthsInsideBranch{i};
                    aux2 = pathLengthsInsideBranch{i};
                    p = polyfit(log(aux1),log(aux2),1);
                    fractalDimension(i) = p(1);
                end
            end
            
            % Obtaining compartment degree
            [~, degree(i), partitionAsymmetry(i), sumOfAsymmetries(i), hortonStrahler(i), branch(i)] = getSubTree3(i, childs_cellarray, isBranchPoint, isTermination);
            if degree(i) == 1
                asymmetryIndex(i) = sumOfAsymmetries(i);
            else
                asymmetryIndex(i) = sumOfAsymmetries(i) / (degree(i) - 1);
            end
            
            % Obtaining Rall ratio at branch points; Defined only for branch points
            if isBranchPoint(i)
                indexes = cell2mat(childs_cellarray(i));
                index1 = indexes(1);
                index2 = indexes(2);
                branchPointRallRatio(i) = (diameter(index1)^1.5 + diameter(index2)^1.5) / (diameter(i)^1.5);
            end
            
            % Obtaining angle between compartment i and its parent; Defined only for branch points
            compartment_vector = [x(i) - proximal_position_x(i), y(i) - proximal_position_y(i), z(i) - proximal_position_z(i)];
            parent_vector = [x(parent(i)) - proximal_position_x(parent(i)), y(parent(i)) - proximal_position_y(parent(i)), z(parent(i)) - proximal_position_z(parent(i))];
            
            angleWithParent(i) = 180/pi * atan2(norm(cross(parent_vector,compartment_vector)),dot(parent_vector,compartment_vector));
            
            % Obtaining angle between two brother; Defined only for branch points
            if isBranchPoint(i)
                indexes = cell2mat(childs_cellarray(i));
                index1 = indexes(1);
                index2 = indexes(2);
                vector1 = [x(index1) - proximal_position_x(index1), y(index1) - proximal_position_y(index1), z(index1) - proximal_position_z(index1)];
                vector2 = [x(index2) - proximal_position_x(index2), y(index2) - proximal_position_y(index2), z(index2) - proximal_position_z(index2)];
            
                branchingAngle(i) = 180/pi * atan2(norm(cross(vector1,vector2)),dot(vector1,vector2));
            end
            
            
            % Obtaining segment somatofugal tropism 
            somatofugalTropism(i) = radial_distance(i) / path_length(i);
        end
    end
    
    degree(1) = max(degree);
    
    close(h)
    
    
    mn_local_prop.('type') = type;
    mn_local_prop.('parent') = parent;
    mn_local_prop.('childs_cellarray') = childs_cellarray;
    mn_local_prop.('x') = x;
    mn_local_prop.('y') = y;
    mn_local_prop.('z') = z;
    mn_local_prop.('radius') = radius;
    mn_local_prop.('diameter') = diameter;
    mn_local_prop.('proximal_position_x') = proximal_position_x;
    mn_local_prop.('proximal_position_y') = proximal_position_y;
    mn_local_prop.('proximal_position_z') = proximal_position_z;
    mn_local_prop.('id') = id;
    mn_local_prop.('radial_distance') = radial_distance;
    mn_local_prop.('segment_length') = segment_length;
    mn_local_prop.('path_length') = path_length;
    mn_local_prop.('area') = area;
    mn_local_prop.('order') = order;
    mn_local_prop.('degree') = degree;
    mn_local_prop.('angleWithParent') = angleWithParent;
    mn_local_prop.('contraction') = contraction;
    mn_local_prop.('fractalDimension') = fractalDimension;
    mn_local_prop.('somatofugalTropism') = somatofugalTropism;
    mn_local_prop.('isBranchPoint') = isBranchPoint;
    mn_local_prop.('isTermination') = isTermination;
    mn_local_prop.('partitionAsymmetry') = partitionAsymmetry;
    mn_local_prop.('asymmetryIndex') = asymmetryIndex;
    mn_local_prop.('hortonStrahler') = hortonStrahler;
%     mn_local_prop.('RallRatioInShell') = RallRatioInShell;
    mn_local_prop.('branchPointRallRatio') = branchPointRallRatio;
    mn_local_prop.('branchingAngle') = branchingAngle;
    mn_local_prop.('stemParent') = stemParent_array;
    
    mn_local_prop.('branch') = branch;
    mn_local_prop.('branchEuclidianLength') = branchEuclidianLength;
    mn_local_prop.('branchPathLength') = branchPathLength;
    mn_local_prop.('branchArea') = branchArea;
    
    
    mn_local_prop.('pathLengthsInsideBranch') = pathLengthsInsideBranch;
    mn_local_prop.('euclidianLengthsInsideBranch') = euclidianLengthsInsideBranch;
    
    
   
end




