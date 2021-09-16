
function properties = processDendTrees(parameters, properties)

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
                display(sprintf('Processing dendritic trees: %s', str));
                display('.................');
                
                radius = properties.(str).('data').('local').('radius');
                area = properties.(str).('data').('local').('area');


                [properties.(str).('data').('branchLevel'), properties.(str).('data').('treeLevel'),...
                    zeroOrderSegments, properties.(str).('data').('local').segmentsFromUnbranchedSubTrees] = getTreeProperties2 (properties.(str), parameters);

                properties.(str).('data').('zeroOrderSegments') = zeroOrderSegments;


                % Obtaining zero order stem dendrite diameters and areas
                
                diameterStemDendrites = [];
                areaStemDendrites = [];
                
                for k = 1:length(zeroOrderSegments)
                    diameterStemDendrites = [diameterStemDendrites; radius(k)];
                    areaStemDendrites = [areaStemDendrites; area(k)];
                end
                properties.(str).('data').('dendriticTree').('areaStemDendrites').('raw') = areaStemDendrites;
                properties.(str).('data').('dendriticTree').('diameterStemDendrites').('raw') = diameterStemDendrites;

            end

        end

    end

end

        

