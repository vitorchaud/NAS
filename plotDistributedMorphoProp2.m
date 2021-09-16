

function [cellarrayOfGroupNames] = plotDistributedMorphoProp2 (graphicType, mns, mnName_cellarray, propertyName, propertyCategory, somatofugalParams, cmap_struct, cmap_array, isGrouping, varargin)
    
    groupType = varargin{1};
    
    step = somatofugalParams.('step');
    finalDistance = somatofugalParams.('finalDistance');
    metric = somatofugalParams.('metric');
    
        
    d = 0:step:finalDistance;
    
    
    if strcmp(graphicType, 'propertyRange')
        
        for i = 1:length(mnName_cellarray)
            modelName = char(mnName_cellarray(i));
            groupName = mns.(modelName).(groupType);
            groupNames_cellarray(i) = cellstr(groupName);
        end
        groupNames_cellarray = eliminateRepetitiveStringsFromCellarray(groupNames_cellarray);
        
        
        for j = 1:length(groupNames_cellarray)
            groupName = char(groupNames_cellarray(j));
            groupedProp = mergePropByGroup(mns, mnName_cellarray, metric, propertyName, groupType, groupName);
            [x, y1, y2] = getMinMaxGroupedProp(d, groupedProp, metric);
            
            if strcmp(groupType, 'name')
                h = fill_between_lines(x', y2', y1', cmap_array(j,:));
                set(h, 'EdgeColor', cmap_struct.(groupName), 'FaceAlpha', 0.1, 'LineWidth', 3, 'EdgeAlpha', 0.5);
            else
                h = fill_between_lines(x', y2', y1', cmap_struct.(groupName));
                set(h, 'EdgeColor', cmap_struct.(groupName), 'FaceAlpha', 0.1, 'LineWidth', 3, 'EdgeAlpha', 0.5);
            end
            
            hold on;
        end
        
    elseif strcmp(graphicType, 'stairs')
        
        
    elseif strcmp(graphicType, 'raw')
        
        for i = 1:length(mnName_cellarray)
            modelName = char(mnName_cellarray(i));
            groupName = mns.(modelName).(groupType);
            groupNames_cellarray(i) = cellstr(groupName);
        end
        groupNames_cellarray = eliminateRepetitiveStringsFromCellarray(groupNames_cellarray);
        
        xg = [];
        yg = [];
        g = {};
        cmap = [];
        for j = 1:length(groupNames_cellarray)
            groupName = char(groupNames_cellarray(j));
            groupedProp = mergePropByGroup(mns, mnName_cellarray, metric, propertyName, groupType, groupName);
            [x, y] = getRawGroupedProp(d, groupedProp, metric);
            xg = [xg; x];
            yg = [yg; y];
            for k = 1:length(x)
                g = [g; groupName];
            end
            if ~strcmp(groupType, 'name')
                cmap = [cmap; cmap_struct.(groupName)];
            end
            
        end
        if strcmp(groupType, 'name')
            h = gscatter(xg, yg, g, cmap_array, '.', 9, true);
        else
            h = gscatter(xg, yg, g, cmap, '.', 9, true);
        end
        
        
        
    elseif strcmp(graphicType, 'errorbar')
        
        for i = 1:length(mnName_cellarray)
            modelName = char(mnName_cellarray(i));
            groupName = mns.(modelName).(groupType);
            groupNames_cellarray(i) = cellstr(groupName);
        end
        groupNames_cellarray = eliminateRepetitiveStringsFromCellarray(groupNames_cellarray);
        
        for j = 1:length(groupNames_cellarray)
            groupName = char(groupNames_cellarray(j));
            groupedProp = mergePropByGroup(mns, mnName_cellarray, metric, propertyName, groupType, groupName);
            [x, y1, y2] = getMeanStdGroupedProp(d, groupedProp, metric);
            h = errorbar(x, y1, y2,'.');
            if strcmp(groupType, 'name')
                set(h, 'MarkerSize', 15, 'Color', cmap_array(j,:));
            else
                set(h, 'MarkerSize', 15, 'Color', cmap_struct.(groupName));
            end
            
            hold on;
        end
        
        
    else
        error('MNS: Unknown graphic type');
    end
    
    cellarrayOfGroupNames = groupNames_cellarray;
end

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    