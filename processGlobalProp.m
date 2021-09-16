
function properties = processGlobalProp(parameters, properties)

    models_cellarray    = parameters.models_cellarray;
    mnFileNames_cellarray = parameters.mnFileNames_cellarray;
    process             = parameters.isProcess;

    for i = 1:length(models_cellarray)
        modelName = char(models_cellarray(i));

        if process.(modelName)

            numOfMNs.(modelName) = length(mnFileNames_cellarray.(modelName));
            mnNames.(modelName) = cell(numOfMNs.(modelName),1);

            for j = 1:numOfMNs.(modelName)

                str = sprintf('%s%d', modelName, j);
                mnNames.(modelName)(j) = cellstr(str);
                display('.................');
                display(sprintf('Processing global properties: %s', str));
                display('.................');

                globalProps = calculateGlobalProp (properties.(str), parameters);

%                 % The following code merges the pre-existing global struct with
%                 % the calculated globalProps. However, these two structs should
%                 % not have fields with the same name
% 
%                 struct1 = properties.(str).('data').('neuronLevel');
% 
%                 fieldNames1 = fieldnames(struct1);
% 
%                 for k = 1:size(fieldNames1,1)
%                     globalProps.(fieldNames1{k}) = struct1.(fieldNames1{k});
%                 end

                properties.(str).('data').('neuronLevel') = globalProps;


            end

        end


    end

end


        

