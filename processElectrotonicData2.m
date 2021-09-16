

function properties  = processElectrotonicData2 (mn_struct, passiveParams, geometryType)
    
    w = passiveParams.('w');
    
    centrifugalAttenuation_mod_matrix = [];
    centripetalAttenuation_mod_matrix = [];
    centrifugalVoltageTransfer_mod_matrix = [];
    centripetalVoltageTransfer_mod_matrix = [];
    centripetalVoltageTransfer_phase_matrix = [];
    transferImpedanceToSoma_mod_matrix = [];
    transferImpedanceToSoma_phase_matrix = [];
    inputImpedance_mod_matrix = [];
    inputImpedance_phase_matrix = [];
    transferImpedanceToSoma_mod_norm_matrix = [];
    
    for i = 1:length(w) 
        display(sprintf('w = %f', w(i)));
        [centrifugalAttenuation, centripetalAttenuation,...
            centrifugalVoltageTransfer, centripetalVoltageTransfer,...
            transferImpedanceToSoma, inputImpedance] = calculateElectrotonics (passiveParams, w(i), mn_struct, geometryType);

        centrifugalAttenuation_mod_matrix =     [centrifugalAttenuation_mod_matrix,             abs(centrifugalAttenuation)];
        centripetalAttenuation_mod_matrix =     [centripetalAttenuation_mod_matrix,             abs(centripetalAttenuation)];
        centrifugalVoltageTransfer_mod_matrix =     [centrifugalVoltageTransfer_mod_matrix,     abs(centrifugalVoltageTransfer)];
        centripetalVoltageTransfer_mod_matrix =     [centripetalVoltageTransfer_mod_matrix,     abs(centripetalVoltageTransfer)];
        centripetalVoltageTransfer_phase_matrix =     [centripetalVoltageTransfer_phase_matrix, angle(centripetalVoltageTransfer)];
        transferImpedanceToSoma_mod_matrix =    [transferImpedanceToSoma_mod_matrix,            abs(transferImpedanceToSoma)];
        transferImpedanceToSoma_mod_norm_matrix = [transferImpedanceToSoma_mod_norm_matrix,     abs(transferImpedanceToSoma)];
        transferImpedanceToSoma_phase_matrix =  [transferImpedanceToSoma_phase_matrix,          angle(transferImpedanceToSoma)];
        inputImpedance_mod_matrix =             [inputImpedance_mod_matrix,                     abs(inputImpedance)];
        inputImpedance_phase_matrix =             [inputImpedance_phase_matrix,                 angle(inputImpedance)];
        
    end
    
    properties = mn_struct;
    properties.('data').('local').('centrifugalVoltageAttenuation_mod') =   centrifugalAttenuation_mod_matrix;
    properties.('data').('local').('centripetalVoltageAttenuation_mod') =   centripetalAttenuation_mod_matrix;
    properties.('data').('local').('centrifugalVoltageTransfer_mod') =   centrifugalVoltageTransfer_mod_matrix;
    properties.('data').('local').('centripetalVoltageTransfer_mod') =   centripetalVoltageTransfer_mod_matrix;
    properties.('data').('local').('centripetalVoltageTransfer_phase') =   centripetalVoltageTransfer_phase_matrix;
    properties.('data').('local').('transferImpedanceToSoma_mod') =  transferImpedanceToSoma_mod_matrix;
    properties.('data').('local').('transferImpedanceToSoma_mod_norm') =  transferImpedanceToSoma_mod_matrix / inputImpedance_mod_matrix(1,1);
    properties.('data').('local').('transferImpedanceToSoma_phase') = transferImpedanceToSoma_phase_matrix;
    properties.('data').('local').('inputImpedance_mod') =           inputImpedance_mod_matrix;
    properties.('data').('local').('inputImpedance_phase') =           inputImpedance_phase_matrix;
end












