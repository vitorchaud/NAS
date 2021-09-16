
function [centrifugalAttenuation, centripetalAttenuation, centrifugalVoltageTransfer, centripetalVoltageTransfer,...
            transferImpedanceToSoma, inputImpedance] = calculateElectrotonics (passiveParams, w, mn, geometryType)
    
    
    numOfSegments = mn.('numOfSegments');                                                                                        
    type =  mn.('data').('local').('type');         
    parent =  mn.('data').('local').('parent');    
    radius =  mn.('data').('local').('radius');    
    area =  mn.('data').('local').('area');    
    segment_length =  mn.('data').('local').('segment_length');    
    childs_cellarray = mn.('data').('local').('childs_cellarray'); 
    
    [cm, rm, ra_prox] = calculatePassiveParams4(passiveParams.('Cm'), passiveParams.('Rm_soma'), passiveParams.('Rm_dend'),...
                                            passiveParams.('Ra'), numOfSegments, type, parent, radius, area, segment_length, geometryType);
    
    
    
    A = zeros(numOfSegments, numOfSegments);
    voltageAttenuationMatrix = zeros(numOfSegments, numOfSegments);
    
    perc = 0.0;
    h = waitbar(perc,'Calculating electrotonic properties...');
    
    for i = 1:numOfSegments
        perc = i/numOfSegments;
        waitbar(perc,h);
        
        if type(i) ~= 1 %% if not soma
            A(i, parent(i)) = -1/ra_prox(i); 
            A(i, i) = +1/rm(i) + complex(0,w*cm(i)) + 1/ra_prox(i);
        else
            A(i, i) = +1/rm(i) + complex(0,w*cm(i));
        end
        
        
        daugther_array = cell2mat(childs_cellarray(i));
        if ~isempty(daugther_array)
            for j = 1:length(daugther_array)
                daugther_index = daugther_array(j);
                
                A(i, i) = A(i, i) + 1/ra_prox(daugther_index);
                A(i, daugther_index) = -1/ra_prox(daugther_index);
            end
        end
    end
    close(h);
    
    K = inv(A);
    
    for i = 1:numOfSegments
        for j = 1:numOfSegments
            voltageAttenuationMatrix(i,j) = K(i,i)/K(i,j);
        end
    end
    
    inputImpedance = diag(K);
    transferImpedanceToSoma = K(:,1);
    centrifugalAttenuation = voltageAttenuationMatrix(1,:)';
    centripetalAttenuation = voltageAttenuationMatrix(:,1);
    centrifugalVoltageTransfer = 1 ./ centrifugalAttenuation;
    centripetalVoltageTransfer = 1 ./ centripetalAttenuation;
    
end