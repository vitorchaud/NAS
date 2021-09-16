

function [numOfSegments, prop] = calculateNumOfSegmentsSingleNeuron (fileName, parameters, geometryType, maxSegmentLength)
    

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
    
    
    
    numOfSegments = length(id);
    
    [radial_distance, segment_length, area,...
         proximal_position_x, proximal_position_y, proximal_position_z] = calculateCompartmentLengthAndArea3(numOfSegments, type, x, y, z, radius, parent, somaGeometry, geometryType);
    
     
    path_length = zeros(numOfSegments, 1);
    
    for i = 1:numOfSegments
        if type(i) == 1
            continue;
        else
            % Obtaining segment path distance from soma
            path_length(i) = calculatePathLength(i, parent, segment_length);
        end
    end
    
    
    prop.('numOfSegments') = numOfSegments;
    prop.('data').('local').('type') = type;
    prop.('data').('local').('parent') = parent;
    prop.('data').('local').('x') = x;
    prop.('data').('local').('y') = y;
    prop.('data').('local').('z') = z;
    prop.('data').('local').('radius') = radius;
    prop.('data').('local').('proximal_position_x') = proximal_position_x;
    prop.('data').('local').('proximal_position_y') = proximal_position_y;
    prop.('data').('local').('proximal_position_z') = proximal_position_z;
    prop.('data').('local').('id') = id;
    prop.('data').('local').('radial_distance') = radial_distance;
    prop.('data').('local').('segment_length') = segment_length;
    prop.('data').('local').('path_length') = path_length;
    prop.('data').('local').('order') = id; % won't use
end




