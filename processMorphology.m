

function properties = processMorphology(parameters, properties)
    

    models_cellarray    = parameters.models_cellarray;
    mnFileNames_cellarray = parameters.mnFileNames_cellarray;
    maxCompartmentLength = parameters.maxCompartmentLength;
    geometryType        = parameters.geometryType;
    process             = parameters.isProcess;


    for i = 1:length(models_cellarray)
        modelName = char(models_cellarray(i));

        numOfMNs.(modelName) = length(mnFileNames_cellarray.(modelName));

        if process.(modelName)

            mnNames.(modelName) = cell(numOfMNs.(modelName),1);

            for j = 1:numOfMNs.(modelName)
                str = sprintf('%s%d', modelName, j);
                mnNames.(modelName)(j) = cellstr(str);
                display('.................');
                display(sprintf('Processing: %s', str));
                display('.................');
                fileName = char(mnFileNames_cellarray.(modelName)(j));   

                [numOfSegments, localData, flagForSpliting] = calculateLocalProp (fileName, parameters, geometryType, maxCompartmentLength);

                properties.(str).('numOfSegments') = numOfSegments;
                properties.(str).('data').('local') = localData;


                if flagForSpliting
                    str = sprintf('MNS: there are compartments larger than %d um in mn %s..\n They were splited to improve model convergence', maxCompartmentLength, str);
                    msgbox(str);
                end

            end

        end

    end

end