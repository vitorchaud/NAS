
function properties = processShollLikeAnalysis(parameters, properties)


    models_cellarray    = parameters.models_cellarray;
    mnFileNames_cellarray = parameters.mnFileNames_cellarray;
    process             = parameters.isProcess;
    somatofugalParams             = parameters.somatofugalParams;

    for i = 1:length(models_cellarray)
        modelName = char(models_cellarray(i));

        if process.(modelName)

            numOfproperties.(modelName) = length(mnFileNames_cellarray.(modelName));
            mnNames.(modelName) = cell(numOfproperties.(modelName),1);

            for j = 1:numOfproperties.(modelName)

                str = sprintf('%s%d', modelName, j);
                mnNames.(modelName)(j) = cellstr(str);
                display('.................');
                display(sprintf('Processing Sholl-like analysis: %s', str));
                display('.................');
                fileName = char(mnFileNames_cellarray.(modelName)(j));   

                properties.(str).('data').('somatofugal').('euclidian') = getSomatofugalProperties3 (properties.(str), parameters, 'euclidian', 0, 0);
                properties.(str).('data').('somatofugal').('path') = getSomatofugalProperties3 (properties.(str), parameters, 'path', 0, 0);
                properties.(str).('data').('somatofugal').('order') = getSomatofugalProperties3 (properties.(str), parameters, 'order', 0, 0);

            end

        end


    end

end