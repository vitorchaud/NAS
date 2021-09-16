
function labels = cumulativeAssignLabels(labels, name, species, lab, development, tertiaryCellClass, subType, partition)

    labels.('name') =               [labels.('name');           name];
    labels.('species') =            [labels.('species');        species];
    labels.('lab') =                [labels.('lab');            lab];
    labels.('development') =        [labels.('development');    development];
    labels.('tertiaryCellClass') =  [labels.('tertiaryCellClass'); tertiaryCellClass];
    labels.('subType') =            [labels.('subType');        subType];
    labels.('partition') =            [labels.('partition');        partition];
end