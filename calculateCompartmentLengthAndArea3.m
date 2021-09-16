

function [radial_distance, compartment_length_array, compartment_area_array,...
            proximal_position_x, proximal_position_y, proximal_position_z] = calculateCompartmentLengthAndArea3(numOfCompartments,...
                                                                                    type, x, y, z, radius, parent, somaGeometry, geometryType)
    
                                                                                
%     numOfCompartments
%     length(x)
    
    proximal_position_x = zeros(numOfCompartments, 1);
    proximal_position_y = zeros(numOfCompartments, 1);
    proximal_position_z = zeros(numOfCompartments, 1);
    radial_distance = zeros(numOfCompartments, 1); % distance to soma center
    
    compartment_length_array = zeros(numOfCompartments, 1);
    compartment_area_array = zeros(numOfCompartments, 1);

    if strcmp(somaGeometry, 'sphere')  ||   strcmp(somaGeometry, 'point')
        perc = 0.0;
        h = waitbar(perc,'Calculating segment areas and lengths...');
        for i = 1:numOfCompartments
            perc = i/numOfCompartments;
            waitbar(perc,h);
            if parent(i) == -1 % soma
                proximal_position_x(i) = x(i);
                proximal_position_y(i) = y(i);
                proximal_position_z(i) = z(i);
                % radial position is not defined for the soma
                compartment_length_array(i) = 2*radius(i); % assigning length equal to the diameter
                compartment_area_array(i) = 4*pi*radius(i)^2;
                

            elseif type(i) == 1 && parent(i) == 1 % false compartments
                continue;
            else
                proximal_position_x(i) = x(parent(i));
                proximal_position_y(i) = y(parent(i));
                proximal_position_z(i) = z(parent(i));
                dx = x(1) - x(i) ;
                dy = y(1) - y(i) ;
                dz = z(1) - z(i) ;
                radial_distance(i) = sqrt(dx^2 + dy^2 + dz^2);

                dx = proximal_position_x(i) - x(i) ;
                dy = proximal_position_y(i) - y(i) ;
                dz = proximal_position_z(i) - z(i) ;
                d = sqrt(dx^2 + dy^2 + dz^2);

                compartment_length_array(i) = d;
                if strcmp(geometryType, 'frustum')
                    compartment_area_array(i) = pi*(radius(i)+radius(parent(i))) * sqrt((radius(i)-radius(parent(i)))^2 + d^2);
                elseif strcmp(geometryType, 'cylinder')
                    compartment_area_array(i) = 2*pi*radius(i)*d;
                end 
            end
        end
        close(h);
    end
end