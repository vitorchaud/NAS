


function indexes =  getCompartmentIndexesBySection5(mn_struct, d_min, d_max, specifiedOrder, metric)

    numOfSegments = mn_struct.('numOfSegments');
    
    type = mn_struct.('data').('local').('type');
    parent = mn_struct.('data').('local').('parent');
    radius = mn_struct.('data').('local').('radius');
    radial_distance = mn_struct.('data').('local').('radial_distance');
    compartment_path_length = mn_struct.('data').('local').('path_length');
    compartment_length = mn_struct.('data').('local').('segment_length');
    order = mn_struct.('data').('local').('order');

    % This function returns an array of the same size of the number of
    % compartments. Each element of the array has one of two possible
    % values: 1 indicating that the associated compartment is inside the
    % diameter range specified (by d_min and d_max) and 0 if it is not in
    % the range. Here, in order to a compartment be considered in the range
    % its midpoint must be inside the specified region (as in Cullheim
    % 1987)
    
    
    indexes = zeros(numOfSegments, 1);
    
    if strcmp(metric, 'path')
        for i = 1:numOfSegments
            
            if (type(i) == 1 && parent(i) == -1) % if compartment is soma
                if d_min == 0 && radius(i) <= d_max
                    indexes(i) = 1;
                end
            else
                midpoint_path_length = compartment_path_length(i) - compartment_length(i)/2;
                if midpoint_path_length >= d_min && midpoint_path_length < d_max
                    indexes(i) = 1;
                end
            end
        end
    elseif strcmp(metric, 'euclidian')
        for i = 1:numOfSegments
            
            if (type(i) == 1 && parent(i) == -1) % if compartment is soma
                if d_min == 0 && radius(i) <= d_max
                    indexes(i) = 1;
                end
            else
                midpoint_distance = 0.5 * (radial_distance(i) + radial_distance(parent(i)));
                if midpoint_distance >= d_min && midpoint_distance < d_max
                    indexes(i) = 1;
                end
            end
        end
    elseif strcmp(metric, 'order')
        for i = 1:numOfSegments
            
            if order(i) == specifiedOrder
                indexes(i) = 1;
            end
        end
    else
        error('NAS: Wrong specification of metric to use in function');
    end
    
end



