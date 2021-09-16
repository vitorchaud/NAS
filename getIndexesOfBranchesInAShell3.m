


function indexes =  getIndexesOfBranchesInAShell3(mn_struct, d, metric)
    
    numOfSegments = mn_struct.('numOfSegments');
    
    type = mn_struct.('data').('local').('type');
    parent = mn_struct.('data').('local').('parent');
%     radius = mn_struct.('data').('local').('radius');
    radial_distance = mn_struct.('data').('local').('radial_distance');
    compartment_path_length = mn_struct.('data').('local').('path_length');
%     compartment_length = mn_struct.('data').('local').('segment_length');
    
    indexes = zeros(numOfSegments, 1);
    
    if strcmp(metric, 'path')
        for i = 1:numOfSegments
            if (type(i) == 1) % if compartment is soma or false compartment
                indexes(i) = 0;
            else
                if (compartment_path_length(parent(i)) < d && compartment_path_length(i) > d)   ||   (compartment_path_length(parent(i)) > d && compartment_path_length(i) < d)
                    indexes(i) = 1;
                end
            end
        end
    elseif strcmp(metric, 'euclidian')
        for i = 1:numOfSegments
            if (type(i) == 1) % if compartment is soma or false compartment
                indexes(i) = 0;
            else
                if (radial_distance(parent(i)) < d && radial_distance(i) > d)   ||   (radial_distance(parent(i)) > d && radial_distance(i) < d)
                    indexes(i) = 1;
                end
            end
        end
    else
        error('MNS: Wrong specification of metric to use in function');
    end
    
    
    
end



