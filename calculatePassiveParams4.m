

function [cm_array, rm_array, ra_prox_array] = calculatePassiveParams4(Cm, Rm_soma, Rm_dend, Ra,...
                                                            numOfCompartments, type, parent, radius, area, compartment_length_array, geometryType)
    
    
    %% Coverting lengths and areas from um to cm
    
    area_converted = area * 1e-8; % [um^2]->[cm^2]
    radius_converted = radius * 1e-4; % [um]->[cm]
    compartment_length_converted = compartment_length_array * 1e-4; % [um]->[cm]
    
    cm_array = Cm .* area_converted; % [uF/cm^2]->[uF]
    
    rm_array = 1e-3 * Rm_dend ./ area_converted; % [ohm.cm^2]->[kohm]
    rm_array(1) = 1e-3 * Rm_soma ./ area_converted(1); % [ohm.cm^2]->[kohm]
    
    ra_prox_array = zeros(numOfCompartments, 1);
    
    for i = 1:numOfCompartments
        if type(i) == 1
            continue;
        end
        meanRadius = 0.5 * (radius_converted(i) + radius_converted(parent(i)));
        if parent(i) == 1
            ra_prox_array(i) = Ra * compartment_length_converted(i) / (pi * meanRadius^2);
        elseif strcmp(geometryType, 'frustum')
            meanRadiusParent = 0.5 * (radius_converted(parent(i)) + radius_converted(parent(parent(i))));
            term1 = Ra * 0.5 * compartment_length_converted(i) / (pi * meanRadius * radius_converted(parent(i)));
            term2 = Ra * 0.5 * compartment_length_converted(parent(i)) / (pi * radius_converted(parent(i)) * meanRadiusParent);
            ra_prox_array(i) = term1 + term2;
            
        elseif strcmp(geometryType, 'cylinder')
            ra_prox_array(i) = Ra * 0.5 * compartment_length_converted(i) / (pi * radius_converted(i)^2) +...
                Ra * 0.5 * compartment_length_converted(parent(i)) / (pi * radius_converted(parent(i))^2);
        end
        
    end
    ra_prox_array = 1e-3 .* ra_prox_array;  % [ohm]->[kohm]
    
end