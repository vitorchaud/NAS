
function properties = processBranchLevel(parameters, properties)

    models_cellarray    = parameters.models_cellarray;
    mnFileNames_cellarray = parameters.mnFileNames_cellarray;
    process             = parameters.isProcess;


    for i = 1:length(models_cellarray)
        modelName = char(models_cellarray(i));

        if process.(modelName)

            numOfMNs.(modelName) = length(mnFileNames_cellarray.(modelName));

            for j = 1:numOfMNs.(modelName)

                str = sprintf('%s%d', modelName, j);
                display('.................');
                display(sprintf('Processing branch level: %s', str));
                display('.................');

                [properties.(str).('data').('branchLevel'), branchIndexes] = getBranchProperties (properties.(str));

                properties.(str).('data').('branchIndexes') = branchIndexes;


            end
        end
    end
end

        










